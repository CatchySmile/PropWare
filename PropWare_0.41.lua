local frame = vgui.Create("DFrame")
frame:SetSize(400, 260)
frame:SetTitle("PropWare - v0.41 Release")
frame:SetVisible(true)
frame:Center()

frame.Paint = function(self, w, h)
    draw.RoundedBox(8, 0, 0, w, h, Color(24, 24, 24, 200))

    surface.SetDrawColor(Color(0, 0, 0, 255))
    surface.DrawOutlinedRect(0, 0, w, h)

    local radius = 5
    local corners = {
        {x = 0, y = 0},
        {x = w, y = 0},
        {x = w, y = h},
        {x = 0, y = h}
    }

    for _, corner in pairs(corners) do
        draw.RoundedBox(radius, corner.x - radius, corner.y - radius, radius * 2, radius * 2, Color(0, 0, 0, 255))
    end
end



-- If you remove my credits ill be oh so sad
local labelModel = vgui.Create("DLabel", frame)
labelModel:SetPos(327, 240)
labelModel:SetSize(200, 20)
labelModel:SetText("Made by 4koy")
labelModel:SetTextColor(Color(255, 255, 255))


local labelModel = vgui.Create("DLabel", frame)
labelModel:SetPos(10, 30)
labelModel:SetSize(200, 20)
labelModel:SetText("Pre-Selected Prop IDs:")
labelModel:SetTextColor(Color(255, 255, 255))


local labelModel = vgui.Create("DLabel", frame)
labelModel:SetPos(10, 55)
labelModel:SetSize(200, 20)
labelModel:SetText("Custom Prop ID:")
labelModel:SetTextColor(Color(255, 255, 255)) 


local propComboBox = vgui.Create("DComboBox", frame)
propComboBox:SetPos(143, 30)
propComboBox:SetSize(180, 20)

local presetProps = {
    "models/props_phx/construct/metal_wire_angle360x1.mdl",
    "models/props_phx/construct/metal_plate_curve360.mdl",
    "models/hunter/tubes/tube4x4x025.mdl",
    "models/props_phx/construct/wood/wood_angle360.mdl",
    "models/props_phx/construct/windows/window2x2.mdl",
    "models/props_c17/gate_door02a.mdl",
    "models/balloons/hot_airballoon.mdl",
    "models/props_phx/oildrum001_explosive.mdl"
}


for _, propModel in ipairs(presetProps) do
    propComboBox:AddChoice(propModel)
end

propComboBox:ChooseOptionID(1)


local function SpawnAllItems()
    for _, propModel in ipairs(presetProps) do
        for i = 1, 6 do
            timer.Simple(
                i * 0.1,
                function()
                    RunConsoleCommand("gm_spawn", propModel)
                end
            )
        end
    end
end

local textEntryCustomModel = vgui.Create("DTextEntry", frame)
textEntryCustomModel:SetPos(143, 55)
textEntryCustomModel:SetSize(180, 20)
textEntryCustomModel:SetPlaceholderText("ex : models/props_phx/oildrum001_explosive.mdl")

local labelQuantity = vgui.Create("DLabel", frame)
labelQuantity:SetPos(10, 80)
labelQuantity:SetSize(200, 20)
labelQuantity:SetText("Spawn Quantity:")
labelQuantity:SetTextColor(Color(255, 255, 255))


local textEntryQuantity = vgui.Create("DTextEntry", frame)
textEntryQuantity:SetPos(143, 80)
textEntryQuantity:SetSize(180, 20)
textEntryQuantity:SetText("1") 


local labelDelay = vgui.Create("DLabel", frame)
labelDelay:SetPos(10, 110)
labelDelay:SetSize(200, 20)
labelDelay:SetText("ms Delay Per Spawn:")
labelDelay:SetTextColor(Color(255, 255, 255)) 


local textEntryDelay = vgui.Create("DTextEntry", frame)
textEntryDelay:SetPos(143, 110)
textEntryDelay:SetSize(180, 20)
textEntryDelay:SetText("0") 


