Snake = Class{}

-- initialises variables
function Snake:init(width, interval)

    -- table to store coordinates of the snake
    self.coords = {
        WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2,
        WINDOW_WIDTH / 2 - 10, WINDOW_HEIGHT / 2 
    }

    -- stores width of snake
    self.width = width

    self.direction = 'right'
    -- checks if there is change of direction in a given interval
    self.change = false

    -- stores starting length
    self.length = 10
    
    self.timer = 0
    -- interval is the amount of time before the snake moves by 10 pixels
    self.interval = interval

    -- sets the thickness of the line
    love.graphics.setLineWidth(self.width)

    -- loading sound
    self.foodCollect = love.audio.newSource('sounds/food_collect.wav', 'static')

    -- storing score
    self.score = 0
end

-- returns true if the snale collides either against itself or the wall
function Snake:collision()
    local i = (self.length / 10 + 1) * 2

    -- checks if snake collided against itself
    while i > 2 do
        if self.coords[i] == self.coords[2] and self.coords[i - 1] == self.coords[1] then
            return true
        end
        i = i - 2
    end

    -- checks if snake collided against the wall
    if self.coords[1] <= 0 or self.coords[1] >= WINDOW_WIDTH or self.coords[2] <= 0 or self.coords[2] >= WINDOW_HEIGHT then
        return true
    end

    return false
end

-- checks if the food has been 'eaten' by the snake
function Snake:food()
    if self.coords[1] == food.x and self.coords[2] == food.y then
        food:spawn()
        self.foodCollect:play()
        -- adds 10 to the length of the snake
        self.length = self.length + 10
        return true
    end
    return false
end

function Snake:update(dt)
    -- counts up timer
    self.timer = self.timer + dt

    while self.timer > self.interval do
        -- iteratively subtract interval from timer
        self.timer = self.timer - self.interval

        -- calculates number of coordinates
        local i = (self.length / 10 + 1) * 2 - 2

        -- updates each pair of coordinates by copying the values of one pair 
        -- to the previous pair
        while i > 0 do
            self.coords[i + 2] = self.coords[i]
            i = i - 1
        end

        -- updates first pair of coordinates based on the direction of movement
        if self.direction == 'left' then
            self.coords[1] = self.coords[1] - 10
        elseif self.direction == 'right' then
            self.coords[1] = self.coords[1] + 10
        elseif self.direction == 'up' then
            self.coords[2] = self.coords[2] - 10
        elseif self.direction == 'down' then
            self.coords[2] = self.coords[2] + 10
        end

        -- once direction change is done once in the interval, allow another direction change
        self.change = false

        -- checks if snake encountered food
        if self:food() then
            self.score = self.score + 1 / snake.interval
        end
    end
end

function Snake:render()
    -- light green colour
    love.graphics.setColor(212 / 255, 240 / 255, 197 / 255, 1)
    love.graphics.line(self.coords)
    -- dark green colour for the head
    love.graphics.setColor(115 / 255, 222 / 255, 124 / 255, 1)
    love.graphics.line(self.coords[1], self.coords[2], self.coords[3], self.coords[4])
    -- white colour
    love.graphics.setColor(1, 1, 1, 1) 
end