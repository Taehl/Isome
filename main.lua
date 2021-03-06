-- isome engine: 3D isometric multiplayer.
require("TSerial")
require("TLibCompress")

function love.load()
	love.mouse.setVisible(false)
	-- todo: add launcher of some sort
	require("client")
	require("server")
	require("editor")
	if server then server.load() end
	
	-- Returns 'n' rounded to the nearest 'deci'th
	function math.round(n, deci) deci = 10^(deci or 0) return math.floor(n*deci+.5)/deci end
	-- An ordered version of pairs()
	function kpairs(t, f)
		local a, i = {}, 0 for n in pairs(t) do table.insert(a, n) end table.sort(a, f)
		local iter = function() i = i+1 if a[i] == nil then return nil else return a[i], t[a[i]] end end
		return iter
	end

	graphics = { tiles = {
			love.graphics.newImage("tile1.png"),
			love.graphics.newImage("tile2.png"),
			love.graphics.newImage("tile3.png"),
		},
		player = love.graphics.newImage("player.png"),
	}
	
	if client then client.load() end
	if editor then editor.load() end
end

function love.keypressed(k)
	if k == "f1" then -- show a help screen
	elseif k == "f2" then if editor then editor.unload() else require("editor") editor.load() end
	elseif k == "f3" then if client then client.unload() else require("client") client.load() end
	elseif k == "f4" then
		if server then
			server.unload()
			-- connect to a server
		else require("server") server.load() end
	end

	if server then server.keypressed(k) end
	
	if k == "escape" then love.event.push("q")
	elseif k == "r" then love.filesystem.load("main.lua")() love.load()
	end
	
	if client then client.keypressed(k) end
	if editor then editor.keypressed(k) end
end

function love.mousepressed(x, y, button)
	if server then server.mousepressed(x, y, button) end
	if client then client.mousepressed(x, y, button) end
	if editor then editor.mousepressed(x, y, button) end
end

function love.update(dt)
	if server then server.update(dt) end	
	if client then client.update(dt) end
	if editor then editor.update(dt) end
end

function love.draw()
	--love.graphics.setColor(255, 255, 255, 255)
	if server then server.draw() end
	if client then client.draw() end
	if editor then editor.draw() end
	love.graphics.print("fps: "..love.timer.getFPS(), 8, 16)
end

-- Convert grid coordinates to screen coordinates
function isogrid(z, x, y)
	return math.round(-x*15 + y*15), math.round(y*7 + x*7 - z*16)
end

-- Convert screen coordinates to grid coordinates
-- todo: fix the whole z-creep thing...
function isoscreen(x, y, z)
	local a = 7/15
	y = y - 2*z
	return math.floor((y-x*a)/14)+z+math.round(z/3.5), math.floor((y+x*a)/14)+z+math.round(z/3.5)
end



-- tile functions

-- add a tile
function newtile(z, x, y, i)
	local t = {}
	t.i = i
	if not tiles[z] then tiles[z] = {} end
	if not tiles[z][x] then tiles[z][x] = {} end
	tiles[z][x][y] = t
end
