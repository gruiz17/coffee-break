# the main game logic
$ = jQuery
FPS = 100
window.canvas = document.getElementById('game')
window.rect = window.canvas.getBoundingClientRect()

window.canvas.width = window.canvas.height = 550

window.ctx = window.canvas.getContext('2d')

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
window.previousMouseX = 0

$('#game').click (e) ->
  window.previousMouseX = e.pageX

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
  if e.pageX - window.previousMouseX > 5
    window.bat.xVelocity += 2
  else if e.pageX - window.previousMouseX < -5
    window.bat.xVelocity -= 2
  else
    if e.pageX < window.previousMouseX
      window.bat.xVelocity -= 1
    else if e.pageX > window.previousMouseX
      window.bat.xVelocity += 1
  window.previousMouseX = e.pageX
  x = e.pageX - window.rect.left + 80
  if e.pageX + 80 < window.rect.left
    window.bat.posX = 0
  else if e.pageX - 80 > window.rect.right
    window.bat.posX = window.canvas.width - window.bat.width
  else
    window.bat.posX = x

update = () ->
  window.bat.updateVelocity()
  # console.log(window.bat.xVelocity)
  console.log(window.ball.direction)
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
  window.ctx.clearRect(0, 0, 550, 550)
  window.bat.draw()
  window.ball.draw()
  block.draw() for block in window.blocks

gameLoop = () ->
  update()
  draw()
  return

setInterval(gameLoop, 1000/FPS)
