//
//  GameScene.swift
//  MyFirstGame
//
//  Created by Josh Taylor on 9/11/14.
//  Copyright (c) 2014 Josh Taylor. All rights reserved.
//

import SpriteKit
import Foundation

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    // Variables and layers
    var gameLayer: SKNode!;
    var SpaceShipClass: SpaceShip!;
    var spaceShip: SKSpriteNode!;
    var leftObstacle: SKShapeNode!;
    var rightObstacle: SKShapeNode!;
    var obstacleSpeed: NSTimeInterval!;
    var spaceShipSpeed: NSTimeInterval!;
    var gameSpeedTimer: NSTimer!;
    var obstacleTimer: NSTimer!;
    var scoreLabel: SKLabelNode!;
    var score: Int!;
    
    let spaceShipCategory: UInt32 = 1 << 0;
    let obstacleCategory: UInt32 = 1 << 1;
    
    // Required
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size);
        setup();
    }
    
    // Setup the game scene
    func setup() {
        self.physicsWorld.contactDelegate = self;
        //self.physicsWorld.gravity = CGVector(11, 0);
        //self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame);
        
        // Create Game Layer
        gameLayer = SKNode();
        
        // Anchor Point bottom left corner
        anchorPoint = CGPoint(x: 0.0, y: 0.0);
        
        // Set Game Speed
        obstacleSpeed = 3.0;
        spaceShipSpeed = 0.16;
        
        // Create and Reset Score
        score = 0;
        scoreLabel = SKLabelNode(fontNamed:"MarkerFelt-Wide");
        scoreLabel.fontSize = 50.0;
        scoreLabel.color = UIColor.cyanColor();
        scoreLabel.position = CGPointMake( CGRectGetMidX( self.frame ), 3 * self.frame.size.height / 4 );
        scoreLabel.zPosition = 100;
        scoreLabel.text = String(score);
        
        gameLayer.addChild(scoreLabel);
        
        obstacleTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("dropObstacle"), userInfo: nil, repeats: true);
        
        //gameSpeedTimer = NSTimer.scheduledTimerWithTimeInterval(1.3, target: self, selector: Selector("gameSpeed"), userInfo: nil, repeats: true);
        
        
        // SpaceShip Size
        let spaceShipSize = size.width/6;
        
        // Setup background
        let background = SKSpriteNode(color: UIColor.blackColor(), size: size);
        background.position = CGPoint(x: 0.0, y: 0.0);
        background.anchorPoint = CGPoint(x: 0.0, y: 0.0);
        
        addChild(background);
        addChild(gameLayer);
        
        // Create SpaceShip
        let SpaceShipClass = SpaceShip();
        spaceShip = SpaceShipClass.createSpaceShip(spaceShipSize);
        gameLayer.addChild(spaceShip);

    }
    
    // Game Speed
    func gameSpeed() {
        if(obstacleSpeed < 0.8 && obstacleSpeed > 0.1) {
            obstacleSpeed = obstacleSpeed - 0.05;
        }else if(obstacleSpeed > 0.2) {
            obstacleSpeed = obstacleSpeed - 0.1;
        }
    }
    
    // Delay
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    // Drop Obstacle
    func dropObstacle(){
        //let screenSize = UIScreen.mainScreen().bounds.size;
        let obstacleClass = Obstacle();
        let obstacleWidth = size.width/2+20;
        let obstacleHeight = (size.width/6)/3;
        let dropDown = SKAction.moveToY(
            0-obstacleHeight/2,
            duration: obstacleSpeed
        );
        let moveRight = SKAction.moveToX(
            obstacleWidth/2,
            duration: 0.3
        );
        let moveLeft = SKAction.moveToX(
            size.width - obstacleWidth/2,
            duration: 0.3
        );
       
        let leftObstacleSequence = SKAction.sequence([moveRight, dropDown]);
        let rightObstacleSequence = SKAction.sequence([moveLeft, dropDown]);
       
        let obstacle = obstacleClass.createObstacle(obstacleHeight, width: obstacleWidth, size: size);
        gameLayer.addChild(obstacle);
        
        if(obstacleClass.obstacleSide == 0) {
            obstacle.runAction(leftObstacleSequence);
        }else {
            obstacle.runAction(rightObstacleSequence);
        }
        
    }
    
    // Detect and Handle Touches
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches as! Set<UITouch>, withEvent: event);
        
        let offset = (size.width/6)/2;
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(gameLayer)
            //let touchedNode = nodeAtPoint(location);
            
            let moveRight = SKAction.moveToX(
                size.width-offset,
                duration: spaceShipSpeed
            );
            
            let moveLeft = SKAction.moveToX(
                offset,
                duration: spaceShipSpeed
            );
            
            let flipRight = SKAction.scaleXTo(
                -1.0,
                duration: 0.01
            );
            
            let flipLeft = SKAction.scaleXTo(
                1.0,
                duration: 0.01
            );
            
            let moveRightSequence = SKAction.sequence([moveRight, flipRight]);
            let moveLeftSequence = SKAction.sequence([moveLeft, flipLeft]);
            
            if(location.x < size.width/2) {
                spaceShip.physicsBody?.velocity = CGVectorMake(0, 0);
                // iPad impulse 175 and gravity 11
                // iPhone impulse 17 and gravity 9
                print(UIScreen.mainScreen().bounds.width);
                spaceShip.physicsBody?.applyImpulse(CGVectorMake(-(size.width/4), 0));
                spaceShip.runAction(SKAction.rotateByAngle(0.2, duration: 0.1));
                spaceShip.runAction(SKAction.rotateByAngle(-0.2, duration: 0.3));
                //spaceShip.runAction(moveLeftSequence);
            }else {
                spaceShip.physicsBody?.velocity = CGVectorMake(0, 0);
                spaceShip.physicsBody?.applyImpulse(CGVectorMake((size.width/4), 0));
                spaceShip.runAction(SKAction.rotateByAngle(-0.2, duration: 0.1));
                spaceShip.runAction(SKAction.rotateByAngle(0.2, duration: 0.3));
                //spaceShip.runAction(moveRightSequence);
            }
        }
    }
    
    func restart() {
        // No need to determine what objects collided, size there are only two types
        //sleep(2);
        gameLayer.removeAllChildren();
        //self.removeAllChildren();
        gameLayer.removeFromParent();
        //gameSpeedTimer.invalidate();
        obstacleTimer.invalidate();
        
        setup();
    }
    
    // Detect and Handle Contact
    func didBeginContact(contact: SKPhysicsContact) {
        
        if (( contact.bodyA.categoryBitMask & spaceShipCategory ) == spaceShipCategory || ( contact.bodyB.categoryBitMask & spaceShipCategory ) == spaceShipCategory) {
            
            obstacleTimer.invalidate();
            
            // Get rid of obstacles
            gameLayer.enumerateChildNodesWithName("obstacle") {
                node, stop in
                node.removeFromParent();
            }
            
            spaceShip.physicsBody?.applyImpulse(CGVectorMake(0, 20));
            spaceShip.runAction(SKAction.rotateByAngle(4, duration: 0.5));
            
            delay(3.0) {
                self.restart();
            }
            
        }
        
    }
    
    // Update Score
    func updateScore() {
        score = score + 1;
        scoreLabel.text = String(score);
        scoreLabel.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration:NSTimeInterval(0.1)), SKAction.scaleTo(1.0, duration:NSTimeInterval(0.1))]))
        //println(score);
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if(spaceShip.position.x > size.width-(spaceShip.size.width/2)) {
            spaceShip.physicsBody?.velocity = CGVectorMake(0, 0);
            spaceShip.position.x = spaceShip.position.x-1;
        }
        
        if(spaceShip.position.x < (spaceShip.size.width/2)) {
            spaceShip.physicsBody?.velocity = CGVectorMake(0, 0);
            spaceShip.position.x = spaceShip.position.x+1;
        }
        
        if(spaceShip.position.x > size.width/2) {
            self.physicsWorld.gravity = CGVector(dx: -11, dy: 0);
        } else {
            self.physicsWorld.gravity = CGVector(dx: 11, dy: 0);
        }
        
        // Clean up old obstacles
        gameLayer.enumerateChildNodesWithName("obstacle") {
            node, stop in
            if(node.position.y < 0) {
                node.removeFromParent();
                self.updateScore();
            }
        }
        
        // End game
        gameLayer.enumerateChildNodesWithName("SpaceShip") {
            node, stop in
            if(node.position.y < 0) {
                node.removeFromParent();
                
            }
        }
        
    }
}
