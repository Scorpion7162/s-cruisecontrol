# S-Cruisecontrol


Hi and welcome to my cruise control script! 

Note: You can change and edit this in any way, want any feature changes? PR it and ill merge it! 

I was messing around with scripts like qbx_cruise, and if you have any custom handling, it messes with it a lot, (e.g turning very well), so I decided to see if I can make one myself, this is my attempt at it. From my testing, it works very well! 

Requirements
- Ox_lib
-----------

To get started. install the release of the script, then drop it into your server.

make sure to ensure it in any way, whether that be in your folder e.g

ensure [VehiclesBE] or
ensure s-cruisecontrol



and that's all you need! 


to change configuration go to shared > cfg.lua

cfg Options are 
usesMph = true, -- Would you rather MPH or KM/H
minspeed = 1.0, -- Minimum speed (mph)
dropthreshold = 8, -- How far can the speed drop for the cruise control to be disabled
checkforupdates = true, -- Check for updates
