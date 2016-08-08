//
//            ┏┓      ┏┓+ +
//           ┏┛┻━━━━━━┛┻━┓ + +
//           ┃           ┃
//           ┃　　　━     ┃ ++ + + +
//          ████━████    ┃+
//           ┃           ┃ +
//           ┃     ┻     ┃
//           ┃           ┃ + +
//           ┗━━┓　　　┏━━┛
//              ┃　　　┃
//              ┃　　　┃ + + + +
//              ┃　　　┃
//              ┃　　　┃ + 　　　　神兽保佑,代码无bug
//              ┃　　　┃
//              ┃　　　┃　　+
//              ┃     ┗━━━┓ + +
//              ┃         ┣┓
//              ┃         ┏┛
//              ┗┓┓┏━┳┓┏━━┛ + + + +
//               ┃┫┫ ┃┫┫
//               ┗┻┛ ┗┻┛+ + + +
//
//  _        _     _        ______     _
// | |      (_)   | |      |  ____|   (_)
// | |      | |   | |      | |___     | |
// | |      | |   | |      |  ___|    | |
// | |____  | |   | |____  | |____    | |
// |______| |_|   |______| |______|   |_|
//
//
//
//
//  LEAlertController.swift
//  TestDemo
//
//  Created by tom on 6/21/16.
//  Copyright © 2016 LL. All rights reserved.
//
import UIKit


let ScreenWIDTH: CGFloat =  {
    return UIScreen.mainScreen().bounds.size.width
}()
let ScreenHEIGHT: CGFloat =  {
    return UIScreen.mainScreen().bounds.size.height
}()
//Cell高度
let TBCellHeight: CGFloat = {
    return 50
}()


public enum LEAlertActionStyle : Int {
    
    case Default
    case Cancel
    case Destructive
}

public enum LEAlertControllerStyle : Int {
    
    case ActionSheet
    case Alert
}

private enum LEAlertPreasetVCType : Int {
    
    case Preasent
    case Dismiss
}


typealias handlerBlock = (view: LEAlertAction?) -> Void

class LEAlertAction : NSObject {
    
    
    var title: String?
    var style: LEAlertActionStyle
    var handBlock: handlerBlock?
    var customData: AnyObject?
    var sheetImage: UIImage?
    var sheetCellTextColor: UIColor?
    
