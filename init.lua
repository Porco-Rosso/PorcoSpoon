-- ======================================= Reload on save
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")


-- ======================================= Define Hyper
local hyper = {"ctrl", "alt", "cmd"}

-- Caps lock is remapped in Karabiner elements to hyper on hold, alfred toggle (non-us-backslash) on hold
-- https://brettterpstra.com/2017/06/15/a-hyper-key-with-karabiner-elements-full-instructions/

-- ======================================= Generic hotkeys to replace BTT

-- Use ctrl + right/left to move spaces right or left
hs.hotkey.bind('ctrl', 'right', function()
    hs.eventtap.event.newKeyEvent(hs.keycodes.map.alt, true):post()
    hs.eventtap.event.newKeyEvent('right', true):post()
    hs.eventtap.event.newKeyEvent('right', false):post()
    hs.eventtap.event.newKeyEvent(hs.keycodes.map.alt, false):post()
end)

hs.hotkey.bind('ctrl', 'left', function()
    hs.eventtap.event.newKeyEvent(hs.keycodes.map.alt, true):post()
    hs.eventtap.event.newKeyEvent('left', true):post()
    hs.eventtap.event.newKeyEvent('left', false):post()
    hs.eventtap.event.newKeyEvent(hs.keycodes.map.alt, false):post()
end)

-- ======================================= Load Spoons and .lua files

--  // Window switcher
local switcher  = require('switcher')
-- Alt-B is bound to the switcher dialog for all apps.
-- Alt-shift-B is bound to the switcher dialog for the current app.
-- switcherfunc() cycles through all widows of the frontmost app.

--  // Rounded Corners
hs.loadSpoon("RoundedCorners")
spoon.RoundedCorners.radius = 8
spoon.RoundedCorners:start()

--  // Mirow Window Manager
hs.loadSpoon("MiroWindowsManager")

hs.window.animationDuration = 0.3
spoon.MiroWindowsManager:bindHotkeys({
  up = {hyper, "up"},
  right = {hyper, "right"},
  down = {hyper, "down"},
  left = {hyper, "left"},
  fullscreen = {hyper, "f"}
})

--  // Mic muter hotkey
hs.loadSpoon("MicMute")
spoon.MicMute:bindHotkeys({toggle = {{}, "pagedown"}})


--  // resize and move windows with mouse
local SkyRocket = hs.loadSpoon("SkyRocket")
sky = SkyRocket:new({
  -- Which modifiers to hold to move a window?
  moveModifiers = {'ctrl','shift'},

  -- Which modifiers to hold to resize a window?
  resizeModifiers = {'alt', 'shift'},
})

-- // Disabled spoons

-- hs.loadSpoon("ArrangeDesktop")
-- hs.loadSpoon("DeepLTranslate")
-- hs.loadSpoon("HSKeybindings")
-- hs.loadSpoon("Hotkeys")
-- hs.loadSpoon("KSheet")


-- ======================================= Switcher

--  function to either open apps or switch through them using switcher
function openswitch(name)
    return function()
        if hs.application.frontmostApplication():name() == name then
          switcherfunc()
        else
          hs.application.launchOrFocus(name)
        end
    end
end

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "O", openswitch("Finder"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "V", openswitch("Vivaldi"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "M", openswitch("Firefox"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "W", openswitch("Whatsapp"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "T", openswitch("Telegram"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "S", openswitch("Slack"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "N", openswitch("Notion"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Z", openswitch("zoom.us"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "A", openswitch("Microsoft Word"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "E", openswitch("Microsoft Excel"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "P", openswitch("Microsoft PowerPoint"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "C", openswitch("Calendar"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "A", openswitch("Anytype"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "D", openswitch("DeepL"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Q", openswitch("Preview"))

-- ======================================= Utilities
-- // disable window animations
hs.window.animationDuration = 0

-- ======================================= Automatic Tiling
-- local spaces = require('hs._asm.undocumented.spaces')
-- 
-- PaperWM = hs.loadSpoon("PaperWM")
-- PaperWM:bindHotkeys({
--     focus_left = { { "ctrl", "alt", "cmd" }, "h" },
--     focus_right = { { "ctrl", "alt", "cmd" }, "l" },
--     focus_up = { { "ctrl", "alt", "cmd" }, "k" },
--     focus_down = { { "ctrl", "alt", "cmd" }, "j" },
--     swap_left = { { "ctrl", "alt", "cmd", "shift" }, "h" },
--     swap_right = { { "ctrl", "alt", "cmd", "shift" }, "l" },
--     swap_up = { { "ctrl", "alt", "cmd", "shift" }, "k" },
--     swap_down = { { "ctrl", "alt", "cmd", "shift" }, "j" },
--     center_window = { { "ctrl", "alt", "cmd" }, "u" },
--     full_width = { { "ctrl", "alt", "cmd" }, "f" },
--     cycle_width = { { "ctrl", "alt", "cmd" }, "r" },
--     cycle_height = { { "ctrl", "alt", "cmd", "shift" }, "r" },
--     slurp_in = { { "ctrl", "alt", "cmd" }, "i" },
--     barf_out = { { "ctrl", "alt", "cmd" }, "o" },
--     switch_space_1 = { { "ctrl", "alt", "cmd" }, "1" },
--     switch_space_2 = { { "ctrl", "alt", "cmd" }, "2" },
--     switch_space_3 = { { "ctrl", "alt", "cmd" }, "3" },
--     switch_space_4 = { { "ctrl", "alt", "cmd" }, "4" },
--     switch_space_5 = { { "ctrl", "alt", "cmd" }, "5" },
--     switch_space_6 = { { "ctrl", "alt", "cmd" }, "6" },
--     switch_space_7 = { { "ctrl", "alt", "cmd" }, "7" },
--     switch_space_8 = { { "ctrl", "alt", "cmd" }, "8" },
--     switch_space_9 = { { "ctrl", "alt", "cmd" }, "9" },
--     move_window_1 = { { "ctrl", "alt", "cmd", "shift" }, "1" },
--     move_window_2 = { { "ctrl", "alt", "cmd", "shift" }, "2" },
--     move_window_3 = { { "ctrl", "alt", "cmd", "shift" }, "3" },
--     move_window_4 = { { "ctrl", "alt", "cmd", "shift" }, "4" },
--     move_window_5 = { { "ctrl", "alt", "cmd", "shift" }, "5" },
--     move_window_6 = { { "ctrl", "alt", "cmd", "shift" }, "6" },
--     move_window_7 = { { "ctrl", "alt", "cmd", "shift" }, "7" },
--     move_window_8 = { { "ctrl", "alt", "cmd", "shift" }, "8" },
--     move_window_9 = { { "ctrl", "alt", "cmd", "shift" }, "9" },
-- })
-- PaperWM:start()

