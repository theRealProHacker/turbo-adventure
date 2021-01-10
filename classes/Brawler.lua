Brawler =Class{}


--initialize Brawler
function Brawler:init(directions,team)
    self.directions=directions or {"w","s","d","a"} 
    self.spawnB=false
    self.team=team
end
--spawns Brawler at random Spawnpoint
function Brawler:spawn()
    --takes random Spawnpoint and sets Brawler there
    local length=#mainMap.spawnpoints
    local random=math.random(length)
    random=round(random)
    self.x=self.x or mainMap.spawnpoints[random][1]
    self.y=self.y or mainMap.spawnpoints[random][2]
    self.width =love.graphics.getWidth(self.image) or 20
    self.height=love.graphics.getHeight(self.image) or 20
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
    self.health=self.HEALTH;self.ammo=self.AMMO
    self.lastShot=self.lastShot or 0;self.RECOVERY_SPEED=self.HEALTH/6
    self.proj={}
    self.lastHeal=Timer:get("main")
    self.healpart = love.graphics.newParticleSystem(images['particle'], 40)
    self.healpart:setEmissionArea('normal', 5, 10);self.healpart:setDirection(math.rad(270));self.healpart:setParticleLifetime(1);self.healpart:setSpeed(3);self.healpart:setLinearAcceleration(-5, -5, 5, -10);self.healpart:setColors(0,1,0,1)
end
--gives Brawler a delta time
function Brawler:update(dt)
    self:move(dt) --move
    self:updateHealth(dt)
    self:updateAmmo(dt)
    self:updateProjectiles(dt)
end

-- draws Brawler and additional data
function Brawler:draw()
    love.graphics.setFont(largeFont)
    love.graphics.draw(self.image, self.x, self.y)
    self:displayHealth()
    self:displayAmmo()
    self:drawProjectiles() 
    displayCenter(tostring(self.lastShot))
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
function Brawler:attack() -- a placeholder  
end
function Brawler:updateAmmo(dt)
    if isAgo(self.lastShot)>1 then
    self.ammo=math.min(self.AMMO,self.ammo+dt*self.AMMO_LOAD_SPEED)
    end
end
function Brawler:displayAmmo()
    local width=50
    local posx,posy = self.x-15,self.y-10
    local height = 7
    local round=3
    love.graphics.setColor(1,140/255,0,1)
    love.graphics.rectangle("fill",posx,posy ,width*self.ammo/self.AMMO, height,round,round)
    love.graphics.setColor(0,0,0,1)
    for i=0,2,1 do
        love.graphics.rectangle("line",posx+i*width/3,posy,width/3,height,round,round)
    end 
    love.graphics.setColor(1,1,1,1)
end
function Brawler:updateProjectiles(dt)
    for key,value in pairs(self.proj) do
        value:update(dt)
    end
    for key,value in pairs(self.proj) do
        if value.delete then
            table.remove(self.proj,key)
        end
    end
end
function Brawler:drawProjectiles()
    for key,value in pairs(self.proj) do
        value:draw()
    end
end
function Brawler:updateHealth(dt)
    if self.health<0 then
        self:die()
    end 
    
    if self.health<self.HEALTH and isAgo(self.lastShot)>=self.RECOVERY_TIME then
        if isAgo(self.lastHeal)>= 2 then
            --healing
            self.healpart:emit(5)
            self.lastHeal=Timer:get("main")
            self.health=math.min(self.HEALTH,self.health+self.RECOVERY_SPEED)
        end
    end
    self.healpart:update(dt)
end
function Brawler:displayHealth ()
    local posx,posy=self.x-15,self.y-23
    local width, height= 50,10
    love.graphics.setColor(0,1,0,1)
    love.graphics.rectangle("fill",posx,posy,width*self.health/self.HEALTH,height)  --health bar
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle("line",posx,posy,width,height)  --line
    love.graphics.setFont(mediumFont)
    love.graphics.print(round(self.health),posx+8,posy) -- text
    love.graphics.setFont(largeFont)
    love.graphics.setColor(1,1,1,1)
    --particlesystem
    love.graphics.draw(self.healpart, self.x+10, self.y+10)
    if isAgo(self.lastHeal)==0 then
    elseif self.health<self.HEALTH/4 then
        --red overlay
        love.graphics.setColor(1,0,0,0.13)
        love.graphics.rectangle("fill",0,0,VIRTUAL_WIDTH,VIRTUAL_HEIGHT)
        love.graphics.setColor(1,1,1,1)
    end
    
end
function Brawler:die()
    self.spawnB=false
    Timer:new("respawn",5)
end
function Brawler:takeDamage(damage)
    self.health=self.health-damage
    self.lastShot=Timer:get("main")
end
-- Single Brawler Data as Classes
--Include the Brawler Class
Bo=Class{__includes = Brawler,
    rarity="common",
    RARITY="fighter",
    v=30,
    image=images['bo'],
    attack= function(self)
        if self.ammo >=1 then
            self.ammo=self.ammo-1
            print_r(self.ammo)
            table.insert(self.proj,Projectile(self,0.3))
            table.insert(self.proj,Projectile(self,0.6))
            table.insert(self.proj,Projectile(self,0.9))
            self.lastShot=Timer:get("main")
        end
    end,
    super=function (self)
    
    end,
    AMMO=3,
    AMMO_LOAD_SPEED=0.5,
    HEALTH=3600,
    RECOVERY_TIME=3,
    RECOVERY_SPEED=200,
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
    HEALTH=2500,
    attack=function(self) end,
    AMMO=4

}
