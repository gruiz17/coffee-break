# Coffee Break source code
# by Gabiel Ruiz
#################
# sounds
#################
window.batSound = new Audio('sounds/bat.wav')
window.blockSound = new Audio('sounds/block.wav')
window.deathSound = new Audio('sounds/death.wav')
window.startSound = new Audio('sounds/start.wav')
window.winSound = new Audio('sounds/win.wav')
#################
# classes
#################
class Bat
  constructor: ->
    @width = 90
    @height = 10
    @posX = canvas.width/2 - 45
    @posY = canvas.height - 40

  draw: ->
    ctx.fillStyle = "rgb(200,0,0)"
    ctx.strokeStyle = "#ffffff"
    ctx.lineWidth = 2
    ctx.strokeRect(@posX, @posY, @width, @height)
    ctx.fillRect(@posX, @posY, @width, @height)

class Ball
  constructor: (bat) ->
    @radius = 6
    @centerX = bat.posX + 45
    @centerY = bat.posY - 20
    @xSpeed = 4
    @ySpeed = 4
    @direction = "lu"
    @dead = false

  draw: ->
    ctx.fillStyle = "#00ffff"
    ctx.strokeStyle = "#ffffff"
    ctx.lineWidth = 1.5
    ctx.beginPath()
    ctx.arc(@centerX, @centerY, @radius, 0, 2 * Math.PI, false)
    ctx.fill()
    ctx.stroke()

  move: ->
    if @direction == "lu"
      @centerX -= @xSpeed
      @centerY -= @ySpeed
    else if @direction == "ru"
      @centerX += @xSpeed
      @centerY -= @ySpeed
    else if @direction == "ld"
      @centerX -= @xSpeed
      @centerY += @ySpeed
    else if @direction == "rd"
      @centerX += @xSpeed
      @centerY += @ySpeed

  die: ->
    window.deathSound.play()
    window.deathSound = new Audio('sounds/death.wav')
    @dead = true
    @xSpeed = 0
    @ySpeed = 0

class Block
  constructor: (posX, posY, color) ->
    @width = 50
    @height = 20
    @posX = posX
    @posY = posY
    @color = color
    @destroyed = false

  die: ->
    @destroyed = true
    window.blockSound.play()
    window.blockSound = new Audio('sounds/block.wav')

  draw: ->
    if @destroyed == false
      ctx.fillStyle = @color
      ctx.strokeStyle = "#ffffff"
      ctx.lineWidth = 1
      ctx.strokeRect(@posX, @posY, @width, @height)
      ctx.fillRect(@posX, @posY, @width, @height)

#####################
# collision detection
#####################
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
    if b.direction == "rd"
      b.direction = "ru"
    else if b.direction == "ld"
      b.direction = "lu"
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

###########
# main game
###########

$ = jQuery
FPS = 100
canvas = document.getElementById('game')
rect = canvas.getBoundingClientRect()

canvas.width = canvas.height = 550

ctx = canvas.getContext('2d')

window.GAME_START = false
window.ROUND_START = false
window.LIVES = 3
window.LEVEL = 1

document.getElementById('lifecount').innerHTML = window.LIVES
document.getElementById('levelcount').innerHTML = window.LEVEL
document.getElementById('message').innerHTML = "Click to play!"

window.bat = new Bat()
window.ball = new Ball(bat)

initializeBlocks = () ->
  blockArray = []
  currX = 0
  currY = 60 # heh curry
  colors = ['#33FF33', '#99CC33', '#667799', '#993399']
  colorIndex = 0
  while currY < 140
    while currX < 550
      blockArray.push(new Block(currX, currY, colors[colorIndex]))
      currX += 50
      if colorIndex == 3
        colorIndex = 0
      else
        colorIndex += 1
    currX = 0
    currY += 20

  return blockArray

window.blocks = initializeBlocks()

window.BLOCK_COUNT = blocks.length

$('#game').click (e) ->
  if window.GAME_START == false
    window.GAME_START = true
    window.LIVES = 3
    window.LEVEL = 1
    window.ROUND_START = true
    document.getElementById('lifecount').innerHTML = window.LIVES
    document.getElementById('levelcount').innerHTML = window.LEVEL
    document.getElementById('message').innerHTML = ''
    window.startSound.play()
    window.startSound = new Audio('sounds/start.wav')

  else
    if window.ROUND_START == false
      window.ROUND_START = true
      document.getElementById('lifecount').innerHTML = window.LIVES
      document.getElementById('levelcount').innerHTML = window.LEVEL
      document.getElementById('message').innerHTML = ''
      window.startSound.play()
      window.startSound = new Audio('sounds/start.wav')

$('#gamebox').mousemove (e) ->
  x = e.pageX - rect.left + 80
  if e.pageX + 80 < rect.left
    window.bat.posX = 0
  else if e.pageX - 80 > rect.right
    window.bat.posX = canvas.width - bat.width
  else
    window.bat.posX = x

update = () ->
  if window.ball.dead == true
    window.ROUND_START = false
    window.LIVES -= 1
    if window.LIVES < 0
      document.getElementById('lifecount').innerHTML = 0
    else
      document.getElementById('lifecount').innerHTML = window.LIVES

  if window.LIVES == 0
    window.GAME_START = false
    document.getElementById('message').innerHTML = "You have completely died. Click to play again!"
    window.blocks = initializeBlocks()
    window.BLOCK_COUNT = window.blocks.length
  else
    if window.BLOCK_COUNT == 0
      window.ROUND_START = false
      window.blocks = initializeBlocks()
      window.BLOCK_COUNT = window.blocks.length
      window.LEVEL += 1
      document.getElementById('levelcount').innerHTML = window.LEVEL
      document.getElementById('message').innerHTML = "Moving to Level " + window.LEVEL + "!"
      window.winSound.play()
      window.winSound = new Audio('sounds/win.wav')

    if window.ROUND_START == false
      window.ball.dead = false
      window.ball.centerX = bat.posX + 45
      window.ball.centerY = bat.posY - 20
      window.ball.xSpeed = 4
      window.ball.ySpeed = 4
      window.ball.direction = "lu"
    else
      window.ball.move()
      handleCollisions(window.ball, window.bat, window.blocks)

draw = () ->
  ctx.clearRect(0, 0, 550, 550)
  window.bat.draw()
  window.ball.draw()
  block.draw() for block in window.blocks

gameLoop = () ->
  update()
  draw()
  return

setInterval(gameLoop, 1000/FPS)
