//
//CAAnimation:
//所有动画对象的父类，负责控制动画的持续时间和速度，是个抽象类，不能直接使用，应该使用它具体的子类
//duration：动画的持续时间
//repeatCount：动画的重复次数
//repeatDuration：动画的重复时间
//removedOnCompletion：默认为YES，代表动画执行完毕后就从图层上移除，图形会恢复到动画执行前的状态。如果想让图层保持显示动画执行后的状态，那就设置为NO，不过还要设置fillMode为kCAFillModeForwards
//fillMode：决定当前对象在非active时间段的行为.比如动画开始之前,动画结束之后
//beginTime：可以用来设置动画延迟执行时间，若想延迟2s，就设置为CACurrentMediaTime()+2，CACurrentMediaTime()为图层的当前时间
//timingFunction：速度控制函数，控制动画运行的节奏
//delegate：动画代理
//keyPath: 通过指定CALayer的一个属性名称达到相应的动画效果，比如说，指定"position"为keyPath，就修改CALayer的position属性值，以达到平移的动画效果

//
//B. CAKeyFrameAnimation
//
//CApropertyAnimation的子类，跟CABasicAnimation的区别是：CABasicAnimation只能从一个数值(fromValue)变到另一个数值(toValue)，而CAKeyframeAnimation会使用一个NSArray保存这些数值
//
//属性解析：
//
//values：就是上述的NSArray对象。里面的元素称为”关键帧”(keyframe)。动画对象会在指定的时间(duration)内，依次显示values数组中的每一个关键帧
//
//path：可以设置一个CGPathRef\CGMutablePathRef,让层跟着路径移动。path只对CALayer的anchorPoint和position起作用。如果你设置了path，那么values将被忽略
//
//keyTimes：可以为对应的关键帧指定对应的时间点,其取值范围为0到1.0,keyTimes中的每一个时间值都对应values中的每一帧.当keyTimes没有设置的时候,各个关键帧的时间是平分的
//
//CABasicAnimation可看做是最多只有2个关键帧的CAKeyframeAnimation

