local function getCasting()
    while true do
        local Character = game.Players.localPlayer.Character
        if Character then
            local Tool = Character:FindFirstChildOfClass("Tool")
            if Tool and Tool:FindFirstChild("values") then
                local casted = Tool.values:FindFirstChild("casted")
                if casted and string.match(Tool.Name, "Rod") and casted.Value ~= true then
                    mouse1press()
                    local power = Character.HumanoidRootPart:FindFirstChild("power")
                    if power then
                        local powerbar = power:FindFirstChild("powerbar")
                        if powerbar then
                            local bar = powerbar:FindFirstChild("bar")
                            local perfect_value = bar:GetMemoryValue(0x308, "float")
                            if perfect_value >= 0.98 and perfect_value <= 1 then
                                mouse1release()
                            end
                        end
                    end
                end
            end
        end
        wait()
    end
end

local function Shake()
    while true do
        local PlayerGui = game.Players.localPlayer:FindFirstChild("PlayerGui")
        if PlayerGui then
            local shakeui = PlayerGui:FindFirstChild("shakeui")
            local backslashpressed = false
            if shakeui then
                if not backslashpressed then
                    keypress(0xDC)
                    backslashpressed = true
                end
                
                keypress(0x53)    
                keyrelease(0x53)
                
                keypress(0x0D)    
                keyrelease(0x0D)
                
                wait(0.01)
            else
                keyrelease(0xDC)
            end
        end
        wait()
    end
end

local function Reeling()
    local cached = tick() 
    
    while true do
        local playerGui = game.Players.localPlayer:FindFirstChild("PlayerGui")
        local current = tick()
        
        if playerGui then
            local reel = playerGui:FindFirstChild("reel")
            if reel and reel:FindFirstChild("bar") then
                if current - cached > 3 then
                    print("Working [Ignore]")
                    local playerbar = reel.bar:FindFirstChild("playerbar")
                    
                    if playerbar then
                        local fish = reel.bar:FindFirstChild("fish")
                        if fish then
                            local fishX = fish:GetMemoryValue(0x2f0, "float")
                            if fishX then
                                local clampedX = math.clamp(fishX, 0.15, 0.9)
                                playerbar:SetMemoryValue(0x2f0, "float", clampedX)
                            else
                                print("Failed to get fishbar Value")
                            end
                        else
                            print("Failed to find fishbar")
                        end
                    else
                        print("Failed to find playerbar")
                    end
                end
            else
                print("Failed Find ReelUI [Ignore if haven't got into Reeling part]")
                cached = current
            end
        else
            print("Failed to find PlayerUI")
            cached = current
        end
        wait()
    end
end


local success, error = pcall(function() 
    spawn(getCasting)
end)
if not success then
    print("Casting Error:", error)
end

success, error = pcall(function()
    spawn(Shake)
end)
if not success then
    print("Shake Error:", error)
end

success, error = pcall(function()
    spawn(Reeling)
end)
if not success then
    print("Reeling Error:", error)
end
