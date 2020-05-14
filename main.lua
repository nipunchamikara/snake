--[[
    Snake is the common name for a video game concept where the player maneuvers a 
    line which grows in length, with the line itself being a primary obstacle. 

    The snake is controlled using the arrow keys (up, down, left, right). 
    The task is to collect 'food' and avoid hitting itself or the surrounding wall.

    A menu is provided with basic functions like to start new game and to exit. 
    Hitting escape can pause/resume gameplay.

    More information can be found in the README.md file
]]

WINDOW_WIDTH = 240
WINDOW_HEIGHT = 240

-- https://github.com/vrld/hump
Class = require 'class'

-- https://github.com/Ulydev/push
push = require 'push'

require 'Snake'
require 'Food'

function love.load()

    -- setting window title
    love.window.setTitle("Snake")

    -- instantiation of classes Snake and Food
    snake = Snake(8, 0.1)
    food = Food(4)

    -- texture scaling filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- fonts
    largeFont = love.graphics.newFont('fonts/font.ttf', 15)
    smallFont = love.graphics.newFont('fonts/font.ttf', 10)

    -- setting window dimensions
    SCALE_FACTOR = 3
    push:setupScreen(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_WIDTH * SCALE_FACTOR, 
        WINDOW_HEIGHT * SCALE_FACTOR, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    -- default actual window size
    WIDTH = WINDOW_WIDTH
    HEIGHT = WINDOW_HEIGHT

    -- initialising game state
    gameState = 'start'
end

function love.resize(width, height)
    -- setting new values of actual width and height
    WIDTH = width
    HEIGHT = height

    -- resizing window preserving aspect ratio
    push:resize(width, height)

    -- calculating new scale factor after window resize
    SCALE_FACTOR = math.min(WIDTH / WINDOW_WIDTH, HEIGHT / WINDOW_HEIGHT)
end

-- listens for key presses
function love.keypressed(key)

    -- direction of snake changes once every interval
    if ((key == 'up' and snake.direction ~= 'down') or
        (key == 'down' and snake.direction ~= 'up') or
        (key == 'left' and snake.direction ~= 'right') or
        (key == 'right' and snake.direction ~= 'left')) and snake.change == false then
            snake.direction = key
            snake.change = true

    -- can play/pause
    elseif key == 'escape' and gameState ~= 'start' then
        if gameState == 'play' then
            gameState = 'pause'
        else
            gameState = 'play'
        end
    end
end


function love.update(dt)
    -- updates snake and food when game is being played (gameState = 'play')
    if gameState == 'play' then
        snake:update(dt)
    end

    -- constantly checks for collisions
    if snake:collision() then
        gameState = 'dead'
    end
end


--[[
    function prints score using length of snake
        score =  ((length of snake - 10) / (interval between frames)) / 10
]]
function score()
    -- sets colour to black
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(largeFont)
    -- prints out the score
    love.graphics.printf(tostring(((snake.length - 10)/ snake.interval) / 10), 
                        0, 10, WINDOW_WIDTH,'center')
    -- sets colour to white
    love.graphics.setColor(1, 1, 1, 1)
end


function love.draw()
    push:apply('start')

    -- background colour (dark blue)
    love.graphics.clear(97 / 255, 106 / 255, 125 / 255, 1)

    -- renders snake and food
    if gameState ~= 'start' then
        snake:render()
        food:render()
    end

    -- renders the boundary
    love.graphics.line(
        0, 0, 
        WINDOW_WIDTH, 0, 
        WINDOW_WIDTH, WINDOW_HEIGHT, 
        0, WINDOW_HEIGHT, 
        0, 0
    )

    -- shows menu if not playing
    if gameState ~= 'play' then
        menu()
    end
    
    -- prints score
    score()

    push:apply('end')
end

-- the following functions renders the menu

-- function returns true if button is clicked; renders buttons
function button(x, y, width, height, text)
    -- gets position of mouse
    local cursorX, cursorY = love.mouse.getPosition()
    
    -- adjusts cursor position based on the current width, height and scale factor
    cursorX = (cursorX - math.max(0, (WIDTH - HEIGHT) / 2)) / SCALE_FACTOR
    cursorY = (cursorY - math.max(0, (HEIGHT - WIDTH) / 2)) / SCALE_FACTOR

    local buttonPress = false

    love.graphics.setColor(227 / 255, 244 / 255, 255 / 255, 1)

    -- checks whether mouse is hoving over the button
    if cursorX >= x and cursorX <= (x + width) and cursorY >= y and cursorY <= (y + height) then
        -- changes colour of button when hovered upon
        love.graphics.setColor(213 / 255, 228 / 255, 235 / 255, 1)

        -- checks whether primary button (1) has been clicked
        if love.mouse.isDown(1) then
            buttonPress = true
        end
    end

    -- renders rectanges used as menu buttons
    love.graphics.rectangle('fill', x, y, width, height)
    love.graphics.setColor(0 , 0, 0, 1)
    love.graphics.printf(text, x, y + height / 2 - 7, width, 'center')
    love.graphics.setColor(1, 1, 1, 1)

    -- returns whether particular button has been pressed
    return buttonPress
end

function menu()
    -- changes font to large
    love.graphics.setFont(largeFont)

    -- dimensions of menu
    local height = WINDOW_HEIGHT / 2.5
    local width = WINDOW_WIDTH / 1.5

    -- position of menu box
    local x = WINDOW_WIDTH / 2 - width / 2
    local y = WINDOW_HEIGHT / 2 - height / 2

    love.graphics.setColor(188 / 255, 201 / 255, 230 / 255, 1)
    love.graphics.rectangle('fill', x, y, width, height)

    -- renders and checks if the 'new game' button is clicked
    if button(x + width / 6, y + width / 6 - 5, width / 1.5, height / 4, 'NEW GAME') then
        snake = Snake(8, 0.1)
        food = Food(4)
        gameState = 'play'
    end    

    -- renders and checks if the 'exit' button is clicked
    if button(x + width / 6, y + width / 3 + 5, width / 1.5, height / 4, 'EXIT') then
        love.event.quit()
    end

    -- prints out message to resume game (if gameState is 'pause'')
    love.graphics.setFont(smallFont)
    if gameState == 'pause' then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf("hit esc to resume", 0, y + height - 10, WINDOW_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
    end
end