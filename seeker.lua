local mathx = require 'mathx'
local Vector2 = require 'Vector2'


function love.load()
    local width, height = love.graphics.getDimensions()

    b1 = {
        position = Vector2.new(100, 100),
        velocity = Vector2.one() * 100,
        radius = 10,
        color = { 255, 0, 0 }
    }

    b2 = {
        position = Vector2.new(200, 200),
        velocity = Vector2.new(0, 0),
        radius = 10,
        color = { 0, 255, 0 }
    }

    distance = b2.position - b1.position
    distance_length = distance:magnitude()
    distance_normalized = distance:normalized()
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        b1.position.y = b1.position.y - 500 * dt
    end
    if love.keyboard.isDown('a') then
        b1.position.x = b1.position.x - 500 * dt
    end
    if love.keyboard.isDown('s') then
        b1.position.y = b1.position.y + 500 * dt
    end
    if love.keyboard.isDown('d') then
        b1.position.x = b1.position.x + 500 * dt
    end

    --[[  UNCOMMENT ONE OF THE FOLLOWING LINES TO SEE THE DIFFERENT BEHAVIOURS  ]]

    --- Smooth damp b2 to b1
    -- b2.position = b2.position:smoothDamp(b1.position, b2.velocity, 0.3, 100, dt)

    --- Moove Towards b1
    -- b2.position = b2.position:moveTowards(b1.position, 100 * dt)

    -- lerp b2 to b1
    b2.position = b2.position:lerp(b1.position, 0.01)

    if (b1.position - b2.position):magnitude() < b1.radius + b2.radius then
        b2.position = b2.position + distance_normalized * 100 * dt
    end

    --- Update distances
    distance = b2.position - b1.position
    distance_length = distance:magnitude()
    distance_normalized = distance:normalized()
end

function love.draw()
    love.graphics.setColor(255, 0, 0)
    love.graphics.circle('fill', b1.position.x, b1.position.y, b1.radius)

    love.graphics.setColor(0, 255, 0)
    love.graphics.circle('fill', b2.position.x, b2.position.y, b2.radius)

    love.graphics.setColor(255, 255, 255)

    -- vector from b1 to b2
    love.graphics.line(b1.position.x, b1.position.y, b1.position.x + distance_normalized.x * distance_length,
        b1.position.y + distance_normalized.y * distance_length)
end
