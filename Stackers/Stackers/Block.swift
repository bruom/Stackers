//
//  Block.swift
//  Stackers
//
//  Created by Bruno Omella Mainieri on 6/6/15.
//  Copyright (c) 2015 Bruno Omella & Vitor Kawai. All rights reserved.
//

import SpriteKit

class Block: SKSpriteNode {
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(texture:SKTexture, tam:CGSize){
        super.init(texture: texture, color: UIColor.blueColor(), size: tam)
    }
    
    func moveAround(scene: GameScene){
        let moveAction = SKAction.repeatActionForever(SKAction.sequence([
			SKAction.moveByX(scene.size.width-self.size.width, y: 0, duration: 2),
			SKAction.moveByX(-(scene.size.width-self.size.width), y: 0, duration: 2)
		]))
        self.runAction(moveAction)
    }
    
    
}
