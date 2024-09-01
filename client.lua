ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local electricObjects = {
    {model = 'prop_streetlight_01', type = 'object'},
    {model = 'prop_streetlight_02', type = 'object'},
    {coords = vector3(123.45, 678.90, 21.34), type = 'coord'}, 
}

local function triggerElectricShock(player)
    local playerPed = GetPlayerPed(-1)
    SetEntityHealth(playerPed, GetEntityHealth(playerPed) - 20) 

    ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.1)
    SetTimecycleModifier("spectator5")
    Wait(500)
    ClearTimecycleModifier()
    PlaySoundFromEntity(-1, "Electric", playerPed, "DLC_BTL_Dinnerbell_Sounds", true, 0)
    
    ESX.ShowNotification('Du hast einen Stromschlag bekommen!')
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)

        for _, obj in pairs(electricObjects) do
            if obj.type == 'object' then
                local object = GetClosestObjectOfType(playerCoords, 5.0, GetHashKey(obj.model), false, false, false)
                if DoesEntityExist(object) then
                    local objectCoords = GetEntityCoords(object)
                    if #(playerCoords - objectCoords) < 2.0 then
                        triggerElectricShock(playerPed)
                    end
                end
            elseif obj.type == 'coord' then
                if #(playerCoords - obj.coords) < 2.0 then
                    triggerElectricShock(playerPed)
                end
            end
        end
    end
end)
