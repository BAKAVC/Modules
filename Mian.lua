local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SimpleUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local window = Instance.new("Frame")
window.Name = "Window"
window.Size = UDim2.new(0, 480, 0, 260)
window.Position = UDim2.new(0.5, -240, 0.5, -130)
window.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
window.BorderSizePixel = 0
window.ClipsDescendants = true
window.Visible = false
window.ZIndex = 10
window.Parent = screenGui

local windowCorner = Instance.new("UICorner")
windowCorner.CornerRadius = UDim.new(0, 14)
windowCorner.Parent = window

local topbar = Instance.new("Frame")
topbar.Name = "Topbar"
topbar.Size = UDim2.new(1, 0, 0, 40)
topbar.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
topbar.BorderSizePixel = 0
topbar.ZIndex = 12
topbar.Parent = window

local topbarCorner = Instance.new("UICorner")
topbarCorner.CornerRadius = UDim.new(0, 14)
topbarCorner.Parent = topbar

local topbarFix = Instance.new("Frame")
topbarFix.Size = UDim2.new(1, 0, 0, 20)
topbarFix.Position = UDim2.new(0, 0, 1, -20)
topbarFix.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
topbarFix.BorderSizePixel = 0
topbarFix.ZIndex = 12
topbarFix.Parent = topbar

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, 0, 1, -40)
content.Position = UDim2.new(0, 0, 0, 40)
content.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
content.BorderSizePixel = 0
content.ZIndex = 11
content.Parent = window

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 14)
contentCorner.Parent = content

local dragging = false
local dragStart = nil
local startPos = nil

local function update(input)
	local delta = input.Position - dragStart
	window.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

topbar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = window.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		update(input)
	end
end)

local function start()
	window.Visible = true
	window.Size = UDim2.new(0, 0, 0, 0)
	window.Position = UDim2.new(0.5, 0, 0.5, 0)
	window.BackgroundTransparency = 1

	task.wait(0.05)

	local pop = TweenService:Create(window, TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 480, 0, 260),
		Position = UDim2.new(0.5, -240, 0.5, -130),
		BackgroundTransparency = 0
	})
	pop:Play()
end

start()