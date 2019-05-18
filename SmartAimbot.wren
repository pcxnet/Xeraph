import "API" for IEvent, IEntity, IGraphicsListener, Engine, EventType, Graphics, Vec3, Vec2, OS
import "CoreTargetResolver" for ITargetResolver, TargetResolver

class AimSettings {
	construct new() {
		_keys = {
            "LB": 0x01,
            "RB": 0x02,
            "LS": 0xA0
        }
		_heroes = {
            64: "RoadHog",
            41: "Genji",
            122: "Dva",
            318: "Orisa",
            7: "Reinhardt",
            9: "Winston",
            458: "Ball",
            104: "Zarya",
            512: "Ashe",
            21: "Bastion",
            303: "Doomfist",
            5: "Hanzo",
            101: "Junkrat",
            66: "Mccree",
            221: "Mei",
            8: "Pharah",
            2: "Reaper",
            110: "Soldier76",
            302: "Sombra",
            22: "Symmetra",
            6: "Torbjorn",
            3: "Tracer",
            10: "Widowmaker",
            315: "Ana",
            545: "Baptiste",
            405: "Brigitte",
            121: "Lucio",
            4: "Mercy",
            418: "Moira",
            32: "Zenyatta",
        }

        _dmg = {
            64: "RoadHog",
            41: "Genji",
            122: "Dva",
            318: "Orisa",
            7: "Reinhardt",
            9: "Winston",
            458: "Ball",
            104: "Zarya",
            512: "Ashe",
            21: "Bastion",
            303: "Doomfist",
            5: "Hanzo",
            101: "Junkrat",
            66: "Mccree",
            221: "Mei",
            8: "Pharah",
            2: "Reaper",
            110: "Soldier76",
            302: "Sombra",
            22: "Symmetra",
            6: "Torbjorn",
            3: "Tracer",
            10: "Widowmaker",
            315: "Ana",
            545: "Baptiste",
            405: "Brigitte",
            121: "Lucio",
            4: "Mercy",
            418: "Moira",
            32: "Zenyatta",
        }
	} 
	keys { _keys }
	heroes { _heroes }
	dmg { _dmg }
}


class Common {
	static viewPortToScreenX(x) {
		return Graphics.screenWidth * (x + 1)/2
	}

	static viewPortToScreenY(y) {
		return Graphics.screenHeight * (1 - y)/2
	}
  
	static screenToViewPort(x,y) {
		return Vec3.new(2 * (x/Graphics.screenWidth) - 1,-2 * (y/Graphics.screenHeight) + 1,0)
	}

	static entityHealthPercent(ent) {
		return (ent.health/ent.healthMax) * 100
	}

	static dotProduct(vec1,vec2) {   
     return (vec1.x * vec2.x) + (vec1.y * vec2.y) + (vec1.z * vec2.z)
    }

    static crossProduct(vec1,vec2) {
     var x = vec1.y * vec2.z - vec1.z * vec2.y
     var y = vec1.z * vec2.x - vec1.x * vec2.z
     var z = vec1.x * vec2.y - vec1.y * vec2.x
     return Vec3.new(x,y,z)
    }

    static lengthSqr2D(vec1) {
    return (vec1.x * vec1.x) + (vec1.y * vec1.y)
    }

//Thanks to dev with no profile name in discord
     static multiplyVectors(vec1, vec2) {
     return Vec3.new(vec1.x * vec2.x, vec1.y * vec2.y, vec1.z * vec2.z)
     }

     static multiplyVectors2D(vec1, n) {
     return Vec2.new(vec1.x * n, vec1.y * n)
     }

