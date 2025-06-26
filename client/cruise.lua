local cruiseState={active=false,targetSpeed=0,vehicle=nil,controlMode='cruise',speedIncrement=5}
local usesMph= cfg.usesMph
local minimumSpeed= cfg.minspeed
local speedDropThreshold= cfg.dropthreshold
local function notify(message,notificationType)
   lib.notify({
       title='Cruise Control',
       description=message,
       type=notificationType or 'info',
       duration=notificationType=='success' and 5000 or 3000
   })
end
local function disableCruise(reason)
   cruiseState.active=false
   cruiseState.targetSpeed=0
   if reason then notify(reason,'error') end
end
local function convertSpeed(speed)
   return math.floor(speed*(usesMph and 2.23694 or 3.6))
end
RegisterCommand('togglecruise',function()
   local playerPed=PlayerPedId()
  
   if not IsPedInAnyVehicle(playerPed,false) then
       notify('You must be in a vehicle','error')
       return
   end
  
   local currentVehicle=GetVehiclePedIsIn(playerPed,false)
   if GetPedInVehicleSeat(currentVehicle,-1)~=playerPed then
       notify('Only for drivers','error')
       return
   end
  
   if cruiseState.active then
       disableCruise('Cruise control disabled')
   else
       local vehicleSpeed=GetEntitySpeed(currentVehicle)
       if vehicleSpeed>minimumSpeed then
           cruiseState.active=true
           cruiseState.targetSpeed=vehicleSpeed
           cruiseState.vehicle=currentVehicle
           cruiseState.controlMode='cruise'
           notify('Set: '..convertSpeed(vehicleSpeed)..(usesMph and ' MPH' or ' KM/H'),'success')
       else
           notify('Moving too slow','error')
       end
   end
end, false)
RegisterCommand('cruisemenu',function()
   lib.registerContext({
       id='cruise_menu',
       title='Cruise Control Menu',
       options={
           {
               title='Cruise Control',
               description='Maintain constant speed',
               onSelect=function()
                   cruiseState.controlMode='cruise'
                   notify('Mode: Cruise Control','success')
               end
           },
           {
               title='Speed Limiter',
               description='Maximum speed limit',
               onSelect=function()
                   cruiseState.controlMode='speedLimiter'
                   notify('Mode: Speed Limiter','success')
               end
           },
           {
               title='Speed Increment',
               description='Current: '..cruiseState.speedIncrement..(usesMph and ' MPH' or ' KM/H'),
               onSelect=function()
                   local input=lib.inputDialog('Speed Increment',{'Increment ('..( usesMph and 'MPH' or 'KM/H')..')'})
                   if input and tonumber(input[1]) then
                       cruiseState.speedIncrement=tonumber(input[1])
                       notify('Increment set to '..cruiseState.speedIncrement..(usesMph and ' MPH' or ' KM/H'),'success')
                   end
               end
           }
       }
   })
   lib.showContext('cruise_menu')
end,false)
RegisterKeyMapping('togglecruise','Toggle Cruise Control','keyboard','y')
RegisterKeyMapping('cruisemenu','Open Cruise Menu','keyboard','u')
RegisterKeyMapping('speedup','Increase Speed','keyboard','UP')
RegisterKeyMapping('speeddown','Decrease Speed','keyboard','DOWN')
RegisterCommand('speedup',function()
   if cruiseState.active then
       local newTargetSpeed=(convertSpeed(cruiseState.targetSpeed)+cruiseState.speedIncrement)/(usesMph and 2.23694 or 3.6)
       cruiseState.targetSpeed=newTargetSpeed
       notify('Speed: '..convertSpeed(newTargetSpeed)..(usesMph and ' MPH' or ' KM/H'),'success')
   end
end,false)
RegisterCommand('speeddown',function()
   if cruiseState.active then
       local newTargetSpeed=math.max(minimumSpeed,(convertSpeed(cruiseState.targetSpeed)-cruiseState.speedIncrement)/(usesMph and 2.23694 or 3.6))
       cruiseState.targetSpeed=newTargetSpeed
       notify('Speed: '..convertSpeed(newTargetSpeed)..(usesMph and ' MPH' or ' KM/H'),'success')
   end
end,false)
CreateThread(function()
    while true do
        if cruiseState.active then
            local playerPed=PlayerPedId()
           
            if not IsPedInAnyVehicle(playerPed,false) then
                disableCruise('Exited vehicle')
            else
                local currentVehicle=GetVehiclePedIsIn(playerPed,false)
               
                if currentVehicle~=cruiseState.vehicle then disableCruise('Vehicle changed')
                elseif IsControlPressed(0,72) then disableCruise('Brakes applied')
                else
                    local currentSpeed=GetEntitySpeed(currentVehicle)
                   
                    if cruiseState.controlMode=='cruise' then
                        if convertSpeed(cruiseState.targetSpeed)-convertSpeed(currentSpeed)>speedDropThreshold then
                            disableCruise('Speed dropped too low')
                        else
                            if currentSpeed<cruiseState.targetSpeed-0.5 then
                                SetVehicleCheatPowerIncrease(currentVehicle,1.0+(cruiseState.targetSpeed-currentSpeed)*0.1)
                                SetControlNormal(0,71,0.6)
                            elseif currentSpeed>cruiseState.targetSpeed+0.8 then
                                SetControlNormal(0,72,0.3)
                            else
                                SetControlNormal(0,71,0.2)
                            end
                        end
                    elseif cruiseState.controlMode=='speedLimiter' then
                        if currentSpeed > cruiseState.targetSpeed + 0.2 then
                            -- Apply brakes and cut throttle when exceeding limit
                            SetControlNormal(0, 72, 0.7)  -- Apply brakes
                            SetControlNormal(0, 71, 0.0)  -- Cut throttle completely
                        elseif currentSpeed > cruiseState.targetSpeed then
                            -- Gentle speed reduction when slightly over limit
                            SetControlNormal(0, 71, 0.1)  -- Reduce throttle significantly
                        end
                        -- When under the limit, let player control normally (no intervention)
                    end
                end
            end
            Wait(0)
        else
            Wait(500)
        end
    end
 end)
