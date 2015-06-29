# What is a click handler

@playerX = 1
@playerY = 1

GridCodes =
    floor : 0
    wall : 1
    door : 2
    player : "P"
    enemy : "E"

class Player
    constructor: (name, type) ->
        @name = name
        @type = type
        @x = @playerX
        @y = @playerY
        return

    getName: ->
        "#{@name} the #{@type}"

    getType: ->
        @type

class GridSpace
    constructor: (type, x, y) ->
        @x = x
        @y = y
        @type = type

    setType: (type) ->
        @type = type

    checkSpace: ->
        return @type

class Level
    constructor: (maxWidth, maxHeight) ->
        @maxWidth = maxWidth
        @maxHeight = maxHeight
        @grid = for x in [0...maxWidth]
            for y in [0...maxHeight]
                new GridSpace(GridCodes.wall,x,y)

    checkGridSpace: (x,y) ->
        return @grid[x][y].checkSpace

    emptyLevel: ->
        for space in @grid
            if space.x > 0 and space.x < @maxWidth
                if space.y > 0 and space.y < @maxHeight
                    space.setType(GridCodes.floor)
        @grid[@playerX][@playerY].setType(GridCodes.player)
     

hero = new Player("Nogrelin", "Death Knight")
level = new Level(5,5)


canvas = document.createElement("canvas")
ctx = canvas.getContext("2d")
canvas.width = 640 # 5 units across
canvas.height = 480 # 5 units tall
document.body.appendChild(canvas)

floorReady = false
floorImage = new Image()
floorImage.onload = ->
    floorReady = true
    return
floorImage.src = "images/Floor.png"

wallReady = false
wallImage = new Image()
wallImage.onload = ->
    wallReady = true
    return
wallImage.src = "images/Wall.png"

playerReady = false
playerImage = new Image()
playerImage.onload = ->
    playerReady = true
    return
playerImage.src = "images/Player.png"

keysDown = {}

addEventListener("keydown", (e)->
        keysDown[e.keyCode] = true
        return
    ,false)

addEventListener("keyup", (e)->
        delete keysDown[e.keyCode]
        return
    ,false)

update = ->
    if 38 of keysDown
        if level.checkGridSpace(player.x,player.y-1) == GridCodes.floor
            player.y -= 1
    if 40 of keysDown
        if level.checkGridSpace(player.x,player.y+1) == GridCodes.floor
            player.y += 1
    if 37 of keysDown
        if level.checkGridSpace(player.x-1,player.y) == GridCodes.floor
            player.x -= 1
    if 39 of keysDown
        if level.checkGridSpace(player.x+1,player.y-1) == GridCodes.floor
            player.x += 1
