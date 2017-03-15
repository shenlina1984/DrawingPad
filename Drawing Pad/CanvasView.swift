//
//  CanvasView.swift
//  Drawing Pad
//
//  Created by Lina Shen on 3/12/17.
//  Copyright © 2017 Lina Shen. All rights reserved.
//


import Foundation
import UIKit
var drawAvailable: Bool=false
var eraseAvailable:Bool=false
var deleteFlag:Bool=false
var undoDeleteFlag:Bool=false
struct Scribbles{
    var color: UIColor;
    var path: [CGPoint];
    var width: CGFloat;
    init(c:UIColor,p:[CGPoint],w:CGFloat) {
        color=c
        path=p
        width=w
    }
}
var undoList: [Scribbles]=[]
//let context=UIGraphicsGetCurrentContext()
class CanvasView: UIView{
    var width: CGFloat=10.0
    var color_config = UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    //var shape: ShapeType = .Line
    var first: CGPoint = CGPoint.zero
    var last : CGPoint = CGPoint.zero
    var points: [CGPoint] = []
    var color_scr:UIColor=UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    var a=undoList.count
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        if let context = UIGraphicsGetCurrentContext() {
            if(deleteFlag==false){
                
                if undoList.count>0{
                    for i in 0...undoList.count-1{
                        context.setLineWidth(undoList[i].width)
                        context.setStrokeColor(undoList[i].color.cgColor)
                        context.move(to: CGPoint(x: undoList[i].path.first!.x, y: undoList[i].path.first!.y))
                        for p in undoList[i].path {
                            context.addLine(to: CGPoint(x: p.x, y: p.y))
                        }
                        context.strokePath()
                    }
                    if drawAvailable{
                        color_scr=color_config;
                        
                    }
                    if eraseAvailable{
                        color_scr=self.backgroundColor!
                    }
                    context.setStrokeColor(color_scr.cgColor)
                    context.setLineWidth(width)
                    context.move(to: CGPoint(x: first.x, y: first.y))
                    for p in points {
                        context.addLine(to: CGPoint(x: p.x, y: p.y))
                    }
                    context.strokePath()
                    
                }
                else{
                    if drawAvailable{
                        color_scr=color_config;
                        
                    }
                    if eraseAvailable{
                        color_scr=self.backgroundColor!
                    }
                    context.setStrokeColor(color_scr.cgColor)
                    context.setLineWidth(width)
                    context.move(to: CGPoint(x: first.x, y: first.y))
                    for p in points {
                        context.addLine(to: CGPoint(x: p.x, y: p.y))
                    }
                    context.strokePath()
                    
                }
            }
            else{
                deleteFlag=false
                if !undoList.isEmpty {
                    undoDeleteFlag=true
                }
                
            }
        }
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.count == 1){
            if let touch = touches.first {
                if let t1=alpha_s{
                    if let t2=selectedColor{
                        let colors = t2.cgColor.components
                        color_config=UIColor(displayP3Red: colors![0], green: colors![1], blue: colors![2], alpha: t1)
                        
                    }
                    else{
                        color_config=UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: t1)
                    }
                }
                else{
                    if let t2=selectedColor{
                        let colors = t2.cgColor.components
                        color_config=UIColor(displayP3Red: colors![0], green: colors![1], blue: colors![2], alpha: 1.0)
                        
                    }
                    else{
                        color_config=UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
                    }
                }
                
                if let t=width_s{
                    width=t
                }
                first = touch.location(in: self)
                last = first
                if (drawAvailable||eraseAvailable){
                    points.append(first)
                    //setNeedsDisplay()
                }
                
                
            }
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.count == 1) {
            
            if let touch = touches.first {
                
                last = touch.location(in: self)
                if (drawAvailable||eraseAvailable){
                    
                    points.append(last)
                    
                    setNeedsDisplay()
                }
                
            }
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.count == 1) {
            if let touch = touches.first {
                
                last = touch.location(in: self)
                if (drawAvailable||eraseAvailable){
                    points.append(last)
                    let path=points
                    points.removeAll(keepingCapacity: true)
                    setNeedsDisplay()
                    if drawAvailable{
                        color_scr=color_config;
                        
                    }
                    if eraseAvailable{
                        color_scr=self.backgroundColor!
                    }
                    undoList.append(Scribbles(c:color_scr,p:path,w:width))
                }
                
            }
        }
        
       
        
    }
  
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
}
