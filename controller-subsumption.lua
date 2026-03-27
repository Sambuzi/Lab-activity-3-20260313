MAX_VELOCITY = 15

TURN = 5
BACKWARD = -3

function init()
    robot.leds.set_all_colors("green")
end

function go_to_light()
    local left = 0
    local right = 0

    for i = 1, #robot.light do
        if robot.light[i].angle > 0 then
            left = left + robot.light[i].value
        else
            right = right + robot.light[i].value
        end
    end
    
    if left > right + 0.05 then
        return TURN, MAX_VELOCITY
    elseif right > left + 0.05 then
        return MAX_VELOCITY, TURN
    else
        return MAX_VELOCITY, MAX_VELOCITY
    end
end

function avoid_obstacles(l, r)
    local left = 0
    local right = 0

    for i = 1, 3 do
        left = left + robot.proximity[i].value
    end

    for i = 22, 24 do
        right = right + robot.proximity[i].value
    end

    if left + right > 0.2 then
        if left > right then
            return MAX_VELOCITY, BACKWARD
        else
            return BACKWARD, MAX_VELOCITY
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