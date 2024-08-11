local library = loadstring(game:HttpGet("https://github.com/Drop56796/CreepyEyeHub/blob/main/Splix.lua?raw=true"))()

-- Create a new window
local window = library:new({
    textsize = 15,
    font = Enum.Font.Oswald,
    name = "White king (Doors)",
    color = Color3.fromRGB(225, 255, 255)
})

-- Create a new tab
local tab = window:page({
    name = "main"
})

local tab2 = window:page({
    name = "UI Setting"
})
local section3 = tab2:section({
    name = "Ui add",
    side = "left",
    size = 250
})

-- Create a section in the tab
local section1 = tab:section({
    name = "esp",
    side = "left",
    size = 250
})

local section2 = tab:section({
    name = "function",
    side = "right",
    size = 250
})

section3:toggle({
    name = "open/close Notification(FPS MS)",
    def = false,
    callback = function(state)
        if state then
            -- 创建屏幕GUI
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "LibraryCodeNotificationGUI"
            screenGui.Parent = game:GetService("CoreGui") -- 添加到CoreGui

            -- 创建主框架
            local mainFrame = Instance.new("Frame")
            mainFrame.Size = UDim2.new(0, 600, 0, 50)
            mainFrame.Position = UDim2.new(0, 10, 0, 10)
            mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
            mainFrame.BorderSizePixel = 2
            mainFrame.BorderColor3 = Color3.new(1, 1, 1)
            mainFrame.Parent = screenGui

            -- 创建名字标签
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(0, 170, 0, 50)
            nameLabel.Position = UDim2.new(0, 10, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextColor3 = Color3.new(1, 1, 1)
            nameLabel.TextStrokeTransparency = 0
            nameLabel.Text = "White King" -- 这里可以替换成你想要显示的名字
            nameLabel.Font = Enum.Font.Code
            nameLabel.TextScaled = true
            nameLabel.Parent = mainFrame

            -- 创建FPS标签
            local fpsLabel = Instance.new("TextLabel")
            fpsLabel.Size = UDim2.new(0, 175, 0, 50)
            fpsLabel.Position = UDim2.new(1, -370, 0, 0)
            fpsLabel.BackgroundTransparency = 1
            fpsLabel.TextColor3 = Color3.new(1, 1, 1)
            fpsLabel.TextStrokeTransparency = 0
            fpsLabel.Text = "FPS: 0"
            fpsLabel.Font = Enum.Font.Code
            fpsLabel.TextScaled = true
            fpsLabel.Parent = mainFrame

            -- 创建MS标签
            local msLabel = Instance.new("TextLabel")
            msLabel.Size = UDim2.new(0, 175, 0, 50)
            msLabel.Position = UDim2.new(1, -175, 0, 0)
            msLabel.BackgroundTransparency = 1
            msLabel.TextColor3 = Color3.new(1, 1, 1)
            msLabel.TextStrokeTransparency = 0
            msLabel.Text = "MS: 0"
            msLabel.Font = Enum.Font.Code
            msLabel.TextScaled = true
            msLabel.Parent = mainFrame

            -- 更新FPS和MS
            local runService = game:GetService("RunService")
            local lastTime = tick()
            local frameCount = 0

            runService.RenderStepped:Connect(function()
                frameCount = frameCount + 1
                local currentTime = tick()
                if currentTime - lastTime >= 1 then
                    local fps = frameCount / (currentTime - lastTime)
                    fpsLabel.Text = string.format("FPS: %.2f", fps)
                    frameCount = 0
                    lastTime = currentTime
                end

                local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                msLabel.Text = string.format("MS: %.2f", ping)
            end)
        else
            -- 关闭UI
            local gui = game:GetService("CoreGui"):FindFirstChild("LibraryCodeNotificationGUI")
            if gui then
                gui:Destroy()
            end
        end
    end
})


section2:toggle({
    name = "FullBright",
    def = false,
    callback = function(state)
        local Light = game:GetService("Lighting")

        local function dofullbright()
            Light.Ambient = Color3.new(1, 1, 1)
            Light.ColorShift_Bottom = Color3.new(1, 1, 1)
            Light.ColorShift_Top = Color3.new(1, 1, 1)
        end

        local function resetLighting()
            Light.Ambient = Color3.new(0, 0, 0)
            Light.ColorShift_Bottom = Color3.new(0, 0, 0)
            Light.ColorShift_Top = Color3.new(0, 0, 0)
        end

        if state then
            _G.fullBrightEnabled = true
            task.spawn(function()
                while _G.fullBrightEnabled do
                    dofullbright()
                    task.wait(0)  -- 每秒检查一次
                end
            end)
        else
            _G.fullBrightEnabled = false
            resetLighting()
        end
    end
})

section2:toggle({
    name = "No Cilp",
    def = false,
    callback = function(state)
        local player = game.Players.LocalPlayer
        local char = player.Character
        local runService = game:GetService("RunService")
        if state then
            _G.NoClip = runService.Stepped:Connect(function()
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end)
        else
            if _G.NoClip then
                _G.NoClip:Disconnect()
                _G.NoClip = nil
            end
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end
})


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local markedTargets = {}

-- Function to create a circular UI element
local function createCircularUI(parent, color)
    local mid = Instance.new("Frame")
    mid.AnchorPoint = Vector2.new(0.5, 0.5)
    mid.BackgroundColor3 = color
    mid.Size = UDim2.new(0, 8, 0, 8)
    mid.Position = UDim2.new(0.5, 0, 0.0001, 0) -- Adjusted position
    Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", mid)
    mid.Parent = parent
    return mid
end

-- Function to mark a target with a custom name
local function markTarget(target, customName)
    if not target then return end
    -- Remove old tags if they exist
    local oldTag = target:FindFirstChild("Batteries")
    if oldTag then
        oldTag:Destroy()
    end
    local oldHighlight = target:FindFirstChild("Highlight")
    if oldHighlight then
        oldHighlight:Destroy()
    end
    -- Create a new BillboardGui
    local tag = Instance.new("BillboardGui")
    tag.Name = "Batteries"
    tag.Size = UDim2.new(0, 200, 0, 50)
    tag.StudsOffset = Vector3.new(0, 0.7, 0) -- Adjusted offset
    tag.AlwaysOnTop = true
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextStrokeTransparency = 0 
    textLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.Jura
    textLabel.TextScaled = true
    textLabel.Text = customName
    textLabel.Parent = tag
    tag.Parent = target
    -- Create a Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "Highlight"
    highlight.Adornee = target
    highlight.FillColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 139)
    highlight.Parent = target
    -- Add the circular UI
    createCircularUI(tag, Color3.fromRGB(255, 255, 255))
    -- Track marked targets
    markedTargets[target] = customName
