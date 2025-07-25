local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ScreenGui作成
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui
screenGui.Name = "SimpleGui"

-- Frame作成
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Draggable = true     -- ← これだけでドラッグ可能に！
frame.Active = true       -- ドラッグに必要なので必ずtrueに
frame.Parent = screenGui

-- TextButton作成
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 40)
button.Position = UDim2.new(0, 10, 0, 30)
button.Text = "足元に地面を出す"
button.Parent = frame

-- 足元に透明な地面を一瞬生成
local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
if not hrp then
	player.CharacterAdded:Wait()
	hrp = player.Character:WaitForChild("HumanoidRootPart")
end

local function createTemporaryGround()
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

button.MouseButton1Click:Connect(createTemporaryGround)
