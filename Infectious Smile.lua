local library = loadstring(game:HttpGet("https://github.com/Drop56796/CreepyEyeHub/blob/main/Splix.lua?raw=true"))()

-- Create a new window
local window = library:new({
    textsize = 15,
    font = Enum.Font.Code,
    name = "Infectious Smile(White King)",
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

section3:toggle({
    name = "Add Toggle ui",
    def = false,
    callback = function(state)
        if state then
            -- 如果不存在 ScreenGui，则创建一个
            local gui = game:GetService("CoreGui"):FindFirstChild("ScreenGui")
            if not gui then
                gui = Instance.new("ScreenGui")
                gui.Name = "ScreenGui"
                gui.Parent = game:GetService("CoreGui")
            end

            -- 确保 GUI 是启用状态
            gui.Enabled = true

            -- 创建控制按钮的 GUI
            local toggleGuiScreen = Instance.new("ScreenGui")
            toggleGuiScreen.Name = "ToggleGuiScreen"
            toggleGuiScreen.Parent = game:GetService("CoreGui")

            local toggleButton = Instance.new("TextButton")
            toggleButton.Size = UDim2.new(0, 100, 0, 50)
            toggleButton.Position = UDim2.new(0, 50, 0, 200)
            toggleButton.Text = "Toggle GUI"
            toggleButton.Parent = toggleGuiScreen
            toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            toggleButton.TextColor3 = Color3.new(1, 1, 1)

            -- Toggle 功能
            local function toggleGui()
                gui.Enabled = not gui.Enabled
            end

            toggleButton.MouseButton1Click:Connect(toggleGui)
        else
            -- 关闭/隐藏UI
            local gui = game:GetService("CoreGui"):FindFirstChild("ToggleGuiScreen")
            if gui then
                gui.Enabled = false
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

section1:toggle({
    name = "Player esp",
    def = false,
    callback = function(state)
        if state then
            _G.aespInstances = {}
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character then
                    local aespInstance = esp(player.Character, Color3.new(1, 0, 0), player.Character:FindFirstChild("HumanoidRootPart"), player.Name)
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

local isFOVControlEnabled = false
local isSpeedControlEnabled = false
local fovValue = 70
local speedValue = 1

-- 创建视野控制切换开关和滑块
section2:toggle({
    name = "Enable FOV",
    def = false,
    callback = function(state)
        isFOVControlEnabled = state
        -- 根据切换开关的状态来设置视野
        if isFOVControlEnabled then
            game:GetService("Workspace").CurrentCamera.FieldOfView = fovValue
        else
            -- 可以选择重置为默认值或者保持当前值
            -- 这里我们保持当前值，不做重置
        end
    end
})

-- 创建视野调节滑块
section2:slider({
    name = "FOV",
    def = 70,
    max = 120,
    min = 70,
    rounding = true,
    callback = function(value)
        fovValue = value
        if isFOVControlEnabled then
            -- 如果视野控制启用，更新视野
            game:GetService("Workspace").CurrentCamera.FieldOfView = fovValue
        end
    end
})

-- 创建速度控制切换开关和滑块
section2:toggle({
    name = "Enable Speed",
    def = false,
    callback = function(state)
        isSpeedControlEnabled = state
        -- 根据切换开关的状态来设置速度
        if isSpeedControlEnabled then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speedValue
        else
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16  -- 重置为默认速度
        end
    end
})

-- 创建速度调节滑块
section2:slider({
    name = "Speed",
    def = 20,
    max = 22,
    min = 20,
    rounding = true,
    callback = function(value)
        speedValue = value
        if isSpeedControlEnabled then
            -- 如果速度控制启用，更新速度
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speedValue
        end
    end
})

section1:toggle({
    name = "Coin esp",
    def = false,
    callback = function(state)
        if state then
            _G.DooDoorInstances = {}
            local DooDoorItems = {
                SmileCoin = Color3.new(1, 0.5, 0)  -- Orange color for DooDoor
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
