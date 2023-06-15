push = require 'push'
Class = require 'class'

require 'Player'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PLAYER_SPEED = 8

gameState = 'start'

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	
	love.window.setTitle('Pong')
	
	math.randomseed(os.time())
	
	
	mediumFont = love.graphics.newFont('font.ttf', 10)
	largeFont = love.graphics.newFont('font.ttf', 20)
	
	love.graphics.setFont(mediumFont)
	
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = true,
		vsync = true
	})
	
	sounds = {
		['hit'] = love.audio.newSource('sounds/hit.wav', 'static'),
		['score'] = love.audio.newSource('sounds/score.wav', 'static')
	}
	
	player1 = Player(20, VIRTUAL_HEIGHT / 2 - 12)
	player2 = Player((VIRTUAL_WIDTH - 20) - 8, VIRTUAL_HEIGHT / 2 - 12)
	
	server = 1
	winner = 0
	
	player1Score = 0
	player2Score = 0
	
	
	ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2)
end

function love.resize(weight, height)
	push:resize(weight, height)
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
	
	if key == 'enter' or key == 'return' then
		if gameState == 'start' then
			gameState = 'serve'
		elseif gameState == 'serve' then
			gameState = 'play'
		elseif gameState == 'win' then
			gameState = 'start'
			winner = 0
			player1Score = 0
			player2Score = 0
		end
	end
end

function love.update(dt)
	
	if gameState == 'serve' then
		ball.dy = math.random(-60, 60)
		
		if server == 1 then
			ball.dx = math.random(120, 210)
		else
			ball.dx = -math.random(120, 210)
		end
		
		
	elseif gameState == 'play' then
		if ball:collides(player1) then
			ball.dx = -ball.dx * 1.03
			ball.x = player1.x + 5
			
			if ball.dy < 0 then
				ball.dy = -math.random(10, 150)
			else
				ball.dy = math.random(10, 150)
			end
			
			sounds['hit']:play()
		end
		if ball:collides(player2) then
			ball.dx = -ball.dx * 1.03
			ball.x = player2.x - 5
			
			if ball.dy < 0 then
				ball.dy = -math.random(10, 150)
			else
				ball.dy = math.random(10, 150)
			end
			
			sounds['hit']:play()
		end
		
		
		
		if ball.y <= 0 then
			ball.y = 0
			ball.dy = -ball.dy
			
			
			sounds['hit']:play()
		end
		
		if ball.y >= VIRTUAL_HEIGHT - 4 then
			ball.y = VIRTUAL_HEIGHT - 4
			ball.dy = -ball.dy
			
			
			sounds['hit']:play()
		end
		
		
		
		
		if ball.x < 0 then
			server = 1
			player2Score = player2Score + 1
			sounds['score']:play()
			
			if player2Score == 10 then
				winner = 2
				gameState = 'win'
			else
				gameState = 'serve'
			end
			
			
			ball:reset()
		end
		
		if ball.x > VIRTUAL_WIDTH then
			server = 2
			player1Score = player1Score + 1
			sounds['score']:play()
			
			if player1Score == 10 then
				winner = 1
				gameState = 'win'
			else
				gameState = 'serve'
			end
			
			ball:reset()
		end
	
		ball:update(dt)
	end
	
	
	



	if love.keyboard.isDown('w') then
		player1.y = math.max(player1.y - PLAYER_SPEED, 0)
	elseif love.keyboard.isDown('s') then
		player1.y = math.min(player1.y + PLAYER_SPEED, VIRTUAL_HEIGHT - player1.height)
	end
	
	if love.keyboard.isDown('up') then
		player2.y = math.max(player2.y - PLAYER_SPEED, 0)
	elseif love.keyboard.isDown('down') then
		player2.y = math.min(player2.y + PLAYER_SPEED, VIRTUAL_HEIGHT - player2.height)
	end
end

function love.draw()
	push:start()
	
	love.graphics.clear(40/255, 40/255, 50/255, 255/255)
	
	
	
	displayScore()
	
	
	if gameState == 'start' then
		love.graphics.setFont(mediumFont)
		love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
		love.graphics.printf('Press Enter!', 0, 22, VIRTUAL_WIDTH, 'center')
	elseif gameState == 'serve' then
		love.graphics.setFont(mediumFont)
		love.graphics.printf('Press Enter to serve!', 0, 10, VIRTUAL_WIDTH, 'center')
	elseif gameState == 'win' then
		love.graphics.setFont(mediumFont)
		love.graphics.printf('Player ' .. winner .. ' has won', 0, 10, VIRTUAL_WIDTH, 'center')
	end
	
	player1:render()
	player2:render()
	
	ball:render()
	
	push:finish()
end

function displayScore()
	love.graphics.setFont(largeFont)
	love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
	love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end
