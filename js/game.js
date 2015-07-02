// Generated by CoffeeScript 1.9.3
(function() {
  var Actor, Grid, GridCodes, GridSpace, Player, actionAvailable, actors, canvas, ctx, floorImage, floorReady, grid, hero, keysDown, main, playerImage, playerReady, playerX, playerY, render, requestAnimationFrame, update, w, wallImage, wallReady,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  playerX = 1;

  playerY = 1;

  GridCodes = {
    floor: 0,
    wall: 1,
    door: 2,
    player: "P",
    enemy: "E"
  };

  Actor = (function() {
    function Actor(x1, y1) {
      this.x = x1;
      this.y = y1;
      return;
    }

    Actor.prototype.toGridSpace = function() {};

    return Actor;

  })();

  Player = (function(superClass) {
    extend(Player, superClass);

    function Player(name, type) {
      this.name = name;
      this.type = type;
      Player.__super__.constructor.call(this, playerX, playerY);
      return;
    }

    Player.prototype.toGridSpace = function() {
      return GridCodes.player;
    };

    Player.prototype.getName = function() {
      return this.name + " the " + this.type;
    };

    Player.prototype.getType = function() {
      return this.type;
    };

    return Player;

  })(Actor);

  GridSpace = (function() {
    GridSpace.prototype.size = 128;

    function GridSpace(x1, y1, object) {
      this.x = x1;
      this.y = y1;
      this.object = object;
    }

    GridSpace.prototype.setObject = function(object) {
      this.object = object;
    };

    GridSpace.prototype.getSpace = function() {
      return this.object;
    };

    return GridSpace;

  })();

  Grid = (function() {
    function Grid(maxWidth, maxHeight) {
      var x, y;
      this.maxWidth = maxWidth;
      this.maxHeight = maxHeight;
      this.grid = (function() {
        var k, ref, results;
        results = [];
        for (x = k = 0, ref = this.maxWidth; 0 <= ref ? k < ref : k > ref; x = 0 <= ref ? ++k : --k) {
          results.push((function() {
            var l, ref1, results1;
            results1 = [];
            for (y = l = 0, ref1 = this.maxHeight; 0 <= ref1 ? l < ref1 : l > ref1; y = 0 <= ref1 ? ++l : --l) {
              results1.push(new GridSpace(x, y, GridCodes.wall));
            }
            return results1;
          }).call(this));
        }
        return results;
      }).call(this);
      return;
    }

    Grid.prototype.getGridSpace = function(x, y) {
      return this.grid[x][y].getSpace();
    };

    Grid.prototype.emptyGrid = function() {
      var k, l, ref, ref1, x, y;
      for (x = k = 1, ref = this.maxWidth - 1; 1 <= ref ? k < ref : k > ref; x = 1 <= ref ? ++k : --k) {
        for (y = l = 1, ref1 = this.maxHeight - 1; 1 <= ref1 ? l < ref1 : l > ref1; y = 1 <= ref1 ? ++l : --l) {
          this.grid[x][y].setObject(GridCodes.floor);
        }
      }
    };

    Grid.prototype.populateGrid = function(actors) {
      var actor, k, len;
      this.emptyGrid();
      for (k = 0, len = actors.length; k < len; k++) {
        actor = actors[k];
        this.grid[actor.x][actor.y].setObject(actor.toGridSpace());
      }
    };

    Grid.prototype.draw = function(x, y) {
      var i, j;
      i = x * this.grid[0][0].size;
      j = y * this.grid[0][0].size;
      switch (this.grid[x][y].getSpace()) {
        case GridCodes.floor:
          if (floorReady) {
            ctx.drawImage(floorImage, i, j);
          }
          break;
        case GridCodes.wall:
          if (wallReady) {
            ctx.drawImage(wallImage, i, j);
          }
          break;
        case GridCodes.player:
          if (playerReady) {
            ctx.drawImage(playerImage, i, j);
          }
      }
    };

    return Grid;

  })();

  hero = new Player("Nogrelin", "Death Knight");

  grid = new Grid(5, 5);

  actors = [hero];

  canvas = document.createElement("canvas");

  ctx = canvas.getContext("2d");

  canvas.width = window.innerWidth;

  canvas.height = window.innerHeight;

  document.body.appendChild(canvas);

  floorReady = false;

  floorImage = new Image();

  floorImage.onload = function() {
    floorReady = true;
  };

  floorImage.src = "images/StandardEnemyship.png";

  wallReady = false;

  wallImage = new Image();

  wallImage.onload = function() {
    wallReady = true;
  };

  wallImage.src = "images/Noahs Starfighter.png";

  playerReady = false;

  playerImage = new Image();

  playerImage.onload = function() {
    playerReady = true;
  };

  playerImage.src = "images/Nogrelin.png";

  keysDown = {};

  actionAvailable = true;

  addEventListener("keydown", function(e) {
    keysDown[e.keyCode] = true;
  }, false);

  addEventListener("keyup", function(e) {
    actionAvailable = true;
    delete keysDown[e.keyCode];
  }, false);

  update = function() {
    if (38 in keysDown && actionAvailable) {
      if (grid.getGridSpace(hero.x, hero.y - 1) === GridCodes.floor) {
        hero.y -= 1;
      }
      actionAvailable = false;
    }
    if (40 in keysDown && actionAvailable) {
      if (grid.getGridSpace(hero.x, hero.y + 1) === GridCodes.floor) {
        hero.y += 1;
      }
      actionAvailable = false;
    }
    if (37 in keysDown && actionAvailable) {
      if (grid.getGridSpace(hero.x - 1, hero.y) === GridCodes.floor) {
        hero.x -= 1;
      }
      actionAvailable = false;
    }
    if (39 in keysDown && actionAvailable) {
      if (grid.getGridSpace(hero.x + 1, hero.y) === GridCodes.floor) {
        hero.x += 1;
      }
      actionAvailable = false;
    }
  };

  render = function() {
    var i, j, k, l, ref, ref1, ref2, ref3;
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    grid.emptyGrid();
    grid.populateGrid(actors);
    for (i = k = ref = hero.x - 1, ref1 = hero.x + 1; ref <= ref1 ? k <= ref1 : k >= ref1; i = ref <= ref1 ? ++k : --k) {
      for (j = l = ref2 = hero.y - 1, ref3 = hero.y + 1; ref2 <= ref3 ? l <= ref3 : l >= ref3; j = ref2 <= ref3 ? ++l : --l) {
        grid.draw(i, j);
      }
    }
  };

  main = function() {
    var delta, now;
    now = Date.now();
    delta = now - previousTime;
    update(delta / 1000);
    render();
    this.previousTime = now;
    requestAnimationFrame(main);
  };

  w = window;

  requestAnimationFrame = w.requestAnimationFrame || w.webkitRequestAnimationFrame || w.msRequestAnimationFrame || w.mozRequestAnimationFrame;

  this.previousTime = Date.now();

  main();

}).call(this);
