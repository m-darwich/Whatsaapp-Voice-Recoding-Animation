
import UIKit

class RecordClass {
    
    var viewController: UIViewController!
    
    var lockView: UIViewDesignable!
    var recordView: UIViewDesignable!
    var recordImageView: UIImageView!
    var lockArrow: UIImageView!
    var cancelView: UIView!
    var cancelLabel: UILabel!
    var cancelArrow: UIImageView!
    var recordIcon: UIImageView!
    var timeLabel: UILabel!
    
    var started = Bool()
    var locked = Bool()
    var canceled = Bool()
    
    var seconds = Int()
    var minutes = Int()
    
    var timer: Timer!
    
    var recordingStarted: (() -> ())!
    var recordingEnded: (() -> ())!
    var recordingCanceled: (() -> ())!
    
    init(viewController: UIViewController, lockView: UIViewDesignable, recordView: UIViewDesignable, recordImageView: UIImageView, lockArrow: UIImageView,
         cancelView: UIView, cancelLabel: UILabel, cancelArrow: UIImageView, recordIcon: UIImageView, timeLabel: UILabel) {
        
        self.viewController = viewController
        self.lockView = lockView
        self.recordView = recordView
        self.recordImageView = recordImageView
        self.lockArrow = lockArrow
        self.cancelView = cancelView
        self.cancelLabel = cancelLabel
        self.cancelArrow = cancelArrow
        self.recordIcon = recordIcon
        self.timeLabel = timeLabel
        
        lockView.isHidden = true
        cancelView.isHidden = true
        
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(swipeAction(gesture:)))
        viewController.view.addGestureRecognizer(swipe)
        
        animateArrowUp()
    }
    
    func touch() {
        if locked && started {
            return
        }
        UIView.animate(withDuration: 0.1) {
            self.recordView.transform = CGAffineTransform(scaleX: 2, y: 2)
        }
        lockView.isHidden = false
        cancelView.isHidden = false
        
        startRecording()
    }
    
    @objc func swipeAction(gesture: UIPanGestureRecognizer) {
        let start = gesture.location(in: viewController.view)
        
        let isStartX = start.x > recordView.frame.minX && start.x < recordView.frame.maxX
        let isStartY = start.y > recordView.frame.minY && start.x < recordView.frame.maxY
        
        if locked {
            return
        }
        if isStartX && isStartY {
            let translation = gesture.translation(in: viewController.view)
            
            if translation.x < 0 && translation.x < translation.y {
                if translation.x > -140 {
                    recordView.transform = CGAffineTransform(translationX: translation.x, y: 0).scaledBy(x: 2, y: 2)
                    cancelView.transform = CGAffineTransform(translationX: translation.x, y: 0)
                    cancelLabel.alpha = 1 + translation.x/140
                    cancelArrow.alpha = 1 + translation.x/140
                } else {
                    canceled = true
                    recordingCanceled()
                    reset()
                }
            } else if translation.y < 0 {
                cancelView.transform = .identity
                cancelLabel.alpha = 1
                cancelArrow.alpha = 1
                
                if translation.y > -140 {
                    recordView.transform = CGAffineTransform(translationX: 0, y: translation.y).scaledBy(x: 2, y: 2)
                } else {
                    locked = true
                    
                    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: []) {
                        self.recordView.transform = .identity
                    } completion: { _ in
                        
                    }
                    recordImageView.image = #imageLiteral(resourceName: "icon_send")
                    
                    lockView.isHidden = true
                    cancelLabel.text = "CANCEL"
                    cancelLabel.textColor = UIColor(named: "red")
                    cancelArrow.isHidden = true
                }
            }
        }
        if gesture.state == .ended {
            if !locked {
                if !canceled {
                    recordingEnded()
                    reset()
                }
                canceled = false
            }
        }
    }
    
    func reset() {
        started = false
        locked = false
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: []) {
            self.recordView.transform = .identity
        } completion: { _ in
            
        }
        cancelView.transform = .identity
        cancelLabel.alpha = 1
        cancelArrow.alpha = 1
        
        lockView.isHidden = true
        cancelView.isHidden = true
        recordImageView.image = #imageLiteral(resourceName: "icon_record")
        
        cancelLabel.text = "Slide to cancel"
        cancelLabel.textColor = UIColor(named: "gray")
        cancelArrow.isHidden = false
        
        timer.invalidate()
    }
    
    func startRecording() {
        started = true
        
        seconds = 0
        minutes = 0
        timeLabel.text = "0:00"
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        
        recordingStarted()
    }
    
    @objc func updateUI() {
        seconds += 1
        
        if seconds == 60 {
            seconds = 0
            minutes += 1
        }
        if seconds < 10 {
            timeLabel.text = "\(minutes):0\(seconds)"
        } else {
            timeLabel.text = "\(minutes):\(seconds)"
        }
    }
    
    func animateArrowUp() {
        UIView.animate(withDuration: 1) {
            self.lockArrow.transform = CGAffineTransform(translationX: 0, y: -4)
            self.recordIcon.alpha = 0.2
        } completion: { _ in
            self.animateArrowDown()
        }
    }
    
    func animateArrowDown() {
        UIView.animate(withDuration: 1) {
            self.lockArrow.transform = CGAffineTransform(translationX: 0, y: 4)
            self.recordIcon.alpha = 1
        } completion: { _ in
            self.animateArrowUp()
        }
    }
}
