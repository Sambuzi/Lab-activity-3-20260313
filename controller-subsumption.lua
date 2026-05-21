local MAX_VELOCITY = 15

local TURN = 5
local BACKWARD = -3
local LIGHT_THRESHOLD = 0.05
local OBSTACLE_THRESHOLD = 0.2
local BLACK_THRESHOLD = 0.1

function init()
    robot.leds.set_all_colors("green")
end

function search_light()
    return MAX_VELOCITY * 0.6, MAX_VELOCITY * 0.4
end

function go_to_light(l, r)
    local left = 0
    local right = 0

    for i = 1, 12 do
        left = left + robot.light[i].value
    end

    for i = 13, 24 do
        right = right + robot.light[i].value
    end

    if left + right < LIGHT_THRESHOLD then
        return l, r
    end

    if left > right + LIGHT_THRESHOLD then
        return TURN, MAX_VELOCITY
    elseif right > left + LIGHT_THRESHOLD then
        return MAX_VELOCITY, TURN
    else
        return MAX_VELOCITY, MAX_VELOCITY
    end
end

function avoid_obstacles(l, r)
    local left = 0
    local right = 0

    for i = 1, 4 do
        left = left + robot.proximity[i].value
    end

    for i = 21, 24 do
        right = right + robot.proximity[i].value
    end

    if left + right > OBSTACLE_THRESHOLD then
        if left > right then
            return MAX_VELOCITY, BACKWARD
        elseif right > left then
            return BACKWARD, MAX_VELOCITY
        else
            return MAX_VELOCITY, BACKWARD
        end
    end

    return l, r
end

function halt_on_black(l, r)
    local black_sensors = 0

    for i = 1, #robot.motor_ground do
        if robot.motor_ground[i].value < BLACK_THRESHOLD then
            black_sensors = black_sensors + 1
        end
    end

    if black_sensors >= 2 then
        return 0, 0
    end

    return l, r
end

function step()
    local l, r = search_light()
    l, r = go_to_light(l, r)
    l, r = avoid_obstacles(l, r)
    l, r = halt_on_black(l, r)
    robot.wheels.set_velocity(l, r)
end

function reset()
end

function destroy()
end
