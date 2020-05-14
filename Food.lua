Food = Class{}

-- initialises variables
function Food:init(radius)
    -- x and y coordinates of food
    self.x = 0
    self.y = 0

    -- radius of food
    self.radius = radius

    -- spawn
    self:spawn()
end

-- spawns food where the snake isn't present
function Food:spawn()
    math.randomseed(os.time())

    local unique = true

    repeat
        unique = true

        -- getting random multiples of 10 between 10 and window width/height
        self.x = math.floor(math.random(10, WINDOW_WIDTH - 10) / 10) * 10
        self.y = math.floor(math.random(10, WINDOW_HEIGHT - 10) / 10) * 10

        local i = (snake.length / 10 + 1) * 2

        -- checks if it's position hasn't been taken up by a snake ('unique' position)
        while i > 0 do
            if snake.coords[i - 1] == self.x and snake.coords[i] == self.y then
                unique = false
            end
            i = i - 2
        end

        -- loops until a 'unique' position has been found
    until unique == true
end

-- renders food (red)
function Food:render()
    -- light red colour
    love.graphics.setColor(219 / 255, 140 / 255, 140 / 255, 1)
    love.graphics.circle('fill', self.x, self.y, self.radius)
    -- white colour
    love.graphics.setColor(1, 1, 1, 1) 
end