Map = Class{}


--initialize map
function Map:init(rows,cols,size)
    self.map={} --create rows
    self.MAP_ROWS=rows
    self.MAP_COLS=cols
    self.TILE_HEIGHT=size
    self.TILE_WIDTH=size
    self.SCALE=size/30
    self.totalX=cols*size
    self.totalY=rows*size
    self.spawnpoints ={
        
    }
    for i=0,self.MAP_ROWS,1 do 
        self.map[i]={} --create collums
        for j=0,self.MAP_COLS,1 do
            if isEven(i+j) then
                self.map[i][j]={"lightTile",self.TILE_HEIGHT*i,self.TILE_WIDTH*j} --fill map with tiles (image,x,y)
            else
                self.map[i][j]={"darkTile",self.TILE_HEIGHT*i,self.TILE_WIDTH*j} -- fill map with tiles
            end
        end
    end
end

function Map:addSP(spawnpoints)
    for k,v in pairs(spawnpoints) do 
    table.insert(self.spawnpoints,v)
    end
    print_r(self.spawnpoints[1])
end

function Map:draw()
    for i=0,self.MAP_ROWS,1 do 
        for j=0,self.MAP_COLS,1  do
            Map:renderTile(self.map[i][j])
        end
    end
    
end

function Map:renderTile(tile)
    local tile=tile or {lightTile,0,0}
    local tileType=tile[1]
    love.graphics.draw(images[tileType],tile[2],tile[3],0,self.SCALE,self.SCALE) 
end