    static addVectors(vec1, vec2) {
     return Vec3.new(vec1.x + vec2.x, vec1.y + vec2.y, vec1.z + vec2.z)
    }
    static addVectors2D(vec1, vec2) {
     return Vec2.new(vec1.x + vec2.x, vec1.y + vec2.y)
    }
    static subtractVectors(vec1, vec2) {
     var res = Vec3.new(vec1.x - vec2.x, vec1.y - vec2.y, vec1.z - vec2.z)
     return res
    }
    static subtractVectors2D(vec1, vec2) {
     var res = Vec2.new(vec1.x - vec2.x, vec1.y - vec2.y)
     return res
    }
    static multiplyVectorN(vec1, n) {
     return Vec3.new(vec1.x * n, vec1.y * n, vec1.z * n)
    }
    static drawCircle(x,y,r2,c) {
       x = Graphics.screenWidth * (x + 1)/2
       y = Graphics.screenHeight * (1 - y)/2
        var xf = null
        var yf = null
        for(i in 1..64) {
            var ang = i / 30 * Num.pi
            var xt = x + r2 * ang.cos
            var yt = y + r2 * ang.sin
            if(xf != null) {
            var res1 = Vec3.new(2 * (xt/Graphics.screenWidth) - 1,-2 * (yt/Graphics.screenHeight) + 1,0)
            var res2 = Vec3.new(2 * (xf/Graphics.screenWidth) - 1,-2 * (yf/Graphics.screenHeight) + 1,0)
                Graphics.addLine(res1.x,res1.y,c,res2.x,res2.y,c)
            }
            xf = xt
            yf = yt
        }
    }
    static drawFov(radius,drawfov) {
    	var tc = Graphics.colorARGB(255,255,255,255)
    	var screenM = Vec2.new(0,0)
    	if(drawfov) {
    	drawCircle(screenM.x, screenM.y, radius, tc)
        }
    }

}

class AimBot {
   static aimTarget(x,y,speed) {
    var targetX = 0
	var	targetY = 0
    x = Graphics.screenWidth * (x + 1)/2
    y = Graphics.screenHeight * (1 - y)/2
    if(x != 0) {
        if(x > Graphics.screenWidth / 2) {
            targetX = -(Graphics.screenWidth / 2 - x)
            targetX = targetX / speed
            if(targetX + Graphics.screenWidth / 2 > Graphics.screenWidth / 2 * 2) {
            targetX = 0
            }
        }
        if (x < Graphics.screenWidth / 2) {
            targetX = x - Graphics.screenWidth / 2
            targetX = targetX /speed
            if (targetX + Graphics.screenWidth / 2 < 0) {
            targetX = 0
           }
        }
    }
  
    if (y != 0) {
         if (y > Graphics.screenHeight / 2) {
                targetY = -(Graphics.screenHeight / 2 - y)
                targetY = targetY /speed
                if (targetY + Graphics.screenHeight / 2 > Graphics.screenHeight / 2 * 2) {
                targetY = 0
                }
            }

            if (y < Graphics.screenHeight / 2) {
                targetY = y - Graphics.screenHeight / 2
                targetY = targetY /speed
                if (targetY + Graphics.screenHeight / 2 < 0) {
                targetY = 0            
                }
            }
        }
        var checkPos = Vec2.new(targetX,targetY)
        var currentPos = Vec2.new(x,y)
        var ppPos = checkPos
        var ppPos2 = Common.multiplyVectors2D(ppPos,0.56)
        var ppPos3 = Common.addVectors2D(ppPos2,checkPos)
        //var predPos = Common.addVectors2D(Common.multiplyVectors2D(Common.subtractVectors2D(checkPos,currentPos).normalized(),220),currentPos)
        if(checkPos.validate()){
        OS.moveMouse(checkPos.x,checkPos.y)
        }     
    }

    static getClosestEnemy() {
    	var	lowestDistance = 99999
	    var	closestPlayer = null
        for(currentPlayer in Engine.getEnemies()) {
        var currentPlayerPos = currentPlayer.headPosition.project()
        var curP = Vec2.new(currentPlayerPos.x,currentPlayerPos.y)
        var sP = Vec2.new(0, 0)
        var currentPlayerDistance = curP.distTo(sP)

        if(currentPlayerDistance < lowestDistance) {
            lowestDistance = currentPlayerDistance
            closestPlayer = currentPlayer
        }
      }

     if(closestPlayer != null && closestPlayer.validate() && closestPlayer.health > 0 && closestPlayer.isVisible){        
        return closestPlayer
     }

    }

