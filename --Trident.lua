--Trident
local Workspace = getchildren(Game)[1]
local camera = findfirstchild(Workspace, "Camera")
local Ignore = findfirstchild(Workspace, "Ignore")

local function IsModelAndCheck(check)
    if getclassname(check) == "Model" then
        return true
    end
    return nil
end

local function CheckPrimaryPart(check)
    local primaryPart = getprimarypart(check)
    
    if primaryPart then
        if getname(primaryPart) == "HumanoidRootPart" or getname(primaryPart) == "Pallets" then
            return primaryPart
        end
    end
    
    return nil
end

local function getCamPos()
    return camera and getposition(camera)
end

local Table = {
    ["Models"] = {}
}
local whatthesigma = {}

local function Heh()
    while wait(3) do
        local gettest = getchildren(Workspace)
        local falid = false
        if gettest then
            for i, v in ipairs(gettest) do
                table.insert(whatthesigma, v) 
                wait()
            end
            wait()
            table.clear(whatthesigma)                
        end
    end
end

local function cachedThread()
    while true do
        local sigma = getchildren(Ignore)
        for index, data in ipairs(whatthesigma) do
            if IsModelAndCheck(data) then
                local primaryPart = CheckPrimaryPart(data)
                if primaryPart then
                    if not Table["Models"][data] then
                        Table["Models"][data] = {
                            ["Part"] = primaryPart,
                            ["Drawing"] = Drawing.new("Text")
                        }
                    end
                end
            end            
            wait()
        end
        

        for index, data in ipairs(sigma) do
            if IsModelAndCheck(data) and getname(data) == "Model" then
                local primaryPart = CheckPrimaryPart(data)
                if primaryPart then
                    if not Table["Models"][data] then
                        Table["Models"][data] = {
                            ["Part"] = primaryPart,
                            ["Drawing"] = Drawing.new("Text")
                        }
                    end
                end
            end            
            wait()
        end
        
        wait(3)
    end
end


local function renderThread()
    while true do
        for thing, data in pairs(Table.Models) do
            local Part = data.Part
            local Drawing = data.Drawing
            if Part and (getclassname(Part) == "Part" or getclassname(Part) == "MeshPart") then 
                local Pos3D = getposition(Part)
                local Parent = getparent(Part)
                local camPos = getCamPos()
                local mousePos = getmouseposition()
                local Human = "Human"
                local AirDrop = "AirDrop"
                if Pos3D and Parent then
                    local Pos2D, OnScreen = worldtoscreenpoint({Pos3D.x, Pos3D.y, Pos3D.z})
                    local smoothMouse = smoothmouse_exponential({mousePos.x, mousePos.y}, {Pos2D.x, Pos2D.y}, 0.1)
                    local getclosetplayeronscreen = math.floor(math.sqrt((mousePos.x - Pos2D.x)^2 + (mousePos.y - Pos2D.y)^2))
                    local dist = camPos and math.sqrt((camPos.x - Pos3D.x)^2 + (camPos.y - Pos3D.y)^2 + (camPos.z - Pos3D.z)^2) or 1e9
                    if getclosetplayeronscreen <= 70 and getname(Part) == "HumanoidRootPart" then
                        mousemoverel(smoothMouse.x, smoothMouse.y + 1)
                    end
                    if dist <= 50000 then
                        Drawing.Visible = OnScreen
                        Drawing.Position = {Pos2D.x, Pos2D.y}                        
                        Drawing.Size = 12
                        Drawing.Center = true
                        Drawing.Outline = true
                        Drawing.Color = {255, 255, 255}
                        Drawing.OutlineColor = {0,0,0}
                        if getname(Part) == "Pallets" then
                            Drawing.Text = string.format("[%s] [%.0f]", AirDrop , dist)
                        else
                            Drawing.Text = string.format("[%s] [%.0f]", Human , dist)
                        end
                    else
                        Table["Models"][thing] = nil
                        Drawing:Remove()
                    end
                else
                    Table["Models"][thing] = nil
                    Drawing:Remove()
                end

            else
                Drawing:Remove()
            end
        end
        wait()
    end
end

spawn(Heh)
spawn(cachedThread)
spawn(renderThread)