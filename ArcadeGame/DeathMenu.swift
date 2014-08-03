//
//  DeathMenu.swift
//  ArcadeGame
//
//  Created by Logan Howard on 6/24/14.
//  Copyright (c) 2014 Logan Howard. All rights reserved.
//

import SpriteKit

class DeathMenu: SKScene {
    let restart = SKShapeNode(rectOfSize: CGSizeMake(600, 150), cornerRadius: 75)
    let leaderboard = SKShapeNode(rectOfSize: CGSizeMake(600, 150), cornerRadius: 75)
    let play = SKShapeNode(rectOfSize: CGSizeMake(600, 150), cornerRadius: 75)
    let restartLabel = SKLabelNode()
    let leaderboardLabel = SKLabelNode()
    let playLabel = SKLabelNode()
    let scoreLabel = SKLabelNode()
    var score = -1
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red: 0.94/3.0, green: 0.50/3.0, blue: 0.50/3.0, alpha: 1)
        
        // EW MUST REFACTOR THIS
        
        // add score label
        scoreLabel.fontName = "Helvetica"
        scoreLabel.text = "a mere " + String(score)
        scoreLabel.fontSize = 124
        scoreLabel.fontColor = UIColor.whiteColor()
        scoreLabel.verticalAlignmentMode = .Center
        scoreLabel.position = CGPointMake(self.frame.width/2, self.frame.height - 120)
        
        // add leaderboard button
        leaderboard.position = CGPointMake(self.frame.width/2, self.frame.height/2 + self.frame.height/6)
        leaderboard.strokeColor = UIColor.clearColor()
        leaderboard.fillColor = UIColor.yellowColor()
        // and its label
        leaderboardLabel.fontName = "Helvetica"
        leaderboardLabel.text = "Leaderboards"
        leaderboardLabel.fontSize = 84
        leaderboardLabel.fontColor = UIColor.blackColor()
        leaderboardLabel.position = CGPointMake(self.frame.width/2, self.frame.height/2 + self.frame.height/6)
        leaderboardLabel.verticalAlignmentMode = .Center
        
        // add restart button
        restart.position = CGPointMake(self.frame.width/2, self.frame.height/2 - self.frame.height/6)
        restart.strokeColor = UIColor.clearColor()
        restart.fillColor = UIColor.greenColor()
        // and its label
        restartLabel.fontName = "Helvetica"
        if score < 0 {
            restartLabel.text = "Play"
        } else {
            restartLabel.text = "Restart"
        }
        restartLabel.fontSize = 84
        restartLabel.fontColor = UIColor.blackColor()
        restartLabel.position = CGPointMake(self.frame.width/2, self.frame.height/2 - self.frame.height/6)
        restartLabel.verticalAlignmentMode = .Center
        
        if (score >= 0) {
            self.addChild(scoreLabel)
        }
        self.addChild(leaderboard)
        self.addChild(leaderboardLabel)
        self.addChild(restart)
        self.addChild(restartLabel)
    }
    
    // called when a touch begins
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if leaderboard.containsPoint(location) {
                
            }
            
            if restart.containsPoint(location) {
                newGame(false)
            }
        }
    }
    
    // called before each frame is rendered
    override func update(currentTime: CFTimeInterval) {
    }
    
    func newGame(firstGame: Bool) {
        let xfade = SKTransition.crossFadeWithDuration(0.25)
        xfade.pausesOutgoingScene = false
        
        let gameScene = GameScene.sceneWithSize(self.size)
        gameScene.firstGame = firstGame
        
        self.scene.view.presentScene(gameScene, transition: xfade)
    }
}