    static pointInCircle(point,cirCenter,radius) {
        var x = Graphics.screenWidth * (cirCenter.x + 1)/2
        var y = Graphics.screenHeight * (1 - cirCenter.y)/2
        var cirScreen = Vec2.new(x,y)
    	var res = (((cirScreen.x - point.x) * (cirScreen.x - point.x)) + ((cirScreen.y - point.y) * (cirScreen.y - point.y)))
    	System.print("%(res.sqrt)")
    	return res.sqrt < radius
    }
    static aimTar(currentPlayer) {
    	var bonePos = currentPlayer.headPosition.project()
    	var x = Graphics.screenWidth * (bonePos.x + 1)/2
        var y = Graphics.screenHeight * (1 - bonePos.y)/2
        return Vec2.new(x,y)
    }

    
    static shootClosestEnemy(keyDown,speed) {
    	var	lowestDistance = 99999
	    var	closestPlayer = null
        for(currentPlayer in Engine.getEnemies()) {
        var currentPlayerPos = currentPlayer.headPosition.project()
        var curP = Vec2.new(currentPlayerPos.x,currentPlayerPos.y)
        var sP = Vec2.new(0, 0)
        var currentPlayerDistance = curP.distTo(sP)

        if(currentPlayerDistance < lowestDistance) {
            lowestDistance = currentPlayerDistance
            closestPlayer = currentPlayer
        }
    }
    if(closestPlayer != null && closestPlayer.validate() && closestPlayer.health > 0 && closestPlayer.isVisible){        
        var bonePos = closestPlayer.headPosition.project() //_closestPlayer.getBonePosition(2).project() 
         if(OS.isKeyDown(keyDown)){
             aimTarget(bonePos.x,bonePos.y,speed)  
         }   
    }

  }
  
  static shootClosestFov(keyDown,speed,fov,drawfov) {
        Common.drawFov(fov,drawfov)
    	var	lowestDistance = 99999
	    var	closestPlayer = null
        for(currentPlayer in Engine.getEnemies()) {
        var currentPlayerPos = currentPlayer.headPosition.project()
        var curP = Vec2.new(currentPlayerPos.x,currentPlayerPos.y)
        var sP = Vec2.new(0, 0)
        var currentPlayerDistance = curP.distTo(sP)

        if(currentPlayerDistance < lowestDistance) {
            lowestDistance = currentPlayerDistance
            closestPlayer = currentPlayer
        }
    }
    if(closestPlayer != null && closestPlayer.validate() && closestPlayer.health > 0 && closestPlayer.isVisible){        
        var bonePos = closestPlayer.headPosition.project()
        var sP2 = Vec2.new(0, 0)
        var head = aimTar(closestPlayer) //_closestPlayer.getBonePosition(2).project() 
         if(OS.isKeyDown(keyDown) && pointInCircle(head,sP2,fov)){
             aimTarget(bonePos.x,bonePos.y,speed)  
         }   
    }

  }
  
 
 
  static shootClosestEnemyAna(keyDown,speed) {
    	var	lowestDistance = 99999
	    var	closestPlayer = null
        for(currentPlayer in Engine.getEnemies()) {
        var currentPlayerPos = currentPlayer.headPosition.project()
        var curP = Vec2.new(currentPlayerPos.x,currentPlayerPos.y)
        var sP = Vec2.new(0, 0)
        var currentPlayerDistance = curP.distTo(sP)

        if(currentPlayerDistance < lowestDistance) {
            lowestDistance = currentPlayerDistance
            closestPlayer = currentPlayer
        }
    }
    if(closestPlayer != null && closestPlayer.validate() && closestPlayer.health > 0 && closestPlayer.isVisible){        
        var bonePos = closestPlayer.getBonePosition(2).project() //_closestPlayer.getBonePosition(2).project() 
         if(OS.isKeyDown(keyDown)){
             aimTarget(bonePos.x,bonePos.y,speed)  
         }   
    }

  }

