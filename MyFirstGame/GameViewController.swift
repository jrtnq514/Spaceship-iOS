//
//  GameViewController.swift
//  MyFirstGame
//
//  Created by Josh Taylor on 9/11/14.
//  Copyright (c) 2014 Josh Taylor. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    // Auto-rotate disabled
    override func shouldAutorotate() -> Bool {
        return false;
    }

    // Show status bar
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    var gameScene: GameScene!;
    var mainScene: GameScene!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Config view
        let gameView = view as! SKView;
        gameView.multipleTouchEnabled = false
        
        // Create the scene
        gameScene = GameScene(size: gameView.bounds.size);
        gameScene.scaleMode = .AspectFill;
        
        //scoreLabel.text = "\(gameScene.score)";
       
        //
        gameView.showsFPS = true;
//        gameView.showsPhysics = true;
//        gameView.showsDrawCount = true;
//        gameView.showsFields = true;
//        gameView.showsNodeCount = true;
//        gameView.showsQuadCount = true;
        
        gameView.presentScene(gameScene, transition: SKTransition.doorsOpenHorizontalWithDuration(1.2));
        
    }
    
}
