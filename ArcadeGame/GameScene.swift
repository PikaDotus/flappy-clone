//
//  GameScene.swift
//  ArcadeGame
//
//  Created by Logan Howard on 6/15/14.
//  Copyright (c) 2014 Logan Howard. All rights reserved.
//

import SpriteKit

extension SKNode {
    var isOnscreen: Bool {
        return (//self.position.x < self.scene.frame.size.width &&
                self.position.x > -self.frame.width &&
                self.position.y < self.scene.frame.height + self.frame.height &&
                self.position.y > -self.frame.height)
    }
}

class GameScene: SKScene {
    let ghost = SKSpriteNode(imageNamed: "Ghost")
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.whiteColor()
        self.size = CGSizeMake(640, 1136)
        
        // add ghost
        ghost.position = CGPointMake(self.frame.width/2.5, self.frame.height/1.5)
        ghost.xScale = 2 * 1.5
        ghost.yScale = 3 * 1.5
        self.addChild(ghost)
        
        // add physics to ghost
        ghost.physicsBody = SKPhysicsBody(circleOfRadius: ghost.frame.width/2)
        ghost.physicsBody.mass = 1.0
        
        // add physics to world
        self.physicsWorld.gravity = CGVectorMake(0, -7.5)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame) // put constraints on edges
        self.physicsBody.allowsRotation = false
    }
    
    // called when a touch begins
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let impulseForce = 500.0
        let ghostVertVeloc = ghost.physicsBody.velocity.dy
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if ghostVertVeloc < 0 { // if it's going down
                ghost.physicsBody.applyImpulse(CGVectorMake(0, -ghostVertVeloc + impulseForce))
            } else {
                ghost.physicsBody.applyImpulse(CGVectorMake(0, impulseForce))
            }
        }
    }
    
    var lastUpdateTimeInterval:CFTimeInterval?
    var timeSinceLastPipe:Double = 0 // time to get oriented
    
    // called before each frame is rendered
    override func update(currentTime: CFTimeInterval) {
        if lastUpdateTimeInterval {
            timeSinceLastPipe += currentTime - self.lastUpdateTimeInterval!
        }
        lastUpdateTimeInterval = currentTime
        
        if timeSinceLastPipe > 2.5 { // secs per pipe
            timeSinceLastPipe = 0
            
            let pipeGap = 300.0
            let pipeSpeed = -150.0
            
            // create bottom pipe
            let botPipe = SKSpriteNode(imageNamed: "Pipe")
            botPipe.anchorPoint = CGPointMake(0.0, 0.0)
            botPipe.position = CGPointMake(self.frame.width, 0)
            botPipe.runAction(SKAction.repeatActionForever(SKAction.moveBy(
                CGVectorMake(pipeSpeed, 0),
                duration: 1
            )))
            botPipe.yScale = CGFloat(arc4random_uniform(4) + UInt32(1))
            
            self.addChild(botPipe)
            
            // create top pipe
            let topPipe = SKSpriteNode(imageNamed: "Pipe")
            topPipe.runAction(SKAction.rotateByAngle(CGFloat(M_PI), duration: 0))
            topPipe.anchorPoint = CGPointMake(1.0, 0.0)
            topPipe.position = CGPointMake(self.frame.width, self.frame.height)
            topPipe.runAction(SKAction.repeatActionForever(SKAction.moveBy(
                CGVectorMake(pipeSpeed, 0),
                duration: 1
            )))
            topPipe.yScale = 5.0 - botPipe.yScale
            
            self.addChild(topPipe)
            
            // also a convinient time to scrap used pipes
            for child: AnyObject in children {
                if !child.isOnscreen {
                    child.removeFromParent()
                }
            }
        }
    }
}
