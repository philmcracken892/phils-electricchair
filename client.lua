local RSGCore = exports['rsg-core']:GetCoreObject()
local ox_lib = exports.ox_lib

-- Configuration
local ELECTRIC_CHAIR = {
    label = "Electric Chair",
    model = `p_cs_electricchair01x`,
    backupModel = `p_chair_crate02x`,
    offset = vector3(0.0, -0.2, 0.5),
    seating = {
        scenario = "PROP_HUMAN_SEAT_CHAIR",
        x = 0.0,
        y = 0.0,
        z = 0.5,
        heading = 180.0
    }
}

-- Particle effect configuration
local FX_GROUP = "scr_dm_ftb"
local FX_NAME = "scr_mp_chest_spawn_smoke"
local FX_SCALE = 0.3

-- Variables
local deployedChair = nil
local chairNetId = nil
local isSitting = false
local sittingPlayerId = nil
local sittingNetId = nil
local sittingStates = {}

-- Register chair targeting with ox_target
local function RegisterChairTargeting()
    exports['ox_target']:addModel({ELECTRIC_CHAIR.model, ELECTRIC_CHAIR.backupModel}, {
        {
            name = 'sit_electric_chair',
            event = 'electricchair:client:sitOnChair',
            icon = "fas fa-chair",
            label = "Sit on Electric Chair",
            distance = 2.0,
            canInteract = function(entity)
                local netId = NetworkGetNetworkIdFromEntity(entity)
                local canSit = not sittingStates[netId]
                print("[DEBUG] Sit canInteract - netId: " .. tostring(netId) .. ", canSit: " .. tostring(canSit))
                return canSit
            end
        },
        {
            name = 'execute_electric_chair',
            event = 'electricchair:client:executeOnChair',
            icon = "fas fa-bolt",
            label = "Execute Player",
            distance = 2.0,
            canInteract = function(entity)
                local netId = NetworkGetNetworkIdFromEntity(entity)
                local sittingId = sittingStates[netId]
                local canExecute = sittingId and sittingId ~= GetPlayerServerId(PlayerId())
                print("[DEBUG] Execute canInteract - netId: " .. tostring(netId) .. ", sittingId: " .. tostring(sittingId) .. ", canExecute: " .. tostring(canExecute))
                return canExecute
            end
        },
        {
            name = 'pickup_electric_chair',
            event = 'electricchair:client:pickupChair',
            icon = "fas fa-hand",
            label = "Pick Up Electric Chair",
            distance = 2.0,
            canInteract = function(entity)
                local netId = NetworkGetNetworkIdFromEntity(entity)
                local canPickup = not sittingStates[netId]
                print("[DEBUG] Pickup canInteract - netId: " .. tostring(netId) .. ", canPickup: " .. tostring(canPickup))
                return canPickup
            end
        }
    })
    print("[DEBUG] Chair targeting registered for models")
end

-- Function to place the chair
RegisterNetEvent('electricchair:client:placeChair', function()
    if deployedChair then
        TriggerEvent('ox_lib:notify', {
            title = "Chair Already Placed",
            description = "You already have an electric chair placed.",
            type = 'error'
        })
        print("[DEBUG] Place chair failed: Chair already deployed")
        return
    end

    local chairModel = ELECTRIC_CHAIR.model
    if not IsModelValid(chairModel) then
        chairModel = ELECTRIC_CHAIR.backupModel
        if not IsModelValid(chairModel) then
            TriggerEvent('ox_lib:notify', {
                title = "Error",
                description = "Chair model not found in game files.",
                type = 'error'
            })
            print("[DEBUG] Place chair failed: No valid model")
            return
        end
    end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local forward = GetEntityForwardVector(ped)
    
    local offsetDistance = 1.0
    local x = coords.x + forward.x * offsetDistance
    local y = coords.y + forward.y * offsetDistance
    local z = coords.z
    
    RequestModel(chairModel)
    while not HasModelLoaded(chairModel) do
        Wait(100)
    end
    
    LocalPlayer.state:set('inv_busy', true, true)
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), -1, true, false, false, false)
    ExecuteCommand('closeInv')
    Wait(2000)
    
    local chairObject = CreateObject(chairModel, x, y, z, true, false, false)
    PlaceObjectOnGroundProperly(chairObject)
    SetEntityHeading(chairObject, heading)
    FreezeEntityPosition(chairObject, true)
    
    deployedChair = chairObject
    chairNetId = NetworkGetNetworkIdFromEntity(chairObject)
    
    TriggerServerEvent('electricchair:server:registerChair', chairNetId)
    print("[DEBUG] Chair placed - netId: " .. tostring(chairNetId))
    
    Wait(500)
    ClearPedTasks(ped)
    LocalPlayer.state:set('inv_busy', false, true)
    SetModelAsNoLongerNeeded(chairModel)
    
    TriggerEvent('ox_lib:notify', {
        title = 'Electric Chair',
        description = 'You placed an electric chair.',
        type = 'success'
    })
