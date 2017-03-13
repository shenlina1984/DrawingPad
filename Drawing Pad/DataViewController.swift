//
//  DataViewController.swift
//  Drawing Pad
//
//  Created by Lina Shen on 3/8/17.
//  Copyright © 2017 Lina Shen. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {
    var color:UIColor!
    @IBOutlet weak var canvas: CanvasView!
    @IBOutlet weak var brush: UIButton!
    @IBOutlet weak var erase: UIButton!

    @IBAction func pickPen(_ sender: UIButton) {
        switch sender {
        case erase:
            eraseAvailable=true;
            drawAvailable=false;
        case brush:
            drawAvailable=true;
            eraseAvailable=false;
        default:
            drawAvailable=false;
            eraseAvailable=false;
        }
        
        
    }
    
    @IBAction func undo(_ sender: UIButton) {
        if undoDeleteFlag==false {
        if undoList.count>0 {
            undoList.removeLast()
            canvas.setNeedsDisplay()
        }
        }
        else{

            canvas.setNeedsDisplay()
            undoDeleteFlag=false
        }
    }

    @IBAction func clearCanvas(_ sender: UIButton) {
        deleteFlag=true
        canvas.setNeedsDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.dataLabel!.text = dataObject
    }


}

