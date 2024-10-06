--Rivals Weapons Check
local Workspace = findfirstchild(Game, "Workspace - Client")
local ViewModels = findfirstchild(Workspace, "ViewModels")
local PlayersFolder = findfirstchild(Game, "Players - Client")
local localPlayer = getlocalplayer()
local camera = findfirstchildofclass(Workspace, "Camera")
local Mixed = {
    ["Models"] = {}
}

local function campos()
    return camera and getposition(camera)
end

local function NotFirstPerson(cheek)
    return getname(cheek) ~= "FirstPerson"
end

local function Coloring(check)
    if string.match(check, "Assault") then
        return {255,0,0}
    end
    return {255,255,255}
end

local function cachedthread()
    while true do
        local View = getchildren(ViewModels)
        local Players = getchildren(PlayersFolder)
        for i, data in ipairs(View) do
            if NotFirstPerson(data) then
                local text = getname(data)
                local Index = string.find(text, " ")
                local EndIndex = string.find(string.reverse(text), "-")
                local SlicedPlayer = string.sub(text, 1, Index - 1)
                local SlicedWeapon = string.sub(text, -EndIndex + 2)

                for _, player in ipairs(Players) do
                    if SlicedPlayer == getname(player) then
                        local Character = getcharacter(player)
                        if Character then
                            local HumanoidRootPart = findfirstchild(Character, "HumanoidRootPart")
                            if HumanoidRootPart then
                                local Humanoid = findfirstchild(Character, "Humanoid")
                                if Humanoid then
                                    local Health = gethealth(Humanoid)
                                    if Health then
                                        if Mixed["Models"][SlicedPlayer] then
                                            Mixed["Models"][SlicedPlayer]["Weapons"] = SlicedWeapon
                                            Mixed["Models"][SlicedPlayer]["Health"] = Health
                                        else

                                            Mixed["Models"][SlicedPlayer] = {
                                                ["PrimaryPart"] = HumanoidRootPart,
                                                ["Weapons"] = SlicedWeapon,
                                                ["Drawing"] = Drawing.new("Text"),
                                                ["Health"] = Health
                                            }
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        wait(3)
    end
end

local function renderThread()
    while true do
        for thing, data in pairs(Mixed.Models) do
            local primaryPart = data.PrimaryPart
            local Drawing = data.Drawing
            local Health = data.Health
            local SlicedWeapon = data.Weapons
            if primaryPart then
                local Parent = getparent(primaryPart)
                local camPos = campos()
                local Pos3D = getposition(primaryPart)
                if Pos3D and Parent then
                    local Pos2D, OnScreen = worldtoscreenpoint({Pos3D.x, Pos3D.y, Pos3D.z})
                    local dist = camPos and math.sqrt((camPos.x - Pos3D.x)^2 + (camPos.y - Pos3D.y)^2 + (camPos.z - Pos3D.z)^2) or 1e9
                    if dist <= 5000 then
                        Drawing.Visible = OnScreen
                        Drawing.Position = {Pos2D.x, Pos2D.y}                        
                        Drawing.Size = 12
                        Drawing.Text = string.format("[%s][%.0f]", SlicedWeapon , dist)
                        Drawing.Center = true
                        Drawing.Outline = true
                        Drawing.Color = {255,255,255}
                        Drawing.OutlineColor = Coloring(SlicedWeapon)
                    else
                        Mixed["Models"][thing] = nil
                        Drawing:Remove()
                    end
                else
                    Mixed["Models"][thing] = nil
                    Drawing:Remove()
                end

            else
                Drawing:Remove()
            end
        end
        wait()
    end
end

spawn(cachedthread)
spawn(renderThread)