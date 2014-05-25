$ = jQuery
FPS = 100
canvas = document.getElementById('game')
rect = canvas.getBoundingClientRect()

canvas.width = canvas.height = 550

ctx = canvas.getContext('2d')

class Bat
  constructor: ->
    @width = 90
    @height = 20
    @posX = canvas.width/2 - 45
    @posY = canvas.height - 60
    @color = "#ffffff"

  draw: ->
    ctx.fillStyle = "rgb(200,0,0)"
    ctx.strokeStyle = "#ffffff"
    ctx.lineWidth = 2
    ctx.strokeRect(@posX, @posY, @width, @height)
    ctx.fillRect(@posX, @posY, @width, @height)

bat = new Bat()

$('#game').click (e) ->
  $('#lifecount').append("<3 ")
  return

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

draw = () ->
  ctx.clearRect(0, 0, 550, 550)
  bat.draw()

gameLoop = () ->
  update()
  draw()

setInterval(gameLoop, 1000/FPS)
