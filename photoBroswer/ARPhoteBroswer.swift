//
//  ARPhoteBroswer.swift
//  CMMALL_Swift
//
//  Created by 刘淋全 on 15/9/9.
//  Copyright (c) 2015年 刘淋全. All rights reserved.
//

import UIKit

class ARPhoteBroswer: UIView,UIScrollViewDelegate {
    
    private var SV:UIScrollView?
    private var imageViewArr=[UIImageView]()
    private var localImages:NSArray?
    
    var showIndex:Int = 0{
        willSet
        {
            //恢复上一张的大小
            var imageView:UIImageView=imageViewArr[showIndex] as UIImageView
            imageView.transform = CGAffineTransformMakeScale(1.0
                , 1.0)
        }
        didSet
        {
            
        SV?.scrollRectToVisible(CGRectMake(CGFloat(showIndex)*CGFloat(self.frame.size.width), 0, self.frame.size.width, self.frame.size.height), animated: false)
            var indexAlertLabel:UILabel=self.viewWithTag(100) as! UILabel
            indexAlertLabel.text="\(showIndex+1)/\(localImages!.count)"
        }
            
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        self.backgroundColor=UIColor.blackColor()
        
        SV=UIScrollView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        SV?.delegate=self
        SV?.showsHorizontalScrollIndicator=false
        SV?.showsVerticalScrollIndicator=false
        SV?.pagingEnabled=true
        self.addSubview(SV!)
        
        naviView()
        
        UIApplication.sharedApplication().keyWindow?.addSubview(self)
        
    }
    
