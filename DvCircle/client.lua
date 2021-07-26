--[[================================================================]]--
--[[   For more support please join https://discord.gg/FAduBsz3H3   ]]--
--[[================================================================]]--

-- Config Here
Config = {
	{x = 1866.00,y = 3698.00,z = 32.61}, -- Sandy Sheriff's Office parking lot
	{x = -478.00,y = 6026.00,z = 30.35}, -- Paleto bay Sheriff's Office Parking lot
	{x = 446.00,y = -1025.00,z = 27.60}, -- Mission Row Police Department Parking lot
}
--[[ Don't edit below this unless you know what you are doing! ]]--
function alert(msg) 
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end

function DeleteGivenVehicle(veh,timeoutMax)
    local timeout = 0 
    
    SetEntityAsMissionEntity(veh, true, true)
    DeleteVehicle(veh)
    
    if (DoesEntityExist(veh)) then
        while (DoesEntityExist(veh) and timeout < timeoutMax) do 
            DeleteVehicle(veh)
            timeout = timeout + 1
            Citizen.Wait(500)
        end 
    end 
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        local ped = GetPlayerPed(-1 )
        if (IsPedSittingInAnyVehicle(ped)) then
            for k in pairs(Config) do
                DrawMarker(1, Config[k].x, Config[k].y, Config[k].z, 0, 0, 0, 0, 0, 0, 4.001, 4.0001, 0.5001, 0, 0, 255, 200, 0, 0, 0, 0)
            end
        end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		for k in pairs(Config) do

			local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config[k].x, Config[k].y, Config[k].z)
            local ped = GetPlayerPed(-1 )
            if (IsPedSittingInAnyVehicle(ped)) and dist <= 2.2 then
                alert("Press ~INPUT_CONTEXT~ to store vehicle.")
            end
            if dist <= 2.2 and IsControlJustPressed(1, 51) then
                local ped = GetPlayerPed(-1 )
                if (DoesEntityExist(ped) and not IsEntityDead(ped)) then 
                    local pos = GetEntityCoords(ped)
            
                    if (IsPedSittingInAnyVehicle(ped)) then
                        local vehicle = GetVehiclePedIsIn(ped, false)
            
                        if (GetPedInVehicleSeat(vehicle, -1) == ped) then 
                            DeleteGivenVehicle(vehicle)
                        end 
            
                        if (DoesEntityExist(vehicle)) then 
                            DeleteGivenVehicle(vehicle)
                        end 
                        notify("Vehicle returned to Garage.")
                    end 
                end
			end
		end
	end
end)