//C. CAAnimationGroup
//
//CAAnimation的子类，可以保存一组动画对象，将CAAnimationGroup对象加入层后，组中所有动画对象可以同时并发运行.支持多个动画组合。
//
//属性解析：
//
//animations：用来保存一组动画对象的NSArray
//
//默认情况下，一组动画对象是同时运行的，也可以通过设置动画对象的beginTime属性来更改动画的开始时间

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var btn: UIButton!
    var textView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView = UIView(frame: CGRectMake(40,40,150,150))
        textView?.layer.backgroundColor = UIColor.redColor().CGColor
        textView?.layer.contents = UIImage(named: "swift_logo")?.CGImage
        textView?.layer.contentsGravity = kCAGravityResizeAspect
        self.view.addSubview(textView!)
        
        btn.addTarget(self, action: "btnFunct", forControlEvents: UIControlEvents.TouchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func btnFunct(){
        self.textView!.layer.removeAnimationForKey("aaa")
    }
 
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.animateTest()
       
    }
    
    func animateTest2() {
        //        self.redView.layer.anchorPoint = CGPointMake(self.redView.frame.width / 2, self.redView.frame.height / 2)
        let keyAnimate = CAKeyframeAnimation(keyPath: "transform.rotation")
        
        keyAnimate.values = [ -2.14 / 20, 2.14 / 20, -2.14 / 20];
//        keyAnimate.values = [  1, 1.2,1];
        
        keyAnimate.removedOnCompletion = false
        keyAnimate.fillMode = kCAFillModeForwards
        
        keyAnimate.duration = 0.05
        
        keyAnimate.delegate = self
        keyAnimate.repeatCount = Float(CGFloat.max)
//        keyAnimate.repeatCount = 1
        self.textView!.layer.addAnimation(keyAnimate, forKey: "aaa")
    }

    func animateTest1() {
        let keyAnimate = CAKeyframeAnimation(keyPath: "position")
        
        let path = CGPathCreateMutable()
        CGPathAddEllipseInRect(path, nil, CGRectMake(0, 100, 200, 200))
        keyAnimate.path = path
        
        //设置动画的进度快慢，可以先快后慢，先慢后快等
        keyAnimate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        keyAnimate.removedOnCompletion = false
        keyAnimate.fillMode = kCAFillModeForwards
        
        keyAnimate.duration = 2
        keyAnimate.repeatCount = 3
        
        keyAnimate.delegate = self
        
        self.textView!.layer.addAnimation(keyAnimate, forKey: "aaa")
    }
    
    func animateTest() {
        let keyAnimate = CAKeyframeAnimation(keyPath: "position")
//        let v1 = NSValue(CGPoint: CGPointMake(self.textView!.frame.origin.x, self.textView!.frame.origin.y))
//        let v2 = NSValue(CGPoint: CGPointMake(100, 200))
//        let v3 = NSValue(CGPoint: CGPointMake(0, 200))
//        let v4 = NSValue(CGPoint: CGPointMake(0, 100))
//        let v5 = NSValue(CGPoint: CGPointMake(self.textView!.frame.origin.x, self.textView!.frame.origin.y))
//        keyAnimate.values = [v1, v2, v3, v4, v5]
        
//        let arr = [ CGPointMake(self.textView!.frame.origin.x, self.textView!.frame.origin.y),CGPointMake(100, 200),CGPointMake(0, 200),CGPointMake(0, 100),CGPointMake(self.textView!.frame.origin.x, self.textView!.frame.origin.y)].map { (point) -> NSValue in
//            NSValue(CGPoint: point)
//        }
//        
        
        
        let arr = [(20,30),(100,100),(100,300),(50,300)].map{ (x:Int,y:Int) -> NSValue in
            NSValue(CGPoint: CGPoint(x: x, y: y))
            
        }
        
        keyAnimate.values = arr
        //设置动画的进度快慢，可以先快后慢，先慢后快等
        keyAnimate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        keyAnimate.removedOnCompletion = false
        keyAnimate.fillMode = kCAFillModeForwards
        
        keyAnimate.duration = 2
        
        keyAnimate.delegate = self
        
        self.textView!.layer.addAnimation(keyAnimate, forKey: "aaa")
    }
    
    func animateTestThree() {
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, 150))
        
        //这是二次贝塞尔曲线的接口，利用此接口，可以定义一条贝塞尔曲线轨迹
        path.addCurveToPoint(CGPointMake(400, 150), controlPoint1: CGPointMake(75, 0), controlPoint2: CGPointMake(225, 300))
//        path.addQuadCurveToPoint(CGPointMake(400, 150), controlPoint: CGPointMake(225, 300))
        
        
        let plane = UIImageView(frame: CGRectMake(0, 0, 85, 60))
        //这里可以放一张飞机图片
        plane.image = UIImage(named: "swift_logo")
        plane.center = CGPointMake(0, 150)
        plane.layer.anchorPoint = CGPointMake(0.5, 0.5)
        self.view.addSubview(plane)
        
        let animate = CAKeyframeAnimation(keyPath: "position")
        animate.duration = 4
        animate.path = path.CGPath
        animate.fillMode = kCAFillModeForwards
        animate.removedOnCompletion = false
        animate.delegate = self
        
        //设置此属性，可以使得飞机在飞行时自动调整角度
        animate.rotationMode = kCAAnimationRotateAuto
        
        //        animate.setValue(plane.layer, forKey: "plane.layer")
        plane.layer.addAnimation(animate, forKey: "animateTestThree")
    }

    func animationGroup(){
        let basicAnimate = CABasicAnimation(keyPath: "transform.scale")
        basicAnimate.toValue = 1.5
        
        let keyFrameAnimate = CAKeyframeAnimation(keyPath: "position")
        
        let path = CGPathCreateMutable()
        CGPathAddEllipseInRect(path, nil, CGRectMake(100, 200, 150, 150))
        keyFrameAnimate.path = path
        
        let animateGroup = CAAnimationGroup()
        animateGroup.animations = [basicAnimate, keyFrameAnimate]
        animateGroup.duration = 2
        animateGroup.fillMode = kCAFillModeForwards
        animateGroup.removedOnCompletion = false
        
        self.textView!.layer.addAnimation(animateGroup, forKey: "aaa")
    }
}
