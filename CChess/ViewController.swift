//
//  ViewController.swift
//  CChess
//
//  Created by tedzhao on 11/11/14.
//  Copyright (c) 2014 tedzhao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var boardView = CChessBoardView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        view.addSubview(boardView)
        
        var game = CChessGame()
        boardView.game = game
        
        game.newGame()
        boardView.addChesses(game.redChesses)
        boardView.addChesses(game.blackChesses)
        
        game.startGame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

