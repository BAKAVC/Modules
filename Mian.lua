-- VHS Style UI - Topbar + Sidebar + Loading + Drag
-- LocalScript in ScreenGui

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================
-- SCREEN GUI
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VHS_UI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- ============================================
-- KLEUREN (VHS / CRT)
-- ============================================
local COLORS = {
	Background = Color3.fromRGB(12, 10, 18),
	Panel = Color3.fromRGB(18, 14, 28),
	Topbar = Color3.fromRGB(22, 16, 32),
	Sidebar = Color3.fromRGB(16, 12, 24),
	AccentGreen = Color3.fromRGB(0, 255, 140),
	AccentMagenta = Color3.fromRGB(255, 0, 170),
	AccentCyan = Color3.fromRGB(0, 230, 255),
	Text = Color3.fromRGB(230, 230, 240),
	TextDim = Color3.fromRGB(140, 130, 160),
	Scanline = Color3.fromRGB(0, 0, 0),
}

-- ============================================
-- LOADING SCREEN
-- ============================================
local loadingFrame = Instance.new("Frame")
loadingFrame.Name = "LoadingScreen"
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.BackgroundColor3 = COLORS.Background
loadingFrame.BorderSizePixel = 0
loadingFrame.ZIndex = 100
loadingFrame.Parent = screenGui

-- Scanline overlay
local scanline = Instance.new("Frame")
scanline.Name = "Scanlines"
scanline.Size = UDim2.new(1, 0, 1, 0)
scanline.BackgroundTransparency = 1
scanline.ZIndex = 101
scanline.Parent = loadingFrame

local scanlineGradient = Instance.new("UIGradient")
scanlineGradient.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.85),
	NumberSequenceKeypoint.new(0.5, 0.95),
	NumberSequenceKeypoint.new(1, 0.85)
})
scanlineGradient.Rotation = 90
scanlineGradient.Parent = scanline

-- Loading title
local loadTitle = Instance.new("TextLabel")
loadTitle.Name = "Title"
loadTitle.Size = UDim2.new(1, 0, 0, 60)
loadTitle.Position = UDim2.new(0, 0, 0.38, 0)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = "VHS SYSTEM"
loadTitle.Font = Enum.Font.Code
loadTitle.TextSize = 42
loadTitle.TextColor3 = COLORS.AccentGreen
loadTitle.TextStrokeTransparency = 0.6
loadTitle.TextStrokeColor3 = COLORS.AccentMagenta
loadTitle.ZIndex = 102
loadTitle.Parent = loadingFrame

-- Subtitle
local loadSub = Instance.new("TextLabel")
loadSub.Size = UDim2.new(1, 0, 0, 30)
loadSub.Position = UDim2.new(0, 0, 0.48, 0)
loadSub.BackgroundTransparency = 1
loadSub.Text = "INITIALIZING INTERFACE..."
loadSub.Font = Enum.Font.Code
loadSub.TextSize = 16
loadSub.TextColor3 = COLORS.AccentCyan
loadSub.ZIndex = 102
loadSub.Parent = loadingFrame

-- Progress bar background
local progressBg = Instance.new("Frame")
progressBg.Size = UDim2.new(0.4, 0, 0, 8)
progressBg.Position = UDim2.new(0.3, 0, 0.58, 0)
progressBg.BackgroundColor3 = Color3.fromRGB(30, 25, 45)
progressBg.BorderSizePixel = 0
progressBg.ZIndex = 102
progressBg.Parent = loadingFrame

local progressCorner = Instance.new("UICorner")
progressCorner.CornerRadius = UDim.new(0, 4)
progressCorner.Parent = progressBg

-- Progress fill
local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = COLORS.AccentGreen
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 103
progressFill.Parent = progressBg

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 4)
fillCorner.Parent = progressFill

-- Glitch text
local glitchLabel = Instance.new("TextLabel")
glitchLabel.Size = UDim2.new(1, 0, 0, 20)
glitchLabel.Position = UDim2.new(0, 0, 0.68, 0)
glitchLabel.BackgroundTransparency = 1
glitchLabel.Text = ""
glitchLabel.Font = Enum.Font.Code
glitchLabel.TextSize = 14
glitchLabel.TextColor3 = COLORS.AccentMagenta
glitchLabel.ZIndex = 102
glitchLabel.Parent = loadingFrame

-- ============================================
-- MAIN UI CONTAINER (draggable)
-- ============================================
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 720, 0, 480)
mainContainer.Position = UDim2.new(0.5, -360, 0.5, -240)
mainContainer.BackgroundColor3 = COLORS.Panel
mainContainer.BorderSizePixel = 0
mainContainer.Visible = false
mainContainer.ClipsDescendants = true
mainContainer.ZIndex = 10
mainContainer.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainContainer

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = COLORS.AccentGreen
mainStroke.Thickness = 2
mainStroke.Transparency = 0.3
mainStroke.Parent = mainContainer

