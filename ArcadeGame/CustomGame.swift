//
//  CustomGame.swift
//  ArcadeGame
//
//  Created by Logan Howard on 8/3/14.
//  Copyright (c) 2014 Logan Howard. All rights reserved.
//

import SpriteKit
import UIKit

extension SKNode {
    var onscreen: Bool {
    return (self.position.x > -self.frame.width &&
        self.position.y < self.scene.frame.height + self.frame.height &&
        self.position.y > -self.frame.height)
    }
}

class CustomGame: SKScene {
    var ghost = SKSpriteNode(imageNamed: "Kirby")
    var playing = true
    var score = -1
    var firstGame = true
    let scoreText = SKLabelNode(fontNamed: "Helvetica")
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.whiteColor()
        self.size = CGSizeMake(640, 1136)
        
        // if this is the first game go to the menu first
        if firstGame {
            newGameMenu()
        } else {
            score = 0
        }
        
        // add background
        makeNewBackground(0.0)
        
        // add ghost
        ghost.position = CGPointMake(self.frame.width/2.5, self.frame.height/1.5)
        ghost.xScale = 0.6
        ghost.yScale = 0.6
        ghost.name = "ghost"
        self.addChild(ghost)
        
        // add physics to ghost
        ghost.physicsBody = SKPhysicsBody(circleOfRadius: ghost.frame.width/2)
        ghost.physicsBody.mass = 1.0
        
        // add physics to world
        self.physicsWorld.gravity = CGVectorMake(0, -7.5)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame) // put constraints on edges
        self.physicsBody.allowsRotation = false
        
        // add score to screen
        scoreText.text = String(score)
        scoreText.name = "score"
        scoreText.fontSize = 96
        scoreText.position = CGPointMake(self.frame.width - 100, self.frame.height - 100)
        
        self.addChild(scoreText)
    }
    
    // called when a touch begins
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let impulseForce = 500.0
        let ghostVertVeloc = ghost.physicsBody.velocity.dy
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if playing {
                if ghostVertVeloc < 0 { // if it's going down
                    var force = -ghostVertVeloc + CGFloat(impulseForce)
                    ghost.physicsBody.applyImpulse(CGVectorMake(0, CGFloat(force)))
                } else {
                    ghost.physicsBody.applyImpulse(CGVectorMake(0, CGFloat(impulseForce)))
                }
            }
        }
    }
    
    var lastUpdateTimeInterval:CFTimeInterval?
    var timeSinceLastPipe:Double = 0 // time for user to "get oriented"
    var timeSinceLastBg:Double = 0
    
    // called before each frame is rendered
    override func update(currentTime: CFTimeInterval) {
        if lastUpdateTimeInterval {
            let timeDiff = currentTime - self.lastUpdateTimeInterval!
            timeSinceLastPipe += timeDiff
            timeSinceLastBg += timeDiff
        }
        lastUpdateTimeInterval = currentTime
        
        if timeSinceLastPipe > 2.5 && playing { // secs per pipe
            timeSinceLastPipe = 0
            makeNewPipeSet()
            makeNewInvis()
            
            // also a convinient time to scrap offscreen things
            for child: AnyObject in children {
                if !child.onscreen {
                    child.removeFromParent()
                }
            }
            
            // might as well do this too
            if timeSinceLastBg > 30 {
                timeSinceLastBg = 0
                makeNewBackground(Double(self.frame.width))
            }
        }
        
        if (playing) {
            checkForCollide(ghost, nodes: children)
        } else {
            for child: AnyObject in children {
                if child.name == "bg" {
                    stopMoving(child as SKNode)
                }
            }
        }
    }
    
    func makeNewInvis() {
        let moveSpeed = -150.0
        let moveAction = SKAction.repeatActionForever(SKAction.moveBy(
            CGVectorMake(CGFloat(moveSpeed), 0), duration: 1
            ))
        
        let invis = SKSpriteNode(imageNamed: "Invis")
        invis.yScale = 2
        invis.name = "invis"
        invis.runAction(moveAction)
        invis.position = CGPointMake(self.frame.width, self.frame.height/2)
        
        self.addChild(invis)
    }
    
    func stopMoving (child: SKNode) {
        let stopMoving = SKAction.repeatActionForever(SKAction.moveBy(
            CGVectorMake(0, 0), duration: 1
            ))
        
        child.runAction(stopMoving)
    }
    
    func makeNewPipeSet() {
        let pipeSpeed = -150.0
        let movePipes = SKAction.repeatActionForever(SKAction.moveBy(
            CGVectorMake(CGFloat(pipeSpeed), 0), duration: 1
            ))
        
        let botHeight = CGFloat(Int(arc4random_uniform(10)) + 1)/5.0
        let botPipe = botPipeMake("Pillar", pipeAction: movePipes, height: botHeight)
        self.addChild(botPipe)
        
        let topHeight = 2.5 - botHeight
        let topPipe = topPipeMake("Pillar", pipeAction: movePipes, height: topHeight)
        self.addChild(topPipe)
    }
    
    func makeNewBackground(startPt: Double) {
        let bgSpeed = -50.0
        let moveBg = SKAction.repeatActionForever(SKAction.moveBy(
            CGVectorMake(CGFloat(bgSpeed), 0), duration: 1
            ))
        
        let bg = SKSpriteNode(imageNamed: "Background")
        bg.anchorPoint = CGPointMake(0, 1)
        bg.position = CGPointMake(CGFloat(startPt), self.frame.height)
        bg.xScale = 2.25
        bg.yScale = 2.25
        bg.name = "bg"
        bg.runAction(moveBg)
        
        self.addChild(bg)
    }
    
    func updateScore() {
        scoreText.text = String(score)
    }
    
    func checkForCollide(mainObject: SKNode, nodes: [AnyObject]) {
        for child: AnyObject in nodes {
            // if it's a pipe and intersects the ghost
            if child.name == "pipe" && mainObject.intersectsNode(child as SKNode) {
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
            } else if child.name == "invis" && mainObject.intersectsNode(child as SKNode) {
                child.removeFromParent()
                ++score
                updateScore()
            }
        }
    }
    
    func changeToMenu() {
        let xfade = SKTransition.crossFadeWithDuration(0.75)
        xfade.pausesOutgoingScene = false
        
        let deathMenu = DeathMenu.sceneWithSize(self.size)
        deathMenu.score = score
        
        self.scene.view.presentScene(deathMenu, transition: xfade)
    }
    
    func newGameMenu() {
        let newGameMenu = DeathMenu.sceneWithSize(self.size)
        self.scene.view.presentScene(newGameMenu)
    }
    
    func botPipeMake(imageName: String, pipeAction: SKAction, height: CGFloat) -> SKSpriteNode {
        let ret = SKSpriteNode(imageNamed: imageName)
        ret.anchorPoint = CGPointMake(0.0, 0.0)
        ret.position = CGPointMake(self.frame.width, 0)
        ret.runAction(pipeAction)
        ret.yScale = height
        ret.name = "pipe"
        
        return ret
    }
    
    func topPipeMake(imageName: String, pipeAction: SKAction, height: CGFloat) -> SKSpriteNode {
        let ret = SKSpriteNode(imageNamed: imageName)
        ret.runAction(SKAction.rotateByAngle(CGFloat(M_PI), duration: 0))
        ret.anchorPoint = CGPointMake(1.0, 0.0)
        ret.position = CGPointMake(self.frame.width, self.frame.height)
        ret.runAction(pipeAction)
        ret.yScale = height
        ret.name = "pipe"
        
        return ret
    }
}
