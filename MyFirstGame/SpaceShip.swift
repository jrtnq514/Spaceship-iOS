//
//  Nino.swift
//  MyFirstGame
//
//  Created by Josh Taylor on 9/20/14.
//  Copyright (c) 2014 Josh Taylor. All rights reserved.
//

import Foundation
import spriteKit

class SpaceShip {
    // Properties
    let textureAtlas = SKTextureAtlas(named:"Spaceship.atlas")
    var textureArray = Array<SKTexture>();
    
    // Create Nino
    func createSpaceShip(spaceShipSize: CGFloat) -> SKSpriteNode {
        textureArray.append(textureAtlas.textureNamed("Spaceship1"));
        textureArray.append(textureAtlas.textureNamed("Spaceship2"));
        textureArray.append(textureAtlas.textureNamed("Spaceship3"));
        textureArray.append(textureAtlas.textureNamed("Spaceship4"));
        textureArray.append(textureAtlas.textureNamed("Spaceship3"));
        textureArray.append(textureAtlas.textureNamed("Spaceship2"));
        textureArray.append(textureAtlas.textureNamed("Spaceship1"));
        
        let spaceShip = SKSpriteNode(texture: textureArray[0], size: CGSize(width: spaceShipSize, height: spaceShipSize));
        
        spaceShip.position = CGPoint(x:spaceShip.size.width/2+20, y:spaceShip.size.width/2+10); // Maybe start the block higher up the screen
    
        // Animation
        let animateSpaceShip = SKAction.animateWithTextures(textureArray, timePerFrame: 0.10);
        let repeatAnimation = SKAction.repeatActionForever(animateSpaceShip);
        spaceShip.runAction(repeatAnimation);
        
        spaceShip.physicsBody = SKPhysicsBody(texture: textureArray[0], alphaThreshold: 0.0, size: spaceShip.size);
        spaceShip.physicsBody?.usesPreciseCollisionDetection = true;
        
        spaceShip.physicsBody?.affectedByGravity = true;
        spaceShip.physicsBody?.allowsRotation = true;
        //nino.physicsBody?.dynamic = false;
        
        spaceShip.physicsBody?.categoryBitMask = UInt32(1 << 0);
        spaceShip.physicsBody?.collisionBitMask = UInt32(1 << 1);
        spaceShip.physicsBody?.contactTestBitMask = UInt32(1 << 1);
        
        spaceShip.name = "SpaceShip";
        
        return spaceShip;
    }
}