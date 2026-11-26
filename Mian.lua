-- Mian.lua

-- Loading screen
local loading = {
    message = "Loading Roblox..."
    progress = 0
}

-- Start the loading process
loading.start()

-- Loop through the loading process
while loading.progress < 100 do
    loading.progress = loading.progress + 1
    loading.message = "Loading Roblox... " .. tostring(loading.progress)
    -- Waart de gebruiker te zien hoe de load completes
end

-- Finish the loading
loading.finish()