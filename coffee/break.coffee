$ = jQuery
FPS = 100
canvas = document.getElementById('game')
rect = canvas.getBoundingClientRect()

canvas.width = canvas.height = 550

ctx = canvas.getContext('2d')

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

  draw: ->
    if @destroyed == false
      ctx.fillStyle = @color
      ctx.strokeStyle = "#ffffff"
      ctx.lineWidth = 1
      ctx.strokeRect(@posX, @posY, @width, @height)
      ctx.fillRect(@posX, @posY, @width, @height)

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

ballCollides = (b, block) ->


handleCollisions = (b) ->
  ballOnEdge(b)

bat = new Bat()
ball = new Ball(bat)

window.GAME_START = false
window.LIVES = 3
window.LEVEL = 1

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

blocks = initializeBlocks()

$('#game').click (e) ->
  if window.GAME_START == false
    window.GAME_START = true
  console.log(e.pageX)

$('#gamebox').mousemove (e) ->
  x = e.pageX - rect.left + 80
  if e.pageX + 80 < rect.left
    bat.posX = 0
  else if e.pageX - 80 > rect.right
    bat.posX = canvas.width - bat.width
  else
    bat.posX = x
  console.log('bat.x = ' + bat.posX)

update = () ->
  if ball.dead == true
    window.GAME_START = false
    window.LIVES -= 1
  if window.LIVES <= 0
    window.LIVES = 3
    window.LEVEL = 1

  if window.GAME_START == false
    ball.dead = false
    ball.centerX = bat.posX + 45
    ball.centerY = bat.posY - 20
    ball.xSpeed = 4
    ball.ySpeed = 4
    ball.direction = "lu"
  else
    ball.move()
    handleCollisions(ball)

draw = () ->
  ctx.clearRect(0, 0, 550, 550)
  bat.draw()
  ball.draw()
  block.draw() for block in blocks

gameLoop = () ->
  update()
  draw()
  return

setInterval(gameLoop, 1000/FPS)