-- ============================================
-- TOPBAR
-- ============================================
local topbar = Instance.new("Frame")
topbar.Name = "Topbar"
topbar.Size = UDim2.new(1, 0, 0, 48)
topbar.BackgroundColor3 = COLORS.Topbar
topbar.BorderSizePixel = 0
topbar.ZIndex = 11
topbar.Parent = mainContainer

local topbarCorner = Instance.new("UICorner")
topbarCorner.CornerRadius = UDim.new(0, 10)
topbarCorner.Parent = topbar

-- Fix bottom corners of topbar
local topbarFix = Instance.new("Frame")
topbarFix.Size = UDim2.new(1, 0, 0, 12)
topbarFix.Position = UDim2.new(0, 0, 1, -12)
topbarFix.BackgroundColor3 = COLORS.Topbar
topbarFix.BorderSizePixel = 0
topbarFix.ZIndex = 11
topbarFix.Parent = topbar

-- Title in topbar
local topTitle = Instance.new("TextLabel")
topTitle.Size = UDim2.new(0, 200, 1, 0)
topTitle.Position = UDim2.new(0, 16, 0, 0)
topTitle.BackgroundTransparency = 1
topTitle.Text = "◆ VHS CONTROL"
topTitle.Font = Enum.Font.Code
topTitle.TextSize = 18
topTitle.TextColor3 = COLORS.AccentGreen
topTitle.TextXAlignment = Enum.TextXAlignment.Left
topTitle.ZIndex = 12
topTitle.Parent = topbar

-- Status indicator
local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 10, 0, 10)
statusDot.Position = UDim2.new(1, -40, 0.5, -5)
statusDot.BackgroundColor3 = COLORS.AccentGreen
statusDot.BorderSizePixel = 0
statusDot.ZIndex = 12
statusDot.Parent = topbar

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(1, 0)
statusCorner.Parent = statusDot

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -48, 0.5, -18)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 40)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.Code
closeBtn.TextSize = 18
closeBtn.TextColor3 = COLORS.AccentMagenta
closeBtn.ZIndex = 12
closeBtn.Parent = topbar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- ============================================
-- SIDEBAR
-- ============================================
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 180, 1, -48)
sidebar.Position = UDim2.new(0, 0, 0, 48)
sidebar.BackgroundColor3 = COLORS.Sidebar
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 11
sidebar.Parent = mainContainer

local sidebarStroke = Instance.new("UIStroke")
sidebarStroke.Color = Color3.fromRGB(40, 30, 60)
sidebarStroke.Thickness = 1
sidebarStroke.Transparency = 0.5
sidebarStroke.Parent = sidebar

-- Sidebar buttons
local menuItems = {
	{name = "DASHBOARD", icon = "▣"},
	{name = "PLAYERS", icon = "◎"},
	{name = "SETTINGS", icon = "⚙"},
	{name = "LOGS", icon = "≡"},
	{name = "ABOUT", icon = "◆"},
}

local selectedButton = nil

for i, item in ipairs(menuItems) do
	local btn = Instance.new("TextButton")
	btn.Name = item.name
	btn.Size = UDim2.new(1, -16, 0, 42)
	btn.Position = UDim2.new(0, 8, 0, 12 + (i-1) * 50)
	btn.BackgroundColor3 = Color3.fromRGB(28, 22, 40)
	btn.Text = item.icon .. "  " .. item.name
	btn.Font = Enum.Font.Code
	btn.TextSize = 14
	btn.TextColor3 = COLORS.TextDim
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.ZIndex = 12
	btn.Parent = sidebar

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = btn

	local btnPadding = Instance.new("UIPadding")
	btnPadding.PaddingLeft = UDim.new(0, 12)
	btnPadding.Parent = btn

	btn.MouseEnter:Connect(function()
		if selectedButton ~= btn then
			TweenService:Create(btn, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(40, 30, 55),
				TextColor3 = COLORS.AccentCyan
			}):Play()
		end
	end)

	btn.MouseLeave:Connect(function()
		if selectedButton ~= btn then
			TweenService:Create(btn, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(28, 22, 40),
				TextColor3 = COLORS.TextDim
			}):Play()
		end
	end)

	btn.MouseButton1Click:Connect(function()
		if selectedButton then
			TweenService:Create(selectedButton, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(28, 22, 40),
				TextColor3 = COLORS.TextDim
			}):Play()
		end
		selectedButton = btn
		TweenService:Create(btn, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(0, 80, 50),
			TextColor3 = COLORS.AccentGreen
		}):Play()
	end)

	if i == 1 then
		selectedButton = btn
		btn.BackgroundColor3 = Color3.fromRGB(0, 80, 50)
		btn.TextColor3 = COLORS.AccentGreen
	end
end

-- ============================================
-- CONTENT AREA
-- ============================================
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -180, 1, -48)
content.Position = UDim2.new(0, 180, 0, 48)
content.BackgroundColor3 = COLORS.Background
content.BorderSizePixel = 0
content.ZIndex = 11
content.Parent = mainContainer

