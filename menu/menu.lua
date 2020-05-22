local x, y, width, height

function menu()
    -- changes font to large
    love.graphics.setFont(largeFont)

    -- dimensions of menu
    height = WINDOW_HEIGHT / 1.5
    width = WINDOW_WIDTH / 1.5

    -- position of menu box
    x = WINDOW_WIDTH / 2 - width / 2
    y = WINDOW_HEIGHT / 2 - height / 2

    love.graphics.setColor(188 / 255, 201 / 255, 230 / 255, 0.5)
    love.graphics.rectangle('fill', x, y, width, height)

    if menuType == 'main' then
        mainMenu()
    elseif menuType == 'settings' then
        settingsMenu()
    end

    -- prints out message to resume game (if gameState is 'pause'')
    love.graphics.setFont(smallFont)
    if gameState == 'pause' then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf("hit esc to resume", 0, y + height - 10, WINDOW_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function mainMenu()
    -- renders and checks if the 'new game' button is clicked
    if newGame:render(x + width / 6, y + 20, width / 1.5, height / 5, 'NEW GAME') then
        newGame.buttonPress = false
        snake = Snake(8, snake.interval)
        food = Food(4)
        gameState = 'play'
    end    

    -- renders and checks if the 'settings' button is clicked
    if settings:render(x + width / 6, y + 60, width / 1.5, height / 5, 'SETTINGS') then
        menuType = 'settings'
        settings.buttonPress = false
    end

    -- renders and checks if the 'exit' button is clicked
    if exit:render(x + width / 6, y + 100, width / 1.5, height / 5, 'EXIT') then
        love.event.quit()
    end
end

function settingsMenu()
    --[[
        Difficulty levels
        Easy   - interval = 0.2
        Medium - interval = 0.1
        Hard   - interval = 0.05
    ]]

    -- sets different toggles
    if snake.interval == 0.2 then
        easy.toggle = true
        medium.toggle = false
        hard.toggle = false
    elseif snake.interval == 0.1 then
        easy.toggle = false
        medium.toggle = true
        hard.toggle = false
    else
        easy.toggle = false
        medium.toggle = false
        hard.toggle = true
    end

    -- checks whether a toggle is clicked on and changes other buttons
    if easy:render(x + width / 6, y + 30, width / 1.5, height / 8, 'EASY') then
        snake.interval = 0.2
        medium.toggle = false
        hard.toggle = false
    end

    if medium:render(x + width / 6, y + 55, width / 1.5, height / 8, 'MEDIUM') then
        snake.interval = 0.1
        easy.toggle = false
        hard.toggle = false
    end

    if hard:render(x + width / 6, y + 80, width / 1.5, height / 8, 'HARD') then
        snake.interval = 0.05
        easy.toggle = false
        medium.toggle = false
    end

    if back:render(x + width / 6, y + 110, width / 1.5, height / 5, 'BACK') then
        menuType = 'main'
        back.buttonPress = false
    end

    love.graphics.printf("DIFFICULTY", 0, y + 10, WINDOW_WIDTH, 'center')
end