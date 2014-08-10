# Collision detection/physics engine
ballOnEdge = (b) ->
  if b.centerX - b.radius < 0
    if b.direction == "lu"
      b.direction = "ru"
    else if b.direction == "ld"
      b.direction = "rd"
  if b.centerX + b.radius > 550
    if b.direction == "ru"
      b.direction = "lu"
    else if b.direction == "rd"
      b.direction = "ld"
  if b.centerY - b.radius < 0
    if b.direction == "lu"
      b.direction = "ld"
    else if b.direction == "ru"
      b.direction = "rd"
  if b.centerY + b.radius > 550
    ball.die()

ballHitsBat = (b, bat) ->
  if (bat.posX < b.centerX < bat.posX + bat.width) and (bat.posY < b.centerY + b.radius < bat.posY + bat.height)
    if b.direction == "rd" and b.xSpeed - bat.xVelocity <= 0
      b.direction = "lu"
      b.xSpeed = Math.abs(b.xSpeed - bat.xVelocity)
    else if b.direction == "ld" and (-b.xSpeed) - bat.xVelocity > 0
      b.direction = "ru"
      b.xSpeed = Math.abs(-b.xSpeed - bat.xVelocity)
    else
      if b.direction == "rd"
        b.xSpeed -= bat.xVelocity
      else if b.direction == "ld"
        b.xSpeed += bat.xVelocity
      if b.xSpeed > 5
        b.xSpeed = 5
      if b.direction == "rd"
        b.direction = "ru"
      else if b.direction == "ld"
        b.direction = "lu"
    console.log(bat.xVelocity)
    console.log(b.xSpeed)
    window.batSound.play()
    window.batSound = new Audio('sounds/bat.wav')

ballHitsBlock = (b, block) ->
  if !block.destroyed

    if block.posX < b.centerX < block.posX + block.width
      # bottom
      if (b.centerY - b.radius < block.posY + block.height) and (b.centerY > block.posY + block.height)
        if b.direction == "ru"
          b.direction = "rd"
        else if b.direction == "lu"
          b.direction = "ld"
        block.die()
        window.BLOCK_COUNT -= 1
      # top
      if (b.centerY + b.radius > block.posY) and (b.centerY < block.posY)
        if b.direction == "rd"
          b.direction = "ru"
        else if b.direction == "ld"
          b.direction = "lu"
        block.die()
        window.BLOCK_COUNT -= 1
    else
      if (block.posY < b.centerY < block.posY + block.height)
        # left
        if (b.centerX < block.posX) and (b.centerX + b.radius > block.posX)
          if b.direction == "ru"
            b.direction = "lu"
          else if b.direction == "rd"
            b.direction = "ld"
          block.die()
          window.BLOCK_COUNT -= 1
        # right
        if (b.centerX > block.posX + block.width) and (b.centerX - b.radius < block.posX + block.width)
          if b.direction == "lu"
            b.direction = "ru"
          else if b.direction == "ld"
            b.direction = "rd"
          block.die()
          window.BLOCK_COUNT -= 1

handleCollisions = (b, bat, blocks) ->
  ballOnEdge(b)
  ballHitsBat(b, bat)
  for block in blocks
    ballHitsBlock(b, block)
