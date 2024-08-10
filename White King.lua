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

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

local tpWalkThread

local function tpWalk(speed)
    while true do
        task.wait()
        if Humanoid.MoveDirection.Magnitude > 0 then
            -- Move the player in the direction they are facing, including vertical movement
            local moveDirection = Humanoid.MoveDirection * speed

            -- Adjust for swimming: add upward movement if the player is in water
            if Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
                moveDirection = moveDirection + Vector3.new(0, speed, 0)
            end

            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + moveDirection
        end
    end
end
3
section2:slider({
    name = "Speed",
    def = 0,
    max = ,
    min = 0,
    rounding = true,
    callback = function(value)
        if tpWalkThread then
            tpWalkThread:Disconnect()
        end

        -- Start a new tpWalk thread
        tpWalkThread = coroutine.wrap(function()
            tpWalk(Value)
        end)
        tpWalkThread()
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
                Camera.CFrame = CFrame.new(humanoidRootPart.Position - humanoidRootPart.CFrame.LookVector * 30, humanoidRootPart.Position)
            end
        end)
    else
        -- Disable third-person view
        RunService:UnbindFromRenderStep('ThirdPersonView')
        Camera.CameraType = Enum.CameraType.Custom
    end
end

-- Toggle control
section1:toggle({
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
    callback = function(val)
       if state then
            _G.nahESPInstances = {}
            local itemTypes = {
                RushMoving = Color3.new(0, 1, 0),
                AmbushMoving = Color3.new(0, 0, 1),
                Snare = Color3.new(1, 1, 1),
                A120 = Color3.new(1, 1, 1),
                A60 = Color3.new(1, 1, 1),
                Eyes = Color3.new(1, 1, 1),
                JeffTheKiller = Color3.new(1, 1, 1)
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

            local function monitorItems()
                for name, color in pairs(itemTypes) do
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

            monitorItems()

            table.insert(_G.nahESPInstances, esptable)
        else
            if _G.nahESPInstances then
                for _, instance in pairs(_G.nahESPInstances) do
                    for _, v in pairs(instance.nah) do
                        v.delete()
                    end
                end
                _G.nahESPInstances = nil
            end
        end
    end
})

section1:toggle({
    name = "Lever ESP",
    def = false,
    callback = function(state)
        if state then
            _G.KInstances = {}
            local K = {
                LeverForGate = Color3.new(11, 45, 14)            
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

            local function monitorK()
                for name, color in pairs(K) do
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

            monitorK()

            table.insert(_G.KInstances, esptable)
        else
            if _G.KInstances then
                for _, instance in pairs(_G.KInstances) do
                    for _, v in pairs(instance.K) do
                        v.delete()
                    end
                end
                _G.KInstances = nil
            end
        end
    end
})

section2:toggle({
    name = "Item ESP",
    def = false,
    callback = function(isEnabled)
        local espItems = {}
        local isEspEnabled = isEnabled
        
        -- Function to create ESP effects
        local function createESP(part, color, name)
            local boxAdornment
            local billboardGui

            -- Create a BoxHandleAdornment if part is a BasePart
            if part and part:IsA("BasePart") then
                boxAdornment = Instance.new("BoxHandleAdornment")
                boxAdornment.Size = part.Size
                boxAdornment.AlwaysOnTop = true
                boxAdornment.ZIndex = 1
                boxAdornment.AdornCullingMode = Enum.AdornCullingMode.Never
                boxAdornment.Color3 = color
                boxAdornment.Transparency = 1
                boxAdornment.Adornee = part
                boxAdornment.Parent = game.CoreGui

                task.spawn(function()
                    while boxAdornment do
                        if not boxAdornment.Adornee or not boxAdornment.Adornee:IsDescendantOf(workspace) then
                            boxAdornment:Destroy()
                            break
                        end
                        task.wait()
                    end
                end)
            end

            -- Create a BillboardGui for labels
            if part and name then
                billboardGui = Instance.new("BillboardGui")
                billboardGui.AlwaysOnTop = true
                billboardGui.Size = UDim2.new(0, 200, 0, 50)
                billboardGui.Adornee = part
                billboardGui.MaxDistance = 2000
                billboardGui.Parent = game.CoreGui

                local label = Instance.new("TextLabel")
                label.AnchorPoint = Vector2.new(0.5, 0.5)
                label.BackgroundTransparency = 1
                label.TextColor3 = color
                label.Size = UDim2.new(1, 0, 1, 0)
                label.Position = UDim2.new(0.5, 0, 0.5, 0)
                label.Text = name
                label.Parent = billboardGui

                task.spawn(function()
                    while billboardGui do
                        if not billboardGui.Adornee or not billboardGui.Adornee:IsDescendantOf(workspace) then
                            billboardGui:Destroy()
                            break
                        end
                        task.wait()
                    end
                end)
            end

            return {
                delete = function()
                    if boxAdornment then
                        boxAdornment:Destroy()
                    end
                    if billboardGui then
                        billboardGui:Destroy()
                    end
                end
            }
        end

        -- Function to check if an item should be added to ESP
        local function checkItem(item)
            if item:IsA("Model") and (item:GetAttribute("Pickup") or item:GetAttribute("PropType")) then
                task.wait(0.1)
                local part = item:FindFirstChild("Handle") or item:FindFirstChild("Prop")
                if part then
                    local espInstance = createESP(part, Color3.fromRGB(255, 255, 255), item.Name)
                    table.insert(espItems, espInstance)
                end
            end
        end

        -- Function to handle room setup
        local function setupRoom(room)
            local assets = room:FindFirstChild("Assets")
            if assets then
                local connection
                connection = assets.DescendantAdded:Connect(function(descendant)
                    checkItem(descendant)
                end)

                for _, descendant in ipairs(assets:GetDescendants()) do
                    checkItem(descendant)
                end

                task.spawn(function()
                    while isEspEnabled do
                        task.wait(1)
                    end
                    connection:Disconnect()
                end)
            end
        end

        if isEspEnabled then
            -- Set up ESP for existing and new rooms
            local roomAddedConnection
            roomAddedConnection = workspace.CurrentRooms.ChildAdded:Connect(function(room)
                setupRoom(room)
            end)

            for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
                setupRoom(room)
            end

            -- Monitor the toggle state
            task.spawn(function()
                while isEspEnabled do
                    task.wait(1)
                end
                roomAddedConnection:Disconnect()
                
                -- Clean up all ESP items
                for _, espInstance in ipairs(espItems) do
                    espInstance.delete()
                end
            end)
        else
            -- Clean up all ESP items if disabled
            for _, espInstance in ipairs(s) do
                espInstance.delete()
            end
        end
    end
})

section2:toggle({
    name = "Entity Message (Information)",
    def = false,
    callback = function(state)
        if state then
            -- Define variables
            local entityNames = {"RushMoving", "AmbushMoving", "Snare", "A60", "A120", "A90", "Eyes", "JeffTheKiller"}
            local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()
            local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()
            local plr = game.Players.LocalPlayer
            local running = true

            -- Function to notify entity spawn
            local function notifyEntitySpawn(entity)
                Notification:Notify(
                    {Title = "Entity Notification(White King)", Description = entity.Name:gsub("Moving", ""):lower() .. " Spawned!"},
                    {OutlineColor = Color3.fromRGB(80, 80, 80), Time = 5, Type = "image"},
                    {Image = "http://www.roblox.com/asset/?id=13327193518", ImageColor = Color3.fromRGB(1, 1, 1)}
                )
            end

            -- Function to handle new child entities
            local function onChildAdded(child)
                if table.find(entityNames, child.Name) then
                    -- Wait until the player is within 1000 studs or the entity is removed
                    repeat
                        task.wait()
                    until plr:DistanceFromCharacter(child:GetPivot().Position) < 1000 or not child:IsDescendantOf(workspace)

                    -- Notify if entity is still in workspace
                    if child:IsDescendantOf(workspace) then
                        notifyEntitySpawn(child)
                    end
                end
            end

            -- Start monitoring for new entities
            local connection = workspace.ChildAdded:Connect(onChildAdded)

            -- Monitor flag and stop the process if the flag is false
            task.spawn(function()
                while running do
                    task.wait(1) -- Adjust the wait time as needed
                    if not state then
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

section1:toggle({
    name = "book/paper ESP",
    def = false,
    callback = function(book)
        if book then
            book = {}
            local itemTypes = {
                LiveBreakerPolePickup = Color3.new(1, 0, 0),
                LiveHintBook = Color3.new(0, 1, 1)
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

            local function book()
                for name, color in pairs(book) do
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

            book()

            table.insert(book, esptable)
        else
            if book then
                for _, instance in pairs(book) do
                    for _, v in pairs(instance.book) do
                        v.delete()
                    end
                end
                book = nil
            end
        end
    end
})
