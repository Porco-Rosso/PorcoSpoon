-- App vars
-- local browser   = hs.appfinder.appFromName("Google Chrome")
-- local iterm     = hs.appfinder.appFromName("iTerm2")
-- local subl      = hs.appfinder.appFromName("Sublime Text")
-- local phpstorm  = hs.appfinder.appFromName("PhpStorm")
-- local finder    = hs.appfinder.appFromName("Finder")
-- local slack     = hs.appfinder.appFromName("Slack")

-- Screens
local main_monitor = "DELL U2414H (1)"
local second_monitor = "DELL U2414H (2)"

-- real configuration
-------------------------------------------------------------------------------
-- variable config
-- hs.window.animationDuration = 0
-- hs.window.setShadows(false)

-- extensions, available in hammerspoon console
ext = {
  frame    = {},
  win      = {},
  app      = {},
  utils    = {},
  cache    = {},
  watchers = {}
}

local hyper = {"ctrl", "alt", "cmd"}

hs.fnutils.each({
  { key = "n", app = "Finder" },
  { key = "v", app = "Vivaldi" },
  { key = "m", app = "Firefox" },
  { key = "w", app = "Whatsapp" },
  { key = "t", app = "Telegram" },
  { key = "p", app = "Preview" }
}, function(object)
    hs.hotkey.bind(hyper, object.key, function() ext.app.forceLaunchOrFocus(object.app) end)
end)


-- functions below


-- https://github.com/szymonkaliski/Dotfiles/blob/b5a640336efc9fde1e8048c2894529427746076f/Dotfiles/hammerspoon/init.lua#L411-L440
function ext.app.forceLaunchOrFocus(appName)
  -- first focus with hammerspoon
  hs.application.launchOrFocus(appName)

  -- clear timer if exists
  if ext.cache.launchTimer then ext.cache.launchTimer:stop() end

  -- wait 500ms for window to appear and try hard to show the window
  ext.cache.launchTimer = hs.timer.doAfter(0.5, function()
    local frontmostApp     = hs.application.frontmostApplication()
    local frontmostWindows = hs.fnutils.filter(frontmostApp:allWindows(), function(win) return win:isStandard() end)

    -- break if this app is not frontmost (when/why?)
    if frontmostApp:title() ~= appName then
      print('Expected app in front: ' .. appName .. ' got: ' .. frontmostApp:title())
      return
    end

    if #frontmostWindows == 0 then
      -- check if there's app name in window menu (Calendar, Messages, etc...)
      if frontmostApp:findMenuItem({ 'Window', appName }) then
        -- select it, usually moves to space with this window
        frontmostApp:selectMenuItem({ 'Window', appName })
      else
        -- otherwise send cmd-n to create new window
        hs.eventtap.keyStroke({ 'cmd' }, 'n')
      end
    end
  end)
end


-- smart app launch or focus or cycle windows
function ext.app.smartLaunchOrFocus(launchApps)
  local frontmostWindow = hs.window.frontmostWindow()
  local runningApps     = hs.application.runningApplications()
  local runningWindows  = {}

  -- filter running applications by apps array
  local runningApps = hs.fnutils.map(launchApps, function(launchApp)
    return hs.application.get(launchApp)
  end)

  -- create table of sorted windows per application
  hs.fnutils.each(runningApps, function(runningApp)
    local standardWindows = hs.fnutils.filter(runningApp:allWindows(), function(win)
      return win:isStandard()
    end)

    table.sort(standardWindows, function(a, b) return a:id() < b:id() end)

    runningWindows = standardWindows
  end)

  if #runningApps == 0 then
    -- if no apps are running then launch first one in list
    ext.app.forceLaunchOrFocus(launchApps[1])
  elseif #runningWindows == 0 then
    -- if some apps are running, but no windows - force create one
    ext.app.forceLaunchOrFocus(runningApps[1]:title())
  else
    -- check if one of windows is already focused
    local currentIndex = hs.fnutils.indexOf(runningWindows, frontmostWindow)

    if not currentIndex then
      -- if none of them is selected focus the first one
      runningWindows[1]:focus()
    else
      -- otherwise cycle through all the windows
      local newIndex = currentIndex + 1
      if newIndex > #runningWindows then newIndex = 1 end

      runningWindows[newIndex]:focus()
    end
  end
end

--------------------------------------------------------------------------------
-- METHODS - BECAREFUL :)
--------------------------------------------------------------------------------
function applyLayout(layouts, app)
  if (app) then
    local appName = app:title()

    for i, layout in ipairs(layouts) do
      if (type(layout.name) == "table") then
        for i, layAppName in ipairs(layout.name) do
          if (layAppName == appName) then
            hs.alert.show(appName)

            local wins = app:allWindows()
            local counter = 1
            for j, win in ipairs(wins) do
              if (win:isVisible() and layout.func) then
                layout.func(counter, win)
                counter = counter + 1
              end
            end
          end
        end
      elseif (type(layout.name) == "string") then
        if (layout.name == appName) then
          local wins = app:allWindows()
          local counter = 1
          for j, win in ipairs(wins) do
            if (win:isVisible() and layout.func) then
              layout.func(counter, win)
              counter = counter + 1
            end
          end
        end
      end
    end
  end
