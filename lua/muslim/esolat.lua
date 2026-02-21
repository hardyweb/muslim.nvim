local Job = require("plenary.job")
local zones = require("muslim.zones")

local M = {
    config = {
        zone = "WLY01",
        period = "today"
    },
    cached_times = nil,
    last_fetch_date = nil
}

local function time_to_epoch(time_str, date_offset)
    local h, m, s = time_str:match("(%d+):(%d+):(%d+)")
    if not h then
        h, m = time_str:match("(%d+):(%d+)")
        s = 0
    end
    if not h then return nil end

    local now = os.date("*t")
    local date = os.date("*t")
    if date_offset then
        date = os.date("*t", os.time() + date_offset * 86400)
    end

    local epoch = os.time({
        year = date.year,
        month = date.month,
        day = date.day,
        hour = tonumber(h),
        min = tonumber(m),
        sec = tonumber(s) or 0
    })

    return epoch * 1000
end

local function fetch_sync(zone, period)
    period = period or "today"
    local url = string.format(
        "%s&period=%s&zone=%s",
        zones.api_url,
        period,
        zone
    )

    local result = vim.fn.system(string.format("curl -s '%s'", url))

    local ok, data = pcall(vim.json.decode, result)
    if not ok or not data or not data.prayerTime or not data.prayerTime[1] then
        return nil
    end

    return data
end

local function fetch_async(zone, period, callback)
    period = period or "today"
    local url = string.format(
        "%s&period=%s&zone=%s",
        zones.api_url,
        period,
        zone
    )

    Job:new({
        command = "curl",
        args = { "-s", url },
        on_exit = function(j)
            local result = table.concat(j:result(), "\n")
            local ok, data = pcall(vim.json.decode, result)
            if not ok or not data or not data.prayerTime or not data.prayerTime[1] then
                callback(nil)
                return
            end
            callback(data)
        end,
    }):start()
end

local function parse_prayer_times(data)
    if not data or not data.prayerTime or not data.prayerTime[1] then
        return nil
    end

    local pt = data.prayerTime[1]
    local today = os.date("*t")
    local date_str = pt.date

    local times = {
        imsak = time_to_epoch(pt.imsak),
        fajr = time_to_epoch(pt.fajr),
        sunrise = time_to_epoch(pt.syuruk),
        dhuhr = time_to_epoch(pt.dhuhr),
        asr = time_to_epoch(pt.asr),
        maghrib = time_to_epoch(pt.maghrib),
        isha = time_to_epoch(pt.isha),
        midnight = nil
    }

    if times.maghrib then
        times.midnight = times.maghrib + (12 * 60 * 60 * 1000)
    end

    return times
end

M.setup = function(opts)
    opts = opts or {}
    if opts.zone then
        M.config.zone = opts.zone
    end
    if opts.period then
        M.config.period = opts.period
    end

    if not zones.is_valid_zone(M.config.zone) then
        vim.notify(string.format('[muslim.nvim] Invalid E-Solat zone: %s', M.config.zone), vim.log.levels.WARN)
        return false
    end

    return true
end

M.get_times = function()
    local today = os.date("%Y-%m-%d")

    if M.cached_times and M.last_fetch_date == today then
        return M.cached_times
    end

    local data = fetch_sync(M.config.zone, M.config.period)
    if not data then
        vim.notify('[muslim.nvim] Failed to fetch E-Solat data', vim.log.levels.ERROR)
        return nil
    end

    M.cached_times = parse_prayer_times(data)
    M.last_fetch_date = today

    return M.cached_times
end

M.get_times_async = function(callback)
    fetch_async(M.config.zone, M.config.period, function(data)
        if not data then
            callback(nil)
            return
        end
        local times = parse_prayer_times(data)
        M.cached_times = times
        M.last_fetch_date = os.date("%Y-%m-%d")
        callback(times)
    end)
end

M.get_current_waqt = function()
    local ONE_SECOND = 1 * 1000
    local ONE_DAY = 24 * 60 * 60 * ONE_SECOND
    local waqt_order = { 'fajr', 'dhuhr', 'asr', 'maghrib', 'isha' }
    local waqt_times = M.get_times()

    if not waqt_times then
        return nil
    end

    local cur_time = os.time() * 1000
    local cur_waqt_info = {}

    for i in ipairs(waqt_order) do
        local j = i + 1
        if (j > 5) then j = 1 end
        local waqt_start = waqt_times[waqt_order[i]]
        local next_waqt = waqt_times[waqt_order[j]]

        if (i == 1) then
            next_waqt = waqt_times['sunrise']
        end
        if (i == 5) then
            next_waqt = next_waqt + ONE_DAY
        end
        next_waqt = next_waqt - ONE_SECOND

        if cur_time >= waqt_start and cur_time <= next_waqt then
            cur_waqt_info = {
                waqt_name = waqt_order[i],
                time_left = next_waqt - cur_time,
                next_waqt_start = next_waqt,
                next_waqt_name = waqt_order[j]
            }
            break
        end
    end

    if next(cur_waqt_info) == nil then
        for i in ipairs(waqt_order) do
            local next_waqt = waqt_times[waqt_order[i]]
            next_waqt = next_waqt - ONE_SECOND

            if cur_time < next_waqt then
                cur_waqt_info = {
                    next_waqt_start = next_waqt,
                    next_waqt_name = waqt_order[i]
                }
                break
            end
        end
    end

    return cur_waqt_info
end

M.refresh = function()
    M.cached_times = nil
    M.last_fetch_date = nil
    return M.get_times()
end

return M
