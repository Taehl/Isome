-- isome server
-- this is for game logic, game rules, physics, AI, etc.
server = {}

function server.load()
	tiles = {}
	
	for x=1,200 do
		for y=1,200 do
			local i = math.max(math.random(-3,3), 1)
			newtile(1, x, y, i, true)
		end
	end
end

function server.keypressed(k)
end

function server.mousepressed(x, y, button)
end

function server.update(dt)
	-- todo: physics
	-- make movement add to a table requesting permission to move,
	-- and figure out here if there's a tile or something in the way?...
end

function server.draw()
	love.graphics.print("server", 750, 36)
end

function server.unload()
	-- save all connected players
	-- tell clients to disconnect
	
	package.loaded.server = nil
	server = nil
end
