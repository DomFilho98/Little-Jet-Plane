
local composer = require( "composer" )
 
local scene = composer.newScene()

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

math.randomseed( os.time() )

local sheetOptions =
{
    frames =
    {
        {   -- 1)nave inimiga
            x = 0,
            y = 0,
            width = 469 ,
            height = 225
        },

        {   -- 2)nave inimiga 2
            x = 45,
            y = 353,
            width = 372,
            height = 176
        },

        {   -- 3)nave principal
            x = 0,
            y = 890,
            width = 460,
            height = 275
        },
 
    },
}

local objectSheet = graphics.newImageSheet( "Objetos_2.png", sheetOptions )

local lives = 1
local score = 0
local died = false
 
local enemiesTable = {} 
 
local plane
local gameLoopTimer
local livesText
local scoreText

local backGroup = display.newGroup()  -- Mostrar na TELA elementos background
local mainGroup = display.newGroup()  -- Mostrar em tel elementos como aviao, inimigos, colecionaveis
local uiGroup = display.newGroup()    -- Mostrar em tela elementos como pontuação e vida
--background
local background = display.newImageRect(backGroup, "bg_stars_2.png", 850,500 )
background.x = display.contentCenterX
background.y = display.contentCenterY
--nave
--plane = display.newImageRect( mainGroup, objectSheet, 1, 140, 60 ) inimigo 1
--plane = display.newImageRect( mainGroup, objectSheet, 2, 140, 60 )inimigo 2
plane = display.newImageRect( mainGroup, objectSheet, 3, 90, 50 )
plane.x = display.contentCenterX - 250
plane.y = display.contentCenterY - 50
physics.addBody( plane, { radius=30, isSensor=true } )
plane.myName = "plane"

-- Display lives and score
livesText = display.newText( uiGroup, "Vida: " .. lives, -200, 40, native.systemFont, 25 )
scoreText = display.newText( uiGroup, "Score " .. score, 500, 40, native.systemFont, 25 )
display.setStatusBar( display.HiddenStatusBar )

local function updateText()
    livesText.text = "Lives: " .. lives
    scoreText.text = "Score: " .. score
end

--inimigos de forma aleatoria
local function createEnemy()
    print("criando inimigo")
    local newEnemy1 = display.newImageRect( mainGroup, objectSheet, math.random(1,2), 90, 40 )
    table.insert( enemiesTable, newEnemy1 )
    physics.addBody( newEnemy1, "dynamic", { radius=40, bounce=0.8 } )
    newEnemy1.myName = "Enemy1"
     
    local whereFrom = math.random( 2 )

    if ( whereFrom == 1 ) then
        -- From the left
        newEnemy1.x = 550
        newEnemy1.y = math.random(20,40)
        newEnemy1:setLinearVelocity ( -550,100 ) 
    elseif ( whereFrom == 2 ) then
        -- From the left
        newEnemy1.x = 550
        newEnemy1.y = math.random(200,250)
        newEnemy1:setLinearVelocity ( -550,100 ) 
    end
    
end
--movimentar nave
local function movePlane( event )
 
    local plane = event.target
    local phase = event.phase
 
    if ( "began" == phase ) then
        display.currentStage:setFocus( plane )
        plane.touchOffsetY = event.y - plane.y
        plane.touchOffsetX = event.x - plane.x
    elseif ( "moved" == phase ) then
        plane.y = event.y - plane.touchOffsetY
        plane.x = event.x - plane.touchOffsetX
    elseif ( "ended" == phase or "cancelled" == phase ) then
        -- Release touch focus on the ship
        display.currentStage:setFocus( nil )
    end

    return true
end
plane:addEventListener( "touch", movePlane )

--game loop
local function gameLoop()
    
    createEnemy()

    for i = #enemiesTable, 1, -1 do
        local thisenemies = enemiesTable[i]
        if ( thisenemies.x < -100 or
            thisenemies.y < -100)
        then    
            display.remove( thisenemies )
            table.remove( enemiesTable, i )
        end
    end
end

--gameLoopTimer = timer.performWithDelay( 500, gameLoop, -1 )
--restart
local function restorePlane()
 
    plane.isBodyActive = false
    plane.x = display.contentCenterX
    plane.y = display.contentHeight - 100
 
    -- Fade in the ship
    transition.to( plane, { alpha=1, time=4000,
        onComplete = function()
            plane.isBodyActive = true
            died = false
        end
    } )
end

-- colisão nave + colisão do cronometro
local function onCollision( event )
 
    if (event.phase == "began") then
		local obj1 = event.object1
		local obj2 = event.object2	


		if ((obj1.myName == "plane" and obj2.myName == "Enemy1") or 
			(obj1.myName == "Enemy1" and obj2.myName == "plane"))
		then
			if(died == false) then
				died = true

				-- Perde Vida
				lives = lives -1
				livesText.text = "Vida: " .. lives

				if (lives == 0) then
					display.remove(plane)
                    timer.performWithDelay( 2000, endGame )
				end
			end
		end
	end
end
Runtime:addEventListener( "collision", onCollision )

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
 
   -- Set up display groups
     --backGroup = display.newGroup()  -- Mostrar na TELA elementos background
     sceneGroup:insert(backGroup)

     --mainGroup = display.newGroup()  -- Mostrar em tel elementos como aviao, inimigos, colecionaveis
     sceneGroup:insert(mainGroup)

     --uiGroup = display.newGroup()
     sceneGroup:insert(uiGroup)

    -- Load the background
    --local background = display.newImageRect(backGroup, "bg_stars_2.png", 850,500 )
    --background.x = display.contentCenterX
    --background.y = display.contentCenterY

    --[[plane = display.newImageRect( mainGroup, objectSheet, 3, 90, 50 )
    plane.x = display.contentCenterX - 250
    plane.y = display.contentCenterY - 50
    physics.addBody( plane, { radius=30, isSensor=true } )
    plane.myName = "plane"
]]--
    -- Display lives and score
  
    
end

-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        physics.start()
      
        
        Runtime:addEventListener( "collision", onCollision )
        --gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )
        gameLoopTimer = timer.performWithDelay( 500, createEnemy, 0 )
    end
end

-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		 timer.cancel( gameLoopTimer )

	elseif ( phase == "did" ) then
		Runtime:removeEventListener( "collision", onCollision )
        physics.pause()
        composer.removeScene( "game" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