    var titleTextAlignment: NSTextAlignment!
    init(title: String?, styleAction: LEAlertActionStyle, handler:handlerBlock?) {
        self.style = styleAction
        self.handBlock = handler
        self.title = title
        self.titleTextAlignment = NSTextAlignment.Center
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SheetViewCell: UITableViewCell {
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.textLabel?.font = UIFont.systemFontOfSize(16)
        self.textLabel?.textColor = UIColor.colorFromRGB(0x666666)
        
        let ViewLine = UIView.init(frame: CGRectMake(0, TBCellHeight - 1, ScreenWIDTH, 1))
        ViewLine.backgroundColor = UIColor.init(red: 238/255, green: 241/255, blue: 243/255, alpha: 1)
        self.contentView.addSubview(ViewLine)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class LEAlertController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK: def
    
    private var preasentType:LEAlertPreasetVCType = .Preasent
    private var bgView:UIView!
    
    
    
    private var alertType: LEAlertControllerStyle
    private var alertView: AnimaAlertView?
    private var titleStr: String?
    private var contentStr: String?
    // alertView
    private var sureTitle: String?
    private var cancelTitle: String?
    
    //alertViewDefine
    
    let leftAndRightMargin: CGFloat = 35
    let AlertViewHeight: CGFloat = 150
    
    //sheetView
    private var tableView:UITableView?
    private var dataSource: Array<LEAlertAction>?
    private var blankBtn:UIButton?
    private var cancelBtn: UIButton?
    private var footView:UIView?
    private var titleHeight:CGFloat!
    //SheetViewDefine
    let footViewHeight: CGFloat = 60
    let cancelBtnHeight: CGFloat = 50
    let footViewAndCancelMargin: CGFloat = 10 //eg: footViewHeight - cancelBtnHeight
    
    let cancelBtnColor: UIColor = {
        return UIColor.colorFromRGB(0xf54b31)
    }()
    
    //MARK: getter / setter
    
    deinit {
        NSLog("LEAlertController 销毁")
        
    }
    //MARK: override
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(title:String?,message: String?,alertType: LEAlertControllerStyle) {
        
        self.titleStr = title
        self.contentStr = message
        self.alertType = alertType
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .Custom
        self.view.backgroundColor = UIColor.clearColor()
        
        self.bgView = UIView.init(frame: CGRectMake(0, 0, ScreenWIDTH, ScreenHEIGHT))
        self.bgView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        self.view.addSubview(self.bgView)
        
        switch alertType {
        case .ActionSheet:
            self.sheetViewSetup()
            
        case.Alert:
            self.alertViewSetup()
        }
        self.transitioningDelegate = self
        
    }
    
    //different style To init
    private func alertViewSetup() {
        
        self.alertView = AnimaAlertView.init(frame: CGRectMake(leftAndRightMargin, ScreenHEIGHT/2 - 75, ScreenWIDTH - leftAndRightMargin * 2, AlertViewHeight), title: self.titleStr, message: self.contentStr)
        self.alertView!.clipsToBounds = true
        self.alertView!.layer.cornerRadius = 5
        self.view.addSubview(self.alertView!)
        self.alertView!.btnHandlerBlock = {[weak self] Void in
            self?.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    private func sheetViewSetup() {
        
        self.dataSource = [LEAlertAction]()
        
        
        self.tableView = UITableView.init(frame: CGRectMake(0, ScreenHEIGHT - footViewHeight, ScreenWIDTH, footViewHeight), style: UITableViewStyle.Plain)
        self.tableView?.separatorStyle = .None
        self.tableView?.rowHeight = TBCellHeight
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.opaque = false
        self.tableView?.tableFooterView = UIView.init()
        self.tableView?.registerClass(SheetViewCell.self, forCellReuseIdentifier: "CellSheetViewIndentifier")
        self.view.addSubview(self.tableView!)
        self.blankBtn = UIButton.init(type: .Custom)
        blankBtn?.frame = CGRectMake(0, 0, ScreenWIDTH, footViewHeight)
        self.view.addSubview(self.blankBtn!)
        self.blankBtn?.backgroundColor = UIColor.clearColor()
        self.blankBtn?.addTarget(self, action: #selector(LEAlertController.sheetViewCancelAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.titleHeight = 0;
        if self.titleStr != nil {
            let headNomalHeight:CGFloat = 35
            let headView = UIView.init(frame: CGRectMake(0, 0, ScreenWIDTH, headNomalHeight))
            headView.backgroundColor = UIColor.whiteColor()
            let lableTitle = UILabel.init(frame: headView.frame)
            lableTitle.font = UIFont.systemFontOfSize(16)
            lableTitle.textColor = UIColor.colorFromRGB(0x333333)
            lableTitle.textAlignment = .Center
            lableTitle.text = self.titleStr
            headView.addSubview(lableTitle)
//            let ViewLine = UIView.init(frame: CGRectMake(0, headView.frame.origin.y - 0.5, headView.frame.size.width, 0.5))
//            ViewLine.backgroundColor = UIColor.init(red: 238/255, green: 241/255, blue: 243/255, alpha: 1)
//            headView.addSubview(ViewLine)
            self.titleHeight = headNomalHeight;
            if self.contentStr != nil {
                let contentlable = UILabel.init(frame: CGRectMake(0, headNomalHeight, headView.frame.width, 21))
                contentlable.font = UIFont.systemFontOfSize(14)
                contentlable.textColor = UIColor.colorFromRGB(0x333333).colorWithAlphaComponent(0.8)
                contentlable.numberOfLines = 0
                contentlable.textAlignment = .Center
                headView.addSubview(contentlable)
                contentlable.text = self.contentStr
                let size =  contentlable.sizeThatFits(CGSizeMake(headView.frame.width - 16, 21))
                contentlable.frame = CGRectMake(8, headNomalHeight, headView.frame.width - 16, size.height + 6);
                
                if size.height > 21 {
                     contentlable.textAlignment = .Left
                }
                headView.frame = CGRectMake(0, 0, ScreenWIDTH, headNomalHeight + contentlable.frame.height + 8)
                
                self.titleHeight = headView.frame.height
            }
            
            
            self.tableView?.tableHeaderView = headView
        }else {
            if self.contentStr != nil {
                
                let headNomalHeight:CGFloat = 0
                let headView = UIView.init(frame: CGRectMake(0, 0, ScreenWIDTH, headNomalHeight))
                headView.backgroundColor = UIColor.whiteColor()
                
                let contentlable = UILabel.init(frame: CGRectMake(0, 0, ScreenWIDTH, 21))
                contentlable.font = UIFont.systemFontOfSize(14)
                contentlable.textColor = UIColor.colorFromRGB(0x333333).colorWithAlphaComponent(0.8)
                contentlable.numberOfLines = 0
                contentlable.textAlignment = .Center
                headView.addSubview(contentlable)
                contentlable.text = self.contentStr
                let size =  contentlable.sizeThatFits(CGSizeMake(headView.frame.width - 16, 21))
                contentlable.frame = CGRectMake(8, 4, headView.frame.width - 16, size.height + 6);
                if size.height > 21 {
                    contentlable.textAlignment = .Left
                }
                headView.frame = CGRectMake(0, 0, ScreenWIDTH, headNomalHeight + contentlable.frame.height + 8)
                
//                let ViewLine = UIView.init(frame: CGRectMake(0, headView.frame.origin.y - 0.5, headView.frame.size.width, 0.5))
//                ViewLine.backgroundColor = UIColor.init(red: 238/255, green: 241/255, blue: 243/255, alpha: 1)
//                headView.addSubview(ViewLine)
                self.titleHeight = headView.frame.height;
                self.tableView?.tableHeaderView = headView
            }
        }
        
    }
    
    //SheetViewDelegate
    //
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.dataSource == nil || self.dataSource?.isEmpty == true  {
            return 0
        }
        return (self.dataSource?.count)!
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell  = self.tableView?.dequeueReusableCellWithIdentifier("CellSheetViewIndentifier", forIndexPath: indexPath) as! SheetViewCell
        let ac = self.dataSource![indexPath.row]
        
        cell.textLabel?.textAlignment = ac.titleTextAlignment
        
        if ac.sheetImage != nil {
            cell.imageView?.image = ac.sheetImage
        }
        cell.textLabel?.text = ac.title
        
        if ac.sheetCellTextColor != nil {
            cell.textLabel?.textColor = ac.sheetCellTextColor
        }
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath
        indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        dispatch_async(dispatch_get_main_queue()) {
            self.dismissViewControllerAnimated(true) {
                let ac = self.dataSource![indexPath.row]
                ac.handBlock!(view: ac)
            }
            
        }
    }
    //MARK: api
    func addAction(action: LEAlertAction) {
        
        switch self.alertType {
        case .ActionSheet:
            self.addSheetCellData(action)
        case.Alert:
            self.alertView!.addButon(action)
            
        }
        
    }
    
    func addSheetCellData (action: LEAlertAction) {
        
        if self.alertType != .ActionSheet {
            assert(false, "AlertView Type is Not SheetView Please  init '.ActionSheet' Type")
        }
        if action.style == .Cancel {
            
            if cancelBtn != nil {
                return
            }
            
            let footView = UIView.init(frame: CGRectMake(0, ScreenHEIGHT - footViewHeight, ScreenWIDTH, footViewHeight))
            footView.backgroundColor = UIColor.init(red: 238/255, green: 241/255, blue: 243/255, alpha: 1)
            self.view.addSubview(footView)
            let btn = UIButton.init(type: UIButtonType.Custom)
            footView.addSubview(btn)
            btn.frame = CGRectMake(0, footViewAndCancelMargin, footView.frame.size.width, cancelBtnHeight)
            btn.titleLabel?.font = UIFont.systemFontOfSize(17)
            
            btn.backgroundColor = UIColor.whiteColor()
            btn.addTarget(self, action: #selector(LEAlertController.sheetViewCancelAction(_:)), forControlEvents: .TouchUpInside)
            if action.title == nil {
                btn .setTitle("cancel", forState: .Normal)
            }else {
                btn.setTitle(action.title, forState: .Normal)
            }
            if action.sheetCellTextColor != nil {
                btn.setTitleColor(action.sheetCellTextColor, forState: .Normal)
            }else {
                btn.setTitleColor(cancelBtnColor, forState: UIControlState.Normal)
            }
            self.cancelBtn = btn
            self.footView = footView
            var r: CGRect =  (self.tableView?.frame)!
            
            r.origin.y =  CGRectGetMinY(footView.frame) - r.size.height
            
            self.tableView?.frame = r
        }else {
            
            self.dataSource?.append(action)
            self.tableView?.reloadData()
            
            var r: CGRect = (self.tableView?.frame)!
//            let titleHeight: CGFloat = self.titleHeight
//            if self.titleStr != nil {
//            titleHeight = self.titleHeight
//            }
            
            
            
            //加2 是table headView 和 的线
            var  heiht: CGFloat = CGFloat((self.dataSource?.count)!) * TBCellHeight  + titleHeight + 2
            
            var cancelHeit:CGFloat = 0
            if self.cancelBtn != nil {
                cancelHeit = footViewHeight
                
            }
            
            if heiht + cancelHeit < ScreenHEIGHT - 40  {
                r.size.height = heiht
                r.origin.y = ScreenHEIGHT - heiht
                
                if self.cancelBtn != nil {
                    r.origin.y -= cancelHeit - 1
                }
                
                self.tableView?.bounces = false
            }else {
                self.tableView?.bounces = true
                r.origin.y = 40
                heiht = ScreenHEIGHT - 40
                r.size.height = heiht - cancelHeit - 1
            }
            
            self.tableView?.frame = r
            
            var blankBtnFrame: CGRect = (self.blankBtn?.frame)!
            blankBtnFrame.size.height = ScreenHEIGHT - heiht - cancelHeit
            self.blankBtn?.frame = blankBtnFrame
            
            
        }
        
    }
    
    
    //MARK: model event
    
    //MARK: view event
    
    func sheetViewCancelAction(btn: UIButton?) {
        
        
        
        if self.alertType == .ActionSheet {
            
            dispatch_async(dispatch_get_main_queue()) {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }else if self.alertType == .Alert {
            
        }
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    //MARK: private
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LEAlertController: UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning,UIViewControllerInteractiveTransitioning{
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.preasentType = .Preasent
    
        return self
       
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.preasentType = .Dismiss
        return self
    }
    
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return animator as? UIViewControllerInteractiveTransitioning
    }
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return animator as? UIViewControllerInteractiveTransitioning
    }
    
    func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if self.alertType == .ActionSheet {
            self .sheetShowAnimateTransition(transitionContext)
        }else if self.alertType == .Alert {
            self.alertShowAnimateTransition(transitionContext)
        }
    }
    
    
    
    func sheetShowAnimateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView:UIView = transitionContext.containerView()!
        containerView.backgroundColor = UIColor.clearColor()
        
        if self.preasentType == .Preasent {
            let toViewController:LEAlertController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! LEAlertController
            toViewController.view.frame = CGRectMake(0, 0, ScreenWIDTH, ScreenHEIGHT)
            containerView.addSubview(toViewController.view)
            let tableCenter: CGPoint = (toViewController.tableView?.center)!
            
            
            toViewController.tableView?.center = CGPointMake(tableCenter.x, ScreenHEIGHT + toViewController.tableView!.frame.size.height/2)
            
            
            var footCenter:CGPoint?
            if toViewController.footView != nil {
                footCenter = (toViewController.footView?.center)!
                toViewController.footView?.center = CGPointMake(footCenter!.x, CGRectGetMaxY((toViewController.tableView?.frame)!)+(toViewController.footView?.frame.size.height)!/2)
            }
            
            toViewController.bgView.alpha = 0
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                toViewController.bgView.alpha = 1
                toViewController.tableView?.center = tableCenter;
                if toViewController.footView != nil {
                    toViewController.footView?.center = footCenter!
                }
                }, completion: { (finsh) in
                    transitionContext.completeTransition(true)
            })
        }else {
            let fromViewController:LEAlertController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! LEAlertController
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                fromViewController.bgView.alpha = 0
                let tableCenter: CGPoint = (fromViewController.tableView?.center)!
                
                
                fromViewController.tableView?.center = CGPointMake(tableCenter.x, ScreenHEIGHT + fromViewController.tableView!.frame.size.height/2)
                var footCenter:CGPoint?
                if fromViewController.footView != nil {
                    footCenter = (fromViewController.footView?.center)!
                    fromViewController.footView?.center = CGPointMake(footCenter!.x, CGRectGetMaxY((fromViewController.tableView?.frame)!)+(fromViewController.footView?.frame.size.height)!/2)
                }
                }, completion: { (finsh) in
                    transitionContext.finishInteractiveTransition()
                    transitionContext.completeTransition(true)
            })
        }
    
    }
    
    func alertShowAnimateTransition(transitionContext: UIViewControllerContextTransitioning)  {
    
        let containerView:UIView = transitionContext.containerView()!
        containerView.backgroundColor = UIColor.clearColor()
        if self.preasentType == .Preasent {
            let toViewController:LEAlertController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! LEAlertController
            toViewController.view.frame = CGRectMake(0, 0, ScreenWIDTH, ScreenHEIGHT)
            containerView.addSubview(toViewController.view)
            
            
            
            let alerViewa: AnimaAlertView = toViewController.alertView!
             alerViewa.transform = CGAffineTransformMakeScale(0.3, 0.3)
            alerViewa.alpha = 0
            toViewController.bgView.alpha = 0
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                toViewController.bgView.alpha = 1
                alerViewa.alpha = 1
                alerViewa.transform = CGAffineTransformIdentity
                }, completion: { (finsh) in
                    transitionContext.completeTransition(true)
            })
        }else {
            let fromViewController:LEAlertController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! LEAlertController
            
            
            let alerViewa: AnimaAlertView = fromViewController.alertView!
            
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                fromViewController.bgView.alpha = 0
                alerViewa.alpha = 0
                alerViewa.transform = CGAffineTransformMakeScale(0.3, 0.3)
                }, completion: { (finsh) in
                    transitionContext.finishInteractiveTransition()
                    transitionContext.completeTransition(true)
            })
        }
        
        
    }
    
    
    //动画持续时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    }
}



