-- Super simpele UI - Dark grey + Bubble pop + Loading
-- LocalScript in ScreenGui

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================
-- SCREEN GUI
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SimpleUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- ============================================
-- WINDOW
-- ============================================
local window = Instance.new("Frame")
window.Name = "Window"
window.Size = UDim2.new(0, 380, 0, 240)
window.Position = UDim2.new(0.5, -190, 0.5, -120)
window.BackgroundColor3 = Color3.fromRGB(42, 42, 46)
window.BorderSizePixel = 0
window.ClipsDescendants = true
window.Visible = false
window.ZIndex = 10
window.Parent = screenGui

local windowCorner = Instance.new("UICorner")
windowCorner.CornerRadius = UDim.new(0, 14)
windowCorner.Parent = window

-- ============================================
-- TOPBAR (draggable)
-- ============================================
local topbar = Instance.new("Frame")
topbar.Name = "Topbar"
topbar.Size = UDim2.new(1, 0, 0, 40)
topbar.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
topbar.BorderSizePixel = 0
topbar.ZIndex = 11
topbar.Parent = window

local topbarCorner = Instance.new("UICorner")
topbarCorner.CornerRadius = UDim.new(0, 14)
topbarCorner.Parent = topbar

-- Fix zodat de onderkant van de topbar recht is
local topbarFix = Instance.new("Frame")
topbarFix.Size = UDim2.new(1, 0, 0, 14)
topbarFix.Position = UDim2.new(0, 0, 1, -14)
topbarFix.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
topbarFix.BorderSizePixel = 0
topbarFix.ZIndex = 11
topbarFix.Parent = topbar

-- ============================================
-- CONTENT
-- ============================================
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, 0, 1, -40)
content.Position = UDim2.new(0, 0, 0, 40)
content.BackgroundColor3 = Color3.fromRGB(42, 42, 46)
content.BorderSizePixel = 0
content.ZIndex = 11
content.Parent = window

-- Loading tekst
local loadingText = Instance.new("TextLabel")
loadingText.Name = "LoadingText"
loadingText.Size = UDim2.new(1, 0, 0, 30)
loadingText.Position = UDim2.new(0, 0, 0.42, 0)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading..."
loadingText.Font = Enum.Font.GothamMedium
loadingText.TextSize = 18
loadingText.TextColor3 = Color3.fromRGB(180, 180, 185)
loadingText.TextTransparency = 1
loadingText.ZIndex = 12
loadingText.Parent = content

-- Dunne progress bar
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0.5, 0, 0, 4)
barBg.Position = UDim2.new(0.25, 0, 0.58, 0)
barBg.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
barBg.BorderSizePixel = 0
barBg.BackgroundTransparency = 1
barBg.ZIndex = 12
barBg.Parent = content

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1, 0)
barCorner.Parent = barBg

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(160, 160, 165)
barFill.BorderSizePixel = 0
barFill.ZIndex = 13
barFill.Parent = barBg

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = barFill

-- ============================================
-- DRAG (PC + Mobile)
-- ============================================
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

-- ============================================
-- START SEQUENCE
-- ============================================
local function start()
	-- Bubble pop-in
	window.Visible = true
	window.Size = UDim2.new(0, 0, 0, 0)
	window.Position = UDim2.new(0.5, 0, 0.5, 0)
	window.BackgroundTransparency = 1

	local pop = TweenService:Create(window, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 380, 0, 240),
		Position = UDim2.new(0.5, -190, 0.5, -120),
		BackgroundTransparency = 0
	})
	pop:Play()