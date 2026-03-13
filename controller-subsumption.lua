MAX_VELOCITY = 15

function init()
    robot.leds.set_all_colors("green")
end

function go_to_light()
    local x = 0
    local y = 0
    for i = 1, #robot.light do
        x = x + robot.light[i].value * math.cos(robot.light[i].angle)
        y = y + robot.light[i].value * math.sin(robot.light[i].angle)
    end
    local a = math.atan(y, x)
    local l = MAX_VELOCITY - 10 * a
    local r = MAX_VELOCITY + 10 * a
    return l, r
end

function avoid_obstacles(l, r)
    local x = 0
    local y = 0
    for i = 1, #robot.proximity do
        x = x + robot.proximity[i].value * math.cos(robot.proximity[i].angle)
        y = y + robot.proximity[i].value * math.sin(robot.proximity[i].angle)
    end
    if x > 0.1 then
        local a = math.atan(y, x)
        l = -8 * a
        r = 8 * a
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