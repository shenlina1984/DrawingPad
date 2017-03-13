//
//  SettingsViewController.swift
//  Drawing Pad
//
//  Created by Yan Zhao on 3/13/17.
//  Copyright © 2017 Lina Shen. All rights reserved.
//

import Foundation
import UIKit

var width_s:CGFloat?
var alpha_s:CGFloat?
class SettingsViewController: UITableViewController{
    

    @IBOutlet weak var radius: UISlider!
    
    @IBOutlet weak var opacity: UISlider!
    
    @IBAction func selectWidth(_ sender: UISlider) {
        width_s=CGFloat(radius.value)
    }
    
    @IBAction func selectOpacity(_ sender: UISlider) {
        alpha_s=CGFloat(opacity.value)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        opacity.value=1.0
        radius.value=10
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
          if let t=alpha_s{
            opacity.value=Float (t)
        }
        if let t=width_s{
            radius.value=Float(t)
        }
    }
    
}
