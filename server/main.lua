ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('mrz_wholesaler:requestSellItems')
AddEventHandler('mrz_wholesaler:requestSellItems', function(item, price, label, amount)
    local xPlayer           = ESX.GetPlayerFromId(source)
    local quantity          = xPlayer.getInventoryItem(item).count

    if (quantity >= amount) then
        local message       = Language["selling_items"]
        local totalPrice    = ESX.Math.Round((price * amount))

        xPlayer.removeInventoryItem(item, amount)
        xPlayer.addMoney(totalPrice)

        TriggerClientEvent('mrz_wholesaler:showMessage', source, message:gsub("%%s", totalPrice))
    else
        TriggerClientEvent('mrz_wholesaler:showMessage', source, Language['invalid_quantity'])
    end
end)