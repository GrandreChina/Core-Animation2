
//D. CATransition
//
//CAAnimation的子类，用于做转场动画，能够为层提供移出屏幕和移入屏幕的动画效果。iOS比Mac OS X的转场动画效果少一点
//
//UINavigationController就是通过CATransition实现了将控制器的视图推入屏幕的动画效果
//
//属性解析:
//
//type：动画过渡类型
//
//subtype：动画过渡方向
//
//startProgress：动画起点(在整体动画的百分比)
//
//endProgress：动画终点(在整体动画的百分比)
import UIKit

class ThreViewController: UIViewController {
    var flag:Bool = false
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        flag = !flag
        if flag {
            lunBo()
//            sprintAnimation()
        }else{
            self.ifAutoFinishAnimate = false
            self.imageV.layer.removeAllAnimations()
        }
    }
    
    
    @IBAction func ifAutoPlay(sender: UISwitch) {
        if sender.on{
           lunBo()
            
        }else{
            self.ifAutoFinishAnimate = false
            self.imageV.layer.removeAllAnimations()
//            self.view.layer.removeAllAnimations()
        }
    }

    func lunBo(){
        if index == 0{
            index = 5
        }else{
            index -= 1
        }
        imageV.image = imageArr[index]
//        self.view.layer.contents = imageArr[index]
//        self.view.layer.contentsGravity = kCAGravityResizeAspectFill
        
        let transition = CATransition()
        transition.delegate = self
        //动画过渡类型
        let ramdom = random() % imageArr.count
        transition.type = effectArr[ramdom]
        
        /*
        fade
        push
        moveIn
        reveal
        cube
        oglFlip
        suckEffect
        rippleEffect
        pageCurl
        pageUnCurl
        cameraIrisHollowOpen
        cameraIrisHollowClose
        */
        
        //动画过渡类型方向
        transition.subtype = kCATransitionFromRight
        
        transition.duration = 2
        transition.repeatCount = 1
        
        transition.setValue("one", forKeyPath: "whichAnimation")
        ifAutoFinishAnimate = true
        
        self.imageV.layer.addAnimation(transition, forKey: "111")
//        self.view.layer.addAnimation(transition, forKey: "222")
    }
   
    
       @IBAction func next(sender: AnyObject) {
        ifAutoFinishAnimate = false
        self.iv.layer.removeAllAnimations()//这里没打印是因为标志置false了
//        self.transition()
        performSelector(#selector(self.transition), withObject: nil, afterDelay: 0.3)
        
//        if index == 5{
//            index = 0
//        }else{
//            index++
//        }
////        imageV.image = imageArr[index]
        
        
//        let transition = CATransition()
//        transition.delegate = self
//        //动画过渡类型
//        transition.type = "pageCurl"
//        
//        //动画过渡类型方向
//        transition.subtype = kCATransitionFromLeft
//        
//        transition.duration = 1
////        一定要在加载动画之前设置setValue
//        transition.setValue("second", forKey: "whichAnimation")
//        
//        self.iv.layer.addAnimation(transition, forKey: nil)
        
       
    }
    
    @IBAction func stopAnimate(sender: AnyObject) {
        ifAutoFinishAnimate = false
        self.iv.layer.removeAllAnimations()//这句会引起调用委托函数
    }
    func transition(){
        let transition = CATransition()
        transition.delegate = self
        //动画过渡类型
        transition.type = "pageCurl"
        
        //动画过渡类型方向
        transition.subtype = kCATransitionFromLeft
        
        transition.duration = 1
        //        一定要在加载动画之前设置setValue
        transition.setValue("second", forKey: "whichAnimation")
        
        self.iv.layer.addAnimation(transition, forKey: nil)
        ifAutoFinishAnimate = true
    }
    func sprintAnimation(){
//        print("grandre")
//        let sprintAni = CASpringAnimation(keyPath: "position")
//        sprintAni.damping = 9
//        sprintAni.mass = 5
//        sprintAni.stiffness = 50
//        
//        sprintAni.duration = 3
//        sprintAni.toValue = NSValue(CGPoint:CGPointMake(self.iv.layer.position.x,300))
//        sprintAni.fillMode = kCAFillModeForwards
//        sprintAni.removedOnCompletion = false
//        
//        iv.layer.addAnimation(sprintAni, forKey: "111")
        
        
        print("grandre")
        let sprintAni = CASpringAnimation(keyPath: "position.y")
        sprintAni.damping = 10
        sprintAni.mass = 5
        sprintAni.stiffness = 50
        sprintAni.initialVelocity = 3
        
        sprintAni.duration = 2
        sprintAni.toValue = 300
            
        sprintAni.fillMode = kCAFillModeForwards
        sprintAni.removedOnCompletion = false
        
        iv.layer.addAnimation(sprintAni, forKey: "111")
        
    }
//  如果CA动画是非连续动画，CA动画正在进行时再次触发，会停止掉上一次动画，重新播放第二次动画。委托协议是执行了两次。
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        print("----gr-")
        if ifAutoFinishAnimate == true{
            switch anim.valueForKey("whichAnimation") as! String{
            case "one" :print("hello")
            
//                    self.imageV.layer.removeAllAnimations()
                        self.lunBo()
            case "second" :print("finish")
                
            
                self.next("2")
            default :print("baba")
            }
        }
    }
    /*
    fade
    push
    moveIn
    reveal
    cube
    oglFlip
    suckEffect
    rippleEffect
    pageCurl
    pageUnCurl
    cameraIrisHollowOpen
    cameraIrisHollowClose
    */
    let effectArr = ["fade","push","moveIn","reveal","cube","oglFlip","suckEffect","rippleEffect","pageCurl","pageUnCurl","cameraIrisHollowOpen","cameraIrisHollowCloew"]
    var ifAutoFinishAnimate:Bool = false
    var imageV:UIImageView!
    var index:Int = 0
    let imageArr = (1...6).map { (number) -> UIImage in
        UIImage(named:"\(number)")!}
    
    @IBOutlet weak var iv: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageV = UIImageView(frame: self.view.frame)
        imageV.image = imageArr[index]
//        self.view.addSubview(imageV)
        
        iv.backgroundColor = UIColor.redColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }

}
