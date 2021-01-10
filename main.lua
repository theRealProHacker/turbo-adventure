require 'requires'
-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 1280
VIRTUAL_HEIGHT = 720

globalPush={}
function love.load()
    math.randomseed(os.time())  --randomseed
    love.window.setTitle('Brawl Stars')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setBackgroundColor(0.5,0.53,0.5,0.8)
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
    -- Timer init and main Timer
    Timer:init()
    Timer:new("main")
    --Map
    mainMap=Map(30,30,30)
    --Spawnpoints
    mainMap:addSP({{50,50},{0,150},{100,200},{200,100},{300,500},{150,600}})
    mainBrawler=Bo() 
        --({"up","down","right","left"})
end

function love.update(dt)
    Timer:update(dt) 
    if Timer:check("respawn") then
        mainBrawler:spawn()
    end
    --only change Brawler when spawned
    if mainBrawler.spawnB then    
        mainBrawler:update(dt)
    end
end

function love.draw()
    --draw map first
    mainMap:draw()
    displayFPS()
    displayMemory()
    Timer:drawAll(20)
    printGlobal()
    --only change Brawler when spawned
    if mainBrawler.spawnB then
    mainBrawler:draw()
    end
    
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key== 'space' then
        mainBrawler:spawn()
    end
    if key=="g" then
        mainBrawler:takeDamage(1000)
    end
end
function love.mousepressed(x,y,button)
    if button==1 and mainBrawler.spawnB then
        mainBrawler:attack()
    end
end