  static shootVisableEnemy(keyDown,speed) {
    	var	lowestDistance = 0
	    var	closestPlayer = null
        for(currentPlayer in Engine.getEnemies()) {
        var currentPlayerPos = currentPlayer.headPosition.project()
        var curP = Vec2.new(currentPlayerPos.x,currentPlayerPos.y)
        var sP = Vec2.new(0, 0)
        var currentPlayerDistance = curP.distTo(sP)

        if(currentPlayer.isVisible && currentPlayer.health > lowestDistance) {
            lowestDistance = currentPlayerDistance
            closestPlayer = currentPlayer
        }
    }
    if(closestPlayer != null && closestPlayer.validate() && closestPlayer.health > 0 && closestPlayer.isVisible){        
        var bonePos = closestPlayer.headPosition.project() //_closestPlayer.getBonePosition(2).project() 
         if(OS.isKeyDown(keyDown)){
             aimTarget(bonePos.x,bonePos.y,speed)  
         }   
    }

  }

  static healClosestAlly(keyDown,speed) {
    	var	lowestDistance = 99999
	    var	closestPlayer = null
        for(currentPlayer in Engine.getAllies()) {
        var currentPlayerPos = currentPlayer.basePosition.project()
        var curP = Vec2.new(currentPlayerPos.x,currentPlayerPos.y)
        var sP = Vec2.new(0, 0)
        var currentPlayerDistance = curP.distTo(sP)

        if(currentPlayerDistance < lowestDistance) {
            lowestDistance = currentPlayerDistance
            closestPlayer = currentPlayer
        }
    }
    if(closestPlayer != null && closestPlayer.validate() && closestPlayer.health > 0 && closestPlayer.isVisible){        
        var bonePos = closestPlayer.headPosition.project() //_closestPlayer.getBonePosition(2).project() 
         if(OS.isKeyDown(keyDown)){
             aimTarget(bonePos.x,bonePos.y,speed)  
         }   
    }

  }

  static heallowestAlly(keyDown,speed) {
    	var	lowestHealth = 99999
	    var	closestPlayer = null
        for(currentPlayer in Engine.getAllies()) {
        var currentPlayerHealth = currentPlayer.health + currentPlayer.shield

        if(currentPlayerHealth < lowestHealth) {
            lowestHealth = currentPlayerHealth
            closestPlayer = currentPlayer
        }
    }
    if(closestPlayer != null && closestPlayer.validate() && closestPlayer.health > 0 && closestPlayer.isVisible){        
        var bonePos = closestPlayer.basePosition.project() //_closestPlayer.getBonePosition(2).project() 
         if(OS.isKeyDown(keyDown)){
             aimTarget(bonePos.x,bonePos.y,speed)  
         }   
    }

  }

  static logicShoot(keyDown,keyDown2,sleepSpeed,healSpeed,shootSpeed) {
  	    var	lowestHealth = 99999
	    var	closestPlayer = null
        for(currentPlayer in Engine.getAllies()) {
        var currentPlayerHealth = currentPlayer.health + currentPlayer.shield

        if(currentPlayerHealth < lowestHealth) {
            lowestHealth = currentPlayerHealth
            closestPlayer = currentPlayer
        }
    }
    if(OS.isKeyDown(keyDown2)) {
    	shootClosestEnemyAna(keyDown2,sleepSpeed)
    }
    if(closestPlayer != null && closestPlayer.validate() && closestPlayer.health > 0 && closestPlayer.isVisible && Common.entityHealthPercent(closestPlayer) < 75 ){        
        var bonePos = closestPlayer.getBonePosition(2).project() 
         if(OS.isKeyDown(keyDown)){
             aimTarget(bonePos.x,bonePos.y,healSpeed)  
         }   
    } else {
    	if(OS.isKeyDown(keyDown)){
    	shootClosestEnemyAna(keyDown,shootSpeed)
    }
    }
  }

