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
    ctx.fillStyle = @color
    ctx.strokeStyle = "#ffffff"
    ctx.lineWidth = 1
    ctx.strokeRect(@posX, @posY, @width, @height)
    ctx.fillRect(@posX, @posY, @width, @height)

ballCollides = (b, rect) ->



bat = new Bat()
ball = new Ball(bat)

GAME_START = false

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
  if GAME_START == false
   GAME_START = true

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
  if GAME_START == false
    ball.centerX = bat.posX + 45
    ball.centerY = bat.posY - 20
  else
    ball.move()

draw = () ->
  ctx.clearRect(0, 0, 550, 550)
  bat.draw()
  ball.draw()
  block.draw() for block in blocks

gameLoop = () ->
  update()
  draw()

setInterval(gameLoop, 1000/FPS)
