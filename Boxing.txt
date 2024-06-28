-- Define global variables
_G.HeadSize = 4
_G.Disabled = true

-- Cache frequently used services
local RunService = game:GetService('RunService')
local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer

-- Ensure LocalPlayer is found
if not LocalPlayer then
    print("LocalPlayer not found!")
    return
end

-- Function to check and update enemy players' HumanoidRootPart properties
local function checkAndUpdatePlayer(player, localPlayerTeam)
    if player ~= LocalPlayer and player:GetAttribute("Team") ~= localPlayerTeam then
        local character = player.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local needsUpdate = false

                if humanoidRootPart.Size ~= Vector3.new(2, _G.HeadSize, 0) then
                    needsUpdate = true
                end
                if humanoidRootPart.Transparency ~= 0.7 then
                    needsUpdate = true
                end
                if humanoidRootPart.CanCollide ~= false then
                    needsUpdate = true
                end

                if needsUpdate then
                    humanoidRootPart.Size = Vector3.new(4, _G.HeadSize, 0)
                    humanoidRootPart.Transparency = 0.7
                    humanoidRootPart.CanCollide = false
                end
            end
        end
    end
end

-- Timer to control the frequency of updates
local lastUpdateTime = 0
local updateInterval = 10 -- seconds

-- Periodically check and update the hitboxes of enemy players
RunService.RenderStepped:Connect(function()
    local currentTime = tick()
    if _G.Disabled and (currentTime - lastUpdateTime >= updateInterval) then
        local localPlayerTeam = LocalPlayer:GetAttribute("Team")
        for _, player in ipairs(Players:GetPlayers()) do
            checkAndUpdatePlayer(player, localPlayerTeam)
        end
        lastUpdateTime = currentTime
    end
end)
