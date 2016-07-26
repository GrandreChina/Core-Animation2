//A. CGAffineTransform
//从CG就可以看出它是属于Core Graphics的东西，实际上UIView的transform属性就是CGAffineTransform类型，用它可以做二维平面上的缩放、旋转、平移。
//B.CATransform3D（layer）
//它可以做到让图层在三维空间内平移、旋转等。

//UIView的动画跟CAAnimation动画的异同：
//1.都能控制动画开始执行时刻。uiview的delay。CA中的beginTime。
//2.都能在动画结束后实现控制。uiview有闭包。CA中有代理函数didFinish。
//3.uiView有关键帧动画，CA中也有,而且更为丰富。
//4.uiView组合动画用cgaffinetransformconcat。CA中用CAanimationGroup，并支持多组合。
//    uiview 的多组合则可以通过创建多个uiview.animation来实现。多是指两个以上。
//    这里的组合是指为同一个对象的不同属性进行组合。
//    如果是不同对象要实现同一个动画，则直接在uiview的内容中添加。或者直接在CA中赋予多个对象的layer。
//5.uiView实现2D或者3D动画，取决于里面设置的动画属性。若设置的是layer层，则可以实现3D动画。(rotation属性可以体现)
//  CA动画则取决于key。如果是transform，则可以3D.如果是transform.rotation，则可以是2D。
//    CA中transform属性有rotation，scale，translation。
//    CA中key还可以是bounds，position，opacity。这里的position等价于uiview的center。
//6.uiview动画完毕之后属性已经更改。CA动画则不会改变实际位置，即使表面改变了。

//并非所有的UIView 的属性都能被动画，通常UIView可以添加动画的属性有bounds，frame,center,alpha,backgroundColor,transform
//属性名         	作用
//frame         	控制UIView的大小和该UIView在superview中的相对位置。
//bounds        	控制UIView的大小
//center        	控制UIView的位置
//transform     	控制UIView的缩放，旋转角度等固定好中心位置之后的变化
//alpha         	控制UIView的透明度
//backgroundColor	控制UIView的背景色
//contentStretch    控制UIView的拉伸方式
//position

//UIView.animateWithDuration可以实现2D，3D动画，取决于闭包里面的属性。
//如果view.transform = CGAffineTransformMake 则是2D动画。
//如果view.layer.transform = CATransform3DMake 则是3D动画。rotation属性才能体现3D效果

//A.CABasicAnimation
//CABasicAnimation(keyPath: "transform")也可以实现2D和3D动画。取决于keyPath。
//如果keyPath: "transform" 则是3D动画。rotation属性才能体现3D效果
//如果keyPath: "transform.rotation" 则是2D动画。

//2D动画变换前的原始状态。view.transform = CGAffineTransformIdentity
//3D动画变换前的原始状态view.layer.transform = CATransform3DIdentity


import UIKit
import QuartzCore

class ViewController: UIViewController {
    @IBOutlet weak var btn: UIButton!
    var textView:UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
    
        textView = UIView(frame: CGRectMake(40,40,150,150))
        textView?.layer.backgroundColor = UIColor.redColor().CGColor
//        设置背景颜色的第二种方法
//        textView?.backgroundColor = UIColor(patternImage: UIImage(named: "swift_logo")!)
        textView?.layer.contents = UIImage(named: "swift_logo")?.CGImage
        textView?.layer.contentsGravity = kCAGravityResizeAspect
        textView?.alpha = 1
//    
//        var effectLayer = CATransform3DIdentity
//        effectLayer.m34 = -1.0/500
//        textView?.layer.transform = effectLayer
        
        self.view.addSubview(textView!)
        
        self.view.layer.contents = UIImage(named: "swift_logo")?.CGImage
        self.view.layer.contentsGravity = kCAGravityResizeAspect
        
        btn.addTarget(self, action: "willDo", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.multipleTouchEnabled = false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
  
//        
        self.textView?.layer.removeAllAnimations()
//        self.willDo()
        self.performSelector("willDo", withObject: nil, afterDelay: 0)
        
//        print("2016--1--17")
//       NSThread.sleepForTimeInterval(2)
//        print("2016--1--18")
    }

    
    
    
//    转场效果与图片内容无关
    func uiUiewTransition(){
//        UIView.setAnimationDelegate(self)
        
        UIView.transitionWithView(textView!, duration: 0.3, options: .TransitionCurlDown , animations: { () -> Void in
            
            self.textView?.layer.contents = self.imageArr[random() % self.imageArr.count].CGImage
            
            self.textView?.hidden = false
//            self.textView?.alpha = 1
            }, completion: {(_) in
                self.uiviewtransition2()
    
            })
        
        
    }
    
    
    var index:Int = 0
    let imageArr = (1...6).map { (number) -> UIImage in
        UIImage(named:"\(number)")!}
    
