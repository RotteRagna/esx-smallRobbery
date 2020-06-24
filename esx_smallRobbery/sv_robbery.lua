  
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)


RegisterServerEvent("fs_robbery:lockpicking")
AddEventHandler("fs_robbery:lockpicking", function()
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    local itemQuantity = xPlayer.getInventoryItem("lockpick").count
    if itemQuantity > 0 then
        xPlayer.removeInventoryItem("lockpick", 1)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { 
            type = 'inform', 
            text = 'Du har brukt et dirkesett', 
            style = { ['background-color'] = '#ffffff', 
            ['color'] = '#000000' } 
        })
        TriggerClientEvent("fs_robbery:rob", source)

    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { 
            type = 'inform', 
            text = 'Du har ikke dirkesett på deg', 
            style = { ['background-color'] = '#ffffff', 
            ['color'] = '#000000' } 
        })
    end

    if xPlayer.job.name == "police" and itemQuantity > 0 then
        TriggerClientEvent("fs_robbery:getAlert", source)
    end
end)

RegisterServerEvent("fs_robbery:giveCash")
AddEventHandler("fs_robbery:giveCash", function()
    local _source = source
    xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.addMoney(Config.Reward)
end)

