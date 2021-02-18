ESX = nil
seeded = false
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
while not ESX do
    Citizen.Wait(0)
end

Citizen.CreateThread(function()
    while not seeded do
        math.randomseed(os.time())
        --print("Unique Plates Seeded - " .. os.time())
        seeded = true
    end
end)

ESX.RegisterServerCallback('apextplate', function(source, cb)
    local newPlate = UniquePlateCheck()
    print(newPlate)
	cb(newPlate)
end)

function GenerateUniquePlate()
    local upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZÅÄÖ"
    local numbers = "0123456789"
    local characterSet = numbers .. upperCase
    local keyLength = 6
    local output = ""
    for	i = 1, keyLength do
        local rand = math.random(#characterSet)
        output = output .. string.sub(characterSet, rand, rand)
    end
    print(output)
    return output
end

function UniquePlateCheck()
    local plate = GenerateUniquePlate()

    local result = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate", {['@plate'] = plate})
    if result[1] then
        --print("Fail cant dupe plate")
        Citizen.Wait(50)
        UniquePlateCheck()
    else
        --print("Good plate")
        return plate
	end
end