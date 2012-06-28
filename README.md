Cloud Jumper
===========

A horizontal scrolling Corona game using basic physics. 

Developed by: [Shawn Grimes](http://www.shawngrimes.me) for [APPlied Club](http://www.appliedclub.org)

Artwork provided by [Vicki Wenderlich](http://www.vickiwenderlich.com)


Image Scaling
-----
1. Run ScalingSample project
2. Open config.lua, change scale="letterBox"
3. Demo difference on each device


Creating a Game
------
1. Open CloudJumper base
2. The code in the CloudJumper base scrolls random clouds across the background.

3. Open Physics Editor
4. Drag in Cloud1,2,3 and char_walk_2
5. Create physics objects See this [Corona Physics Editor Tutorial](http://www.codeandweb.com/blog/2012/05/24/getting-started-with-coronasdk-and-physicseditor-tutorial) for more information on using [Physics Editor](http://www.codeandweb.com/)

6. Add physics library to CloudJumper base
    ````
    -- init physics
    local physics = require("physics")
    physics.start()

	````

7. Now add our exported physics file from Physics Editor
	````
	local physicsData = (require "CloudPhysics").physicsData(1.0)
	````
	
8. Add score label
    ````
    ------Create Clouds to walk on
    --create display group for walking clouds
    local walkingCloudDisplayGroup=display.newGroup()
    
    local walkingCloudSpeed=.05
    
    --Create a label to count how many clouds have passed
    local scoreCount=0
    local scoreLabel=display.newText("Score: 0", 10,40, native.systemFontBold , 48)
    scoreLabel:setTextColor(255, 255, 255)
    
    walkingCloudDisplayGroup:insert(scoreLabel)
    ````
9. Run the app in the simulator, you should see the new score label added to the scene. 
9. Create initial platforms
````
	--Create function to remove clouds when they travel off the scene
    local function removeWalkingCloud(cloudToRemove)
	    scoreCount=scoreCount+1
	    scoreLabel.text="Score: "..scoreCount
	    cloudToRemove:removeSelf()
	    cloudToRemove=nil
    end
	
	--Create variables to track the location of the last cloud
	local lastX=0
	local lastY=display.contentWidth/2
	
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
    end

	createStartingWalkingClouds()
````
11. Run the app in the simulator, you should see the foreground clouds. 
10. Add our hero
````
    --Create hero object
    --include movieclip object
    local movieClip=require("movieclip")

    local heroAngel=movieClip.newAnim({"char_jump_1.png","char_jump_2.png","char_shoot_1.png","char_shoot_2.png","char_walk_1.png","char_walk_2.png"})
    heroAngel.x=heroAngel.contentWidth
    heroAngel.y=50
    heroAngel:setSpeed(0.4)
    heroAngel:play({startFrame=1,endFrame=2,loop=0,remove=false})
    physics.addBody(heroAngel,physicsData:get("char_walk_2"))

	````
11. Run the app in the simulator, you should see the hero character fall from the sky and land on the foreground clouds.  Then he falls over :( 
11. Fix the hero so he's upright and doesn't fall over.  We are going to attach him to a rectangle object below with a pivot joint.  Pivot joints can only move up and down and this will prevent the hero angel from rotating.
````
    --This physics joint keeps our angel upright
    local rect = display.newRect( 50, 50, 100, 100 )
    rect:setFillColor( 255, 255, 255, 100 )
    rect.isVisible = true  -- optional
    rect.y=display.contentHeight
    physics.addBody( rect, "static",{ isSensor = true } )
    local pistonJoint=physics.newJoint("piston",heroAngel, rect,heroAngel.x,heroAngel.y,0,-100)
````
12. Now set the rect.isVisible = false to hide it on the scene.

12. Let's make the hero jump when we touch the screen
`````
    --Function to make the angel jump when the screen is tapped
    local function jumpAngel(event)
	 	heroAngel:applyLinearImpulse( 0, -225, heroAngel.x, heroAngel.y )
    end
    Runtime:addEventListener("tap", jumpAngel)
````

13.  Let's add a better jump function to make sure you can't infinite jump with collision detection:
````
    --Function to make the angel jump when the screen is tapped
    local isJumping=false
    local function jumpAngel(event)
	    if(isJumping ~= true) then
	    	--Change to flying frames
		    heroAngel:play({startFrame=1,endFrame=2,loop=0,remove=false})
		    isJumping=true
			 heroAngel:applyLinearImpulse( 0, -200, heroAngel.x, heroAngel.y )
	    end
    end
    Runtime:addEventListener("tap", jumpAngel)
    
    --Reset the angel when he lands
    local function onLocalCollision(self, event)
	    if ( event.phase == "began" ) then
		    isJumping=false
		    --Change back to walking frames
		    heroAngel:play({startFrame=5,endFrame=6,loop=0,remove=false})
	    end
    end
    heroAngel.collision = onLocalCollision
    heroAngel:addEventListener( "collision", heroAngel )
````

14. Adjust gravity if tap is held
````
--Function to adjust gravity if touching and flying
local function adjustGravityForTouch(event)
	if ( event.phase=="began" ) then
		print("changing gravity")
		physics.setGravity( 0, 2.4 )
	elseif(event.phase=="ended") then
		print("gravity normal")
		physics.setGravity( 0, 9.8 )
	end
end
Runtime:addEventListener("touch", adjustGravityForTouch)
````

Adding Polish
------
1. Open CloudJumper-NeedsPolish
2. Run and show current state of game
3. Introduce [Corona Director Class](http://developer.anscamobile.com/code/director-class-10)
4. Rename main.lua to GameScene.lua
5. Create new main.lua
6. Copy code to main.lua
````
    -------------------------------------------------------------------------------------
    --
    -- main.lua
    --
--------------------------------------------------------------------------------------
    
    -- Your code here
    
    -- IMPORT DIRECTOR CLASS
    local director = require("director")
        
    -- CREATE A MAIN GROUP
    local mainGroup = display.newGroup()
    
    -- MAIN FUNCTION
    local main = function ()
	    -- Add the group from director class
	    mainGroup:insert(director.directorView)
	    
	    director:changeScene("MainMenuScene")
	    
	    -- Return true to signal that the function was successful
        return true
    end
    
    main()
````
7. Create MainMenuScene.lua
8. Copy template.lua code into MainMenuScene.lua
9. Create background image in MainMenuScene.lua
````
	local mainMenuBackground=display.newImage("Cloud_Jumper_TitleScreen.png")
	localGroup:insert(mainMenuBackground)
````
10. Run the app, you should see the MainMenu Scene now.
10. Add a play button:
````
local ui = require("ui")
	
	local playButtonPressed = function (event )
			if event.phase == "release" then
				director:changeScene( "GameScene", "overFromRight" )
			end
	end
	
	local playButton = ui.newButton{
		default = "button_play_up.png",
		over = "button_play_down.png",
		onEvent = playButtonPressed,
		id = "btn001",
		text = "",
		font = "Trebuchet-BoldItalic",
		textColor = { 51, 51, 51, 255 },
		size = 22,
		emboss = true
	}
	
	playButton:setReferencePoint(display.CenterReferencePoint)
	playButton.x=display.contentWidth/2
	playButton.y=display.contentHeight-display.contentHeight/5
	
	--Add start button to local group
	localGroup:insert(playButton)
````
11. Now open GameScene.lua
12. At the top add:
````
    module(..., package.seeall)
    
    new = function ()
````

13. At the bottom add:
````
    return localGroup
	    
    end
````
14. Run the game.  You should be able to launch the gameplay scene now.
14. Restarting the game
15. Let's add a restart button to our game over logic.  Line 215, add:
````
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
````
16. How about some background music?
17. Open main.lua and add the following around line 17 (after `local main = function ()` ):
````
	--Play background music
	local backgroundMusicObject = audio.loadStream("backgroundMusic.mp3")
	audio.play(backgroundMusicObject)
````
18. Run the game now


