-- Mian.lua
-- Roblox login screen

local screen = screen:create()

-- Deze is de hoofd logonormatie, geplaatst in de midden van het scherm.
-- De design is in de dark team stijl (verlichting op zwart/grint).

-- 1. De logonormatie (titel)
local title = screen:create()

-- 1.1 De logonormatie: tekst en styling
local title_text = screen:create()
title_text:set_text("Mian")
title_text:set_font("RobloxFont")
title_text:set_color(0, 0, 0) -- Verlichting op zwart
title_text:set_align("center")

-- 1.2 Mooie animatie: de titel glitters en beweegt
local title_animation = screen:create()
title_animation:set_animation("glow")
title_animation:set_animation_delay(0.5) -- Glitters voor 0,5 seconden

-- 1.3 Mooie animatie: een licht effect
local glow = screen:create()
glow:set_animation("pulse")
glow:set_animation_delay(1.0) -- Pulses voor 1,0 seconden

-- 2. De rest van het scherm (geen functie nodig, maar designvol)
local background = screen:create()
background:set_color(15, 15, 15) -- Verlichting op zwart/grint

-- (Hier kan je de rest van het scherm bepalen, bijvoorbeeld een veilige grint-uitstraling)