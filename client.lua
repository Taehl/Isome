-- isome client
-- this is for controls, menus, inventory, stats screens, ingame graphics, etc.
client = {}

function client.load()
	cam = { x=0, y=0 }
	player = {z=2, x=13, y=32}
	
	client.maketerrain()
end

function client.keypressed(k)
end

function client.mousepressed(x, y, button)
end

function client.update(dt)
	-- movement
	if love.keyboard.isDown("w") then player.x = player.x-0.1 player.y=player.y-0.1
	elseif love.keyboard.isDown("s") then player.x = player.x+0.1 player.y=player.y+0.1
	end
	if love.keyboard.isDown("a") then player.x = player.x+0.1 player.y=player.y-0.1
	elseif love.keyboard.isDown("d") then player.x = player.x-0.1 player.y=player.y+0.1
	end
	
	-- camera tracks player
	if not editor then local x, y = isogrid(player.z, player.x, player.y) cam.x, cam.y = x-400, y-300 end
end

function client.draw()
	love.graphics.print("client", 750, 26)
	love.graphics.print(cam.x..", "..cam.y, 8, 26)
	
	local cgx, cgy = isoscreen(cam.x+400, cam.y+300, 1)
	
	--local drewcursor = true
	--if editor then drewcursor = editor.menuopen end
	
	
	--love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(terrain, -cam.x, -cam.y, 0, 1, 1, 0, 0)
	if not drewcursor then editor.drawcursor() end
	
	-- player
	local rx, ry = isogrid(player.z, player.x, player.y)
	love.graphics.draw(graphics.player, rx-cam.x, ry-cam.y, 0, 1, 1, 16, 24)
end

function client.unload()
	-- save the player, either locally or on the server
	
	package.loaded.client = nil
	client = nil
end

function client.maketerrain()
	terrain:clear()
	for z, layer in kpairs(tiles) do
		-- change color based on relative depth if viewing by layers
		if editor then if editor.layerview then
			if z < mouse.z then love.graphics.setColor(255, 127, 127, 255)
			elseif z > mouse.z then love.graphics.setColor(127, 255, 127, 63)
			else love.graphics.setColor(255, 255, 255, 255)
			end
		end end
		for x, row in kpairs(layer) do
			for y, t in kpairs(row) do
				
				local rx, ry = isogrid(z, x, y)			
				terrain:addq(quads.tiles[t.i], rx, ry, 0, 1, 1, 16, 16)
				
				--if (z >= mouse.z) and (x >= mouse.x) and (y >= mouse.y) and not drewcursor then
				--	editor.drawcursor()
				--	drewcursor = true
				--end
			end
		end
	end
end