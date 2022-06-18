ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent(Legacy.getSharedObject, function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
    while true do
        Wait(500)
        if ESX.IsPlayerLoaded() then 
        if NetworkIsPlayerActive(PlayerId()) then
            OpenLoginMenu(true)
            break
        end
    end
    end
end)



local cam
function OpenLoginMenu(bool)
    if bool then
        
if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
      end
    
      SetCamActive(cam, true)
      RenderScriptCams(true, true, 500, true, true)
    
      isCameraActive = true
      SetCamRot(cam, 0.0, 0.0, -30.0, true)        
      SetCamCoord(cam, 2106.46, 6983.83, 74.38 + 190.8915)
          PointCamAtCoord(cam, 2106.46, 6983.83, 74.38 + 180.8915)
          ESX.TriggerServerCallback('legacy_login:name', function(name)
            SendNUIMessage({
                action = "openlogin",
                name = name:upper()
            })
          end) 
           

    SetNuiFocus(true, true)
else
    SetCamActive(cam, false)
    RenderScriptCams(false, true, 500, true, true)
    cam = nil
    SendNUIMessage({ 
        action = "closelogin"
    })
    TriggerServerEvent('player:setDim', 0)
    SetNuiFocus(false, false)
    SwitchOutPlayer(PlayerPedId(), 0, 1)
    Wait(5000)
    SwitchInPlayer(PlayerPedId())
end
end


RegisterNUICallback('notify', function(data)
    msg(data.text, data.text2)
end)

RegisterNUICallback('abgelaufen', function(data)
    TriggerServerEvent('legacy_login:k')
end)

RegisterNUICallback('login', function(data)
    local pwenc = data.pwenc
    if ESX.IsPlayerLoaded() then
        TriggerServerEvent('legacy_login:log', pwenc)
    else
        msg('login', 'Warte noch, du bist noch nicht geladen')
    end
end)

RegisterNetEvent('notifylogin')
AddEventHandler('notifylogin', function(ub, nsg)
    msg(ub, nsg)
end)

RegisterNetEvent('legacy_login:passwkorrektjoin')
AddEventHandler('legacy_login:passwkorrektjoin', function()
    OpenLoginMenu(false)
end)


function msg(uberschrift, msg)
    if Legacy.NotifyUeberschrift then
        if Legacy.NotifyFarbe then
            TriggerEvent(Legacy.NotifyTrigger, Legacy.NotifyFarbe, uberschrift, msg)
        else
            TriggerEvent(Legacy.NotifyTrigger, uberschrift, msg)
        end
    else
        if Legacy.NotifyFarbe then
            TriggerEvent(Legacy.NotifyTrigger, Legacy.NotifyFarbe, msg)
        else
            TriggerEvent(Legacy.NotifyTrigger, msg)
        end
    end
end