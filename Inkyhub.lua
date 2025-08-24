-- Rayfield UI Loader
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "InkyHub [beta]",
    LoadingTitle = "Cargando Módulos...",
    LoadingSubtitle = "By Inknkmodz",
    ConfigurationSaving = {Enabled = true, FolderName = "SkylermodzConfig", FileName = "MainConfig"}
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local raycastModule = require(ReplicatedStorage.Events.Modules.RaycastModule)

local ESPConns = {}
local ESPObjects = {}

-- ==========================
-- Funciones de Utilidad
-- ==========================
function GetClosestPlayer()
    local closest, shortest = nil, math.huge
    for i,v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (v.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortest then
                shortest = dist
                closest = v
            end
        end
    end
    return closest
end

function AimAt(player)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, hrp.Position)
    end
end

-- ==========================
-- Aimbot Functions (con AimSilent real)
-- ==========================
getgenv().FOV = 180
getgenv().AimSilentEnabled = false

-- círculo de FOV para AimSilent
local fovCircle = Drawing.new("Circle")
fovCircle.Position = Camera.ViewportSize * 0.5
fovCircle.Visible = true
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Radius = getgenv().FOV
fovCircle.Thickness = 1
fovCircle.Transparency = 1
fovCircle.Filled = false
fovCircle.NumSides = 64

-- buscar jugador dentro del FOV
local function GetClosestPlayerFOV()
    local closest, closestDistance = nil, math.huge
    for _, player in Players:GetPlayers() do  
        if player == LocalPlayer or (player.Team == LocalPlayer.Team and LocalPlayer.Team ~= nil) then continue end  
        local character = player.Character  
        if not character then continue end  
        local rootPart = character:FindFirstChild("HumanoidRootPart")  
        if not rootPart then continue end  

        local screenPosition, onScreen = Camera:WorldToViewportPoint(rootPart.Position)  
        if not onScreen then continue end  

        local screenDistance = (Vector2.new(screenPosition.X, screenPosition.Y) - Camera.ViewportSize * 0.5).Magnitude  
        if screenPosition.Z > 0 and screenDistance < getgenv().FOV and screenDistance < closestDistance then  
            closest = character  
            closestDistance = screenDistance  
        end  
    end  
    return closest
end

-- hook del RaycastModule para AimSilent
for i, func in pairs(raycastModule) do
    if typeof(func) ~= "function" then continue end
    raycastModule[i] = function(...)  
        if not getgenv().AimSilentEnabled then
            return func(...)  
        end
        local closestPlayer = GetClosestPlayerFOV()  
        if not closestPlayer then
            return func(...)  
        end
        return closestPlayer.Head, closestPlayer.Head.Position, Vector3.zero  
    end
end

function EnableAimbot()
    return RunService.RenderStepped:Connect(function()
        local target = GetClosestPlayer()
        if target then AimAt(target) end
    end)
end

function EnableAimbot360()
    return RunService.RenderStepped:Connect(function()
        local target = GetClosestPlayer()
        if target then
            AimAt(target)
            -- Extra 360 logic
        end
    end)
end

function EnableAimFOV(fov)
    getgenv().FOV = fov
    fovCircle.Radius = fov
end

-- AimSilent toggle
function EnableAimSilent()
    getgenv().AimSilentEnabled = true
    return RunService.RenderStepped:Connect(function()
        fovCircle.Radius = getgenv().FOV
        fovCircle.Position = Camera.ViewportSize * 0.5
    end)
end

function DisableAimSilent()
    getgenv().AimSilentEnabled = false
end

function EnableAimbotLegit()
    return RunService.RenderStepped:Connect(function()
        local target = GetClosestPlayer()
        if target then
            -- Human-like aim movement logic
        end
    end)
end

-- ==========================
-- Movement Functions
-- ==========================
function EnableSpeedHack()
    return RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        if char then char.Humanoid.WalkSpeed = 50 end
    end)
end

function EnableFlyHack()
    return RunService.RenderStepped:Connect(function()
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Velocity = Vector3.new(0,0,0) end
    end)
end

function EnableFloatHack()
    return RunService.RenderStepped:Connect(function()
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Velocity = Vector3.new(0,5,0) end
    end)
end

function EnableJumpHack(power)
    return RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        if char then char.Humanoid.JumpPower = power*50 end
    end)
end

function UpMe()
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0,5,0) end
end

function DownMe()
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = hrp.CFrame - Vector3.new(0,5,0) end
end

