local Vector2 = require 'Vector2'

local MAX_BALL = 2
local BALL_SPEED = 500
local BALL_ACCELERATION = Vector2(10, 50)
local BALL_TRAIL_LENGTH = 100
local BALL_MASS = 50
local GRAVITY_FORCE = Vector2(0, 9.81)

function love.load()
    love.window.setTitle('Reflect')
    love.window.setMode(800, 600, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    balls = {}
    for i = 1, MAX_BALL do
        table.insert(balls, {
            trail = {},
            position = Vector2(math.random(0, love.graphics.getWidth()), math.random(0, love.graphics.getHeight())),
            velocity = Vector2(math.random(-BALL_SPEED, BALL_SPEED), math.random(-BALL_SPEED, BALL_SPEED)),
            radius = 10,
            color = { 1, 1, 1 }
        })
    end
end

-- Adjust as needed


function love.update(dt)
    for i = 1, MAX_BALL do
        local ball = balls[i]

        -- Apply gravity
        local gravityForce = GRAVITY_FORCE * BALL_MASS
        ball.velocity = ball.velocity + (BALL_ACCELERATION + gravityForce) * dt

        -- Update ball position
        ball.position = ball.position + ball.velocity * dt

        -- Handle screen edge reflections
        if ball.position.x + ball.radius > love.graphics.getWidth() then
            ball.velocity.x = -ball.velocity.x
            ball.position.x = love.graphics.getWidth() - ball.radius
        elseif ball.position.x - ball.radius < 0 then
            ball.velocity.x = -ball.velocity.x
            ball.position.x = ball.radius
        end

        if ball.position.y + ball.radius > love.graphics.getHeight() then
            ball.velocity.y = -ball.velocity.y
            ball.position.y = love.graphics.getHeight() - ball.radius
        elseif ball.position.y - ball.radius < 0 then
            ball.velocity.y = -ball.velocity.y
            ball.position.y = ball.radius
        end

        -- Normalize velocity
        ball.velocity = ball.velocity:normalized() * BALL_SPEED

        -- Add current position to the trail
        table.insert(ball.trail, 1, ball.position:clone())

        -- Remove the last position from the trail if it's too long
        if #ball.trail > BALL_TRAIL_LENGTH then
            table.remove(ball.trail)
        end
    end
end

function love.draw()
    -- draw the ball

    for i = 1, MAX_BALL do
        local ball = balls[i]
        love.graphics.setColor(ball.color)
        love.graphics.circle('fill', ball.position.x, ball.position.y, ball.radius)

        -- Draw the ball trail
        for j = 1, #ball.trail do
            local alpha = j / #ball.trail * 0.1 -- Adjust the multiplier to decrease brightness
            love.graphics.setColor(ball.color[1], ball.color[2], ball.color[3], alpha)
            love.graphics.circle('fill', ball.trail[j].x, ball.trail[j].y, ball.radius * .8)
        end
    end
end
