//
//  ViewController.swift
//  segment_ios
//
//  Created by Joey Ng on 15/7/23.
//

import UIKit
import Segment

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func trackOrderCompleted(_ sender: Any) {
        Analytics.shared().track("Order Completed", properties: ["price": 100])
        print("Fired Order Completed")
    }
    
    @IBAction func trackSignedUp(_ sender: Any) {
        Analytics.shared().track("Signed Up", properties: ["name": "Joey"])
        print("Fired Signed Up")
    }
    
}
