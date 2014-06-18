//
//  GameScene.swift
//  ArcadeGame
//
//  Created by Logan Howard on 6/15/14.
//  Copyright (c) 2014 Logan Howard. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let cannon = SKSpriteNode(imageNamed:"BasicCannon")
    let PI = CGFloat(M_PI)
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.whiteColor()
        
        // add cannon
        cannon.xScale = 1
        cannon.yScale = 1
        cannon.position = CGPoint(x:self.size.width/2, y:40)
        cannon.runAction(SKAction.rotateByAngle(-PI/2, duration: 0))
        
        let rotateLeft = SKAction.rotateByAngle(PI, duration: 1)
        cannon.runAction(SKAction.repeatActionForever(SKAction.sequence(
            [rotateLeft, rotateLeft.reversedAction()]
        )))
        
        self.addChild(cannon)
        
        // add physics properties
        self.physicsWorld.gravity = CGVectorMake(0, -9.8)
        let sceneBody = SKPhysicsBody(edgeLoopFromRect: self.frame) // put constraints on edges
        self.physicsBody = sceneBody
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        // called when a touch begins
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            // create new shot
            let shotSpeed = 700.0
            let shot = Shot(launchAngle: cannon.zRotation)
            shot.xScale = 1
            shot.yScale = 1
            shot.position = CGPoint( // seemingly random doubles make shots not on top of cannon
                x: cannon.position.x + 2.3 * cannon.size.width/2 * cos(cannon.zRotation + PI/2),
                y: cannon.position.y + 1.15 * cannon.size.height/2 * sin(cannon.zRotation + PI/2)
            )
            shot.runAction(SKAction.moveBy(
                CGVector(
                    dx: shotSpeed * cos(cannon.zRotation + PI/2),
                    dy: shotSpeed * sin(cannon.zRotation + PI/2)
                ),
                duration: 1
            ))
            
            self.addChild(shot)
            
            // add physics
            shot.physicsBody = SKPhysicsBody(circleOfRadius: shot.frame.size.width/2)
            shot.physicsBody.friction = 0.2
            shot.physicsBody.restitution = 0.2 // "bounciness"
            shot.physicsBody.mass = 1.0
            // allows shots to rotate when bounced
            shot.physicsBody.allowsRotation = true
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        // called before each frame is rendered
    }
}
