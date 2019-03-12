
local background = display.newImage("bg.png")
background.x = display.contentCenterX
background.y = display.contentCenterY

local Cityback = display.newImage("Cityback.png")
Cityback.x = display.contentCenterX
Cityback.y = display.contentCenterY+40
Cityback.speed=1

local Cityback2 = display.newImage("Cityback.png")
Cityback2.x = display.contentCenterX +480
Cityback2.y = display.contentCenterY+40
Cityback2.speed=1

local Citymain = display.newImage("Citymain.png")
Citymain.x = display.contentCenterX 
Citymain.y = display.contentCenterY+100
Citymain.speed=2

local Citymain2 = display.newImage("Citymain.png")
Citymain2.x = display.contentCenterX +480
Citymain2.y = display.contentCenterY+100
Citymain2.speed=2

--faz as cidades background mexer
function scrollCity(self,event)
    if self.x< -460 then
        self.x=460
    else
    self.x = self.x -self.speed
    end
end

Cityback.enterFrame = scrollCity
Runtime:addEventListener("enterFrame",Cityback)

Cityback2.enterFrame = scrollCity
Runtime:addEventListener("enterFrame",Cityback2)

Citymain.enterFrame = scrollCity
Runtime:addEventListener("enterFrame",Citymain)

Citymain2.enterFrame = scrollCity
Runtime:addEventListener("enterFrame",Citymain2)

--adiciona aviao
local plane = display.newImage("jet_Test.png",40,100)
--adiciona laser
local function Fire() --falta regular
 
    local Rocket = display.newImage("Rocket.png",90,100)
    physics.addBody( newLaser, "dynamic", { isSensor=true } )
    newLaser.isBullet = true
    newLaser.myName = "laser"

    newLaser.x = plane.x
    newLaser.y = plane.y
    newLaser:toBack()

    transition.to( newLaser, { y=90, time=100,
    onComplete = function() display.remove( newLaser ) end 
    } )
end

plane:addEventListener( "tap", Fire )

 
 
