-- virtual resolution handling library
push = require 'push'

Class = require 'class'

require 'StateMachine'

require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

require 'Bird'
require 'Pipe'
require 'PipePair'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('pictures/background.png')
-- starting scroll location
local backgroundScroll = 0

local ground = love.graphics.newImage('pictures/ground.png')
local groundScroll = 0

-- scroll speed
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

-- looping back point
local BACKGOUND_LOOPING_POINT = 413

-- game continuing or not
local scrolling = true

function love.load()
    -- filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- seed the RNG
    math.randomseed(os.time())

    -- title
    love.window.setTitle('Flappy Bird')

    -- init fonts
    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('fonts/flappy.ttf', 56)

    -- init sounds
    sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/marios_way.mp3', 'static')
    }

    -- start play bg music
    sounds['music']:setLooping(true)
    sounds['music']:play()

    -- virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')

    -- init pressed keys table
    love.keyboard.keysPressed = {}

    love.mouse.buttonsPressed = {}
end

function love.resize(w, h)
    push:resize(w,h);
end

function love.keypressed(key)
    -- add keys to table of keys being pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

-- check if a key was pressed last frame
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.mouse.wasPressed(key)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)
    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGOUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
    end

    gStateMachine:update(dt)
        
    --reset the table
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end



