ESX                           = nil
Citizen.CreateThread(function ()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
  end
end)

local distanciaJugador = {}
local habilitado = false

Citizen.CreateThread(function()
    while true do 
        if IsControlJustPressed(0, Config.Key) then
            habilitado = not habilitado
            Wait(50)
        end
        Wait(0)
    end
end)

local function DrawText3D(position, text, r,g,b) 
    local onScreen,_x,_y=World3dToScreen2d(position.x,position.y,position.z+1)
    local dist = #(GetGameplayCamCoords()-position)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        if not useCustomScale then
            SetTextScale(0.0*scale, 0.55*scale)
        else 
            SetTextScale(0.0*scale, customScale)
        end
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

Citizen.CreateThread(function()
	Wait(500)
    while true do
        if habilitado then
            for _, id in ipairs(GetActivePlayers()) do
                local targetPed = GetPlayerPed(id)
                if targetPed ~= PlayerPedId() then
                    if distanciaJugador[id] then
                        if distanciaJugador[id] < Config.DistanceToSeeID then
                            local targetPedCords = GetEntityCoords(targetPed)
                            if GetPedDrawableVariation(targetPed, 1) <= 0 then
                                if NetworkIsPlayerTalking(id) then
                                    DrawText3D(targetPedCords, GetPlayerServerId(id), 247,124,24)
                                    DrawMarker(27, targetPedCords.x, targetPedCords.y, targetPedCords.z-0.97, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 173, 216, 230, 100, 0, 0, 0, 0)
                                else
                                    DrawText3D(targetPedCords, GetPlayerServerId(id), 255,255,255)
                                end
                            else
                                if NetworkIsPlayerTalking(id) then
                                    DrawText3D(targetPedCords, "Desconocido | "..GetPlayerServerId(id).."", 247,124,24)
                                    DrawMarker(27, targetPedCords.x, targetPedCords.y, targetPedCords.z-0.97, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 173, 216, 230, 100, 0, 0, 0, 0)
                                else
                                    DrawText3D(targetPedCords, "Desconocido | "..GetPlayerServerId(id).."", 255,255,255)
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for _, id in ipairs(GetActivePlayers()) do
            local targetPed = GetPlayerPed(id)
            if targetPed ~= playerPed then
                local distance = #(playerCoords-GetEntityCoords(targetPed))
				distanciaJugador[id] = distance
            end
        end
        Wait(1000)
    end
end)