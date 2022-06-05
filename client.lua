ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(100)
    end
    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local itemlimite = 'limit' --mettre weight si vous avez le système de poid

listeitemzeb = {}
groupejoueur = nil
h4ci_itemzeb = {
    nom = 'A saisir',
    label = 'A saisir',
    limite = ' A saisir',
    consommable = false,
    boisson = false,
    nourriture = false
}

choixitemamodif = {
    nomdebase = 'A saisir',
    name = 'A saisir',
    label = 'A saisir',
    limite = ' A saisir',
    consommable = false,
    boisson = false,
    nourriture = false
}

RegisterCommand("itembuilder", function() 
    ESX.TriggerServerCallback('h4ci_itembuilder:checkrole', function(resultatgroupe)
        groupejoueur = resultatgroupe
    end)
    if groupejoueur == 'superadmin' then
        ESX.TriggerServerCallback('h4ci_itemzeb:majitemzebsrv', function(itemsrv)
            listeitemzeb = itemsrv
        end)
        itemzebzeb2()
    else
        ESX.ShowNotification("Tu n'as pas les permissions")
    end
end)

local opitemzeb = false
local itemzebzeb = RageUI.CreateMenu("Item Builder", "Pour crée des items.") 
local creation = RageUI.CreateSubMenu(itemzebzeb, "Création d'item",  'Pour créer l\'item')
local listeitem = RageUI.CreateSubMenu(itemzebzeb, "Liste items",  'Pour voir la liste des items')
local modifitem = RageUI.CreateSubMenu(listeitem, "Modifier un item",  'Pour modifier un item')
itemzebzeb.Closed = function()
  opitemzeb = false
end

