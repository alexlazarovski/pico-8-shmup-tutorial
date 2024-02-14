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
 
 shipx=64 
 shipy=100
 
 shipspdx=0
 shipspdy=0
  shipspr=2
 flamespr=5
 
 bulx=64
 buly=-10
 
 bullets={}
 
 muzzle=0
 
 score=flr(rnd(128))*100
 
 lives=3
 starx={}
 stary={}
 stars={}
 
 for i=1,100 do
  add(starx,flr(rnd(128)))
  add(stary,flr(rnd(128)))
  add(stars, rnd(1.5)+0.5)
 end
 
end






-->8
-- helpers
function drawstarfield()
 for i=1,#starx do
  local scolor=6
  if stars[i]<1 then
   scolor=1
  elseif stars[i]<1.5 then
   scolor=13
  end
  
  pset(starx[i],stary[i],scolor)
   
 end
end

function animatestars()
 --animate background
	for i=1,#stary do
	 local sy=stary[i]
	 local ss=stars[i]
	 sy=sy+ss
	 if stary[i]>128 then
	  sy=0
	 end
	 stary[i] = sy
	end
end

function drawbullet()
 for i=1,#bullets do
  spr(16, bullets[i].x, bullets[i].y)
 end
end

function drawbulletsmuzzle()
 if muzzle>0 then
  circfill(
   shipx+3, shipy-3,muzzle,7)
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
-->8
-- update

function update_game()
 --controls
 shipspdx=0
 shipspdy=0
 shipspr=2
 
	if (btn(0)) then  
	 shipspdx = -2
	 shipspr=1
	end
	if btn(1) then 
	 shipspdx = 2
	 shipspr=3 
	end
	if btn(2) then 
	 shipspdy = -2 
	end
	if btn(3) then 
	 shipspdy = 2 
	end
	
	if btn(4) then
	 mode="over"
	end
	
	if btnp(5) then
	 bullet={}
	 bullet.x=shipx
	 bullet.y=shipy-4
	 add(bullets, bullet)
	 sfx(0)
	 muzzle=6
	end
	
	--moving the ship
	shipx = shipx+shipspdx
	shipy = shipy+shipspdy
	
	--move the bullet
	--buly=buly-4
	for i=1,#bullets do
	 bullets[i].y-=4 
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
	
	if shipx>120 then
		shipx=120
	end
	
	if shipx<0 then 
	 shipx=0
	end
	
	if shipy<0 then
	 shipy=0
	end
	
	if shipy>120 then
	 shipy=120
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
 spr(shipspr,shipx,shipy)
 spr(flamespr,shipx,shipy+8)
 
 drawbullet()
 
 drawbulletsmuzzle()
	
	--draw score
	print("score:"..score,40,1,12)
 
 drawlives()
 
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
00999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09aaaa90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9aa77aa9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9a7777a9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9a7777a9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9aa77aa9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09aaaa90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100003755035550325502f5502c550295502555022550205501e5501c5501a550175501555012550105500e5500c5500a550075500755006550045500355000550100000d0000a0000800005000020000b000
001000000000000000000000000028000260002400021000200001f0001e000000001d0001c0001c0001d0001d0001f00022000260002b0002d00000000000000000000000000000000000000000000000000000
