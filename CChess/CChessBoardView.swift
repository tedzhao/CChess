//
//  CChessBoardView.swift
//  CChess
//
//  Created by tedzhao on 11/11/14.
//  Copyright (c) 2014 tedzhao. All rights reserved.
//

import UIKit

class CChessBoardView: UIView,UIAlertViewDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let row = frame.height / 11
        let col = frame.width / 10
        let size:CGFloat = row < col ? row : col
        
        self.padding = size
        self.colWidth = size
        self.rowHeight = size
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var padding:CGFloat = 0;
    var colWidth:CGFloat = 0;
    var rowHeight:CGFloat = 0;
    
    var selectedChess : CChessChessView? = nil
    var game: CChessGame? = nil
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let backColor = UIColor(red: 1, green: 238.0/255, blue: 221.0/255, alpha: 1)
        backColor.setFill()
        UIRectFill(rect)
        
        let x = rect.origin.x;
        let y = rect.origin.y;
        let width = rect.size.width - padding * 2.0
        let height = rect.size.height - padding * 2.0
        
        var context = UIGraphicsGetCurrentContext();
        
        // Set the circle outerline-width
        CGContextSetLineWidth(context, 3.0);
        
        // Set the circle outerline-colour
        UIColor(red: 102.0/255, green: 55.0/255, blue: 0, alpha: 1).set()

        // Horizontal lines
        var path = CGPathCreateMutable();
        for(var i = 0; i < 10; i++){
            CGPathMoveToPoint(path, nil, padding, padding + rowHeight * CGFloat(i))
            CGPathAddLineToPoint(path, nil, width + padding, rowHeight * CGFloat(i) + padding)
        }
        
        // Vertical line
        for(var i = 0; i < 9; i++){
            CGPathMoveToPoint(path, nil, padding + colWidth * CGFloat(i), padding)
            CGPathAddLineToPoint(path, nil, padding + colWidth * CGFloat(i), rowHeight * 4 + padding)
        }
        
        for(var i = 0; i < 9; i++){
            CGPathMoveToPoint(path, nil, padding + colWidth * CGFloat(i), padding + rowHeight * 5)
            CGPathAddLineToPoint(path, nil, padding + colWidth * CGFloat(i), rowHeight * 9 + padding)
        }
        CGPathMoveToPoint(path, nil, padding, padding)
        CGPathAddLineToPoint(path, nil, padding, rowHeight * 9 + padding)
        CGPathMoveToPoint(path, nil, padding + width, padding)
        CGPathAddLineToPoint(path, nil, padding + width, rowHeight * 9 + padding)
        
        // Cross line
        CGPathMoveToPoint(path, nil, padding + colWidth * 3, padding)
        CGPathAddLineToPoint(path, nil, padding + colWidth * 5, rowHeight * 2 + padding)
        CGPathMoveToPoint(path, nil, padding + colWidth * 5, padding)
        CGPathAddLineToPoint(path, nil, padding + colWidth * 3, rowHeight * 2 + padding)
        
        CGPathMoveToPoint(path, nil, padding + colWidth * 3, padding + rowHeight * 9)
        CGPathAddLineToPoint(path, nil, padding + colWidth * 5, rowHeight * 7 + padding)
        CGPathMoveToPoint(path, nil, padding + colWidth * 5, padding + rowHeight * 9)
        CGPathAddLineToPoint(path, nil, padding + colWidth * 3, rowHeight * 7 + padding)
        
        CGContextAddPath(context, path)
        CGContextStrokePath(context);
        
        let font = UIFont(name: "Arial", size: 60)
        var text:NSString = "楚      河"
        
        var tempDict:Dictionary<NSObject, AnyObject> = Dictionary()
        tempDict[NSFontAttributeName] = font
        tempDict[NSForegroundColorAttributeName] = UIColor(red: 102.0/255, green: 55.0/255, blue: 0, alpha: 1)
        
        var textStyle = NSMutableParagraphStyle()
        textStyle.alignment = NSTextAlignment.Center
        tempDict[NSParagraphStyleAttributeName] = textStyle
        
        let textHeight = text.sizeWithAttributes(tempDict).height;
        let leftRect = CGRectMake(padding, padding + rowHeight * 4 + (rowHeight - textHeight) / 2, width / 2, rowHeight)
        text.drawInRect(leftRect, withAttributes: tempDict)
        
        text = "漢      界"
        let rightRect = CGRectMake(padding + width / 2, padding + rowHeight * 4 + (rowHeight - textHeight) / 2, width / 2, rowHeight)
        
        text.drawInRect(rightRect, withAttributes: tempDict)
        
        //the re-start button
        let reBtn = UIButton(frame: CGRectMake(padding, padding + rowHeight * 10 , width / 7, rowHeight/2))
        reBtn.setTitle("再來一盤", forState: UIControlState.Normal)
        reBtn.backgroundColor=UIColor(red: 220/255, green: 238.0/255, blue: 221.0/255, alpha: 1)
        reBtn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        reBtn.layer.cornerRadius = 20
        reBtn.layer.masksToBounds = true
        reBtn.addTarget(self, action: "clickReBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(reBtn)
    }
    
    func clickReBtn(sender:UIButton){
        var alert = UIAlertView(title: "", message: "是否再來一局？", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "確定")
        alert.show()
        alert.delegate = self
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            for var i=subviews.count-1; i>=0; i-- {
                (self.subviews[i] as UIView).removeFromSuperview()
            }
            self.game?.newGame()
            self.addChesses(game!.redChesses)
            self.addChesses(game!.blackChesses)
            
            self.game!.startGame()
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        println("Start")
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent){
        println("Move")
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent){
        println("End")
        
        let touch = touches.allObjects[0] as UITouch
        // has selected chess, move selected chess
        if (self.selectedChess != nil){
            let point = touch.locationInView(self)
            let chessPos = getChessPosition(point)
            
            let chess = game?.getChessFromPostion(chessPos)
            if (chess != nil && chess?.camp == self.selectedChess?.chess?.camp)
            {
                self.selectedChess!.isSelected = false
                self.selectedChess = getChessView(chess!)
                self.selectedChess!.isSelected = true
                return;
            }
            
            let moveResult = game!.MoveChess(self.selectedChess!.chess!, target: chessPos)
            if (moveResult.isSuccess){
                self.selectedChess!.frame = getChessFrame(chessPos)
                self.selectedChess!.isSelected = false
                self.selectedChess = nil
                
                if (moveResult.eatChess != nil){
                    var eatChessView : CChessChessView! = getChessView(moveResult.eatChess!)
                    eatChessView.removeFromSuperview()
                }
            }
        }else{
            if (touch.view is CChessChessView){
                let chessView = touch.view as CChessChessView
                if (game!.SelectChess(chessView.chess!)){
                    chessView.isSelected = true
                    self.selectedChess = chessView
                }
            }
        }
    }
    
    func getChessView(chess:CChessChess) -> CChessChessView?{
        for view in self.subviews as [CChessChessView] {
            if (view.chess! === chess){
                return view
            }
        }

        return nil;
    }
    
    func getChessFrame(position:CChessPosition) -> CGRect{
        let x1:CGFloat = padding + colWidth * CGFloat(position.x) - colWidth / 2
        let y1:CGFloat = padding + rowHeight * CGFloat(position.y) - rowHeight / 2.0
        
        return CGRectMake(x1, y1, colWidth, rowHeight)
    }
    
    func getChessPosition(point:CGPoint) -> CChessPosition{
        let x = floor((point.x - padding + colWidth / 2) / colWidth);
        let y = floor((point.y - padding + rowHeight / 2) / rowHeight);
        
        return CChessPosition(x:Int(x), y:Int(y))
    }
    
    func addChesses(chesses : [CChessChess] ){
        for c in chesses {
            let rect = getChessFrame(c.position);
            let cView = CChessChessView(frame:rect, chess:c)
            
            self.addSubview(cView)
        }
    }
}
