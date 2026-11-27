-- COPY THIS: loadstring(game:HttpGet("https://raw.githubusercontent.com/rynxlol/BetterUI/refs/heads/main/main.lua"))()
-- BetterUI by Rynx

local runService = game:GetService("RunService")
local players = game:GetService("Players")
local tweenService = game:GetService("TweenService")

local player = game.Players.LocalPlayer
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

-- BetterUI Module (1/2)

local betterUI = {}
betterUI.TabTransparency = 0
betterUI.Tabs = {}
betterUI.Counts = 0

-- Some executors can run server-side. This is a client-side script.
if not runService:IsClient() then
    error("The BetterUI script can only run on client.")
    return
end

-- GUI

local guiParent = runService:IsStudio() and player.PlayerGui or game.CoreGui

local gui = Instance.new("ScreenGui", guiParent)
gui.Name = "BetterUI_" .. math.random(1000, 9999)
gui.IgnoreGuiInset = true

local frameSize = UDim2.new(0, 400, 0, 300)

local frame = Instance.new("Frame", gui)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.Size = frameSize
frame.Position = UDim2.new(0.5, 0, 0.5, 0)

local frameUICorner = Instance.new("UICorner", frame)

local frameUIShadow = Instance.new("UIShadow", frame)
frameUIShadow.BlurRadius = UDim.new(0, 20)
frameUIShadow.Transparency = 0.5

local function tween(obj, goal)
    local tween = tweenService:Create(obj, tweenInfo, goal)
    tween:Play()
end

local frameUIDrag = Instance.new("UIDragDetector", frame)
frameUIDrag.DragStart:Connect(function() tween(frameUIShadow, {Transparency = 0.25}) end)
frameUIDrag.DragEnd:Connect(function() tween(frameUIShadow, {Transparency = 0.5}) end)

local subtraction = 20

local function calculateMainSize(size: UDim2)
    local xOffset = size.X.Offset
    local yOffset = size.Y.Offset
    
    return UDim2.new(0, xOffset - subtraction, 0, yOffset - subtraction)
end

-- Instance creator with modified properties

local function createInstance(className: string, parent: Instance)
    local guiObject: TextLabel = Instance.new(className, parent)
    
    if className:find("Text") then
        -- Text Objects
        guiObject.RichText = true
        guiObject.TextColor3 = Color3.new(1, 1, 1)
        guiObject.TextSize = 12
    end
    
    guiObject.BackgroundTransparency = 1
    guiObject.BorderSizePixel = 0
    
    return guiObject
end

local counterBadge = createInstance("TextLabel", frame)
counterBadge.AnchorPoint = Vector2.new(0.5, 0.5)
counterBadge.Name = "NotificationBadge"
counterBadge.BackgroundColor3 = Color3.new(1, 0, 0)
counterBadge.BackgroundTransparency = 0
counterBadge.Size = UDim2.new(0, 20, 0, 20)
counterBadge.Visible = false
counterBadge.Text = ""
counterBadge.TextSize = 8

local badgeUICorner = Instance.new("UICorner", counterBadge)
badgeUICorner.CornerRadius = UDim.new(1, 0)

local mainSize = calculateMainSize(frame.Size)

local main: Frame = createInstance("Frame", frame)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Name = "Main"
main.Size = mainSize
main.Position = UDim2.new(0.5, 0, 0.5, 0)

local topBar: Frame = createInstance("Frame", main)
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 25)

local titleLabel: TextLabel = createInstance("TextLabel", topBar)
titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
titleLabel.Text = "Untitled UI"

local contentsSizeY = topBar.Size.Y.Offset + 8

local contents: Frame = createInstance("Frame", main)
contents.Name = "Contents"
contents.Size = UDim2.new(1, 0, 0, main.Size.Y.Offset - contentsSizeY)
contents.Position = UDim2.new(0, 0, 0, contentsSizeY)

local minimized = false

