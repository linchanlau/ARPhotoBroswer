//
//  ARCustomAlert.swift
//  swiftShop
//
//  Created by 刘淋全 on 15/9/2.
//  Copyright (c) 2015年 刘淋全. All rights reserved.
//自定义弹出、自动消失提醒

import UIKit

class ARCustomAlert: UIControl {
    
    static let sharedInstance=ARCustomAlert()
    
    private var textLable:UILabel!
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        textLable=UILabel()
        textLable.textColor=UIColor .whiteColor()
        textLable.tag=1002
        textLable.font=UIFont.systemFontOfSize(13)
        textLable.numberOfLines=20;
        self.addSubview(textLable)
        
    }
    
    func alertWithText(str:NSString){
        var mysize:CGSize=KStringSize(str, width: 0, height: 18, font: UIFont.systemFontOfSize(13))
        
        if mysize.width>UIScreen.mainScreen().bounds.size.width-60.0
        {
            var ww:CGFloat=UIScreen.mainScreen().bounds.size.width
            var strSize:CGSize=KStringSize(str, width: ww-60.0, height: 0, font: UIFont.systemFontOfSize(13))
            textLable.frame=CGRectMake(10, 5, UIScreen.mainScreen().bounds.size.width-60.0, strSize.height)
        }else
        {
            textLable.frame=CGRectMake(10, 5, mysize.width, 18)
        }
        textLable.text=str as String
        
        self.frame=CGRectMake((UIScreen.mainScreen().bounds.width-textLable.frame.size.width-20.0)/2.0, UIScreen.mainScreen().bounds.size.height-120.0-textLable.frame.size.height, textLable.frame.size.width+20, textLable.frame.size.height+10)
        self.clipsToBounds=true
        self.layer.cornerRadius=6.0
        self.layer.borderWidth=0.5
        self.layer.borderColor=UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).CGColor
        self.layer.masksToBounds=true
        self.backgroundColor=UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        UIApplication.sharedApplication().keyWindow?.addSubview(self)
        UIApplication.sharedApplication().keyWindow?.bringSubviewToFront(self)
        
        let time: NSTimeInterval = 3.0
        let delay = dispatch_time(DISPATCH_TIME_NOW,
            Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(2)
            self.removeFromSuperview()
            UIView.commitAnimations()
        }
        
    }
    
    func KStringSize(str:NSString,width:CGFloat,height:CGFloat,font:UIFont)->CGSize
    {
        //计算文字本的宽度
        var attributes=[NSFontAttributeName:font]
        var option=NSStringDrawingOptions.UsesLineFragmentOrigin
        var size2:CGSize=CGSizeMake(width, height)
        var rect:CGRect=str.boundingRectWithSize(size2, options: option, attributes: attributes, context: nil)
        return rect.size
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

