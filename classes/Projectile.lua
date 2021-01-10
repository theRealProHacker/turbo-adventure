Projectile=Class{}

function Projectile:init(owner,delay,dangle)
    self.owner=owner or Brawler
    if delay>=0 or delay then
        Timer:new(self,delay)
    end
    self.x=owner.x
    self.y=owner.y
    self.startX, self.startY=self.x,self.y
    self.speed=50
    local aimX=love.mouse.getX()-self.x
    local aimY=love.mouse.getY()-self.y
    --everything about correction might become unvital
    local correction=0
    self.dangle=dangle or 0
    if aimX<0 and aimY>=0 then
        correction=math.pi/2
    end
    if aimX<0 and aimY<0 then
        correction=math.pi
    end
    if aimX>=0 and aimY<0 then
        correction=math.pi*3/2
    end
    self.correction=correction
    self.angle=math.atan2(aimY,aimX)+self.dangle  

    aimX, aimY = math.cos(self.angle), math.sin(self.angle)
    self.dx,self.dy=normVector(aimX,aimY,self.speed)
    self.range=100
    self.image=images['arrow']
    
    self.activeB=false
end

function Projectile:update(dt)
    if Timer:check(self) then
        self.activeB=true
        self.x,self.y=self.owner.x,self.owner.y
    end
    self.distance= distance(self.x,self.y,self.startX,self.startY)
    if self.distance>=self.range then
        self.delete=true    
    else
    if self.activeB then    
        self.moving=true
        self.x=self.x+self.dx*dt
        self.y=self.y+self.dy*dt
        end
    end
end

function Projectile:draw()
    if self.activeB then
        love.graphics.draw(self.image,self.x,self.y,self.angle,2,2)
        if self.delete then
            displayCenter("delete")
        end
        if self.moving then
            local grad=math.deg(self.angle)
            local correction=math.deg(self.correction)
        --displayCenter(tostring(correction).."moving: "..tostring(grad))
        end
    end
end
