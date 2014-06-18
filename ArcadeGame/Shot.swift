//
//  Shot.swift
//  ArcadeGame
//
//  Created by Logan Howard on 6/15/14.
//  Copyright (c) 2014 Logan Howard. All rights reserved.
//

import SpriteKit

class Shot: SKSpriteNode {
    var launchAngle: CGFloat = 0.0
    
    init(launchAngle: CGFloat) {
        let tex = SKTexture(imageNamed: "BasicShot")
        super.init(texture: tex, color: nil, size: tex.size())
        
        self.launchAngle = launchAngle
    }
}
