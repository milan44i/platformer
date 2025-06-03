function love.load()
  love.window.setMode(1000, 768)

  anim8 = require 'libraries/anim8/anim8'
  sti = require 'libraries/Simple-Tiled-Implementation/sti'
  cameraFile = require 'libraries/hump/camera'

  camera = cameraFile()

  sounds = {}
  sounds.jump = love.audio.newSource('audio/jump.wav', 'static')
  sounds.music = love.audio.newSource('audio/music.mp3', 'stream')
  sounds.music:setLooping(true)
  sounds.music:play()
  sounds.music:setVolume(0.1)
  sounds.jump:setVolume(0.2)

  sprites = {}
  sprites.playerSheet = love.graphics.newImage('sprites/playerSheet.png')
  sprites.enemySheet = love.graphics.newImage('sprites/enemySheet.png')
  sprites.background = love.graphics.newImage('sprites/background.png')

  local grid = anim8.newGrid(614, 564, sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight())
  local enemyGrid = anim8.newGrid(100, 79, sprites.enemySheet:getWidth(), sprites.enemySheet:getHeight())

  animations = {}
  animations.idle = anim8.newAnimation(grid('1-15', 1), 0.05)
  animations.jump = anim8.newAnimation(grid('1-7', 2), 0.05)
  animations.run = anim8.newAnimation(grid('1-15', 3), 0.05)
  animations.enemy = anim8.newAnimation(enemyGrid('1-2', 1), 0.03)

  wf = require 'libraries/windfield/windfield'
  world = wf.newWorld(0, 800, false)
  world:setQueryDebugDrawing(true)

  world:addCollisionClass('Player')
  world:addCollisionClass('Platform')
  world:addCollisionClass('Danger')

  require 'player'
  require 'enemy'
  require 'libraries/show'

  dangerZone = world:newRectangleCollider(-500, 800, 5000, 50, {collision_class = 'Danger'})
  dangerZone:setType('static')

  platforms = {}

  flagX = 0
  flagY = 0

  saveData = {}
  saveData.currentLevel = 'level1'

  if love.filesystem.getInfo('data.lua') then
    local data = love.filesystem.load('data.lua')
    data()  
  else
    love.filesystem.write('data.lua', table.show(saveData, 'saveData'))
  end

  loadMap(saveData.currentLevel)
end

function love.update(dt)
  world:update(dt)
  map:update(dt)
  playerUpdate(dt)
  updateEnemies(dt)

  local px, py = player:getPosition()
  camera:lookAt(px, love.graphics.getHeight() / 2)

  local colliders = world:queryCircleArea(flagX, flagY, 10, {'Player'})
  if #colliders > 0 then
    if saveData.currentLevel == 'level1' then
      loadMap('level2')
    elseif saveData.currentLevel == 'level2' then
      loadMap('level1')
    end
  end
end

function love.draw()
  love.graphics.draw(sprites.background, 0, 0)
  camera:attach()
    map:drawLayer(map.layers['Tile Layer 1'])
    playerDraw()
    drawEnemies()
  camera:detach()
end

function love.keypressed(key)
  if key == 'up' then
    if player.grounded then
      player:applyLinearImpulse(0, -4000)
      sounds.jump:play()
    end
  end
end

function spawnPlatform(x, y, width, height)
  if width <= 0 or height <= 0 then
    return
  end
  local platform = world:newRectangleCollider(x, y, width, height, {collision_class = 'Platform'})
  platform:setType('static')
  table.insert(platforms, platform)
end

function destroyAll()
  for i, platform in ipairs(platforms) do
    platform:destroy()
  end
  platforms = {}
  for i, enemy in ipairs(enemies) do
    enemy:destroy()
  end
  enemies = {}
end

function loadMap(mapName)
  saveData.currentLevel = mapName
  love.filesystem.write('data.lua', table.show(saveData, 'saveData'))
  destroyAll()
  map = sti('maps/' .. mapName .. '.lua')
  for i, object in ipairs(map.layers['Start'].objects) do
    playerStartX = object.x
    playerStartY = object.y
  end
  player:setPosition(playerStartX, playerStartY)
  for i, object in ipairs(map.layers['Platforms'].objects) do
    spawnPlatform(object.x, object.y, object.width, object.height)
  end
  for i, object in ipairs(map.layers['Enemies'].objects) do
    spawnEnemy(object.x, object.y)
  end
  for i, object in ipairs(map.layers['Flag'].objects) do
    flagX = object.x
    flagY = object.y
  end
end