// custom AlertView
class AnimaAlertView: UIView {
    
    
    
    let titleTopMargin: CGFloat = 20
    let titleLableHeight:CGFloat = 21
    
    let titleAndContentMargin: CGFloat = 20
    
    let contentLeftOrRigntMargin: CGFloat = 10
    
    
    lazy var lableTitle: UILabel! = {
        
        let titleLalbe = UILabel.init(frame: CGRectZero)
        titleLalbe.font = UIFont.systemFontOfSize(16)
        titleLalbe.textAlignment = .Center
        
        titleLalbe.textColor = UIColor.colorFromRGB(0x333333)
        return titleLalbe
    }()
    lazy var lableContent: UILabel! = {
        let content = UILabel.init(frame: CGRectZero)
        content.font = UIFont.systemFontOfSize(14)
        content.textAlignment = .Center
        content.numberOfLines = 0
        content.textColor = UIColor.colorFromRGB(0x666666)
        return content
        
    }()
    private var btnCancel: UIButton?
    private var btnSure: UIButton?
    private var title: String?
    private var cancelTitle: String?
    private var sureTitle: String?
    private var messageTitle: String?
    
    
    private var cancleHandlerBlock: handlerBlock?
    
    private var cancleAlertAction: LEAlertAction?
    
    private var sureHandlerBlock: handlerBlock?
    
