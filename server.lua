ESX = nil

TriggerEvent(Legacy.getSharedObject, function(obj) ESX = obj end)

RegisterNetEvent('legacy_login:k')
AddEventHandler('legacy_login:k', function()
    local s = source
    DropPlayer(s, "Deine Anmelde Zeit ist abgelaufen")
end)

RegisterNetEvent('legacy_login:log')
AddEventHandler('legacy_login:log', function(pwenc)
    local s = source
    local xPlayer = ESX.GetPlayerFromId(s)
    local license = xPlayer.identifier
    local steam = "unknown"
    for k, v in pairs(GetPlayerIdentifiers(s)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steam = v
        end
    end
    if Legacy.V1 == false then
    MySQL.Async.fetchAll(
    'SELECT password FROM users WHERE identifier = @steam',
    {
        ['@steam'] = steam
    }, function(result)
        pwresult = result[1].password
        if pwresult == nil then
            MySQL.Async.execute('UPDATE users SET password = @password WHERE identifier = @steam', {['@steam'] = steam, ['@password'] = pwenc})
            TriggerClientEvent('notifylogin', s, 'login', 'Passwort wurde erfolgreich erstellt')
            TriggerClientEvent('legacy_login:passwkorrektjoin', s)
            Wait(100)
        else
            if pwenc == pwresult then
                TriggerClientEvent('notifylogin', s, 'login', 'Willkommen zurück, ' .. xPlayer.getName())
                TriggerClientEvent('legacy_login:passwkorrektjoin', s)
            else
                TriggerClientEvent('notifylogin', s, 'login', 'Passwort ist falsch')
            end
        end
    end)
else
    MySQL.Async.fetchAll(
        'SELECT password FROM users WHERE identifier = @license',
        {
            ['@license'] = license
        }, function(result)
            pwresult = result[1].password
            
            if pwresult == nil then
                MySQL.Async.execute('UPDATE users SET password = @password WHERE identifier = @license', {['@license'] = license, ['@password'] = pwenc})
                TriggerClientEvent('notifylogin', s, 'login', 'Passwort wurde erfolgreich erstellt')
                TriggerClientEvent('legacy_login:passwkorrektjoin', s)
                Wait(100)
            else
                if pwenc == pwresult then
                    TriggerClientEvent('notifylogin', s, 'login', 'Passwort ist korrekt')
                    TriggerClientEvent('legacy_login:passwkorrektjoin', s)
                else
                    TriggerClientEvent('notifylogin', s, 'login', 'Passwort ist falsch')
                end
            end
        end)
end
end)


ESX.RegisterServerCallback('legacy_login:name', function(source, cb, name)
    local s = source
    local xPlayer = ESX.GetPlayerFromId(s)
    local name = xPlayer.getName()
    cb(name)
end)