module(..., package.seeall)

--====================================================================--
-- SCENE: [NAME]
--====================================================================--

--[[

 - Version: [1.0]
 - Made by: [name]
 - Website: [url]
 - Mail: [mail]

******************
 - INFORMATION
******************

  - [Your info here]

--]]

new = function ()
	
	------------------
	-- Groups
	------------------
	
	local localGroup = display.newGroup()
	
	------------------
	-- Your code here
	------------------
	
	local mainMenuBackground=display.newImage("Cloud_Jumper_TitleScreen.png")
	localGroup:insert(mainMenuBackground)
	
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
	
	------------------
	-- MUST return a display.newGroup()
	------------------
	
	return localGroup
	
end