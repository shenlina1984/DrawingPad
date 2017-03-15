//
//  DataViewController.swift
//  Drawing Pad
//
//  Created by Lina Shen on 3/8/17.
//  Copyright © 2017 Lina Shen. All rights reserved.
//

import UIKit

class DataViewController: UIViewController,UITextFieldDelegate {
    
    var color:UIColor!
    @IBOutlet weak var canvas: CanvasView!
    @IBOutlet weak var brush: UIButton!
    @IBAction func backGroundTouch(_ sender: UIControl) {
        imgTitle.resignFirstResponder()
    }
    
    @IBAction func editingDidEnd(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBOutlet weak var erase: UIButton!
    @IBOutlet weak var imgTitle: UITextField!
    


    @IBAction func newProject(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Alert", message: "Do you want to save current drawing to image?", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.saveToDisk()
            while(!undoList.isEmpty){
                undoList.removeAll()
            }
            self.canvas.setNeedsDisplay()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
            while(!undoList.isEmpty){
                undoList.removeAll()
            }
            self.canvas.setNeedsDisplay()
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        }

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
        UIView.animate(withDuration: 0.5, delay: 0.0,
                       usingSpringWithDamping: CGFloat(0.25),
                       initialSpringVelocity: CGFloat(0.25),
                       options: UIViewAnimationOptions(), animations: {
                        self.brush.frame.origin.y=max(self.brush.frame.origin.y,self.erase.frame.origin.y)
                        self.erase.frame.origin.y=max(self.brush.frame.origin.y,self.erase.frame.origin.y)
                        sender.frame.origin.y -= 20
        }, completion: nil)

        
        
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
        UIView.animate(withDuration: 0.5, delay: 0.0,
                       usingSpringWithDamping: CGFloat(0.25),
                       initialSpringVelocity: CGFloat(0.25),
                       options: UIViewAnimationOptions(), animations: {
                        self.brush.frame.origin.y=max(self.brush.frame.origin.y,self.erase.frame.origin.y)
                        self.erase.frame.origin.y=max(self.brush.frame.origin.y,self.erase.frame.origin.y)
        }, completion: nil)
    }

    @IBAction func clearCanvas(_ sender: UIButton) {
        deleteFlag=true
        canvas.setNeedsDisplay()
        UIView.animate(withDuration: 0.5, delay: 0.0,
                       usingSpringWithDamping: CGFloat(0.25),
                       initialSpringVelocity: CGFloat(0.25),
                       options: UIViewAnimationOptions(), animations: {
                        self.brush.frame.origin.y=max(self.brush.frame.origin.y,self.erase.frame.origin.y)
                        self.erase.frame.origin.y=max(self.brush.frame.origin.y,self.erase.frame.origin.y)
        }, completion: nil)
    }
    
    func saveToDisk(){
        
        UIGraphicsBeginImageContextWithOptions(canvas.bounds.size, false, 0.0)
        canvas.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImageWriteToSavedPhotosAlbum(img!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func shareImg(){
        UIGraphicsBeginImageContextWithOptions(canvas.bounds.size, false, 0.0)
        canvas.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        let shareText = "Share my drawing work"
        
        let vc = UIActivityViewController(activityItems: [shareText, img!], applicationActivities: [])
        present(vc, animated: true)
    }
    
    @IBAction func clickSave(){
        // Create the alert controller
        let alertController = UIAlertController(title: "Alert", message: "Do you want to save to this drawing to image?", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.saveToDisk()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func handlePinch(recognizer : UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        imgTitle.resignFirstResponder()
        return true;
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       imgTitle.text="New Image"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        

        
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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

