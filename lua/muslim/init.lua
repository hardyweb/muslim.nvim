local M = {
    config = {
        refresh     = 1,
        data_source = 'offline',
        zone        = 'WLY01',
        latitude    = nil,
        longitude   = nil,
        utc_offset  = 0,
        school      = 'hanafi',
        method      = 'MWL',
    },
    prayer_time_text = 'Please wait...',
}



M.setup = function(opts)
    if not pcall(require, 'plenary') then
        vim.notify('[muslim.nvim] please install plenary.nvim', vim.log.levels.WARN)
        return
    end
    if not pcall(require, 'lualine') then
        vim.notify('[muslim.nvim] did not find lualine. only user_commands will be available', vim.log.levels.WARN)
    end

    opts = opts or {}
    for k, v in pairs(opts) do M.config[k] = v end

    if M.config.data_source == 'esolat' then
        local zones = require("muslim.zones")
        if not zones.is_valid_zone(M.config.zone) then
            vim.notify(string.format('[muslim.nvim] Invalid E-Solat zone: %s', M.config.zone), vim.log.levels.WARN)
            return
        end
        M.prayer_module = require("muslim.esolat")
        M.prayer_module.setup({ zone = M.config.zone })
        M.config.utc_offset = M.config.utc_offset or 8
    else
        if not M.config.latitude or not M.config.longitude or not M.config.utc_offset then
            vim.notify('[muslim.nvim] please set latitude, longitude and utc_offset for offline calculation', vim.log.levels.WARN)
            return
        end
        M.prayer_module = require("muslim.prayer_calc")
        M.prayer_module.setup({
            location = {
                lat = M.config.latitude,
                lng = M.config.longitude,
            },
            utc_offset = M.config.utc_offset,
            asr = M.config.school,
            method = M.config.method
        })
    end

    M.update()

    local timer = vim.loop.new_timer()
    timer:start(
        M.config.refresh * 60 * 1000,
        M.config.refresh * 60 * 1000,
        function()
            M.update()
        end
    )
end

M.update = function()
    local format = require("muslim.utils").format
    M.prayer_time_text = 'Updating prayer times...'

    local current_waqt = M.prayer_module.get_current_waqt()

    M.prayer_time_text = format(current_waqt, M.config.utc_offset)

    -- update lualine if available
    vim.schedule(function()
        M.update_lualine(current_waqt)
    end)
end

M.prayer_time = function()
    return M.prayer_time_text
end

M.today_prayer_time_epochs = function()
    return M.prayer_module.get_times()
end

M.update_lualine = function(current_waqt)
    if not pcall(require, 'lualine') then
        return
    end
    local get_warning_level = require("muslim.utils").get_warning_level
    pcall(function()
        local sections = require("lualine").get_config().sections
        for col, info in pairs(sections) do
            for idx in ipairs(info) do
                local section = info[idx]
                if (section.id == 'muslim.nvim') then
                    section.color = get_warning_level(current_waqt)
                end
            end
        end
        require('lualine').setup({
            sections = sections
        })
        require("lualine").refresh {
            place = { "statusline", "tabline", "winbar" }
        }
    end)

    -- Force actual redraw (fixes async updates)
    vim.cmd("redrawstatus!")
end

vim.api.nvim_create_user_command("PrayerTimes", function()
    local times = M.prayer_module.get_times()
    if not times then
        vim.notify('[muslim.nvim] Could not fetch prayer times', vim.log.levels.ERROR)
        return
    end
    local formatted = {}
    for k, v in pairs(times) do
        formatted[k] = require("muslim.utils").format_time(v, M.config.utc_offset * 60, "12H")
    end
    vim.print(formatted)
    return formatted
end, {})

vim.api.nvim_create_user_command("PrayerZones", function()
    local zones = require("muslim.zones")
    local zone_list = {}
    for _, group in ipairs(zones.zones) do
        table.insert(zone_list, string.format("=== %s ===", group.group))
        for _, option in ipairs(group.options) do
            table.insert(zone_list, string.format("  %s", option.text))
        end
    end
    vim.print(zone_list)
end, {})

vim.api.nvim_create_user_command("PrayerRefresh", function()
    if M.prayer_module and M.prayer_module.refresh then
        M.prayer_module.refresh()
        M.update()
        vim.notify('[muslim.nvim] Prayer times refreshed', vim.log.levels.INFO)
    end
end, {})

return M
