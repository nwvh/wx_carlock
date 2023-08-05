ESX = exports["es_extended"]:getSharedObject()

-- Ox_Target stuff

local options =     {
	name = 'wx_carlock:target',
	icon = wx.targetIcon,
	label = wx.Locale["TargetLabel"],
	onSelect = function(data)
		ToggleLock(data.entity)
	end
}

if wx.targetSupport then exports.ox_target:addGlobalVehicle(options) end

-- Main functions

local function vehLights(vehicle)
	SetVehicleLights(vehicle, 2)
	Wait(200)
	SetVehicleLights(vehicle, 0)
	Wait(150)
	SetVehicleLights(vehicle, 2)
	Wait(500)
	SetVehicleLights(vehicle, 0)
end
local function vehHorn(vehicle)
	StartVehicleHorn(vehicle, 200, "HELDDOWN", false)
	Wait(300)
	StartVehicleHorn(vehicle, 150, "HELDDOWN", false)
end

function ToggleLock(entity)
	local vehicle
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	if not entity then
		if IsPedInAnyVehicle(ped, false) then
			vehicle = GetVehiclePedIsIn(ped, false)
		else
			vehicle = GetClosestVehicle(x,y,z, 8.0, 0, 71)
		end
	else
		vehicle = entity
	end
	if not DoesEntityExist(vehicle) then
		if wx.Notifications.NoNearbyVehicles then
			lib.notify({
				title = wx.Locale["NotifyTitle"],
				description = wx.Locale["NoVehicleNearby"],
				position = 'top',
				style = {
					backgroundColor = '#1E1E2E',
					color = '#C1C2C5',
					['.description'] = {
					color = '#909296'
					}
				},
				icon = 'triangle-exclamation',
				iconColor = '#f38ba8'
			})
		end
		return
	end

	ESX.TriggerServerCallback('wx_carlock:getVeh', function(Owned)

		if Owned then
			local lockStatus = GetVehicleDoorLockStatus(vehicle)

			if lockStatus == 1 then -- Vehicle is unlocked
				SetVehicleDoorsLocked(vehicle, 2)
				ExecuteCommand(wx.commandOnLock)
				lib.progressCircle({
					duration = wx.progressLength,
					label = wx.Locale['ProgressLocking'],
					position = 'bottom',
					useWhileDead = false,
					canCancel = false,
					disable = wx.ToDisable,
					anim = wx.Anim,

				})
				if wx.Notifications.Locked then
					lib.notify({
						title = wx.Locale["NotifyTitle"],
						description = wx.Locale["NotifyLocked"],
						position = 'top',
						style = {
							backgroundColor = '#1E1E2E',
							color = '#C1C2C5',
							['.description'] = {
							color = '#909296'
							}
						},
						icon = 'lock',
						iconColor = '#f38ba8'
					})
				end
				if wx.Sounds then PlaySoundFromCoord(-1,"PIN_BUTTON",x,y,z,"ATM_SOUNDS", true, 5, false) end
				vehLights(vehicle)
			elseif lockStatus == 2 then -- Vehicle is locked
				SetVehicleDoorsLocked(vehicle, 1)
				ExecuteCommand(wx.commandOnUnLock)
				lib.progressCircle({
					duration = wx.progressLength,
					label = wx.Locale['ProgressUnLocking'],
					position = 'bottom',
					useWhileDead = false,
					canCancel = false,
					disable = wx.ToDisable,
					anim = wx.Anim,

				})				
				if wx.Notifications.Unlocked then
					lib.notify({
						title = wx.Locale["NotifyTitle"],
						description = wx.Locale["NotifyUnLocked"],
						position = 'top',
						style = {
							backgroundColor = '#1E1E2E',
							color = '#C1C2C5',
							['.description'] = {
							color = '#909296'
							}
						},
						icon = 'lock-open',
						iconColor = '#a6e3a1'
					})
				end
				if wx.Sounds then PlaySoundFromCoord(-1,"PIN_BUTTON",x,y,z,"ATM_SOUNDS", true, 5, false) end
				if wx.Horn then vehHorn(vehicle) end
				if wx.Lights then vehLights(vehicle) end
			end
		else
			if wx.Notifications.NotYourVehicle then
				lib.notify({
					title = wx.Locale["NotifyTitle"],
					description = wx.Locale["NotOwned"],
					position = 'top',
					style = {
						backgroundColor = '#1E1E2E',
						color = '#C1C2C5',
						['.description'] = {
						color = '#909296'
						}
					},
					icon = 'triangle-exclamation',
					iconColor = '#f38ba8'
				})
				return
			end
		end

	end, ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)))
end


-- Check if the player is sitting in locked vehicle
Citizen.CreateThread(function ()
		while true do
			Wait(0)
			if IsPedInAnyVehicle(PlayerPedId(),false) and GetVehicleDoorLockStatus(GetVehiclePedIsIn(PlayerPedId(),false)) == 2 then
				DisableControlAction(0,75,true)
			elseif not IsPedInAnyVehicle(PlayerPedId(),false) then
				EnableControlAction(0,75,true)
			else
				EnableControlAction(0,75,true)
			end
		end
end)


RegisterCommand('carlock',function ()
	ToggleLock()
	Citizen.Wait(300)
end,false)
RegisterKeyMapping('carlock', 'Lock or Unlock your personal vehicle', 'keyboard', 'l')
