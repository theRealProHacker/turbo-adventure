function love.resize(w,h)
    push:resize(w,h)
end
function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end
function isEven(x)
    return x%2==0
end
function distance(x1,y1,x2,y2)
    x1=math.abs(x1) or 0
    y1=math.abs(y1) or 0
    x2=math.abs(x2) or 0
    y2=math.abs(y2) or 0
    local distance = math.sqrt((x1-x2)^2+(y1-y2)^2)
    return distance
end
function normVector(x,y,norm)
    norm =norm or 1
    local length = distance(x,y,0,0)
    x=x/length*norm
    y=y/length*norm
    return x,y
end
function displayCenter(string)
    
    string=string or ""
    love.graphics.setFont(scoreFont)
    love.graphics.setColor(0,0,0,1)
    love.graphics.print(string,VIRTUAL_WIDTH/2-10 , VIRTUAL_HEIGHT/2-10)
    love.graphics.setColor(1,1,1,1)
end
function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(largeFont)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(1,1,1,1)
end
function displayMemory()
    -- simple FPS display across all states
    love.graphics.setFont(largeFont)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('Memory: ' .. tostring(round(collectgarbage("count"))), 10, 30)
    love.graphics.setColor(1,1,1,1)
end

function print_r(thing)
    if type(thing) ==nil then
        return nil
    else
        love.graphics.setFont(scoreFont)
        love.graphics.setColor(0,0,0,1)
        
        if type(thing)=="string" then
            pushGlobal(thing,x)
        elseif type(thing)=="number" then
            thing =tostring(thing)
            pushGlobal(thing,x)
        elseif type(thing)=="table" then
            for key,value in pairs(thing) do
                pushGlobal(thing[key])
            end
        end
        love.graphics.setColor(1,1,1,1)
    end

end

function pushGlobal(string)
    table.insert(globalPush,string)    
end

function printGlobal()
    local y=20
    for key,value in pairs(globalPush) do
        y=y+20
        love.graphics.print(value,500,y)
    end
end

--blank Function
function blank()
end
--does not work actually
function traverse_nested_array(arr) 
    local simple_array={}
    for k,i in pairs(arr) do
        if type(i) == "table" then
            i=traverse_nested_array(i)
        else
            table.insert(simple_array,i)
        end
    end
    return simple_array
end