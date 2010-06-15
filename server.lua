-- isome server
-- this is for game logic, game rules, physics, AI, etc.
server = {}

function server.load()
	tiles = {}
	
	-- make a little world
	--[[
	newtile(1, 11, 31, 1)
	newtile(1, 12, 31, 1)
	newtile(1, 13, 31, 1)
	newtile(1, 13, 32, 1)
	newtile(1, 13, 33, 1)
	newtile(2, 13, 31, 2)
	newtile(3, 13, 31, 2)
	--]]
	for x=0,500 do
		for y=0,500 do
			local i = math.random(2,3)
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
	
	package.loaded.server = nil
	server = nil
end
