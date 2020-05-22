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
Class = require 'utilities/class'

-- https://github.com/Ulydev/push
push = require 'utilities/push'

-- Sound effects: https://github.com/ttencate/jfxr

require 'gameplay/Snake'
require 'gameplay/Food'
require 'menu/menu'
require 'menu/Button'
require 'menu/Toggle'

function love.load()

    -- setting window title
    love.window.setTitle("Snake")

    -- instantiation of classes Snake and Food
    snake = Snake(8, 0.1)
    food = Food(4)

    -- instantiation of buttons
    newGame = Button()
    settings = Button()
    exit = Button()
    back = Button()

    -- instantiation of toggles
    easy = Toggle()
    medium = Toggle()
    hard = Toggle()

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

    -- initialise menu variables
    menuType = 'main'
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
        menuType = 'main'
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
    love.graphics.printf(tostring(snake.score), 
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