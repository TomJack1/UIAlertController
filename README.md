# 控件使用swift 
仿微信 SheetView ，与UIAlertController用法相同，兼容7.0 
#Usage
 let shet = LEAlertController.init(title: "标题党", message: "content lable", alertType: LEAlertControllerStyle.ActionSheet)
 
 let  cancle = LEAlertAction.init(title: "取消", styleAction: LEAlertActionStyle.Cancel, handler: nil)
 
 shet.addAction(cancle)
 
 let b2 = LEAlertAction.init(title: "btn2", styleAction: LEAlertActionStyle.Default) { (view) in
        NSLog("btnAction2");
  }
  shet.addAction(b2)
  self.presentViewController(shet, animated: true, completion: nil)
