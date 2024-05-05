local mathx = require 'mathx'
local Vector2 = require 'Vector2'

local MAX_TURRET = 2
local TURRET_FIRE_RATE = 0.1
local TURRET_ROTATION_SPEED = 5
local TURRET_CANON_LENGTH = 25
local TURRET_RADIUS = 10

local EXPLOSION_COLOR = { 0.9, 0.9, 0.2 }
local EXPLOSION_MAX_RADIUS = 20
local EXPLOSION_GROWTH_RATE = 100

local ZOMBIE_SPEED = .5
local ZOMBIE_RADIUS = 10
local ZOMBIE_SPAWN_RATE = .1

local BULLET_SPEED = 1000
local BULLET_RADIUS = 2

local zombieSpawnTimer = 0

function love.load()
  love.window.setTitle("Turret Defense")
  love.window.setMode(1200, 800, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })

  local screenWidth = love.graphics.getWidth()
  local screenHeight = love.graphics.getHeight()

  turret = {}
  for i = 1, MAX_TURRET do
    -- Calculate the offset from the center of the screen
    local offset = (MAX_TURRET - 1) * 100 / 2

    turret[i] = {
      position = Vector2(screenWidth / 2 + (i - 1) * 100 - offset, screenHeight / 2),
      velocity = Vector2(0, 0),
      cannon = Vector2(0, -1),
      shootTimer = 0,
      radius = TURRET_RADIUS,
      color = { 0, 1, 0 }
    }
  end

  bullets = {}
  explosions = {}
  zombies = {}
end

local function findClosestZombie(turret, ignoreZombie)
  local closestZombie = nil
  local closestDistance = math.huge

  for i, zombie in ipairs(zombies) do
    for _, ignore in ipairs(ignoreZombie or {}) do
      if ignore == zombie then goto continue end
    end

    local distance = (zombie.position - turret.position):magnitude()
    if distance < closestDistance then
      closestZombie = zombie
      closestDistance = distance
    end

    ::continue::
  end

  return closestZombie
end

local function findClosestTurret(zombie)
  local closestTurret = nil
  local closestDistance = math.huge

  for i, turret in ipairs(turret) do
    -- local distance = (zombie.position - turret.position):magnitude()
    local distance = zombie.position:distance(turret.position)
    if distance < closestDistance then
      closestTurret = turret
      closestDistance = distance
    end
  end

  return closestTurret
end


local function spawnZombie(dt)
  zombieSpawnTimer = zombieSpawnTimer + dt

  if (not (zombieSpawnTimer > ZOMBIE_SPAWN_RATE)) then
    return
  end

  local side = math.random(4)
  local x, y
  if side == 1 then
    x = math.random(love.graphics.getWidth())
    y = -ZOMBIE_RADIUS
  elseif side == 2 then
    x = love.graphics.getWidth() + ZOMBIE_RADIUS
    y = math.random(love.graphics.getHeight())
  elseif side == 3 then
    x = math.random(love.graphics.getWidth())
    y = love.graphics.getHeight() + ZOMBIE_RADIUS
  else
    x = -ZOMBIE_RADIUS
    y = math.random(love.graphics.getHeight())
  end

  table.insert(zombies, {
    position = Vector2(x, y),
    velocity = Vector2(0, 0),
    radius = ZOMBIE_RADIUS,
    color = { 1, 0, 0 }
  })

  zombieSpawnTimer = 0
end

local function updateZombies(dt)
  for i, zombie in ipairs(zombies) do
    local turret = findClosestTurret(zombie)

    if (turret) then
      zombie.position = zombie.position:lerp(turret.position, ZOMBIE_SPEED * dt)
    end
  end
end


local function updateExplosions(dt)
  for i, explosion in ipairs(explosions) do
    if explosion.isGrowing then
      explosion.radius = explosion.radius + EXPLOSION_GROWTH_RATE * dt
      if explosion.radius > EXPLOSION_MAX_RADIUS then
        explosion.isGrowing = false
      end
    else
      explosion.radius = explosion.radius - EXPLOSION_GROWTH_RATE * dt
      if explosion.radius < 0 then
        table.remove(explosions, i)
      end
    end
  end
end

local function updateExplosions(dt)
  for i = #explosions, 1, -1 do
    local explosion = explosions[i]
    explosion.radius = explosion.radius + (explosion.isGrowing and 1 or -1) * EXPLOSION_GROWTH_RATE * dt
    if (explosion.isGrowing and explosion.radius > EXPLOSION_MAX_RADIUS) or
        (not explosion.isGrowing and explosion.radius < 0) then
      table.remove(explosions, i)
    end
  end
end


local function updateBullets(dt)
  for i, bullet in ipairs(bullets) do
    bullet.position = bullet.position + bullet.velocity * dt

    if bullet.position.x < 0 or bullet.position.x > love.graphics.getWidth() or
        bullet.position.y < 0 or bullet.position.y > love.graphics.getHeight() then
      table.remove(bullets, i)
      goto continue
    end

    for j, zombie in ipairs(zombies) do
      if (bullet.position - zombie.position):magnitude() < zombie.radius then
        table.remove(bullets, i)
        table.remove(zombies, j)

        table.insert(explosions, {
          position = zombie.position,
          isGrowing = true,
          radius = 0
        })
      end
    end

    ::continue::
  end
end

local function fireBullet(turret)
  table.insert(bullets, {
    position = turret.position + turret.cannon * TURRET_CANON_LENGTH,
    velocity = turret.cannon * BULLET_SPEED
  })
end

local function updateTurretsTarget(dt)
  local closestZombies = {}
  for i, turret in ipairs(turret) do
    local closestZombie = findClosestZombie(turret, closestZombies)
    if closestZombie then
      turret.cannon = (closestZombie.position - turret.position):normalized()
      turret.shootTimer = turret.shootTimer + dt
      if turret.shootTimer > TURRET_FIRE_RATE then
        fireBullet(turret)
        turret.shootTimer = 0
      end
      table.insert(closestZombies, closestZombie)
    end
  end
end

-- no player input
function love.update(dt)
  spawnZombie(dt)
  updateZombies(dt)
  updateTurretsTarget(dt)
  updateBullets(dt)
  updateExplosions(dt)
end

function love.draw()
  -- Draw the turret
  for i, turret in ipairs(turret) do
    love.graphics.setColor(turret.color)
    love.graphics.line(turret.position.x, turret.position.y, turret.position.x + turret.cannon.x * TURRET_CANON_LENGTH,
      turret.position.y + turret.cannon.y * TURRET_CANON_LENGTH)
    love.graphics.circle('fill', turret.position.x, turret.position.y, turret.radius)
  end

  -- Draw the bullets
  for i, bullet in ipairs(bullets) do
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle('fill', bullet.position.x, bullet.position.y, BULLET_RADIUS)
  end

  -- Draw the zombies
  for i, zombie in ipairs(zombies) do
    love.graphics.setColor(zombie.color)
    love.graphics.circle('fill', zombie.position.x, zombie.position.y, zombie.radius)
  end

  -- Draw the explosions
  for i, explosion in ipairs(explosions) do
    love.graphics.setColor(1, 1, 0)
    love.graphics.circle('fill', explosion.position.x, explosion.position.y, explosion.radius)
  end

  --- Draw the debug information
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
  love.graphics.print("Memory: " .. math.floor(collectgarbage("count")) .. "kb", 10, 30)
  love.graphics.print("Zombies: " .. #zombies, 10, 50)
  love.graphics.print("Bullets: " .. #bullets, 10, 70)
  love.graphics.print("Explosions: " .. #explosions, 10, 90)
end
