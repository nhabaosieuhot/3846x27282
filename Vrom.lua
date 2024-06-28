-- Function to get the 'Vehicles' folder
local function getVehiclesFolder()
    return game:GetService("Workspace"):FindFirstChild("Vehicles")
end

-- Function to retrieve Team attribute from Metadata of a model
local function getModelTeamColor(model)
    local metadata = model:FindFirstChild("Metadata")
    if metadata then
        local teamAttribute = metadata:FindFirstChild("Team")
        if teamAttribute and teamAttribute:IsA("StringValue") then
            return teamAttribute.Value
        end
    end
    return nil
end

-- Function to process hitbox properties for enemies
local function processHitboxForEnemy(model)
    local hitbox = model:FindFirstChild("Hitbox")
    local vehicleBoundingBox = model:FindFirstChild("VehicleBoundingBox")
    if hitbox and hitbox:IsA("Part") and vehicleBoundingBox and vehicleBoundingBox:IsA("Part") then
        hitbox.Transparency = 0.5  -- Make hitbox semi-transparent
        hitbox.CanCollide = false  -- Ensure hitbox is not collidable
        hitbox.Rotation = vehicleBoundingBox.Rotation
        hitbox.Size = vehicleBoundingBox.Size
    end
end

-- Function to revert hitbox properties for allies
local function revertHitboxForAlly(model)
    local hitbox = model:FindFirstChild("Hitbox")
    if hitbox and hitbox:IsA("Part") then
        hitbox.Transparency = 1  -- Make hitbox fully transparent
        hitbox.CanCollide = false  -- Ensure hitbox is not collidable
        -- Optionally, reset other properties if needed
    end
end

-- Function to compare OriginalOwner with LocalPlayer and process models
local function processOwnerStatusAndHitbox()
    local localPlayer = game:GetService("Players").LocalPlayer
    if not localPlayer then
        return
    end
    
    local localPlayerTeam = localPlayer:GetAttribute("Team")
    local vehiclesFolder = getVehiclesFolder()
    if not vehiclesFolder then
        return
    end
    
    local models = vehiclesFolder:GetChildren()
    for _, model in ipairs(models) do
        if model:IsA("Model") then
            local modelTeamColor = getModelTeamColor(model)
            if modelTeamColor then
                if modelTeamColor == localPlayerTeam then
                    revertHitboxForAlly(model)
                else
                    processHitboxForEnemy(model)
                end
            end
        end
    end
    
    for _, model in ipairs(models) do
        if model:IsA("Model") then
            local originalOwner = model:FindFirstChild("OriginalOwner")
            if originalOwner and originalOwner:IsA("ObjectValue") then
                local originalOwnerValue = originalOwner.Value
                if originalOwnerValue and originalOwnerValue:IsA("Player") then
                    local ownerTeamColor = originalOwnerValue:GetAttribute("Team")
                    if ownerTeamColor then
                        -- Tag the model based on the owner's team color
                        local tag = (ownerTeamColor ~= localPlayerTeam) and "[Enemy]" or "[Ally]"
                    end
                end
            end
        end
    end
end

-- Main loop to continuously process hitboxes and owner statuses
while true do
    processOwnerStatusAndHitbox()
    wait(10)  -- Wait for 10 seconds before checking again
end
