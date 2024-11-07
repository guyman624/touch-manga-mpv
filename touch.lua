
local tapdown = false
local scroll = false

local swipeexittime = 0

local fingersdown = 0

local starttaptime = 0
local taplocx = 0
local taplocy = 0

local lastlocx = 0
local lastlocy = 0

local swipedir = 0

local displaywidth = 0

function ypos(points)
	if #points == 1 then
		return points[1].y
	end
	sum = 0
	for _, point in ipairs(points) do
		sum = sum + point.y
	end
    return (sum) / #points
end

function xpos(points)
	if #points == 1 then
		return points[1].x
	end
	sum = 0
	for _, point in ipairs(points) do
		sum = sum + point.x
	end
    return (sum) / #points
end


function first_page()
	mp.commandv("playlist-play-index", 0)
end

function last_page()
	local len = mp.get_property_number("playlist-count")
	mp.commandv("playlist-play-index", len - 1)
end


function resetvals()
	taptime = 0
	taplocx = 0
	starttaptime = 0
	swipedir = 0
	
	fingersdown = 0
	
	tapdown = false
	scroll = false
end



function handle_scroll(name, points)
	if #points > 0 then
		if #points > fingersdown then
			starttaptime = os.clock()
			fingersdown = #points
			taplocx = xpos(points)
			taplocy = ypos(points)
		end
		lastlocx = xpos(points)
		lastlocy = ypos(points)
	else
		taptime = os.clock() - starttaptime
		swipedir = taplocy - lastlocy

		if fingersdown == 1 then
				
			if taptime < .2 then
				displaywidth = mp.get_property_number("display-width")
				local ratio = taplocx/displaywidth
				if ratio < 0.3 then
					mp.command("playlist-prev")
				elseif ratio > 0.7 then
					mp.command("playlist-next")
				end
			else
				local swipedir = taplocy - lastlocy
				if swipedir > 400 then
					first_page()
				elseif swipedir < -400 then
					last_page()
				end
					
			end
		elseif fingersdown == 2 then
			if swipedir > 150 then
				brightness = mp.get_property_native("brightness")
				mp.command("no-osd add contrast -4; no-osd add brightness 4")
				
				mp.commandv("show-text", "Black Level: "..tostring(brightness + 4))
			elseif swipedir < -150 and swipedir > -400 then
				print(swipedir)
				brightness = mp.get_property_native("brightness")
				mp.command("no-osd add contrast 4; no-osd add brightness -4")
				
				mp.commandv("show-text", "Black Level: "..tostring(brightness - 4))
			elseif swipedir < -400 then
				if os.clock() - swipeexittime < 0.8 then
					mp.command("quit")
				else
					swipeexittime = os.clock()
				end
			end

		end
		resetvals()
	end
	
end



mp.observe_property("touch-pos", "native", handle_scroll)