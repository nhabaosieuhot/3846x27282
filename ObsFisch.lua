local a=game.Workspace.active["OceanPOI's"].Mushgrove.CFrame.Position
local b=game.Workspace.active
local c=game.Workspace.active["OceanPOI's"]
local d=game.Workspace.Camera
local e=c:GetChildren()
local f={}
local g={}
local h={"Dark Art Skull","Giant Mushroom","Spiders Eye","Strange Root","Candy Corn"}
local i=getscreendimensions()
local j=20

for k,l in ipairs(e)do
    local m=Drawing.new("Text")
    m.Text=l.Name..string.format(" [Numpad[%d]]",k-1)
    m.Position={20,(i.y/2)+(k-1)*j}
    m.Color={0,255,0}
    m.Size=12
    m.Visible=true
    m.Outline=true
    m.OutlineColor={0,0,0}
    m.Font=2
    table.insert(g,l)
    table.insert(f,m)
end

local n=nil
local o=nil
local p={}
local q={["Models"]={}}
local r={}

local function s(t)
    for _,u in pairs(h)do
        if t==u then return true end
    end
    return false
end

local function v()
    while true do
        local w=tick()
        if not r.lastUpdate or w-r.lastUpdate>1 then
            r.items={}
            for _,x in ipairs(b:GetChildren())do
                if x.ClassName=="Model" and s(x.Name)then
                    table.insert(r.items,x)
                end
            end
            r.lastUpdate=w
        end
        for _,y in pairs(r.items)do
            local z=y:FindFirstChildOfClass("Part")or y:FindFirstChildOfClass("MeshPart")
            if z then
                if not q["Models"][y]then
                    q["Models"][y]={["PrimaryPart"]=z,["Drawing"]=Drawing.new("Text")}
                end
            end
        end
        wait(1)
    end
end

local function A(B)
    local C=(math.sin(math.rad(B))+1)*0.5
    local D=(math.sin(math.rad(B)+2)+1)*0.5
    local E=(math.sin(math.rad(B)+4)+1)*0.5
    return{C,D,E}
end

local F=0

local function G()
    while true do
        local H=game.Players.localPlayer.Character.HumanoidRootPart
        local I=false
        if n and not p[n]then
            if o and f[o]then
                f[o].Color={0,255,0}
            end
            f[n].Color={255,0,0}
            if o~=n and not I then
                local J=g[n].CFrame.Position+Vector3.new(0,150,0)
                H:SetPosition(J)
                I=true
            end
            o=n
        end
        for K,L in pairs(q.Models)do
            local M=L.PrimaryPart
            local N=L.Drawing
            if M and M.Parent then
                local O=M.CFrame.Position
                local P,Q=d:WorldToScreenPoint(O)
                local R=d.CFrame.Position
                local S=math.floor(math.sqrt((R.x-O.x)^2+(R.y-O.y)^2+(R.z-O.z)^2))
                if S then
                    F=(F+1)%360
                    local T=A(F)
                    N.Text=string.format("[%s]\nD: [%d]",M.Parent.Name,S)
                    N.Position={P.x,P.y}
                    N.Visible=Q
                    N.Size=12
                    N.Color=T
                    N.Center=true
                    N.Outline=true
                    N.Font=2
                    N.OutlineColor={0,0,0}
                end
            else
                N:Remove()
                q.Models[K]=nil
            end
        end
        wait()
    end
end

local function U()
    while wait(0.1)do
        local V=getpressedkeys()
        for _,W in pairs(V)do
            if W=="Numpad0"then n=1
            elseif W=="Numpad1"then n=2
            elseif W=="Numpad2"then n=3
            elseif W=="Numpad3"then n=4
            elseif W=="Numpad4"then n=5
            elseif W=="Numpad5"then n=6
            elseif W=="Numpad6"then n=7
            end
        end
    end
end

spawn(function()
    local X,Y=pcall(v)
    if not X then warn("Error in cachedthread: "..Y) end
end)

spawn(function()
    local X,Y=pcall(G)
    if not X then warn("Error in RenderThread: "..Y) end
end)

spawn(function()
    local X,Y=pcall(U)
    if not X then warn("Error in HandleKeys: "..Y) end
end)