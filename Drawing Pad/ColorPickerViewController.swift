//
//  ColorPickerViewController.swift
//  Drawing Pad
//
//  Created by Yan Zhao on 3/13/17.
//  Copyright © 2017 Lina Shen. All rights reserved.
//

import Foundation

import UIKit

var selectedColor: UIColor?
class ColorPickerViewController: UIViewController {


    @IBOutlet var colorPicker: SwiftHSVColorPicker!


    // Init ColorPicker with yellow
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Setup Color Picker
        
            colorPicker.setViewColor(UIColor.red)
    }
    override func viewWillDisappear(_ animated: Bool) {
        //save select value
        selectedColor=colorPicker.color
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if let t=selectedColor{
            colorPicker.setViewColor(t)
        }

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
