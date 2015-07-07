# What is a click handler

# I need a way to sync the x,y position of an object and the grid
# What I'm going to do is use the grid as a visual representaion of each object, only being an array that need to be populated with objects x's and y's. Each object will hold their own x,y values and check for another object with the x,y values that they're evaluating

# TODO
    # Consolidate object, type, and gridcode when necessary

GridCodes =
    floor : 0
    wall : 1
    door : 2
    player : "P"
    ogre : "O"

class Actor
    constructor:(@x,@y) ->
        return
    toGridSpace: ->
        return

class Player extends Actor
    seeRange: 5
    constructor: (@name, @type, @x, @y) ->
        super(@x, @y)
        return
    toGridSpace: ->
        return GridCodes.player
    getName: ->
        "#{@name} the #{@type}"
    getType: ->
        @type

class Enemy extends Actor
    constructor: (@name, @type,@x,@y) ->
        super(@x,@y)
        return
    getName: ->
        "#{@name} the #{@type}"
    getType: ->
        @type

class Ogre extends Enemy
    constructor: (@name,@x,@y)->
        super(@name, GridCodes.ogre, @x, @y)
        return
    toGridSpace: ->
        return GridCodes.ogre
    getName: ->
        "#{@name} the Ogre"

class GridSpace
    size: 128
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
    draw: (x,y,xmin, ymin) ->
        i = (x-xmin) * @grid[0][0].size
        j = (y-ymin) * @grid[0][0].size
        if bgReady
            ctx.drawImage(bgImage,i,j)
        if x>=0 and y>=0 and x<@maxWidth and y<@maxHeight
            if floorReady
                ctx.drawImage(floorImage,i,j)
            switch @grid[x][y].getSpace()
                when GridCodes.ogre
                    if ogreReady
                        ctx.drawImage(ogreImage, i, j)
                when GridCodes.wall
                    if wallReady
                        ctx.drawImage(wallImage, i, j)
                when GridCodes.player
                    if playerReady
                        ctx.drawImage(playerImage, i, j)
        return

hero = new Player("Nogrelin", "Death Knight", 1, 1)
ogre = new Ogre("Ogrelin",2,2)
grid = new Grid(7,7)

actors = [
    hero
    ogre
    ]

canvas = document.createElement("canvas")
ctx = canvas.getContext("2d")
canvas.width = window.innerWidth - 20#(hero.seeRange*2+1)*128
canvas.height = window.innerHeight - 20#(hero.seeRange*2+1)*128
document.body.appendChild(canvas)

bgReady = false
bgImage = new Image()
bgImage.onload = ->
    bgReady = true
    return
bgImage.src = "images/Background.png"

floorReady = false
floorImage = new Image()
floorImage.onload = ->
    floorReady = true
    return
floorImage.src = "images/Floor.png" #Floor

wallReady = false
wallImage = new Image()
wallImage.onload = ->
    wallReady = true
    return
wallImage.src = "images/Wall.png" #Wall

playerReady = false
playerImage = new Image()
playerImage.onload = ->
    playerReady = true
    return
playerImage.src = "images/Nogrelin.png" #Player

ogreReady = false
ogreImage = new Image()
ogreImage.onload = ->
    ogreReady = true
    return
ogreImage.src = "images/Ogre.png" #Ogre

keysDown = {}
playerActionAvailable = true
enemyActionAvailable = true

addEventListener("keydown", (e)->
        keysDown[e.keyCode] = true
        return
    ,false)

addEventListener("keyup", (e)->
        playerActionAvailable = true
        enemyActionAvailable = true
        delete keysDown[e.keyCode]
        return
    ,false)

update = ->
    # move player
    # get space you want to move to for emptiness and move or else dont
    if 38 of keysDown && playerActionAvailable
        if grid.getGridSpace(hero.x, hero.y-1) == GridCodes.floor
            hero.y-=1
        playerActionAvailable = false
    if 40 of keysDown && playerActionAvailable
        if grid.getGridSpace(hero.x, hero.y+1) == GridCodes.floor
            hero.y+=1
        playerActionAvailable = false
    if 37 of keysDown && playerActionAvailable
        if grid.getGridSpace(hero.x-1, hero.y) == GridCodes.floor
            hero.x-=1
        playerActionAvailable = false
    if 39 of keysDown && playerActionAvailable
        if grid.getGridSpace(hero.x+1, hero.y) == GridCodes.floor
            hero.x+=1
            playerActionAvailable = false

    if enemyActionAvailable
        num = Math.floor(Math.random()*4+1)
        switch num
            when 1
                if grid.getGridSpace(ogre.x, ogre.y-1) == GridCodes.floor
                    ogre.y-=1
                else if grid.getGridSpace(ogre.x, ogre.y-1) == GridCodes.player
                    console.log "#{ogre.getName()} attacked #{hero.getName()}"
                enemyActionAvailable = false
            when 2
                if grid.getGridSpace(ogre.x, ogre.y+1) == GridCodes.floor
                    ogre.y+=1
                else if grid.getGridSpace(ogre.x, ogre.y+1) == GridCodes.player
                    console.log "#{ogre.getName()} attacked #{hero.getName()}"
                enemyActionAvailable = false
            when 3
                if grid.getGridSpace(ogre.x-1, ogre.y) == GridCodes.floor
                    ogre.x-=1
                else if grid.getGridSpace(ogre.x-1, ogre.y) == GridCodes.player
                    console.log "#{ogre.getName()} attacked #{hero.getName()}"
                enemyActionAvailable = false
            when 4
                if grid.getGridSpace(ogre.x+1, ogre.y) == GridCodes.floor
                    ogre.x+=1
                else if grid.getGridSpace(ogre.x+1, ogre.y) == GridCodes.player
                    console.log "#{ogre.getName()} attacked #{hero.getName()}"
                enemyActionAvailable = false
    return
render = ->
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    # draw the 3x3 grid area around the hero
    grid.emptyGrid()
    grid.populateGrid(actors)

    # for i in [0..grid.maxWidth-1]
    #     for j in [0..grid.maxHeight-1]
    #         grid.draw(i,j, hero.seeRange)

    for i in [hero.x-hero.seeRange..hero.x+hero.seeRange]
        for j in [hero.y-hero.seeRange..hero.y+hero.seeRange]
            grid.draw(i,j, hero.x-hero.seeRange, hero.y-hero.seeRange)

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
