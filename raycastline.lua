local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LENGTH = 8
local WIDTH = 0.1
local HEIGHT = 0.1
local OFFSET_Y = 2 -- HRP の頭あたり
local COLOR = Color3.fromRGB(0, 255, 0)

local function createLaser(character)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local laser = Instance.new("Part")
    laser.Size = Vector3.new(WIDTH, HEIGHT, LENGTH)
    laser.Anchored = true
    laser.CanCollide = false
    laser.Color = COLOR
    laser.Material = Enum.Material.Neon
    laser.Name = "__LaserBar"
    laser.Parent = workspace

    RunService.RenderStepped:Connect(function()
        if not hrp.Parent then return end

        local startPos = hrp.Position + Vector3.new(0, OFFSET_Y, 0)
        local look = hrp.CFrame.LookVector

        -- 中心を HRP から L/2 後ろにずらす
        local center = startPos + look * (LENGTH / 2)
        laser.CFrame = CFrame.lookAt(center, startPos) -- startPos に向ける
    end)
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr.Character then createLaser(plr.Character) end
    plr.CharacterAdded:Connect(function(char)
        char:WaitForChild("HumanoidRootPart")
        createLaser(char)
    end)
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        char:WaitForChild("HumanoidRootPart")
        createLaser(char)
    end)
end)    beam.Width0 = WIDTH
    beam.Width1 = WIDTH
    beam.Color = COLOR
    beam.Transparency = NumberSequence.new(0) -- 濃い
    beam.FaceCamera = false
    beam.LightInfluence = 0
    beam.Segments = 1
    beam.Parent = hrp -- どこでも OK

    -- 位置更新
    RunService.RenderStepped:Connect(function()
        if not hrp.Parent then return end

        -- 頭の位置
        local origin = hrp.Position + Vector3.new(0, OFFSET_Y, 0)
        a1.Position = Vector3.new(0, OFFSET_Y, 0) -- ずっと同じ位置

        -- 前へ8スタッド
        local target = hrp.Position + Vector3.new(0, OFFSET_Y, 0) + hrp.CFrame.LookVector * RANGE
        endPart.CFrame = CFrame.new(target)
    end)
end

-- 全プレイヤーに適用
for _, plr in ipairs(Players:GetPlayers()) do
    if plr.Character then createBeam(plr.Character) end
    plr.CharacterAdded:Connect(function(char)
        char:WaitForChild("HumanoidRootPart")
        createBeam(char)
    end)
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        char:WaitForChild("HumanoidRootPart")
        createBeam(char)
    end)
end)