local spawnCustomButton = vgui.Create("DButton", frame)
spawnCustomButton:SetPos(330, 55)
spawnCustomButton:SetSize(60, 20)
spawnCustomButton:SetText("Spawn")


local spawnButton = vgui.Create("DButton", frame)
spawnButton:SetPos(330, 30)
spawnButton:SetSize(60, 20)
spawnButton:SetText("Spawn")

local spawnAllButton = vgui.Create("DButton", frame)
spawnAllButton:SetPos(10, 140)
spawnAllButton:SetSize(100, 20)
spawnAllButton:SetText("Spawn Variety")
spawnAllButton:SetTextColor(Color(33, 33, 33)) 


spawnAllButton.DoClick = SpawnAllItems


local cleanupButton = vgui.Create("DButton", frame)
cleanupButton:SetPos(150, 140)
cleanupButton:SetSize(100, 20)
cleanupButton:SetText("Clear Props")
cleanupButton:SetTextColor(Color(33, 33, 33))


local function RunCleanup()
    RunConsoleCommand("gmod_cleanup")
    surface.PlaySound("buttons/button7.wav")
    Msg("Clear Successful\n")
end


cleanupButton.DoClick = RunCleanup



local function SpawnCustomProp()
    local customModelID = textEntryCustomModel:GetValue() or ""
    local quantity = tonumber(textEntryQuantity:GetValue()) or 1
    local delay = tonumber(textEntryDelay:GetValue()) or 0
    notification.AddLegacy("Spawned Props Successfully!", NOTIFY_UNDO, 2)
    surface.PlaySound("buttons/button15.wav")
    Msg("Spawn Successful\n")

    for i = 1, quantity do
        timer.Simple(
            i * delay / 1000,
            function()
                RunConsoleCommand("gm_spawn", customModelID)
            end
        )
    end
end





spawnCustomButton.DoClick = SpawnCustomProp


local function SpawnProps()
    local modelID = propComboBox:GetValue() or textEntryCustomModel:GetValue() or ""
    local quantity = tonumber(textEntryQuantity:GetValue()) or 1
    local delay = tonumber(textEntryDelay:GetValue()) or 0
    notification.AddLegacy("Spawned Props Successfully!", NOTIFY_UNDO, 2)
    surface.PlaySound("buttons/button15.wav")
    Msg("Spawn Successful\n")

    for i = 1, quantity do
        timer.Simple(
            i * delay / 1000,
            function()
                RunConsoleCommand("gm_spawn", modelID)
            end
        )
    end
end


spawnButton.DoClick = SpawnProps


spawnAllButton.DoClick = SpawnAllItems


local espEnabled = false

