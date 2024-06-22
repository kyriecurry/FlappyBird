PipePair = Class{}

local GAP_HEIGHT = 100

function PipePair:init(y)
    -- init pipes left over the screen
    self.x = VIRTUAL_WIDTH + 32

    -- y is y of top pipe's bottom
    self.y = y

    -- instantiate the two pipes
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    -- whether this pipes pair is to be removed or not
    -- don't remove items when iterating it, do it afterwards
    self.remove = false
end

function PipePair:update(dt)
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end