function UpPlayers()
    for i,v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            v.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
        end
    end
end

function DownPlayers()
    for i,v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            v.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame - Vector3.new(0,5,0)
        end
    end
end

function Telekill()
    local target = GetClosestPlayer()
    if target then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
    end
end

function Aimkill()
    local target = GetClosestPlayer()
    if target then
        AimAt(target)
        -- Fire weapon logic placeholder
    end
end

function TPEnemy()
    local target = GetClosestPlayer()
    if target then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,0,2)
    end
end

-- ==========================
-- ESP Line
-- ==========================
function EnableESPLine()
    return RunService.RenderStepped:Connect(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if not ESPObjects[player] then ESPObjects[player] = {} end
                if not ESPObjects[player].Line then
                    local line = Drawing.new("Line")
                    line.Color = Color3.fromRGB(255,0,0)
                    line.Thickness = 2
                    ESPObjects[player].Line = line
                end
                local hrpPos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    ESPObjects[player].Line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    ESPObjects[player].Line.To = Vector2.new(hrpPos.X, hrpPos.Y)
                    ESPObjects[player].Line.Visible = true
                else
                    ESPObjects[player].Line.Visible = false
                end
            end
        end
    end)
end

-- ==========================
-- ESP Box
-- ==========================
function EnableESPBox()
    return RunService.RenderStepped:Connect(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if not ESPObjects[player] then ESPObjects[player] = {} end
                if not ESPObjects[player].Box then
                    local box = Drawing.new("Square")
                    box.Color = Color3.fromRGB(0,255,0)
                    box.Thickness = 2
                    box.Filled = false
                    ESPObjects[player].Box = box
                end
                local hrpPos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    ESPObjects[player].Box.Position = Vector2.new(hrpPos.X-25, hrpPos.Y-25)
                    ESPObjects[player].Box.Size = Vector2.new(50,50)
                    ESPObjects[player].Box.Visible = true
                else
                    ESPObjects[player].Box.Visible = false
                end
            end
        end
    end)
end

-- ==========================
-- ESP Skeleton
-- ==========================
function EnableESPSkeleton()
    return RunService.RenderStepped:Connect(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                if not ESPObjects[player] then ESPObjects[player] = {} end
                if not ESPObjects[player].Skeleton then ESPObjects[player].Skeleton = {} end

                local torso = player.Character:FindFirstChild("HumanoidRootPart")
                local head = player.Character:FindFirstChild("Head")
                if torso and head then
                    if not ESPObjects[player].Skeleton[1] then
                        local line = Drawing.new("Line")
                        line.Color = Color3.fromRGB(0,0,255)
                        line.Thickness = 2
                        ESPObjects[player].Skeleton[1] = line
                    end
                    local torsoPos, onScreen1 = Camera:WorldToViewportPoint(torso.Position)
                    local headPos, onScreen2 = Camera:WorldToViewportPoint(head.Position)
                    if onScreen1 and onScreen2 then
                        ESPObjects[player].Skeleton[1].From = Vector2.new(torsoPos.X, torsoPos.Y)
                        ESPObjects[player].Skeleton[1].To = Vector2.new(headPos.X, headPos.Y)
                        ESPObjects[player].Skeleton[1].Visible = true
                    else
                        ESPObjects[player].Skeleton[1].Visible = false
                    end
                end
            end
        end
    end)
end

-- ==========================
-- ESP Health
-- ==========================
function EnableESPHealth()
    return RunService.RenderStepped:Connect(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                if not ESPObjects[player] then ESPObjects[player] = {} end
                if not ESPObjects[player].HealthBar then
                    local bar = Drawing.new("Square")
                    bar.Color = Color3.fromRGB(255,255,0)
                    bar.Filled = true
                    ESPObjects[player].HealthBar = bar
                end
                local hum = player.Character.Humanoid
                local hrpPos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    ESPObjects[player].HealthBar.Position = Vector2.new(hrpPos.X-10, hrpPos.Y-40)
                    ESPObjects[player].HealthBar.Size = Vector2.new(20*(hum.Health/hum.MaxHealth),5)
                    ESPObjects[player].HealthBar.Visible = true
                else
                    ESPObjects[player].HealthBar.Visible = false
                end
            end
        end
    end)
end

