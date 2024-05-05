local mathx = require 'libs.mathx'
local Vector2 = require 'libs.Vector2'

local AIM_LINE_LENGTH = 40
local PLAYER_BASE_SPEED = 500
local PLAYER_FIRE_RATE = 10
local ENEMY_FIRE_RATE = 1
local ENEMY_COLOR = { 0.8, 0.2, 0.2 }
local EXPLOSION_COLOR = { 0.9, 0.9, 0.2 }
local EXPLOSION_MAX_RADIUS = 20
local EXPLOSION_GROWTH_RATE = 100
local ENEMY_BULLET_SPEED = 400
local PLAYER_BULLET_SPEED = 500
local ENEMY_SEEK_FORCE = 100
local ENEMY_SPAWN_INTERVAL = 2

local ENEMY_SPAWN_INTERVAL_MIN = 0.5
local PLAYER_SHOOT_INTERVAL = 1 / PLAYER_FIRE_RATE
local ENEMY_SHOOT_INTERVAL = 1 / ENEMY_FIRE_RATE
local ENEMY_SPAWN_INTERVAL_CHANGE_RATE = 0.1                 -- Rate of decrease of spawn interval over time
local PLAYER_SHOOT_INTERVAL_CHANGE_RATE = 0.1                -- Rate of decrease of shoot interval over time
local PLAYER_SHOOT_INTERVAL_MIN = 1 / (PLAYER_FIRE_RATE * 2) -- Minimum shoot interval for the player


local enemySpawnTimer = 0
local playerShootTimer = 0

function love.load()
  love.window.setTitle('Battle Ball')
  love.window.setMode(900, 800, { resizable = true, vsync = true, minwidth = 400, minheight = 300 })

  score = 0
  isAutoFire = true
  isGameOver = false
  killedBy = nil

  player = {
    position = Vector2(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2),
    velocity = Vector2(0, 0),
    aim = Vector2(0, 0),
    aimArrowPolygon = {},
    radius = 10,
    color = { 0.2, 0.6, 0.8 },
  }

  enemies = {

    {
      position = Vector2(math.random(love.graphics.getWidth()), math.random(love.graphics.getHeight())),
      velocity = Vector2(0, 0),
      acceleration = Vector2(0, 0),
      radius = 10,
      enemyShootTimer = 0,
      color = ENEMY_COLOR
    }
  }


  bullets = {}
  explosions = {}
end

