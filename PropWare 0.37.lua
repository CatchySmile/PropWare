
local frame = vgui.Create("DFrame")
frame:SetSize(400, 190)
frame:SetTitle("PropWare - v0.37")
frame:SetVisible(true)
frame:Center()


frame.Paint = function(self, w, h)
    draw.RoundedBox(8, 0, 0, w, h, Color(24, 24, 24, 200)) 
end


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

-- Pre-set prop models
local presetProps = {
    "models/props_phx/construct/metal_wire_angle360x1.mdl",
    "models/props_phx/construct/metal_plate_curve360.mdl",
    "models/hunter/tubes/tube4x4x025.mdl",
    "models/props_phx/construct/wood/wood_angle360.mdl",
    "models/props_phx/construct/windows/window2x2.mdl",
    "models/props_c17/furnitureCouch002a.mdl",
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

local labelToggleGUI = vgui.Create("DLabel", frame)
labelToggleGUI:SetPos(10, 170)
labelToggleGUI:SetSize(370, 20)
labelToggleGUI:SetText("`HOME` To toggle GUI")
labelToggleGUI:SetTextColor(Color(255, 255, 255)) 


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


frame:MakePopup()

local lastHomePressTime = 0
local homePressDelay = 200 


hook.Add(
    "Think",
    "ToggleMinimizedMode",
    function()
        if input.IsKeyDown(KEY_HOME) then
            local currentTime = RealTime() * 1000 
            if currentTime - lastHomePressTime >= homePressDelay then
                frame:SetVisible(not frame:IsVisible())
                lastHomePressTime = currentTime
            end
        else
            lastHomePressTime = 0
        end
    end
)