-- ==========================
-- ESP Moco (Custom)
-- ==========================
function EnableESPMoco()
    return RunService.RenderStepped:Connect(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                if not ESPObjects[player] then ESPObjects[player] = {} end
                if not ESPObjects[player].Moco then
                    local circle = Drawing.new("Circle")
                    circle.Color = Color3.fromRGB(255,0,255)
                    circle.Radius = 5
                    circle.Thickness = 2
                    ESPObjects[player].Moco = circle
                end
                local hrpPos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    ESPObjects[player].Moco.Position = Vector2.new(hrpPos.X, hrpPos.Y)
                    ESPObjects[player].Moco.Visible = true
                else
                    ESPObjects[player].Moco.Visible = false
                end
            end
        end
    end)
end

-- ==========================
-- ESP Up/Down
-- ==========================
function EnableESPUpDown()
    return RunService.RenderStepped:Connect(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if not ESPObjects[player] then ESPObjects[player] = {} end
                if not ESPObjects[player].UpDown then
                    local text = Drawing.new("Text")
                    text.Size = 18
                    text.Center = true
                    text.Color = Color3.fromRGB(0,255,255)
                    ESPObjects[player].UpDown = text
                end
                local hrpPos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    local deltaY = player.Character.HumanoidRootPart.Position.Y - LocalPlayer.Character.HumanoidRootPart.Position.Y
                    ESPObjects[player].UpDown.Text = deltaY > 2 and "↑" or deltaY < -2 and "↓" or "•"
                    ESPObjects[player].UpDown.Position = Vector2.new(hrpPos.X, hrpPos.Y - 50)
                    ESPObjects[player].UpDown.Visible = true
                else
                    ESPObjects[player].UpDown.Visible = false
                end
            end
        end
    end)
end

-- ==========================
-- Extras funcionales
-- ==========================
function EnableRainbowESP()
    return RunService.RenderStepped:Connect(function()
        for _, player in pairs(Players:GetPlayers()) do
            if ESPObjects[player] and ESPObjects[player].Box then
                local r = tick()%5 / 5
                ESPObjects[player].Box.Color = Color3.fromHSV(r,1,1)
            end
        end
    end)
end

function EnableWallHack()
    -- WallHack logic
end

function EnableTPWall()
    -- Teleport through walls logic
end

-- ==========================
-- Combat / Fire Functions
-- ==========================
function EnableMagicBulletV1()
    -- Increase bullet range without breaking other functions
end

function EnableMagicBulletV2()
    -- Disable collision so bullets pass through walls
end

function EnableAutoFire()
    -- AutoFire within FOV logic
end

-- ==========================
-- Visual / Extras
-- ==========================
function EnableRainbowFOV()
    -- Change FOV color dynamically
end

function EnableRainbowESP()
    -- Rainbow ESP / box colors
end

function EnableChams3D()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp and not ESPObjects[player].Chams then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = player.Character
                highlight.FillColor = Color3.fromRGB(0,255,255)
                highlight.OutlineColor = Color3.fromRGB(0,0,0)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = game:GetService("CoreGui")
                ESPObjects[player].Chams = highlight
            end
        end
    end
end

function EnableBypassSpeedTP()
    -- Bypass speed hack using TP logic
end

function SetHitbox(size)
    for i,player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.Size = Vector3.new(size,size,size)
            hrp.CanCollide = false
        end
    end
end

-- Conexión para actualizar hitbox dinámicamente
function EnableHitbox(size)
    if _G.HitboxConn then _G.HitboxConn:Disconnect() end
    _G.HitboxConn = RunService.RenderStepped:Connect(function()
        SetHitbox(size)
    end)
end


-- ==========================
-- GUI Connections
-- ==========================
local AimbotTab = Window:CreateTab("Aimbot",4483362458)
AimbotTab:CreateToggle({Name="Aimbot",CurrentValue=false,Callback=function(v) if v then _G.AimbotConn=EnableAimbot() else if _G.AimbotConn then _G.AimbotConn:Disconnect() end end end})
AimbotTab:CreateToggle({Name="Aimbot 360",CurrentValue=false,Callback=function(v) if v then _G.Aimbot360Conn=EnableAimbot360() else if _G.Aimbot360Conn then _G.Aimbot360Conn:Disconnect() end end end})
AimbotTab:CreateSlider({Name="Aim FOV",Range={1,360},Increment=1,Suffix="°",CurrentValue=180,Callback=function(v) EnableAimFOV(v) end})
AimbotTab:CreateToggle({Name="AimSilent",CurrentValue=false,Callback=function(v) if v then _G.AimSilentConn=EnableAimSilent() else if _G.AimSilentConn then _G.AimSilentConn:Disconnect() end end end})
AimbotTab:CreateToggle({Name="Aimbot Legit",CurrentValue=false,Callback=function(v) if v then _G.AimbotLegitConn=EnableAimbotLegit() else if _G.AimbotLegitConn then _G.AimbotLegitConn:Disconnect() end end end})