local minimizeButton: TextButton = createInstance("TextButton", topBar)
minimizeButton.Size = UDim2.new(0.1, 0, 1, 0)
minimizeButton.Position = UDim2.new(0.8, 0, 0, 0)
minimizeButton.Text = "-"
minimizeButton.TextSize = 14
minimizeButton.MouseButton1Click:Connect(function()
    betterUI.Minimized = not betterUI.Minimized
    if betterUI.Minimized then
        local yOffset = topBar.Size.Y.Offset + subtraction
        
        minimizeButton.Text = "+"
        contents.Visible = false
        
        tween(frame, {Size = UDim2.new(0, frameSize.X.Offset, 0, yOffset)})
        tween(main, {Size = UDim2.new(0, main.Size.X.Offset, 0, topBar.Size.Y.Offset)})
    else
        minimizeButton.Text = "-"
        
        tween(frame, {Size = frameSize})
        tween(main, {Size = mainSize})
        
        task.wait(0.25)
        
        contents.Visible = true
        if counterBadge.Visible then counterBadge.Visible = false end
        betterUI.Counts = 0
    end
end)

local closeButton: TextButton = createInstance("TextButton", topBar)
closeButton.Size = UDim2.new(0.1, 0, 1, 0)
closeButton.Position = UDim2.new(0.9, 0, 0, 0)
closeButton.Text = "x"
closeButton.TextSize = 14
closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- BetterUI Module (2/2)

function betterUI:SetSize(size: UDim2)
    if not size then
        error("Please provide a size.")
        return
    end
    
    if typeof(size) ~= "UDim2" then
        error("The size must be in UDim2.")
        return
    end
    
    frameSize = size
    frame.Size = frameSize
    
    mainSize = calculateMainSize(frameSize)
    main.Size = mainSize
end

function betterUI:SetName(name: string)
    if not name then
        error("Please provide a name.")
        return
    end
    
    if typeof(name) ~= "string" then
        error("The name must be a string. Add quotes around it.")
        return
    end
    
    titleLabel.Text = name
end

-- For the counter badge

function betterUI:Count()
    self.Counts += 1
    
    if self.Counts <= 0 then return end
    if not self.Minimized then return end
    if not counterBadge.Visible then counterBadge.Visible = true end
    
    local text = self.Counts <= 9 and self.Counts or "9+"

    counterBadge.Text = `<b>{text}</b>`
end

-- Creates a tab

