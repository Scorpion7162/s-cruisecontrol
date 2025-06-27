-- This resource is protected under the GNU General Public License v3.0.
-- You may not redistribute this code without providing clear attribution to the original author (Scorpion).
-- https://choosealicense.com/licenses/gpl-3.0/
--  Copyright © 2025 Scorpion <https://github.com/scorpion7162> 
local v="1.0.2"
local r="Scorpion7162/s-cruisecontrol"
local u="https://github.com/Scorpion7162/s-cruisecontrol"
if cfg.checkforupdates then

    local function c()PerformHttpRequest("https://api.github.com/repos/"..r.."/releases/latest",function(e,d,h)
    if e~=200 then return end
    local j=json.decode(d)
    if j and j.tag_name and j.tag_name~=v then
    print("^1==============================================^7")
    print("^3Your version of s-cruisecontrol is outdated!^7")
    print("^3Current version: ^1"..v.."^3, Latest version: ^2"..j.tag_name.."^7")
    print("^3Download the latest version from: ^5"..u.."^7")
    print("^1==============================================^7")
        end
    end,"GET",nil,{["User-Agent"]="FiveM-UpdateCheck"})end
    AddEventHandler("onResourceStart",function(n)
    if n==GetCurrentResourceName()then
              c()
         end
    end)
    CreateThread(function()
         Wait(10000)
        while true do
        c()
        Wait(3600000)
         end
    end)
end
-- This resource is protected under the GNU General Public License v3.0.
-- You may not redistribute this code without providing clear attribution to the original author (Scorpion).
-- https://choosealicense.com/licenses/gpl-3.0/
--  Copyright © 2025 Scorpion <https://github.com/scorpion7162> 