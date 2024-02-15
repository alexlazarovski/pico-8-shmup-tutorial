pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- init gets called once
-- at the beginning
function _init()
 cls(0)
 mode="start"
 blinkt=1
end

function _update()
 blinkt+=1
 
 if mode=="game" then
  update_game()
 elseif mode=="start" then
  update_start()
 elseif mode=="over" then
  update_over()
 end

end

function _draw()

 if mode=="game" then
  draw_game()
 elseif mode=="start" then
  --startdraw
  draw_start()
 elseif mode=="over" then
  draw_over()
 end
 
end

function startgame()
 mode="game"
 
 ship={}
 ship.x=64
 ship.y=64
 ship.sx=0
 ship.sy=0
 ship.spr=2
 
 flamespr=5
 
 bullets={}
 
 muzzle=0
 
 score=flr(rnd(128))*100
 
 lives=3
 
 stars={}
 for i=1,100 do
  local newstar={}
  newstar.x=flr(rnd(128))
  newstar.y=flr(rnd(128))
  newstar.spd=rnd(1.5)+0.5
  add(stars,newstar)
 end
 
 enemies={}
 
 local myen={}
 myen.x=60
 myen.y=5
 myen.spr=21
 
 add(enemies,myen)
 
end






-->8
-- helpers
function drawstarfield()
 for i=1,#stars do
  local mystar=stars[i]
  local scolor=6
  
  if mystar.spd<1 then
   scolor=1
  elseif mystar.spd<1.5 then
   scolor=13
  end
  
  pset(mystar.x,mystar.y,scolor) 
 end
end

function animatestars()
 --animate background
	for i=1,#stars do
	 local mystar=stars[i]
	 mystar.y+=mystar.spd
	 if mystar.y>128 then
	  mystar.y-=128
	 end
	end
end

function drawbullet()
 for bullet in all(bullets) do
  drwmyspr(bullet)
 end
end

function drawbulletsmuzzle()
 if muzzle>0 then
  circfill(
   ship.x+3, ship.y-3,muzzle,7)
	end
end

function drawlives() 
 for i=1,4 do
  if lives>=i then
   spr(13,i*9-8,1)
  else
   spr(12,i*9-8,1)
  end
 end
end

function blink()
 local blinkanim={5,5,5,5,5,5,5,6,6,6,7,7,6,6,5,5}
	if blinkt>#blinkanim then
	 blinkt=1
	end 
 return blinkanim[blinkt]

end

function drwmyspr(myspr)
 spr(myspr.spr,myspr.x,myspr.y)
end
-->8
-- update

function update_game()
 --controls
 ship.sx=0
 ship.sy=0
 ship.spr=2
 
	if (btn(0)) then  
	 ship.sx = -2
	 ship.spr=1
	end
	if btn(1) then 
	 ship.sx = 2
	 ship.spr=3 
	end
	if btn(2) then 
	 ship.sy = -2 
	end
	if btn(3) then 
	 ship.sy = 2 
	end
	
	if btn(4) then
	 mode="over"
	end
	
	if btnp(5) then
	 local bullet={}
	 bullet.x=ship.x
	 bullet.y=ship.y-4
	 bullet.spr=16
	 add(bullets, bullet)
	 sfx(0)
	 muzzle=6
	end
	
	--moving the ship
	ship.x+=ship.sx
	ship.y+=ship.sy
	
	--move the bullet
	for bullet in all(bullets) do
	 bullet.y-=4
	 
	 if bullet.y<-8 then
	  del(bullets,bullet)
	 end 
	end
	
	
	--moving enemies
	for myen in all(enemies) do
	 myen.y+=1
	 
	 --enemy animation
	 myen.spr+=0.4
	 if myen.spr>=25 then
	  myen.spr=21
	 end 
	 
	 if(myen.y>128) then
	  del(enemies,myen)
	 end
	end
	
	--animate flame
	flamespr=flamespr+1
	if flamespr>9 then
	 flamespr=5
	end
	
	--animate muzzle flash
	if muzzle>0 then
	 muzzle = muzzle-1
	end
	
	if ship.x>120 then
		ship.x=120
	end
	
	if ship.x<0 then 
	 ship.x=0
	end
	
	if ship.y<0 then
	 ship.y=0
	end
	
	if ship.y>120 then
	 ship.y=120
	end
	
	animatestars()

end

function update_start()

 if btnp(4) or btnp(5) then
  startgame()
 end
 
end

function update_over()
 if btnp(4) or btnp(5) then
  mode="start"
 end
end
-->8
-- draw

function draw_game()
 cls(0)
 
 --this draws the background
 drawstarfield()

	-- this draws the ship
	drwmyspr(ship)
 spr(flamespr,ship.x,ship.y+8)
 
 --draw enemies
 for i=1,#enemies do
  local enemy=enemies[i]
  drwmyspr(enemy)
 end
 
 drawbullet()
 
 drawbulletsmuzzle()
	
	--draw score
	print("score:"..score,40,1,12)
 
 drawlives()
 
 print(#bullets,5,5,7)
 
end

function draw_start()
 cls(1)
 print("awesome shmup",34,40,12)
 print("press any key to start",20,80,blink())
end

function draw_over()
 cls(8)
 print("game over",45,40,2)
 print("press any key to continue",15,80,blink())
end
__gfx__
00000000000220000002200000022000000000000000000000000000000000000000000000000000000000000000000008800880088008800000000000000000
000000000028820000288200002882000000000000077000000770000007700000c77c0000077000000000000000000080088008878888880000000000000000
007007000028820000288200002882000000000000c77c000007700000c77c000cccccc000c77c00000000000000000080000008878888880000000000000000
0007700000288e2002e88e2002e882000000000000cccc00000cc00000cccc0000cccc0000cccc00000000000000000080000008888888880000000000000000
00077000027c88202e87c8e202887c2000000000000cc000000cc000000cc00000000000000cc000000000000000000008000080088888800000000000000000
007007000211882028811882028811200000000000000000000cc000000000000000000000000000000000000000000000800800008888000000000000000000
00000000025582200285582002285520000000000000000000000000000000000000000000000000000000000000000000088000000880000000000000000000
00000000002aa200002aa200002aa200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999900000000000000000000000000000000000330033003300330033003300330033000000000000000000000000000000000000000000000000000000000
09aaaa900000000000000000000000000000000033b33b3333b33b3333b33b3333b33b3300000000000000000000000000000000000000000000000000000000
9aa77aa9000000000000000000000000000000003bbbbbb33bbbbbb33bbbbbb33bbbbbb300000000000000000000000000000000000000000000000000000000
9a7777a9000000000000000000000000000000003b7717b33b7717b33b7717b33b7717b300000000000000000000000000000000000000000000000000000000
9a7777a9000000000000000000000000000000000b7117b00b7117b00b7117b00b7117b000000000000000000000000000000000000000000000000000000000
9aa77aa9000000000000000000000000000000000037730000377300003773000037730000000000000000000000000000000000000000000000000000000000
09aaaa90000000000000000000000000000000000303303003033030030330300303303000000000000000000000000000000000000000000000000000000000
00999900000000000000000000000000000000000300003030000003030000300330033000000000000000000000000000000000000000000000000000000000
__sfx__
000100003755035550325502f5502c550295502555022550205501e5501c5501a550175501555012550105500e5500c5500a550075500755006550045500355000550100000d0000a0000800005000020000b000
001000000000000000000000000028000260002400021000200001f0001e000000001d0001c0001c0001d0001d0001f00022000260002b0002d00000000000000000000000000000000000000000000000000000