    private var sureAlertAction: LEAlertAction?
    
    
    
    typealias didHandlerBlock = () -> Void
    
    var btnHandlerBlock: didHandlerBlock!
    
    init(frame: CGRect,title:String?,message: String?) {
        
        self.title = title
        self.messageTitle = message
        super.init(frame: frame)
        self.setup()
        
        
    }
    
    private func setup() {
        self.backgroundColor = UIColor .whiteColor()
        self.addSubview(self.lableTitle)
        self.lableTitle.text = self.title
        
        self.addSubview(self.lableContent)
        
        if self.title == nil {
            self.lableTitle.frame = CGRectMake(0, 0, self.frame.width, titleLableHeight - 10)
            
        }else {
            self.lableTitle.frame = CGRectMake(0, titleTopMargin, self.frame.width, titleLableHeight)
        }
        if self.messageTitle == nil {
            self.lableContent.frame = CGRectMake(8, CGRectGetMaxY(self.lableTitle.frame) + titleAndContentMargin, self.frame.width - contentLeftOrRigntMargin * 2, 5)
        }else {
            self.lableContent.text = self.messageTitle
            let size = self.lableContent.sizeThatFits(CGSizeMake(self.frame.width, 20))
            self.lableContent.frame = CGRectMake(8, CGRectGetMaxY(self.lableTitle.frame) + titleAndContentMargin, self.frame.width - contentLeftOrRigntMargin * 2, size.height)
        }
    }
    