end

-- Recursive function to find all descendants with a specific name
local function recursiveFindAll(parent, name, targets)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == name then
            table.insert(targets, child)
        end
        recursiveFindAll(child, name, targets)
    end
end

-- Function to mark items by name
local function Itemlocationname(name, customName)
    local targets = {}
    recursiveFindAll(game, name, targets)
    for _, target in ipairs(targets) do
        markTarget(target, customName)
    end
end

-- Function to mark players by name
local function Invalidplayername(playerName, customName)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name == playerName and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                markTarget(head, customName)
            end
        end
    end
end

-- Main logic for toggling functionality
local function setup(state)
    if state then
        -- Connect player and descendant events
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function(character)
                local head = character:FindFirstChild("Head")
                if head then
                    markTarget(head, player.Name)
                end
            end)
        end)

        game.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Key" then
                markTarget(descendant, "Key")
            end
        end)

        -- Update highlighted targets each frame
        RunService.RenderStepped:Connect(function()
            for target, customName in pairs(markedTargets) do
                if target and target:FindFirstChild("Batteries") then
                    target.Batteries.TextLabel.Text = customName
                else
                    if target then
                        markTarget(target, customName)
                    end
                end
            end
        end)

        -- Initial calls to mark specific targets
        Invalidplayername("玩家名称", "玩家")
        Itemlocationname("Key", "Key")
    else
        -- Cleanup logic if needed
        for target, _ in pairs(markedTargets) do
            if target:FindFirstChild("Batteries") then
                target.Batteries:Destroy()
            end
            if target:FindFirstChild("Highlight") then
                target.Highlight:Destroy()
            end
        end
        markedTargets = {}
    end
end

-- Toggle callback
section1:toggle({
    name = "Key esp",
    def = false,
    callback = function(state)
        setup(state)
    end
})

section1:toggle({
    name = "Player esp",
    def = false,
    callback = function(state)
        if state then
            _G.aespInstances = {}
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character then
                    local aespInstance = esp(player.Character, Color3.new(255, 255, 255), player.Character:FindFirstChild("HumanoidRootPart"), player.Name)
                    table.insert(_G.aespInstances, aespInstance)
                end
            end
        else
            if _G.aespInstances then
                for _, aespInstance in pairs(_G.aespInstances) do
                    aespInstance.delete()
                end
                _G.aespInstances = nil
            end
        end
    end
})

