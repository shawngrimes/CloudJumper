-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

--Create blue background
local backgroundSky=display.newRect(0,0,display.contentWidth,display.contentHeight)
backgroundSky:setFillColor(98,183,214)

-- Add a cloud to the scene
local randomCloudObject=display.newImage("bg_cloud3.png")
randomCloudObject.x=display.contentWidth/2
randomCloudObject.y=display.contentHeight/2

--Add our hero
local heroAngel=display.newImage("char_jump_1.png")
heroAngel.x=heroAngel.contentWidth
heroAngel.y=display.contentHeight/2
