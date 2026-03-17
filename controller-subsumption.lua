MAX_VELOCITY = 15

function init()
    robot.leds.set_all_colors("green")
end

function go_to_light()
    local maxv = 0
    local a = 0

    for i = 1, #robot.light do
        if robot.light[i].value > maxv then
            maxv = robot.light[i].value
            a = robot.light[i].angle
        end
    end

    if a > 0.1 then
        return 6, 15  --gira a sinistra 
    elseif a < -0.1 then
        return 15, 6 -- gira a destra
    else
        return 15, 15  -- va dritto
    end
end

function avoid_obstacles(l, r)
    local maxv = 0
    local a = 0

    for i = 1, #robot.proximity do
        if robot.proximity[i].value > maxv then
            maxv = robot.proximity[i].value
            a = robot.proximity[i].angle
        end
    end

    if maxv > 0.2 then
        if a > 0 then
            return 15, -5 -- gira a destra
        else
            return -5, 15 -- gira a sinistra
        end
    end

    return l, r
end

function halt_on_black(l, r)
    for i = 1, #robot.motor_ground do
        if robot.motor_ground[i].value < 0.1 then
            return 0, 0
        end
    end
    return l, r
end

function step()
    local l, r = go_to_light()
    l, r = avoid_obstacles(l, r)
    l, r = halt_on_black(l, r)
    robot.wheels.set_velocity(l, r)
end

function reset()
end

function destroy()
end