local function DrawESP()
    if not espEnabled then return end 
    local localPlayer = LocalPlayer()
    local localPos = localPlayer:GetPos()

    local players = player.GetAll()

    local function GetDistanceColor(distance)
        local gradientValue = math.Clamp((distance - 3) / 100, 0, 1) 
        local r, g, b = 0, 255, 0 
        
        r = math.Clamp(gradientValue * 155, 50, 155) 
        g = math.Clamp((1 - gradientValue) * 255, 50, 255)
        
        return Color(r, g, b)
    end

    for _, ply in ipairs(players) do
        if IsValid(ply) and ply:IsPlayer() and ply:Alive() and ply ~= localPlayer then 
            local scrPos = ply:GetPos():ToScreen()

            local health = ply:Health()
            local healthText = "HP: " .. health
            local healthColor = Color(0, 255, 0) 

            if health <= 20 then
                healthColor = Color(255, 0, 0) 
            elseif health >= 100 then
                healthColor = Color(0, 255, 0) 
            else
                local gradientValue = (health - 20) / (100 - 20) 
                local r = 255 * (1 - gradientValue)
                local g = 255 * gradientValue 
                healthColor = Color(r, g, 0) 
            end

            surface.SetFont("DermaDefault")
            local healthTextW, healthTextH = surface.GetTextSize(healthText)
            draw.SimpleTextOutlined(healthText, "DermaDefault", scrPos.x, scrPos.y - healthTextH - 10, healthColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))


            local name = ply:Nick()
            local nameColor = Color(255, 255, 255) 

            surface.SetFont("DermaDefault")
            local textW, textH = surface.GetTextSize(name)
            draw.SimpleTextOutlined(name, "DermaDefault", scrPos.x, scrPos.y - textH - 26, nameColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))

            local distance = localPos:Distance(ply:GetPos()) / 50 
            local distanceText = "Distance: " .. math.Round(distance) .. " meters"
            local distanceColor = GetDistanceColor(distance)

            surface.SetFont("DermaDefault")
            local distTextW, distTextH = surface.GetTextSize(distanceText)
            draw.SimpleTextOutlined(distanceText, "DermaDefault", scrPos.x, scrPos.y + 4, distanceColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
        end
    end
end

hook.Add("HUDPaint", "DrawESP", DrawESP)

local function GetLineColor(distance)
    local gradientValue = math.Clamp((distance - 3) / 100, 0, 1) 
    local r, g, b = 0, 255, 0 
    r = math.Clamp(gradientValue * 255, 0, 255)
    g = math.Clamp((1 - gradientValue) * 255, 0, 255) 
    
    return Color(r, g, b)
end

hook.Add("PostDrawOpaqueRenderables", "DrawPlayerBoxesAndLines", function()
    local players = player.GetAll()
    local localPos = LocalPlayer():GetPos()

    local WireframeMaterial = Material("models/wireframe")
    local lineColor = Color(255, 255, 255)
    local outlineColor = Color(0, 0, 0, 255) 
    local outlineThickness = 1

    for _, ply in ipairs(players) do
        if IsValid(ply) and ply:IsPlayer() and ply:Alive() and ply ~= LocalPlayer() then 
            local plyPos = ply:GetPos()

            if espEnabled then
                cam.IgnoreZ(true)

                render.SetMaterial(WireframeMaterial)
                render.DrawBox(plyPos, ply:GetAngles(), ply:OBBMins() * 1.0, ply:OBBMaxs() * 1.0, outlineColor, true)


                cam.IgnoreZ(false)

                if espEnabled then
                    render.DrawLine(localPos, plyPos, lineColor, false)
                end
            end
        end
    end
end)





local espCheckbox = vgui.Create("DCheckBoxLabel", frame)
espCheckbox:SetPos(90, 167)
espCheckbox:SetSize(200, 20)
espCheckbox:SetText("Esp")
espCheckbox:SetValue(espEnabled)
espCheckbox:SizeToContents()

espCheckbox.OnChange = function(panel, isChecked)
    espEnabled = isChecked
end







local lookRandomCheckbox = vgui.Create("DCheckBoxLabel", frame) 
lookRandomCheckbox:SetPos(999, 999)
lookRandomCheckbox:SetValue(0)
lookRandomCheckbox:SizeToContents()

-- This shit is NOT silent
local function LookRandomlyContinuously()
    if lookRandomCheckbox:GetChecked() then
        local yaw = math.random(0, 360)
        local pitch = math.Clamp(math.random(-60, 25), -60, 25) 
        local newAngles = Angle(pitch, yaw, 0)
        LocalPlayer():SetEyeAngles(newAngles)
        local delay = 50 
        delay = math.max(delay, 1) 
        timer.Simple(delay / 710, LookRandomlyContinuously) 
    end
end

lookRandomCheckbox.OnChange = function(panel, isChecked)
    if isChecked then
        LookRandomlyContinuously() 
    end
end

CreateClientConVar("spin_enabled", 0, true, false)

local spinCheckbox = vgui.Create("DCheckBoxLabel", frame)
spinCheckbox:SetPos(10, 207)
spinCheckbox:SetSize(200, 20)
spinCheckbox:SetText("Anti-Aim")
spinCheckbox:SetValue(GetConVar("spin_enabled"):GetBool())
spinCheckbox:SizeToContents()

local spinSpeed = 700 
-- Also not silent

hook.Add("Think", "SpinCharacter", function()
    if GetConVar("spin_enabled"):GetBool() then
        if IsValid(LocalPlayer()) then 
            local ply = LocalPlayer()
            local ang = ply:EyeAngles() 
            ang.yaw = ang.yaw + spinSpeed * FrameTime() 
            ply:SetEyeAngles(ang) 
        end
    end
end)

spinCheckbox.OnChange = function(panel, isChecked)
    if isChecked then
        RunConsoleCommand("spin_enabled", "1")
        lookRandomCheckbox:SetValue(1) 
    else
        RunConsoleCommand("spin_enabled", "0") 
        lookRandomCheckbox:SetValue(0)
    end
end


local LightingModeChanged = false
local lightingModeEnabled = false

hook.Add("PreRender", "fullbright", function()
    if lightingModeEnabled then
        render.SetLightingMode(1)
        LightingModeChanged = true
    end
end)

local function EndOfLightingMod()
    if LightingModeChanged then
        render.SetLightingMode(0)
        LightingModeChanged = false
    end
end

hook.Add("PostRender", "fullbright", EndOfLightingMod)
hook.Add("PreDrawHUD", "fullbright", EndOfLightingMod)

local lightingModeCheckbox = vgui.Create("DCheckBoxLabel", frame)
lightingModeCheckbox:SetPos(10, 167)
lightingModeCheckbox:SetSize(200, 20)
lightingModeCheckbox:SetText("Fullbright")
lightingModeCheckbox:SetValue(lightingModeEnabled)
lightingModeCheckbox:SizeToContents()

lightingModeCheckbox.OnChange = function(panel, isChecked)
    lightingModeEnabled = isChecked
end


local fovText = vgui.Create("DLabel", frame)
fovText:SetPos(353, 105)
fovText:SetSize(200, 20)
fovText:SetText("Fov")
fovText:SetTextColor(Color(255, 255, 255)) 

local fovSlider = vgui.Create("DNumSlider", frame)
fovSlider:SetPos(243, 90)
fovSlider:SetSize(200, 20)
fovSlider:SetMin(75)
fovSlider:SetMax(150)
fovSlider:SetDecimals(0)
fovSlider:SetValue(110)

local fovSliderIsValid = true

local function ApplyFOV()
    if not freecamEnabled and LocalPlayer() then
        local newFOV = fovSlider:GetValue()
        LocalPlayer():SetFOV(newFOV, 0.1)
    end
end

local function CalcFOV(ply, origin, angles, fov)
    if fovSliderIsValid and not freecamEnabled and ply == LocalPlayer() then
        return {
            fov = fovSlider:GetValue()
        }
    end
end

hook.Add("CalcView", "ChangeFOV", CalcFOV)



local freecamCheckbox = vgui.Create("DCheckBoxLabel", frame)
freecamCheckbox:SetPos(90, 207)
freecamCheckbox:SetSize(200, 20)
freecamCheckbox:SetText("Freecam")
freecamCheckbox:SetValue(false)
freecamCheckbox:SizeToContents()

freecamCheckbox.OnChange = function(panel, isChecked)
    if isChecked then
        if input.IsKeyDown(KEY_LALT) then
            freecamEnabled = false 
        else
            freecamAngles = LocalPlayer():EyeAngles()
            freecamAngles2 = LocalPlayer():EyeAngles()
            freecamPos = LocalPlayer():EyePos()
            freecamEnabled = true 
        end
    else
        freecamEnabled = false 
    end
end



freecamAngles = Angle()
freecamAngles2 = Angle()
freecamPos = Vector()
freecamEnabled = false
freecamSpeed = 3
keyPressed = false

hook.Add("CreateMove", "lock_movement", function(ucmd)
    if(freecamEnabled) then
        ucmd:SetSideMove(0)
        ucmd:SetForwardMove(0)
        ucmd:SetViewAngles(freecamAngles2)
        ucmd:RemoveKey(IN_JUMP)
        ucmd:RemoveKey(IN_DUCK)
        freecamAngles = (freecamAngles + Angle(ucmd:GetMouseY() * .023, ucmd:GetMouseX() * -.023, 0));
        freecamAngles.p, freecamAngles.y, freecamAngles.x = math.Clamp(freecamAngles.p, -89, 89), math.NormalizeAngle(freecamAngles.y), math.NormalizeAngle(freecamAngles.x);
        local curFreecamSpeed = freecamSpeed
        if(input.IsKeyDown(KEY_LSHIFT)) then
            curFreecamSpeed = freecamSpeed * 2
        end
        if(input.IsKeyDown(KEY_W)) then
            freecamPos = freecamPos + (freecamAngles:Forward() * curFreecamSpeed)
        end
        if(input.IsKeyDown(KEY_S)) then
            freecamPos = freecamPos - (freecamAngles:Forward() * curFreecamSpeed)
        end
        if(input.IsKeyDown(KEY_A)) then
            freecamPos = freecamPos - (freecamAngles:Right() * curFreecamSpeed)
        end
        if(input.IsKeyDown(KEY_D)) then
            freecamPos = freecamPos + (freecamAngles:Right() * curFreecamSpeed)
        end
        if(input.IsKeyDown(KEY_SPACE)) then
            freecamPos = freecamPos + Vector(0,0,curFreecamSpeed)
        end
        if(input.IsKeyDown(KEY_LCONTROL)) then
            freecamPos = freecamPos - Vector(0,0,curFreecamSpeed)
        end
    end
end)
hook.Add("CalcView", "freeCam", function(ply, pos, angles, fov)
    local view = {}
    if(freecamEnabled) then
        view = {
            origin = freecamPos,
            angles = freecamAngles,
            fov = fov,
            drawviewer = true
        }
    else
        view = {
            origin = pos,
            angles = angles,
            fov = fov,
            drawviewer = false
        }
    end
	return view
end)


local propEspEnabled = false
local selectedColorIndex = 1

local colorOptions = {
    Color(175, 94, 94, 70),
    Color(255, 0, 0, 100),
    Color(155, 155, 0, 100),
    Color(0, 255, 0, 100),
    Color(0, 155, 155, 100),
    Color(0, 0, 255, 100), 
    Color(155, 155, 0, 100),
    Color(255, 255, 0, 100),
    Color(155, 0, 155, 100),
    Color(255, 0, 255, 100),
    Color(0, 155, 155, 100), 
    Color(0, 255, 255, 100)  
}

local function SetPropEspColor(colorIndex)
    selectedColorIndex = colorIndex
end

local colorSlider = vgui.Create("DNumSlider", frame)
colorSlider:SetPos(105, 183) 
colorSlider:SetSize(180, 20) 
colorSlider:SetText("")
colorSlider:SetMin(1)
colorSlider:SetMax(#colorOptions)
colorSlider:SetDecimals(0)
colorSlider:SetValue(selectedColorIndex)

colorSlider.OnValueChanged = function(panel, value)
    SetPropEspColor(math.floor(value + 0.5)) 
end

local function DrawPropESP()
    if not propEspEnabled then return end
    
    local props = ents.FindByClass("prop_*") 
    
    cam.IgnoreZ(true)
    
    for _, prop in ipairs(props) do
        if IsValid(prop) then
            local propPos = prop:GetPos()
            local propMins, propMaxs = prop:GetModelBounds()
            local propAngles = prop:GetAngles()
            
            local forward = propAngles:Forward()
            local right = propAngles:Right()
            local up = propAngles:Up()
            
            local corners = {
                propPos + forward * propMins.x + right * propMins.y + up * propMins.z,
                propPos + forward * propMaxs.x + right * propMins.y + up * propMins.z,
                propPos + forward * propMaxs.x + right * propMaxs.y + up * propMins.z,
                propPos + forward * propMins.x + right * propMaxs.y + up * propMins.z,
                propPos + forward * propMins.x + right * propMins.y + up * propMaxs.z,
                propPos + forward * propMaxs.x + right * propMins.y + up * propMaxs.z,
                propPos + forward * propMaxs.x + right * propMaxs.y + up * propMaxs.z,
                propPos + forward * propMins.x + right * propMaxs.y + up * propMaxs.z
            }
            
            render.SetMaterial(Material("color"))

            render.DrawQuad(corners[1], corners[2], corners[3], corners[4], colorOptions[selectedColorIndex])
            render.DrawQuad(corners[5], corners[6], corners[7], corners[8], colorOptions[selectedColorIndex])
            render.DrawQuad(corners[1], corners[2], corners[6], corners[5], colorOptions[selectedColorIndex])
            render.DrawQuad(corners[3], corners[4], corners[8], corners[7], colorOptions[selectedColorIndex])
            render.DrawQuad(corners[1], corners[4], corners[8], corners[5], colorOptions[selectedColorIndex])
            render.DrawQuad(corners[2], corners[3], corners[7], corners[6], colorOptions[selectedColorIndex])

            render.DrawQuad(corners[4], corners[3], corners[2], corners[1], colorOptions[selectedColorIndex])
            render.DrawQuad(corners[8], corners[7], corners[6], corners[5], colorOptions[selectedColorIndex])
            render.DrawQuad(corners[5], corners[6], corners[2], corners[1], colorOptions[selectedColorIndex])
            render.DrawQuad(corners[7], corners[8], corners[4], corners[3], colorOptions[selectedColorIndex])
            render.DrawQuad(corners[5], corners[8], corners[7], corners[4], colorOptions[selectedColorIndex])
            render.DrawQuad(corners[6], corners[7], corners[3], corners[2], colorOptions[selectedColorIndex])
            
            render.SetMaterial(Material("models/wireframe")) 
            for i = 1, 4 do
                render.DrawLine(corners[i], corners[i % 4 + 1], colorOptions[selectedColorIndex], true)
                render.DrawLine(corners[i + 4], corners[i % 4 + 5], colorOptions[selectedColorIndex], true)
                render.DrawLine(corners[i], corners[i + 4], colorOptions[selectedColorIndex], true)
            end
        end
    end
    
    cam.IgnoreZ(false)
end



hook.Add("PostDrawOpaqueRenderables", "DrawPropESP", DrawPropESP)



local propEspCheckbox = vgui.Create("DCheckBoxLabel", frame)
propEspCheckbox:SetPos(170, 167)
propEspCheckbox:SetSize(200, 20)
propEspCheckbox:SetText("Prop Chams")
propEspCheckbox:SetValue(propEspEnabled)
propEspCheckbox:SizeToContents()

propEspCheckbox.OnChange = function(panel, isChecked)
    propEspEnabled = isChecked
end



CreateClientConVar("BhopVar", 0, true, false)

local bunnyhopCheckbox = vgui.Create("DCheckBoxLabel", frame)
bunnyhopCheckbox:SetPos(90, 187)
bunnyhopCheckbox:SetSize(200, 20)
bunnyhopCheckbox:SetText("Bhop")
bunnyhopCheckbox:SetValue(GetConVar("BhopVar"):GetBool())
bunnyhopCheckbox:SizeToContents()

local function Bunnyhop()
    if GetConVar("BhopVar"):GetBool() then
        if input.IsKeyDown(KEY_SPACE) then
            if LocalPlayer():IsOnGround() then
                RunConsoleCommand("+jump")
                timer.Simple(0.1, function()
                    RunConsoleCommand("-jump")
                end)
            else
                local velocity = LocalPlayer():GetVelocity()
                local forward = LocalPlayer():EyeAngles():Forward()
                local speed = velocity:Length2D()

                if speed > 30 then
                    local addSpeed = math.max(0, 30 - speed)
                    local pushVel = forward * (addSpeed + 100) * 10
                    LocalPlayer():SetVelocity(velocity + pushVel)
                else
                    BhopVar = false 
                end
            end
        end
    end
end

hook.Add("Think", "Bunnyhop", Bunnyhop)

bunnyhopCheckbox.OnChange = function(panel, isChecked)
    if isChecked then
        RunConsoleCommand("BhopVar", "1")
    else
        RunConsoleCommand("BhopVar", "0")
    end
end


frame:MakePopup()

local lastHomePressTime = 0
local homePressDelay = 200 


local toggleKeys = {
    [KEY_INSERT] = "Insert",
    [KEY_HOME] = "Home",
    [KEY_DELETE] = "Delete",
    [KEY_END] = "End",
    [KEY_F10] = "F10",
    [KEY_F9] = "F9"
}

local labelToggleGUI = vgui.Create("DLabel", frame)
labelToggleGUI:SetPos(75, 230)
labelToggleGUI:SetSize(370, 20)
labelToggleGUI:SetText("GUI Key")
labelToggleGUI:SetTextColor(Color(255, 255, 255)) 


local toggleKeyComboBox = vgui.Create("DComboBox", frame)
toggleKeyComboBox:SetPos(10, 230)
toggleKeyComboBox:SetSize(60, 20)
toggleKeyComboBox:SetText("Home")

for key, name in pairs(toggleKeys) do
    toggleKeyComboBox:AddChoice(name, key)
end

local toggleKey = KEY_HOME

toggleKeyComboBox.OnSelect = function(panel, index, value, data)
    toggleKey = data
end



local DetectPropFlingCheckbox = vgui.Create("DCheckBoxLabel", frame)
DetectPropFlingCheckbox:SetPos(10, 187)
DetectPropFlingCheckbox:SetSize(200, 20)
DetectPropFlingCheckbox:SetText("Fling Alert")
DetectPropFlingCheckbox:SetValue(0) 
DetectPropFlingCheckbox:SizeToContents()

local lastNotificationTime = 0
local notificationDelay = 1.0 

local function DetectPropFling()
    local props = ents.FindByClass("prop_*")

    for _, prop in ipairs(props) do
        if IsValid(prop) then
            local propPos = prop:GetPos()

            for _, ply in ipairs(player.GetAll()) do
                if IsValid(ply) then
                    local plyPos = ply:GetPos()
                    local distance = plyPos:Distance(propPos)

                    if distance <= 1600 then 
                        local velocity = prop:GetVelocity():Length() 
                        local flingThreshold = 3640 

                        if velocity > flingThreshold then
                            local currentTime = CurTime()
                            if currentTime - lastNotificationTime >= notificationDelay then
                                notification.AddLegacy("Prop Fling Detected!", NOTIFY_GENERIC, 5)
                                Msg("Prop Fling Detected!\n")
                                lastNotificationTime = currentTime
                            end
                            break 
                        end
                    end
                end
            end
        end
    end
end

hook.Add("Think", "DetectPropFling", function()
    if IsValid(DetectPropFlingCheckbox) and DetectPropFlingCheckbox:GetChecked() then
        DetectPropFling()
    end
end)


local function ToggleGUI()
    if IsValid(frame) then
        frame:SetVisible(not frame:IsVisible())
    else
        print("You must re-run the script because you hit the X")
    end
end



frame.OnClose = function()
    hook.Remove("CalcView", "ChangeFOV")
    fovSliderIsValid = false
    DetectPropFlingCheckbox:SetValue(false)
    espCheckbox:SetValue(false)
    spinCheckbox:SetValue(false)
    lightingModeCheckbox:SetValue(false)
    bunnyhopCheckbox:SetValue(false)
    propEspCheckbox:SetValue(false)
    freecamCheckbox:SetValue(false)

    propEspEnabled = false
end


hook.Add(
    "Think",
    "ToggleMinimizedMode",
    function()
        if toggleKey and input.IsKeyDown(toggleKey) then
            local currentTime = RealTime() * 1000 
            if currentTime - lastHomePressTime >= homePressDelay then
                ToggleGUI()
                lastHomePressTime = currentTime
            end
        else
            lastHomePressTime = 0
        end
    end
)
