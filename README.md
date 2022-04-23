# PorcoSpoon - My Versatile Hammerspoon Config

After having discovered the extremely powerful [Hammerspoon](http://www.hammerspoon.org/) app, and finally landing on a configuration that I am very happy with, I thought I should share it with others to enjoy. I've tried to comment `init.lua` to make it easier to understand.

I use this config together with some [Karabiner](https://karabiner-elements.pqrs.org) remapping to achieve a fast and usable config with a short learning curve.

# Features

- Reload on Save
- Hyper Key
- Additional hotkeys to switch spaces
- Window Switcher menu
- **Quick per-application window switcher (Across spaces!)**
- Rounded screen corners
- MiroWindowManager with reduced animation times
- Universal Mic muter with hotkey
- Drag to resize and move windows
- App launcher
- ... Some additional Spoons that are currently disabled


# Additional details and usage

## Hyper and hotkeys

Hyper is what people like to call a special shortcut comprised of multiple modifier keys. In this case the hyper key is the following:

Hyper = <kbd>ctrl</kbd>+<kbd>alt</kbd>+<kbd>cmd</kbd>

### Karabiner configuration
I've used [Karabiner](https://karabiner-elements.pqrs.org) and the default mac hotkey settings to remap the useless <kbd>capslock</kbd> key into something extremely powerful. If you tap <kbd>capslock</kbd>, it triggers "non_us_backslash" (what even is that?) which I have remapped to open spotlight or Alfred. Hold it and it acts like the hyper modifier. Perfect.

### Launcher
I use <kbd>Hyper</kbd> + `<key>` to either launch or switch to certain applications. This is easily configured in the init.lua file so feel free to modify it for your own use. 

examples:

- <kbd>Hyper</kbd>+<kbd>V</kbd> = Launch or switch to Vivaldi
- <kbd>Hyper</kbd>+<kbd>S</kbd> = Launch or switch to Slack
- <kbd>Hyper</kbd>+<kbd>C</kbd> = Launch or switch to Calendar
- <kbd>Hyper</kbd>+<kbd>E</kbd> = Launch or switch to Excel
... you get the idea

### App Switcher

Many other configs online have similar features, but what is unique about this config is that if the app is already focused and you hit the key combination again, focus will cycle through the open windows of the current application. This works across spaces, and is really great when you have a bunch of windows open at the same time.

I've also remapped <kbd>right ctrl</kbd>+<kbd>right</kbd>/<kbd>left</kbd> to switch spaces left and right.

## App Switcher
Thanks to the help of [dmgerman](https://github.com/dmgerman) who's code allowed me to implement my app switcher, I've also maintained his app switcher menu.

- <kbd>alt</kbd>+<kbd>b</kbd> opens a switcher dialogue for all open windows
- <kbd>alt</kbd>+<kbd>shift</kbd>+<kbd>b</kbd> opens a switcher dialogue for all open windows for the current app
- <kbd>hyper</kbd>+<kbd>tab</kbd> switches to the last focused window

## MiroWindowsManager

[MiroWindowsManager](https://github.com/miromannino/miro-windows-manager) is a great spoon to maneuver windows in a convenient fashion. Maybe one day I will graduate to a tiling window manger, but for now dragging a window to the sides will make it take up that half of the screen. Dragging to the top makes it take up the whole screen.

MiroWindowsManager also has some hotkeys mapped to it.
I use the following:

- <kbd>Hyper</kbd>+<kbd>up</kbd> = Resize the window to take up the top half of the screen
- <kbd>Hyper</kbd>+<kbd>down</kbd> = Resize the window to take up the bottom half of the screen
- <kbd>Hyper</kbd>+<kbd>right</kbd> = Resize the window to take up the right half of the screen
- <kbd>Hyper</kbd>+<kbd>left</kbd> = Resize the window to take up the left half of the screen
- <kbd>Hyper</kbd>+<kbd>f</kbd> = Resize the window to take up the whole screen

Tapping the respective keys again does extra things, best to head to [MiroWindowsManager](https://github.com/miromannino/miro-windows-manager) page to learn more.

![example](https://github.com/miromannino/miro-windows-manager/raw/imgs/example.gif)

## Skyrocket

The [Skyrocket Spoon](https://github.com/dbalatero/SkyRocket.spoon) allows to resize and move windows conveniently without having to grab a window by the corner of window decoration.

In my config:
- <kbd>ctrl</kbd>+<kbd>shift</kbd> allows you to move a window with the mouse
- <kbd>alt</kbd>+<kbd>shift</kbd> allows you to resize a window with the mouse.


## Micmute

Here, I used the [Micmute Spoon](https://www.hammerspoon.org/Spoons/MicMute.html) and mapped it to <kbd>Pagedown</kbd>. I never use the key and it sits on the corner of my keyboard, so it is a convenient way for me to toggle the microphone on and off when on Zoom calls. A menubar icon will display the status, but you might have to hit it a few times for it to sync up with the current state.

## Rounded corners

Just the [RoundedCorners Spoon](https://www.hammerspoon.org/Spoons/RoundedCorners.html). I think it looks nice. feel free to disable to get those pixels back. Might cause burn in if you have an OLED panel, so be careful.

## Disabled Spoons

I have some extra Spoons in my repo, but I am not actively using them so they are disabled in the `init.lua`. Feel free to delete them.

# Install

- Install [Hammerspoon](https://www.hammerspoon.org/)
- copy the contents of this repo into you `~/.hammerspoon` folder
- Reload the config

### Karabiner config

To get capslock to work as described above I followed [the following guide](https://brettterpstra.com/2017/06/15/a-hyper-key-with-karabiner-elements-full-instructions/) with some modifications.

Insert the following into your '~/.config/karabiner/karabiner.json' file. Watch out for closing brackets and comments! Reload the config to activate.

```
"complex_modifications": {
"parameters": {
	"basic.simultaneous_threshold_milliseconds": 50,
	"basic.to_delayed_action_delay_milliseconds": 500,
	"basic.to_if_alone_timeout_milliseconds": 1000,
	"basic.to_if_held_down_threshold_milliseconds": 500,
	"mouse_motion_to_scroll.speed": 100
},
"rules": [
	{
		"manipulators": [
			{
				"description": "Change caps_lock to command+control+option.",
				"from": {
					"key_code": "caps_lock",
					"modifiers": {
						"optional": [
							"any"
						]
					}
				},
				"to": [
					{
						"key_code": "left_control",
						"modifiers": [
							"left_command",
							"left_option"
						]
					}
				],
				"to_if_alone": [
					{
						"key_code": "non_us_backslash"
					}
				],
				"type": "basic"
			}
		]
	},
	},
	
```

### Spotlight/Alfred hotkey remap
Next, open up the settings app > keyboard > Shortcuts, and then remap spotlight by clicking the current shortcut and tapping capslock. If you prefer [Alfred](https://www.alfredapp.com), remap that in the app settings instead.
