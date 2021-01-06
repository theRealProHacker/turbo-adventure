Brawler =Class{}


--initialize Brawler
function Brawler:init(directions)
    self.directions=directions or {"w","s","d","a"} 
    self.spawnB=false
    self.proj={}
end
--spawns Brawler at random Spawnpoint
function Brawler:spawn()
    --takes random Spawnpoint and sets Brawler there
    local length=#mainMap.spawnpoints
    local random=math.random(length)
    random=round(random)
    self.x=self.x or mainMap.spawnpoints[random][1]
    self.y=self.y or mainMap.spawnpoints[random][2]
    --sets Brawler to spawned
    self.spawnB=true
    --plays Spawn music
    self.sounds["start"]:setLooping(false)
    self.sounds["start"]:play()
    --gives additional data
    print_r(random)
    print_r(self.x)
    print_r(self.y)
    print_r(self.v)
    self.health=self.FULLHEALTH
end
--gives Brawler a delta time
function Brawler:update(dt)
    self:move(dt)
    if self.health<0 then
        self:die()
    end
end

-- draws Brawler and additional data
function Brawler:draw()
    love.graphics.draw(self.image, self.x, self.y)
    self:displayHealth()
end
-- lets the Brawler move
function Brawler:move(dt)
    local dt=dt or 1/60
    local directions = self.directions or {
        "w",
        "s",
        "d",
        "a"
    }
    
    local collide=collide or true
    
    local directionY =0
    local directionX =0
    local diagonalWeaken=1
    
    --no limit
    local limittop=-10000
    local limitbottom=10000
    local limitright=10000
    local limitleft=-10000
    --one time maybe replace 10000 with math.huge
    if collide==true then  -- specified boundaries
    
    limittop=0
    limitbottom=mainMap.totalY
    limitright=mainMap.totalX
    limitleft=0
    end
    if love.keyboard.isDown(directions[1]) or love.keyboard.isDown(directions[2]) or love.keyboard.isDown(directions[3]) or love.keyboard.isDown(directions[4]) then
        if love.keyboard.isDown(directions[1]) then
            
            if self.y>=limittop then
                directionY=-1
            end
        elseif love.keyboard.isDown(directions[2]) then
            if self.y<=limitbottom then
                directionY=1
            end
        end
        if love.keyboard.isDown(directions[3]) then
            if self.x<=limitright then
                directionX=1
            end
        elseif love.keyboard.isDown(directions[4]) then
            if self.x>=limitleft then
                directionX=-1
            end
        end
        if directionX~=0 and directionY~=0 then
            diagonalWeaken=0.7071
        end
        
        self.x=self.x+self.v*dt*directionX*diagonalWeaken
        self.x=math.min(math.max(limitleft,self.x),limitright)
        self.y=self.y+self.v*dt*directionY*diagonalWeaken
    end
end
function Brawler:displayHealth ()
    love.graphics.print(self.health,self.x-10,self.y-10)
end
function Brawler:die()
    self.spawnB=false
    Timer:new("respawn",5)--..tostring(self))
end
-- Single Brawler Data as Classes
--Include the Brawler Class
Bo=Class{__includes = Brawler,
    rarity="common",
    RARITY="fighter",
    v=30,
    image=images['bo'],
    attack= function(self)

    end,
    super=function (self)
    
    end,
    AMMO=3,
    FULLHEALTH=3600,
    starpower={},
    gadget={},
    sounds={
        ["start"]=music['bo_start_1']
    }
}
Max=Class{__includes = Brawler,
RARITY="mythic",
CLASS="fighter",
image=images['max'],
v=50,
FULLHEALTH=2500,
attack=function(self) end,
AMMO=4

}