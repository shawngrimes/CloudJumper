-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

--Create blue background
local backgroundSky=display.newRect(0,0,display.contentWidth,display.contentHeight)
backgroundSky:setFillColor(98,183,214)


---Create background clouds
--Create display group to hold clouds
local cloudDisplayGroup=display.newGroup()

--Set speed of clouds
local cloudSpeed=.1

--Function to remove cloud when it travels off the scene
local function removeCloud(cloudObject)
	cloudObject:removeSelf()
	cloudObject=nil
end

--Function to create a random background coud
local function createRandomCloud()
	local randomNumber=math.random(1,3)
	local randomCloudObject=display.newImage("bg_cloud"..randomNumber..".png", true)
	
	--Get a random Y lcoation for the cloud
	local randomY=math.random(0,display.contentHeight)
	randomCloudObject.x=display.contentWidth + randomCloudObject.contentWidth
	randomCloudObject.y=randomY
	
	--Calculate the travel time for the cloud to move off scene
	local travelDistance=display.contentWidth+randomCloudObject.contentWidth
	local travelTime=travelDistance/cloudSpeed
	
	--Start the cloud moving off the scene
	randomCloudObject.transition=transition.to(randomCloudObject,{time=travelTime,x=-randomCloudObject.contentWidth, onComplete=removeCloud})
	
	--Add new random cloud to display group
	cloudDisplayGroup:insert(randomCloudObject)
end

local cloudTimer=timer.performWithDelay(4000,createRandomCloud,0)




