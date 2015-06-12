//
//  Block.swift
//  Stackers
//
//  Created by Bruno Omella Mainieri on 6/6/15.
//  Copyright (c) 2015 Bruno Omella & Vitor Kawai. All rights reserved.
//

import SpriteKit

class Block: SKSpriteNode {
    
    var perfeito:Bool!
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
        perfeito = false
    }
    
    init(texture:SKTexture, tam:CGSize){
        super.init(texture: texture, color: UIColor.blueColor(), size: tam)
        perfeito = false
    }
    
    func moveAround(scene: GameScene){
        var modVelocidade:Double = 2 - (0.05 * Double(scene.stackSize))
        if modVelocidade < 0.8 {
            modVelocidade = 0.8
        }
        let moveAction = SKAction.repeatActionForever(SKAction.sequence([
			SKAction.moveByX(scene.size.width-self.size.width, y: 0, duration: modVelocidade),
			SKAction.moveByX(-(scene.size.width-self.size.width), y: 0, duration: modVelocidade)
		]))
        self.runAction(moveAction)
    }
    
    
}
