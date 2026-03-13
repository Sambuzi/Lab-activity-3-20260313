MAX_VELOCITY = 15
turn_steps = 0
turn_dir = 1

function init()
    robot.leds.set_all_colors("green")
end

function clamp(v)
    if v > MAX_VELOCITY then return MAX_VELOCITY end
    if v < -MAX_VELOCITY then return -MAX_VELOCITY end
    return v
end

-- livello base: vai verso la luce
function go_to_light()
    local x = 0
    local y = 0

    for i=1,#robot.light do
        local v = robot.light[i].value
        local a = robot.light[i].angle
        x = x + v * math.cos(a)
        y = y + v * math.sin(a)
    end

    local base = 12
    local gain = 12

    local l = base + gain*y
    local r = base - gain*y

    return clamp(l), clamp(r)
end

-- livello superiore: evita ostacoli
function avoid_obstacles(l,r)

    if turn_steps > 0 then
        turn_steps = turn_steps - 1
        return turn_dir*12, -turn_dir*12
    end

    local x = 0
    local y = 0

    for i=1,#robot.proximity do
        local v = robot.proximity[i].value
        local a = robot.proximity[i].angle
        x = x + v * math.cos(a)
        y = y + v * math.sin(a)
    end

    if x > 0.15 then
        turn_steps = 10
        if y > 0 then
            turn_dir = -1
        else
            turn_dir = 1
        end
        return turn_dir*12, -turn_dir*12
    end

    return l,r
end

-- livello massimo: stop sul nero
function halt_on_black(l,r)
    for i=1,#robot.motor_ground do
        if robot.motor_ground[i].value < 0.1 then
            return 0,0
        end
    end
    return l,r
end

function step()
    local l,r = go_to_light()
    l,r = avoid_obstacles(l,r)
    l,r = halt_on_black(l,r)

    robot.wheels.set_velocity(l,r)
end

function reset()
    turn_steps = 0
end

function destroy()
end