function itemzebzeb2()
    if opitemzeb == false then 
        opitemzeb = true 
        RageUI.Visible(itemzebzeb, true)
        CreateThread(function()
        while opitemzeb do 
            RageUI.IsVisible(itemzebzeb,function() 
                RageUI.Button("Créer un item",  nil, {RightLabel = "→"}, true , { 
                    onSelected = function() 
                    end
                },creation)
                RageUI.Button("Liste des items",  nil, {RightLabel = "→"}, true , { 
                    onSelected = function() 
                        ESX.TriggerServerCallback('h4ci_itemzeb:majitemzebsrv', function(itemsrv)
                            listeitemzeb = itemsrv
                        end)
                    end
                },listeitem)

            end)
            RageUI.IsVisible(listeitem,function() 
                for k,v in pairs(listeitemzeb) do
                RageUI.Button(v.name..' | '..v.label,  nil, {RightLabel = "→"}, true , { 
                    onSelected = function()
                        choixitemamodif = v
                        choixitemamodif.nomdebase = v.name
                    end
                },modifitem)
                end
            end)
            RageUI.IsVisible(modifitem,function() 
                RageUI.Button("Quantité transportable : ",  nil, {RightLabel = choixitemamodif.limite}, true , { 
                    onSelected = function() 
                        local nombreinvalide = false
                                choixitemamodif.limite = KeyboardInput('Veuillez choisir la quantité transportable', '', 9)  
                                if tonumber(choixitemamodif.limite) then
                                    ESX.ShowNotification('Nombre validé')
                                else
                                    nombreinvalide = true
                                end

                                while nombreinvalide == true do
                                    ESX.ShowNotification('Nombre invalide, veuillez recommencer')
                                    choixitemamodif.limite = KeyboardInput('Veuillez choisir la quantité transportable', '', 9)
                                    if tonumber(choixitemamodif.limite) then
                                        ESX.ShowNotification('Nombre validé')
                                        nombreinvalide = false
                                    end
                                end
                    end
                })
                RageUI.Button("Valider",  nil, {RightLabel = "→", Color = {BackgroundColor = RageUI.ItemsColour.Green}}, true , { 
                        onSelected = function()
                            if choixitemamodif.label == 'A saisir' then
                                ESX.ShowNotification("Le label n'as pas été saisi")
                            else
                                TriggerServerEvent('h4ci_itembuilder:maj', choixitemamodif)
                                ESX.ShowNotification('Mise à jour ok')
                                RageUI.CloseAll()
                                opitemzeb = false
                            end
                        end
                })
                --[[possibilité de bug
                                                RageUI.Button("Supprimer",  nil, {RightLabel = "→", Color = {BackgroundColor = RageUI.ItemsColour.Red}}, true , { 
                                                        onSelected = function()
                                                            TriggerServerEvent('h4ci_itemzeb:delete', choixitemamodif.name)
                                                            RageUI.CloseAll()
                                                            opitemzeb = false
                                                        end
                                                })]]
            end)
            RageUI.IsVisible(creation,function() 
                RageUI.Button("Nom de l'item : ",  nil, {RightLabel = h4ci_itemzeb.nom}, true , { 
                    onSelected = function() 
                        h4ci_itemzeb.nom = KeyboardInput('Veuillez saisir le nom de l\'item', '', 12)
                    end
                })
                RageUI.Button("Label de l'item : ",  nil, {RightLabel = h4ci_itemzeb.label}, true , { 
                    onSelected = function() 
                        h4ci_itemzeb.label = KeyboardInput('Veuillez saisir le label de l\'item', '', 30)
                    end
                })
                RageUI.Button("Quantité transportable : ",  nil, {RightLabel = h4ci_itemzeb.limite}, true , { 
                    onSelected = function() 
                        local nombreinvalide = false
                                h4ci_itemzeb.limite = KeyboardInput('Veuillez choisir la quantité transportable', '', 9)  
                                if tonumber(h4ci_itemzeb.limite) then
                                    ESX.ShowNotification('Nombre validé')
                                else
                                    nombreinvalide = true
                                end

                                while nombreinvalide == true do
                                    ESX.ShowNotification('Nombre invalide, veuillez recommencer')
                                    h4ci_itemzeb.limite = KeyboardInput('Veuillez choisir la quantité transportable', '', 9)
                                    if tonumber(h4ci_itemzeb.limite) then
                                        ESX.ShowNotification('Nombre validé')
                                        nombreinvalide = false
                                    end
                                end
                    end
                })
                RageUI.Checkbox("Consommable", nil, h4ci_itemzeb.consommable, {}, {
                    onChecked = function(Index, Items)
                        h4ci_itemzeb.consommable = true
                    end,
                    onUnChecked = function(Index, Items)
                        h4ci_itemzeb.consommable = false
                    end,
                })
                
                if h4ci_itemzeb.consommable == true then
                    RageUI.Separator('Choix du type de consommable')
                    RageUI.Checkbox("Boisson", nil, h4ci_itemzeb.boisson, {}, {
                    onChecked = function(Index, Items)
                        h4ci_itemzeb.boisson = true
                        if h4ci_itemzeb.nourriture == true then
                            h4ci_itemzeb.nourriture = false
                        end
                    end,
                    onUnChecked = function(Index, Items)
                        h4ci_itemzeb.boisson = false
                        if h4ci_itemzeb.nourriture == false then
                            h4ci_itemzeb.nourriture = true
                        end
                    end,
                })
                    RageUI.Checkbox("Nourriture", nil, h4ci_itemzeb.nourriture, {}, {
                    onChecked = function(Index, Items)
                        h4ci_itemzeb.nourriture = true
                        if h4ci_itemzeb.boisson == true then
                            h4ci_itemzeb.boisson = false
                        end
                    end,
                    onUnChecked = function(Index, Items)
                        h4ci_itemzeb.nourriture = false
                        if h4ci_itemzeb.boisson == false then
                            h4ci_itemzeb.boisson = true
                        end
                    end,
                })
                end
                RageUI.Button("Valider",  nil, {RightLabel = "→", Color = {BackgroundColor = RageUI.ItemsColour.Green}}, true , { 
                        onSelected = function()
                            if h4ci_itemzeb.nom == 'A saisir' then
                                ESX.ShowNotification("Le nom n'as pas été saisi")
                            elseif h4ci_itemzeb.label == 'A saisir' then
                                ESX.ShowNotification("Le label n'as pas été saisi")
                            elseif h4ci_itemzeb.limite == 'A saisir' then
                                ESX.ShowNotification("La limite n'as pas été saisi")
                            else
                                TriggerServerEvent('h4ci_itembuilder:ajout', h4ci_itemzeb, itemlimite)
                                ESX.ShowNotification('Ajout ok, veuillez redémarrer le serveur')
                                RageUI.CloseAll()
                                opitemzeb = false
                            end
                        end
                })
            end)
        Wait(0)
    end
 end)
end
end

h4ci_itemzeb = {
    nom = 'A saisir',
    label = 'A saisir',
    limite = ' A saisir',
    consommable = false,
    boisson = false,
    nourriture = false
}

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end
