-- Mian.lua

-- Script voor het checken van de gebruikte executie
local function checkExecutie()
    local currentExecutie = current_executie
    local availableExecutie = available_executie

    if currentExecutie == nil then
        print("Niet een executie geïnstalleerd")
        return
    end

    if currentExecutie == availableExecutie then
        print("U wordt de gewenste executie gebruikt")
    else
        print("U wordt geen gewenste executie gebruikt")
    end
end

-- Inclusie van de executie
local function setCurrentExecutie()
    if current_executie == nil then
        current_executie = available_executie
    end
end

-- Inclusie van de executie
local function setAvailableExecutie()
    if available_executie == nil then
        available_executie = current_executie
    end
end

-- Main
checkExecutie()