function esp(what, color, core, name)
    local parts
    if typeof(what) == "Instance" then
        if what:IsA("Model") then
            parts = what:GetChildren()
        elseif what:IsA("BasePart") then
            parts = {what, table.unpack(what:GetChildren())}
        end
    elseif typeof(what) == "table" then
        parts = what
    end

    local bill
    local boxes = {}

    for i, v in pairs(parts) do
        if v:IsA("BasePart") then
            local box = Instance.new("BoxHandleAdornment")
            box.Size = v.Size
            box.AlwaysOnTop = true
            box.ZIndex = 1
            box.AdornCullingMode = Enum.AdornCullingMode.Never
            box.Color3 = color
            box.Transparency = 0.7
            box.Adornee = v
            box.Parent = game.CoreGui

            table.insert(boxes, box)

            task.spawn(function()
                while box do
                    if box.Adornee == nil or not box.Adornee:IsDescendantOf(workspace) then
                        box.Adornee = nil
                        box.Visible = false
                        box:Destroy()
                    end
                    task.wait()
                end
            end)
        end
    end

    if core and name then
        bill = Instance.new("BillboardGui", game.CoreGui)
        bill.AlwaysOnTop = true
        bill.Size = UDim2.new(0, 100, 0, 50)
        bill.Adornee = core
        bill.MaxDistance = 2000

        local mid = Instance.new("Frame", bill)
        mid.AnchorPoint = Vector2.new(0.5, 0.5)
        mid.BackgroundColor3 = color
        mid.Size = UDim2.new(0, 8, 0, 8)
        mid.Position = UDim2.new(0.5, 0, 0.5, 0)
        Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
        Instance.new("UIStroke", mid)

        local txt = Instance.new("TextLabel", bill)
        txt.AnchorPoint = Vector2.new(0.5, 0.5)
        txt.BackgroundTransparency = 1
        txt.BackgroundColor3 = color
        txt.TextColor3 = color
        txt.Size = UDim2.new(1, 0, 0, 20)
        txt.Position = UDim2.new(0.5, 0, 0.7, 0)
        txt.Text = name
        Instance.new("UIStroke", txt)

        task.spawn(function()
            while bill do
                if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                    bill.Enabled = false
                    bill.Adornee = nil
                    bill:Destroy()
                end
                task.wait()
            end
        end)
    end

    local ret = {}

    ret.delete = function()
        for i, v in pairs(boxes) do
            v.Adornee = nil
            v.Visible = false
            v:Destroy()
        end

        if bill then
            bill.Enabled = false
            bill.Adornee = nil
            bill:Destroy()
        end
    end

    return ret
end

-- Define Player ESP function
function playerEsp()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            esp(player.Character, Color3.new(0, 1, 0), player.Character:FindFirstChild("HumanoidRootPart"), player.Name)
        end
    end
end



-- Define a variable to control auto-interaction
local autoInteract = false

-- Function to handle auto-interaction
local function setupAutoInteract(state)
    if state then
        -- Enable auto-interaction
        autoInteract = true

        -- Get the local player
        local player = game.Players.LocalPlayer

        -- Connect to room and descendant additions
        workspace.CurrentRooms.ChildAdded:Connect(function(room)
            room.DescendantAdded:Connect(function(descendant)
                if descendant:IsA("Model") then
                    local prompt = nil
                    -- Determine the prompt based on the model's name
                    if descendant.Name == "DrawerContainer" then
                        prompt = descendant:WaitForChild("Knobs"):WaitForChild("ActivateEventPrompt")
                    elseif descendant.Name == "GoldPile" then
                        prompt = descendant:WaitForChild("LootPrompt")
                    elseif descendant.Name:sub(1, 8) == "ChestBox" or descendant.Name == "RolltopContainer" then
                        prompt = descendant:WaitForChild("ActivateEventPrompt")
                    end

                    -- If a prompt is found, set up auto-interaction
                    if prompt then
                        local interactions = prompt:GetAttribute("Interactions")
                        if not interactions then
                            task.spawn(function()
                                while autoInteract and not prompt:GetAttribute("Interactions") do
                                    task.wait(0.1)
                                    if player:DistanceFromCharacter(descendant.PrimaryPart.Position) <= 12 then
                                        fireproximityprompt(prompt)
                                    end
                                end
                            end)
                        end
                    end
                end
            end)
        end)

        -- Check existing items in current rooms
        for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
            for _, descendant in pairs(room:GetDescendants()) do
                if descendant:IsA("Model") then
                    local prompt = nil
                    -- Determine the prompt based on the model's name
                    if descendant.Name == "DrawerContainer" then
                        prompt = descendant:WaitForChild("Knobs"):WaitForChild("ActivateEventPrompt")
                    elseif descendant.Name == "GoldPile" then
                        prompt = descendant:WaitForChild("LootPrompt")
                    elseif descendant.Name:sub(1, 8) == "ChestBox" or descendant.Name == "RolltopContainer" then
                        prompt = descendant:WaitForChild("ActivateEventPrompt")
                    end

                    -- If a prompt is found, set up auto-interaction
                    if prompt then
                        local interactions = prompt:GetAttribute("Interactions")
                        if not interactions then
                            task.spawn(function()
                                while autoInteract and not prompt:GetAttribute("Interactions") do
                                    task.wait(0.1)
                                    if player:DistanceFromCharacter(descendant.PrimaryPart.Position) <= 12 then
                                        fireproximityprompt(prompt)
                                    end
                                end
                            end)
                        end
                    end
                end
            end
        end
    else
        -- Disable auto-interaction
        autoInteract = false
    end
end

-- Example usage
section2:toggle({
    name = "look aura",
    def = false,
    callback = function(state)
        setupAutoInteract(state)
    end
})

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- LocalPlayer and Collision initialization
local player = Players.LocalPlayer
local collision = player.Character:WaitForChild("Collision")
local crouch = collision:WaitForChild("CollisionCrouch")

-- Variables to manage state
local isBypassEnabled = false
local oTick = tick()

