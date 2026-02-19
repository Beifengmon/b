local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
end)

local originalHeadScale = 1
local originalBodyScale = 1
local originalHSR = humanoid.HipHeight
local collisionOff = false

-- GUI 彩色渐变
local screen = Instance.new("ScreenGui")
screen.Name = "CollisionControl"
screen.Parent = player.PlayerGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 160, 0, 100)
main.Position = UDim2.new(0.02, 0, 0.2, 0)
main.BackgroundTransparency = 0.1
main.Active = true
main.Draggable = true
main.ClipsDescendants = true
main.Parent = screen

local gradient = Instance.new("UIGradient")
gradient.Rotation = 45
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(0.2, 0.3, 1)),
    ColorSequenceKeypoint.new(0.5, Color3.new(1, 0.2, 0.6)),
    ColorSequenceKeypoint.new(1, Color3.new(0.3, 1, 0.5))
})
gradient.Parent = main

-- 标题
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,22)
title.BackgroundTransparency = 1
title.Text = "碰撞箱控制"
title.TextColor3 = Color3.new(1,1,1)
title.TextStrokeTransparency = 0
title.TextSize = 14
title.Parent = main

-- 状态
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,0,0,20)
status.Position = UDim2.new(0,0,0,22)
status.BackgroundTransparency = 1
status.Text = "状态: 正常"
status.TextColor3 = Color3.new(1,1,1)
status.TextSize = 13
status.Parent = main

-- 按钮
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0,72,0,26)
toggleBtn.Position = UDim2.new(0.03,0,0,44)
toggleBtn.BackgroundTransparency = 0.3
toggleBtn.BackgroundColor3 = Color3.new(0.2,0.7,0.3)
toggleBtn.Text = "消失"
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Parent = main

local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0,72,0,26)
resetBtn.Position = UDim2.new(0.5,0,0,44)
resetBtn.BackgroundTransparency = 0.3
resetBtn.BackgroundColor3 = Color3.new(0.7,0.2,0.3)
resetBtn.Text = "恢复"
resetBtn.TextColor3 = Color3.new(1,1,1)
resetBtn.Parent = main

local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0,72,0,24)
miniBtn.Position = UDim2.new(0.03,0,0,74)
miniBtn.BackgroundTransparency = 0.4
miniBtn.BackgroundColor3 = Color3.new(0.2,0.2,0.4)
miniBtn.Text = "缩小UI"
miniBtn.TextColor3 = Color3.new(1,1,1)
miniBtn.Parent = main

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,72,0,24)
closeBtn.Position = UDim2.new(0.5,0,0,74)
closeBtn.BackgroundTransparency = 0.4
closeBtn.BackgroundColor3 = Color3.new(0.4,0.2,0.2)
closeBtn.Text = "关闭"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Parent = main

-- 渐变动画
RunService.Heartbeat:Connect(function()
    local t = tick() % 2 / 2
    local c1 = Color3.fromHSV(t, 1, 1)
    local c2 = Color3.fromHSV((t + 0.5) % 1, 1, 1)
    gradient.Color = ColorSequence.new(c1, c2)
end)

-- 功能
local isMinimized = false
miniBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        main.Size = UDim2.new(0, 50, 0, 30)
        title.Visible = false
        status.Visible = false
        toggleBtn.Visible = false
        resetBtn.Visible = false
        closeBtn.Visible = false
        miniBtn.Text = "打开"
    else
        main.Size = UDim2.new(0, 160, 0, 100)
        title.Visible = true
        status.Visible = true
        toggleBtn.Visible = true
        resetBtn.Visible = true
        closeBtn.Visible = true
        miniBtn.Text = "缩小UI"
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    collisionOff = true
    status.Text = "状态: 已消失"
    humanoid.HipHeight = 0
    humanoid.BodyWidthScale = 0
    humanoid.BodyDepthScale = 0
    humanoid.BodyHeightScale = 0
    humanoid.HeadScale = 0
    if rootPart then rootPart.Transparency = 1 end
end)

resetBtn.MouseButton1Click:Connect(function()
    collisionOff = false
    status.Text = "状态: 正常"
    humanoid.HipHeight = originalHSR
    humanoid.BodyWidthScale = 1
    humanoid.BodyDepthScale = 1
    humanoid.BodyHeightScale = 1
    humanoid.HeadScale = 1
    if rootPart then rootPart.Transparency = 0 end
end)

closeBtn.MouseButton1Click:Connect(function()
    collisionOff = false
    humanoid.HipHeight = originalHSR
    humanoid.BodyWidthScale = 1
    humanoid.BodyDepthScale = 1
    humanoid.BodyHeightScale = 1
    humanoid.HeadScale = 1
    if rootPart then rootPart.Transparency = 0 end
    screen:Destroy()
end)
