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
	--Play background music
local backgroundMusicObject = audio.loadStream("backgroundMusic.mp3")
audio.play(backgroundMusicObject)
    -- Add the group from director class
    mainGroup:insert(director.directorView)

    director:changeScene("MainMenuScene")

    -- Return true to signal that the function was successful
    return true
end

main()