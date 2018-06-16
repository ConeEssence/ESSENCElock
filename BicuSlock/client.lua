##SCRIPT CREATED BY CONE FOR YOURLFIERP COMMUNITY AND OTHER ESSENCE COMMUNITIES. If you want buy some more advanced script text to me on YOURLIFERP.PL DISCORD or ESSENCE DISCORD##

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local notificationParam = 1
local keyParam = Key["U"]
local soundEnable = true
local disableCar_NPC = true
local soundDistance = 10

local player = GetPlayerPed(-1)

Citizen.CreateThread(function()
	while true do
		Wait(0)

		vehicle = GetVehiclePedIsIn(player, false)
		isPlayerInside = IsPedInAnyVehicle(player, true)

		if IsControlJustPressed(1, keyParam) then

			player = GetPlayerPed(-1)
			lastVehicle = GetPlayersLastVehicle()
			px, py, pz = table.unpack(GetEntityCoords(player, true))
			coordA = GetEntityCoords(player, true)

			for i = 1, 32 do
				coordB = GetOffsetFromEntityInWorldCoords(player, 0.0, (6.281)/i, 0.0)
				targetVehicle = GetVehicleInDirection(coordA, coordB)
				if targetVehicle ~= nil and targetVehicle ~= 0 then
					vx, vy, vz = table.unpack(GetEntityCoords(targetVehicle, false))
						if GetDistanceBetweenCoords(px, py, pz, vx, vy, vz, false) then
							distance = GetDistanceBetweenCoords(px, py, pz, vx, vy, vz, false)
							break
						end
				end
			end

			if distance ~= nil and distance <= 5 and targetVehicle ~= 0 or vehicle ~= 0 then

				if vehicle ~= 0 then
					plate = GetVehicleNumberPlateText(vehicle)
				else
					vehicle = targetVehicle
					plate = GetVehicleNumberPlateText(vehicle)
				end

				TriggerServerEvent("ls:check", plate, vehicle, isPlayerInside, notificationParam)

			end
		end
	end
end)

RegisterNetEvent("ls:lock")
AddEventHandler("ls:lock", function(lockStatus, vehicle)

	if lockStatus == 1 or lockStatus == 0 then 

		if IsVehicleEngineOn(vehicle) and not isPlayerInside then
			SetVehicleUndriveable(vehicle, true)
		end

		SetVehicleDoorsLocked(vehicle, 2) 
		SetVehicleDoorsLockedForPlayer(vehicle, PlayerId(), true)
		TriggerServerEvent("ls:updateLockStatus", 2, plate)

		-- ## Notifications
			if soundEnable then TriggerServerEvent("InteractSound_SV:PlayWithinDistance", soundDistance, "lock", 1.0) end
			TriggerEvent("ls:sendNotification", notificationParam, "Closed.", 0.080)
		-- ## Notifications

	elseif lockStatus == 2 then

		if not IsVehicleEngineOn(vehicle) then
			Citizen.CreateThread(function()
				while true do
					Wait(0)
					if isPlayerInside then
						SetVehicleUndriveable(vehicle, false)
						break
					end
				end
			end)
		end

		SetVehicleDoorsLocked(vehicle, 1)
		SetVehicleDoorsLockedForPlayer(vehicle, PlayerId(), false)
		TriggerServerEvent("ls:updateLockStatus", 1, plate) 

		-- ## Notifications
			if soundEnable then	TriggerServerEvent("InteractSound_SV:PlayWithinDistance", soundDistance, "lock", 1.0) end
			TriggerEvent("ls:sendNotification", notificationParam, "Opened.", 0.080)
		-- ## Notifications

	end
end)

if not enableCar_NPC then
	Citizen.CreateThread(function()
    	while true do
			Wait(0)

			local player = GetPlayerPed(-1)

	        if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId(player))) then

	            local veh = GetVehiclePedIsTryingToEnter(PlayerPedId(player))
	            local lock = GetVehicleDoorLockStatus(veh)

	            if lock == 7 then
	                SetVehicleDoorsLocked(veh, 2)
	            end

	            local pedd = GetPedInVehicleSeat(veh, -1)

	            if pedd then
	                SetPedCanBeDraggedOut(pedd, false)
	            end
	        end
	    end
	end)
end

RegisterNetEvent("ls:createMissionEntity")
AddEventHandler("ls:createMissionEntity", function(vehicleId)

	SetEntityAsMissionEntity(vehicleId, true, true)
end)

RegisterNetEvent("ls:notify")
AddEventHandler("ls:notify", function(text, time)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	Citizen.InvokeNative(0x1E6611149DB3DB6B, "CHAR_PEGASUS_DELIVERY", "CHAR_PEGASUS_DELIVERY", true, 1, "ESSENCE LOCKSYSTEM", "", time)
	DrawNotification_4(false, true)
end)

RegisterNetEvent("ls:sendNotification")
AddEventHandler("ls:sendNotification", function(param, message, duration)
	if param == 1 then
		TriggerEvent("ls:notify", message, duration)
	elseif param == 2 then
		TriggerEvent('chatMessage', 'ESSENCELockSystem', { 255, 128, 0 }, message)
	end
end)

function GetVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end