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
        return (self.position.x > -self.frame.width &&
                self.position.y < self.scene.frame.height + self.frame.height &&
                self.position.y > -self.frame.height)
    }
}

class GameScene: SKScene {
    let ghost = SKSpriteNode(imageNamed: "Ghost")
    var playing = true
    
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
            
            if playing {
                if ghostVertVeloc < 0 { // if it's going down
                    ghost.physicsBody.applyImpulse(CGVectorMake(0, -ghostVertVeloc + impulseForce))
                } else {
                    ghost.physicsBody.applyImpulse(CGVectorMake(0, impulseForce))
                }
            }
        }
    }
    
    var lastUpdateTimeInterval:CFTimeInterval?
    var timeSinceLastPipe:Double = 0 // time for user to "get oriented"
    
    // called before each frame is rendered
    override func update(currentTime: CFTimeInterval) {
        if lastUpdateTimeInterval {
            timeSinceLastPipe += currentTime - self.lastUpdateTimeInterval!
        }
        lastUpdateTimeInterval = currentTime
        
        if timeSinceLastPipe > 2.5 && playing { // secs per pipe
            timeSinceLastPipe = 0
            makeNewPipeSet()
            
            // also a convinient time to scrap used pipes
            for pipe: AnyObject in children {
                if !pipe.isOnscreen {
                    pipe.removeFromParent()
                }
            }
        }
        
        if (playing) {
            checkForCollide(ghost, nodes: children)
        }
    }
    
    func makeNewPipeSet() {
        let pipeSpeed = -150.0
        let movePipes = SKAction.repeatActionForever(SKAction.moveBy(
            CGVectorMake(pipeSpeed, 0), duration: 1
            ))
        
        let botHeight = CGFloat(arc4random_uniform(4) + UInt32(1))
        let botPipe = botPipeMake("Pipe", pipeAction: movePipes, height: botHeight)
        self.addChild(botPipe)
        
        let topHeight = 5.0 - botHeight
        let topPipe = topPipeMake("Pipe", pipeAction: movePipes, height: topHeight)
        self.addChild(topPipe)
    }
    
    func checkForCollide(mainObject: SKNode, nodes: AnyObject[]) {
        for child: AnyObject in nodes {
            // if it's a pipe and intersects the ghost
            if child as SKNode != mainObject && mainObject.intersectsNode(child as SKNode) {
                self.physicsWorld.gravity = CGVectorMake(0, -100)
                playing = false
                
                // remove all pipes
                for pipe: AnyObject in nodes {
                    if pipe as SKNode != mainObject {
                        pipe.removeFromParent()
                    }
                }
                
                changeToMenu()
                
                break
            }
        }
    }
    
    func changeToMenu() {
        let xfade = SKTransition.crossFadeWithDuration(0.75)
        xfade.pausesOutgoingScene = false
        
        let deathMenu = DeathMenu.sceneWithSize(self.size)
        
        self.scene.view.presentScene(deathMenu, transition: xfade)
    }
    
    func botPipeMake(imageName: String, pipeAction: SKAction, height: CGFloat) -> SKSpriteNode {
        let ret = SKSpriteNode(imageNamed: imageName)
        ret.anchorPoint = CGPointMake(0.0, 0.0)
        ret.position = CGPointMake(self.frame.width, 0)
        ret.runAction(pipeAction)
        ret.yScale = height
        
        return ret
    }
    
    func topPipeMake(imageName: String, pipeAction: SKAction, height: CGFloat) -> SKSpriteNode {
        let ret = SKSpriteNode(imageNamed: imageName)
        ret.runAction(SKAction.rotateByAngle(CGFloat(M_PI), duration: 0))
        ret.anchorPoint = CGPointMake(1.0, 0.0)
        ret.position = CGPointMake(self.frame.width, self.frame.height)
        ret.runAction(pipeAction)
        ret.yScale = height
        
        return ret
    }
}