local MovementTab = Window:CreateTab("Movement",4483362458)
MovementTab:CreateToggle({Name="Speed x3",CurrentValue=false,Callback=function(v) if v then _G.SpeedConn=EnableSpeedHack() else if _G.SpeedConn then _G.SpeedConn:Disconnect() end end end})
MovementTab:CreateToggle({Name="Fly",CurrentValue=false,Callback=function(v) if v then _G.FlyConn=EnableFlyHack() else if _G.FlyConn then _G.FlyConn:Disconnect() end end end})
MovementTab:CreateToggle({Name="Float",CurrentValue=false,Callback=function(v) if v then _G.FloatConn=EnableFloatHack() else if _G.FloatConn then _G.FloatConn:Disconnect() end end end})
MovementTab:CreateSlider({Name="Jump Hack",Range={1,4},Increment=0.1,Suffix="x",CurrentValue=1,Callback=function(v) if _G.JumpConn then _G.JumpConn:Disconnect() end _G.JumpConn=EnableJumpHack(v) end})

local ESPTab = Window:CreateTab("ESP",4483362458)
ESPTab:CreateToggle({Name="ESP Line",CurrentValue=false,Callback=function(v) if v then _G.ESPLineConn=EnableESPLine() else if _G.ESPLineConn then _G.ESPLineConn:Disconnect() end end end})
ESPTab:CreateToggle({Name="ESP Box",CurrentValue=false,Callback=function(v) if v then _G.ESPBoxConn=EnableESPBox() else if _G.ESPBoxConn then _G.ESPBoxConn:Disconnect() end end end})
ESPTab:CreateToggle({Name="ESP Skeleton",CurrentValue=false,Callback=function(v) if v then _G.ESPSkeletonConn=EnableESPSkeleton() else if _G.ESPSkeletonConn then _G.ESPSkeletonConn:Disconnect() end end end})
ESPTab:CreateToggle({Name="ESP Health",CurrentValue=false,Callback=function(v) if v then _G.ESPHealthConn=EnableESPHealth() else if _G.ESPHealthConn then _G.ESPHealthConn:Disconnect() end end end})
ESPTab:CreateToggle({Name="ESP Moco",CurrentValue=false,Callback=function(v) if v then _G.ESPMocoConn=EnableESPMoco() else if _G.ESPMocoConn then _G.ESPMocoConn:Disconnect() end end end})
ESPTab:CreateToggle({Name="ESP Up/Down",CurrentValue=false,Callback=function(v) if v then _G.ESPUpDownConn=EnableESPUpDown() else if _G.ESPUpDownConn then _G.ESPUpDownConn:Disconnect() end end end})
ESPTab:CreateToggle({Name="WallHack",CurrentValue=false,Callback=function(v) if v then EnableWallHack() end end})
ESPTab:CreateToggle({Name="TP Wall",CurrentValue=false,Callback=function(v) if v then EnableTPWall() end end})
ESPTab:CreateToggle({Name="MagicBullet V1",CurrentValue=false,Callback=function(v) if v then _G.MBV1Conn=EnableMagicBulletV1() else if _G.MBV1Conn then _G.MBV1Conn:Disconnect() end end end})
ESPTab:CreateToggle({Name="MagicBullet V2",CurrentValue=false,Callback=function(v) if v then EnableMagicBulletV2() end end})
ESPTab:CreateToggle({Name="AutoFire",CurrentValue=false,Callback=function(v) if v then EnableAutoFire() end end})
ESPTab:CreateToggle({Name="Rainbow FOV",CurrentValue=false,Callback=function(v) if v then EnableRainbowFOV() end end})
ESPTab:CreateToggle({Name="Rainbow ESP",CurrentValue=false,Callback=function(v) if v then EnableRainbowESP() end end})
ESPTab:CreateToggle({Name="Chams3D",CurrentValue=false,Callback=function(v) if v then EnableChams3D() end end})
ESPTab:CreateToggle({Name="Bypass Speed TP",CurrentValue=false,Callback=function(v) if v then EnableBypassSpeedTP() end end})
ESPTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {1, 60}, -- rango de tamaño
    Increment = 0.1,
    Suffix = " studs",
    CurrentValue = 2,
    Callback = function(value)
        EnableHitbox(value)
    end
})