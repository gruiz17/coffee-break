# The classes used in the game
class Bat
  constructor: ->
    @width = 90
    @height = 10
    @posX = window.canvas.width/2 - 45
    @posY = window.canvas.height - 40
    @xVelocity = 0

  draw: ->
    window.ctx.fillStyle = "rgb(200,0,0)"
    window.ctx.strokeStyle = "#ffffff"
    window.ctx.lineWidth = 2
    window.ctx.strokeRect(@posX, @posY, @width, @height)
    window.ctx.fillRect(@posX, @posY, @width, @height)

  updateVelocity: ->
    if @xVelocity < 0
      @xVelocity += 0.9
    else if @xVelocity > 0
      @xVelocity -= 0.9

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
    window.ctx.fillStyle = "#00ffff"
    window.ctx.strokeStyle = "#ffffff"
    window.ctx.lineWidth = 1.5
    window.ctx.beginPath()
    window.ctx.arc(@centerX, @centerY, @radius, 0, 2 * Math.PI, false)
    window.ctx.fill()
    window.ctx.stroke()

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
      window.ctx.fillStyle = @color
      window.ctx.strokeStyle = "#ffffff"
      window.ctx.lineWidth = 1
      window.ctx.strokeRect(@posX, @posY, @width, @height)
      window.ctx.fillRect(@posX, @posY, @width, @height)
