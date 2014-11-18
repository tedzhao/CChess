//
//  CChessChessView.swift
//  CChess
//
//  Created by tedzhao on 11/12/14.
//  Copyright (c) 2014 tedzhao. All rights reserved.
//

import UIKit

class CChessChessView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.opaque = false
    }
    
    init(frame:CGRect, chess:CChessChess!){
        super.init(frame:frame)
        
        self.opaque = false
        self.chess = chess
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var padding:CGFloat = 10
    var chess:CChessChess? = nil
    
    var isSelected:Bool = false{
        willSet(newValue){
        }
        didSet{
            if (self.isSelected == oldValue){
                return
            }
            
            if(isSelected){
                let selLayer = CALayer()
                let layerFrame = CGRectMake(0, 0, self.frame.width, self.frame.height)
                
                selLayer.frame = layerFrame.rectByInsetting(dx:self.padding - 3, dy:self.padding - 3);
                selLayer.borderColor = UIColor.redColor().CGColor
                selLayer.borderWidth = 3.0
                self.layer.addSublayer(selLayer)
            }else{
                self.layer.sublayers.removeAll(keepCapacity: false)
            }
        }
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        var context = UIGraphicsGetCurrentContext();
        
        let eRect = rect.rectByInsetting(dx: padding, dy: padding)
        //let eRect = rect.rectByInsetting(dx: 3, dy: 3)

        let backColor = UIColor(red: 1, green: 204.0/255, blue: 153.0/255, alpha: 1)
        backColor.setFill()
        CGContextFillEllipseInRect(context, eRect)
        
        // Set the circle outerline-colour
        CGContextSetLineWidth(context, 3.0);
        UIColor(red: 1, green: 170.0/255, blue: 136/255, alpha: 1).set()
        CGContextAddEllipseInRect(context, eRect);
        CGContextStrokePath(context);

        let font = UIFont(name: "Arial", size: 36)
        var tempDict:Dictionary<NSObject, AnyObject> = Dictionary()
        tempDict[NSFontAttributeName] = font
        if (self.chess!.camp == .Red){
            tempDict[NSForegroundColorAttributeName] = UIColor(red: 204.0/255, green: 0, blue: 0, alpha: 1)
        }
        else{
            tempDict[NSForegroundColorAttributeName] = UIColor(red: 0, green: 153.0/255, blue: 0, alpha: 1)
        }
        
        
        var textStyle = NSMutableParagraphStyle()
        textStyle.alignment = NSTextAlignment.Center
        tempDict[NSParagraphStyleAttributeName] = textStyle
        
        let textHeight = self.chess!.text.sizeWithAttributes(tempDict).height;
        let tRect = CGRectMake(eRect.origin.x, eRect.origin.y + (eRect.height - textHeight) / 2, eRect.width, textHeight)

        self.chess!.text.drawInRect(tRect, withAttributes: tempDict)
    }
}