    func addButon(action: LEAlertAction) {
        if self.btnCancel == nil {
            let btn = UIButton.init(type: UIButtonType.Custom)
            btn.backgroundColor = UIColor.colorFromRGB(0xabcd03)
            btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            btn.titleLabel?.font = UIFont.systemFontOfSize(16)
            btn.setTitle(action.title, forState: .Normal)
            btn.addTarget(self, action: #selector(AnimaAlertView.cancleAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.btnCancel = btn
            self.cancleAlertAction = action
            self.cancleHandlerBlock = action.handBlock
            
            self.addSubview(self.btnCancel!)
            self.btnCancel!.frame = CGRectMake((self.frame.width - 105)/2, CGRectGetMaxY(self.lableContent.frame) + 20, 105, 36)
            
            btn.clipsToBounds = true
            btn.layer.cornerRadius = 5
            var r = self.frame
            
            let heiht = CGRectGetMaxY((self.btnCancel?.frame)!) + 20
            r.size.height = heiht
            
            r.origin.y = (ScreenHEIGHT - heiht)/2 - 20
            
            self.frame = r
            return
        }
        
        if self.btnSure == nil {
            let btn = UIButton.init(type: UIButtonType.Custom)
            btn.backgroundColor = UIColor.colorFromRGB(0xabcd03)
            btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            btn.titleLabel?.font = UIFont.systemFontOfSize(16)
            btn.setTitle(action.title, forState: .Normal)
            btn.addTarget(self, action: #selector(AnimaAlertView.sureAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.btnSure         = btn
            self.sureAlertAction = action
            self.sureHandlerBlock = action.handBlock
            self.addSubview(self.btnSure!)
            self.btnCancel!.frame = CGRectMake((self.frame.width/2 - 105)/2, CGRectGetMaxY(self.lableContent.frame) + 20, 105, 36)
            self.btnSure!.frame = CGRectMake((self.frame.width/2 - 105)/2 + self.frame.width/2, CGRectGetMaxY(self.lableContent.frame) + 20, 105, 36)
            btn.clipsToBounds = true
            btn.layer.cornerRadius = 5
            var r = self.frame
            
            let heiht = CGRectGetMaxY((self.btnCancel?.frame)!) + 20
            r.size.height = heiht
            r.origin.y = (ScreenHEIGHT - heiht)/2 - 20
            self.frame = r
            return
        }
        
    }
    
    func cancleAction(sender: UIButton) {
        
        self.cancleHandlerBlock!(view: self.cancleAlertAction)
        self.btnHandlerBlock()
    }
    
    func sureAction(sender: UIButton) {
        
        self.sureHandlerBlock!(view: self.sureAlertAction)
        self.btnHandlerBlock()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
extension UIColor {
    class func colorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