-- Function to toggle bypass functionality
local function toggleBypass(state)
    if state then
        -- Start bypass functionality
        RunService:BindToRenderStep('Bypass', 999, function()
            if (tick() - oTick) >= 0.2 then
                crouch.Massless = not crouch.Massless
                oTick = tick()
            end
        end)
    else
        -- Disable bypass functionality
        RunService:UnbindFromRenderStep('Bypass')
        crouch.Massless = false  -- Reset to default state
    end
end

-- Toggle control
section2:toggle({
    name = "Banned speed Bypass(35%)",
    def = false,
    callback = function(state)
        isBypassEnabled = state
        toggleBypass(state)
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variables to manage third-person view state
local thirdPersonEnabled = false

-- Function to toggle third-person view
local function toggleThirdPerson(state)
    thirdPersonEnabled = state
    
    if state then
        -- Enable third-person view
        RunService:BindToRenderStep('ThirdPersonView', Enum.RenderPriority.Camera.Value, function()
            if character and humanoidRootPart then
                Camera.CameraType = Enum.CameraType.Scriptable
                Camera.CFrame = CFrame.new(humanoidRootPart.Position - humanoidRootPart.CFrame.LookVector * 10, humanoidRootPart.Position)
            end
        end)
    else
        -- Disable third-person view
        RunService:UnbindFromRenderStep('ThirdPersonView')
        Camera.CameraType = Enum.CameraType.Custom
    end
end

-- Toggle control
section2:toggle({
    name = "Enable Third View",
    def = false,
    callback = function(state)
        toggleThirdPerson(state)
    end
})


section1:toggle({
    name = "Locker/Wardrobe esp",
    def = false,
    callback = function(state)
        if state then
            _G.ABCDInstances = {}
            local ABCD = {
                Rooms_Locker_Fridge = Color3.new(91, 91, 91),
                Rooms_Locker = Color3.new(78, 78, 78),
                Wardrobe = Color3.new(91, 91, 91)
            }

            local function createBillboard(instance, name, color)
                if not instance or not instance:IsDescendantOf(workspace) then return end

                local bill = Instance.new("BillboardGui", game.CoreGui)
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0, 100, 0, 50)
                bill.Adornee = instance
                bill.MaxDistance = 2000

                local mid = Instance.new("Frame", bill)
                mid.AnchorPoint = Vector2.new(0.5, 0.5)
                mid.BackgroundColor3 = color
                mid.Size = UDim2.new(0, 8, 0, 8)
                mid.Position = UDim2.new(0.5, 0, 0.5, 0)
                Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
                Instance.new("UIStroke", mid)

                local txt = Instance.new("TextLabel", bill)
                txt.AnchorPoint = Vector2.new(0.5, 0.5)
                txt.BackgroundTransparency = 1
                txt.TextColor3 = color
                txt.Size = UDim2.new(1, 0, 0, 20)
                txt.Position = UDim2.new(0.5, 0, 0.7, 0)
                txt.Text = name
                Instance.new("UIStroke", txt)

                task.spawn(function()
                    while bill and bill.Adornee do
                        if not bill.Adornee:IsDescendantOf(workspace) then
                            bill:Destroy()
                            return
                        end
                        task.wait()
                    end
                end)
            end

            local function monitorABCD()
                for name, color in pairs(ABCD) do
                    -- Check existing instances
                    for _, instance in pairs(workspace:GetDescendants()) do
                        if instance:IsA("Model") and instance.Name == name then
                            createBillboard(instance, name, color)
                        end
                    end

                    -- Monitor for new instances
                    workspace.DescendantAdded:Connect(function(instance)
                        if instance:IsA("Model") and instance.Name == name then
                            createBillboard(instance, name, color)
                        end
                    end)
                end
            end

            monitorABCD()

            table.insert(_G.ABCDInstances, esptable)
        else
            if _G.ABCDInstances then
                for _, instance in pairs(_G.ABCDInstances) do
                    for _, v in pairs(instance.ABCD) do
                        v.delete()
                    end
                end
                _G.ABCDInstances = nil
            end
        end
    end
})
section1:toggle({
    name = "Entity ESP",
    def = false,
    callback = function(isEnabled)
        local esptable = { entity = {} }
        local flags = { esprush = isEnabled }
        local entityNames = {"RushMoving", "AmbushMoving", "Snare", "A60", "A120", "A90", "Eyes", "JeffTheKiller"}

        -- Function to create ESP effects
        local function esp(what, color, core, name)
            local parts

            if typeof(what) == "Instance" then
                if what:IsA("Model") then
                    parts = what:GetChildren()
                elseif what:IsA("BasePart") then
                    parts = {what, table.unpack(what:GetChildren())}
                end
            elseif typeof(what) == "table" then
                parts = what
            end

            local bill
            local boxes = {}

            for i, v in pairs(parts) do
                if v:IsA("BasePart") then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Size = v.Size
                    box.AlwaysOnTop = true
                    box.ZIndex = 1
                    box.AdornCullingMode = Enum.AdornCullingMode.Never
                    box.Color3 = color
                    box.Transparency = 1
                    box.Adornee = v
                    box.Parent = game.CoreGui

                    table.insert(boxes, box)

                    task.spawn(function()
                        while box do
                            if box.Adornee == nil or not box.Adornee:IsDescendantOf(workspace) then
                                box.Adornee = nil
                                box.Visible = false
                                box:Destroy()
                            end
                            task.wait()
                        end
                    end)
                end
            end

            if core and name then
                bill = Instance.new("BillboardGui", game.CoreGui)
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0, 400, 0, 100)
                bill.Adornee = core
                bill.MaxDistance = 2000

                local mid = Instance.new("Frame", bill)
                mid.AnchorPoint = Vector2.new(0.5, 0.5)
                mid.BackgroundColor3 = color
                mid.Size = UDim2.new(0, 8, 0, 8)
                mid.Position = UDim2.new(0.5, 0, 0.5, 0)
                Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
                Instance.new("UIStroke", mid)

                local txt = Instance.new("TextLabel", bill)
                txt.AnchorPoint = Vector2.new(0.5, 0.5)
                txt.BackgroundTransparency = 1
                txt.BackgroundColor3 = color
                txt.TextColor3 = color
                txt.Size = UDim2.new(1, 0, 0, 20)
                txt.Position = UDim2.new(0.5, 0, 0.7, 0)
                txt.Text = name
                Instance.new("UIStroke", txt)

                task.spawn(function()
                    while bill do
                        if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                            bill.Enabled = false
                            bill.Adornee = nil
                            bill:Destroy()
                        end
                        task.wait()
                    end
                end)
            end

            local ret = {}

            ret.delete = function()
                for i, v in pairs(boxes) do
                    v.Adornee = nil
                    v.Visible = false
                    v:Destroy()
                end

                if bill then
                    bill.Enabled = false
                    bill.Adornee = nil
                    bill:Destroy()
                end
            end

            return ret
        end

        -- Function to handle new entity
        local function handleNewEntity(entity)
            if table.find(entityNames, entity.Name) then
                task.wait(0.1)
                local espInstance = esp(entity, Color3.fromRGB(255, 25, 25), entity.PrimaryPart, entity.Name:gsub("Moving", ""))
                table.insert(esptable.entity, espInstance)
            end
        end

        -- Function to setup room entities
        local function setupRoom(room)
            if room.Name == "50" or room.Name == "100" then
                local figureSetup = room:FindFirstChild("FigureSetup")
                if figureSetup then
                    local figure = figureSetup:FindFirstChild("FigureRagdoll")
                    task.wait(0.1)
                    if figure then
                        local espInstance = esp(figure, Color3.fromRGB(255, 25, 25), figure.PrimaryPart, "Figure")
                        table.insert(esptable.entity, espInstance)
                    end
                end
            else
                local assets = room:FindFirstChild("Assets")
                if assets then
                    local function checkDescendant(descendant)
                        if descendant:IsA("Model") and table.find(entityNames, descendant.Name) then
                            task.wait(0.1)
                            local espInstance = esp(descendant:FindFirstChild("Base"), Color3.fromRGB(255, 25, 25), descendant.Base, "Snare")
                            table.insert(esptable.entity, espInstance)
                        end
                    end

                    assets.DescendantAdded:Connect(checkDescendant)
                    for _, descendant in pairs(assets:GetDescendants()) do
                        checkDescendant(descendant)
                    end
                end
            end
        end

        -- Main logic
        if isEnabled then
            local addConnect = workspace.ChildAdded:Connect(function(entity)
                handleNewEntity(entity)
            end)

            local roomConnect = workspace.CurrentRooms.ChildAdded:Connect(function(room)
                setupRoom(room)
            end)

            for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
                setupRoom(room)
            end

            task.spawn(function()
                repeat
                    task.wait()
                until not flags.esprush
                addConnect:Disconnect()
                roomConnect:Disconnect()

                for _, espInstance in pairs(esptable.entity) do
                    espInstance.delete()
                end
            end)
        else
            -- Cleanup if disabled
            for _, espInstance in pairs(esptable.entity) do
                espInstance.delete()
            end
        end
    end
})

