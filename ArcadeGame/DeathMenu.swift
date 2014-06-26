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
    let menu = SKShapeNode(rectOfSize: CGSizeMake(600, 150), cornerRadius: 75)
    let restartLabel = SKLabelNode()
    let leaderboardLabel = SKLabelNode()
    let menuLabel = SKLabelNode()
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red: 0.94/3.0, green: 0.50/3.0, blue: 0.50/3.0, alpha: 1)
        
        // EW MUST REFACTOR THIS
        
        // add menu button
        menu.position = CGPointMake(self.frame.width/2, self.frame.height/2 + self.frame.height/4)
        menu.strokeColor = UIColor.clearColor()
        menu.fillColor = UIColor.redColor()
        self.addChild(menu)
        // and its label
        menuLabel.fontName = "Helvetica"
        menuLabel.text = "Main Menu"
        menuLabel.fontSize = 84
        menuLabel.fontColor = UIColor.blackColor()
        menuLabel.position = CGPointMake(self.frame.width/2, self.frame.height/2 + self.frame.height/4)
        menuLabel.verticalAlignmentMode = .Center
        self.addChild(menuLabel)
        
        // add leaderboard button
        leaderboard.position = CGPointMake(self.frame.width/2, self.frame.height/2)
        leaderboard.strokeColor = UIColor.clearColor()
        leaderboard.fillColor = UIColor.yellowColor()
        self.addChild(leaderboard)
        // and its label
        leaderboardLabel.fontName = "Helvetica"
        leaderboardLabel.text = "Leaderboards"
        leaderboardLabel.fontSize = 84
        leaderboardLabel.fontColor = UIColor.blackColor()
        leaderboardLabel.position = CGPointMake(self.frame.width/2, self.frame.height/2)
        leaderboardLabel.verticalAlignmentMode = .Center
        self.addChild(leaderboardLabel)
        
        // add restart button
        restart.position = CGPointMake(self.frame.width/2, self.frame.height/2 - self.frame.height/4)
        restart.strokeColor = UIColor.clearColor()
        restart.fillColor = UIColor.greenColor()
        self.addChild(restart)
        // and its label
        restartLabel.fontName = "Helvetica"
        restartLabel.text = "Restart"
        restartLabel.fontSize = 84
        restartLabel.fontColor = UIColor.blackColor()
        restartLabel.position = CGPointMake(self.frame.width/2, self.frame.height/2 - self.frame.height/4)
        restartLabel.verticalAlignmentMode = .Center
        self.addChild(restartLabel)
    }
    
    // called when a touch begins
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            
        }
    }
    
    // called before each frame is rendered
    override func update(currentTime: CFTimeInterval) {
    }
}
