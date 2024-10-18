local Ball = game.Workspace.Balls
local player = game.Players:GetChildren()[1]

local CLOSE_RANGE = 20
local MID_RANGE = 60
local MAX_DISTANCE = 120

local function campos()
    return player and player.Character:WaitForChild("HumanoidRootPart", 2e9).CFrame.Position
end

local function IsTarget()
    return (player.Character and player.Character:FindFirstChild("Highlight"))
end

local function isBallMovingTowardsPlayer(ballPos, ballVelocity, playerPos)
    if not playerPos then return false end
    
    local directionToPlayer = {
        x = playerPos.x - ballPos.x,
        y = playerPos.y - ballPos.y,
        z = playerPos.z - ballPos.z
    }

    local magnitude = math.sqrt(directionToPlayer.x^2 + directionToPlayer.y^2 + directionToPlayer.z^2)
    directionToPlayer.x = directionToPlayer.x / magnitude
    directionToPlayer.y = directionToPlayer.y / magnitude
    directionToPlayer.z = directionToPlayer.z / magnitude
    
    local velocityMagnitude = math.sqrt(ballVelocity.x^2 + ballVelocity.y^2 + ballVelocity.z^2)
    local normalizedVelocity = {
        x = ballVelocity.x / velocityMagnitude,
        y = ballVelocity.y / velocityMagnitude,
        z = ballVelocity.z / velocityMagnitude
    }
    
    local dotProduct = directionToPlayer.x * normalizedVelocity.x +
                       directionToPlayer.y * normalizedVelocity.y +
                       directionToPlayer.z * normalizedVelocity.z

    return dotProduct > 0.27
end

local function cachedthread()
    while true do
        local Exist = Ball:GetChildren()[1]
        if Exist then
            local campos = campos()
            if IsTarget() then
                local Distance = campos and math.sqrt((Exist.CFrame.Position.x - campos.x)^2 + (Exist.CFrame.Position.y - campos.y)^2 + (Exist.CFrame.Position.z - campos.z)^2) or 1e9
                local Velocity = math.sqrt(Exist.Velocity.x^2 + Exist.Velocity.y^2 + Exist.Velocity.z^2)

                if Distance <= CLOSE_RANGE then
                    if (Distance / Velocity) <= 0.6 then 
                        mouse1press()
                        wait(0.05)
                        mouse1release()
                    end
                elseif Distance <= MAX_DISTANCE then
                    if (Distance / Velocity) <= 0.473 and isBallMovingTowardsPlayer(Exist.CFrame.Position, Exist.Velocity, campos) then
                        mouse1press()
                        wait(0.1)
                        mouse1release()
                    end
                end
            end
        end
        wait()
    end
end

spawn(cachedthread)