section1:toggle({
    name = "Door ESP",
    def = false,
    callback = function(val)
        if val then
            _G.DooDoorInstances = {}
            local DooDoorItems = {
                Door = Color3.new(1, 0.5, 0)  -- Orange color for DooDoor
            }

            local function createDooDoorBillboard(instance, name, color)
                if not instance or not instance:IsDescendantOf(workspace) then return end

                local bill = Instance.new("BillboardGui", game.CoreGui)
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0, 100, 0, 50)
                bill.Adornee = instance
                bill.MaxDistance = 2000

                local mid = Instance.new("Frame", bill)
                mid.AnchorPoint = Vector2.new(0.5, 0.5)
                mid.BackgroundColor3 = color
                mid.Size = UDim2.new(0, 8, 0, 8)
                mid.Position = UDim2.new(0.5, 0, 0.5, 0)
                Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
                Instance.new("UIStroke", mid)

                local txt = Instance.new("TextLabel", bill)
                txt.AnchorPoint = Vector2.new(0.5, 0.5)
                txt.BackgroundTransparency = 1
                txt.TextColor3 = color
                txt.Size = UDim2.new(1, 0, 0, 20)
                txt.Position = UDim2.new(0.5, 0, 0.7, 0)
                txt.Text = name
                Instance.new("UIStroke", txt)

                task.spawn(function()
                    while bill and bill.Adornee do
                        if not bill.Adornee:IsDescendantOf(workspace) then
                            bill:Destroy()
                            return
                        end
                        task.wait()
                    end
                end)
            end

            local function monitorDooDoorItems()
                for name, color in pairs(DooDoorItems) do
                    -- Check existing instances
                    for _, instance in pairs(workspace:GetDescendants()) do
                        if instance:IsA("Model") and instance.Name == name then
                            createDooDoorBillboard(instance, name, color)
                        end
                    end

                    -- Monitor for new instances
                    workspace.DescendantAdded:Connect(function(instance)
                        if instance:IsA("Model") and instance.Name == name then
                            createDooDoorBillboard(instance, name, color)
                        end
                    end)
                end
            end

            monitorDooDoorItems()

            table.insert(_G.DooDoorInstances, esptable)
        else
            if _G.DooDoorInstances then
                for _, instance in pairs(_G.DooDoorInstances) do
                    for _, v in pairs(instance.DooDoor) do
                        v.delete()
                    end
                end
                _G.DooDoorInstances = nil
            end
        end
    end
})

