//
//  ZTDropDownTextField.swift
//  ZTDropDownTextField
//
//  Created by Ziyang Tan on 7/30/15.
//  Copyright (c) 2015 Ziyang Tan. All rights reserved.
//

import UIKit

// MARK: Animation Style Enum
public enum ZTDropDownAnimationStyle {
    case Basic
    case Slide
    case Expand
    case Flip
}

// MARK: Dropdown Delegate
public protocol ZTDropDownTextFieldDataSourceDelegate: NSObjectProtocol {
    func dropDownTextField(dropDownTextField: ZTDropDownTextField, numberOfRowsInSection section: Int) -> Int
    func dropDownTextField(dropDownTextField: ZTDropDownTextField, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    func dropDownTextField(dropDownTextField: ZTDropDownTextField, didSelectRowAtIndexPath indexPath: NSIndexPath)
}

public class ZTDropDownTextField: UITextField {
    
    // MARK: Instance Variables
    public var dropDownTableView: UITableView!
    public var rowHeight:CGFloat = 50
    public var dropDownTableViewHeight: CGFloat = 150
    public var animationStyle: ZTDropDownAnimationStyle = .Basic
    public weak var dataSourceDelegate: ZTDropDownTextFieldDataSourceDelegate?
    private var heightConstraint: NSLayoutConstraint!
    
    // MARK: Init Methods
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextField()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    
    // MARK: Setup Methods
    private func setupTextField() {
        addTarget(self, action: "editingChanged:", forControlEvents:.EditingChanged)
    }
    
    private func setupTableView() {
        if dropDownTableView == nil {
            
            dropDownTableView = UITableView()
            dropDownTableView.backgroundColor = UIColor.whiteColor()
            dropDownTableView.layer.cornerRadius = 10.0
            dropDownTableView.layer.borderColor = UIColor.lightGrayColor().CGColor
            dropDownTableView.layer.borderWidth = 1.0
            dropDownTableView.showsVerticalScrollIndicator = false
            dropDownTableView.delegate = self
            dropDownTableView.dataSource = self
            dropDownTableView.estimatedRowHeight = rowHeight
            
            superview!.addSubview(dropDownTableView)
            superview!.bringSubviewToFront(dropDownTableView)
            
            dropDownTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            let leftConstraint = NSLayoutConstraint(item: dropDownTableView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0)
            let rightConstraint =  NSLayoutConstraint(item: dropDownTableView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0)
            heightConstraint = NSLayoutConstraint(item: dropDownTableView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: dropDownTableViewHeight)
            let topConstraint = NSLayoutConstraint(item: dropDownTableView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 1)
            
            NSLayoutConstraint.activateConstraints([leftConstraint, rightConstraint, heightConstraint, topConstraint])
            
            let tapGesture = UITapGestureRecognizer(target: self, action: "tapped:")
            tapGesture.numberOfTapsRequired = 1
            tapGesture.cancelsTouchesInView = false
            superview!.addGestureRecognizer(tapGesture)
        }
        
    }
    
    private func tableViewAppearanceChange(appear: Bool) {
        switch animationStyle {
        case .Basic:
            let basicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            basicAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            basicAnimation.toValue = appear ? 1 : 0
            dropDownTableView.pop_addAnimation(basicAnimation, forKey: "basic")
        case .Slide:
            let basicAnimation = POPBasicAnimation(propertyNamed: kPOPLayoutConstraintConstant)
            basicAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            basicAnimation.toValue = appear ? dropDownTableViewHeight : 0
            heightConstraint.pop_addAnimation(basicAnimation, forKey: "heightConstraint")
        case .Expand:
            let springAnimation = POPSpringAnimation(propertyNamed: kPOPViewSize)
            springAnimation.springSpeed = dropDownTableViewHeight / 100
            springAnimation.springBounciness = 10.0
            let width = appear ? CGRectGetWidth(frame) : 0
            let height = appear ? dropDownTableViewHeight : 0
            springAnimation.toValue = NSValue(CGSize: CGSize(width: width, height: height))
            dropDownTableView.pop_addAnimation(springAnimation, forKey: "expand")
        case .Flip:
            var identity = CATransform3DIdentity
            identity.m34 = -1.0/1000
            let angle = appear ? CGFloat(0) : CGFloat(M_PI_2)
            let rotationTransform = CATransform3DRotate(identity, angle, 0.0, 1.0, 0.0)
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.dropDownTableView.layer.transform = rotationTransform
            })
        }
    }
    
    // MARK: Target Methods
    func tapped(gesture: UIGestureRecognizer) {
        let location = gesture.locationInView(superview)
        if !CGRectContainsPoint(dropDownTableView.frame, location) {
            if let dropDownTableView = dropDownTableView {
                self.tableViewAppearanceChange(false)
            }
        }
    }
    
    func editingChanged(textField: UITextField) {
        if count(textField.text) > 0 {
            setupTableView()
            self.tableViewAppearanceChange(true)
        } else {
            if let dropDownTableView = dropDownTableView {
                self.tableViewAppearanceChange(false)
            }
        }
    }
    
}

// Mark: UITableViewDataSoruce
extension ZTDropDownTextField: UITableViewDataSource {
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSourceDelegate = dataSourceDelegate {
            if dataSourceDelegate.respondsToSelector(Selector("dropDownTextField:numberOfRowsInSection:")) {
                return dataSourceDelegate.dropDownTextField(self, numberOfRowsInSection: section)
            }
        }
        return 0
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let dataSourceDelegate = dataSourceDelegate {
            if dataSourceDelegate.respondsToSelector(Selector("dropDownTextField:cellForRowAtIndexPath:")) {
                return dataSourceDelegate.dropDownTextField(self, cellForRowAtIndexPath: indexPath)
            }
        }
        return UITableViewCell()
    }
}

// Mark: UITableViewDelegate
extension ZTDropDownTextField: UITableViewDelegate {
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let dataSourceDelegate = dataSourceDelegate {
            if dataSourceDelegate.respondsToSelector(Selector("dropDownTextField:didSelectRowAtIndexPath:")) {
                dataSourceDelegate.dropDownTextField(self, didSelectRowAtIndexPath: indexPath)
            }
        }
        self.tableViewAppearanceChange(false)
    }
}