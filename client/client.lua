ESX = exports["es_extended"]:getSharedObject()
local ped = PlayerPedId()
local x,y,z = table.unpack(GetEntityCoords(ped))
-- Ox_Target stuff

local options =     {
	name = 'wx_carlock:target',
	icon = 'fa-solid fa-lock',
	label = wx.Locale["TargetLabel"],
	onSelect = function()
		ToggleLock()
	end
}

if wx.targetSupport then exports.ox_target:addGlobalVehicle(options) end

-- Main functions

function ToggleLock()
	local vehicle


	if IsPedInAnyVehicle(ped, false) then
		vehicle = GetVehiclePedIsIn(ped, false)
	else
		vehicle = GetClosestVehicle(x,y,z, wx.checkRadius, 0, 71)
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
			return
		end
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
				if wx.Sounds then PlaySoundFromCoord(-1,"PIN_BUTTON",x,y,z,"ATM_SOUNDS", true, 5, false) end

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
				if wx.Sounds then PlaySoundFromCoord(-1,"PIN_BUTTON",x,y,z,"ATM_SOUNDS", true, 5, false) end

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
			else
				EnableControlAction(0,75,true)
			end

			-- If player is trying to exit the locked vehicle, show an error notification
			if IsDisabledControlJustPressed(0,75) then
				lib.notify({
					title = wx.Locale["NotifyTitle"],
					description = wx.Locale["LockedWhileInside"],
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
		end
end)



RegisterCommand('carlock',function ()
	ToggleLock()
end,false)
RegisterKeyMapping('carlock', 'Lock or Unlock your personal vehicle', 'keyboard', 'l')
-- PlaySoundFrontend(-1, "BUTTON", "MP_PROPERTIES_ELEVATOR_DOORS", 1)
