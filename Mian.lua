-- Minimal VHS UI - Centered + Draggable Topbar + Loading inside
-- LocalScript in ScreenGui

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================
-- KLEUREN
-- ============================================
local COLORS = {
	Background = Color3.fromRGB(14, 12, 20),
	Panel = Color3.fromRGB(18, 15, 28),
	Topbar = Color3.fromRGB(24, 18, 36),
	AccentGreen = Color3.fromRGB(0, 255, 140),
	AccentMagenta = Color3.fromRGB(255, 0, 170),
	AccentCyan = Color3.fromRGB(0, 230, 255),
	Text = Color3.fromRGB(230, 230, 240),
	TextDim = Color3.fromRGB(130, 120, 150),
}

-- ============================================
-- SCREEN GUI
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VHS_Minimal"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- ============================================
-- MAIN WINDOW (klein + centered)
-- ============================================
local window = Instance.new("Frame")
window.Name = "Window"
window.Size = UDim2.new(0, 420, 0, 280)
window.Position = UDim2.new(0.5, -210, 0.5, -140)
window.BackgroundColor3 = COLORS.Panel
window.BorderSizePixel = 0
window.ClipsDescendants = true
window.Visible = false
window.ZIndex = 10
window.Parent = screenGui

local windowCorner = Instance.new("UICorner")
windowCorner.CornerRadius = UDim.new(0, 10)
windowCorner.Parent = window

local windowStroke = Instance.new("UIStroke")
windowStroke.Color = COLORS.AccentGreen
windowStroke.Thickness = 2
windowStroke.Transparency = 0.35
windowStroke.Parent = window

-- ============================================
-- TOPBAR (draggable)
-- ============================================
local topbar = Instance.new("Frame")
topbar.Name = "Topbar"
topbar.Size = UDim2.new(1, 0, 0, 42)
topbar.BackgroundColor3 = COLORS.Topbar
topbar.BorderSizePixel = 0
topbar.ZIndex = 11
topbar.Parent = window

local topbarCorner = Instance.new("UICorner")
topbarCorner.CornerRadius = UDim.new(0, 10)
topbarCorner.Parent = topbar

-- Fix bottom of topbar
local topbarFix = Instance.new("Frame")
topbarFix.Size = UDim2.new(1, 0, 0, 12)
topbarFix.Position = UDim2.new(0, 0, 1, -12)
topbarFix.BackgroundColor3 = COLORS.Topbar
topbarFix.BorderSizePixel = 0
topbarFix.ZIndex = 11
topbarFix.Parent = topbar

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 14, 0, 0)
title.BackgroundTransparency = 1
title.Text = "◆ VHS SYSTEM"
title.Font = Enum.Font.Code
title.TextSize = 16
title.TextColor3 = COLORS.AccentGreen
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 12
title.Parent = topbar

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -38, 0.5, -16)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 40)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.Code
closeBtn.TextSize = 16
closeBtn.TextColor3 = COLORS.AccentMagenta
closeBtn.ZIndex = 12
closeBtn.Parent = topbar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- ============================================
-- CONTENT AREA (waar de loading speelt)
-- ============================================
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, 0, 1, -42)
content.Position = UDim2.new(0, 0, 0, 42)
content.BackgroundColor3 = COLORS.Background
content.BorderSizePixel = 0
content.ZIndex = 11
content.Parent = window

-- Loading elements (binnen het venster)
local loadTitle = Instance.new("TextLabel")
loadTitle.Size = UDim2.new(1, 0, 0, 30)
loadTitle.Position = UDim2.new(0, 0, 0.28, 0)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = "LOADING..."
loadTitle.Font = Enum.Font.Code
loadTitle.TextSize = 20
loadTitle.TextColor3 = COLORS.AccentCyan
loadTitle.ZIndex = 12
loadTitle.Parent = content

local progressBg = Instance.new("Frame")
progressBg.Size = UDim2.new(0.7, 0, 0, 6)
progressBg.Position = UDim2.new(0.15, 0, 0.48, 0)
progressBg.BackgroundColor3 = Color3.fromRGB(30, 25, 45)
progressBg.BorderSizePixel = 0
progressBg.ZIndex = 12
progressBg.Parent = content

local progressCorner = Instance.new("UICorner")
progressCorner.CornerRadius = UDim.new(0, 3)
progressCorner.Parent = progressBg

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = COLORS.AccentGreen
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 13
progressFill.Parent = progressBg

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 3)
fillCorner.Parent = progressFill

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, 0, 0, 20)
statusText.Position = UDim2.new(0, 0, 0.62, 0)
statusText.BackgroundTransparency = 1
statusText.Text = ""
statusText.Font = Enum.Font.Code
statusText.TextSize = 13
statusText.TextColor3 = COLORS.AccentMagenta
statusText.ZIndex = 12
statusText.Parent = content

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
-- CLOSE
-- ============================================
closeBtn.MouseButton1Click:Connect(function()
	local t = TweenService:Create(window, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundTransparency = 1
	})
	t:Play()
	t.Completed:Wait()
	window.Visible = false
end)

-- ============================================
-- LOADING + INTRO ANIMATIE
-- ============================================
local function start()
	-- Eerst het venster laten verschijnen met animatie
	window.Visible = true
	window.Size = UDim2.new(0, 0, 0, 0)
	window.Position = UDim2.new(0.5, 0, 0.5, 0)
	window.BackgroundTransparency = 1

	local intro = TweenService:Create(window, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 420, 0, 280),
		Position = UDim2.new(0.5, -210, 0.5, -140),
		BackgroundTransparency = 0
	})
	intro:Play()
	intro.Completed:Wait()

	-- Loading animatie binnen het venster
	local messages = {
		"INITIALIZING...",
		"LOADING MODULES...",
		"SYNCING SIGNAL...",
		"READY"
	}

	for i = 1, 100 do
		local p = i / 100
		progressFill.Size = UDim2.new(p, 0, 1, 0)

		-- Glitch flicker
		if i % 8 == 0 then
			loadTitle.TextColor3 = COLORS.AccentMagenta
			task.wait(0.025)
			loadTitle.TextColor3 = COLORS.AccentCyan
		end

		local idx = math.clamp(math.ceil(p * #messages), 1, #messages)
		statusText.Text = messages[idx]

		task.wait(0.016)
	end

	task.wait(0.25)

	-- Loading weg + klaar tekst
	TweenService:Create(loadTitle, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
	TweenService:Create(progressBg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
	TweenService:Create(progressFill, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
	TweenService:Create(statusText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()

	task.wait(0.35)

	-- Eindtekst
	local ready = Instance.new("TextLabel")
	ready.Size = UDim2.new(1, 0, 0, 40)
	ready.Position = UDim2.new(0, 0, 0.4, 0)
	ready.BackgroundTransparency = 1
	ready.Text = "SYSTEM ONLINE"
	ready.Font = Enum.Font.Code
	ready.TextSize = 22
	ready.TextColor3 = COLORS.AccentGreen
	ready.TextTransparency = 1
	ready.ZIndex = 12
	ready.Parent = content

	TweenService:Create(ready, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
end

start()