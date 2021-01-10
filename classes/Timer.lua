Timer = Class{}

function Timer:init()
self.start=1
self.timerEnd={}
self.timerCurrent={}
end
function Timer:new(name,seconds,toDo)
    name=name or self.start
    if name==self.start then
        self.start=self.start+1
    end
    seconds =seconds or math.huge
    self.timerCurrent[name]=0
    self.timerEnd[name]=seconds
    
end

function Timer:update(dt)
    dt=dt or 1/60
    for k,value in pairs(self.timerCurrent) do
        self.timerCurrent[k]=self.timerCurrent[k]+dt
    end
end

function Timer:check(name)
    name=name or self.start-1
    if Timer:valueExistsInTable(name) then
        if self.timerCurrent[name]>=self.timerEnd[name] then
            Timer:delete(name)
            return true
        end
    end
    return false
end

function Timer:get(name)
    if Timer:valueExistsInTable(name) then
    return self.timerCurrent[name]
    end
end

function Timer:set(name,value)
    name=name or self.start-1
    value=value or 0
    self.timerCurrent[name]=value
end

function Timer:drawAll(x)
    x=x or 0
    y=60
    local count=0
    for k,v in pairs(self.timerCurrent) do
        love.graphics.print(tostring(k):gsub("^%l", string.upper)..":  "..math.floor(v).."/"..self.timerEnd[k],x,y)
        y=y+20
    end
end

function Timer:valueExists(value)
    return value~=nil
end

function Timer:valueExistsInTable(name)
    return self.timerCurrent[name]~=nil or self.timerEnd[name]~=nil
end

function Timer:delete(name)
    self.timerCurrent[name]=nil
    self.timerEnd[name]=nil
end