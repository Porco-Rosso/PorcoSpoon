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
    -- hs.execute("/usr/local/bin/yabai -m space --focus next")
end)

hs.hotkey.bind('ctrl', 'left', function()
    hs.eventtap.event.newKeyEvent(hs.keycodes.map.alt, true):post()
    hs.eventtap.event.newKeyEvent('left', true):post()
    hs.eventtap.event.newKeyEvent('left', false):post()
    hs.eventtap.event.newKeyEvent(hs.keycodes.map.alt, false):post()
    -- hs.execute("/usr/local/bin/yabai -m space --focus prev")
end)

-- ======================================= Load Spoons and .lua files

--  // Window switcher
local switcher  = require('switcher')
-- Alt-B is bound to the switcher dialog for all apps.
-- Alt-shift-B is bound to the switcher dialog for the current app.

-- Hyper + "app key" launches/switches to the window of the app or cycles through its open windows if already focused
  -- switcherfunc() cycles through all widows of the frontmost app.
-- Hyper + tab cycles to the previously focused app.

--  // Rounded Corners
hs.loadSpoon("RoundedCorners")
spoon.RoundedCorners.radius = 8
spoon.RoundedCorners:start()

--  // Mirow Window Manager
hs.loadSpoon("MiroWindowsManager")
-- added top and bottom padding at the end of miro's window manager: hs.grid.MARGINY = 40

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
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "E", openswitch("Microsoft Excel"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "P", openswitch("Microsoft PowerPoint"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "C", openswitch("Calendar"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "A", openswitch("Anytype"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "D", openswitch("DeepL"))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Q", openswitch("Preview"))

-- ======================================= Utilities
-- // disable window animations
hs.window.animationDuration = 0

