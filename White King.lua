local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/Splix"))()

-- Create a new window
local window = library:new({
    textsize = 15,
    font = Enum.Font.Oswald,
    name = "White king (Doors)",
    color = Color3.fromRGB(225, 255, 255)
})

-- Create a new tab
local tab = window:page({
    name = "Doors"
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

section1:toggle({
    name = "Enity ESP",
    def = false,
    callback = function(state)
        if state then
            _G.EnityInstances = {}
            local Enity = {
                RushMoving = Color3.new(11, 45, 14),
                AmbushMoving = Color3.new(91, 78, 91),
                Snare = Color3.new(91, 78, 91),
                A60 = Color3.new(91, 78, 91),
                A120 = Color3.new(91, 78, 91),
                Eyes = Color3.new(91, 78, 91),
                JeffTheKiller = Color3.new(91, 78, 91)
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

            local function monitorEnity()
                for name, color in pairs(Enity) do
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

            monitorEnity()

            table.insert(_G.EnityInstances, esptable)
        else
            if _G.EnityInstances then
                for _, instance in pairs(_G.EnityInstances) do
                    for _, v in pairs(instance.Enity) do
                        v.delete()
                    end
                end
                _G.EnityInstances = nil
            end
        end
    end
})

section2:toggle({
    name = "Enity Message (information)",
    def = false,
    callback = function(state)
        if state then
            -- Define variables
            local entityNames = {"RushMoving", "AmbushMoving", "Snare", "A60", "A120", "A90", "Eyes", "JeffTheKiller"}
            local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()
            local flags = flags or {} -- Ensure flags is defined
            local plr = game.Players.LocalPlayer

            -- Function to notify entity spawn
            local function notifyEntitySpawn(entity)
                Notification:Notify(
                    {Title = "Creepy client V2", Description = entity.Name:gsub("Moving", ""):lower() .. " Spawned!"},
                    {OutlineColor = Color3.fromRGB(80, 80, 80), Time = 5, Type = "image"},
                    {Image = "http://www.roblox.com/asset/?id=10802751252", ImageColor = Color3.fromRGB(255, 255, 255)}
                )
            end

            -- Function to handle new child entities
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

            -- Start monitoring for new entities
            local running = true
            local connection = workspace.ChildAdded:Connect(onChildAdded)

            task.spawn(function()
                while running do
                    task.wait(1) -- Adjust the wait time as needed
                    if not flags.hintrush then
                        running = false
                    end
                end
                connection:Disconnect()
            end)

        else
            -- Stop monitoring and cleanup if needed
            running = false
            -- Add any additional cleanup code here if necessary
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

    -- Create ESP boxes
    for _, v in pairs(parts) do
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

    -- Create BillboardGui if core and name are provided
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
        for _, v in pairs(boxes) do
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

local function setupDoorESP(state)
    if state then
        _G.doorESPInstances = {}
        local esptable = {doors = {}}
        local flags = {espdoors = true}

        local function setup(room)
            local door = room:WaitForChild("Door"):WaitForChild("Door")
            
            task.wait(0.1)
            local h = esp(door, Color3.fromRGB(90, 255, 40), door, "Door")
            table.insert(esptable.doors, h)
            
            door:WaitForChild("Open").Played:Connect(function()
                h.delete()
            end)
            
            door.AncestryChanged:Connect(function()
                h.delete()
            end)
        end
        
        local addconnect
        addconnect = workspace.CurrentRooms.ChildAdded:Connect(function(room)
            setup(room)
        end)
        
        for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
            if room:FindFirstChild("Assets") then
                setup(room) 
            end
        end
        
        repeat task.wait() until not flags.espdoors
        addconnect:Disconnect()
        
        for _, v in pairs(esptable.doors) do
            v.delete()
        end 
    end
end

-- Example of how to use the setup function with a toggle
section1:toggle({
    name = "Door ESP",
    def = false,
    callback = function(state)
        setupDoorESP(state)
    end
})

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

-- Initialize default values
local isSpeedEnabled = false
local speedMultiplier = 1

-- Function to update character's movement speed
local function updateSpeed()
    pcall(function()
        local player = Players.LocalPlayer
        local character = player and player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if isSpeedEnabled then
                    -- Use speedMultiplier to adjust the movement speed
                    humanoid.WalkSpeed = speedMultiplier
                else
                    -- Disable speed adjustment by setting to default value
                    humanoid.WalkSpeed = 20 -- Default WalkSpeed value (adjust as needed)
                end
            end
        end
    end)
end

-- Connect RenderStepped to continuously update character's speed
RunService.RenderStepped:Connect(updateSpeed)

-- Toggle control
section2:toggle({
    name = "Enable Speed",
    def = false,
    callback = function(state)
        isSpeedEnabled = state
        updateSpeed() -- Update speed immediately when toggle state changes
    end
})

-- Slider control
section2:slider({
    name = "Speed",
    def = 1,
    max = 22,
    min = 1,
    rounding = true,
    callback = function(state)
        speedMultiplier = state
        updateSpeed() -- Update speed immediately when slider value changes
    end
})

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Initialize default values
local isFOVEnabled = false
local fovValue = 70  -- Default FOV value

-- Function to update the player's Field of View
local function updateFOV()
    pcall(function()
        local player = Players.LocalPlayer
        if player and player.Camera then
            local camera = player.Camera
            if isFOVEnabled then
                camera.FieldOfView = fovValue
            else
                camera.FieldOfView = 70  -- Default FOV value (adjust if needed)
            end
        end
    end)
end

-- Connect RenderStepped to continuously update the camera's FOV
RunService.RenderStepped:Connect(updateFOV)

-- Toggle control to enable/disable FOV adjustment
section2:toggle({
    name = "Enable FOV",
    def = false,
    callback = function(state)
        isFOVEnabled = state
        updateFOV()  -- Update FOV immediately when toggle state changes
    end
})

-- Slider control to adjust FOV
section2:slider({
    name = "FOV",
    def = 70,
    max = 120,
    min = 70,
    rounding = true,
    callback = function(state)
        fovValue = state
        updateFOV()  -- Update FOV immediately when slider value changes
    end
})
