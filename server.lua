ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

local function checkRole(xPlayer)
    return (xPlayer.getGroup() == "superadmin")
end

MySQL.ready(function()
    listeitemzebamk = {}
    MySQL.Async.fetchAll("SELECT * FROM items", {}, function(data)
        for _, v in pairs(data) do
            table.insert(listeitemzebamk, { name = v.name, label = v.label, limite = v.limit, consommable = v.consommable })
            if v.consommable == 'boisson' then
                print(v.consommable)
                ESX.RegisterUsableItem(v.name, function(source)
                    local _source = source
                    local xPlayer = ESX.GetPlayerFromId(_source)
                    xPlayer.removeInventoryItem(v.name, 1)
                    TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
                    TriggerClientEvent('esx_basicneeds:onDrink', source)
                    TriggerClientEvent('esx:showNotification', source, 'tu as bu une boisson')
                end)
            elseif v.consommable == 'nourriture' then
                print(v.consommable)
                ESX.RegisterUsableItem(v.name, function(source)
                    local _source = source
                    local xPlayer = ESX.GetPlayerFromId(_source)
                    xPlayer.removeInventoryItem(v.name, 1)
                    TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
                    TriggerClientEvent('esx_basicneeds:onEat', source)
                    TriggerClientEvent('esx:showNotification', source, 'tu as manger de la nourriture')
                end)
            end
        end
    end)
end)

ESX.RegisterServerCallback('h4ci_itembuilder:checkrole', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local groupe = xPlayer.getGroup()
    cb(groupe)
end)

RegisterNetEvent('h4ci_itembuilder:ajout')
AddEventHandler('h4ci_itembuilder:ajout', function(configitem, itemlimite)
    local xPlayer = ESX.GetPlayerFromId(source)
    if (not (checkRole(xPlayer))) then
        return
    end
    typeconsommable = 'rien'
    if configitem.consommable == true then
        if configitem.boisson == true then
            typeconsommable = 'boisson'
        else
            typeconsommable = 'nourriture'
        end
    end
    if itemlimite == 'limit' then
        MySQL.Async.execute('INSERT INTO items (name, label, `limit`, consommable) VALUES (@name, @label, @limit, @consommable)', {
            ['@name'] = configitem.nom,
            ['@label'] = configitem.label,
            ['@limit'] = tonumber(configitem.limite),
            ['@consommable'] = typeconsommable,
        })
    else
        MySQL.Async.execute('INSERT INTO items (name, label, `weight`, consommable) VALUES (@name, @label, @limit, @consommable)', {
            ['@name'] = configitem.nom,
            ['@label'] = configitem.label,
            ['@limit'] = tonumber(configitem.limite),
            ['@consommable'] = typeconsommable,
        })
    end
end)

RegisterServerEvent('h4ci_itembuilder:maj')
AddEventHandler('h4ci_itembuilder:maj', function(maj)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    if (not (checkRole(xPlayer))) then
        return
    end
    print(maj.limite)
    MySQL.Async.execute(
            'UPDATE items SET `limit` = @limit WHERE name = @name',
            {
                ['@limit'] = tonumber(maj.limite),
                ['@name'] = maj.name,
            }
    )
end)

ESX.RegisterServerCallback('h4ci_itemzeb:majitemzebsrv', function(_src, cb)
    local xPlayer = ESX.GetPlayerFromId(_src)
    if (not (checkRole(xPlayer))) then
        return
    end
    majitems = {}
    MySQL.Async.fetchAll("SELECT * FROM items", {}, function(data)
        for _, v in pairs(data) do
            table.insert(majitems, { name = v.name, label = v.label, limite = v.limit, consommable = v.consommable })
        end
        cb(majitems)
    end)
end)

RegisterServerEvent('h4ci_itemzeb:delete')
AddEventHandler('h4ci_itemzeb:delete', function(name)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    if (not (checkRole(xPlayer))) then
        return
    end
    if name ~= nil then
        MySQL.Async.execute(
                'DELETE FROM items WHERE name = @name',
                {
                    ['@name'] = name
                }
        )
        TriggerClientEvent('esx:showNotification', source, "Suppresion ok!")
    else
        TriggerClientEvent('esx:showNotification', source, "Impossible de supprimer, introuvable")
    end

end)


