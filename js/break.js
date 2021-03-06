// Generated by CoffeeScript 1.7.1
(function() {
  var $, Ball, Bat, Block, FPS, ballHitsBat, ballHitsBlock, ballOnEdge, draw, gameLoop, handleCollisions, initializeBlocks, update;

  window.batSound = new Audio('sounds/bat.wav');

  window.blockSound = new Audio('sounds/block.wav');

  window.deathSound = new Audio('sounds/death.wav');

  window.startSound = new Audio('sounds/start.wav');

  window.winSound = new Audio('sounds/win.wav');

  Bat = (function() {
    function Bat() {
      this.width = 90;
      this.height = 10;
      this.posX = window.canvas.width / 2 - 45;
      this.posY = window.canvas.height - 40;
      this.xVelocity = 0;
    }

    Bat.prototype.draw = function() {
      window.ctx.fillStyle = "rgb(200,0,0)";
      window.ctx.strokeStyle = "#ffffff";
      window.ctx.lineWidth = 2;
      window.ctx.strokeRect(this.posX, this.posY, this.width, this.height);
      return window.ctx.fillRect(this.posX, this.posY, this.width, this.height);
    };

    Bat.prototype.updateVelocity = function() {
      if (this.xVelocity < 0) {
        return this.xVelocity += 0.9;
      } else if (this.xVelocity > 0) {
        return this.xVelocity -= 0.9;
      }
    };

    return Bat;

  })();

  Ball = (function() {
    function Ball(bat) {
      this.radius = 6;
      this.centerX = bat.posX + 45;
      this.centerY = bat.posY - 20;
      this.xSpeed = 4;
      this.ySpeed = 4;
      this.direction = "lu";
      this.dead = false;
    }

    Ball.prototype.draw = function() {
      window.ctx.fillStyle = "#00ffff";
      window.ctx.strokeStyle = "#ffffff";
      window.ctx.lineWidth = 1.5;
      window.ctx.beginPath();
      window.ctx.arc(this.centerX, this.centerY, this.radius, 0, 2 * Math.PI, false);
      window.ctx.fill();
      return window.ctx.stroke();
    };

    Ball.prototype.move = function() {
      if (this.direction === "lu") {
        this.centerX -= this.xSpeed;
        return this.centerY -= this.ySpeed;
      } else if (this.direction === "ru") {
        this.centerX += this.xSpeed;
        return this.centerY -= this.ySpeed;
      } else if (this.direction === "ld") {
        this.centerX -= this.xSpeed;
        return this.centerY += this.ySpeed;
      } else if (this.direction === "rd") {
        this.centerX += this.xSpeed;
        return this.centerY += this.ySpeed;
      }
    };

    Ball.prototype.die = function() {
      window.deathSound.play();
      window.deathSound = new Audio('sounds/death.wav');
      this.dead = true;
      this.xSpeed = 0;
      return this.ySpeed = 0;
    };

    return Ball;

  })();

  Block = (function() {
    function Block(posX, posY, color) {
      this.width = 50;
      this.height = 20;
      this.posX = posX;
      this.posY = posY;
      this.color = color;
      this.destroyed = false;
    }

    Block.prototype.die = function() {
      this.destroyed = true;
      window.blockSound.play();
      return window.blockSound = new Audio('sounds/block.wav');
    };

    Block.prototype.draw = function() {
      if (this.destroyed === false) {
        window.ctx.fillStyle = this.color;
        window.ctx.strokeStyle = "#ffffff";
        window.ctx.lineWidth = 1;
        window.ctx.strokeRect(this.posX, this.posY, this.width, this.height);
        return window.ctx.fillRect(this.posX, this.posY, this.width, this.height);
      }
    };

    return Block;

  })();

  ballOnEdge = function(b) {
    if (b.centerX - b.radius < 0) {
      if (b.direction === "lu") {
        b.direction = "ru";
      } else if (b.direction === "ld") {
        b.direction = "rd";
      }
    }
    if (b.centerX + b.radius > 550) {
      if (b.direction === "ru") {
        b.direction = "lu";
      } else if (b.direction === "rd") {
        b.direction = "ld";
      }
    }
    if (b.centerY - b.radius < 0) {
      if (b.direction === "lu") {
        b.direction = "ld";
      } else if (b.direction === "ru") {
        b.direction = "rd";
      }
    }
    if (b.centerY + b.radius > 550) {
      return ball.die();
    }
  };

  ballHitsBat = function(b, bat) {
    var _ref, _ref1;
    if (((bat.posX < (_ref = b.centerX) && _ref < bat.posX + bat.width)) && ((bat.posY < (_ref1 = b.centerY + b.radius) && _ref1 < bat.posY + bat.height))) {
      if (b.direction === "rd" && b.xSpeed - bat.xVelocity <= 0) {
        b.direction = "lu";
        b.xSpeed = Math.abs(b.xSpeed - bat.xVelocity);
      } else if (b.direction === "ld" && (-b.xSpeed) - bat.xVelocity > 0) {
        b.direction = "ru";
        b.xSpeed = Math.abs(-b.xSpeed - bat.xVelocity);
      } else {
        if (b.direction === "rd") {
          b.xSpeed -= bat.xVelocity;
        } else if (b.direction === "ld") {
          b.xSpeed += bat.xVelocity;
        }
        if (b.xSpeed > 5) {
          b.xSpeed = 5;
        }
        if (b.direction === "rd") {
          b.direction = "ru";
        } else if (b.direction === "ld") {
          b.direction = "lu";
        }
      }
      console.log(bat.xVelocity);
      console.log(b.xSpeed);
      window.batSound.play();
      return window.batSound = new Audio('sounds/bat.wav');
    }
  };

  ballHitsBlock = function(b, block) {
    var _ref, _ref1;
    if (!block.destroyed) {
      if ((block.posX < (_ref = b.centerX) && _ref < block.posX + block.width)) {
        if ((b.centerY - b.radius < block.posY + block.height) && (b.centerY > block.posY + block.height)) {
          if (b.direction === "ru") {
            b.direction = "rd";
          } else if (b.direction === "lu") {
            b.direction = "ld";
          }
          block.die();
          window.BLOCK_COUNT -= 1;
        }
        if ((b.centerY + b.radius > block.posY) && (b.centerY < block.posY)) {
          if (b.direction === "rd") {
            b.direction = "ru";
          } else if (b.direction === "ld") {
            b.direction = "lu";
          }
          block.die();
          return window.BLOCK_COUNT -= 1;
        }
      } else {
        if ((block.posY < (_ref1 = b.centerY) && _ref1 < block.posY + block.height)) {
          if ((b.centerX < block.posX) && (b.centerX + b.radius > block.posX)) {
            if (b.direction === "ru") {
              b.direction = "lu";
            } else if (b.direction === "rd") {
              b.direction = "ld";
            }
            block.die();
            window.BLOCK_COUNT -= 1;
          }
          if ((b.centerX > block.posX + block.width) && (b.centerX - b.radius < block.posX + block.width)) {
            if (b.direction === "lu") {
              b.direction = "ru";
            } else if (b.direction === "ld") {
              b.direction = "rd";
            }
            block.die();
            return window.BLOCK_COUNT -= 1;
          }
        }
      }
    }
  };

  handleCollisions = function(b, bat, blocks) {
    var block, _i, _len, _results;
    ballOnEdge(b);
    ballHitsBat(b, bat);
    _results = [];
    for (_i = 0, _len = blocks.length; _i < _len; _i++) {
      block = blocks[_i];
      _results.push(ballHitsBlock(b, block));
    }
    return _results;
  };

  $ = jQuery;

  FPS = 100;

  window.canvas = document.getElementById('game');

  window.rect = window.canvas.getBoundingClientRect();

  window.canvas.width = window.canvas.height = 550;

  window.ctx = window.canvas.getContext('2d');

  window.GAME_START = false;

  window.ROUND_START = false;

  window.LIVES = 3;

  window.LEVEL = 1;

  document.getElementById('lifecount').innerHTML = window.LIVES;

  document.getElementById('levelcount').innerHTML = window.LEVEL;

  document.getElementById('message').innerHTML = "Click to play!";

  window.bat = new Bat();

  window.ball = new Ball(bat);

  initializeBlocks = function() {
    var blockArray, colorIndex, colors, currX, currY;
    blockArray = [];
    currX = 0;
    currY = 60;
    colors = ['#33FF33', '#99CC33', '#667799', '#993399'];
    colorIndex = 0;
    while (currY < 140) {
      while (currX < 550) {
        blockArray.push(new Block(currX, currY, colors[colorIndex]));
        currX += 50;
        if (colorIndex === 3) {
          colorIndex = 0;
        } else {
          colorIndex += 1;
        }
      }
      currX = 0;
      currY += 20;
    }
    return blockArray;
  };

  window.blocks = initializeBlocks();

  window.BLOCK_COUNT = blocks.length;

  window.previousMouseX = 0;

  $('#game').click(function(e) {
    window.previousMouseX = e.pageX;
    if (window.GAME_START === false) {
      window.GAME_START = true;
      window.LIVES = 3;
      window.LEVEL = 1;
      window.ROUND_START = true;
      document.getElementById('lifecount').innerHTML = window.LIVES;
      document.getElementById('levelcount').innerHTML = window.LEVEL;
      document.getElementById('message').innerHTML = '';
      window.startSound.play();
      return window.startSound = new Audio('sounds/start.wav');
    } else {
      if (window.ROUND_START === false) {
        window.ROUND_START = true;
        document.getElementById('lifecount').innerHTML = window.LIVES;
        document.getElementById('levelcount').innerHTML = window.LEVEL;
        document.getElementById('message').innerHTML = '';
        window.startSound.play();
        return window.startSound = new Audio('sounds/start.wav');
      }
    }
  });

  $('#gamebox').mousemove(function(e) {
    var x;
    if (e.pageX - window.previousMouseX > 5) {
      window.bat.xVelocity += 2;
    } else if (e.pageX - window.previousMouseX < -5) {
      window.bat.xVelocity -= 2;
    } else {
      if (e.pageX < window.previousMouseX) {
        window.bat.xVelocity -= 1;
      } else if (e.pageX > window.previousMouseX) {
        window.bat.xVelocity += 1;
      }
    }
    window.previousMouseX = e.pageX;
    x = e.pageX - window.rect.left + 80;
    if (e.pageX + 80 < window.rect.left) {
      return window.bat.posX = 0;
    } else if (e.pageX - 80 > window.rect.right) {
      return window.bat.posX = window.canvas.width - window.bat.width;
    } else {
      return window.bat.posX = x;
    }
  });

  update = function() {
    window.bat.updateVelocity();
    console.log(window.ball.direction);
    if (window.ball.dead === true) {
      window.ROUND_START = false;
      window.LIVES -= 1;
      if (window.LIVES < 0) {
        document.getElementById('lifecount').innerHTML = 0;
      } else {
        document.getElementById('lifecount').innerHTML = window.LIVES;
      }
    }
    if (window.LIVES === 0) {
      window.GAME_START = false;
      document.getElementById('message').innerHTML = "You have completely died. Click to play again!";
      window.blocks = initializeBlocks();
      return window.BLOCK_COUNT = window.blocks.length;
    } else {
      if (window.BLOCK_COUNT === 0) {
        window.ROUND_START = false;
        window.blocks = initializeBlocks();
        window.BLOCK_COUNT = window.blocks.length;
        window.LEVEL += 1;
        document.getElementById('levelcount').innerHTML = window.LEVEL;
        document.getElementById('message').innerHTML = "Moving to Level " + window.LEVEL + "!";
        window.winSound.play();
        window.winSound = new Audio('sounds/win.wav');
      }
      if (window.ROUND_START === false) {
        window.ball.dead = false;
        window.ball.centerX = bat.posX + 45;
        window.ball.centerY = bat.posY - 20;
        window.ball.xSpeed = 4;
        window.ball.ySpeed = 4;
        return window.ball.direction = "lu";
      } else {
        window.ball.move();
        return handleCollisions(window.ball, window.bat, window.blocks);
      }
    }
  };

  draw = function() {
    var block, _i, _len, _ref, _results;
    window.ctx.clearRect(0, 0, 550, 550);
    window.bat.draw();
    window.ball.draw();
    _ref = window.blocks;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      block = _ref[_i];
      _results.push(block.draw());
    }
    return _results;
  };

  gameLoop = function() {
    update();
    draw();
  };

  setInterval(gameLoop, 1000 / FPS);

}).call(this);