   static logicShoot2(keyDown,keyDown2,sleepSpeed,healSpeed,shootSpeed) {
  	   var	lowestDistance = 99999
	    var	closestPlayer = null
        for(currentPlayer in Engine.getAllies()) {
        var currentPlayerPos = currentPlayer.basePosition.project()
        var curP = Vec2.new(currentPlayerPos.x,currentPlayerPos.y)
        var sP = Vec2.new(0, 0)
        var currentPlayerDistance = curP.distTo(sP)

        if(currentPlayerDistance < lowestDistance) {
            lowestDistance = currentPlayerDistance
            closestPlayer = currentPlayer
        }
    }
    if(OS.isKeyDown(keyDown2)) {
    	shootClosestEnemyAna(keyDown2,sleepSpeed)
    }
    if(closestPlayer != null && closestPlayer.validate() && closestPlayer.health > 0 && closestPlayer.isVisible && Common.entityHealthPercent(closestPlayer) < 75 ){        
        var bonePos = closestPlayer.getBonePosition(2).project() 
         if(OS.isKeyDown(keyDown)){
             aimTarget(bonePos.x,bonePos.y,healSpeed)  
         }   
    } else {
    	if(OS.isKeyDown(keyDown)){
    	shootClosestEnemyAna(keyDown,shootSpeed)
    }
    }
  }
}

class Global {
    static init() {   
		if(!__AimSettings) {
			__AimSettings = AimSettings.new()
		}
    }
	static AimSettings { __AimSettings }
}

