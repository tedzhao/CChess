//
//  CChessChessInfo.swift
//  CChess
//
//  Created by tedzhao on 11/13/14.
//  Copyright (c) 2014 tedzhao. All rights reserved.
//

import Foundation

enum CChessCamp {
    case Red
    case Black
}

enum CChessRole {
    case Chariot
    case Horse
    case Elephant
    case Guard
    case King
    case Cannon
    case Soldier
}

class CChessChess {
    var position:CChessPosition = CChessPosition(x:0, y:0)
    var text = ""
    var camp : CChessCamp = .Red
    var role : CChessRole = .Soldier
    
    init(x:Int,y:Int,text:String,camp:CChessCamp,role:CChessRole){
        self.position = CChessPosition(x:x, y:y)
        self.text = text
        self.camp = camp
        self.role = role
    }
}
