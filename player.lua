playerStartX = 360
playerStartY = 100

player = world:newRectangleCollider(playerStartX, playerStartY, 40, 100, {collision_class = 'Player'})
player:setFixedRotation(true)
player.speed = 240
player.animation = animations.idle
player.isMoving = false
player.direction = 1
player.grounded = true

function playerUpdate(dt) 
  if player.body then
    local colliders = world:queryRectangleArea(player:getX() - 20, player:getY() + 50, 40, 2, {'Platform'})
    player.grounded = #colliders > 0
    player.isMoving = false
    local playerX, playerY = player:getPosition()
    if love.keyboard.isDown('right') then
      player:setX(playerX + player.speed * dt)
      player.isMoving = true
      player.direction = 1
    end
    if love.keyboard.isDown('left') then
      player:setX(playerX - player.speed * dt)
      player.isMoving = true
      player.direction = -1
    end

    if player:enter('Danger') then
      player:setPosition(playerStartX, playerStartY)
    end
  end

  if player.grounded then
    if player.isMoving then
      player.animation = animations.run
    else
      player.animation = animations.idle
    end
  else
    player.animation = animations.jump
  end
  player.animation:update(dt)
end

function playerDraw()
  local playerX, playerY = player:getPosition()
  player.animation:draw(sprites.playerSheet, playerX, playerY, nil, 0.25 * player.direction, 0.25, 130, 300)
end