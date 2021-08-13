
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lockView: UIViewDesignable!
    @IBOutlet weak var recordView: UIViewDesignable!
    @IBOutlet weak var recordImageView: UIImageView!
    @IBOutlet weak var lockArrow: UIImageView!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var cancelArrow: UIImageView!
    @IBOutlet weak var recordIcon: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var recordClass: RecordClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordClass = RecordClass(viewController: self, lockView: lockView, recordView: recordView, recordImageView: recordImageView, lockArrow: lockArrow,
                                  cancelView: cancelView, cancelLabel: cancelLabel, cancelArrow: cancelArrow, recordIcon: recordIcon, timeLabel: timeLabel)
        
        recordClass.recordingStarted = recordingStarted
        recordClass.recordingEnded = recordingEnded
        recordClass.recordingCanceled = recordingCanceled
    }
    
    @IBAction func touch(_ sender: UIButton) {
        recordClass.touch()
    }
    
    @IBAction func touchEnded(_ sender: UIButton) {
        recordingEnded()
        recordClass.reset()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        recordingCanceled()
        recordClass.reset()
    }
    
    func recordingStarted() {
        print("Recording Started")
    }
    
    func recordingEnded() {
        print("Recording Ended")
    }
    
    func recordingCanceled() {
        print("Recording Canceled")
    }
}
