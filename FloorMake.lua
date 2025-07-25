local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local guiName = "SimpleGui"
local hrp -- キャラリセット後に更新されるように外に出す

-- 足元に透明な地面を一瞬生成する関数
local function createTemporaryGround()
	if not hrp then return end

	local part = Instance.new("Part")
	part.Size = Vector3.new(6, 1, 6)
	part.Anchored = true
	part.CanCollide = true
	part.Transparency = 1
	part.Position = hrp.Position - Vector3.new(0, 3, 0)
	part.Name = "TempGround"
	part.Parent = workspace

	task.delay(0.1, function()
		if part then
			part:Destroy()
		end
	end)
end

-- GUIを作成する関数（リセット後にも呼ばれる）
local function createGui()
	-- 古いGUIがあれば削除
	local oldGui = playerGui:FindFirstChild(guiName)
	if oldGui then
		oldGui:Destroy()
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = guiName
	screenGui.ResetOnSpawn = false -- リセット時に消えないように！
	screenGui.Parent = playerGui

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 200, 0, 100)
	frame.Position = UDim2.new(0.5, -100, 0.5, -50)
	frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	frame.Draggable = true
	frame.Active = true
	frame.Parent = screenGui

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -20, 0, 40)
	button.Position = UDim2.new(0, 10, 0, 30)
	button.Text = "足元に地面を出す"
	button.Parent = frame

	button.MouseButton1Click:Connect(createTemporaryGround)
end

-- キャラが生成されたときにHumanoidRootPartを取得
local function onCharacterAdded(char)
	hrp = char:WaitForChild("HumanoidRootPart")
end

-- キャラが追加されたら処理（初回・リセット時）
player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then
	onCharacterAdded(player.Character)
end

-- GUIが削除されたら自動で再生成
playerGui.ChildRemoved:Connect(function(child)
	if child.Name == guiName then
		task.wait(0.2)
		createGui()
	end
end)

-- 最初のGUI生成
createGui()
