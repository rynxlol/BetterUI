# BetterUI
BetterUI can make a perfect UI panel for your small scripts, making it perfect for mods and admins without being the expert in UI design. You can also access the elements made by the script or add in your own UI elements.

### TL;DR
* Better for simple scripts
* Gives you more power/control

> [!WARNING]
> This script is currently in Beta. No other features are released yet. Basically only focus on 1 tab only.

## Getting Started
### Library
Load in the library to get started.
```lua
local betterUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/rynxlol/BetterUI/refs/heads/main/main.lua"))()
```
| Methods | Description |
| --- | --- |
| SetSize( Size: `UDim2` ) | Set the size of the panel. |
| SetName( Name: `string` ) | Give it a good name. It will show up on the top bar. |
| SetTabTransparency( Transparency: `number` ) | Set the transparency of the tabs. |
| CreateTab( TabName: `name` ) | Create the tab. These are where your content will be in. |
| Count() | Adds a number to the counter badge. Perfect for notifications. |

### Create a tab
This is where you will have everything in. A tab can be created with or without a name (for 1 tab only), just don't forget the quotes.
```lua
local tab = betterUI:CreateTab("Very Nice Commands")
```
| Methods | Description |
| --- | --- |
| GetSize() | Returns the tab size. |
| AddObject( `GuiObject` ) | Add in your UI object to the tab. |

## Elements
### Create a label
Add a nice text in the tab.
```lua
tab:CreateLabel("Commands")
```
### Create a button
Add a nice button.
```lua
tab:CreateButton("Click Me", function()
  print("This button has been clicked!")
end)
```
### Create a toggle
Add a nice toggle.
```lua
tab:CreateToggle("Toggle Me", function(value)
  if value then
    print("The toggle is ON!")
  else
    print("The toggle is OFF!")
  end
end)
```
### Create an input
The input elements only contain strings.
```lua
tab:CreateInput("Change Name", "c00lgui", function(value)
  betterUI:SetName(value)
end)
```
### Create a divider
Divide the elements.
```lua
tab:CreateDivider()
```