function love.update(dt)
  if (isGameOver) then
    return
  end

  enemySpawnTimer = enemySpawnTimer + dt
  playerShootTimer = playerShootTimer + dt

  --- Player movement
  if love.keyboard.isDown('w') then
    player.position.y = player.position.y - PLAYER_BASE_SPEED * dt
  end
  if love.keyboard.isDown('s') then
    player.position.y = player.position.y + PLAYER_BASE_SPEED * dt
  end
  if love.keyboard.isDown('a') then
    player.position.x = player.position.x - PLAYER_BASE_SPEED * dt
  end
  if love.keyboard.isDown('d') then
    player.position.x = player.position.x + PLAYER_BASE_SPEED * dt
  end

  --- Prevent player from going out of the screen
  if (player.position.x < 0) then
    player.position.x = 0
  end
  if (player.position.x > love.graphics.getWidth()) then
    player.position.x = love.graphics.getWidth()
  end
  if (player.position.y < 0) then
    player.position.y = 0
  end
  if (player.position.y > love.graphics.getHeight()) then
    player.position.y = love.graphics.getHeight()
  end

  -- AIMING
  local mousePosition = Vector2(love.mouse.getX(), love.mouse.getY())
  local direction = mousePosition - player.position
  player.aim = direction:normalized() * AIM_LINE_LENGTH
  player.velocity = direction:normalized() * PLAYER_BASE_SPEED

  -- Aim arrow update
  player.aimArrowPolygon = calcAimArrowPolygonCoordinate(player, player.aim)

  --- Player shoot
  if isAutoFire or love.mouse.isDown(1) then
    if (playerShootTimer >= PLAYER_SHOOT_INTERVAL) then
      table.insert(bullets, {
        position = player.position + player.aim,
        velocity = direction:normalized() * PLAYER_BULLET_SPEED,
        radius = 5,
        shotBy = 'player',
        color = { 0.9, 0.9, 0.2 }
      })
      playerShootTimer = playerShootTimer - PLAYER_SHOOT_INTERVAL

      if PLAYER_SHOOT_INTERVAL > PLAYER_SHOOT_INTERVAL_MIN then
        PLAYER_SHOOT_INTERVAL = PLAYER_SHOOT_INTERVAL - PLAYER_SHOOT_INTERVAL_CHANGE_RATE * dt
      end
    end
  end

  --- Update enemies
  for _, enemy in ipairs(enemies) do
    --- Enemy seek player
    local direction = player.position - enemy.position
    local distance = direction:magnitude()
    local acceleration = direction:normalized() * ENEMY_SEEK_FORCE

    if distance < 100 then
      acceleration = acceleration * 2
    end

    enemy.velocity = enemy.velocity + acceleration * dt
    enemy.position = enemy.position + enemy.velocity * dt

    --- Enemy shoot
    enemy.enemyShootTimer = enemy.enemyShootTimer + dt
    if (enemy.enemyShootTimer >= ENEMY_SHOOT_INTERVAL) then
      table.insert(bullets, {
        position = enemy.position,
        velocity = direction:normalized() * ENEMY_BULLET_SPEED,
        radius = 5,
        shotBy = 'enemy',
        color = { 0.6, 0.1, 0.6 }
      })
      enemy.enemyShootTimer = enemy.enemyShootTimer - ENEMY_SHOOT_INTERVAL
    end


    -- prevent the enemy ball from overlaping with each other
    for _, other in ipairs(enemies) do
      if enemy ~= other then
        local direction = other.position - enemy.position
        local distance = direction:magnitude()
        local overlap = enemy.radius + other.radius - distance

        if overlap > 0 then
          local normal = direction:normalized()
          enemy.position = enemy.position - normal * overlap / 2
          other.position = other.position + normal * overlap / 2
        end
      end
    end

    -- Check if player collide with enemy (And Game Over)

    if player.position:distance(enemy.position) < player.radius + enemy.radius then
      print('Game Over!')
      killedBy = 'enemy collision'
      isGameOver = true
    end
  end


  -- Update bullets
  for i = #bullets, 1, -1 do
    local bullet = bullets[i]
    bullet.position = bullet.position + bullet.velocity * dt

    if bullet.position.x < 0 or bullet.position.x > love.graphics.getWidth() or
        bullet.position.y < 0 or bullet.position.y > love.graphics.getHeight() then
      print('delete bullet')
      table.remove(bullets, i)
    end

    if bullet.shotBy == 'player' then
      for _, enemy in ipairs(enemies) do
        if bullet.position:distance(enemy.position) < bullet.radius + enemy.radius then
          table.remove(bullets, i)
          table.remove(enemies, _)

          -- add explosions
          table.insert(explosions, {
            position = enemy.position,
            radius = 0,
            isGrowing = true,
            color = EXPLOSION_COLOR
          })

          score = score + 1
        end
      end
    end

    if bullet.shotBy == 'enemy' then
      if bullet.position:distance(player.position) < bullet.radius + player.radius then
        print('Game Over!')
        killedBy = 'enemy bullet'
        isGameOver = true
      end
    end
  end


  --- Add new enemies
  if enemySpawnTimer >= ENEMY_SPAWN_INTERVAL then
    enemySpawnTimer = enemySpawnTimer - ENEMY_SPAWN_INTERVAL

    local spawnDist = math.random(200, 600)
    local spawnAngle = math.random() * math.pi * 2

    local spawnX = player.position.x + math.cos(spawnAngle) * spawnDist
    local spawnY = player.position.y + math.sin(spawnAngle) * spawnDist

    table.insert(enemies, {
      position = Vector2(spawnX, spawnY),
      velocity = Vector2(0, 0),
      acceleration = Vector2(0, 0),
      radius = 10,
      enemyShootTimer = 0,
      color = ENEMY_COLOR
    })

    if ENEMY_SPAWN_INTERVAL > ENEMY_SPAWN_INTERVAL_MIN then
      ENEMY_SPAWN_INTERVAL = ENEMY_SPAWN_INTERVAL - ENEMY_SPAWN_INTERVAL_CHANGE_RATE * dt
    end
  end

  --- Update explosions
  for i = #explosions, 1, -1 do
    local explo = explosions[i]

    if explo.isGrowing then
      explo.radius = explo.radius + EXPLOSION_GROWTH_RATE * dt

      if explo.radius > EXPLOSION_MAX_RADIUS then
        explo.isGrowing = false
      end
    else
      explo.radius = explo.radius - EXPLOSION_GROWTH_RATE * dt

      if explo.radius < 0 then
        table.remove(explosions, i)
      end
    end
  end
end

