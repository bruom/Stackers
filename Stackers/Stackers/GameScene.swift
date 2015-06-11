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
    //margem aceitavel para acerto perfeito
    let deltaPerfeito:CGFloat = 10.0
    //tamanho bonus para cada acerto perfeito
    let bonusWidth:CGFloat = 15.0
    //altura de cada bloco
    let blockHeigth:CGFloat = 30.0
    
    //variaveis que controlam a pilha de blocos
    
    //largura do bloco do topo - controla o tamanho do próximo bloco criado
    var stackWidth:CGFloat = 80.0
    //altura do bloco do topo
    var stackHeigth:CGFloat = 180.0
    //tamanho da pilha (numero de blocos)
    var stackSize:Int = 0
    //posicao do topo da pilha
    var stackPos:CGPoint!
    
    //node que representa a pilha de blocos
    var stack:SKSpriteNode!
    
    //node que é o bloco no topo
    var topo:SKSpriteNode!
    
    //node que é o bloco a ser colocado
    var proxBloco:Block!
    
    
    //debug
    //var debugNode:SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        
        self.stack = SKSpriteNode(color: UIColor.blueColor(), size: CGSizeMake(stackWidth, stackHeigth))
        stack.position = CGPointMake(self.size.width/2, stackHeigth/2)
        self.addChild(stack)
        
        topo = stack
        
        self.stackPos = stack.position
        
//        debugNode = SKSpriteNode(color: UIColor.greenColor(), size: CGSizeMake(stackWidth, blockHeigth))
//        debugNode.position = CGPointMake(stackPos.x, stackHeigth)
//        self.addChild(debugNode)
        
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

    //ta tudo ruim isso aqui, tem que arrumar
    func addToStack(bloco: Block){
        stackSize++
        
        //valores relativos ao topo da pilha antes da adição do novo bloco
        var oldWidth = stackWidth
        var leftEdge = stackPos.x - stackWidth/2
        var rightEdge = stackPos.x + stackWidth/2

//        println("Left: \(leftEdge)")
//        println("Mid: \(stackPos.x)")
//        println("Right: \(rightEdge)")
//        if rightEdge - leftEdge == stackWidth {
//            println("OK")
//        }
        
        //a partir daqui, stackWidth se refere ao novo bloco no topo da pilha
        let blocoCortado = self.cortaBloco(bloco)
    
        var blocoXRelativo:CGFloat
        
        
        //o stackPos ta certo, o blocoXRelativo ta broken
        if bloco.position.x <= stackPos.x {
            self.stackPos = CGPointMake(leftEdge + stackWidth/2, stackPos.y)
            blocoXRelativo = (bloco.position.x - stackPos.x) + stackWidth/2
        }
        else{
            self.stackPos = CGPointMake(rightEdge - stackWidth/2, stackPos.y)
            blocoXRelativo = rightEdge - leftEdge - stackWidth/2
        }
        
        bloco.removeFromParent()
        
        blocoCortado.position = CGPointMake(stackPos.x - leftEdge - oldWidth/2, blockHeigth)///2 + CGFloat(stackSize)*blockHeigth)
        
//        blocoCortado.position = CGPointMake(stackPos.x - leftEdge - oldWidth/2, blockHeigth/2 + CGFloat(stackSize)*blockHeigth)
        self.topo.addChild(blocoCortado)
        if blocoCortado.perfeito == true {
            blocoCortado.runAction(SKAction.resizeToWidth(blocoCortado.size.width + bonusWidth, duration: 0.1))
            stackWidth += bonusWidth
        }
        self.topo = blocoCortado
        self.stack.runAction(SKAction.moveBy(CGVectorMake(0, -self.blockHeigth), duration: 0.5))
    }

    func novoBloco(){
        proxBloco = Block(texture: SKTexture(imageNamed: "block"), tam: CGSizeMake(self.stackWidth, self.blockHeigth))
        
        proxBloco.position = CGPointMake(self.stackWidth/2, self.size.height * 0.95)
        self.addChild(proxBloco)
        proxBloco.moveAround(self)
        
    }
    
    func soltaBloco(){
        proxBloco.removeAllActions()
        
        //se o bloco estiver pelo menos parcialmente sobre o topo da pilha
        if proxBloco.position.x < (stackPos.x + stackWidth) && (proxBloco.position.x + stackWidth) > stackPos.x {
            proxBloco.runAction(SKAction.moveToY(stackPos.y + blockHeigth/2 + CGFloat(stackSize)*blockHeigth, duration: 1.0), completion: { () -> Void in
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
    
    func cortaBloco(bloco: Block) -> Block{
		// Já inicia na largura perfeita, e troca caso tenha sobra
        var novaLargura:CGFloat = stackWidth
        
        
        //caso de acerto perfeito
        if abs(bloco.position.x - stackPos.x) < self.deltaPerfeito {
            
            var blocoCortado = Block(texture: SKTexture(imageNamed: "block"), tam: CGSizeMake(stackWidth, blockHeigth))
            blocoCortado.perfeito = true
            return blocoCortado
        }
        
        //caso sobre para a esquerda
        if bloco.position.x < stackPos.x {
            novaLargura = stackWidth - (stackPos.x - bloco.position.x)
        }
        
        //caso sobre para a direita
        if bloco.position.x > stackPos.x {
            novaLargura = stackWidth - (bloco.position.x - stackPos.x)
        }
        self.stackWidth = novaLargura
        var blocoCortado = Block(texture: SKTexture(imageNamed: "block"), tam: CGSizeMake(stackWidth, blockHeigth))
        return blocoCortado
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
//        debugNode.size = CGSizeMake(stackWidth, blockHeigth)
//        debugNode.position = CGPointMake(stackPos.x, stackHeigth)
    }
}
