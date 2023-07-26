ESX = exports["es_extended"]:getSharedObject()

-- Check if player owns the vehicle he's trying to lock/unlock
ESX.RegisterServerCallback('wx_carlock:getVeh', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE owner = @owner AND plate = @plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = plate
	}, function(result)
		cb(result[1] ~= nil)
	end)
end)
