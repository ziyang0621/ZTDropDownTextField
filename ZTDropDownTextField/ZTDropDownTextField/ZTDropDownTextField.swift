//
//  ZTDropDownTextField.swift
//  ZTDropDownTextField
//
//  Created by Ziyang Tan on 7/30/15.
//  Copyright (c) 2015 Ziyang Tan. All rights reserved.
//

import UIKit

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
    public weak var dataSourceDelegate: ZTDropDownTextFieldDataSourceDelegate?
    
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
            let heightConstraint = NSLayoutConstraint(item: dropDownTableView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: dropDownTableViewHeight)
            let topConstraint = NSLayoutConstraint(item: dropDownTableView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 1)
            
            NSLayoutConstraint.activateConstraints([leftConstraint, rightConstraint, heightConstraint, topConstraint])
            
            let tapGesture = UITapGestureRecognizer(target: self, action: "tapped:")
            tapGesture.numberOfTapsRequired = 1
            tapGesture.cancelsTouchesInView = false
            superview!.addGestureRecognizer(tapGesture)
        }
        
    }
    
    // MARK: Target Methods
    func tapped(gesture: UIGestureRecognizer) {
        let location = gesture.locationInView(superview)
        if !CGRectContainsPoint(dropDownTableView.frame, location) {
            if let dropDownTableView = dropDownTableView {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.dropDownTableView.alpha = 0
                })
            }
        }
    }
    
    func editingChanged(textField: UITextField) {
        if count(textField.text) > 0 {
            setupTableView()
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.dropDownTableView.alpha = 1.0
            })
        } else {
            if let dropDownTableView = dropDownTableView {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.dropDownTableView.alpha = 0
                })
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
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            tableView.alpha = 0
        })
    }
    
}