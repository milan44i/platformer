enemies = {}

function spawnEnemy(x, y)
    local enemy = world:newRectangleCollider(x, y, 70, 90, {collision_class = 'Danger'})
    enemy.direction = 1
    enemy.speed = 200
    enemy.animation = animations.enemy
    table.insert(enemies, enemy)
end

function updateEnemies(dt)
    for i, enemy in ipairs(enemies) do
      enemy.animation:update(dt)
      local x, y = enemy:getPosition()

      local colliders = world:queryRectangleArea(x + 40 * enemy.direction, y + 45, 10, 10, {'Platform'})
      if #colliders == 0 then
          enemy.direction = -enemy.direction
      end

      enemy:setX(x + enemy.direction * enemy.speed * dt)
    end
end

function drawEnemies()
    for i, enemy in ipairs(enemies) do
        local x, y = enemy:getPosition()
        enemy.animation:draw(sprites.enemySheet, x, y, nil, enemy.direction, 1, 50, 65)
    end
end