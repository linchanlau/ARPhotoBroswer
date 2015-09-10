//
//  ARImageCache.swift
//  CMMALL_Swift
//
//  Created by 刘淋全 on 15/9/8.
//  Copyright (c) 2015年 刘淋全. All rights reserved.
//

import UIKit

let myDirectory:String = NSHomeDirectory() + "/Documents/imageCache"

class ARImageCache: NSObject {
    
    //缓存图片
    class func saveImageFile(image:UIImage,filename:NSString) {
        
        let fileManager = NSFileManager.defaultManager()
        var exist = fileManager.fileExistsAtPath(myDirectory)
        
        if !exist
        {
            var error:NSErrorPointer = nil
            var isSuccess:Bool = fileManager.createDirectoryAtPath(myDirectory,
                withIntermediateDirectories: true, attributes: nil, error: error)
        }
        
        //字符串“/”过滤
        var name:String=filename as String
        
        var filtered = name.stringByReplacingOccurrencesOfString("/", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        var path:NSString = myDirectory.stringByAppendingPathComponent(filtered);
        println(path)
        UIImagePNGRepresentation(image).writeToFile(path as String, atomically: true);
        
    }
    
    //根据图片名称判断图片是否存在
    class func existImageFileWithName(filename:NSString) ->Bool {
        
        //字符串“/”过滤
        var name:String=filename as String
        
        var filtered = name.stringByReplacingOccurrencesOfString("/", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        var path:NSString = myDirectory.stringByAppendingPathComponent(filtered);
        let fileManager = NSFileManager.defaultManager()
        var exist = fileManager.fileExistsAtPath(path as String)
        
        return exist
    }
    
    //根据图片名称取出图片
    
    class func findImageFileWithName(filename:NSString) ->UIImage {
        
        //字符串“/”过滤
        var name:String=filename as String
        
        var filtered = name.stringByReplacingOccurrencesOfString("/", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        var path:NSString = myDirectory.stringByAppendingPathComponent(filtered);
        let fileManager = NSFileManager.defaultManager()
        
        let data = fileManager.contentsAtPath(path as String)
            
        return UIImage(data: data!)!
        
    }
    
    //根据名称删除图片
    class func deleteImageFileWithName(filename:NSString) {
        //字符串“/”过滤
        var name:String=filename as String
        
        var filtered = name.stringByReplacingOccurrencesOfString("/", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        var path:NSString = myDirectory.stringByAppendingPathComponent(filtered);
        let fileManager = NSFileManager.defaultManager()
        var error:NSErrorPointer = nil
        fileManager.removeItemAtPath(path as String, error: error)
    }
    
    //删除所有图片
    class func deleteAllImageFile() {
        
        let fileManager = NSFileManager.defaultManager()
        var error:NSErrorPointer = nil
        var fileArray:[AnyObject]? = fileManager.subpathsAtPath(myDirectory)
        for fn in fileArray!{
            fileManager.removeItemAtPath(myDirectory + "/\(fn)", error: error)
        }
        
    }
    
    
    //改变图片大小
    class func reSizeImage(image:UIImage,width:CGFloat)->UIImage
    {
        var ratio:CGFloat=width/image.size.width
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width*ratio, image.size.height*ratio));
        image.drawInRect(CGRectMake(0, 0, image.size.width*ratio, image.size.height*ratio));
        var reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
   
}
