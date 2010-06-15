function love.conf(t)
    t.modules.joystick = false
    t.modules.audio = false
    t.modules.keyboard = true
    t.modules.event = true
    t.modules.image = true
    t.modules.graphics = true
    t.modules.timer = true
    t.modules.mouse = true
    t.modules.sound = false
    t.modules.physics = false
	t.title = "isome"
    t.author = "Taehl"
    t.version = 0               -- The LÖVE version this game was made for (number)
    t.console = false
end
