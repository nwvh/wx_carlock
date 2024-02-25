ESX = exports["es_extended"]:getSharedObject()
local sharedKeys = {}

function Notify(id, data)
    TriggerClientEvent("ox_lib:notify", id, data)
end

-- Check if player owns the vehicle he's trying to lock/unlock
ESX.RegisterServerCallback('wx_carlock:getVeh', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	if sharedKeys[tostring(source)] == plate then return cb("shared") end
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE owner = @owner AND plate = @plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = plate
	}, function(result)
		cb(result[1] ~= nil)
	end)
end)


lib.callback.register('wx_carlock:shareKeys', function(source, target, plate)
    if target then
		if sharedKeys[tostring(target)] == string.gsub(plate, "^%s*(.-)%s*$", "%1") then
			return Notify(
				source,
				{
					title = "Shared Keys",
					description = "You've already gave the keys for this vehicle to this player",
					iconAnimation = "beat",
					type = "error",
					duration = 4000
				}
			)
		end
		sharedKeys[tostring(target)] = string.gsub(plate, "^%s*(.-)%s*$", "%1")
		print(json.encode(sharedKeys,{indent=true}))

		Notify(
            target,
            {
                title = "Shared Keys",
                description = "You have received keys for "..plate,
                iconAnimation = "beat",
                type = "success",
                duration = 4000
            }
        )
		Notify(
            source,
            {
                title = "Shared Keys",
                description = "You have shared the keys keys for "..plate.." to player "..GetPlayerName(target),
                iconAnimation = "beat",
                type = "success",
                duration = 4000
            }
        )

	end
end)

lib.callback.register('wx_carlock:removeKeys', function(source, target,plate)
    if plate and target then
		for k,v in pairs(sharedKeys) do
			if k == target then
				if string.gsub(v, "^%s*(.-)%s*$", "%1") == string.gsub(plate, "^%s*(.-)%s*$", "%1") then
					sharedKeys[k] = nil
				end
			end
		end
		Notify(
            target,
            {
                title = "Shared Keys",
                description = "Your key from "..plate.." has been removed by the vehicle owner.",
                iconAnimation = "beat",
                type = "error",
                duration = 4000
            }
        )
		Notify(
            source,
            {
                title = "Shared Keys",
                description = "You have removed the keys to "..plate.." from the player.",
                iconAnimation = "beat",
                type = "success",
                duration = 4000
            }
        )
	end
end)

lib.callback.register('wx_carlock:getSharedKeys', function(source, plate)
    if plate then
		local toreturn = {}
		for k,v in pairs(sharedKeys) do
			print(plate,v)
			if string.gsub(v, "^%s*(.-)%s*$", "%1") == string.gsub(plate, "^%s*(.-)%s*$", "%1") then
				table.insert(toreturn,{
					id = k,
					plate = v,
					player = GetPlayerName(k)
				})
			end
		end
		return toreturn
	end
end)

exports("shareKey",function (playerId,plate)
	if playerId and plate then
		if sharedKeys[tostring(playerId)] == string.gsub(plate, "^%s*(.-)%s*$", "%1") then
			return false
		end
		sharedKeys[tostring(playerId)] = string.gsub(plate, "^%s*(.-)%s*$", "%1")
	end
end)