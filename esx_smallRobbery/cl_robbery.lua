ESX = nil

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end
    ESX.PlayerData = ESX.GetPlayerData()
end)

local ped = PlayerPedId(-1)
local currentPos = GetEntityCoords(ped)

--DRAWS TEXT AND CHECKS DISTANCE
Citizen.CreateThread(function()
    --Citizen.Wait(0)
    function Draw3DText(x, y, z, text)
        local onScreen, _x, _y = World3dToScreen2d(x, y, z)
        local p = GetGameplayCamCoords()
        local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
        local scale = (1 / distance) * 2
        local fov = (1 / GetGameplayCamFov()) * 100
        local scale = scale * fov
        if onScreen  then --and ESX.PlayerData.job.name ~= "police" 
            SetTextScale(0.35, 0.35)
            SetTextFont(4)
            SetTextProportional(1)
            SetTextColour(255, 255, 255, 215)
            SetTextEntry("STRING")
            SetTextCentre(1)
            AddTextComponentString(text)
            DrawText(_x,_y)
            local factor = (string.len(text)) / 370
            DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
        end
    end
    while true do 
        Citizen.Wait(0)
        local coords = GetEntityCoords(PlayerPedId())
        for k,v in ipairs(Config.Register) do
            if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 0.8) then --changed to 3.0    
                DrawMarker(v.Type, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 192, 29, 204, 100, false, false, 2, true, false, false, false)
                Draw3DText(v.x, v.y, v.z, "~g~[E]~s~ for å begynne dirking")
                if IsControlJustReleased(0, 38) and GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 0.8 then --and ESX.PlayerData.job.name ~= "police"  
                    TriggerServerEvent("fs_robbery:lockpicking")
                    getStreet()
                    Citizen.CreateThread(function()
                        local plyCoords = GetEntityCoords(PlayerPedId())
                        local blip = AddBlipForCoord(plyCoords.x, plyCoords.y, plyCoords.z)
                            if ESX.PlayerData.job.name == "police" then
                                SetBlipSprite(blip, 567)
                                SetBlipDisplay(blip, 4)
                                SetBlipScale(blip, 1.4)
                            end
                        Citizen.Wait(10000)
                        RemoveBlip(blip)
                    end)
                end
            end
        end
    end
end)



RegisterNetEvent("fs_robbery:getAlert")
AddEventHandler("fs_robbery:getAlert", function()
    local plyCoords = GetEntityCoords(PlayerPedId())
    local streetCoord = GetStreetNameAtCoord(plyCoords.x, plyCoords.y, plyCoords.z)
    local seeStreet = GetStreetNameFromHashKey(streetCoord)
    print(seeStreet)
    exports['mythic_notify']:DoLongHudText(
        'error', 
        'Et ran har staret på ' .. seeStreet)
end)


function getStreet()
    local plyCoords = GetEntityCoords(PlayerPedId())
    local streetCoord = GetStreetNameAtCoord(plyCoords.x, plyCoords.y, plyCoords.z)
    local seeStreet = GetStreetNameFromHashKey(streetCoord)
    print(seeStreet)
end

--- THE ACTUALLY ROBBERY
RegisterNetEvent("fs_robbery:rob")
AddEventHandler("fs_robbery:rob", function()
    
    TriggerEvent("mythic_progressbar:client:progress", {
        name = "unique_action_name",
        duration = 10000,
        label = "Dirker opp kassen...",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "veh@plane@cuban@front@ds@base",
            anim = "hotwire",
            flags = 49,
        }
    }, function(status)
        if not status then
                Citizen.Wait(100)
                TriggerEvent("mythic_progressbar:client:progress", {
                    name = "unique_action_name",
                    duration = 20000,
                    label = "Tar penger...",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                    animation = {
                        animDict = "mp_take_money_mg",
                        anim = "stand_cash_in_bag_loop",
                        flags = 49,
                    },
                    prop = {
                        model = "prop_anim_cash_pile_01",
                    }
                }, function(status)
                    if not status then

                        TriggerServerEvent("fs_robbery:giveCash")
                    end
                end)
            end
    end)

end)

