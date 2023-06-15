Player = Class{}

function Player:init(x, y)
	self.x = x
	self.y = y
	
	self.width = 8
	self.height = 25
end

function Player:render()
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
