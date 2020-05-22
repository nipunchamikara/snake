Toggle = Class{}

function Toggle:init()
    self.toggle = false
end

function Toggle:render(x, y, width, height, text)
    -- gets position of mouse
    local cursorX, cursorY = love.mouse.getPosition()
    
    -- adjusts cursor position based on the current width, height and scale factor
    cursorX = (cursorX - math.max(0, (WIDTH - HEIGHT) / 2)) / SCALE_FACTOR
    cursorY = (cursorY - math.max(0, (HEIGHT - WIDTH) / 2)) / SCALE_FACTOR

    love.graphics.setColor(227 / 255, 244 / 255, 255 / 255, 1)

    -- checks whether mouse is hoving over the button
    if cursorX >= x and cursorX <= (x + width) and cursorY >= y and cursorY <= (y + height) then
        -- changes colour of button when hovered upon
        love.graphics.setColor(213 / 255, 228 / 255, 235 / 255, 1)

        -- checks whether primary button (1) has been clicked
        if love.mouse.isDown(1) then
            self.toggle = true
        end
    end

    if self.toggle == true then
        love.graphics.setColor(193 / 255, 217 / 255, 214 / 255, 1)
    end

    -- renders rectanges used as menu buttons
    love.graphics.rectangle('fill', x, y, width, height)
    love.graphics.setColor(0 , 0, 0, 1)
    love.graphics.printf(text, x, y + height / 2 - 7, width, 'center')
    love.graphics.setColor(1, 1, 1, 1)

    -- returns whether particular button has been pressed
    return self.toggle
end