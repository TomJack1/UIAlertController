//
//  ViewController.swift
//  keyAnimation
//
//  Created by tom on 16/7/16.
//  Copyright © 2016年 tom. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBOutlet var open: UIButton!
    
    
    @IBOutlet var close: UIButton!
    
    @IBAction func openaction(sender: AnyObject) {
        
        
        let shet = LEAlertController.init(title: "标题党", message: "content lable", alertType: LEAlertControllerStyle.ActionSheet)
        let  cancle = LEAlertAction.init(title: "取消", styleAction: LEAlertActionStyle.Cancel, handler: nil)
         shet.addAction(cancle)
        let b1 = LEAlertAction.init(title: "btn1", styleAction: LEAlertActionStyle.Default) { (view) in
            NSLog("btnAction1");
            let vc = UIViewController.init()
            vc.view.backgroundColor = UIColor.whiteColor()
            
            let v = UIButton.init(type: UIButtonType.Custom)
            v.frame = CGRectMake(20, 20, 50, 40);
            v.backgroundColor = UIColor.blackColor()
            v.setTitle("返回", forState: .Normal)
            vc.view.addSubview(v)
            v.addTarget(self, action: #selector(ViewController.btn(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            self.presentViewController(vc, animated: true, completion: nil)
        }
        shet.addAction(b1)
        let b2 = LEAlertAction.init(title: "btn2", styleAction: LEAlertActionStyle.Default) { (view) in
            NSLog("btnAction2");
        }
        shet.addAction(b2)
        let b3 = LEAlertAction.init(title: "btn3", styleAction: LEAlertActionStyle.Default) { (view) in
            NSLog("btnAction3");
        }
        shet.addAction(b3)
        
        
        let b4 = LEAlertAction.init(title: "btn4", styleAction: LEAlertActionStyle.Default) { (view) in
            NSLog("btnAction4");
        }
        shet.addAction(b4)
        
        let b5 = LEAlertAction.init(title: "btn5", styleAction: LEAlertActionStyle.Default) { (view) in
            NSLog("btnAction5");
            self.alertShow()
        }
        shet.addAction(b5)
        self.presentViewController(shet, animated: true, completion: nil)
        
    }
    @IBAction func closeAction(sender: AnyObject) {
        self.alertShow()
    }
    
    func alertShow() {
    
        let shet = LEAlertController.init(title: "标题alert", message: "内容content,自动更具当前文字进行缩放", alertType: LEAlertControllerStyle.Alert)
        
        let b5 = LEAlertAction.init(title: "取消", styleAction: LEAlertActionStyle.Cancel) { (view) in
            NSLog("取消");
        }
        shet.addAction(b5)
        let b1 = LEAlertAction.init(title: "确定", styleAction: LEAlertActionStyle.Default) { (view) in
            NSLog("确定");
        }
        shet.addAction(b1)
        self.presentViewController(shet, animated: true, completion: nil)
        
        
    }
    
    
    func btn(sede:UIButton) {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
}



