SSYSegmentedControl is a replacement for UISegmentedControl, optimized for text
titles.  Does not support images.  Public Domain, requires Swift 3 and Auto
Layout.

Yet another segmented control?  Yes, because I couldn't find any that met my
requirements, one of which is to use Swift 3.  Also, I wanted my control to have
variable segment widths, adapting to the text in each segment, so that it could
be butted horizontally against a fixed UILabel and give the user the sensation
of *completing  the sentence* with their selection.

## Features

* Customizable height and font.  Defaults to the default UILabel font.
* Customizable colors, border thickness and corner radius
* Segment widths (and total width) which adapt to title widths
* Animation when changing selection
* Simple, open source code; you only use one file (SSYSegmentedContro.swift)
* [Public domain license](http://unlicense.org)

## Limitations:

* Supports text titles only, not images
* Cannot remove segment

## Operation

The user may chanage the selected segment by either tapping or swiping.
SSYSegmentedControl simply looks at the location of the event in touchesEnded.
SSYSegmentedControl sends a `valueChanged` action to its target when the
selected segment is changed.

## Configuration

### Layout

Add the file SSYSegmentedControl.swift to your project and target.

#### Using Interface Builder (up to 3 segments)

* Drag a UIView from the Object Library into your view.
* In the Identity Inspector, set the class to SSYSegmentedControl.
* Set constraints for x position and y position position of SSYSegmentedControl
to its superview.  To the SSYSegmentedControl itself, add constraints for
height and width.  With the default font, a height of 26-30 points is nice.
The width is arbitrary because SSYSegmentedControl will set the width of its
intrinsicContentSize as required to accomodate the titles you set.  In this
width constraint's Attributes Inspector , switch on *Placeholder … Remove at
build time*.
* Set other parameters as desired in Attributes Inspector.

#### Without using Interface Builder

Follow the example in ViewController.swift, `createGreatLakesControl(below:)`.

### Configuring Segments

SSYSegmentedControl does not have a *count of segments* method.  A newly
initialized SSYSegmentedControl has zero (0) segments.  Segment(s) are added as
needed when you set segment title(s).  Removing segments is not supported.

To set segment titles, you may set the properties `firstTitle`, `secondTitle`,
and optionally `thirdTitle`.  These are @IBInspectable and therefore editable
in the Attributes Inspector of Interface Builder.  Alternatively, and/or if you
want more than three segments, use setTitle(_:forSegment:).  You may also use
these methods to update (change) segment titles later.

## Subclassing Notes

Under the hood, SSYSegmentedControl is constructed of:

* A label (UILabel) for each segment; each is a subview of SSYSegmentedControl.
The thin borders around deselected segments are simply the border of each
label's layer.
* A *indicator* CALayer which provides a thick border around the selected
segment.  This layer has a higher z position and thus obliterates the normal
thin border.

Our implementation takes advantage of the fact that the array of subviews
is the array of labels, from left to right.  Subclasses should not add
subviews.

## Methods

### firstTitle

```swift
@IBInspectable public var firstTitle: String?
```

Title displayed on the first (left-most) segment.  May be nil, which is the default value, if there is less than 1.

### secondTitle

```swift
@IBInspectable public var secondTitle: String?
```
Title displayed on the second (from left) segment.  May be nil, which is the default value, if there are less than 2 segments.

### thirdTitle

```swift
@IBInspectable public var thirdTitle: String?
```
Title displayed on the third (from left) segment.  May be nil, which is the default value, if there are less than 3 segments.

### setTitle(_:forSegment:)

```swift
public func setTitle(_ title: String!, forSegment index: Int)
```
Sets the title of a segment at a given index, adding the necessary segment(s) if segment at given index does not exist.

### title(forSegment:)

```swift
public func title(forSegment index: Int) -> String?
```
Gets the title of a segment at a given index, returning nil if the given index lies beyond the count of segments

### selectedSegmentIndex

```swift
open var selectedSegmentIndex: Int? = nil
```

Index of the selected segment, counting from left, starting at 0) .  A `valueChanged` action is sent to the target when this changes.  May be nil to indicate *no selection*, which is the default value.

### cornerRadius

```swift
@IBInspectable open var cornerRadius : CGFloat = CGFloat(0)
```
Corner radius of border around the instance's segments

### font

```swift
@IBInspectable open var font : UIFont = UIFont.systemFont(ofSize: 17.0)
```
Font used in labels.  Defaults to system font of size 17.0, which is the default font for UILabel in iOS 10.

In Interface Builder, the Attributes Inspector does not display a control for this.  Apparently @IBInspectable does not yet support UIFont.  Maybe someday it will.

### deselectedSegmentColor

```swift
@IBInspectable override open var tintColor: UIColor!
```
Color of text and border of deselected segment(s).  To be intuitive to the user, this color should be lighter than the tintColor.

### tintColor 

```swift
@IBInspectable override open var tintColor: UIColor!
```

Color of text and border of selected segment(s).  To be intuitive to the user, this color should be darker than the deselectedSegmentColor.  This override has two purposes (1) document what it is used for in SSYSegmentedControl and (2) make it @IBInspectable.

### selectedBorderWidth

```swift
@IBInspectable open var selectedBorderWidth: CGFloat = CGFloat(3)
```

Width of border line around the selected segment, in points.  Defaults to 3.0.

### deselectedBorderWidth

```swift
@IBInspectable open var deselectedBorderWidth: CGFloat = CGFloat(1.5)
```

Width of border line around a deselected segment, in points.  Defaults to 1.5.

### paddingX

```swift
@IBInspectable open var paddingX: CGFloat = CGFloat(8.0)
```

Padding to the left and right of the text in a segment, including space required by the border line
