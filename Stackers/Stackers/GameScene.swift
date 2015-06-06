//
//  GameScene.swift
//  Stackers
//
//  Created by Bruno Omella Mainieri on 6/6/15.
//  Copyright (c) 2015 Bruno Omella & Vitor Kawai. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    //constantes
    //altura de cada bloco
    let blockHeigth:CGFloat = 30.0
    
    //variaveis que controlam a pilha de blocos
    
    //largura do bloco do topo - controla o tamanho do próximo bloco criado
    var stackWidth:CGFloat = 50.0
    //altura do bloco do topo
    var stackHeigth:CGFloat = 80.0
    //tamanho da pilha (numero de blocos)
    var stackSize:Int = 0
    //posicao do topo da pilha
    var stackPos:CGPoint!
    
    //node que representa a pilha de blocos
    var stack:SKSpriteNode!
    
    //node que é o bloco a ser colocado
    var proxBloco:Block!
    
    override func didMoveToView(view: SKView) {
        
        self.stack = SKSpriteNode(color: UIColor.blueColor(), size: CGSizeMake(stackWidth, stackHeigth))
        stack.position = CGPointMake(self.size.width/2, stackHeigth/2)
        self.addChild(stack)
        
        self.stackPos = stack.position
        
        let myLabel = SKLabelNode(fontNamed:"Helvetica")
        myLabel.text = "Stackers!";
        myLabel.fontSize = 30;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
        
        self.novoBloco()
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        var novoBloco = Block(texture: SKTexture(imageNamed: "block"), tam: CGSizeMake(self.stackWidth, self.blockHeigth))
//        novoBloco.position = CGPointMake(self.size.width/2, stackHeigth)
//        self.addChild(novoBloco)
//        self.addToStack(novoBloco)
        self.soltaBloco()
        
        
    }
    
    func addToStack(bloco: Block){
        stackSize++
        bloco.removeFromParent()
        self.stack.addChild(bloco)
        bloco.position = CGPointMake(0, blockHeigth/2 + CGFloat(stackSize)*blockHeigth)
        self.stack.runAction(SKAction.moveBy(CGVectorMake(0, -self.blockHeigth), duration: 0.5))
    }
    
    func novoBloco(){
        proxBloco = Block(texture: SKTexture(imageNamed: "block"), tam: CGSizeMake(self.stackWidth, self.blockHeigth))
        
        proxBloco.position = CGPointMake(self.stackWidth, self.size.height * 0.8)
        self.addChild(proxBloco)
        proxBloco.moveAround(self)
        
    }
    
    func soltaBloco(){
        proxBloco.removeAllActions()
        
        //se o bloco estiver pelo menos parcialmente sobre o topo da pilha
        if proxBloco.position.x < (stackPos.x + stackWidth) && (proxBloco.position.x + stackWidth) > stackPos.x {
            proxBloco.runAction(SKAction.moveToY(stack.position.y + blockHeigth/2 + CGFloat(stackSize)*blockHeigth, duration: 1.0), completion: { () -> Void in
                self.addToStack(self.proxBloco)
                self.novoBloco()
            })
            
        }
        else{
            proxBloco.runAction(SKAction.moveToY(-blockHeigth, duration: 1.0), completion: { () -> Void in
                self.novoBloco()
                //ou, sabe, perder o jogo
            })
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