function betterUI:CreateTab(tabName: string)
    if not tabName then
        error("A tab name is needed. It can just be a blank string.")
        return
    end
    
    if table.find(self.Tabs, tabName) then
        error(`The tab '{tabName}' already exists.`)
        return
    end
    
    local tabContent: ScrollingFrame = createInstance("ScrollingFrame", contents)
    tabContent.Name = tabName .. "_Content"
    tabContent.BackgroundTransparency = self.TabTransparency
    tabContent.BackgroundColor3 = Color3.new(0, 0, 0)
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.CanvasSize = UDim2.new(0.95, 0, 0, 0)
    
    local tabUICorner = Instance.new("UICorner", tabContent)
    tabUICorner.CornerRadius = UDim.new(0, 6)
    
    local tabUIList = Instance.new("UIListLayout", tabContent)
    tabUIList.Padding = UDim.new(0, 10)
    tabUIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local function updateTabSize(element: GuiObject)
        local elementYOffset = element.Size.Y.Offset
        local paddingOffset = tabUIList.Padding.Offset
        
        tabContent.CanvasSize += UDim2.new(0, 0, 0, elementYOffset + paddingOffset)
    end
    
    local tab = {}
    
    -- Creating a label element
    
    function tab:CreateLabel(labelText: string)
        if not labelText then
            error("A text is needed for this label.")
            return
        end
        
        local label = createInstance("TextLabel", tabContent)
        label.Name = #tabContent:GetChildren() .. " Label"
        label.Size = UDim2.new(1, 0, 0, 30)
        label.Text = labelText
        label.TextYAlignment = Enum.TextYAlignment.Bottom
        
        updateTabSize(label)
        
        return label
    end
    
    -- Creating a button element
    
    function tab:CreateButton(buttonName: string, clickFunc)
        if not buttonName then
            error("A name is needed for this button.")
            return
        end
        
        if not clickFunc then
            error("A function is needed for this button.")
            return
        end
        
        if type(clickFunc) ~= "function" then
            error("The second argument must be a function.")
            return
        end
        
        local button = createInstance("TextButton", tabContent)
        button.Name = #tabContent:GetChildren() .. " Button"
        button.BackgroundTransparency = 0
        button.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
        button.Size = UDim2.new(0.95, 0, 0, 35)
        button.MouseButton1Click:Connect(clickFunc)
        
        local buttonUICorner = Instance.new("UICorner", button)
        
        local buttonUIShadow = Instance.new("UIShadow", button)
        buttonUIShadow.BlurRadius = UDim.new(0, 10)
        buttonUIShadow.Transparency = 0.75
        
        updateTabSize(button)
        
        return button
    end
    
    -- Creating a toggle element
    
    function tab:CreateToggle(toggleName: string, toggleFunc)
        if not toggleName then
            error("A name is required for this toggle element.")
            return
        end
        
        if not toggleFunc then
            error("A function is required when toggling.")
            return
        end
        
        if type(toggleFunc) ~= "function" then
            error("The second argument must be a function.")
            return
        end
        
        local toggleValue = false
        
        local toggleContainer = createInstance("Frame", tabContent)
        toggleContainer.Name = #tabContent:GetChildren() .. " Toggle"
        toggleContainer.Size = UDim2.new(1, 0, 0, 35)
        
        local toggleLabel = createInstance("TextLabel", toggleContainer)
        toggleLabel.Name = "Label"
        toggleLabel.Size = UDim2.new(0.5, 0, 1, 0)
        toggleLabel.Position = UDim2.new(0.025, 0, 0, 0)
        toggleLabel.Text = toggleName
        
        local DEFAULT_PRIMARY_COLOR = Color3.new(1, 0.2, 0.2)
        local DEFAULT_SEC_COLOR = Color3.new(0.2, 0, 0)
        
        local buttonContainer = createInstance("Frame", toggleContainer)
        buttonContainer.Name = "ButtonContainer"
        buttonContainer.Size = UDim2.new(0.425, 0, 1, 0)
        buttonContainer.Position = UDim2.new(0.55, 0, 0, 0)
        
        local toggleButton = createInstance("TextButton", buttonContainer)
        toggleButton.AnchorPoint = Vector2.new(0.5, 0.5)
        toggleButton.Name = "Button"
        toggleButton.BackgroundTransparency = 0
        toggleButton.BackgroundColor3 = DEFAULT_SEC_COLOR
        toggleButton.Size = UDim2.new(0.475, 0, 0.825, 0)
        toggleButton.Position = UDim2.new(0.5, 0, 0.5, 0)
        toggleButton.Text = ""
        
        local buttonUICorner = Instance.new("UICorner", toggleButton)
        
        local buttonUIStroke = Instance.new("UIStroke", toggleButton)
        buttonUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        buttonUIStroke.Color = DEFAULT_PRIMARY_COLOR
        buttonUIStroke.Thickness = 2
        
        local buttonUIShadow = Instance.new("UIShadow", toggleButton)
        buttonUIShadow.BlurRadius = UDim.new(0, 10)
        buttonUIShadow.Color = DEFAULT_PRIMARY_COLOR
        buttonUIShadow.Transparency = 0.25
        
        local toggleThumb = createInstance("Frame", toggleButton)
        toggleThumb.AnchorPoint = Vector2.new(0, 0.5)
        toggleThumb.Name = "Thumb"
        toggleThumb.BackgroundTransparency = 0
        toggleThumb.BackgroundColor3 = DEFAULT_PRIMARY_COLOR
        toggleThumb.Size = UDim2.new(0.3, 0, 0.75, 0)
        toggleThumb.Position = UDim2.new(0.05, 0, 0.5, 0)
        
        local thumbUICorner = Instance.new("UICorner", toggleThumb)
        thumbUICorner.CornerRadius = UDim.new(0, 6)
        
        toggleButton.MouseButton1Click:Connect(function()
            local PRIMARY_GREEN = Color3.new(0, 1, 0.5)
            local SEC_GREEN = Color3.new(0, 0.2, 0)
            
            toggleValue = not toggleValue
            if toggleValue then
                local xScale = 0.95 - toggleThumb.Size.X.Scale
                
                tween(toggleButton, {BackgroundColor3 = SEC_GREEN})
                tween(buttonUIStroke, {Color = PRIMARY_GREEN})
                tween(buttonUIShadow, {Color = PRIMARY_GREEN})
                tween(toggleThumb, {
                    BackgroundColor3 = PRIMARY_GREEN,
                    Position = UDim2.new(xScale, 0, 0.5, 0)
                })
            else
                tween(toggleButton, {BackgroundColor3 = DEFAULT_SEC_COLOR})
                tween(buttonUIStroke, {Color = DEFAULT_PRIMARY_COLOR})
                tween(buttonUIShadow, {Color = DEFAULT_PRIMARY_COLOR})
                tween(toggleThumb, {
                    BackgroundColor3 = DEFAULT_PRIMARY_COLOR,
                    Position = UDim2.new(0.05, 0, 0.5, 0)
                })
            end
            
            toggleFunc(toggleValue)
        end)
        
        return toggleContainer
    end
    
    -- Creating a input element
    
    function tab:CreateInput(inputName: string, placeholder: string, inputFunc)
        if not inputName then
            error("A name for this input element is required.")
            return
        end
        
        if not placeholder then
            error("Please provide a placeholder for the input.")
            return
        end
        
        if not inputFunc then
            error("A function is required for the input.")
            return
        end
        
        if type(inputFunc) ~= "function" then
            error("The third argument must be a function.")
            return
        end
        
        local inputContainer = createInstance("Frame", tabContent)
        inputContainer.Name = #tabContent:GetChildren() .. " Input"
        inputContainer.Size = UDim2.new(1, 0, 0, 30)
        
        local inputLabel = createInstance("TextLabel", inputContainer)
        inputLabel.Name = "Label"
        inputLabel.Size = UDim2.new(0.5, 0, 1, 0)
        inputLabel.Position = UDim2.new(0.025, 0, 0, 0)
        inputLabel.Text = inputName
        
        local inputBox: TextBox = createInstance("TextBox", inputContainer)
        inputBox.Name = "Box"
        inputBox.BackgroundColor3 = Color3.new(0, 0, 0)
        inputBox.BackgroundTransparency = 0
        inputBox.Size = UDim2.new(0.425, 0, 1, 0)
        inputBox.Position = UDim2.new(0.55, 0, 0, 0)
        inputBox.PlaceholderText = placeholder
        inputBox.Text = ""
        
        local boxUIShadow = Instance.new("UIShadow", inputBox)
        boxUIShadow.BlurRadius = UDim.new(0, 0)
        boxUIShadow.Color = Color3.new(1, 1, 1)
        boxUIShadow.Transparency = 0.9
        
        inputBox.Focused:Connect(function()
            tween(boxUIShadow, {BlurRadius = UDim.new(0, 10)})
        end)
        
        inputBox.FocusLost:Connect(function()
            inputFunc(inputBox.Text) 
            tween(boxUIShadow, {BlurRadius = UDim.new(0, 0)})
        end)
        
        local boxUIStroke = Instance.new("UIStroke", inputBox)
        boxUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        boxUIStroke.Color = Color3.new(0.2, 0.2, 0.2)
        boxUIStroke.Thickness = 2
        
        local boxUICorner = Instance.new("UICorner", inputBox)
        boxUICorner.CornerRadius = UDim.new(0, 6)
        
        return inputContainer
    end
    
    -- Creates a divider element
    
    function tab:CreateDivider()
        local divider = createInstance("Frame", tabContent)
        divider.Name = #tabContent:GetChildren() .. " Divider"
        divider.BackgroundTransparency = 0.75
        divider.Size = UDim2.new(0.95, 0, 0, 2)
        
        return divider
    end
    
    -- For Developers
    
    function tab:GetSize()
        return tabContent.Size
    end
    
    function tab:AddObject(guiObject: GuiObject)
        guiObject.Name = #tabContent:GetChildren() .. guiObject.Name
        guiObject.Parent = tabContent
    end
    
    return tab
end

function betterUI:SetTabTransparency(transparency: number)
    if transparency > 1 then
        error("Transparency cannot be greater than 1.")
        return
    end
    
    if transparency < 0 then
        error("Transparency cannot be less than 0 (in negatives).")
        return
    end
    
    self.TabTransparency = transparency
end

return betterUI
