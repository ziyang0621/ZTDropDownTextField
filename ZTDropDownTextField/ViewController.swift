//
//  ViewController.swift
//  Example
//
//  Created by Ziyang Tan on 7/30/15.
//  Copyright (c) 2015 Ziyang Tan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension UIViewController: UITableViewDelegate {
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let simpleDemoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SimpleDemoViewController") as! SimpleDemoViewController
            showViewController(simpleDemoVC, sender: self)
        } else {
            let mapViewDemoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MapViewDemoViewController") as! MapViewDemoViewController
            showViewController(mapViewDemoVC, sender: self)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("mainCell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "mainCell")
        }
        
        if indexPath.row == 0 {
            cell!.textLabel!.text = "Simple Demo"
        } else {
            cell!.textLabel!.text = "Map View Demo"
        }
        return cell!
    }
}