class GraphicsEvent is IGraphicsListener {
	static onDraw() {
    var key = Global.AimSettings.keys["LB"]
    var speed = 5.5  // 1 - 100 smoothing
    var fov = 25
    var drawfov = true
    var localPlayer = Engine.getLocalPlayer()
    //Future Pred Based Aimbot
    if (Global.AimSettings.heroes[localPlayer.heroId] == "Genji") {
          key = Global.AimSettings.keys["LB"]
          speed = 9.5
          
          //AimBot.shootClosestEnemy(key,speed)
    }
    if (Global.AimSettings.heroes[localPlayer.heroId] == "Torbjorn") {
          key = Global.AimSettings.keys["LB"]
          speed = 4.5
          
          //AimBot.shootClosestEnemy(key,speed)
    }
    if (Global.AimSettings.heroes[localPlayer.heroId] == "Hanzo") {
          key = Global.AimSettings.keys["LB"]
          speed = 4.5
          
          //AimBot.shootClosestEnemy(key,speed)
    }
    if (Global.AimSettings.heroes[localPlayer.heroId] == "Mei") {
          key = Global.AimSettings.keys["LB"]
          speed = 4.5
          
          //AimBot.shootClosestEnemy(key,speed)
    }
    if (Global.AimSettings.heroes[localPlayer.heroId] == "Mercy") {
          key = Global.AimSettings.keys["LB"]
          speed = 4.5
          
          //AimBot.shootClosestEnemy(key,speed)
    }
    if (Global.AimSettings.heroes[localPlayer.heroId] == "Lucio") {
          key = Global.AimSettings.keys["LB"]
          speed = 4.5
          
          //AimBot.shootClosestEnemy(key,speed)
    }
    if (Global.AimSettings.heroes[localPlayer.heroId] == "Zenyatta") {
          key = Global.AimSettings.keys["LB"]
          speed = 4.5
          
          //AimBot.shootClosestEnemy(key,speed)
    }
    
    //Flick Based Aimbot
    if (Global.AimSettings.heroes[localPlayer.heroId] == "Mccree") {
          key = Global.AimSettings.keys["LB"]
          speed = 3
          fov = 100         
            //Aimbot.shootNearCrossHairFov(key,speed,fov)
            AimBot.shootClosestFov(key,speed,fov,drawfov)
          //AimBot.shootClosestEnemy(key,speed)       
    }

    //FPS Aimbot
    if (Global.AimSettings.heroes[localPlayer.heroId] == "Tracer") {
          key = Global.AimSettings.keys["LB"]
          speed = 12
          fov = 100

          AimBot.shootClosestFov(key,speed,fov,drawfov)
    }
    if (Global.AimSettings.heroes[localPlayer.heroId] == "Soldier76") {
          key = Global.AimSettings.keys["LB"]
          speed = 12
          fov = 100

          AimBot.shootClosestFov(key,speed,fov,drawfov)
    }
    if (Global.AimSettings.heroes[localPlayer.heroId] == "Bastion") {
          key = Global.AimSettings.keys["LB"]
          speed = 12
          fov = 100

          AimBot.shootClosestFov(key,speed,fov,drawfov)
    }
    if (Global.AimSettings.heroes[localPlayer.heroId] == "Dva") {
          key = Global.AimSettings.keys["LB"]
          speed = 10
          fov = 100

          AimBot.shootClosestFov(key,speed,fov,drawfov)
    }
    if (Global.AimSettings.heroes[localPlayer.heroId] == "Orisa") {
          key = Global.AimSettings.keys["LB"]
          speed = 10
          fov = 100

          AimBot.shootClosestFov(key,speed,fov,drawfov)
    }
    if (Global.AimSettings.heroes[localPlayer.heroId] == "Reaper") {
          key = Global.AimSettings.keys["LB"]
          speed = 10
          fov = 100

          AimBot.shootClosestFov(key,speed,fov,drawfov)
    }
     if (Global.AimSettings.heroes[localPlayer.heroId] == "Sombra") {
          key = Global.AimSettings.keys["LB"]
          speed = 10
          fov = 100

          AimBot.shootClosestFov(key,speed,fov,drawfov)
    }

    //Smart Logic/Adaptive Smoothing Aimbot
    if (Global.AimSettings.heroes[localPlayer.heroId] == "Ana") {
          key = Global.AimSettings.keys["LB"]
      var key2 = Global.AimSettings.keys["LS"]
      var sleepSpeed = 1.5 ////speed when using your sleep
      var healSpeed = 2.5 //speed to heal allies
          speed = 4.5 //speed to hit enemies

          AimBot.logicShoot2(key,key2,sleepSpeed,healSpeed,speed)
    }
    if (Global.AimSettings.heroes[localPlayer.heroId] == "Widowmaker") {
          key = Global.AimSettings.keys["LB"]
          var key2 = Global.AimSettings.keys["RB"]
          var speed2 = 10 //Speed without scoping
          speed = 1.2 //speed with scoping
          fov = 100
          
          if(OS.isKeyDown(key2)) {
             Common.drawFov(fov * 2,drawfov)
          }
          if(!OS.isKeyDown(key2)) {
            Common.drawFov(fov,drawfov)  
          }
          
          if(OS.isKeyDown(key2) && OS.isKeyDown(key)){
          AimBot.shootClosestFov(key,speed,fov * 2,false)
          }
          if(OS.isKeyDown(key)) {
      	     AimBot.shootClosestFov(key,speed2,fov,false)
          }
    }
    if (Global.AimSettings.heroes[localPlayer.heroId] == "Ashe") {
          key = Global.AimSettings.keys["LB"]
          var key2 = Global.AimSettings.keys["RB"]
          var speed2 = 7.5 //Speed without scoping
          speed = 3.5 //speed with scoping
          
          if(OS.isKeyDown(key2)) {
             Common.drawFov(fov * 2,drawfov)
          }
          if(!OS.isKeyDown(key2)) {
            Common.drawFov(fov,drawfov)  
          }
          
          if(OS.isKeyDown(key2) && OS.isKeyDown(key)){
           AimBot.shootClosestFov(key,speed,fov * 2,false)
          }
          if(OS.isKeyDown(key)) {
      	      AimBot.shootClosestFov(key,speed2,fov,false)
          }
    }

     //AimBot.shootClosestEnemy(key,12)
   

  }
}
Global.init()
Graphics.registerListener(GraphicsEvent)
