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
    let deltaPerfeito:CGFloat = 5.0
    //tamanho bonus para cada acerto perfeito
    let bonusWidth:CGFloat = 15.0
    //altura de cada bloco
    let blockHeigth:CGFloat = 30.0
    //largura original
    let startWidth:CGFloat = 80.0
    
    //flags do jogo
    
    //perdeu
    var perdeu:Bool = false
    
    //variaveis que controlam a pilha de blocos
    
    //largura do bloco do topo - controla o tamanho do próximo bloco criado
    var stackWidth:CGFloat = 80.0
    //altura do bloco do topo
    var stackHeigth:CGFloat = 180.0
    //tamanho da pilha (numero de blocos)
    var stackSize:Int = 0
    //posicao do topo da pilha
    var stackPos:CGPoint!
    
    //variacao da posicao do topo da pilha com relacao a posicao do ojbeto da pilha em si
    var diff:CGFloat = 0
    
    //node que representa a pilha de blocos
    var stack:SKSpriteNode!
    
    //node que é o bloco no topo
    var topo:SKSpriteNode!
    
    //node que é o bloco a ser colocado
    var proxBloco:Block!
    
    //node da tela de derrota
    var perdeuNode:SKNode!
    
    
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
//        
//        let myLabel = SKLabelNode(fontNamed:"Helvetica")
//        myLabel.text = "Stackers!";
//        myLabel.fontSize = 30;
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
//        
//        self.addChild(myLabel)
        
        self.novoBloco()
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        var novoBloco = Block(texture: SKTexture(imageNamed: "block"), tam: CGSizeMake(self.stackWidth, self.blockHeigth))
//        novoBloco.position = CGPointMake(self.size.width/2, stackHeigth)
//        self.addChild(novoBloco)
//        self.addToStack(novoBloco)
        if self.perdeu == false{
            self.soltaBloco()
        } else {
            self.perdeu = false
            self.stackSize = 0
            self.perdeuNode.removeFromParent()
            self.reset()
        }

    }

    //ta tudo ruim isso aqui, tem que arrumar
    func addToStack(bloco: Block){
        stackSize++
        //self.stack.hidden = false
        //self.stack.runAction(SKAction.fadeInWithDuration(0.3))
        
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
        
        self.diff = bloco.position.x - self.stackPos.x
        
        
        bloco.removeFromParent()
        
        blocoCortado.position = CGPointMake(stackPos.x - leftEdge - oldWidth/2, blockHeigth)///2 + CGFloat(stackSize)*blockHeigth)
        
//        blocoCortado.position = CGPointMake(stackPos.x - leftEdge - oldWidth/2, blockHeigth/2 + CGFloat(stackSize)*blockHeigth)
        self.topo.addChild(blocoCortado)
        if blocoCortado.perfeito == true {
            blocoCortado.runAction(SKAction.resizeToWidth(blocoCortado.size.width + bonusWidth, duration: 0.1))
            stackWidth += bonusWidth
        }
        self.topo = blocoCortado
        
        //debug
        blocoCortado.physicsBody = SKPhysicsBody(rectangleOfSize: blocoCortado.size)
        blocoCortado.physicsBody?.dynamic = false
        
        self.stack.runAction(SKAction.moveBy(CGVectorMake(0, -self.blockHeigth), duration: 0.3), completion: { () -> Void in
            
            //aqui anda pra lá e pra cá
            if self.stackSize == 3 {
                let moveAroundAction = SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.moveToX(100, duration: 1.5),
                    SKAction.moveToX(self.size.width-100, duration: 1.5)
//                    SKAction.moveByX(self.size.width-self.size.width/2, y: 0, duration: 1),
//                    SKAction.moveByX(-(self.size.width-self.size.width/2), y: 0, duration: 1)
                    ]))
                self.stack.runAction(moveAroundAction)
            }
            
            //aqui fica INVISIBRU
            if self.stackSize == 5 {
                //self.stack.hidden = true
                //self.stack.runAction((SKAction.fadeOutWithDuration(0.5)))
                let fadeAction = SKAction.sequence([SKAction.fadeOutWithDuration(0.3), SKAction.waitForDuration(0.3),SKAction.fadeInWithDuration(0.3)])
                self.stack.runAction(SKAction.repeatActionForever(fadeAction))
            }
        })
        
    }

    func novoBloco(){
        proxBloco = Block(texture: SKTexture(imageNamed: "block"), tam: CGSizeMake(self.stackWidth, self.blockHeigth))
        
        //debug
        proxBloco.physicsBody = SKPhysicsBody(rectangleOfSize: proxBloco.size)
        proxBloco.physicsBody?.dynamic = false
        
        proxBloco.position = CGPointMake(self.stackWidth/2, self.size.height * 0.95)
        self.addChild(proxBloco)
        proxBloco.moveAround(self)
        
    }
    
    func soltaBloco(){
        proxBloco.removeAllActions()
        
        proxBloco.runAction(SKAction.moveToY(self.topo.position.y + blockHeigth + blockHeigth, duration: 0.5), completion: { () -> Void in
            
//            //calcular a diferença da posicao do stack com a do topo atual
//            var diff = self.stackPos.x - self.stack.position.x
//            
//            self.stackPos.x = self.stack.position.x + diff
            
            //se o bloco estiver pelo menos parcialmente sobre o topo da pilha
            if self.proxBloco.position.x < (self.stackPos.x + self.stackWidth) && (self.proxBloco.position.x + self.stackWidth) > self.stackPos.x {
                self.addToStack(self.proxBloco)
                self.novoBloco()
                
            }
            else{
                self.proxBloco.runAction(SKAction.moveToY(-self.blockHeigth, duration: 0.25), completion: { () -> Void in
                    //self.novoBloco()
                    //ou, sabe, perder o jogo
                    self.lose()
                })
            }
            
        })
        
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
    
    func lose(){
        self.perdeu = true
        self.perdeuNode = SKSpriteNode(texture: SKTexture(imageNamed: "curveRect"), color: UIColor.clearColor(), size: CGSizeMake(self.size.width-100, self.size.height-10))
        perdeuNode.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        perdeuNode.alpha = 0.8
        let labelPerdeu = SKLabelNode(fontNamed: "Helvetica")
        labelPerdeu.text = "Perdeu!"
        self.perdeuNode.addChild(labelPerdeu)
        labelPerdeu.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(perdeuNode)
    }
    
    func reset(){
        self.diff = 0
        self.stack.removeFromParent()
        self.stack = SKSpriteNode(color: UIColor.blueColor(), size: CGSizeMake(stackWidth, stackHeigth))
        stack.position = CGPointMake(self.size.width/2, stackHeigth/2)
        self.addChild(stack)
        
        topo = stack
        
        self.stackPos = stack.position
        self.stackWidth = self.startWidth
        
        self.novoBloco()
    }
   
    override func update(currentTime: CFTimeInterval) {
        println(self.stackPos.x)
        //println(self.stack.position.x)
        self.stackPos.x = self.stack.position.x + self.diff
    }
}
