local QBCore = exports['qb-core']:GetCoreObject()

-- Give fish to player
RegisterNetEvent('qb-fishing:catchFish', function(fish)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(fish, 1)
    TriggerClientEvent('QBCore:Notify', src, "You caught a fish!", "success")
end)

-- Sell all fish
RegisterNetEvent('qb-fishing:sellFish', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local totalMoney = 0

    for _, fish in pairs(Config.FishItems) do
        local amount = Player.Functions.GetItemByName(fish.name)
        if amount ~= nil then
            Player.Functions.RemoveItem(fish.name, amount.amount)
            totalMoney = totalMoney + (amount.amount * fish.price)
        end
    end

    if totalMoney > 0 then
        Player.Functions.AddMoney('cash', totalMoney, "sold-fish")
        TriggerClientEvent('QBCore:Notify', src, "You sold your fish for $"..totalMoney, "success")
    else
        TriggerClientEvent('QBCore:Notify', src, "You have no fish to sell!", "error")
    end
end)