section1:toggle({
    name = "Book/Paper ESP",
    def = false,
    callback = function(val)
        if val then
            _G.DoorInstances = {}
            local DoorItems = {
                LiveHintBook = Color3.new(1, 0, 0), 
                LiveBreakerPolePickup = Color3.new(1, 0, 0),
            }

            local function createDooDoorBillboard(instance, name, color)
                if not instance or not instance:IsDescendantOf(workspace) then return end

                local bill = Instance.new("BillboardGui", game.CoreGui)
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0, 100, 0, 50)
                bill.Adornee = instance
                bill.MaxDistance = 2000

                local mid = Instance.new("Frame", bill)
                mid.AnchorPoint = Vector2.new(0.5, 0.5)
                mid.BackgroundColor3 = color
                mid.Size = UDim2.new(0, 8, 0, 8)
                mid.Position = UDim2.new(0.5, 0, 0.5, 0)
                Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
                Instance.new("UIStroke", mid)

                local txt = Instance.new("TextLabel", bill)
                txt.AnchorPoint = Vector2.new(0.5, 0.5)
                txt.BackgroundTransparency = 1
                txt.TextColor3 = color
                txt.Size = UDim2.new(1, 0, 0, 20)
                txt.Position = UDim2.new(0.5, 0, 0.7, 0)
                txt.Text = name
                Instance.new("UIStroke", txt)

                task.spawn(function()
                    while bill and bill.Adornee do
                        if not bill.Adornee:IsDescendantOf(workspace) then
                            bill:Destroy()
                            return
                        end
                        task.wait()
                    end
                end)
            end

            local function monitorDoorItems()
                for name, color in pairs(DoorItems) do
                    -- Check existing instances
                    for _, instance in pairs(workspace:GetDescendants()) do
                        if instance:IsA("Model") and instance.Name == name then
                            createDooDoorBillboard(instance, name, color)
                        end
                    end

                    -- Monitor for new instances
                    workspace.DescendantAdded:Connect(function(instance)
                        if instance:IsA("Model") and instance.Name == name then
                            createDooDoorBillboard(instance, name, color)
                        end
                    end)
                end
            end

            monitorDoorItems()

            table.insert(_G.DoorInstances, esptable)
        else
            if _G.DoorInstances then
                for _, instance in pairs(_G.DoorInstances) do
                    for _, v in pairs(instance.Door) do
                        v.delete()
                    end
                end
                _G.DoorInstances = nil
            end
        end
    end
})

