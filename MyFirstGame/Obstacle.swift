//
//  Obstacle.swift
//  MyFirstGame
//
//  Created by Josh Taylor on 9/20/14.
//  Copyright (c) 2014 Josh Taylor. All rights reserved.
//

import Foundation
import spriteKit

class Obstacle {
    // Properties
    let numberOfColors: UInt32 = 6;
    let numberOfSizes: UInt32 = 4;
    let obstacleSide = arc4random_uniform(2);
    
    // Create Obstacle
    func createObstacle(height: CGFloat, width: CGFloat, size: CGSize) -> SKShapeNode {
        
        
        let obstacle = SKShapeNode(rectOfSize: CGSize(width: width+randomSize(size), height: height));
        
        if(obstacleSide == 0) {
            obstacle.position = CGPoint(x: 0-obstacle.frame.width/2, y: size.height-obstacle.frame.height);
        }else {
            obstacle.position = CGPoint(x: size.width+obstacle.frame.width/2, y: size.height-obstacle.frame.height);
        }
        
        let obstacleColor: UIColor = randomColor();
        
        obstacle.physicsBody = SKPhysicsBody(rectangleOfSize: obstacle.frame.size);
        obstacle.physicsBody?.usesPreciseCollisionDetection = true;
        obstacle.physicsBody?.affectedByGravity = false;
        obstacle.physicsBody?.allowsRotation = false;
        //obstacle.physicsBody?.dynamic = false;
        
        obstacle.physicsBody?.categoryBitMask = UInt32(1 << 1);
        obstacle.physicsBody?.collisionBitMask = UInt32(1 << 0);
        obstacle.physicsBody?.contactTestBitMask = UInt32(1 << 1);
        
        obstacle.name = "obstacle";
        obstacle.strokeColor = obstacleColor;
        
        obstacle.lineWidth = 2.0;
        obstacle.fillColor = obstacleColor; // Possibly only use stroke color
    
        return obstacle;
    }
    
    // Random Color
    func randomColor() -> UIColor {
        
        let colorNumber: Int = Int(arc4random_uniform(numberOfColors));
        
        switch colorNumber {
            case 0:
                return UIColor.redColor();
            case 1:
                return UIColor.yellowColor();
            case 2:
                return UIColor.greenColor();
            case 3:
                return UIColor.blueColor();
            case 4:
                return UIColor.purpleColor();
            case 5:
                return UIColor.orangeColor();
            default:
                return UIColor.cyanColor();
        }
    }
    
    // Random Size
    func randomSize(size: CGSize) -> CGFloat {

        let sizeNumber: Int = Int(arc4random_uniform(numberOfSizes));
        
        switch sizeNumber {
        case 0:
            return size.width/10;
        case 1:
            return size.width/8;
        case 2:
            return size.width/6;
        case 3:
            return size.width/5;
        default:
            return 0.0;
        }
    }
}