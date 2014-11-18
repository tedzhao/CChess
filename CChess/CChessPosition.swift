//
//  CChessPosition.swift
//  CChess
//
//  Created by tedzhao on 11/12/14.
//  Copyright (c) 2014 tedzhao. All rights reserved.
//

import Foundation

struct CChessPosition {
    var x  = 0
    var y = 0
}

func == (left: CChessPosition, right: CChessPosition) -> Bool {
    return (left.x == right.x) && (left.y == right.y)
}

func != (left: CChessPosition, right: CChessPosition) -> Bool {
    return !(left == right)
}


