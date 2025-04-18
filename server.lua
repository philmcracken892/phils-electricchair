local RSGCore = exports['rsg-core']:GetCoreObject()


local placedChairs = {}
local sittingPlayers = {}


RegisterServerEvent('electricchair:server:registerChair')
AddEventHandler('electricchair:server:registerChair', function(netId)
    local src = source
    placedChairs[netId] = src
    
end)


RegisterServerEvent('electricchair:server:playerSitting')
AddEventHandler('electricchair:server:playerSitting', function(netId, playerId)
    sittingPlayers[netId] = playerId
    
    TriggerClientEvent('electricchair:client:playerSitting', -1, netId, playerId)
end)


RegisterServerEvent('electricchair:server:playerStoodUp')
AddEventHandler('electricchair:server:playerStoodUp', function(netId)
    sittingPlayers[netId] = nil
    
    TriggerClientEvent('electricchair:client:playerStoodUp', -1, netId)
end)

RegisterServerEvent('electricchair:server:triggerExecution')
AddEventHandler('electricchair:server:triggerExecution', function(netId, playerId)
    local src = source
    local sittingId = sittingPlayers[netId]
    
    
    
    if placedChairs[netId] and sittingId then
        if playerId ~= sittingId then
            playerId = sittingId
        end
        
       
        
        
        TriggerClientEvent('electricchair:client:executePlayer', playerId)
        
        
        TriggerClientEvent('electricchair:client:executionEffects', -1, netId)
        
        
        local Player = RSGCore.Functions.GetPlayer(playerId)
        if Player then
            
            Wait(3000) 
            TriggerClientEvent("RSGCore:Client:KillPlayer", playerId)
            
           
            if Player.Functions.SetMetaData then
                Player.Functions.SetMetaData("isdead", true)
            end
        end
        
        
        if src ~= playerId then
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Electric Chair',
                description = 'You triggered the execution!',
                type = 'success'
            })
        end
        
        
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Electric Chair',
            description = 'Execution failed: No one is sitting or the chair is invalid.',
            type = 'error'
        })
        
    end
end)


RegisterServerEvent('electricchair:server:executionComplete')
AddEventHandler('electricchair:server:executionComplete', function(netId, playerId)
   
    
    
    sittingPlayers[netId] = nil
    
    
    TriggerClientEvent('electricchair:client:playerStoodUp', -1, netId)
end)


RegisterServerEvent('electricchair:server:removeChair')
AddEventHandler('electricchair:server:removeChair', function(netId)
    local src = source
    
    if placedChairs[netId] then
        local Player = RSGCore.Functions.GetPlayer(src)
        Player.Functions.AddItem('electricchair', 0)
        TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items['electricchair'], "add")
        
        placedChairs[netId] = nil
        sittingPlayers[netId] = nil
        
        TriggerClientEvent('electricchair:client:deleteChair', -1, netId)
        TriggerClientEvent('electricchair:client:playerStoodUp', -1, netId)
       
    end
end)


RegisterServerEvent('electricchair:server:requestAllSittingStates')
AddEventHandler('electricchair:server:requestAllSittingStates', function()
    local src = source
    for netId, sittingId in pairs(sittingPlayers) do
        TriggerClientEvent('electricchair:client:requestSittingState', src, netId, sittingId)
        
    end
end)


RSGCore.Functions.CreateUseableItem('electricchair', function(source, item)
    local src = source
    TriggerClientEvent('electricchair:client:placeChair', src)
end)