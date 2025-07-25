local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local character = player.Character or player.CharacterAdded:Wait()

local toggled = false
local guiName = "TeleportToggleGui"

-- キャラクターが変わったときに更新
player.CharacterAdded:Connect(function(char)
	character = char
end)

-- CLIENT_BALL_数字の下位置を取得
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

-- GUI作成
local function createGui()
	local playerGui = player:WaitForChild("PlayerGui")

	-- 二重生成を防ぐ
	local existing = playerGui:FindFirstChild(guiName)
	if existing then existing:Destroy() end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = guiName
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

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
	toggleButton.Text = toggled and "テレポート: ON" or "テレポート: OFF"
	toggleButton.BackgroundColor3 = toggled and Color3.fromRGB(100, 150, 100) or Color3.fromRGB(80, 80, 80)
	toggleButton.Parent = frame

	toggleButton.MouseButton1Click:Connect(function()
		toggled = not toggled
		toggleButton.Text = toggled and "テレポート: ON" or "テレポート: OFF"
		toggleButton.BackgroundColor3 = toggled and Color3.fromRGB(100, 150, 100) or Color3.fromRGB(80, 80, 80)
	end)
end

-- GUIが削除されたら再生成（これが安定性のカギ）
player:WaitForChild("PlayerGui").ChildRemoved:Connect(function(child)
	if child.Name == guiName then
		task.wait(0.2) -- GUI消去処理が完全に終わってから再生成
		createGui()
	end
end)

-- 最初のGUI生成
createGui()

-- 毎フレームテレポート制御
RunService.RenderStepped:Connect(function()
	if not toggled then return end

	local currentCharacter = character or player.Character
	local hrp = currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart")
	local targetPos = getTargetPosition()

	if hrp and targetPos then
		local lookVector = Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z).Unit
		local newCFrame = CFrame.new(targetPos, targetPos + lookVector)
		hrp.CFrame = newCFrame
	end
end)
