import UIKit

@IBDesignable open class SSYSegmentedControl: UIControl {
    let indicatorLayer = CALayer()
    
    /** Title displayed on the first (left-most) segment.  May be nil, which
     is the default value, if there is less than 1. */
    @IBInspectable public var firstTitle: String? {
        get {
            return self.title(forSegment: 0)
        }
        set {
            self.setTitle(newValue, forSegment:0)
        }
    }
    
    /** Title displayed on the second (from left) segment.  May be nil, which
     is the default value, if there are less than 2 segments. */
    @IBInspectable public var secondTitle: String? {
        get {
            return self.title(forSegment: 1)
        }
        set {
            self.setTitle(newValue, forSegment:1)
        }
    }
    
    /** Title displayed on the third (from left) segment.  May be nil, which
     is the default value, if there are less than 3 segments. */
    @IBInspectable public var thirdTitle: String? {
        get {
            return self.title(forSegment: 2)
        }
        set {
            self.setTitle(newValue, forSegment:2)
        }
    }
    
    /** Sets the title of a segment at a given index, adding the necessary
     segment(s) if segment at given index does not exist. */
    public func setTitle(_ title: String!, forSegment index: Int) {
        /* If index is beyond the range of existing segments/labels, add
         the required segment/label(s) after the last existing segment/label */
        while ((labels.count - 1) < index) {
            let label = UILabel()
            label.textAlignment = .center
            label.font = font
            label.layer.borderColor = deselectedSegmentColor?.cgColor
            label.layer.borderWidth = deselectedBorderWidth
            label.textColor = deselectedSegmentColor
            
            addSubview(label)
        }
        self.labels[index].text = title
        invalidateIntrinsicContentSize()
    }
    
    /** Gets the title of a segment at a given index, returning nil if the given
     index lies beyond the count of segments */
    public func title(forSegment index: Int) -> String? {
        let answer = (index < self.labels.count) ? self.labels[index].text : nil
        return answer
    }
    
    /** Index of the selected segment, counting from left, starting at 0) .  A
     .valueChanged action is sent to the target when this changes.  May be nil
     to indicate *no selection*, which is the default value. */
    open var selectedSegmentIndex: Int? = nil {
        didSet {
            updateIndicator()
            updateLabelsTextColor()
            sendActions(for: .valueChanged)
        }
    }
    
    /// Corner radius of border around the instance's segments
    @IBInspectable open var cornerRadius : CGFloat = CGFloat(0) {
        // See Swift Learners Note 2 at end
        didSet {
            for label in labels {
                label.layer.cornerRadius = cornerRadius
            }
            
            indicatorLayer.cornerRadius = cornerRadius
        }
    }
    
    /** Font used in labels.  Defaults to system font of size 17.0, which is the
     default font for UILabel in iOS 10.
     
     In Interface Builder, the Attributes Inspector does not display a control
     for this.  Apparently @IBInspectable does not yet support UIFont.  Maybe
     someday it will.*/
    @IBInspectable open var font : UIFont = UIFont.systemFont(ofSize: 17.0) {
        didSet {
            for label in labels {
                label.font = font
            }
        }
    }
    
    /** Color of text and border of deselected segment(s).  To be intuitive to
     the user, this color should be lighter than the tintColor. */
    @IBInspectable open var deselectedSegmentColor: UIColor? = UIColor.lightGray {
        didSet {
            if let color = deselectedSegmentColor?.cgColor {
                for label in labels {
                    label.layer.borderColor = color
                }
            }
            updateLabelsTextColor()
        }
    }
    
    /** Color of text and border of selected segment(s).  To be intuitive to
     the user, this color should be darker than the deselectedSegmentColor.
     This override has two purposes (1) document what it is
     used for in SSYSegmentedControl and (2) make it @IBInspectable. */
    @IBInspectable override open var tintColor: UIColor! {
        get {
            return super.tintColor
        }
        set {
            super.tintColor = newValue
        }
    }
    
    /// Color of text and the indicator rectangle of the selected segment
    override open func tintColorDidChange() {
        super.tintColorDidChange()
        indicatorLayer.borderColor = tintColor.cgColor
        updateLabelsTextColor()
    }
    
    /** Width of border line around the selected segment, in points.
     Defaults to 3.0. */
    @IBInspectable open var selectedBorderWidth: CGFloat = CGFloat(3)
    