    //导航栏
    func naviView()
    {
        var naviView:UIView=UIView(frame: CGRectMake(0, 0, self.frame.size.width, 64))
        naviView.backgroundColor=UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.addSubview(naviView)
        self.bringSubviewToFront(naviView)
        
        var backBtn:UIButton=UIButton(frame: CGRectMake(5, 27, 30, 30))
        backBtn.setImage(UIImage(named: "backArrow"), forState: UIControlState.Normal)
        backBtn.addTarget(self, action: "backBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        backBtn.tag=10
        naviView.addSubview(backBtn)
        
        var saveBtn:UIButton=UIButton(frame: CGRectMake(naviView.frame.size.width-35, backBtn.frame.origin.y, backBtn.frame.size.width, backBtn.frame.size.height))
        saveBtn.setImage(UIImage(named: "save_icon"), forState: UIControlState.Normal)
        saveBtn.setImage(UIImage(named: "save_icon_h"), forState: UIControlState.Highlighted)
        saveBtn.tag=11
        saveBtn.addTarget(self, action: "backBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        naviView.addSubview(saveBtn)
        
        var indexAlertLabel:UILabel=UILabel(frame: CGRectMake(backBtn.frame.origin.x+backBtn.frame.size.width+10.0, backBtn.frame.origin.y, saveBtn.frame.origin.x-backBtn.frame.origin.x-backBtn.frame.size.width-20.0, backBtn.frame.size.height))
        indexAlertLabel.font=UIFont.boldSystemFontOfSize(18)
        indexAlertLabel.textColor=UIColor.whiteColor()
        indexAlertLabel.textAlignment=NSTextAlignment.Center
        indexAlertLabel.tag=100
        naviView.addSubview(indexAlertLabel)
    }
    
    //返回按钮事件
    func backBtnClick(myBtn:UIButton)
    {
        if myBtn.tag==11
        {
            var imageView:UIImageView=imageViewArr[showIndex] as UIImageView
            var saveImage:UIImage=imageView.image!
            UIImageWriteToSavedPhotosAlbum(saveImage, self, "image:didFinishSavingWithError:contextInfo:", nil)
            
        }else
        {
            self.removeFromSuperview()
        }
    }
    
    //图片保存成功提醒
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        
        if didFinishSavingWithError != nil {
            ARCustomAlert.sharedInstance.alertWithText("保存失败")
            return
        }
        ARCustomAlert.sharedInstance.alertWithText("已保存到相册")
    }
    
    //本地图片
    func showLocalImage(images:NSArray)
    {
        localImages=images
         SV?.contentSize=CGSizeMake(self.frame.size.width*CGFloat(localImages!.count), self.frame.size.height)
        var indexAlertLabel:UILabel=self.viewWithTag(100) as! UILabel
        indexAlertLabel.text="\(showIndex+1)/\(localImages!.count)"
        for i in 0..<images.count
        {
            var imageView:UIImageView=UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
            imageView.contentMode=UIViewContentMode.ScaleAspectFit
            imageView.userInteractionEnabled=true
             imageView.image=UIImage(named: localImages![i] as! String)
            SV?.addSubview(imageView)
            imageViewArr.append(imageView)
        }
    }
    
    //网络图片
    func showNetWorkImage(urls:NSArray)
    {
        var defaultImages:NSMutableArray?
        localImages=urls
        SV?.contentSize=CGSizeMake(self.frame.size.width*CGFloat(urls.count), self.frame.size.height)
        var indexAlertLabel:UILabel=self.viewWithTag(100) as! UILabel
        indexAlertLabel.text="\(showIndex+1)/\(urls.count)"
        for i in 0..<urls.count
        {
            
            var imageView:UIImageView=UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
            imageView.contentMode=UIViewContentMode.ScaleAspectFit
            imageView.userInteractionEnabled=true
            //imageView.image=ARImageCache.reSizeImage(UIImage(named: "timeline")!, width: imageView.frame.size.width)
            SV?.addSubview(imageView)
            imageViewArr.append(imageView)
            
            var dView:UIView=defaultImageView("timeline", str: "正在加载...")
            imageView.addSubview(dView)
            
            
            if ARImageCache.existImageFileWithName(urls[i] as! String)
            {
                imageView.image=ARImageCache.findImageFileWithName(urls[i] as! String)
                dView.removeFromSuperview()
                
            }else
            {
                var dispath=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
                dispatch_async(dispath, { () -> Void in
                    var URL:NSURL = NSURL(string: urls[i] as! String)!
                    var data:NSData?=NSData(contentsOfURL: URL)
                    if data != nil {
                        var originImage:UIImage=UIImage(data: data!)!
                        
                        //写缓存
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            //刷新主UI
                            ARImageCache.saveImageFile(originImage, filename: urls[i] as! String)//缓存图片
                            imageView.image=originImage
                            dView.removeFromSuperview()
                            
                        })
                    }else
                    {
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            //刷新主UI
                            var aLabel:UILabel=dView.viewWithTag(1000) as! UILabel
                            aLabel.text="加载失败"
                            
                        })
                    }
                    
                })
            }
            
            
            
        }
    }
    
    
    //默认图片
    func defaultImageView(img:String,str:String) ->UIView
    {
        var defaultView:UIView=UIView(frame: CGRectMake(0, 0, 120.0, 125.0))
        defaultView.center=self.center
        defaultView.backgroundColor=UIColor(red: 237.0/255.0, green: 237.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        
        //默认图片
        var defaultImage:UIImageView=UIImageView(frame: CGRectMake(0, 0, 120, 120))
        defaultImage.image=UIImage(named: img)
        defaultView.addSubview(defaultImage)
        
        var label:UILabel=UILabel(frame: CGRectMake(0, defaultView.frame.size.height-20, defaultView.frame.size.width, 20))
        label.text=str
        label.textAlignment=NSTextAlignment.Center
        label.font=UIFont.systemFontOfSize(13)
        label.textColor=UIColor.blackColor()
        label.tag=1000
        defaultView.addSubview(label)
        
//        var pinch=UIPinchGestureRecognizer(target:self,action:"handlePinchGesture:")
//        imageView.addGestureRecognizer(pinch)
        
        var tap=UITapGestureRecognizer(target: self, action: "tap:")
        defaultView.addGestureRecognizer(tap)
        
        return defaultView
        
    }
    
    //点击重新加载
//    func tap(tap:UITapGestureRecognizer)
//    {
//        var index=showIndex
//        
//        var dispath=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
//        dispatch_async(dispath, { () -> Void in
//            var URL:NSURL = NSURL(string: localImages[index] as! String)!
//            var data:NSData?=NSData(contentsOfURL: URL)
//            if data != nil {
//                var originImage:UIImage=UIImage(data: data!)!
//                
//                //写缓存
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    //刷新主UI
//                    ARImageCache.saveImageFile(originImage, filename: localImages[index] as! String)//缓存图片
//                    
//                    var imageView:UIImageView=self.imageViewArr[self.showIndex] as UIImageView
//                    imageView.image=originImage
//                    tap.view!.removeFromSuperview()
//                    
//                })
//            }else
//            {
//                
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    //刷新主UI
//                    var aLabel:UILabel=tap.view!.viewWithTag(1000) as! UILabel
//                    aLabel.text="加载失败"
//                    
//                })
//            }
//            
//        })
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    
        for i in 0..<imageViewArr.count
        {
            var imageView:UIImageView=imageViewArr[i] as UIImageView
            imageView.frame=CGRectMake(0.0+CGFloat(i)*CGFloat(self.frame.size.width), 0, self.frame.size.width, self.frame.size.height)
        
            var pinch=UIPinchGestureRecognizer(target:self,action:"handlePinchGesture:")
            imageView.addGestureRecognizer(pinch)
        }
       
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        showIndex=Int(scrollView.contentOffset.x/self.frame.size.width)
        
        
    }
    
    //捏合手势
    func handlePinchGesture(sender:UIGestureRecognizer){
        var factor:CGFloat = (sender as! UIPinchGestureRecognizer).scale
        sender.view!.transform = CGAffineTransformMakeScale(factor
            , factor)
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
