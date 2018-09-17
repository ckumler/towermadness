pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--tower madness
-- by corey kumler

local player
local level
local canon
local towers
local creeps
local nodes
local projectiles
local game

function _init()
	cls()

	game = {
		-- game states and menu handlers
		version="V0.23",
		states={"main_menu","in_game","game_over","win_game"},
		current_state="main_menu",
		instructions_open = false,
		ani_menu_tick=0,
		ani_menu_speed=6,
		end_can_continue = false,
		titlexoffset = 5,
		titleyoffset = 5,
		main_menu_selc = 0, --0=easy,1=normal,2=instructions

		draw_upgrade_menu=function(self)
			if(player.x > 104 and player.y == 88) then
				rectfill(8,34,119, 71,0)
				rectfill(12,38,115, 67,4)
				spr(129, 17, 36) --top filler
				spr(129, 25, 36) --top filler
				spr(129, 33, 36) --top filler
				spr(129, 41, 36) --top filler
				spr(129, 49, 36) --top filler
				spr(129, 57, 36) --top filler
				spr(129, 65, 36) --top filler
				spr(129, 73, 36) --top filler
				spr(129, 81, 36) --top filler
				spr(129, 89, 36) --top filler
				spr(129, 97, 36) --top filler
				spr(129, 105, 36) --top filler
				spr(161, 17, 63) --bottom filler
				spr(161, 25, 63) --bottom filler
				spr(161, 33, 63) --bottom filler
				spr(161, 41, 63) --bottom filler
				spr(161, 49, 63) --bottom filler
				spr(161, 57, 63) --bottom filler
				spr(161, 65, 63) --bottom filler
				spr(161, 73, 63) --bottom filler
				spr(161, 81, 63) --bottom filler
				spr(161, 89, 63) --bottom filler
				spr(161, 97, 63) --bottom filler
				spr(161, 105, 63) --bottom filler
				spr(144, 9, 44) --left filler
				spr(144, 9, 52) --left filler
				spr(144, 9, 60) --left filler
				spr(146, 111, 44) --right filler
				spr(146, 111, 52) --right filler
				spr(146, 111, 60) --right filler
				spr(128, 9, 36) --top left
				spr(130, 111, 36) --top right
				spr(160, 9, 63) --bottom left
				spr(162, 111, 63) --bottom right
					-- money indicator
				if(towers.canon_levels[towers.current_tower] >= 10) then
					print("upgraded to max level",23,44,7)
					print("sorry, try again on v0.3",17,59,7)
				elseif(player.money >= (towers.level_price[towers.canon_levels[towers.current_tower]])) then
					print("money: $" .. player.money,45,44,11)
					print("cost to upgrade: $" .. towers.level_price[towers.canon_levels[towers.current_tower]],21,59,11)
				elseif(player.money < (towers.level_price[towers.canon_levels[towers.current_tower]])) then
					print("money: $" .. player.money,45,44,11)
					print("cost to upgrade: $".. towers.level_price[towers.canon_levels[towers.current_tower]],21,59,8)
				end
			end
		end,

		draw_title=function(self)
			spr(192,0+self.titlexoffset,0+self.titleyoffset)
			spr(193,8+self.titlexoffset,0+self.titleyoffset)

			spr(208,0+self.titlexoffset,8+self.titleyoffset)
			spr(209,8+self.titlexoffset,8+self.titleyoffset)
			spr(210,16+self.titlexoffset,8+self.titleyoffset)
			spr(211,24+self.titlexoffset,8+self.titleyoffset)
			spr(212,32+self.titlexoffset,8+self.titleyoffset)
			spr(213,40+self.titlexoffset,8+self.titleyoffset)
			spr(214,48+self.titlexoffset,8+self.titleyoffset)
			spr(215,56+self.titlexoffset,8+self.titleyoffset)

			spr(224,0+self.titlexoffset,16+self.titleyoffset)
			spr(225,8+self.titlexoffset,16+self.titleyoffset)
			spr(226,16+self.titlexoffset,16+self.titleyoffset)
			spr(227,24+self.titlexoffset,16+self.titleyoffset)
			spr(228,32+self.titlexoffset,16+self.titleyoffset)
			spr(229,40+self.titlexoffset,16+self.titleyoffset)
			spr(230,48+self.titlexoffset,16+self.titleyoffset)
			spr(231,56+self.titlexoffset,16+self.titleyoffset)
			spr(232,64+self.titlexoffset,16+self.titleyoffset)
			spr(233,72+self.titlexoffset,16+self.titleyoffset)
			spr(234,80+self.titlexoffset,16+self.titleyoffset)
			spr(235,88+self.titlexoffset,16+self.titleyoffset)
			spr(236,96+self.titlexoffset,16+self.titleyoffset)
			spr(237,104+self.titlexoffset,16+self.titleyoffset)
			spr(238,112+self.titlexoffset,16+self.titleyoffset)

			spr(244,32+self.titlexoffset,24+self.titleyoffset)
			spr(245,40+self.titlexoffset,24+self.titleyoffset)
			spr(246,48+self.titlexoffset,24+self.titleyoffset)
			spr(247,56+self.titlexoffset,24+self.titleyoffset)
			spr(248,64+self.titlexoffset,24+self.titleyoffset)
			spr(249,72+self.titlexoffset,24+self.titleyoffset)
			spr(250,80+self.titlexoffset,24+self.titleyoffset)
			spr(251,88+self.titlexoffset,24+self.titleyoffset)
			spr(252,96+self.titlexoffset,24+self.titleyoffset)
			spr(253,104+self.titlexoffset,24+self.titleyoffset)
			spr(254,112+self.titlexoffset,24+self.titleyoffset)

			spr(200,32+self.titlexoffset,32+self.titleyoffset)
			spr(201,40+self.titlexoffset,32+self.titleyoffset)
			spr(202,48+self.titlexoffset,32+self.titleyoffset)
			spr(203,56+self.titlexoffset,32+self.titleyoffset)
			spr(204,64+self.titlexoffset,32+self.titleyoffset)
			spr(205,72+self.titlexoffset,32+self.titleyoffset)
			spr(206,80+self.titlexoffset,32+self.titleyoffset)
			spr(207,88+self.titlexoffset,32+self.titleyoffset)
			spr(194,96+self.titlexoffset,32+self.titleyoffset)
			spr(195,104+self.titlexoffset,32+self.titleyoffset)
			spr(196,112+self.titlexoffset,32+self.titleyoffset)

			spr(216,32+self.titlexoffset,40+self.titleyoffset)
			spr(217,40+self.titlexoffset,40+self.titleyoffset)
			spr(218,48+self.titlexoffset,40+self.titleyoffset)
			spr(219,56+self.titlexoffset,40+self.titleyoffset)
			spr(220,64+self.titlexoffset,40+self.titleyoffset)
			spr(221,72+self.titlexoffset,40+self.titleyoffset)
			spr(222,80+self.titlexoffset,40+self.titleyoffset)
			spr(223,88+self.titlexoffset,40+self.titleyoffset)
			spr(197,96+self.titlexoffset,40+self.titleyoffset)
			spr(198,104+self.titlexoffset,40+self.titleyoffset)
			spr(199,112+self.titlexoffset,40+self.titleyoffset)
		end,

		draw_main_menu=function(self)
			
			if(self.instructions_open==true) then
				--draw instuctions
				cls()
				--rectfill(0,0,128,128,1)
				print("use ladders to switch towers", 6,8,7)
				spr(69,59,18)
				print("grab ammo from the ammo crate", 5,32,7)
				spr(76,59,42)
				print("load ammo into the cannon", 14,56,7)
				print("manually fire the cannon", 16,64,7)
				spr(73,56,74)
				spr(74,64,74)
				print("use desk to upgrade the tower", 4,88,7)
				spr(89,59,98)

				print("press ❎ to exit instructions", 6, 120,7)
			elseif(self.instructions_open==false) then

				--printh("drawing main menu")
				rectfill(0,0,128,128,0)
				game:draw_title()
				print(game.version,106,5,5)
				print("created for gmtk2018 game jam", 6, 50,7)
				print("updated during wgj week 61", 12, 56,7)

				--draw menu box
				--rect(31,78, 98,109,7)

				--draw menu cursor
				if(self.main_menu_selc==0) then
					spr(131,33,82)
				elseif(self.main_menu_selc==1) then
					spr(131,33,90)
				elseif(self.main_menu_selc==2) then
					spr(131,33,98)
				end
							
				print("easy mode", 44, 84,7)
				print("normal mode", 44, 92,7)
				print("instructions", 44, 100,7)

				print("press ❎ to select", 30, 120,7)

			end
		end, --end draw main menu

		update_main_menu=function(self)
			--printh("updating main menu")

			if(self.instructions_open==true) then
				if btnp(5) then
					--exit instructions
					sfx(2)
					self.instructions_open=false
				end
			elseif(self.main_menu_selc==2) then
				if btnp(5) then
					--show instructions
					sfx(2)
					self.instructions_open=true
				elseif btnp(2) then
					--move cursor up
					self.main_menu_selc=1
					sfx(0)
				elseif btnp(3) then
					--move cursor down
					self.main_menu_selc=0
					sfx(0)
				end--end btn presses
			elseif(self.main_menu_selc==1) then
				
				if btnp(5) then
					--start normal mode
					sfx(2)
					for i=0, 15 do
		 				rectfill(0,0,i*8+8,i*8+8,0)	
		 				flip()
		 			end

					self.current_state=self.states[2]

			 		for i=15,1,-1 do
			 			cls()
						_draw()
		 				rectfill(0,0,i*8+8,i*8+8,0)	
		 				flip()
		 			end
				elseif btnp(2) then
					--move cursor up
					self.main_menu_selc=0
					sfx(0)
				elseif btnp(3) then
					--move cursor down
					self.main_menu_selc=2
					sfx(0)
				end--end btn presses
			elseif(self.main_menu_selc==0) then
				if btnp(5) then
					--start easy mode
					sfx(2)
					towers.ammo_per=20
					player.money += 500
					for i=0, 15 do
		 				rectfill(0,0,i*8+8,i*8+8,0)	
		 				flip()
		 			end

					self.current_state=self.states[2]

			 		for i=15,1,-1 do
			 			cls()
						_draw()
		 				rectfill(0,0,i*8+8,i*8+8,0)	
		 				flip()
		 			end
				elseif btnp(2) then
					--move cursor up
					self.main_menu_selc=2
					sfx(0)
				elseif btnp(3) then
					--move cursor down
					self.main_menu_selc=1
					sfx(0)
				end--end btn presses	
			end

		end,

		draw_game_over=function(self)
			--printh("drawing main menu")
			rectfill(8,34,119, 71,0)
				rectfill(12,38,115, 67,4)
				spr(129, 17, 36) --top filler
				spr(129, 25, 36) --top filler
				spr(129, 33, 36) --top filler
				spr(129, 41, 36) --top filler
				spr(129, 49, 36) --top filler
				spr(129, 57, 36) --top filler
				spr(129, 65, 36) --top filler
				spr(129, 73, 36) --top filler
				spr(129, 81, 36) --top filler
				spr(129, 89, 36) --top filler
				spr(129, 97, 36) --top filler
				spr(129, 105, 36) --top filler
				spr(161, 17, 63) --bottom filler
				spr(161, 25, 63) --bottom filler
				spr(161, 33, 63) --bottom filler
				spr(161, 41, 63) --bottom filler
				spr(161, 49, 63) --bottom filler
				spr(161, 57, 63) --bottom filler
				spr(161, 65, 63) --bottom filler
				spr(161, 73, 63) --bottom filler
				spr(161, 81, 63) --bottom filler
				spr(161, 89, 63) --bottom filler
				spr(161, 97, 63) --bottom filler
				spr(161, 105, 63) --bottom filler
				spr(144, 9, 44) --left filler
				spr(144, 9, 52) --left filler
				spr(144, 9, 60) --left filler
				spr(146, 111, 44) --right filler
				spr(146, 111, 52) --right filler
				spr(146, 111, 60) --right filler
				spr(128, 9, 36) --top left
				spr(130, 111, 36) --top right
				spr(160, 9, 63) --bottom left
				spr(162, 111, 63) --bottom right

				print("game over",44,44,11)
				print("10 enemies have escaped",19,59,11)

				print("press ❎ to restart", 28, 110,7)
		end,

		update_game_over=function(self)
			if btnp(5) then
				sfx(2)
				for i=0, 15 do
	 				rectfill(0,0,i*8+8,i*8+8,0)	
	 				flip()
	 			end

	 			_init()
				self.current_state=self.states[2]

		 		for i=15,1,-1 do
		 			cls()
					_draw()
	 				rectfill(0,0,i*8+8,i*8+8,0)	
	 				flip()
	 			end

			end--end btn4
		end,
		draw_win_game=function(self)
			--printh("drawing main menu")
				rectfill(0,0,127, 127,0)
				rectfill(12,38,115, 67,4)
				spr(129, 17, 36) --top filler
				spr(129, 25, 36) --top filler
				spr(129, 33, 36) --top filler
				spr(129, 41, 36) --top filler
				spr(129, 49, 36) --top filler
				spr(129, 57, 36) --top filler
				spr(129, 65, 36) --top filler
				spr(129, 73, 36) --top filler
				spr(129, 81, 36) --top filler
				spr(129, 89, 36) --top filler
				spr(129, 97, 36) --top filler
				spr(129, 105, 36) --top filler
				spr(161, 17, 63) --bottom filler
				spr(161, 25, 63) --bottom filler
				spr(161, 33, 63) --bottom filler
				spr(161, 41, 63) --bottom filler
				spr(161, 49, 63) --bottom filler
				spr(161, 57, 63) --bottom filler
				spr(161, 65, 63) --bottom filler
				spr(161, 73, 63) --bottom filler
				spr(161, 81, 63) --bottom filler
				spr(161, 89, 63) --bottom filler
				spr(161, 97, 63) --bottom filler
				spr(161, 105, 63) --bottom filler
				spr(144, 9, 44) --left filler
				spr(144, 9, 52) --left filler
				spr(144, 9, 60) --left filler
				spr(146, 111, 44) --right filler
				spr(146, 111, 52) --right filler
				spr(146, 111, 60) --right filler
				spr(128, 9, 36) --top left
				spr(130, 111, 36) --top right
				spr(160, 9, 63) --bottom left
				spr(162, 111, 63) --bottom right


				if(self.ani_menu_tick<self.ani_menu_speed*1) then
					rect(0,0,127, 127,11)
					self.ani_menu_tick+=1
				--	print("you win!",48,43,11)
				--	print("you win!",50,43,11)
				--	print("you win!",48,45,11)
				--	print("you win!",50,45,11)
				--	print("you win!",48,44,11)
				--	print("you win!",50,44,11)
				--	print("you win!",49,43,11)
				--	print("you win!",49,45,11)
				elseif(self.ani_menu_tick<self.ani_menu_speed*2) then
					rect(0,0,127, 127,12)
					self.ani_menu_tick+=1
				--	print("you win!",48,43,12)
				--	print("you win!",50,43,12)
				--	print("you win!",48,45,12)
				--	print("you win!",50,45,12)
				--	print("you win!",48,44,12)
				--	print("you win!",50,44,12)
				--	print("you win!",49,43,12)
				--	print("you win!",49,45,12)
				elseif(self.ani_menu_tick<self.ani_menu_speed*3) then
					rect(0,0,127, 127,13)
					self.ani_menu_tick+=1
				--	print("you win!",48,43,13)
				--	print("you win!",50,43,13)
				--	print("you win!",48,45,13)
				--	print("you win!",50,45,13)
				--	print("you win!",48,44,13)
				--	print("you win!",50,44,13)
				--	print("you win!",49,43,13)
				--	print("you win!",49,45,13)
				elseif(self.ani_menu_tick<self.ani_menu_speed*4) then
					rect(0,0,127, 127,2)
					self.ani_menu_tick+=1
				--	print("you win!",48,43,2)
				--	print("you win!",50,43,2)
				--	print("you win!",48,45,2)
				--	print("you win!",50,45,2)
				--	print("you win!",48,44,2)
				--	print("you win!",50,44,2)
				--	print("you win!",49,43,2)
				--	print("you win!",49,45,2)
				elseif(self.ani_menu_tick<self.ani_menu_speed*5) then
					rect(0,0,127, 127,8)
					self.ani_menu_tick+=1
				--	print("you win!",48,43,8)
				--	print("you win!",50,43,8)
				--	print("you win!",48,45,8)
				--	print("you win!",50,45,8)
				--	print("you win!",48,44,8)
				--	print("you win!",50,44,8)
				--	print("you win!",49,43,8)
				--	print("you win!",49,45,8)
				elseif(self.ani_menu_tick<self.ani_menu_speed*6) then
					rect(0,0,127, 127,9)
					self.ani_menu_tick+=1
				--	print("you win!",48,43,9)
				--	print("you win!",50,43,9)
				--	print("you win!",48,45,9)
				--	print("you win!",50,45,9)
				--	print("you win!",48,44,9)
				--	print("you win!",50,44,9)
				--	print("you win!",49,43,9)
				--	print("you win!",49,45,9)
				elseif(self.ani_menu_tick<self.ani_menu_speed*7) then
					rect(0,0,127, 127,10)
					self.ani_menu_tick+=1
				--	print("you win!",48,43,10)
				--	print("you win!",50,43,10)
				--	print("you win!",48,45,10)
				--	print("you win!",50,45,10)
				--	print("you win!",48,44,10)
				--	print("you win!",50,44,10)
				--	print("you win!",49,43,10)
				--	print("you win!",49,45,10)
					if(self.ani_menu_tick>=self.ani_menu_speed*7) then
						self.ani_menu_tick = 0
						self.end_can_continue = true
					end
				end


				

				print("you win!",49,44,7)
				print("you've cleared 10 waves",18,59,11)

				print("thank you so much for playing!",5,80,7)

				if(self.end_can_continue) then
					print("press ❎ to restart", 28, 110,7)
				end
		end,

		update_win_game=function(self)
			printh("you have won!")
			if btnp(5) then
				sfx(2)
				printh("you have pressed x")
				if(self.end_can_continue) then
					for i=0, 15 do
		 				rectfill(0,0,i*8+8,i*8+8,0)	
		 				flip()
		 			end

		 			_init()
					self.current_state=self.states[2]

			 		for i=15,1,-1 do
			 			cls()
						_draw()
		 				rectfill(0,0,i*8+8,i*8+8,0)	
		 				flip()
		 			end
		 		end
			end--end btn4
		end
	}

	projectiles = {
		queue = {},
		add_to_queue=function(self,x1,y1,x2,y2)
		    local anim = {
		    	coords = {x1,y1,x2,y2},
		    	ticks = 1
		    }
		    add(self.queue, anim)
		end,
		draw=function(self)
			for item in all(self.queue) do
				if(item.ticks == 1) then
					line(item.coords[1]+2,item.coords[2]+2,item.coords[3],item.coords[4],12)
					spr(120,item.coords[1]-1,item.coords[2]-1)
					item.ticks += 1
				elseif(item.ticks == 2) then
					line(item.coords[1]+2,item.coords[2]+2,item.coords[3],item.coords[4],7)
					spr(121,item.coords[1]-1,item.coords[2]-1)
					item.ticks += 1
				elseif(item.ticks == 3) then
					line(item.coords[1]+2,item.coords[2]+2,item.coords[3],item.coords[4],6)
					spr(122,item.coords[1]-1,item.coords[2]-1)
					item.ticks += 1
				elseif(item.ticks > 3) then
					del(self.queue, item)
				end
			end
		end
	}


	creeps = {
		current_wave = 1,
		creeps_arr = {},
		creeps_left = 8,
		creeps_per_wave = {8, 10, 13, 18, 24, 30, 40, 50, 60, 75},
		creeps_wait_per_wave = {80,70,70,70,65,65,65,60,50,45},
		wave_wait_timer = 90,
		wave_wait_setter = 90,
		new_wave_timer = 10,
		starting_new_wave = false,
		starting_new_wave_ticks = 0,
		escaped=0,

		draw_new_wave=function(self)
			if(self.starting_new_wave == true) then
				rectfill(8,34,119, 71,0)
				rectfill(12,38,115, 67,4)
				spr(129, 17, 36) --top filler
				spr(129, 25, 36) --top filler
				spr(129, 33, 36) --top filler
				spr(129, 41, 36) --top filler
				spr(129, 49, 36) --top filler
				spr(129, 57, 36) --top filler
				spr(129, 65, 36) --top filler
				spr(129, 73, 36) --top filler
				spr(129, 81, 36) --top filler
				spr(129, 89, 36) --top filler
				spr(129, 97, 36) --top filler
				spr(129, 105, 36) --top filler
				spr(161, 17, 63) --bottom filler
				spr(161, 25, 63) --bottom filler
				spr(161, 33, 63) --bottom filler
				spr(161, 41, 63) --bottom filler
				spr(161, 49, 63) --bottom filler
				spr(161, 57, 63) --bottom filler
				spr(161, 65, 63) --bottom filler
				spr(161, 73, 63) --bottom filler
				spr(161, 81, 63) --bottom filler
				spr(161, 89, 63) --bottom filler
				spr(161, 97, 63) --bottom filler
				spr(161, 105, 63) --bottom filler
				spr(144, 9, 44) --left filler
				spr(144, 9, 52) --left filler
				spr(144, 9, 60) --left filler
				spr(146, 111, 44) --right filler
				spr(146, 111, 52) --right filler
				spr(146, 111, 60) --right filler
				spr(128, 9, 36) --top left
				spr(130, 111, 36) --top right
				spr(160, 9, 63) --bottom left
				spr(162, 111, 63) --bottom right

				print("wave " .. self.current_wave .. " completed!",32,44,11)
				print("starting new wave in " .. self.new_wave_timer,23,59,11)
			end
		end,

		spawn_wave=function(self)
			if(self.wave_wait_timer > 0) then
				self.wave_wait_timer -= 1				
			elseif (self.wave_wait_timer == 0 and self.creeps_left > 0) then
				self:spawn_creep()
				self.wave_wait_timer = self.wave_wait_setter
			elseif (self.creeps_left <= 0 and #self.creeps_arr <= 0) then
				--start next wave
				self.starting_new_wave = true
				if(self.current_wave == 10) then
					game.current_state = game.states[4]
				elseif(self.starting_new_wave_ticks >= 30 and self.new_wave_timer > 0) then
					self.starting_new_wave_ticks = 0
					self.new_wave_timer -=1
				elseif(self.starting_new_wave_ticks >= 30 and self.new_wave_timer <= 0) then				
					self.starting_new_wave_ticks = 0
					self.new_wave_timer = 10
					self.starting_new_wave = false
					self.current_wave += 1
					self.creeps_left = self.creeps_per_wave[self.current_wave]
					self.wave_wait_setter = self.creeps_wait_per_wave[self.current_wave]
				else
					self.starting_new_wave_ticks+=1
				end

			end	

			for n_creeps in all(creeps.creeps_arr) do
				n_creeps:move()
			end
		end,

		spawn_creep=function(self)
		    self.creeps_left = self.creeps_left - 1
		    if self.creeps_left == 0 then
		      printh('outta creeps!')
		    end

		    local creep = {
		      x=12,
		      y=level.map_y-2,
		      node=1,
		      hp=40,
		      max_hp=40,
		      reward=20,
		      move_speed=8, --higher is slower
		      move_ticks=0,
		      ani_spr=6,
		      ani_frame=0,
		      ani_max_frame=1,
		      ani_tick=0,
		      ani_speed=20,

		      move=function(self)
			        if (self.move_ticks >= self.move_speed) then
				      	self.x=nodes[self.node][1]-2
				      	self.y=nodes[self.node][2]-2
				      	if (self.node < #nodes) then
				      		self.node+=1
				      		self.move_ticks = 0
				      	end
			      	else
			      		self.move_ticks += 1
			        end
		  	  end,

		  	  damaged=function(self,damage)
		  	  	--printh("damaged for :" .. damage)
		  	  	self.hp -= damage
		  	  end
			  }

			  add(self.creeps_arr, creep)
			  -- adjust creep after spawn
			  self.creeps_arr[#self.creeps_arr].move_speed -= flr(self.current_wave/2)
			  if(self.current_wave >= 4 and self.current_wave < 7) then
			  	self.creeps_arr[#self.creeps_arr].ani_spr = 22
			  	self.creeps_arr[#self.creeps_arr].hp += (self.current_wave*2)
			  	self.creeps_arr[#self.creeps_arr].max_hp += (self.current_wave*2)
			  	self.creeps_arr[#self.creeps_arr].reward += (self.current_wave*2)
			  	--printh("wave 4-6")
			  elseif(self.current_wave >= 7) then
			  	self.creeps_arr[#self.creeps_arr].ani_spr = 38
			  	self.creeps_arr[#self.creeps_arr].hp += (self.current_wave*5)
			  	self.creeps_arr[#self.creeps_arr].reward += (self.current_wave*5)
			  	--printh("wave 7-10")
			  end
			  printh("wave:"..self.current_wave..", new creep: speed=" .. self.creeps_arr[#self.creeps_arr].move_speed..", hp=" .. self.creeps_arr[#self.creeps_arr].hp .. "/" .. self.creeps_arr[#self.creeps_arr].hp..", reward = "..self.creeps_arr[#self.creeps_arr].reward)
		end,

		draw=function(self)
			for n_creeps in all(self.creeps_arr) do
				n_creeps.ani_tick+=1
				if(n_creeps.ani_tick>=n_creeps.ani_speed) then
					n_creeps.ani_tick=0
					if(n_creeps.ani_frame >= n_creeps.ani_max_frame) then
						n_creeps.ani_frame = 0
					else
						n_creeps.ani_frame += 1
					end
				end

				pertick=flr(n_creeps.max_hp/5)
				line(n_creeps.x,n_creeps.y-2,n_creeps.x+4,n_creeps.y-2, 8)
				if(n_creeps.hp >= pertick)pset(n_creeps.x,n_creeps.y-2,11)
				if(n_creeps.hp >= pertick*2)pset(n_creeps.x+1,n_creeps.y-2,11)
				if(n_creeps.hp >= pertick*3)pset(n_creeps.x+2,n_creeps.y-2,11)
				if(n_creeps.hp >= pertick*4)pset(n_creeps.x+3,n_creeps.y-2,11)
				if(n_creeps.hp >= (pertick*5)-1)pset(n_creeps.x+4,n_creeps.y-2,11)


				spr(n_creeps.ani_frame+n_creeps.ani_spr, n_creeps.x, n_creeps.y)
				--print(#self.creeps_arr, 50, 50, 11) -- how many creeps in table
				--print(n_creeps.x .. "," .. n_creeps.y, 10,25,11)
				--print(n_creeps.ani_frame .. " , " .. n_creeps.ani_max_frame .. " , " .. n_creeps.ani_tick, 10,35,11)
			end
		end,
		cleanup=function(self) -- clean up
			for n_creep in all(self.creeps_arr) do
				if(n_creep.hp <= 0) then
					del(self.creeps_arr, n_creep)
					player.money += n_creep.reward
				end
				if(n_creep.node >= #nodes) then
					del(self.creeps_arr, n_creep)
					self.escaped += 1
						if(self.escaped==10) then
							game.current_state = game.states[3]
						end
				end	
			end
		end
	}
	
	towers = {
		current_tower=1,
		canon_ammo_ind={0,0,0},
		canon_ammo_sfx=0,
		current_ammo=5,
		canon1_ammo=10,
	 	canon2_ammo=10,
	 	canon3_ammo=10,
	 	canon1_speed=100,
	 	canon2_speed=100,
	 	canon3_speed=100,
	 	canon1_atk=8,
	 	canon2_atk=8,
	 	canon3_atk=8,
	 	canon1_ticks=0,
	 	canon2_ticks=0,
	 	canon3_ticks=0,
	 	canon1_range=30,
	 	canon2_range=30,
	 	canon3_range=30,
	 	canon_levels={1,1,1},
	 	tower_center={{30,49},{63,53},{96,49}},
	 	ammo_per=10,
	 	level_price={80,160,250,450,800,1000,1500, 2000, 2500,3500,5000},
	 	ani_frame=1,
	 	ani_max_frame=5,
	 	ani_tick=0,
	 	ani_speed=10,
	 	ani_spr= {10,11,12,11,10},
	 	locations = {{27, 46},{60, 50},{93, 46}},
	 	dist=function(x1, y1, x2, y2)
			return sqrt(((x1 - x2)^2) + ((y1 - y2)^2))
		end,

		-- upgrade tower
		upgrade_tower=function(self)
			if(self.current_tower==1 and player.money >= (self.level_price[self.canon_levels[1]]) and self.canon_levels[1] <10) then
				printh(towers.canon_levels[towers.current_tower])
				player.money -= self.level_price[self.canon_levels[1]]
				self.canon_levels[1]+=1
				self.canon1_atk += 2
				self.canon1_speed = flr(self.canon1_speed * .8)
				printh(self.canon1_speed)
				sfx(2)
			elseif(self.current_tower==2 and player.money >= (self.level_price[self.canon_levels[2]]) and self.canon_levels[2] <10) then
				player.money -= self.level_price[self.canon_levels[2]]
				self.canon_levels[2]+=1
				self.canon2_atk += 2
				self.canon2_speed = flr(self.canon1_speed * .8)
				printh(self.canon2_speed)
				sfx(2)
			elseif(self.current_tower==3 and player.money >= (self.level_price[self.canon_levels[3]]) and self.canon_levels[3] <10) then
				player.money -= self.level_price[self.canon_levels[3]]
				self.canon_levels[3]+=1
				self.canon3_atk += 2
				self.canon3_speed = flr(self.canon3_speed * .8)
				printh(self.canon3_speed)
				sfx(2)
			end
		end,

	 	tower1_attack=function(self)
		 	--printh("***************** start attack *****************")
		 	shortest = self.canon1_range
		 	target = {hp=-1}
		 	if(#creeps.creeps_arr > 0 and self.canon1_ammo > 0) then
		 		for n_creep in all(creeps.creeps_arr) do
		 			n_dist = self.dist(self.tower_center[1][1],self.tower_center[1][2],n_creep.x, n_creep.y)
		 			if(n_dist < shortest and n_dist < self.canon1_range) then
		 				shortest = n_dist
		 				target = n_creep
		 			end
		 		end
		 		if(target.hp>0) then
		 			sfx(3)
		 			target:damaged(self.canon1_atk)
		 			self.canon1_ammo -= 1
		 			projectiles:add_to_queue(target.x,target.y,towers.tower_center[1][1],towers.tower_center[1][2])
		 		end
		 	end
	 	end,

	 	tower2_attack=function(self)
		 	--printh("***************** start attack *****************")
		 	shortest = self.canon1_range
		 	target = {hp=-1}
		 	if(#creeps.creeps_arr > 0 and self.canon2_ammo > 0) then
		 		for n_creep in all(creeps.creeps_arr) do
		 			n_dist = self.dist(self.tower_center[2][1],self.tower_center[2][2],n_creep.x, n_creep.y)
		 			if(n_dist < shortest and n_dist < self.canon2_range) then
		 				shortest = n_dist
		 				target = n_creep
		 			end
		 		end
		 		if(target.hp>0) then
		 			sfx(3)
		 			target:damaged(self.canon2_atk)
		 			self.canon2_ammo -= 1
		 			projectiles:add_to_queue(target.x,target.y,towers.tower_center[2][1],towers.tower_center[2][2])
		 		end
		 	end
	 	end,

	 	tower3_attack=function(self)
		 	--printh("***************** start attack *****************")
		 	shortest = self.canon3_range
		 	target = {hp=-1}
		 	if(#creeps.creeps_arr > 0 and self.canon3_ammo > 0) then
		 		for n_creep in all(creeps.creeps_arr) do
		 			n_dist = self.dist(self.tower_center[3][1],self.tower_center[3][2],n_creep.x, n_creep.y)
		 			if(n_dist < shortest and n_dist < self.canon3_range) then
		 				shortest = n_dist
		 				target = n_creep
		 			end
		 		end
		 		if(target.hp>0) then
		 			sfx(3)
		 			target:damaged(self.canon3_atk)
		 			self.canon3_ammo -= 1
		 			projectiles:add_to_queue(target.x,target.y,towers.tower_center[3][1],towers.tower_center[3][2])
		 		end
		 	end
	 	end,

	 	tower_attacks=function(self)
	 		if(self.canon1_speed<=self.canon1_ticks) then
	 			self:tower1_attack()
	 			self.canon1_ticks = 0
	 		elseif(self.canon1_speed > self.canon1_ticks) then
	 			self.canon1_ticks += 1
	 		end
	 		if(self.canon2_speed<=self.canon2_ticks) then
	 			self:tower2_attack()
	 			self.canon2_ticks = 0
	 		elseif(self.canon2_speed > self.canon2_ticks) then
	 			self.canon2_ticks += 1
	 		end
	 		if(self.canon3_speed<=self.canon3_ticks) then
	 			self:tower3_attack()
	 			self.canon3_ticks = 0
	 		elseif(self.canon3_speed > self.canon3_ticks) then
	 			self.canon3_ticks += 1
	 		end
	 	end,

	 	switch_tower=function(self)
	 		player.can_move = false
	 		
	 		for i=0, 15 do
	 			rectfill(0,0,i*8+8,i*8+8,0)	
	 			flip()
	 		end

		 	if(self.current_tower == 3) then
		 		self.current_tower = 1
		 	else	
		 		self.current_tower += 1
		 	end
		 	player.y = 120
		 	for i=15,1,-1 do
		 		cls()
				_draw()
	 			rectfill(0,0,i*8+8,i*8+8,0)	
	 			flip()
	 		end
		 	player.can_move=true
		end,
		draw=function(self)
			--find ammo			
			if(self.current_tower==1) then
				self.current_ammo = self.canon1_ammo
			elseif(self.current_tower==2) then
				self.current_ammo = self.canon2_ammo
			elseif(self.current_tower==3) then
				self.current_ammo = self.canon3_ammo
			end

			--draw hud
			rectfill(9,9,82,15,4)
			print("current tower: " .. self.current_tower,13,10,9)
			rectfill(85,9,118,15,4)
			if(self.current_ammo<100)then
				print("ammo: " .. self.current_ammo,86,10,9)
			elseif(self.current_ammo>=100)then
				print("ammo:" .. self.current_ammo,86,10,9)
				
			end
			rectfill(9,27,43,33,4)
			print("wave: " .. creeps.current_wave,11,28,9)
			rectfill(46,18,82,33,4)
			print("escaped: ",50,19,9)
			print(creeps.escaped.."/10",58,28,9)
			if(self.current_tower==1)then
				rectfill(85,18,118,24,4)
				print("atk: " .. self.canon1_atk,87,19,9)
				rectfill(85,27,118,33,4)
				print("spd: " .. flr((200-self.canon1_speed)/10),87,28,9)
				rectfill(9,18,43,24,4)
				print("lvl: " .. self.canon_levels[1],11,19,9)
			end
			if(self.current_tower==2)then
				rectfill(85,18,118,24,4)
				print("atk: " .. self.canon2_atk,89,19,9)
				rectfill(85,27,118,33,4)
				print("spd: " .. flr((200-self.canon2_speed)/10),89,28,9)
				rectfill(9,18,43,24,4)
				print("lvl: " .. self.canon_levels[2],11,19,9)
			end
			if(self.current_tower==3)then
				rectfill(85,18,118,24,4)
				print("atk: " .. self.canon3_atk,89,19,9)
				rectfill(85,27,118,33,4)
				print("spd: " .. flr((200-self.canon3_speed)/10),89,28,9)
				rectfill(9,18,43,24,4)
				print("lvl: " .. self.canon_levels[3],11,19,9)
			end
			--draw tower ammo indicator
			if(self.canon1_ammo <= 0) then
				self.canon_ammo_ind[1] += 1
				if(self.canon_ammo_ind[1] >= 50) then
					spr(27,self.tower_center[1][1]-3,self.tower_center[1][2]-10)
					self.canon_ammo_ind[1] = 0
				elseif(self.canon_ammo_ind[1] >= 25) then
					spr(27,self.tower_center[1][1]-3,self.tower_center[1][2]-10)
					self.canon_ammo_ind[1] +=1
				elseif(self.canon_ammo_ind[1] < 25) then
					spr(28,self.tower_center[1][1]-3,self.tower_center[1][2]-10)
					self.canon_ammo_ind[1] +=1				
				end
			end

			if(self.canon2_ammo <= 0) then
				self.canon_ammo_ind[2] += 1
				if(self.canon_ammo_ind[2] >= 50) then
					spr(27,self.tower_center[2][1]-3,self.tower_center[2][2]+7)
					self.canon_ammo_ind[2] = 0
				elseif(self.canon_ammo_ind[2] >= 25) then
					spr(27,self.tower_center[2][1]-3,self.tower_center[2][2]+7)
					self.canon_ammo_ind[2] +=1
				elseif(self.canon_ammo_ind[2] < 25) then
					spr(28,self.tower_center[2][1]-3,self.tower_center[2][2]+7)
					self.canon_ammo_ind[2] +=1				
				end
			end

			if(self.canon3_ammo <= 0) then
				self.canon_ammo_ind[3] += 1
				if(self.canon_ammo_ind[3] >= 50) then
					spr(27,self.tower_center[3][1]-3,self.tower_center[3][2]-10)
					self.canon_ammo_ind[3] = 0
				elseif(self.canon_ammo_ind[3] >= 25) then
					spr(27,self.tower_center[3][1]-3,self.tower_center[3][2]-10)
					self.canon_ammo_ind[3] +=1
				elseif(self.canon_ammo_ind[3] < 25) then
					spr(28,self.tower_center[3][1]-3,self.tower_center[3][2]-10)
					self.canon_ammo_ind[3] +=1				
				end
			end

			if((self.canon1_ammo <= 0 or self.canon2_ammo <= 0 or self.canon3_ammo <= 0) and self.canon_ammo_sfx == 0) then
				sfx(4)
				self.canon_ammo_sfx += 1
				printh("play canon_ammo_sfx : "..self.canon_ammo_sfx)
			elseif((self.canon1_ammo <= 0 or self.canon2_ammo <= 0 or self.canon3_ammo <= 0) and self.canon_ammo_sfx < 30) then
				self.canon_ammo_sfx += 1
				printh("tick canon_ammo_sfx : "..self.canon_ammo_sfx)
			elseif((self.canon1_ammo <= 0 or self.canon2_ammo <= 0 or self.canon3_ammo <= 0) and self.canon_ammo_sfx >= 30) then
				self.canon_ammo_sfx = 0
				printh("reset canon_ammo_sfx : "..self.canon_ammo_sfx)
			else
				self.canon_ammo_sfx = 0
				printh("else!!!")
			end

			--draw tower
			spr(10, 27, 46)
			spr(10, 60, 50)
			spr(10, 93, 46)
			-- animate cur tower
			self.ani_tick += 1
			if(self.ani_tick >= self.ani_speed) then
				if(self.ani_frame >= self.ani_max_frame) then
					self.ani_frame = 1
				else
					self.ani_frame +=1
				end
				self.ani_tick = 0
			end
			spr(self.ani_spr[self.ani_frame],self.locations[self.current_tower][1],self.locations[self.current_tower][2])
		end
	}

 canon = {
 	ani_frame=0,
 	ani_tick=0,
 	ani_speed=5,
 	firing=false,
 	x=8,
 	y=88,
 	draw=function(self)
 		spr(73,self.x,self.y)
 		spr(74,self.x+8,self.y)
 	end
 }

 player = {
  x = 16,
  y = 112,
  x_vol = 0,
  y_vol = 0,
  can_move = true,
  ani_direction = 1,--1=right,17=left,33=ladder
  ani_frame = 0,
  ani_tick = 0,
  ani_speed =15,
  move_speed = 1,
  move_ticks = 0,
  max_speed = 1,
  money = 0,
  has_ammo = false,
  on_ladder = false,
  draw=function(self)
  	self.ani_tick+=1
  	if (self.ani_frame == 0 and self.ani_tick == self.ani_speed) then
       spr(self.ani_direction,self.x,self.y)
       self.ani_frame = 1
       self.ani_tick = 0
   elseif (self.ani_frame == 1 and self.ani_tick == self.ani_speed) then
       spr(self.ani_direction+1,self.x,self.y)
       self.ani_frame = 0
       self.ani_tick = 0
   elseif (self.ani_frame == 0 and self.ani_tick < self.ani_speed) then
       spr(self.ani_direction,self.x,self.y)
   elseif (self.ani_frame == 1 and self.ani_tick < self.ani_speed) then
       spr(self.ani_direction+1,self.x,self.y)
   end
   	if(self.has_ammo and self.on_ladder==false)spr(26,self.x,self.y-8)
  end,
  slow_x=function(self)
  	if(self.x_vol>0) then
  		self.x_vol-=1
  	end
  	self.move_ticks=0
  	self.max_speed=1
  end,
  speedup_x=function(self,val)
  	print(val,40,40,11)
  	if(self.move_ticks > 5)self.max_speed=1
  	if(self.move_ticks > 10)self.max_speed=2
  	if(val > 0 and (val+self.x_vol)<=self.max_speed) then
  		self.x_vol+=val
  		self.x+=self.x_vol
  	elseif(val < 0 and (val+self.x_vol)>=(self.max_speed*-1)) then
  		self.x_vol+=val
  		self.x+=self.x_vol
  	elseif(val > 0) then
   	self.x+=self.x_vol
  	elseif(val < 0) then
  		self.x+=self.x_vol
  	end
  end,
  slow_y=function(self)
  	if(self.y_vol>0) then
  		self.y_vol-=1
  	end
  end,
 	update=function(self)
  		if(self.can_move==true) then
  			--movement
			if btn(1) then
				self.toggle_ammo = false
				self.on_ladder = false
				self.speedup_x(self,1)
				self.ani_direction=1
				self.move_ticks+=1
				if(self.has_ammo==true)self.ani_direction+=3
			elseif btn(0) then
				self.toggle_ammo = false
				self.on_ladder = false
				self:speedup_x(-1)
				self.ani_direction=17
				self.move_ticks+=1
				if(self.has_ammo==true)self.ani_direction+=3
			else
				self:slow_x()
			end

			if((self.x >= 8 and self.x <= 10 and self.y >= 112) or (self.x >= 62 and self.x <= 66 and self.y >= 88 and self.y <= 112)) then
				if btn(3) then
					self.on_ladder = true
					self.y+=self.move_speed
					self.ani_direction=33
					if(self.has_ammo==true)self.ani_direction+=3
				elseif btn(2) then
					self.on_ladder = true
					self.y-=self.move_speed
					self.ani_direction=33
					if(self.has_ammo==true)self.ani_direction+=3
				else
					self:slow_y()
				end
			end
			--keypresses keys
			if btnp(4) then

			end--end btn4
			if btnp(5) then
				if(self.x > 104 and self.y == 112 and self.toggle_ammo == false and self.has_ammo == false) then
					self.has_ammo=true
					self.ani_direction+=3
					self.toggle_ammo = true
					sfx(0)

				elseif(self.x < 24 and self.y == 88 and self.toggle_ammo == false and self.has_ammo == true) then
					self.has_ammo=false
					self.ani_direction-=3
					self.toggle_ammo = true
					if(towers.current_tower == 1) then
						towers.canon1_ammo += towers.ammo_per
					elseif(towers.current_tower == 2) then
						towers.canon2_ammo += towers.ammo_per
					elseif(towers.current_tower == 3) then
						towers.canon3_ammo += towers.ammo_per
					end
					sfx(1)
				
				--fire cannons
				elseif(self.x < 24 and self.y == 88 and self.has_ammo == false) then
					if(towers.current_tower == 1) then
						towers:tower1_attack()
					elseif(towers.current_tower == 2) then
						towers:tower2_attack()
					elseif(towers.current_tower == 3) then
						towers:tower3_attack()
					end
				end
				if(player.x > 104 and player.y == 88) then
					towers:upgrade_tower()
				end
			end --end btn5
		end
	end,
 }


	level = {
	
			map_color = 5,
			map_y = 42,
	
			draw=function(self)
    	--add edges/floors
    	for i=0,120,8 do
    		spr(65,0,i)
    		spr(65,120,i)
    		spr(64,i,120)
    		spr(64,i,0)
    		spr(64,i,96)
    		spr(64,i,72)
    	end
    	--add corners/intersects
    	spr(66,0,0,1,1,false,true)
    	spr(66,0,120)
    	spr(66,120,0,1,1,true,true)
    	spr(66,120,120,1,1,true,false)
    	--add intersects
     spr(67,0,96)
     spr(67,0,72)
     spr(67,120,96,1,1,true,false)
     spr(67,120,72,1,1,true,false)
     --add ladders
     rectfill(8,120,15,127,0)
     rectfill(64,96,71,103,0)
     spr(68,8,120)
     spr(68,64,96)
     spr(69,64,104)
     spr(69,64,112)
     --desk
     spr(89,112,88)
     --ammo
     spr(76, 112,112)
     --map
     line(14,0+self.map_y,14,19+self.map_y,self.map_color)
     line(14,19+self.map_y,47,19+self.map_y,self.map_color)
     line(47,19+self.map_y,47,0+self.map_y,self.map_color)
     line(47,0+self.map_y,80,0+self.map_y,self.map_color)
     line(80,0+self.map_y,80,19+self.map_y,self.map_color)
     line(80,19+self.map_y,113,19+self.map_y,self.map_color)
     line(113,19+self.map_y,113,0+self.map_y,self.map_color)
     --indicators
    if(player.x > 104 and player.y == 112 and player.has_ammo==false) then
		print("❎",112,106,6) -- ammo
	elseif(player.x < 24 and player.y == 88 and player.has_ammo==true) then
		print("❎",16,82,6) -- cannon load ind
	elseif(player.x < 24 and player.y == 88) then
		if(towers.current_tower == 1 and towers.canon1_ammo > 0) then
			print("❎",16,82,8) -- cannon shoot ind
		elseif(towers.current_tower == 2 and towers.canon2_ammo > 0) then
			print("❎",16,82,8) -- cannon shoot ind
		elseif(towers.current_tower == 3 and towers.canon3_ammo > 0) then
			print("❎",16,82,8) -- cannon shoot ind
		end

		
	elseif(player.x > 104 and player.y == 88 and player.money > towers.level_price[towers.current_tower]) then
		print("❎",112,82,6) --desk
	elseif(player.x < 11 and player.y == 112) then
		print("⬇️",9,105,6) -- change tower
	end
     

    end,
  	collision=function(self)
  		--check sides of walls
  			if(player.x < 8) player.x=8
  			if(player.x > 112) player.x=112
  		--check floors
   		if(player.y > 88 and player.y > 112 and player.x > 10) player.y=112
   		if(player.y < 112 and player.y > 110 and player.x < 62) player.y=112
   		if(player.y < 112 and player.y > 110 and player.x > 66) player.y=112
  		if(player.y < 112 and player.y > 88 and player.x < 62) player.y=88
  		if(player.y < 112 and player.y > 88 and player.x > 66) player.y=88
		if(player.y < 88) player.y=88
		if((player.x < 8 or player.x > 8)and player.y > 112) player.x=8 -- ladder 1
		if((player.x < 64 or player.x > 64)and player.y < 112 and player.y > 88) player.x=64 --ladder2
		--cannon, desk, ammo
		if(player.y < 90 and player.y > 86 and player.x <= 23) player.x=23 --canon
		if(player.y < 90 and player.y > 86 and player.x >= 106) player.x=106 --desk
		if(player.y < 114 and player.y > 110 and player.x >= 105) player.x=105
		--event
		if(player.y>128) towers:switch_tower()
  	end
  	
  }

	nodes={}
	--setup nodes
    for i=0+level.map_y,19+level.map_y do
		add(nodes,{14,i})
	end
	for i=14,47 do
		add(nodes,{i,19+level.map_y})
	end
	for i=19+level.map_y,0+level.map_y,-1 do
		add(nodes,{47,i})
	end
	for i=47,80 do
		add(nodes,{i,0+level.map_y})
	end
	for i=0+level.map_y,19+level.map_y do
		add(nodes,{80,i})
	end
	for i=80,113 do
		add(nodes,{i,19+level.map_y})
	end
	for i=19+level.map_y,0+level.map_y,-1 do
		add(nodes,{113,i})
	end
	

end --end init


function _update()

	if(game.current_state==game.states[1]) then
		game:update_main_menu()

	elseif(game.current_state==game.states[2]) then
		player:update()
		level:collision()
		creeps:spawn_wave()
		creeps:cleanup()
		towers:tower_attacks()
	elseif(game.current_state==game.states[3]) then
		game:update_game_over()
	elseif(game.current_state==game.states[4]) then
		game:update_win_game()
	end
end

function _draw()

	if(game.current_state==game.states[1]) then
		cls()
		game:draw_main_menu()
	elseif(game.current_state==game.states[2]) then
		cls()
		--printh("player(x,y) : " .. player.x .. "," .. player.y)
		level:draw()
		canon:draw()
		player:draw()
		creeps:draw()
		projectiles:draw()
		towers:draw()
		creeps:draw_new_wave()
		game:draw_upgrade_menu()

	elseif(game.current_state==game.states[3]) then
		cls()
		game:draw_game_over()
	elseif(game.current_state==game.states[4]) then
		cls()
		game:draw_win_game()
	end
	
end
__gfx__
000000000044440000444400000000000f4444f00f4444f001310000000000000000000000000000505050505050505050505050000000000000000000000000
000000000041f1000041f100000000000241f1200241f12003330000013100000000000000000000555555505555555055555550000000000000000000000000
0070070002ffff2002ffff200000000002ffff2002ffff2003330000333300000000000000000000055555000555550085555580000000000000000000000000
0007700020222220022222200000000000222200002222003333000033330000000000000000000000565000005a5000085a5800000000000000000000000000
00077000f02222f00f22220f0000000000222200002222003333000033330000000000000000000000565000005a5000085a5800000000000000000000000000
00700700001111000011110000000000001111000011110000000000000000000000000000000000005550000055500008555800000000000000000000000000
00000000011001000010010000000000011001000010010000000000000000000000000000000000055555000555550085555580000000000000000000000000
00000000040004000040400000000000040004000040400000000000000000000000000000000000555555505555555055555550000000000000000000000000
000000000044440000444400000000000f4444f00f4444f001310000013100000000000000000000000000002022220050555500000000000000000000000000
00000000001f1400001f140000000000021f1420021f142003330000033300000000000000000000000000002022222050555550000000000000000000000000
0000000002ffff2002ffff200000000002ffff2002ffff2034443000444430000000000000000000000000002022222050555550000000000000000000000000
00000000022222020222222000000000002222000022220003440000344300000000000000000000000000002022222050555550000000000000000000000000
000000000f22220ff02222f0000000000022220000222200000300000300000000000000000000000006d0002022220050555500000000000000000000000000
00000000001111000011110000000000001111000011110000000000000000000000000000000000006d55000000000000000000000000000000000000000000
0000000000100110001001000000000000100110001001000000000000000000000000000000000000d555000000000000000000000000000000000000000000
00000000004000400004040000000000004000400004040000000000000000000000000000000000000550000000000000000000000000000000000000000000
00000000004444f00f44440000000000004444f00044440001410000014100000000000000000000000000000000000000000000000000000000000000000000
000000000f444420024444f00000000000444420004444f004440000044400000000000000000000000000000000000000000000000000000000000000000000
0000000002ffff2002ffff200000000022ffff2000ffff2045554000555540000000000000000000000000000000000000000000000000000000000000000000
00000000022222000022222000000000fd2222002222222004550000455400000000000000000000000000000000000000000000000000000000000000000000
000000000022220000222200000000000d222200fd22220000040000040000000000000000000000000000000000000000000000000000000000000000000000
00000000001111000011110000000000001111000d11110000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001004000040010000000000001004000040010000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000004000000000040000000000004000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
555555555ddd5d555d5dd5d55ddd5dd554444445044444400000000000000000a099090055555555555555000000000000000000000000000000000000000000
dd5ddddd5d555dd55dd5dddd5ddddddd5400004504000040000000000000000009099a9955555555555555500000000000dd1000000000000000000000000000
dd5ddd5d5dddddd55dddd5d555dd55dd5444444504444440000000000000000000a9aa9a555555555555555500000000d1d1dd10000000000000000000000000
ddd55d55555d5d555d55dd5d5ddddddd54000045040000400000000000000000009999a955555555555555550000000022222222000000000000000000000000
5dddd5dd5ddd5dd55ddddddd5d5ddd5d54444445044444400000000000000000a009999a55555555555555550000000024424442000000000000000000000000
555d5d5d5d5d55d55d5d5dd55d5ddddd54000045040000400000000000000000090099a955555544444455500000000042442424000000000000000000000000
dddddd5d5d5dddd55ddddddd5dddd5dd544444450444444000000000000000000009999055555444444445000000000042424424000000000000000000000000
5555555555ddd5d5555555555d5dddd554000045040000400000000000000000a090990000004444444444000000000042444244000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000a0a0a0000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000900a9aa900000044000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000a0090a9a00004444000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000a9a9a900444444000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000a00a9a9a44444444000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000a090a900500050000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000a00a09000500050000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000a00a0000500050000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000009900000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000a00a00000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000090900000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000009000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000008000090008000000a00000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000800a0000800a000009000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000009998000099990a00000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000899a900009090000000000a0000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000009aaa9880000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000099999009909990090000090000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000080999a0008099a08000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000008000000800a00009000000000000000000000000000000000000000000000
44444444444444444444444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44aaaaaaaaaaaaaaaaaaaa4400007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4aa4444444444444444449a400007770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4a444444444444444444449400000777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4a444444444444444444449400000777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4a444444444444444444449400007770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4a444444444444444444449400007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4a444444444444444444449400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4a444444444444444444449400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4a444444444444444444449400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4a444444444444444444449400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4a444444444444444444449400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4a444444444444444444449400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4a444444444444444444449400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4a444444444444444444449400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4a444444444444444444449400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4a444444444444444444449400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4a444444444444444444449400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4a444444444444444444449400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4a444444444444444444449400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4a444444444444444444449400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4a9444444444444444444a9400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44a99999999999999999994400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444444444444444444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000888000000000088800008888000000088888800000000000008808888800880088008880088000088088088008808880000000000088
00077777777777000000088000088800088800000000000000000000000000000000088800888800880088000888088000088088088888008880000000000880
07777777777700000000088000880800088800000000000000000000000000000000088800888000880088000088088000088088008888008880000000000800
07777777777700000000088000880000088000000000000000000000000000000000088800888000880088000088008800880088008888008880000000000880
00000077000000000000888000880000088000000000000000000000000000000000088800888000088088000088008800880088000888008880000000000880
00000777000000000000880000880008888000000000000000000000000000000000088800888000088088000088008808800088000888008880000000000880
00000777000000000088880000880880088000000000000000000000000000000000088800088000088088000088808808000088000888008800000000000880
00000777000000008888800000088888888000000000000000000000000000000000088800088000088000000008808888000088000888008888880000000088
00000777000000770000000000000007000000077770000000770000700000000000088800088800008800000008808888000088000088008888888888800008
00000777000077777700000077007007700007777777700077770777700000000000080000088800008800000008808880000088000000000000888800000000
00000777000077777777000077707707700077777777700077770777770000000000080000000800008800000008808000000000000000000000000000000000
00000777000000000777000077707707700077000077700007777707770000000000080000000800008800000008000000000000000000000000000000000000
00000777000077000777700077707707700077000077700007777707770000000000000000000000008880000000000000000000000000000000000000000000
00000777000077000007700077707707700077000077000007770007700000000000000000000000000880000000000000000000000000000000000000000000
00000777000777000007700007707707700077007770000007770007000000000000000000000000000880000000000000000000000000000000000000000000
00000777000777000007700007707707700077077770000007770000000000000000000000000000000080000000000000000000000000000000000000000000
00000777000777000007700007707707700077000000000007700000000000000000000000000000000000000000000000000000000000000000000000000000
00000777000077700007700007707777700077700000080007700000000000000000000000000000000000000000000000000000000000000000000000000000
00000777000077700077700007777777700077700000080007700008000000000000000000000088000000000000000000000000000000000000000000000000
00000777000077777777000007770777700077777777088007700008000080000000000000000088000008888880088888880000000000000000000000000000
00000770000000777777000000770077000007777777088007770008000088800000000880000088088888888800880008880000000000000000000000000000
00000770000000777700000000770007000000778800088007770008000088880000000880000088088888000000880000008800000088888000000000000000
00000000000000000000000000000000000000088800088000000088800088088000000880000088088000000000880000000800000888888880000000000000
00000000000000000000000000000000000000008800088800000088800088088000000880000088088000000000880000000800008880000880000000000000
00000000000000000000000000000000000000088800088800000080880088008800000880000088088000000000880000008000008800000080000000000000
00000000000000000000000000000000000000088800088800000880880088000880000880000880088000000000088000000000008800000080000000000000
00000000000000000000000000000000000000088800088800000880880088000088000880000880088000000000088880000000008800000080000000000000
00000000000000000000000000000000000000888880088880000880880008000088800888000880088000000000000888000000008880000000000000000000
00000000000000000000000000000000000000888880088880000880888008800008800888000880088000000000000088800000008888000000000000000000
00000000000000000000000000000000000000888880888880008880088008800008800888000880088888888800000008880000000888800000000000000000
00000000000000000000000000000000000000880880888880008888088008800000800888000880088888088880000000888000000000888000000000000000
00000000000000000000000000000000000000880880888088008808888008800000808808800880888000000000000000088880000000088880000000000000
__label__
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
5ddddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5dddddddddddd5
5d5d5dd5dd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5d5dd5d5d5
5dddddddddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddddddd5
5d55dd5d5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5ddd5dd55d5
5dddd5d5555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d5d5dddd5
5dd5dddddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddd5dd5
5d5dd5d555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555d5dd5d5
5ddd5d5500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005ddd5d55
5d555dd504444444444444444444444444444444444444444444444444444444444444444444444444400444444444444444444444444444444444405d555dd5
5dddddd504444499494949994999499949944999444449994499494949994999444444444994444444400499949994999449944444444499944444405dddddd5
555d5d550444494449494949494949444949449444444494494949494944494944944444449444444440049494999499949494494444444494444440555d5d55
5ddd5dd504444944494949944994499449494494444444944949494949944994444444444494444444400499949494949494944444444499944444405ddd5dd5
5d5d55d504444944494949494949494449494494444444944949499949444949449444444494444444400494949494949494944944444494444444405d5d55d5
5d5dddd504444499449949494949499949494494444444944994499949994949444444444999444444400494949494949499444444444499944444405d5dddd5
55ddd5d5044444444444444444444444444444444444444444444444444444444444444444444444444004444444444444444444444444444444444055ddd5d5
5ddd5d5500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005ddd5d55
5d555dd500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005d555dd5
5dddddd504444444444444444444444444444444444400444444444444444444444444444444444444400444444444444444444444444444444444405dddddd5
555d5d550449444949494444444444499444444444440044449994499449949994999499949944444440044999499949494444444449444444444440555d5d55
5ddd5dd504494449494944449444444494444444444400444494449444944494949494944494944944400449494494494944944444494444444444405ddd5dd5
5d5d55d504494449494944444444444494444444444400444499449994944499949994994494944444400449994494499444444444499944444444405d5d55d5
5d5dddd504494449994944449444444494444444444400444494444494944494949444944494944944400449494494494944944444494944444444405d5dddd5
55ddd5d5044999449449994444444449994444444444004444999499444994949494449994999444444004494944944949444444444999444444444055ddd5d5
5ddd5d5504444444444444444444444444444444444400444444444444444444444444444444444444400444444444444444444444444444444444405ddd5d55
5d555dd500000000000000000000000000000000000000444444444444444444444444444444444444400000000000000000000000000000000000005d555dd5
5dddddd500000000000000000000000000000000000000444444444444444444444444444444444444400000000000000000000000000000000000005dddddd5
555d5d550444444444444444444444444444444444440044444444444444444444444444444444444440044444444444444444444444444444444440555d5d55
5ddd5dd504494949994949499944444444499444444400444444444444999444949944999444444444400444994999499444444444499944444444405ddd5dd5
5d5d55d504494949494949494444944444449444444400444444444444949449444944949444444444400449444949494944944444494444444444405d5d55d5
5d5dddd504494949994949499444444444449444444400444444444444949449444944949444444444400449994999494944444444499944444444405d5dddd5
55ddd5d5044999494949994944449444444494444444004444444444449494494449449494444444444004444949444949449444444449444444444055ddd5d5
5ddd5d5504499949494494499944444444499944444400444444444444999494449994999444444444400449944944499944444444499944444444405ddd5d55
5d555dd504444444444444444444444444444444444400444444444444444444444444444444444444400444444444444444444444444444444444405d555dd5
5dddddd500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005dddddd5
555d5d550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000555d5d55
5ddd5dd500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005ddd5dd5
5d5d55d500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005d5d55d5
5d5dddd5000000000000000000000000000000000000000bbb88000bbb880000000000000000000000000000000000000000000000000000000000005d5dddd5
55ddd5d5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055ddd5d5
5ddd5d5500000000000000000000000000000000000000001310000013100000000000000000000000000000000000000000000000000000000000005ddd5d55
5d555dd500000000000000000000000000000000000000003330000033300000000000000000000000000000000000000000000000000000000000005d555dd5
5dddddd500000050000000000000000000000000000000044443555344435555555555555555555550000000000000000000000000000000050000005dddddd5
555d5d550000005000000000000000000000000000000bbb883000003440000000000000000000005000000000000000000000000000000005000000555d5d55
5ddd5dd500000050000000000000000000000000000000053000000000300000000000000000000050000000000000000000000000000000050000005ddd5dd5
5d5d55d500000050000000000000000000000000000000131000000000000000000000000000000050000000000000000000000000000000050000005d5d55d5
5d5dddd500000050000000000005050505000000000000333000000000000000000000000000000050000000000005050505000000000000050000005d5dddd5
55ddd5d5000000500000000000055555550000000000034443000000000000000000000000000000500000000000055555550000000000000500000055ddd5d5
5ddd5d5500000050000000000008555558000000000000344000000000000000000000000000000050000000000000555550000000000000050000005ddd5d55
5d555dd50000005000000000000085a580000000000000053000000000000000000000000000000050000000000000056500000000000000050000005d555dd5
5dddddd50000005000000000000085a580000000000000050000000000005050505000000000000050000000000000056500000000000000050000005dddddd5
555d5d550000005000000000000085558000000000000005000000000000555555500000000000005000000000000005550000000000000005000000555d5d55
5ddd5dd50000005000000000000855555800000000000bbbbb00000000000555550000000000000050000000000000555550000000000000050000005ddd5dd5
5d5d55d500000050000000000005555555000000000000050000000000000056500000000000000050000000000005555555000000000000050000005d5d55d5
5d5dddd500000050000000000000000000000000000000131000000000000056500000000000000050000000000000000000000000000000050000005d5dddd5
55ddd5d5000000500000000000000000000000000000003330000000000000555000000000000000500000000000000000000000000000000500000055ddd5d5
5ddd5d5500000050000000000000000000000000000003444300000000000555550000000000000050000000000000000000000000000000050000005ddd5d55
5d555dd5000000500000000000000000000bbb88000bbb884000000000005555555000000000000050000000000000000000000000000000050000005d555dd5
5dddddd500000050000000000000000000000000000000053000000000000000000000000000000050000000000000000000000000000000050000005dddddd5
555d5d550000005000000000000000000000131000001315000000000000000000000000000000005000000000000000000000000000000005000000555d5d55
5ddd5dd500000050000000000000000000003330000033350000000000000000000000000000000050000000000000000000000000000000050000005ddd5dd5
5d5d55d500000055555555555555555555544443555444430000000000000000000000000000000055555555555555555555555555555555550000005d5d55d5
5d5dddd500000000000000000000000000034430000344300000000000000000000000000000000000000000000000000000000000000000000000005d5dddd5
55ddd5d5000000000000000000000000000030000000300000000000000000000000000000000000000000000000000000000000000000000000000055ddd5d5
5ddd5d5500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005ddd5d55
5d555dd500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005d555dd5
5dddddd500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005dddddd5
555d5d550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000555d5d55
5ddd5dd500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005ddd5dd5
5d5d55d500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005d5d55d5
5d5dddd500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005d5dddd5
55ddd5d5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055ddd5d5
5ddd5dd555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555dd5ddd5
5ddddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5dddddddddddd5
55dd55dddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd55dd55
5dddddddddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddddddd5
5d5ddd5d5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5ddd5ddd5d5
5d5ddddd555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5dddddd5d5
5dddd5dddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddd5dddd5
5d5dddd555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555dddd5d5
5ddd5d5500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005ddd5d55
5d555dd500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005d555dd5
5dddddd500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005dddddd5
555d5d550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000555d5d55
5ddd5dd500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005ddd5dd5
5d5d55d500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005d5d55d5
5d5dddd500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005d5dddd5
55ddd5d5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055ddd5d5
5ddd5d5555555555555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005ddd5d55
5d555dd555555555555555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000445d555dd5
5dddddd555555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044445dddddd5
555d5d555555555555555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000444444555d5d55
5ddd5dd555555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000444444445ddd5dd5
5d5d55d555555544444455500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005000505d5d55d5
5d5dddd555555444444445000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005000505d5dddd5
55ddd5d5000044444444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050005055ddd5d5
5ddd5dd555555555555555555555555555555555555555555555555555555555544444455555555555555555555555555555555555555555555555555dd5ddd5
5ddddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddd54000045dd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5dddddddddddd5
55dd55dddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5d54444445dd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd55dd55
5dddddddddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d5554000045ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddddddd5
5d5ddd5d5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd544444455dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5ddd5ddd5d5
5d5ddddd555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d54000045555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5dddddd5d5
5dddd5dddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5d54444445dddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddd5dddd5
5d5dddd555555555555555555555555555555555555555555555555555555555540000455555555555555555555555555555555555555555555555555dddd5d5
5ddd5d5500000000000000000000000000000000000000000000000000000000044444400000000000000000000000000000000000000000000000005ddd5d55
5d555dd500000000000000000000000000000000000000000000000000000000040000400000000000000000000000000000000000000000000000005d555dd5
5dddddd500000000000000000000000000000000000000000000000000000000044444400000000000000000000000000000000000000000000000005dddddd5
555d5d550000000000000000000000000000000000000000000000000000000004000040000000000000000000000000000000000000000000000000555d5d55
5ddd5dd50000000000000000000000000000000000000000000000000000000004444440000000000006d000000000000000000000000000000000005ddd5dd5
5d5d55d5000000000000000000000000000000000000000000000000000000000400004000000000006d5500000000000000000000000000000000005d5d55d5
5d5dddd500000000000000000000000000000000000000000000000000000000044444400000000000d55500000000000000000000000000000000005d5dddd5
55ddd5d5000000000000000000000000000000000000000000000000000000000400004000000000000550000000000000000000000000000000000055ddd5d5
5ddd5d550000000000000000000000000000000000000000000000000000000004444440000000000f4444f0000000000000000000000000000000005ddd5d55
5d555dd5000000000000000000000000000000000000000000000000000000000400004000000000021f142000000000000000000000000000dd10005d555dd5
5dddddd500000000000000000000000000000000000000000000000000000000044444400000000002ffff20000000000000000000000000d1d1dd105dddddd5
555d5d550000000000000000000000000000000000000000000000000000000004000040000000000022220000000000000000000000000022222222555d5d55
5ddd5dd500000000000000000000000000000000000000000000000000000000044444400000000000222200000000000000000000000000244244425ddd5dd5
5d5d55d500000000000000000000000000000000000000000000000000000000040000400000000000111100000000000000000000000000424424245d5d55d5
5d5dddd500000000000000000000000000000000000000000000000000000000044444400000000000100100000000000000000000000000424244245d5dddd5
55ddd5d5000000000000000000000000000000000000000000000000000000000400004000000000000404000000000000000000000000004244424455ddd5d5
5d5dd5d554444445555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555d5dd5d5
5dd5dddd54000045dd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddddd5dd5
5dddd5d554444445dd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5ddd5d5d5dddd5
5d55dd5d54000045ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55ddd55d55d5dd55d5
5ddddddd544444455dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5dd5dddd5ddddddddd5
5d5d5dd554000045555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d555d5d5d5dd5d5d5
5ddddddd54444445dddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5ddddddd5dddddddd5
55555555540000455555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555

__map__
5858585858585858585858585858585858585858585858585858585858585858585858580000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5807070707070707070303030303030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5803030707070703070303070303030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5803030303070707070707070303030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5803030303030707070307070703030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5803030303030307070707070703030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5803030303030303030303030303030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030307030303030303030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303030303030303030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000e0501a0501f05024050180001b0001f00022000290002200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000230501d05019050140500e0500a050120000c000070002200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01040000150552b0001d0551805429055080000500004000030000100001000010000100001000010010100101000000000000100001000010000100001000010000100001000010000100001000010000100000
01030000103530e6450e6250e615000000e6150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010800000c5550c5000c555005050c555005000050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505005050050500505
__music__
00 01424344

