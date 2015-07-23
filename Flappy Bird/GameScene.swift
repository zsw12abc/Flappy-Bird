//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Shaowei Zhang on 15/7/23.
//  Copyright (c) 2015年 Shaowei Zhang. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var bird = SKSpriteNode()
    var pipeUpTexture = SKTexture()
    var pipeDownTexture = SKTexture()
    var PipeMoveAndRemove = SKAction()
    
    let pipeGap = 100.0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //Physics
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.0)
        
        //Bird
        let BirdTexture = SKTexture(imageNamed: "bird.png")
        BirdTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        bird = SKSpriteNode(texture: BirdTexture)
        bird.setScale(0.5)
        bird.position = CGPoint(x: self.frame.size.width * 0.35, y: self.frame.size.height * 0.6)
        
        //物理模型
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height/2.0)
        bird.physicsBody?.dynamic = true
        bird.physicsBody?.allowsRotation = false
        
        self.addChild(bird)
        
        //groud
        let groundTexture = SKTexture(imageNamed: "ground")
        let sprite = SKSpriteNode(texture: groundTexture)
        sprite.setScale(2.0)
        sprite.position = CGPointMake(self.size.width/2, sprite.size.height/2)
        
        self.addChild(sprite)
        
        let ground = SKNode()
        ground.position = CGPointMake(0, groundTexture.size().height)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, groundTexture.size().height * 2))
        ground.physicsBody?.dynamic = false
        self.addChild(ground)
        
        //pipes
        //create the pipes
        pipeUpTexture = SKTexture(imageNamed: "pipeBottom")
        pipeDownTexture = SKTexture(imageNamed: "pipeTop")
        
        //movement of pipes
        
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeUpTexture.size().width)
        let movePipes = SKAction.moveByX(-distanceToMove, y: 0.0, duration: NSTimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        PipeMoveAndRemove = SKAction.sequence([movePipes, removePipes])
        
        //spawn pipes
        let spawn = SKAction.runBlock({() in self.spawnPipes()})
        let delay = SKAction.waitForDuration(NSTimeInterval(1.0))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        
        self.runAction(spawnThenDelayForever)
    }
    
    func spawnPipes() {
        let pipePair = SKNode()
        pipePair.position = CGPointMake(self.frame.size.width + pipeUpTexture.size().width * 2, 0)
        pipePair.zPosition = -10
        
        let height = UInt32(self.frame.size.height / 4)
        let y = arc4random() % height + height
        
        let pipeDown = SKSpriteNode(texture: pipeDownTexture)
        pipeDown.setScale(0.3)
        pipeDown.position = CGPointMake(0, CGFloat(y) + pipeDown.size.height + CGFloat(pipeGap))
        
        pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize: pipeDown.size)
        pipeDown.physicsBody?.dynamic = false
        
        pipePair.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(texture: pipeUpTexture)
        pipeUp.setScale(0.3)
        pipeUp.position = CGPointMake(0, CGFloat(y))
        
        pipeUp.physicsBody = SKPhysicsBody(rectangleOfSize: pipeUp.size)
        pipeUp.physicsBody?.dynamic = false
        pipePair.addChild(pipeUp)
        
        pipePair.runAction(PipeMoveAndRemove)
        self.addChild(pipePair)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 1))
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