section2:toggle({
    name = "Item ESP",
    def = false,
    callback = function(isEnabled)
        local highlightedItems = {}
        local monitoredRooms = {}

        -- Define the esp function inside the toggle callback
        local function esp(what, color, core, name)
            local parts

            if typeof(what) == "Instance" then
                if what:IsA("Model") then
                    parts = what:GetChildren()
                elseif what:IsA("BasePart") then
                    parts = {what, table.unpack(what:GetChildren())}
                end
            elseif typeof(what) == "table" then
                parts = what
            end

            local bill
            local boxes = {}

            -- Create box handle adornments for each part
            for i, v in pairs(parts) do
                if v:IsA("BasePart") then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Size = v.Size
                    box.AlwaysOnTop = true
                    box.ZIndex = 1
                    box.AdornCullingMode = Enum.AdornCullingMode.Never
                    box.Color3 = color
                    box.Transparency = 1
                    box.Adornee = v
                    box.Parent = game.CoreGui

                    table.insert(boxes, box)

                    task.spawn(function()
                        while box do
                            if box.Adornee == nil or not box.Adornee:IsDescendantOf(workspace) then
                                box.Adornee = nil
                                box.Visible = false
                                box:Destroy()
                                break
                            end  
                            task.wait()
                        end
                    end)
                end
            end

            -- Create a BillboardGui for labeling
            if core and name then
                bill = Instance.new("BillboardGui", game.CoreGui)
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0, 200, 0, 50)
                bill.Adornee = core
                bill.MaxDistance = 2000

                local mid = Instance.new("Frame", bill)
                mid.AnchorPoint = Vector2.new(0.5, 0.5)
                mid.BackgroundColor3 = color
                mid.Size = UDim2.new(0, 8, 0, 8)
                mid.Position = UDim2.new(0.5, 0, 0.5, 0)
                Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
                Instance.new("UIStroke", mid)

                local txt = Instance.new("TextLabel", bill)
                txt.AnchorPoint = Vector2.new(0.5, 0.5)
                txt.BackgroundTransparency = 1
                txt.BackgroundColor3 = color
                txt.TextColor3 = color
                txt.Size = UDim2.new(1, 0, 0, 20)
                txt.Position = UDim2.new(0.5, 0, 0.7, 0)
                txt.Text = name
                Instance.new("UIStroke", txt)

                task.spawn(function()
                    while bill do
                        if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                            bill.Enabled = false
                            bill.Adornee = nil
                            bill:Destroy() 
                            break
                        end
                        task.wait()
                    end
                end)
            end

            -- Return a table with a delete function to clean up
            local ret = {}

            ret.delete = function()
                for i, v in pairs(boxes) do
                    v.Adornee = nil
                    v.Visible = false
                    v:Destroy()
                end

                if bill then
                    bill.Enabled = false
                    bill.Adornee = nil
                    bill:Destroy() 
                end
            end

            return ret 
        end

        -- Function to highlight the item
        local function highlightItem(item)
            if item:IsA("Model") then
                local part = item:FindFirstChild("Handle") or item:FindFirstChild("Prop")
                if part then
                    local espInstance = esp(part, Color3.fromRGB(0, 255, 0), part, item.Name) -- Using the ESP function
                    table.insert(highlightedItems, espInstance) -- Store the ESP instance for cleanup
                end
            end
        end

        -- Function to monitor and highlight items in the room
        local function monitorRoom(room)
            local assets = room:FindFirstChild("Assets")
            if assets then
                -- Highlight existing items in the assets
                for _, descendant in ipairs(assets:GetDescendants()) do
                    highlightItem(descendant)
                end

                -- Monitor for new items added to the assets
                assets.DescendantAdded:Connect(function(descendant)
                    highlightItem(descendant)
                end)
            end
        end

        -- Start monitoring the rooms and handle dynamic updates
        local function startMonitoring()
            -- Monitor current rooms
            for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
                monitorRoom(room)
                monitoredRooms[room] = true
            end

            -- Monitor newly added rooms
            workspace.CurrentRooms.ChildAdded:Connect(function(room)
                monitorRoom(room)
                monitoredRooms[room] = true
            end)
        end

        -- Manage the toggle state
        if isEnabled then
            startMonitoring()
            
            -- Keep monitoring and updating while enabled
            task.spawn(function()
                while isEnabled do
                    -- Remove any items that are no longer in the workspace
                    for _, espInstance in pairs(highlightedItems) do
                        espInstance.delete()
                    end
                    highlightedItems = {}

                    -- Reapply ESP to all currently visible items
                    for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
                        monitorRoom(room)
                    end

                    task.wait(1)
                end
                
                -- Clean up when ESP is disabled
                for _, espInstance in pairs(highlightedItems) do
                    espInstance.delete()
                end
                highlightedItems = {}
            end)
        else
            -- Clean up if disabled
            for _, espInstance in pairs(highlightedItems) do
                espInstance.delete()
            end
        end
    end
})

section1:toggle({
    name = "Lever esp",
    def = false,
    callback = function(state)
        if state then
            _G.ABCInstances = {}
            local ABC = {
                LeverForGate = Color3.new(1, 10, 100)
            }

            local function createBillboard(instance, name, color)
                if not instance or not instance:IsDescendantOf(workspace) then return end

                local bill = Instance.new("BillboardGui", game.CoreGui)
                bill.AlwaysOnTop = true
                bill.Size = UDim2.new(0, 100, 0, 50)
                bill.Adornee = instance
                bill.MaxDistance = 2000

                local mid = Instance.new("Frame", bill)
                mid.AnchorPoint = Vector2.new(0.5, 0.5)
                mid.BackgroundColor3 = color
                mid.Size = UDim2.new(0, 8, 0, 8)
                mid.Position = UDim2.new(0.5, 0, 0.5, 0)
                Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
                Instance.new("UIStroke", mid)

                local txt = Instance.new("TextLabel", bill)
                txt.AnchorPoint = Vector2.new(0.5, 0.5)
                txt.BackgroundTransparency = 1
                txt.TextColor3 = color
                txt.Size = UDim2.new(1, 0, 0, 20)
                txt.Position = UDim2.new(0.5, 0, 0.7, 0)
                txt.Text = name
                Instance.new("UIStroke", txt)

                task.spawn(function()
                    while bill and bill.Adornee do
                        if not bill.Adornee:IsDescendantOf(workspace) then
                            bill:Destroy()
                            return
                        end
                        task.wait()
                    end
                end)
            end

            local function monitorABC()
                for name, color in pairs(ABC) do
                    -- Check existing instances
                    for _, instance in pairs(workspace:GetDescendants()) do
                        if instance:IsA("Model") and instance.Name == name then
                            createBillboard(instance, name, color)
                        end
                    end

                    -- Monitor for new instances
                    workspace.DescendantAdded:Connect(function(instance)
                        if instance:IsA("Model") and instance.Name == name then
                            createBillboard(instance, name, color)
                        end
                    end)
                end
            end

            monitorABC()

            table.insert(_G.ABCInstances, esptable)
        else
            if _G.ABCInstances then
                for _, instance in pairs(_G.ABCInstances) do
                    for _, v in pairs(instance.ABC) do
                        v.delete()
                    end
                end
                _G.ABCInstances = nil
            end
        end
    end
})