end)

-- Function to sit on the chair
RegisterNetEvent('electricchair:client:sitOnChair', function(data)
    if isSitting then 
        print("[DEBUG] Sit failed: Already sitting")
        return 
    end
    
    local chairEntity = data.entity
    if not DoesEntityExist(chairEntity) then 
        print("[DEBUG] Sit failed: Chair entity does not exist")
        return 
    end
    
    local chairCoords = GetEntityCoords(chairEntity)
    local chairHeading = GetEntityHeading(chairEntity)
    local netId = NetworkGetNetworkIdFromEntity(chairEntity)
    
    local seating = ELECTRIC_CHAIR.seating
    local ped = PlayerPedId()
    
    local offsetX = seating.x
    local offsetY = seating.y
    local radians = math.rad(chairHeading)
    local rotatedX = offsetX * math.cos(radians) - offsetY * math.sin(radians)
    local rotatedY = offsetX * math.sin(radians) + offsetY * math.cos(radians)
    
    local sitX = chairCoords.x + rotatedX
    local sitY = chairCoords.y + rotatedY
    local sitZ = chairCoords.z + seating.z
    local sitHeading = chairHeading + seating.heading
    
    TaskStartScenarioAtPosition(ped, GetHashKey(seating.scenario), 
        sitX, sitY, sitZ, sitHeading, -1, true, true)
    
    isSitting = true
    sittingPlayerId = PlayerId()
    sittingNetId = netId
    
    TriggerServerEvent('electricchair:server:playerSitting', netId, GetPlayerServerId(sittingPlayerId))
    print("[DEBUG] Player sitting - netId: " .. tostring(netId) .. ", playerId: " .. tostring(GetPlayerServerId(sittingPlayerId)))
    
    Citizen.CreateThread(function()
        while isSitting do
            if IsControlJustPressed(0, 0xCEFD9220) then -- E key
                ClearPedTasks(ped)
                isSitting = false
                sittingPlayerId = nil
                sittingNetId = nil
                TriggerServerEvent('electricchair:server:playerStoodUp', netId)
                print("[DEBUG] Player stood up - netId: " .. tostring(netId))
            end
            Wait(0)
        end
    end)
end)

-- Function to execute the seated player
RegisterNetEvent('electricchair:client:executeOnChair', function(data)
    local chairEntity = data.entity
    if not DoesEntityExist(chairEntity) then 
        print("[DEBUG] Execute failed: Chair entity does not exist")
        return 
    end
    
    local netId = NetworkGetNetworkIdFromEntity(chairEntity)
    local sittingId = sittingStates[netId]
    
    if not sittingId then
        TriggerEvent('ox_lib:notify', {
            title = 'Electric Chair',
            description = 'No one is sitting in the chair.',
            type = 'error'
        })
        print("[DEBUG] Execute failed: No sitting player for netId: " .. tostring(netId))
        return
    end
    
    print("[DEBUG] Execute triggered - netId: " .. tostring(netId) .. ", sittingId: " .. tostring(sittingId))
    TriggerServerEvent('electricchair:server:triggerExecution', netId, sittingId)
    TriggerEvent('ox_lib:notify', {
        title = 'Electric Chair',
        description = 'Execution triggered!',
        type = 'info'
    })
end)

-- Function to pick up the chair
RegisterNetEvent('electricchair:client:pickupChair', function()
    if isSitting then
        TriggerEvent('ox_lib:notify', {
            title = "Cannot Pick Up",
            description = "You can't pick up the chair while someone is sitting on it.",
            type = 'error'
        })
        print("[DEBUG] Pickup failed: Chair occupied")
        return
    end
    
    local ped = PlayerPedId()
    
    LocalPlayer.state:set('inv_busy', true, true)
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), -1, true, false, false, false)
    ExecuteCommand('closeInv')
    Wait(2000)
    
    if deployedChair then
        DeleteObject(deployedChair)
        TriggerServerEvent('electricchair:server:removeChair', chairNetId)
        deployedChair = nil
        chairNetId = nil
        print("[DEBUG] Chair picked up - netId: " .. tostring(chairNetId))
    end
    
    ClearPedTasks(ped)
    LocalPlayer.state:set('inv_busy', false, true)
    
    TriggerEvent('ox_lib:notify', {
        title = 'Electric Chair',
        description = 'You picked up the electric chair.',
        type = 'success'
    })
end)

