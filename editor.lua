-- isome editor
-- this is for the the level editor
editor = {}

function editor.load()
	mouse = {x=0, y=0, z=1, i=1 }	-- the drawing tool thingy
	
	graphics.editor = {
		blanktile = love.graphics.newImage("tile0.png"),
	-- Cory's GUI
		powerico = love.graphics.newImage("powerico.png"),
		saveico = love.graphics.newImage("saveico.png"),
		openico = love.graphics.newImage("openico.png"),
		paletteico = love.graphics.newImage("paletteico.png"),
	}
	
	editor.menuopen = false
end

function editor.keypressed(k)
	if k == "kp+" then mouse.z = mouse.z + 1
	elseif k == "kp-" then mouse.z = mouse.z - 1	
	elseif k == "kpenter" then editor.layerview = not editor.layerview
	elseif k == "kp." then		-- save
		local file = love.filesystem.newFile("isome.zil") file:open("w")
		file:write(TLibCompress.CompressLZW("tiles="..TSerialize(tiles)))
		file:close()
	elseif k == "kp*" then		-- load
		local file = love.filesystem.newFile("isome.zil") file:open("r")
		tiles={} loadstring(TLibCompress.DecompressLZW(file:read()))()
		file:close()
	elseif love.keyboard.isDown("q") then
		editor.menuopen = not editor.menuopen
		iconx = love.mouse.getX()
		icony = love.mouse.getY()
	end
	-- "export" i/o code:
	--file:write(Tserialize(tiles))
	--tiles={} loadstring("tiles="..file:read())()
end

function editor.mousepressed(x, y, button)
	-- scroll through tiles
    if button == "wu" then mouse.i = (mouse.i > 1) and mouse.i-1 or #quads.tiles
    elseif button == "wd" then mouse.i = (mouse.i < #quads.tiles) and mouse.i+1 or 1
	end
end

function editor.update(dt)
	-- update cursor position
	local mx, my = love.mouse.getPosition()
	mouse.x, mouse.y = isoscreen(mx+cam.x, my+cam.y, mouse.z)
	
	-- camera controls
	if my < 32 then cam.y = cam.y-4
	elseif my > 568 then cam.y = cam.y+4 end
	if mx < 32 then cam.x = cam.x-4
	elseif mx > 768 then cam.x = cam.x+4 end
	if love.keyboard.isDown("up") then cam.y = cam.y-16
	elseif love.keyboard.isDown("down") then cam.y = cam.y+16 end
	if love.keyboard.isDown("left") then cam.x = cam.x-16
	elseif love.keyboard.isDown("right") then cam.x = cam.x+16 end
	
	-- place/remove tiles
	if not editor.menuopen then
		if love.mouse.isDown("l") then
			if tiles[mouse.z] then if tiles[mouse.z][mouse.x] then if tiles[mouse.z][mouse.x][mouse.y] then
				if tiles[mouse.z][mouse.x][mouse.y].i == mouse.i then return end
			end end end
			newtile(mouse.z, mouse.x, mouse.y, mouse.i)
		elseif love.mouse.isDown("r") then if tiles[mouse.z] then if tiles[mouse.z][mouse.x] then
			tiles[mouse.z][mouse.x][mouse.y] = nil
			if client then client.maketerrain() end
		end end end
	end
end

function editor.draw()
	love.graphics.print("editor", 750, 16)
	love.graphics.drawq(graphics.tiles, quads.tiles[mouse.i], 800, 600, 0, 4, 4, 32, 32)
	
	-- Cory's GUI Menu
	if editor.menuopen then
		local powerScaleX , powerScaleY, saveScaleX, saveScaleY, openScaleX, openScaleY, paletteScaleX, paletteScaleY = 1, 1, 1, 1, 1, 1, 1, 1
		local mx, my = love.mouse.getPosition()
		
		-- Close menu if cursor is too far from menu
		if mx < iconx-48 or mx > iconx+48 or my < icony-48 or my > icony+48 then
			-- make it choose the icon closest to the cursor, ala gesture control?
			editor.menuopen = false
			return
		end
		
		if mx < iconx-24 and mx > iconx-40 and my < icony+8 and my > icony-8 then
			powerScaleX, powerScaleY = 2, 2 love.graphics.print("Quit", iconx-80, icony+4)
		elseif mx > iconx+24 and mx < iconx+40 and my < icony+8 and my > icony-8 then
			saveScaleX, saveScaleY = 2, 2  love.graphics.print("Save", iconx+56, icony+4)
		elseif mx < iconx+8 and mx > iconx-8 and my < icony-24 and my > icony-40 then
			openScaleX, openScaleY = 2, 2 love.graphics.print("Open", iconx-17, icony-56)
		elseif mx < iconx+8 and mx > iconx-8 and my > icony+24 and my < icony+42 then
			paletteScaleX, paletteScaleY = 2, 2 love.graphics.print("Pallette", iconx-20, icony+64)
		end
		
		love.graphics.draw(graphics.editor.powerico, (iconx - 32), icony, 0, powerScaleX, powerScaleY, 8, 8)
		love.graphics.draw(graphics.editor.saveico, (iconx + 32), icony, 0,saveScaleX, saveScaleY, 8, 8)
		love.graphics.draw(graphics.editor.openico, iconx, (icony - 32), 0, openScaleX, openScaleY, 8, 8)
		love.graphics.draw(graphics.editor.paletteico, iconx, (icony + 32), 0, paletteScaleX, paletteScaleY, 8, 8)
		love.graphics.line(iconx, icony, mx, my)
	end
end

function editor.unload()
	package.loaded.editor = nil
	editor = nil
end

-- draw ghost cursor
function editor.drawcursor()
	local r, g, b, a = love.graphics.getColor()
	local rx, ry = isogrid(mouse.z, mouse.x, mouse.y)
	love.graphics.print(rx..", "..ry, 8, 36)
	love.graphics.print(mouse.z..", "..mouse.x..", "..mouse.y, 8, 46)
	
	love.graphics.setColor(255, 255, 255, 192)
	love.graphics.drawq(graphics.tiles, quads.tiles[mouse.i], rx-cam.x, ry-cam.y, 0, 1, 1, 16, 16)
	love.graphics.setColor( 0, 0, 255-math.mod(love.timer.getTime()*300, 255), 63 )
	love.graphics.draw(graphics.editor.blanktile, rx-cam.x, ry-cam.y, 0, 1, 1, 16, 16)
	love.graphics.setColor(r, g, b, a)
end