function love.draw()
  -- draw aim line
  love.graphics.setColor({ 1, 0.8, 0.6 })
  love.graphics.line(player.position.x, player.position.y, player.position.x + player.aim.x,
    player.position.y + player.aim.y)

  -- draw aim arrow
  love.graphics.setColor(1, 1, 1)
  love.graphics.polygon('fill', player.aimArrowPolygon)

  -- draw player
  love.graphics.setColor(player.color)
  love.graphics.circle('fill', player.position.x, player.position.y, player.radius)

  --- draw enemies
  for _, enemy in ipairs(enemies) do
    love.graphics.setColor(enemy.color)
    love.graphics.circle('fill', enemy.position.x, enemy.position.y, enemy.radius)

    -- draw esp line, distance, velocity
    love.graphics.setColor(255, 255, 255)
    -- love.graphics.line(player.position.x, player.position.y, enemy.position.x, enemy.position.y)
    -- love.graphics.print(math.floor(player.position:distance(enemy.position)), enemy.position.x, enemy.position.y)
    -- love.graphics.print(math.floor(enemy.velocity:magnitude()), enemy.position.x, enemy.position.y + 10)
  end

  --- draw bullets
  for _, bullet in ipairs(bullets) do
    love.graphics.setColor(bullet.color)
    love.graphics.circle('fill', bullet.position.x, bullet.position.y, bullet.radius)
  end

  --- draw explosions
  for _, exp in ipairs(explosions) do
    love.graphics.setColor(exp.color)
    love.graphics.circle('fill', exp.position.x, exp.position.y, exp.radius)
  end

  --- draw debug information
  love.graphics.setColor(255, 255, 255)
  love.graphics.print('FPS: ' .. love.timer.getFPS(), 10, 10)
  love.graphics.print('Memory: ' .. math.floor(collectgarbage('count')) .. 'KB', 10, 25)
  love.graphics.print('Score: ' .. score, 10, 40)
  love.graphics.print('Enemies: ' .. #enemies, 10, 55)
  love.graphics.print('Bullets: ' .. #bullets, 10, 70)
  love.graphics.print('Explosions: ' .. #explosions, 10, 85)
  love.graphics.print('Auto fire: ' .. tostring(isAutoFire), 10, 100)
  love.graphics.print('WASD to move, mouse to aim and shoot', 10, 115)
  love.graphics.print('Left click to shoot', 10, 130)
  love.graphics.print('Press space to toggle auto fire', 10, 145)
  -- love.graphics.print('Player position: ' .. player.position, 10, 70)
  -- love.graphics.print('Player velocity: ' .. player.velocity, 10, 85)
  -- love.graphics.print('Player aim: ' .. player.aim, 10, 100)

  --- GAME OVER SCREEN
  if (isGameOver) then
    love.graphics.setColor(0, 0, 0, .8)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(255, 255, 255)
    love.graphics.print('Game Over!', love.graphics.getWidth() / 2 - 50, love.graphics.getHeight() / 2)
    love.graphics.print('Press R to restart', love.graphics.getWidth() / 2 - 70, love.graphics.getHeight() / 2 + 20)
    love.graphics.print('Score: ' .. score, love.graphics.getWidth() / 2 - 30, love.graphics.getHeight() / 2 + 40)
    love.graphics.print('Killed by: ' .. killedBy, love.graphics.getWidth() / 2 - 50,
      love.graphics.getHeight() / 2 + 60)
  end
end

function calcAimArrowPolygonCoordinate(player, aim)
  local angle = math.atan2(aim.y, aim.x)
  local arrowLength = 10
  local arrowAngle = math.pi / 6

  --  Calculate the angles for the arrowhead
  local arrow1Angle = angle - math.pi + arrowAngle
  local arrow2Angle = angle - math.pi - arrowAngle

  --  Calculate the coordinates of the arrowhead points
  local arrow1X = player.position.x + aim.x + arrowLength * math.cos(arrow1Angle)
  local arrow1Y = player.position.y + aim.y + arrowLength * math.sin(arrow1Angle)
  local arrow2X = player.position.x + aim.x + arrowLength * math.cos(arrow2Angle)
  local arrow2Y = player.position.y + aim.y + arrowLength * math.sin(arrow2Angle)

  return { player.position.x + aim.x, player.position.y + aim.y, arrow1X, arrow1Y, arrow2X, arrow2Y }
end

function love.keypressed(key)
  if key == 'r' then
    love.load()
  end

  if key == 'space' then
    isAutoFire = not isAutoFire
  end
end
