# muslim.nvim

<div style="text-align: right">السلام عليكم</div>

A plugin to get prayer times and useful islamic essentials inside neovim

![lualine-integration](./img/lualine-integration.png)

## ✨ Features

- complete offline calculation based on [Equation of Time](https://en.wikipedia.org/wiki/Equation_of_time) and [Declination of Sun](https://www.pveducation.org/pvcdrom/properties-of-sunlight/declination-angle)
- **E-Solat API support** - official JAKIM prayer times for Malaysia (46 zones)
- supports hanafi school of thought adjustments
- supported methods: MWL, ISNA, Egypt, Makkah, Karachi, Tehran, Jafari, France, Russia, Singapore.
- supports higher latitude adjustment
- lualine integration to display current waqt status

## 📦 Requirements

- Neovim >= 0.11
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [lualine](https://github.com/nvim-lualine/lualine.nvim) _(optional)_

## 🚀 Installation

Install the plugin with your preferred package manager

```lua
vim.pack.add({
    { url = "https://github.com/hardyweb/muslim.nvim" },
    { url = "https://github.com/nvim-lua/plenary.nvim" },
    -- OPTIONAL
    { url = "https://github.com/nvim-lualine/lualine.nvim" },
})
```

## ⚙️ Configuration

**`muslim.nvim`** comes with the following defaults:

```lua
{
    refresh     = 1,          -- Refresh interval in minutes to update prayer waqt times
    data_source = 'offline',  -- 'offline' or 'esolat' (Malaysia JAKIM)
    zone        = 'WLY01',    -- E-Solat zone code (for data_source = 'esolat')
    latitude    = nil,        -- MANDATORY for offline. Geolocation latitude
    longitude   = nil,        -- MANDATORY for offline. Geolocation longitude
    utc_offset  = 0,          -- Timezone offset from GMT (e.g., 8 for Malaysia)
    school      = 'hanafi',   -- School of thought: 'hanafi' or 'standard' (offline only)
    method      = 'MWL',      -- Calculation method (offline only)
}
```

### Data Sources

| Source | Description | Required Config |
|--------|-------------|-----------------|
| `offline` | Astronomical calculation (default) | `latitude`, `longitude`, `utc_offset` |
| `esolat` | JAKIM E-Solat API (Malaysia) | `zone` |

## 🚀 Setup

### Offline Mode (Worldwide)

```lua
local muslim = require("muslim")
muslim.setup({
    data_source = 'offline',
    latitude = 3.139,      -- Kuala Lumpur
    longitude = 101.6869,
    utc_offset = 8,        -- GMT+8
    school = 'hanafi',     -- optional: 'hanafi' or 'standard'
    method = 'MWL',        -- optional: MWL, ISNA, Egypt, Makkah, Karachi, Tehran, Jafari, France, Russia, Singapore
    refresh = 5
})
```

### E-Solat Mode (Malaysia)

```lua
local muslim = require("muslim")
muslim.setup({
    data_source = 'esolat',
    zone = 'WLY01',  -- Kuala Lumpur, Putrajaya
    refresh = 5
})
```

Use `:PrayerZones` to see all available Malaysia zone codes.

### Sample Coordinates

| Location | Latitude | Longitude | UTC Offset |
|----------|----------|-----------|------------|
| Kuala Lumpur, Malaysia | 3.139 | 101.6869 | 8 |
| Dhaka, Bangladesh | 23.8162 | 90.7966 | 6 |
| Jakarta, Indonesia | -6.2088 | 106.8456 | 7 |
| London, UK | 51.5074 | -0.1278 | 0 |
| New York, USA | 40.7128 | -74.0060 | -5 |

## 🧭 Commands

**`muslim.nvim`** supports the following user commands.

| Command | Description |
| -- | -- |
| `:PrayerTimes` | Returns a table with formatted waqt times for the day |
| `:PrayerZones` | Lists all E-Solat zone codes (Malaysia) |
| `:PrayerRefresh` | Refresh prayer times from data source |

### `:PrayerTimes` sample return value

```lua
{
  asr = "04:15 PM",
  dhuhr = "12:06 PM",
  fajr = "05:06 AM",
  isha = "07:03 PM",
  maghrib = "05:53 PM",
  midnight = "12:06 AM",
  sunrise = "06:21 AM",
  sunset = "05:52 PM"
}
```

## 🧰 Utility functions

| Function name | Description |
| -- | -- |
| `prayer_time`  | Returns a formatted text. Shows remaining time for current waqt (if valid) and start time of next waqt |
| `today_prayer_time_epochs` | Returns a table with all the waqt time _(in epochs)_ for the day |

These functions can be used to enhance the behavior of the plugin. For example, create a scheduler with `vim.schedule` and show the prayer time as a popup notification for certain warnings.

## 🧩 Integration with lualine

If you want the prayer times to appear in the statusline, you have to update your lualine configuration to add the following to the section of the lualine you want the text to be.

```lua
{ muslim.prayer_time, id = "muslim.nvim" }
```

### Simple lualine configuration

```lua
require("lualine").setup({
    sections = {
        lualine_c = { "filename", require("muslim").prayer_time },
    },
})
```

### 🎨 Full lualine configuration

To get something similar to the image above, the configuration can be as below:

```lua
require("lualine").setup({
    sections = {
        lualine_a = { { 'mode', icons_enabled = true, separator = { left = '' }, right_padding = 2 } },
        lualine_b = { { 'filename', path = 1 }, 'branch' },
        lualine_c = {
            { clients_lsp }
        },
        -- added muslim.nvim here
        lualine_x = { { 'datetime', style = 'default' }, { muslim.prayer_time, id = "muslim.nvim", color = { fg = colors.blue } } },
        lualine_y = { 'filetype', 'progress' },
        lualine_z = {
            { 'location', separator = { right = '' }, left_padding = 2 },
        },
    }
})
```
