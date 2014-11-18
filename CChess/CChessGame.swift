//
//  CChessGame.swift
//  CChess
//
//  Created by tedzhao on 11/14/14.
//  Copyright (c) 2014 tedzhao. All rights reserved.
//

import Foundation

enum CChessGameStatus {
    case Init
    case Start
    case Finish
}

class CChessGame{
    init(){
    }
    
    var redChesses : [CChessChess] = []
    var blackChesses : [CChessChess] = []
    var diedChesses : [CChessChess] = []
    var currentOrder : CChessCamp = .Red
    var gameStatus : CChessGameStatus = .Init
    
    func newGame(){
        self.initChesses()
        self.currentOrder = .Red
        self.gameStatus = .Init
    }
    
    func startGame(){
        self.gameStatus = .Start
    }
    
    func finishGame(){
        self.gameStatus = .Finish
    }
    
    func initChesses(){
        self.redChesses =
            [CChessChess(x:0,y:0,text:"車",camp:.Red,role:.Chariot),
                CChessChess(x:1,y:0,text:"馬",camp:.Red, role:.Horse),
                CChessChess(x:2,y:0,text:"相",camp:.Red, role:.Elephant),
                CChessChess(x:3,y:0,text:"士",camp:.Red, role:.Guard),
                CChessChess(x:4,y:0,text:"帥",camp:.Red, role:.King),
                CChessChess(x:5,y:0,text:"士",camp:.Red, role:.Guard),
                CChessChess(x:6,y:0,text:"相",camp:.Red, role:.Elephant),
                CChessChess(x:7,y:0,text:"馬",camp:.Red, role:.Horse),
                CChessChess(x:8,y:0,text:"車",camp:.Red, role:.Chariot),
                CChessChess(x:1,y:2,text:"炮",camp:.Red, role:.Cannon),
                CChessChess(x:7,y:2,text:"炮",camp:.Red, role:.Cannon),
                CChessChess(x:0,y:3,text:"兵",camp:.Red, role:.Soldier),
                CChessChess(x:2,y:3,text:"兵",camp:.Red, role:.Soldier),
                CChessChess(x:4,y:3,text:"兵",camp:.Red, role:.Soldier),
                CChessChess(x:6,y:3,text:"兵",camp:.Red, role:.Soldier),
                CChessChess(x:8,y:3,text:"兵",camp:.Red, role:.Soldier)
        ]
        self.blackChesses =
            [CChessChess(x:0,y:9,text:"車",camp:.Black, role:.Chariot),
                CChessChess(x:1,y:9,text:"馬",camp:.Black, role:.Horse),
                CChessChess(x:2,y:9,text:"象",camp:.Black, role:.Elephant),
                CChessChess(x:3,y:9,text:"士",camp:.Black, role:.Guard),
                CChessChess(x:4,y:9,text:"帥",camp:.Black, role:.King),
                CChessChess(x:5,y:9,text:"士",camp:.Black, role:.Guard),
                CChessChess(x:6,y:9,text:"象",camp:.Black, role:.Elephant),
                CChessChess(x:7,y:9,text:"馬",camp:.Black, role:.Horse),
                CChessChess(x:8,y:9,text:"車",camp:.Black, role:.Chariot),
                CChessChess(x:1,y:7,text:"炮",camp:.Black, role:.Cannon),
                CChessChess(x:7,y:7,text:"炮",camp:.Black, role:.Cannon),
                CChessChess(x:0,y:6,text:"卒",camp:.Black, role:.Soldier),
                CChessChess(x:2,y:6,text:"卒",camp:.Black, role:.Soldier),
                CChessChess(x:4,y:6,text:"卒",camp:.Black, role:.Soldier),
                CChessChess(x:6,y:6,text:"卒",camp:.Black, role:.Soldier),
                CChessChess(x:8,y:6,text:"卒",camp:.Black, role:.Soldier)
        ]
        self.diedChesses = []
    }
    
    func getChessFromPostion(pos:CChessPosition) -> CChessChess?{
        for redChess in redChesses{
            if (redChess.position == pos){
                return redChess
            }
        }
        
        for blackChess in blackChesses{
            if (blackChess.position == pos){
                return blackChess
            }
        }
        
        return nil
    }
    
    func isValidPosition(pos:CChessPosition) -> Bool{
        return pos.x >= 0 && pos.x < 9 && pos.y >= 0 && pos.y < 10;
    }
    
    func isInsideCamp(pos:CChessPosition, camp:CChessCamp) -> Bool{
        if(!isValidPosition(pos)){
            return false
        }
        
        if(camp == .Red){
            return pos.y <= 4;
        } else {
            return pos.y >= 5;
        }
    }

    func isInsidePalace(pos:CChessPosition, camp:CChessCamp) -> Bool{
        if(!isValidPosition(pos)){
            return false
        }
        
        if(pos.x < 3 || pos.x > 5){
            return false
        }
        
        if(camp == .Red){
            return pos.y <= 2;
        } else {
            return pos.y >= 7;
        }
    }
    
    func canMoveChessTo(chess:CChessChess, target:CChessPosition) -> (canMove:Bool, eatChess:CChessChess?){
        var canMove = false
        switch chess.role{
        case .Chariot:
            canMove = canMoveChariotTo(chess, target:target)
        case .Horse:
            canMove = canMoveHorseTo(chess, target:target)
        case .Elephant:
            canMove = canMoveElephantTo(chess, target:target)
        case .Guard:
            canMove = canMoveGuardTo(chess, target:target)
        case .King:
            canMove = canMoveKingTo(chess, target:target)
        case .Cannon:
            canMove = canMoveCannonTo(chess, target:target)
        case .Soldier:
            canMove = canMoveSoldierTo(chess, target:target)
        default:
            canMove = false
        }
        
        if (canMove){
            let targetChess = getChessFromPostion(target)
            if (targetChess != nil){
                canMove = targetChess!.camp != chess.camp
            }
            
            return (canMove, targetChess)
        }
        
        return (false, nil)
    }
    