RegisterNetEvent('electricchair:client:executePlayer')
AddEventHandler('electricchair:client:executePlayer', function()
    local ped = PlayerPedId()
    local cycles = 5 
    local cycleDuration = 1000 
    
    
    local animDict = "script_common"
    local animName = "electrocution"
    RequestAnimDict(animDict)
    
    
    local executionNetId = sittingNetId
    local playerId = GetPlayerServerId(PlayerId())
    
    
    Citizen.CreateThread(function()
        
        for i = 1, cycles do
            
            SetEntityHealth(ped, GetEntityHealth(ped) - 20)
            
            
            SetPedToRagdoll(ped, 1500, 1500, 0, false, false, false)
            ShakeGameplayCam("DRUNK_SHAKE", 1.0)
            
           
            local coords = GetEntityCoords(ped)
            UseParticleFxAsset(FX_GROUP)
            StartParticleFxNonLoopedAtCoord(FX_NAME, coords.x, coords.y, coords.z + 0.5, 
                0.0, 0.0, 0.0, FX_SCALE, false, false, false)
            
            
            TriggerEvent('ox_lib:notify', {
                title = 'Electric Chair',
                description = 'You\'re being electrocuted!',
                type = 'error',
                duration = 1500
            })
            
            
            Wait(cycleDuration)
        end
        
        
        
        
        ExecuteCommand("kill")
        
        
        Wait(250)
        SetEntityHealth(ped, 0)
        
        
        Wait(250)
        if not IsEntityDead(ped) then
            SetEntityInvincible(ped, false)
            SetPlayerInvincible(PlayerId(), false)
            NetworkSetEntityInvisibleToNetwork(ped, true)
            Wait(50)
            NetworkSetEntityInvisibleToNetwork(ped, false)
            Wait(50)
            SetEntityHealth(ped, 0)
        end
        
        
        Wait(250)
        if not IsEntityDead(ped) then
            TriggerEvent("RSGCore:Client:KillPlayer")
        end
        
        
        Wait(250)
        if not IsEntityDead(ped) then
            TriggerServerEvent("RSGCore:Server:Kill:Player")
        end
        
        
        isSitting = false
        sittingPlayerId = nil
        sittingNetId = nil
        
        
        StopGameplayCamShaking(true)
        
        
        if executionNetId then
            TriggerServerEvent('electricchair:server:playerStoodUp', executionNetId)
        end
    end)
end)


RegisterNetEvent('electricchair:client:executionEffects')
AddEventHandler('electricchair:client:executionEffects', function(netId)
    local chairEntity = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(chairEntity) then
       
        return
    end
    
    local coords = GetEntityCoords(chairEntity)
    local fxCoords = vector3(coords.x, coords.y, coords.z + 0.5)
    local playerCoords = GetEntityCoords(PlayerPedId())
    
    if #(playerCoords - coords) < 10.0 then
        
        for i = 1, 7 do
            
            UseParticleFxAsset(FX_GROUP)
            StartParticleFxNonLoopedAtCoord(FX_NAME, fxCoords.x, fxCoords.y, fxCoords.z, 0.0, 0.0, 0.0, FX_SCALE, false, false, false)
           
            
            
            ShakeGameplayCam("DRUNK_SHAKE", 0.5)
            Wait(2000)
        end
        StopGameplayCamShaking(true)
    end
   
end)


RegisterNetEvent('electricchair:client:playerSitting')
AddEventHandler('electricchair:client:playerSitting', function(netId, sittingId)
    local chairEntity = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(chairEntity) then
        sittingStates[netId] = sittingId
        
    else
       
        local retries = 0
        Citizen.CreateThread(function()
            while retries < 5 do
                Wait(2000)
                chairEntity = NetworkGetEntityFromNetworkId(netId)
                if DoesEntityExist(chairEntity) then
                    sittingStates[netId] = sittingId
                    
                    return
                end
                retries = retries + 1
               
            end
            TriggerEvent('ox_lib:notify', {
                title = 'Electric Chair',
                description = 'Failed to sync chair state. Please try again.',
                type = 'error'
            })
           
        end)
    end
end)


RegisterNetEvent('electricchair:client:playerStoodUp')
AddEventHandler('electricchair:client:playerStoodUp', function(netId)
    sittingStates[netId] = nil
   
end)


RegisterNetEvent('electricchair:client:requestSittingState')
AddEventHandler('electricchair:client:requestSittingState', function(netId, sittingId)
    if sittingId then
        local chairEntity = NetworkGetEntityFromNetworkId(netId)
        if DoesEntityExist(chairEntity) then
            sittingStates[netId] = sittingId
           
        else
           
        end
    else
        sittingStates[netId] = nil
       
    end
end)


AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    if deployedChair then
        DeleteObject(deployedChair)
       
    end
    sittingStates = {}
end)


CreateThread(function()
    RegisterChairTargeting()
  
    TriggerServerEvent('electricchair:server:requestAllSittingStates')
end)