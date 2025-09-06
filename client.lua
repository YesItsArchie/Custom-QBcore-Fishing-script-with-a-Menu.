local QBCore = exports['qb-core']:GetCoreObject()
local isFishing = false

-- Key to open menu
local MenuKey = 38 -- E key

-- Open fishing menu
function OpenFishingMenu()
    local elements = {
        {label = "Start Fishing 🎣", value = "start_fishing"},
        {label = "Sell Fish 💰", value = "sell_fish"},
        {label = "Check Inventory 📦", value = "check_inventory"},
    }

    QBCore.UI.Menu.Open('default', GetCurrentResourceName(), 'fishing_menu', {
        title = "Fishing Menu",
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == "start_fishing" then
            StartFishing()
        elseif data.current.value == "sell_fish" then
            TriggerServerEvent('qb-fishing:sellFish')
        elseif data.current.value == "check_inventory" then
            TriggerEvent('inventory:client:OpenInventory')
        end
    end, function(data, menu)
        menu.close()
    end)
end

-- Start fishing
function StartFishing()
    if isFishing then return end
    isFishing = true
    QBCore.Functions.Notify("You started fishing... 🎣", "success")

    local playerPed = PlayerPedId()
    local dict = "amb@world_human_stand_fishing@base"
    local anim = "base"

    -- Load animation dictionary
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end

    -- Start fishing animation
    TaskPlayAnim(playerPed, dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)

    -- Progress bar for fishing (optional, nice visual)
    QBCore.Functions.Progressbar("fishing", "Fishing...", Config.FishingTime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- On finish
        ClearPedTasks(playerPed)
        local caughtFish = Config.FishItems[math.random(#Config.FishItems)]
        TriggerServerEvent('qb-fishing:catchFish', caughtFish.name)
        isFishing = false
    end, function() -- On cancel
        ClearPedTasks(playerPed)
        QBCore.Functions.Notify("Fishing cancelled", "error")
        isFishing = false
    end)
end
