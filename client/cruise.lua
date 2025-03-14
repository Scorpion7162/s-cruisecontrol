
local s={on=false,speed=0,veh=nil}
local usesMph= cfg.usesMph
local minSpeed= cfg.minspeed
local dropThreshold= cfg.dropthreshold


local function n(m,t)
    lib.notify({
        title='Cruise Control',
        description=m,
        type=t or 'info',
        duration=t=='success' and 5000 or 3000
    })
end

-- Disable cruise control
local function d(r)
    s.on=false
    s.speed=0
    if r then n(r,'error') end
end


local function c(speed)
    return math.floor(speed*(usesMph and 2.23694 or 3.6))
end

RegisterCommand('togglecruise',function()
    local p=PlayerPedId()
    
    if not IsPedInAnyVehicle(p,false) then
        n('You must be in a vehicle','error')
        return
    end
    
    local v=GetVehiclePedIsIn(p,false)
    if GetPedInVehicleSeat(v,-1)~=p then
        n('Only for drivers','error')
        return
    end
    
    if s.on then
        d('Cruise control disabled')
    else
        local speed=GetEntitySpeed(v)
        if speed>minSpeed then
            s.on=true
            s.speed=speed
            s.veh=v
            n('Set: '..c(speed)..(usesMph and ' MPH' or ' KM/H'),'success')
        else
            n('Moving too slow','error')
        end
    end
end)

-- Register key mapping
RegisterKeyMapping('togglecruise','Toggle Cruise Control','keyboard','y')

-- Main thread
CreateThread(function()
    while true do
        if s.on then
            local p=PlayerPedId()
            
            if not IsPedInAnyVehicle(p,false) then
                d('Exited vehicle')
            else
                local v=GetVehiclePedIsIn(p,false)
                
                if v~=s.veh then d('Vehicle changed')
                elseif IsControlPressed(0,72) then d('Brakes applied')
                else
                    local cs=GetEntitySpeed(v)
                    
                    if c(s.speed)-c(cs)>dropThreshold then
                        d('Speed dropped too low')
                    else
                        if cs<s.speed-0.5 then
                            SetVehicleCheatPowerIncrease(v,1.0+(s.speed-cs)*0.1)
                            SetControlNormal(0,71,0.6)
                        elseif cs>s.speed+0.8 then
                            SetControlNormal(0,72,0.3)
                        else
                            SetControlNormal(0,71,0.2)
                        end
                    end
                end
            end
            Wait(0)
        else
            Wait(500)
        end
    end
end)