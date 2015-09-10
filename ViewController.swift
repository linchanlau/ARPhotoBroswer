//
//  ViewController.swift
//  ARPhotoBroswer
//
//  Created by 刘淋全 on 15/9/9.
//  Copyright (c) 2015年 刘淋全. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let titleArr:Array=["本地图片","网络图片"]
        for i in 0..<2
        {
            var btn:UIButton=UIButton(frame: CGRectMake(100, 100+60.0*CGFloat(i), 100, 40))
            btn.setTitle(titleArr[i] as String, forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            btn.layer.borderWidth=1
            btn.layer.borderColor=UIColor.redColor().CGColor
            btn.addTarget(self, action: "btnClick:", forControlEvents: UIControlEvents.TouchUpInside)
            btn.tag=i
            self.view.addSubview(btn)
        }
        
    }
    
    func btnClick(btn:UIButton)
    {
        if btn.tag==0{
            
            var photoBroswer:ARPhoteBroswer=ARPhoteBroswer()
            photoBroswer.showLocalImage(["PAG1","pic1.jpg","pic2.jpg","pic3.jpg","pic4.jpg","pic5"])
            
        }else{
            
            var photoBroswer:ARPhoteBroswer=ARPhoteBroswer()
            //photoBroswer.showLocalImage(["PAG1","pic1.jpg","pic2.jpg","pic3.jpg","pic4.jpg","pic5"])
            photoBroswer.showNetWorkImage(["http://pic1a.nipic.com/2008-12-04/2008124215522671_2.jpg","http://pic25.nipic.com/20121209/9252150_194258033000_.jpg","http://pic.sucai.com/tp/foto/img/xpic1348.jpg","http://pica.nipic.com/2007-11-09/200711912453162_2.jpg","http://img.taopic.com/uploads/allimg/120331/2722-12033109302882.jpg","http://pica.nipic.com/2007-11-09/2007119124413448_2.jpg"])
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