    /** Width of border line around a deselected segment, in points.
     Defaults to 1.5. */
    @IBInspectable open var deselectedBorderWidth: CGFloat = CGFloat(1.5)
    
    /** Padding to the left and right of the text in a segment, including space
     required by the border line */
    @IBInspectable open var paddingX: CGFloat = CGFloat(8.0)
    
    /// Returns the instance's labels, arranged from left to right
    var labels: [UILabel] {
        return subviews as! [UILabel]
    }
    //  See Swift Learners Note 1 at end
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonConfig()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonConfig()
    }
    
    func commonConfig() {
        indicatorLayer.borderWidth = selectedBorderWidth
        indicatorLayer.borderColor = tintColor.cgColor
        
        /*  Set a z position which will ensure that the selection indicator
         obliterates the selected label's layer.  Any value > 0 should work
         work, because the label's layer has the default z position of 0.0 */
        indicatorLayer.zPosition = 1000.0
        
        layer.addSublayer(indicatorLayer)
        
        self.updateLabelsTextColor()
    }
    
    override open func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let height = bounds.size.height
        var x = CGFloat(0)
        
        for label in labels {
            let width = self.widthOfSegment(label: label)
            label.frame = CGRect(x: x,
                                 y: 0,
                                 width: width,
                                 height: height)
            x += width
            x -= deselectedBorderWidth  // Adjacent segments share border
        }
        
        updateIndicator()
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        let touch = touches.first!
        let touchX = touch.location(in:self).x
        
        var i = 0
        var x = CGFloat(0)
        repeat {
            x += self.widthOfSegment(label: labels[i])
            i += 1
        } while (x < touchX) && (i < self.subviews.count)
        
        /* We broke out of the loop when we passed by touchX, so now we must
         back up by 1.  To avoid this, you could put the i += 1 at the top of
         the loop, but then you'd need to start with -i change the second
         limit condition to  `< self.subviews.count - 1`.  I think that the
         approach used here is less ugly. */
        self.selectedSegmentIndex = i - 1
    }
    
    override open var intrinsicContentSize : CGSize {
        var height = CGFloat(0)
        var width = CGFloat(0)
        for label in labels {
            height = max(height, label.intrinsicContentSize.height) ;
            width += widthOfSegment(label: label)
            // Cosmetics: Labels should share a common border.
            width -= deselectedBorderWidth  // overlap
        }
        
        // Last label had no successor to overlap with, so add the overlap back
        width += deselectedBorderWidth
        
        return CGSize(width: width,
                      height: height)
    }
    
    func isSelected(label: UILabel) -> Bool {
        let answer = self.labels.index(of: label) == self.selectedSegmentIndex
        return answer
    }
    
    func updateLabelsTextColor() {
        for label in self.labels {
            let isSelected = self.isSelected(label: label)
            let newColor = isSelected ? tintColor : deselectedSegmentColor
            UIView.transition(with: label,
                              duration: 0.33,
                              options: .transitionCrossDissolve,
                              animations: {
                                label.textColor = newColor
            },
                              completion: nil)
        }
    }
    
    func widthOfSegment(label: UILabel) -> CGFloat{
        return label.intrinsicContentSize.width + 2 * paddingX
    }
    
    func updateIndicator() {
        var priorWidths = CGFloat(0)
        var selectedLabel: UILabel?
        for label in labels {
            if self.isSelected(label: label) {
                selectedLabel = label
                break
            }
            priorWidths += self.widthOfSegment(label: label) - deselectedBorderWidth
        }
        if let selectedLabel = selectedLabel {
            indicatorLayer.frame = CGRect(x: priorWidths,
                                          y: CGFloat(0),
                                          width: self.widthOfSegment(label: selectedLabel),
                                          height: self.bounds.height)
        }
    }
}


/*
 
 Swift Learners Note 1
 
 This is a *read-only computed property* written in short-hand.  A computed
 property is typically defined with two code blocks, with symbols *get* and
 *set*.  But since this property implementation has only a single anonymous code
 block, this code block is presumed by the compiler to be the getter, and
 furthermore the lack of a setter tells the compiler that this property is
 *read-only*.
 
 
 Swift Learners Note 2
 
 It appears that the two CGFloats in the above line are redundant.  They are,
 but the explicit declaration is necessary necessary for this to have a field
 in the Attributes Inspector of Interface Builder, and the initializer is
 necessary to avoid the compiler warning of no initialization.  Maybe a future
 Xcode will be a little smarter here.
 
 */