end

function applyLayouts(layouts)

  for i, layout in ipairs(layouts) do
    if (type(layout.name) == "table") then
      --hs.alert.show("Applying Layout in table")
      for i, appName in ipairs(layout.name) do
        --print("Applying Layout in table i -> " .. i)
        --print("Applying Layout in table appName -> " .. appName)
        -- focus or launch
        ext.app.forceLaunchOrFocus(appName)
        local app = hs.application.find(appName)

        if (app) then
          local wins = app:allWindows()
          local counter = 1
          for j, win in ipairs(wins) do
            if (win:isVisible() and layout.func) then
              layout.func(counter, win)
              counter = counter + 1
            end
          end
        end
      end
    elseif (type(layout.name) == "string") then
      --hs.alert.show("Applying Layout in string")
      ext.app.forceLaunchOrFocus(appName)
      local app = hs.appfinder.appFromName(layout.name)
      if (app) then
        local wins = app:allWindows()
        local counter = 1
        for j, win in ipairs(wins) do
          if (win:isVisible() and layout.func) then
            layout.func(counter, win)
            counter = counter + 1
          end
        end
      end
    end
  end
end

function hs.screen.get(screen_name)
  local allScreens = hs.screen.allScreens()
  for i, screen in ipairs(allScreens) do
    if screen:name() == screen_name then
      return screen
    end
  end
end

-- Returns the width of the smaller screen size
-- isFullscreen = false removes the toolbar
-- and dock sizes
function hs.screen.minWidth(isFullscreen)
  local min_width = math.maxinteger
  local allScreens = hs.screen.allScreens()
  for i, screen in ipairs(allScreens) do
    local screen_frame = screen:frame()
    if (isFullscreen) then
      screen_frame = screen:fullFrame()
    end
    min_width = math.min(min_width, screen_frame.w)
  end
  return min_width
end

-- isFullscreen = false removes the toolbar
-- and dock sizes
-- Returns the height of the smaller screen size
function hs.screen.minHeight(isFullscreen)
  local min_height = math.maxinteger
  local allScreens = hs.screen.allScreens()
  for i, screen in ipairs(allScreens) do
    local screen_frame = screen:frame()
    if (isFullscreen) then
      screen_frame = screen:fullFrame()
    end
    min_height = math.min(min_height, screen_frame.h)
  end
  return min_height
end

-- If you are using more than one monitor, returns X
-- considering the reference screen minus smaller screen
-- = (MAX_REFSCREEN_WIDTH - MIN_AVAILABLE_WIDTH) / 2
-- If using only one monitor, returns the X of ref screen
function hs.screen.minX(refScreen)
  local min_x = refScreen:frame().x
  local allScreens = hs.screen.allScreens()
  if (#allScreens > 1) then
    min_x = refScreen:frame().x + ((refScreen:frame().w - hs.screen.minWidth()) / 2)
  end
  return min_x
end

-- If you are using more than one monitor, returns Y
-- considering the focused screen minus smaller screen
-- = (MAX_REFSCREEN_HEIGHT - MIN_AVAILABLE_HEIGHT) / 2
-- If using only one monitor, returns the Y of focused screen
function hs.screen.minY(refScreen)
  local min_y = refScreen:frame().y
  local allScreens = hs.screen.allScreens()
  if (#allScreens > 1) then
    min_y = refScreen:frame().y + ((refScreen:frame().h - hs.screen.minHeight()) / 2)
  end
  return min_y
end

-- If you are using more than one monitor, returns the
-- half of minX and 0
-- = ((MAX_REFSCREEN_WIDTH - MIN_AVAILABLE_WIDTH) / 2) / 2
-- If using only one monitor, returns the X of ref screen
function hs.screen.almostMinX(refScreen)
  local min_x = refScreen:frame().x
  local allScreens = hs.screen.allScreens()
  if (#allScreens > 1) then
    min_x = refScreen:frame().x + (((refScreen:frame().w - hs.screen.minWidth()) / 2) - ((refScreen:frame().w - hs.screen.minWidth()) / 4))
  end
  return min_x
end

-- If you are using more than one monitor, returns the
-- half of minY and 0
-- = ((MAX_REFSCREEN_HEIGHT - MIN_AVAILABLE_HEIGHT) / 2) / 2
-- If using only one monitor, returns the Y of ref screen
function hs.screen.almostMinY(refScreen)
  local min_y = refScreen:frame().y
  local allScreens = hs.screen.allScreens()
  if (#allScreens > 1) then
    min_y = refScreen:frame().y + (((refScreen:frame().h - hs.screen.minHeight()) / 2) - ((refScreen:frame().h - hs.screen.minHeight()) / 4))
  end
  return min_y
end

-- Returns the frame of the smaller available screen
-- considering the context of refScreen
-- isFullscreen = false removes the toolbar
-- and dock sizes
function hs.screen.minFrame(refScreen, isFullscreen)
  return {
    x = hs.screen.minX(refScreen),
    y = hs.screen.minY(refScreen),
    w = hs.screen.minWidth(isFullscreen),
    h = hs.screen.minHeight(isFullscreen)
  }
end
