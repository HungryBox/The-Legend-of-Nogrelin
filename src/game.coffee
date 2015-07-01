# What is a click handler

# I need a way to sync the x,y position of an object and the grid
# What I'm going to do is use the grid as a visual representaion of each object, only being an array that need to be populated with objects x's and y's. Each object will hold their own x,y values and check for another object with the x,y values that they're evaluating

# These should eventually provide a random valid output on the grid
playerX = 1 
playerY = 1 

GridCodes =
    floor : 0
    wall : 1
    door : 2
    player : "P"
    enemy : "E"

class Actor
    constructor:(@x,@y) ->
        return

    toGridSpace: ->
        return
    
class Player extends Actor
    constructor: (@name, @type) ->
        super(playerX,playerY)
        return

    toGridSpace: ->
        return GridCodes.player

    getName: ->
        "#{@name} the #{@type}"

    getType: ->
        @type

class GridSpace
    size: 30
    constructor: (@x, @y, @object) ->

    setObject: (@object) ->

    getSpace: ->
        return @object

class Grid
    constructor: (@maxWidth, @maxHeight) ->
        @grid = for x in [0...@maxWidth]
            for y in [0...@maxHeight]
                new GridSpace(x,y,GridCodes.wall)
        return

    getGridSpace: (x,y) ->
        return @grid[x][y].getSpace()

    emptyGrid: ->
        for x in [1...@maxWidth-1]
            for y in [1...@maxHeight-1]
                @grid[x][y].setObject(GridCodes.floor)
        return

    populateGrid: (actors) ->
        this.emptyGrid()
        for actor in actors
            @grid[actor.x][actor.y].setObject(actor.toGridSpace())
        return

    draw: (x,y) ->
        i = x * @grid[0][0].size
        j = y * @grid[0][0].size
        switch @grid[x][y].getSpace()
            when GridCodes.floor
                if floorReady
                    ctx.drawImage(floorImage, i, j)
            when GridCodes.wall 
                if wallReady
                    ctx.drawImage(wallImage, i, j)
            when GridCodes.player
                if playerReady
                    ctx.drawImage(playerImage, i, j)
        ctx.fillStyle = "rgb(250,250,250)"
        ctx.font = "24px Helvetica"
        ctx.textAlign = "left"
        ctx.textBaseline = "top"
        return
        
            
hero = new Player("Nogrelin", "Death Knight")
grid = new Grid(5,5)

actors = [
    hero
    #enemy
    ]

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
floorImage.src = "images/StandardEnemyship.png" #Floor

wallReady = false
wallImage = new Image()
wallImage.onload = ->
    wallReady = true
    return
wallImage.src = "images/Noahs Starfighter.png" #Wall

playerReady = false
playerImage = new Image()
playerImage.onload = ->
    playerReady = true
    return
playerImage.src = "images/Starfighter.png" #Player


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
    # move player
    # get space you want to move to for emptiness and move or else dont
    if 38 of keysDown
        if grid.getGridSpace(hero.x, hero.y-1) == GridCodes.floor
            hero.y-=1
    if 40 of keysDown
        if grid.getGridSpace(hero.x, hero.y+1) == GridCodes.floor
            hero.y+=1
    if 37 of keysDown
        if grid.getGridSpace(hero.x-1, hero.y) == GridCodes.floor
            hero.x-=1
    if 39 of keysDown
        if grid.getGridSpace(hero.x+1, hero.y) == GridCodes.floor
            hero.x+=1
    return

render = ->
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    
    # draw the 3x3 grid area around the hero
    grid.emptyGrid()
    grid.populateGrid(actors)

    # should be: draw background (floor and walls)
    # for i in [0..grid.maxWidth-1]
    #     for j in [0..grid.maxHeight-1]
    #         grid.draw(i,j) 
  
    for i in [hero.x-1..hero.x+1]
        for j in [hero.y-1..hero.y+1]
            grid.draw(i,j)

    # then: draw actors ontop of current layer
    return

main = ->
    now = Date.now()
    delta = now-previousTime

    update(delta / 1000)
    render()

    @previousTime = now

    requestAnimationFrame(main)

    return

w = window
requestAnimationFrame = w.requestAnimationFrame || w.webkitRequestAnimationFrame || w.msRequestAnimationFrame || w.mozRequestAnimationFrame

@previousTime = Date.now()

main()
