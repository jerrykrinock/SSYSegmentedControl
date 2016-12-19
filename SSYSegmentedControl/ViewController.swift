import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var hereThereLabel: UILabel!
    @IBOutlet weak var niceControl: SSYSegmentedControl!
    
    @IBAction func hereThereAction(sender: SSYSegmentedControl) {
        if let selectedIndex = sender.selectedSegmentIndex {
            hereThereLabel.text = String(format:
                NSLocalizedString("selected index = %ld", comment: ""),
                                           selectedIndex)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* The following works because the height was assigned in
         Interface Builder.  But, in general, it is a bad idea to rely on
         a view's `frame` like this when Auto Layout is in use. */
        let fontSize = 0.65 * niceControl.frame.size.height
        niceControl.font = UIFont.systemFont(ofSize:fontSize)
        
        /* For fun and testing, we create the Great Lakes segmented control,
         and the label above it, entirely in code. */
        let label = self.createALabel()
        self.createGreatLakesControl(below: label)
    }
    
    func createALabel() -> UILabel {
        let label = UILabel()
        label.text = "This one is created one entirely in code:"
        label.font = UIFont.systemFont(ofSize: 14.0)
        self.view.addSubview(label)
        
        // Layout:
        label.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(
            item:label,
            attribute:NSLayoutAttribute.top,
            relatedBy:NSLayoutRelation.equal,
            toItem:niceControl,
            attribute:NSLayoutAttribute.bottom,
            multiplier:1.0,
            constant:40.0))
        constraints.append(NSLayoutConstraint(
            item:label,
            attribute:NSLayoutAttribute.centerX,
            relatedBy:NSLayoutRelation.equal,
            toItem:self.view,
            attribute:NSLayoutAttribute.centerX,
            multiplier:1.0,
            constant:0.0))
        self.view.addConstraints(constraints)
        
        return label
    }
    
    func createGreatLakesControl(below: UILabel) {
        let height = CGFloat(24.0)
        let lakesControl = SSYSegmentedControl()
        lakesControl.setTitle("Superior", forSegment: 0)
        lakesControl.setTitle("Michigan", forSegment: 1)
        lakesControl.setTitle("Huron", forSegment: 2)
        lakesControl.setTitle("Erie", forSegment: 3)
        lakesControl.setTitle("Ontario", forSegment: 4)
        lakesControl.font = UIFont.systemFont(ofSize: 12.0)
        lakesControl.tintColor = UIColor.purple
        lakesControl.deselectedSegmentColor = UIColor.orange
        lakesControl.cornerRadius = height/2  // maximum possible round-ness
        self.view.addSubview(lakesControl)
        
        // Layout:
        lakesControl.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(
            item:lakesControl,
            attribute:NSLayoutAttribute.height,
            relatedBy:NSLayoutRelation.equal,
            toItem:nil,
            attribute:NSLayoutAttribute.notAnAttribute,
            multiplier:1.0,
            constant:height))
        constraints.append(NSLayoutConstraint(
            item:lakesControl,
            attribute:NSLayoutAttribute.top,
            relatedBy:NSLayoutRelation.equal,
            toItem:below,
            attribute:NSLayoutAttribute.bottom,
            multiplier:1.0,
            constant:8.0))
        constraints.append(NSLayoutConstraint(
            item:lakesControl,
            attribute:NSLayoutAttribute.centerX,
            relatedBy:NSLayoutRelation.equal,
            toItem:self.view,
            attribute:NSLayoutAttribute.centerX,
            multiplier:1.0,
            constant:0.0))
        self.view.addConstraints(constraints)
    }
}


