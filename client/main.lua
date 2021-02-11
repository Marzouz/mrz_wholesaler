ESX                 = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local HasAlreadyEnteredMarker

local function showNotification(message)
	AddTextEntry('mrzNotification', message)
	BeginTextCommandThefeedPost('mrzNotification')
    EndTextCommandThefeedPostMessagetext(Config.notificationTexture, Config.notificationTexture, false, Config.notificationIconType, Language['sender'], Language['subject'])
	EndTextCommandThefeedPostTicker(false, true)
end
local function showInfo(info)
	SetTextComponentFormat("STRING")
	AddTextComponentString(info)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
RegisterNetEvent('mrz_wholesaler:showMessage')
AddEventHandler('mrz_wholesaler:showMessage', function(message)
    showNotification(message)
end)
local function OpenMarketMenu(datas)
    local elements = {}
    for i=1, #datas.items, 1 do
		local item = datas.items[i]

		table.insert(elements, {
			label      = item.label .. ' - <span style="color:green;">'.. item.price ..'$</span>',
			itemLabel  = item.label,
			item       = item.item,
			price      = item.price,
		})
	end

    ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop', {
		title    = Language['title_menu'],
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
        ESX.UI.Menu.Open(
        'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
        {
            title = Language['title_quantity']
        },
        function(data1, dialogMenu)
            menu.close()
            local amount = tonumber(data1.value)
            if amount ~= nil then
                if datas.OpeningTime.enabled then
                    local hours = tonumber(GetClockHours())
                    if hours > datas.OpeningTime.OpenHours and hours < datas.OpeningTime.CloseHours then
                        dialogMenu.close()
                        TriggerServerEvent('mrz_wholesaler:requestSellItems', data.current.item, data.current.price, data.current.itemLabel, amount)
                    else
                        dialogMenu.close()
                        showNotification(Language["closed"])
                    end
                else
                    dialogMenu.close()
                    TriggerServerEvent('mrz_wholesaler:requestSellItems', data.current.item, data.current.price, data.current.itemLabel, amount)
                end
            end
        end,
        function(data1, dialogMenu)
            dialogMenu.close()
        end)
	end, function(data, menu)
		menu.close()

		currentAction     = 'shop_menu'
		currentActionMsg  = Language['actionMessage']
		currentActionData = {data = data}
	end)
end

AddEventHandler('mrz_wholesaler:hasEnteredMarker', function(value)
    CurrentAction       = 'shop_menu'
    CurrentActionMsg    = Language['actionMessage']
    CurrentActionData   = {data = Config.Markets[value]}
end)
AddEventHandler('mrz_wholesaler:hasExitedMarker', function(zone)
    CurrentAction   = nil
    ESX.UI.Menu.CloseAll()
end)

Citizen.CreateThread(function()
    for k,v in pairs(Config.Markets) do
        local market = v
        if (market.blipEnabled) then
            local blipMarker = market.blip
            local blipCoord = AddBlipForCoord(blipMarker.Pos.x, blipMarker.Pos.y, blipMarker.Pos.z)
            SetBlipSprite (blipCoord, blipMarker.Sprite)
            SetBlipDisplay(blipCoord, blipMarker.Display)
            SetBlipScale  (blipCoord, blipMarker.Scale)
            SetBlipColour (blipCoord, blipMarker.Colour)
            SetBlipAsShortRange(blipCoord, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blipMarker.label)
            EndTextCommandSetBlipName(blipCoord)
        end
    end
end)
Citizen.CreateThread(function()
    while true do
        if ESX ~= nil then
            local coords = GetEntityCoords(PlayerPedId())
            
            for k,v in pairs(Config.Markets) do
                for i = 1, #v.location.position, 1 do
                    if (v.location.Type ~= -1 and GetDistanceBetweenCoords(coords, v.location.position[i].x, v.location.position[i].y, v.location.position[i].z, true) < Config.DrawDistance) then
                        DrawMarker(v.location.Type,  v.location.position[i].x, v.location.position[i].y, v.location.position[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.location.Size.x, v.location.Size.y, v.location.Size.z, v.location.Color.r, v.location.Color.g, v.location.Color.b, 100, false, false, 2, false, false, false, false)
                    end
                end
            end
            Citizen.Wait(0)
        else
            Citizen.Wait(3000)
        end
    end
end)
Citizen.CreateThread(function()
    while true do
        if ESX ~= nil then
            local coords      = GetEntityCoords(PlayerPedId())
            local isInMarker  = false
            local currentZone = nil

            for k,v in pairs(Config.Markets) do
                for i = 1, #v.location.position, 1 do
                    if (GetDistanceBetweenCoords(coords, v.location.position[i].x, v.location.position[i].y, v.location.position[i].z, true) < v.location.Size.x) then
                        isInMarker  = true
                        currentZone = k
                    end
                end
            end

            if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
                HasAlreadyEnteredMarker = true
                LastZone                = currentZone
                TriggerEvent('mrz_wholesaler:hasEnteredMarker', currentZone)
            end

            if not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerEvent('mrz_wholesaler:hasExitedMarker', LastZone)
            end
            
            if isInMarker == false then
                Citizen.Wait(3000) 
            else
                Citizen.Wait(0)
            end
        else
            Citizen.Wait(3000)
        end
    end
end)
Citizen.CreateThread(function()
    while true do
        if ESX ~= nil then
            if CurrentAction ~= nil then
                if not IsPedInAnyVehicle(PlayerPedId(), false) then
                    SetTextComponentFormat('STRING')
                    AddTextComponentString(CurrentActionMsg)
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                    
                    if CurrentAction == 'shop_menu' then
                        if IsControlJustReleased(0, Config.keys['interact']) then
                            OpenMarketMenu(CurrentActionData.data)
                            CurrentAction = nil
                        end
                    end
                end
            end
            Citizen.Wait(0)
        else
            Citizen.Wait(3000)
        end
    end
end)