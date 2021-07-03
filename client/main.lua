-- Vars
Cancel = false
inEdit = false
DevMode(false)
Props = {}
Core = nil

-- ESX
CreateThread(function()
    while Core == nil do
        TriggerEvent('esx:getSharedObject', function(obj) Core = obj end)
        Wait(0)
    end

    while Core.GetPlayerData() == nil do
        Wait(0)
    end

    PD = Core.GetPlayerData()
end)

-- Threads
CreateThread(function()
    while true do
        local msec = 250
        if propList == '[]' then
            msec = 1000
        else
            msec = 0
            local pCoords = GetEntityCoords(PlayerPedId())
            for k,v in pairs(Props) do
                if #(pCoords - vector3(v.coords.x, v.coords.y, v.coords.z)) < 2 then
                    if PD.job.name == Props[k].job then
                        DrawText3Ds(vector3(v.coords.x, v.coords.y, v.coords.z+2), "~g~E~w~ - "..Config.Locales[Config.Locale].Delete, 0.35, 4, false)
                        if old_IsControlJustPressed(0, 38) then
                            TaskPlayAnim(PlayerPedId(), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 3.0, 3.0, -1, 16, 0)
                            Wait(2500)
                            ClearPedTasks(PlayerPedId())
                            DeleteEntity(Props[k].props)
                            Props[k] = nil
                        end
                    end
                end
            end
        end
        Wait(msec)
    end
end)

-- Funcs
PlaceObject = function(cancel, prop)
    inEdit = true
    CreateLoop(function()
        if Cancel then
            ClearPedTasksImmediately(PlayerPedId())
            DeleteEntity(Obj, false)
            _break()
        end
        local pCoords = GetEntityCoords(PlayerPedId())
        local forward = GetEntityForwardVector(PlayerPedId())
        local oCoords = (vector3(pCoords.x, pCoords.y, pCoords.z-1) + forward * 1.0)
        if old_IsControlJustPressed(0, 191) then
            DeleteEntity(Obj, false)
            ClearPedTasksImmediately(PlayerPedId())
            TaskPlayAnim(PlayerPedId(), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 3.0, 3.0, -1, 16, 0)
            Wait(2500)
            ClearPedTasks(PlayerPedId())
            local obj, netId = CreateObject(prop, oCoords, true)
            PlaceObjectOnGroundProperly(obj)
            FreezeEntityPosition(obj, true)
            SetEntityInvincible(obj, true)
            SetEntityHeading(obj, GetEntityHeading(PlayerPedId()))
            Props[netId] = {
                props = obj,
                propLabel = prop,
                coords = oCoords,
                job = PD.job.name
            }
            Cancel = true
            inEdit = false
        end
        PlaceObjectOnGroundProperly(Obj)
        SetEntityCoords(Obj, oCoords)
        SetEntityAlpha(Obj, 150)
    end)
end

-- Commands
RegisterCommand(Config.Command, function(player, args)
    if args[1] == Config.CancelArg then
        Cancel = true
        inEdit = false
        return
    end
    local Allowed = {allowed = false, prop = nil}
    for i,v in pairs(Config.Objects) do
        if args[1] == v.prop then
            for a,b in pairs(v.jobs) do
                if PD.job.name == b then
                    Allowed = {allowed = true, prop = i}
                end
            end
        end
    end

    if Allowed.allowed then
        if inEdit then
            ShowNotification(Config.Locales[Config.Locale].AlreadyPlaceObj)
        else
            Cancel = false
            Obj = nil
            Obj, netId = CreateObject(Allowed.prop, GetEntityCoords(PlayerPedId()), false)
            TakeObjectOnHand(PlayerPedId(), Obj)
            PlaceObject(false, Allowed.prop)
        end
    else
        ShowNotification(Config.Locales[Config.Locale].NotAllowed)
    end
end)

-- Events
RegisterNetEvent('esx:playerLoaded', function()
    PD = Core.GetPlayerData()
end)

RegisterNetEvent('esx:setJob', function(job)
    PD.job = job
end)