module(..., package.seeall)

new = function ()
	local localGroup=display.newGroup()
	
	--Create blue background
	local backgroundSky=display.newRect(0,0,display.contentWidth,display.contentHeight)
	backgroundSky:setFillColor(98,183,214)
	
	localGroup:insert(backgroundSky)
	
	--Create display group to hold clouds
	local cloudDisplayGroup=display.newGroup()
	
	localGroup:insert(cloudDisplayGroup)
	
	--Set speed of clouds
	local cloudSpeed=.1
	
	--Function to remove cloud when it travels off the scene
	local function removeCloud(cloudObject)
		cloudObject:removeSelf()
		cloudObject=nil
	end
	
	--Function to create a random coud
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
	
	
	-- init physics
	local physics = require("physics")
	physics.start()
	
	local physicsData = (require "CloudPhysics").physicsData(1.0)
	
	------Create Clouds to walk on
	--create display group for walking clouds
	local walkingCloudDisplayGroup=display.newGroup()
	localGroup:insert(walkingCloudDisplayGroup)
	
	local walkingCloudSpeed=.05
	
	local function removeWalkingCloud(cloudToRemove)
		cloudToRemove:removeSelf()
		cloudToRemove=nil
	end
	
	local lastX=0
	local lastY=display.contentWidth/2
	local createRandomWalkingCloudTimer
	local function createRandomWalkingCloud()
		local randomCloudNumber=math.random(1,2)
		local walkingCloud=display.newImage("cloud"..randomCloudNumber..".png")
		physics.addBody(walkingCloud,physicsData:get("cloud"..randomCloudNumber))
		walkingCloud.bodyType="static"
		local randomX=math.random(walkingCloud.contentWidth/2,walkingCloud.contentWidth)
		walkingCloud.x=lastX+randomX
		lastX=walkingCloud.x+walkingCloud.contentWidth/2
		walkingCloud.y=math.random(lastY-walkingCloud.contentHeight/2,lastY+walkingCloud.contentHeight/2)
		lastY=walkingCloud.y
		
		local walkingCloudDistance=- walkingCloud.x - walkingCloud.contentWidth/2
		local walkingCloudTravelSpeed= math.abs(walkingCloudDistance/walkingCloudSpeed)
		walkingCloud.transition=transition.to(walkingCloud,{time=walkingCloudTravelSpeed, x=-walkingCloud.x-walkingCloud.contentWidth/2, onComplete=removeWalkingCloud})
		walkingCloudDisplayGroup:insert(walkingCloud)
	
	
		createRandomWalkingCloudTimer=timer.performWithDelay(1000,createRandomWalkingCloud)
	end
	
	local generateRandomCloudsTimer
	
	local function createStartingWalkingClouds()
		for i=1,5 do
			local walkingCloud=display.newImage("cloud2.png")
			physics.addBody(walkingCloud,physicsData:get("cloud2"))
			walkingCloud.bodyType="static"
			walkingCloud.x=lastX+walkingCloud.contentWidth/2
			lastX=lastX+walkingCloud.contentWidth
			walkingCloud.y=lastY
	
			local walkingCloudDistance=- walkingCloud.x - walkingCloud.contentWidth/2
			local walkingCloudTravelSpeed= math.abs(walkingCloudDistance/walkingCloudSpeed)
			walkingCloud.transition=transition.to(walkingCloud,{time=walkingCloudTravelSpeed, x=-walkingCloud.x-walkingCloud.contentWidth/2, onComplete=removeWalkingCloud})
			walkingCloudDisplayGroup:insert(walkingCloud)
		end
		createRandomWalkingCloud()
	end
	
	createStartingWalkingClouds()
	
	
	--Create hero object
	--include movieclip object
	local movieClip=require("movieclip")
	
	local heroAngel=movieClip.newAnim({"char_jump_1.png","char_jump_2.png","char_shoot_1.png","char_shoot_2.png","char_walk_1.png","char_walk_2.png"})
	heroAngel.x=heroAngel.contentWidth
	heroAngel.y=50
	heroAngel:setSpeed(0.4)
	heroAngel:play({startFrame=1,endFrame=2,loop=0,remove=false})
	physics.addBody(heroAngel,physicsData:get("char_walk_2"))
	
	localGroup:insert(heroAngel)
	
	--This physics joint keeps our angel upright
	local rect = display.newRect( 50, 50, 100, 100 )
	rect:setFillColor( 255, 255, 255, 100 )
	rect.isVisible = false  -- optional
	rect.y=display.contentHeight
	physics.addBody( rect, "static",{ isSensor = true } )
	local pistonJoint=physics.newJoint("piston",heroAngel, rect,heroAngel.x,heroAngel.y,0,-100)
	
	
	--Function to make the angel jump when the screen is tapped
	local isJumping=false
	local function jumpAngel(event)
		if(isJumping ~= true) then
			
			heroAngel:play({startFrame=1,endFrame=2,loop=5,remove=false})
			
			if(event.numTaps>1) then
				isJumping=true
				print("double tap")
				heroAngel:applyLinearImpulse( 0, -225, heroAngel.x, heroAngel.y )
			else
				isJumping=true
				heroAngel:applyLinearImpulse( 0, -200, heroAngel.x, heroAngel.y )
			end
		end
	end
	Runtime:addEventListener("tap", jumpAngel)
	
	
	--Function to adjust gravity if touching and flying
	local function adjustGravityForTouch(event)
		if ( event.phase=="began" ) then
			print("changing gravity")
			physics.setGravity( 0, 2.4 )
			heroAngel:play({startFrame=1,endFrame=2,loop=0,remove=false})
		elseif(event.phase=="ended") then
			print("gravity normal")
			physics.setGravity( 0, 9.8 )
			heroAngel:stopAtFrame(2)
		end
	end
	Runtime:addEventListener("touch", adjustGravityForTouch)
	
	--Reset the angel when he lands
	local function onLocalCollision(self, event)
		if ( event.phase == "began" ) then
			isJumping=false
			heroAngel:play({startFrame=5,endFrame=6,loop=0,remove=false})
		end
	end
	heroAngel.collision = onLocalCollision
	heroAngel:addEventListener( "collision", heroAngel )
	
	
	local checkGameOver
	
	--Function to clean up the scene before loading the next one
	local function cleanUpScene()
		timer.cancel(cloudTimer)
		timer.cancel(createRandomWalkingCloudTimer)
		Runtime:removeEventListener("enterFrame",checkGameOver)
		Runtime:removeEventListener("tap", jumpAngel)
		
		for i=cloudDisplayGroup.numChildren,1,-1 do
			local cloudObject=cloudDisplayGroup[i]
			transition.cancel(cloudObject.transition)
			removeCloud(cloudObject)
		end
		
		for i=walkingCloudDisplayGroup.numChildren,1,-1 do
			local walkingCloudObject = walkingCloudDisplayGroup[i]
			transition.cancel(walkingCloudObject.transition)
	  		removeWalkingCloud(walkingCloudObject)
		end
		
		
	end
	
	local gameOver=false
	
	--Check if angel fell down
	function checkGameOver()
		if(gameOver~=true) then
			if (heroAngel.y>display.contentHeight) then
				gameOver=true
				heroAngel:removeEventListener("enterFrame",checkGameOver)
				local gameOverText=display.newText("Game Over",0,0,native.SystemFontBold,72)
				gameOverText.x=display.contentWidth/2
				gameOverText.y=display.contentHeight/2
				--Show restart button
local ui=require("ui")
local restartButtonPressed = function (event )
    if event.phase == "release" then
        --Clean up the scene before we start it again
        cleanUpScene()
        director:changeScene( "GameScene", "overFromRight" )
    end
end

--Create a restart Button
local restartButton = ui.newButton{
    default = "button_restart_up.png",
    over = "button_restart_down.png",
    onEvent = restartButtonPressed,
    id = "btn001",
    text = "",
    font = "Trebuchet-BoldItalic",
    textColor = { 51, 51, 51, 255 },
    size = 22,
    emboss = true
}

restartButton:setReferencePoint(display.CenterReferencePoint)
restartButton.x=display.contentWidth/2
restartButton.y=restartButton.y + restartButton.contentHeight
localGroup:insert(restartButton)    
			end
		end
	end

	Runtime:addEventListener("enterFrame",checkGameOver)
	
	return localGroup

end


