// Generated by CoffeeScript 1.9.3
(function() {
  var bgImage, bgReady, canvas, ctx, hero, heroImage, heroReady, keysDown, main, monster, monsterImage, monsterReady, monstersCaught, render, requestAnimationFrame, reset, update, w;

  canvas = document.createElement("canvas");

  ctx = canvas.getContext("2d");

  canvas.width = 512;

  canvas.height = 480;

  document.body.appendChild(canvas);

  bgReady = false;

  bgImage = new Image();

  bgImage.onload = function() {
    bgReady = true;
  };

  bgImage.src = "images/Space.png";

  heroReady = false;

  heroImage = new Image();

  heroImage.onload = function() {
    heroReady = true;
  };

  heroImage.src = "images/Starfighter.png";

  monsterReady = false;

  monsterImage = new Image();

  monsterImage.onload = function() {
    monsterReady = true;
  };

  monsterImage.src = "images/StandardEnemyShip.png";

  hero = {
    speed: 256
  };

  monster = {};

  monstersCaught = 0;

  keysDown = {};

  addEventListener("keydown", function(e) {
    keysDown[e.keyCode] = true;
  }, false);

  addEventListener("keyup", function(e) {
    delete keysDown[e.keyCode];
  }, false);

  reset = function() {
    hero.x = canvas.width / 2;
    hero.y = canvas.height / 2;
    monster.x = 32 + (Math.random() * (canvas.width - 64));
    monster.y = 32 + (Math.random() * (canvas.height - 64));
  };

  update = function(modifier) {
    if (38 in keysDown) {
      hero.y -= hero.speed * modifier;
    }
    if (40 in keysDown) {
      hero.y += hero.speed * modifier;
    }
    if (37 in keysDown) {
      hero.x -= hero.speed * modifier;
    }
    if (39 in keysDown) {
      hero.x += hero.speed * modifier;
    }
    if (hero.x <= monster.x + 32 && monster.x <= hero.x + 32 && hero.y <= monster.y + 32 && monster.y <= hero.y + 32) {
      ++monstersCaught;
      reset();
    }
  };

  render = function() {
    if (bgReady) {
      ctx.drawImage(bgImage, 0, 0);
    }
    if (heroReady) {
      ctx.drawImage(heroImage, hero.x, hero.y);
    }
    if (monsterReady) {
      ctx.drawImage(monsterImage, monster.x, monster.y);
    }
    ctx.fillStyle = "rgb(250,250,250)";
    ctx.font = "24px Helvetica";
    ctx.textAlign = "left";
    ctx.textBaseline = "top";
    ctx.fillText("Goblins caught: " + monstersCaught, 32, 32);
  };

  main = function() {
    var delta, now;
    now = Date.now();
    delta = now - previousTime;
    update(delta / 1000);
    render();
    this.previousTime = now;
    requestAnimationFrame(main);
    console.log(keysDown);
  };

  w = window;

  requestAnimationFrame = w.requestAnimationFrame || w.webkitRequestAnimationFrame || w.msRequestAnimationFrame || w.mozRequestAnimationFrame;

  this.previousTime = Date.now();

  reset();

  main();

}).call(this);