local contentTitle = Instance.new("TextLabel")
contentTitle.Size = UDim2.new(1, -40, 0, 40)
contentTitle.Position = UDim2.new(0, 20, 0, 20)
contentTitle.BackgroundTransparency = 1
contentTitle.Text = "SYSTEM ONLINE"
contentTitle.Font = Enum.Font.Code
contentTitle.TextSize = 28
contentTitle.TextColor3 = COLORS.AccentCyan
contentTitle.TextXAlignment = Enum.TextXAlignment.Left
contentTitle.ZIndex = 12
contentTitle.Parent = content

local contentDesc = Instance.new("TextLabel")
contentDesc.Size = UDim2.new(1, -40, 0, 80)
contentDesc.Position = UDim2.new(0, 20, 0, 70)
contentDesc.BackgroundTransparency = 1
contentDesc.Text = "Welcome to the VHS Control Interface.\nDrag the window anywhere on screen.\nWorks on both PC and Mobile."
contentDesc.Font = Enum.Font.Code
contentDesc.TextSize = 15
contentDesc.TextColor3 = COLORS.TextDim
contentDesc.TextXAlignment = Enum.TextXAlignment.Left
contentDesc.TextYAlignment = Enum.TextYAlignment.Top
contentDesc.ZIndex = 12
contentDesc.Parent = content

-- Decorative lines
local line1 = Instance.new("Frame")
line1.Size = UDim2.new(0.6, 0, 0, 2)
line1.Position = UDim2.new(0, 20, 0, 160)
line1.BackgroundColor3 = COLORS.AccentMagenta
line1.BorderSizePixel = 0
line1.ZIndex = 12
line1.Parent = content

local line2 = Instance.new("Frame")
line2.Size = UDim2.new(0.4, 0, 0, 2)
line2.Position = UDim2.new(0, 20, 0, 172)
line2.BackgroundColor3 = COLORS.AccentGreen
line2.BorderSizePixel = 0
line2.ZIndex = 12
line2.Parent = content

-- ============================================
-- DRAG FUNCTIONALITY (PC + Mobile)
-- ============================================
local dragging = false
local dragStart = nil
local startPos = nil

local function updateDrag(input)
	local delta = input.Position - dragStart
	mainContainer.Position = UDim2.new(
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
		startPos = mainContainer.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

topbar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		if dragging then
			updateDrag(input)
		end
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		updateDrag(input)
	end
end)

-- ============================================
-- CLOSE BUTTON
-- ============================================
closeBtn.MouseButton1Click:Connect(function()
	local tween = TweenService:Create(mainContainer, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundTransparency = 1
	})
	tween:Play()
	tween.Completed:Wait()
	mainContainer.Visible = false
end)

-- ============================================
-- LOADING ANIMATION + INTRO
-- ============================================
local function playLoading()
	-- Fake progress
	local progress = 0
	local glitchTexts = {
		"LOADING MODULES...",
		"SYNCING CRT SIGNAL...",
		"DECODING VHS TRACK...",
		"APPLYING FILTERS...",
		"SYSTEM READY"
	}

	for i = 1, 100 do
		progress = i / 100
		progressFill.Size = UDim2.new(progress, 0, 1, 0)

		-- Glitch color flicker
		if i % 7 == 0 then
			loadTitle.TextColor3 = COLORS.AccentMagenta
			task.wait(0.03)
			loadTitle.TextColor3 = COLORS.AccentGreen
		end

		-- Update glitch text
		local idx = math.clamp(math.ceil(progress * #glitchTexts), 1, #glitchTexts)
		glitchLabel.Text = glitchTexts[idx]

		task.wait(0.018)
	end

	task.wait(0.3)

	-- Fade out loading
	TweenService:Create(loadingFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {
		BackgroundTransparency = 1
	}):Play()

	for _, child in ipairs(loadingFrame:GetDescendants()) do
		if child:IsA("TextLabel") or child:IsA("Frame") then
			TweenService:Create(child, TweenInfo.new(0.5), {
				BackgroundTransparency = 1,
				TextTransparency = 1
			}):Play()
		end
	end

	task.wait(0.55)
	loadingFrame.Visible = false

	-- Show main UI with nice intro animation
	mainContainer.Visible = true
	mainContainer.Size = UDim2.new(0, 0, 0, 0)
	mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
	mainContainer.BackgroundTransparency = 1

	-- Scale + fade in
	local introTween = TweenService:Create(mainContainer, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 720, 0, 480),
		Position = UDim2.new(0.5, -360, 0.5, -240),
		BackgroundTransparency = 0
	})
	introTween:Play()

	-- Subtle pulse on stroke
	task.spawn(function()
		for i = 1, 3 do
			TweenService:Create(mainStroke, TweenInfo.new(0.25), {Transparency = 0}):Play()
			task.wait(0.25)
			TweenService:Create(mainStroke, TweenInfo.new(0.25), {Transparency = 0.4}):Play()
			task.wait(0.25)
		end
	end)
end

-- Start everything
playLoading()