    func uiviewtransition2(){
      UIView.animateWithDuration(0.5, delay: 1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
        self.textView?.transform = CGAffineTransformMakeTranslation(600, 0)
        }) { (_) -> Void in
            self.textView?.transform = CGAffineTransformIdentity
            self.textView?.hidden = true
            
            self.uiUiewTransition()
            }
    }
    
    func willDo(){
        print("hello grandre")
//        self.textView?.layer.removeAllAnimations()
       UIView.animateWithDuration(4,animations: { () -> Void in
        //            self.textView?.transform = CGAffineTransformMakeTranslation(0, 300/2)
        //            self.textView?.transform =    CGAffineTransformMakeScale(2, 2)
        self.textView?.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        //            普通动画组合需要用concat
        //            而利用JNW动画框架的时候，则直接创建多个JNW实例即可。JNW动画本身可以控制动画时间，所以无需放进杜蕾斯运动里面。要想先后执行JNW动画，则需把动画放进时间链中。
        //          self.textView?.transform =   CGAffineTransformConcat(CGAffineTransformMakeScale(2, 2),CGAffineTransformMakeTranslation(0, 300))
        //            加个颜色变化
        self.textView?.backgroundColor = UIColor.greenColor()
        }) { (finish:Bool) -> Void in
            self.textView?.transform = CGAffineTransformIdentity
            self.textView?.backgroundColor = UIColor.redColor()
            if finish {print("finish")}
        }
        
    }
//
    func will3DAnimate(){
        
        UIView.animateWithDuration(2, animations: { () -> Void in
       
//            下面直接组合是不行的
            self.textView!.layer.transform = CATransform3DMakeRotation( CGFloat(M_PI * 3.0 / 4.0),0, 1, 0)//(角度，x，y，z)
//            self.textView?.layer.transform = CATransform3DMakeTranslation(50, 200, 0)
//            self.textView?.layer.transform = CATransform3DMakeScale(2, 2, 2)
//            self.textView?.layer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeScale(2, 2))
            }, completion: { (finish: Bool) -> Void in
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                    self.textView!.layer.transform = CATransform3DIdentity
                })
        })
        
        
    }
    
    func will3DBasicAnimation2(){
        let animate = CABasicAnimation(keyPath: "transform")
        
        animate.toValue =  NSValue(CATransform3D: CATransform3DMakeScale(1.2,1.2,1.2))
        //       animate.toValue = M_PI
        animate.duration = 2
        //      重复两次
        animate.repeatCount = 1
        
        //      停留在动画执行完的状态。但实际图片状态还是动画前的状态。
        animate.removedOnCompletion = false
        animate.fillMode = kCAFillModeForwards
        //      代理其实已经默认给了self
        animate.delegate = self
        
        self.textView?.layer.addAnimation(animate, forKey: "aaa")
    }
    func will3DBasicAnimation(){
        let animate = CABasicAnimation(keyPath: "transform")
        
        animate.toValue =  NSValue(CATransform3D: CATransform3DMakeRotation(CGFloat(M_PI),0,1,0))
//       animate.toValue = M_PI
        animate.duration = 2
//      重复两次
        animate.repeatCount = 1
        
//      停留在动画执行完的状态。但实际图片状态还是动画前的状态。
        animate.removedOnCompletion = false
        animate.fillMode = kCAFillModeForwards
//      代理其实已经默认给了self
        animate.delegate = self
        
        self.textView?.layer.addAnimation(animate, forKey: "aaa")
    }

    func animateOfScale() {
        let animate = CABasicAnimation(keyPath: "bounds")
        
        animate.toValue = NSValue(CGRect: CGRectMake(100, 100, 200, 200))
        
        animate.duration = 2
        
        animate.removedOnCompletion = false
        
        animate.fillMode = kCAFillModeForwards
        
        animate.delegate = self
        
        self.textView!.layer.addAnimation(animate, forKey: "bcd")
    }
    
    func animationScale2(){
        let animate = CABasicAnimation(keyPath: "transform.scale")
        animate.toValue = 2
        animate.duration = 2
        self.textView?.layer.addAnimation(animate, forKey: "haha")
    }
    
    //平移动画
    func animateOfTranslation() {
        //keyPath放需要执行怎么样的动画
        let animate = CABasicAnimation(keyPath: "position")
        
        //layer从哪里来
        animate.fromValue = NSValue(CGPoint: CGPointMake(100, 100))
        //到哪去
        animate.toValue = NSValue(CGPoint: CGPointMake(200, 200))
        
        //    在当前位置的基础上增加多少
        //    animate.byValue = [NSValue valueWithCGPoint:CGPointMake(0, 300)];
        
        animate.duration = 1
        //设置动画执行完毕之后不删除动画
        animate.removedOnCompletion = false
        
        //设置保存动画的最新状态
        animate.fillMode = kCAFillModeForwards
        
        animate.delegate = self
        
        self.textView!.layer.addAnimation(animate, forKey: "abc")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