section2:toggle({
    name = "Entity Notification",
    def = false,
    callback = function(state)
        if state then
            local entityNames = {"RushMoving", "AmbushMoving", "Snare", "A60", "A120", "A90", "Eyes", "JeffTheKiller"}  -- Entities to monitor
            local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))() -- Lib1
            local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))() -- Lib2

            -- Ensure flags and plr are defined
            local flags = flags or {} -- Prevent error
            local plr = game.Players.LocalPlayer -- Reference to the local player

            -- Function to notify when an entity spawns
            local function notifyEntitySpawn(entity)
                Notification:Notify(
                    {Title = "White King Notification", Description = entity.Name:gsub("Moving", ""):lower() .. " Spawned go hide!"},
                    {OutlineColor = Color3.fromRGB(80, 80, 80), Time = 5, Type = "image"},
                    {Image = "http://www.roblox.com/asset/?id=18394059300", ImageColor = Color3.fromRGB(255, 255, 255)}
                )
            end

            -- Function to handle when a new child is added to the workspace
            local function onChildAdded(child)
                if table.find(entityNames, child.Name) then
                    repeat
                        task.wait()
                    until plr:DistanceFromCharacter(child:GetPivot().Position) < 1000 or not child:IsDescendantOf(workspace)

                    if child:IsDescendantOf(workspace) then
                        notifyEntitySpawn(child)
                    end
                end
            end

            -- Keep track of the running state and manage connections
            local running = true
            local connection

            -- Infinite loop to maintain the script
            task.spawn(function()
                while running do
                    connection = workspace.ChildAdded:Connect(onChildAdded)
                    
                    repeat
                        task.wait(1) -- Adjust the wait time as needed
                    until not flags.hintrush or not running
                    
                    connection:Disconnect()
                end
            end)
        else
            -- Cleanup: Stop the script from running
            running = false
        end
    end
})


section2:toggle({
    name = "Library Code Notification",
    def = false,
    callback = function(state)
        if state then
            local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()
            local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()
            _G.codeEventInstances = _G.codeEventInstances or {}

            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()

            -- 确保 player 和 character 都已正确初始化
            if not player or not character then
                warn("Player or Character is nil")
                return
            end

            local function decipherCode()
                local paper = character:FindFirstChild("LibraryHintPaper")
                local hints = player.PlayerGui:WaitForChild("PermUI"):WaitForChild("Hints")
                local code = {[1]="_", [2]="_", [3]="_", [4]="_", [5]="_"}

                if paper then
                    for _, v in pairs(paper:WaitForChild("UI"):GetChildren()) do
                        if v:IsA("ImageLabel") and v.Name ~= "Image" then
                            for _, img in pairs(hints:GetChildren()) do
                                if img:IsA("ImageLabel") and img.Visible and v.ImageRectOffset == img.ImageRectOffset then
                                    local num = img:FindFirstChild("TextLabel").Text
                                    code[tonumber(v.Name)] = num 
                                end
                            end
                        end
                    end 
                end
                
                return code
            end
            
            local addConnect
            addConnect = character.ChildAdded:Connect(function(v)
                if v:IsA("Tool") and v.Name == "LibraryHintPaper" then
                    task.wait()
                    local code = table.concat(decipherCode())

                    if code:find("_") then
                        Notification:Notify(
                            {Title = "White King Notification", Description = "You need to get all books"},
                            {OutlineColor = Color3.fromRGB(80, 80, 80), Time = 5, Type = "image"},
                            {Image = "http://www.roblox.com/asset/?id=13327193518", ImageColor = Color3.fromRGB(255, 255, 255)}
                        )
                    else
                        Notification:Notify(
                            {Title = "White King Notification", Description = "Code is " .. code},
                            {OutlineColor = Color3.fromRGB(80, 80, 80), Time = 5, Type = "image"},
                            {Image = "http://www.roblox.com/asset/?id=13327193518", ImageColor = Color3.fromRGB(255, 255, 255)}
                        )
                    end
                end
            end)
            
            table.insert(_G.codeEventInstances, addConnect)

        else
            if _G.codeEventInstances then
                for _, instance in pairs(_G.codeEventInstances) do
                    if instance and instance.Connected then
                        instance:Disconnect()
                    end
                end
                _G.codeEventInstances = nil
            end
        end
    end
})