    func canMoveChariotTo(chess:CChessChess, target:CChessPosition) -> Bool{
        let dx = target.x - chess.position.x, dy = target.y - chess.position.y;
        if(dx != 0 && dy != 0){
            return false;
        }
        
        var midPos = CChessPosition(x:chess.position.x, y:chess.position.y)
        let steps = max(abs(dx), abs(dy))
        for var i=1; i<steps; i++ {
            midPos.x += dx / steps
            midPos.y += dy / steps
            
            let midChess = getChessFromPostion(midPos)
            if (midChess != nil){
                return false
            }
        }
        
        return true
    }
    
    func canMoveCannonTo(chess:CChessChess, target:CChessPosition) -> Bool{
        let dx = target.x - chess.position.x, dy = target.y - chess.position.y;
        if(dx != 0 && dy != 0){
            return false;
        }
        
        var midPos = CChessPosition(x:chess.position.x, y:chess.position.y)
        let steps = max(abs(dx), abs(dy))
        var blocks = 0
        
        for var i=1; i<steps; i++ {
            midPos.x += dx / steps
            midPos.y += dy / steps
            
            let midChess = getChessFromPostion(midPos)
            blocks += midChess == nil ? 0 : 1
        }
        
        let targetChess = getChessFromPostion(target)
        return (blocks == 0 && targetChess == nil) || (blocks == 1 && targetChess != nil);
    }
    
    func canMoveHorseTo(chess:CChessChess, target:CChessPosition) -> Bool{
        let dx = target.x - chess.position.x, dy = target.y - chess.position.y;
        if(dx == 0 || dy == 0 || abs(dx) + abs(dy) != 3){
            return false
        }
        
        var blockPos = CChessPosition(x:chess.position.x, y:chess.position.y)
        if(abs(dx) == 2){
            blockPos.x += dx / 2;
        }else{
            blockPos.y += dy / 2;
        }
        
        let blockChess = getChessFromPostion(blockPos)
        return blockChess == nil
    }
    
    func canMoveElephantTo(chess:CChessChess, target:CChessPosition) -> Bool{
        if (!isInsideCamp(target, camp: chess.camp)){
            return false
        }
        
        let dx = target.x - chess.position.x, dy = target.y - chess.position.y;
        if(abs(dx) != 2 || abs(dy) != 2){
            return false;
        }
        
        let blockPos = CChessPosition(x:chess.position.x + dx / 2, y:chess.position.y + dy / 2);
        let blockChess = getChessFromPostion(blockPos)
        
        return blockChess == nil
    }

    func canMoveGuardTo(chess:CChessChess, target:CChessPosition) -> Bool{
        if (!isInsidePalace(target, camp: chess.camp)){
            return false
        }
        
        let dx = target.x - chess.position.x, dy = target.y - chess.position.y;
        if(abs(dx) != 1 || abs(dy) != 1){
            return false;
        }
        
        return true
    }

    func canMoveKingTo(chess:CChessChess, target:CChessPosition) -> Bool{
        if (!isInsidePalace(target, camp: chess.camp)){
            return false
        }
        
        let dx = target.x - chess.position.x, dy = target.y - chess.position.y;
        return abs(dx) + abs(dy) == 1
    }
    
    func canMoveSoldierTo(chess:CChessChess, target:CChessPosition) -> Bool{
        let dx = target.x - chess.position.x, dy = target.y - chess.position.y;
        if(abs(dx) + abs(dy) != 1){
            return false
        }
        
        if (isInsideCamp(target, camp: chess.camp) && dx != 0){
            return false
        }
        
        if (chess.camp == .Red && dy < 0){
            return false
        }
        
        if (chess.camp == .Black && dy > 0){
            return false
        }
        
        return true
    }
    
    func SelectChess(chess:CChessChess) -> Bool{
        if (gameStatus != .Start){
            return false
        }
        
        return currentOrder == chess.camp
    }
    
    func MoveChess(chess:CChessChess, target:CChessPosition) -> (isSuccess:Bool, eatChess:CChessChess?){
        if (gameStatus != .Start || chess.camp != currentOrder){
            return (false, nil)
        }
        
        let canMoveResult = canMoveChessTo(chess, target:target)
        if (canMoveResult.canMove){
            chess.position = target;
            
            if (canMoveResult.eatChess != nil){
                
                var index = indexOf(redChesses, chess: canMoveResult.eatChess!)
                if (index >= 0){
                    redChesses.removeAtIndex(index)
                }else{
                    index = indexOf(blackChesses, chess: canMoveResult.eatChess!)
                    if (index >= 0){
                        blackChesses.removeAtIndex(index)
                    }
                }
                
                diedChesses.append(canMoveResult.eatChess!)
            }
            
            currentOrder = (currentOrder == .Red ? .Black : .Red)
            return (true, canMoveResult.eatChess)
        }
        
        return (false, nil)
    }
    
    func indexOf(chesses:[CChessChess], chess:CChessChess) -> Int{
        for var i=0;i<chesses.count;i++ {
            if (chesses[i] === chess){
                return i;
            }
        }
        
        return -1;
    }
}