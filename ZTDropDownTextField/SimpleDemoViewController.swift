//
//  SimpleDemoViewController.swift
//  ZTDropDownTextField
//
//  Created by Ziyang Tan on 8/18/15.
//  Copyright (c) 2015 Ziyang Tan. All rights reserved.
//

import UIKit
import MapKit
import AddressBookUI

class SimpleDemoViewController: UIViewController {
    
    // MARK: Instance Variables
    let geocoder = CLGeocoder()
    let region = CLCircularRegion(center: CLLocationCoordinate2DMake(37.7577, -122.4376), radius: 1000, identifier: "region")
    var placemarkList: [CLPlacemark] = []
    
    // Mark: Outlet
    @IBOutlet weak var fullAddressTextField: ZTDropDownTextField!
    @IBOutlet weak var addressSummaryTextView: UITextView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Simple Demo"
        
        fullAddressTextField.dataSourceDelegate = self
        fullAddressTextField.animationStyle = .Flip
        fullAddressTextField.addTarget(self, action: "fullAddressTextDidChanged:", forControlEvents:.EditingChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Address Helper Mehtods
    func fullAddressTextDidChanged(textField: UITextField) {
        
        if textField.text.isEmpty {
            placemarkList.removeAll(keepCapacity: false)
            fullAddressTextField.dropDownTableView.reloadData()
            return
        }
        
        geocoder.geocodeAddressString(textField.text, inRegion: region, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                println(error)
            } else {
                self.placemarkList.removeAll(keepCapacity: false)
                self.placemarkList = placemarks as! [CLPlacemark]
                self.fullAddressTextField.dropDownTableView.reloadData()
            }
        })
    }
    
    private func formateedFullAddress(placemark: CLPlacemark) -> String {
        let lines = ABCreateStringWithAddressDictionary(placemark.addressDictionary, false)
        let addressString = lines.stringByReplacingOccurrencesOfString("\n", withString: ", ", options: .LiteralSearch, range: nil)
        return addressString
    }
    
}

extension SimpleDemoViewController: ZTDropDownTextFieldDataSourceDelegate {
    func dropDownTextField(dropDownTextField: ZTDropDownTextField, numberOfRowsInSection section: Int) -> Int {
        return placemarkList.count
    }
    
    func dropDownTextField(dropDownTextField: ZTDropDownTextField, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = dropDownTextField.dropDownTableView.dequeueReusableCellWithIdentifier("addressCell") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "addressCell")
        }
        
        cell!.textLabel!.text = formateedFullAddress(placemarkList[indexPath.row])
        cell!.textLabel?.numberOfLines = 0
        
        return cell!
    }
    
    func dropDownTextField(dropdownTextField: ZTDropDownTextField, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        fullAddressTextField.text = formateedFullAddress(placemarkList[indexPath.row])
        addressSummaryTextView.text = formateedFullAddress(placemarkList[indexPath.row])
    }
}
