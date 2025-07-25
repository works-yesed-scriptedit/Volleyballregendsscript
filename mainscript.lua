local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = Workspace.CurrentCamera

-- GUI作成
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.Name = "TeleportToggleGui"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.7, 0)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, -20, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 30)
toggleButton.Text = "テレポート: OFF"
toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleButton.Parent = frame

-- トグル状態
local toggled = false

-- HumanoidRootPart取得
local function getHRP()
	local character = player.Character
	return character and character:FindFirstChild("HumanoidRootPart")
end

-- CLIENT_BALL_数字 のちょっと下の位置を取得
local function getTargetPosition()
	for _, obj in ipairs(workspace:GetChildren()) do
		if obj:IsA("Model") and obj.Name:match("^CLIENT_BALL_%d+$") then
			local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
			if primary then
				return primary.Position - Vector3.new(0, 2, 0)
			end
		end
	end
end

-- 毎フレームテレポート制御
RunService.RenderStepped:Connect(function()
	if not toggled then return end
	local hrp = getHRP()
	local targetPos = getTargetPosition()
	if hrp and targetPos then
		local lookVector = Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z).Unit
		local newCFrame = CFrame.new(targetPos, targetPos + lookVector)
		hrp.CFrame = newCFrame
	end
end)

-- トグルボタン切り替え
toggleButton.MouseButton1Click:Connect(function()
	toggled = not toggled
	if toggled then
		toggleButton.Text = "テレポート: ON"
		toggleButton.BackgroundColor3 = Color3.fromRGB(100, 150, 100)
	else
		toggleButton.Text = "テレポート: OFF"
		toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	end
end)local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = Workspace.CurrentCamera

local function getHRP()
	return character and character:FindFirstChild("HumanoidRootPart")
end

local function getTargetCFrame()
	for _, obj in ipairs(workspace:GetChildren()) do
		if obj:IsA("Model") and obj.Name:match("^CLIENT_BALL_%d+$") then
			local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
			if primary then
				-- ボールの位置のちょっと下（Y-2）
				local pos = primary.Position - Vector3.new(0, 2, 0)
				return pos
			end
		end
	end
end

-- 毎フレーム実行
RunService.RenderStepped:Connect(function()
	local hrp = getHRP()
	local targetPos = getTargetCFrame()
	if hrp and targetPos then
		-- 視点（カメラ）の向きをY軸だけ抽出してHumanoidRootPartに適用
		local lookVector = Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z).Unit
		local newCFrame = CFrame.new(targetPos, targetPos + lookVector)
		hrp.CFrame = newCFrame
	end
end)
