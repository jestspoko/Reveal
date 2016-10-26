//
//  RevealLabel.swift
//  MaskedLabel
//
//  Created by Lukasz Czechowicz on 26.10.2016.
//  Copyright © 2016 Lukasz Czechowicz. All rights reserved.
//

import UIKit

/// holds UILabel and creates animations
public class RevealLabel:Equatable {
    
    /// label's reference
    private var label:UILabel
    
    /// animation speed
    private var speed:Double
    /// animation's delay
    private var delay:Double
    
    /// function describing a timing curve
    private var timingFunction:CAMediaTimingFunction
    
    /// animation's direction
    private var direction:Reveal.RevealDirection
    
    /// destination mask frame
    private var destinationRect:CGRect
    
    /// layer with B&W gradient used as mask
    var gradientLayer:CAGradientLayer
    
    /**
     Initializes new label holder
     
     - Parameters:
     - label: UILabel reference
     - speed: animation speed
     - delay: animation delay
     - timingFunction: function describing timing curve
     - direction: animation direction
     */
    init(_ label:UILabel, speed:Double, delay:Double, timingFunction:CAMediaTimingFunction, direction:Reveal.RevealDirection) {
        self.label = label
        self.speed = speed
        self.delay = delay
        self.timingFunction = timingFunction
        self.direction = direction
        
        destinationRect = label.bounds
        
        gradientLayer = CAGradientLayer()
        
        
        // creates and tweaks destination frame and mask layer depends of animation direction
        switch direction {
        case .fromLeft:
            destinationRect.origin.x = destinationRect.origin.x - destinationRect.size.width - 20
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.frame = CGRect(x: destinationRect.origin.x, y: destinationRect.origin.y, width: destinationRect.size.width + 20, height: destinationRect.size.height)
        case .fromRight:
            destinationRect.origin.x = destinationRect.origin.x + destinationRect.size.width + 20
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.frame = CGRect(x: destinationRect.origin.x-20, y: destinationRect.origin.y, width: destinationRect.size.width + 20, height: destinationRect.size.height)
        }
        
        gradientLayer.colors = [UIColor.black.cgColor,UIColor.clear.cgColor]
        gradientLayer.locations = [0.9, 1.0]
        label.layer.mask = gradientLayer
        
    }
    /// holds UILabel content
    public var text:String? {
        set {
            self.label.text = newValue
        }
        get {
            return self.label.text
        }
    }
    
    public static func ==(l: RevealLabel, r: RevealLabel) -> Bool {
        return l.label == r.label
    }
    
    
    /**
     Creates and perfomrs reveal animation on mask
     
     - Parameters:
     - complete: handler fires when animation in complete
     */
    func reaval(complete:((_ revealLabel:RevealLabel)->())? = nil) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if let cpl = complete {
                cpl(self)
            }
        }
        
        let animation = CABasicAnimation(keyPath: "bounds")
        animation.duration = speed
        animation.fromValue = NSValue(cgRect: label.bounds)
        animation.toValue = NSValue(cgRect: destinationRect)
        animation.fillMode = "forwards"
        animation.beginTime = CACurrentMediaTime() + delay
        animation.isRemovedOnCompletion = false
        animation.timingFunction = timingFunction
        label.layer.add(animation, forKey:"reveal")
        CATransaction.commit()
    }
    
    /**
     Creates and perfomrs hide animation on mask
     
     - Parameters:
     - complete: handler fires when animation in complete
     */
    func hide(complete:((_ revealLabel:RevealLabel)->())? = nil) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if let cpl = complete {
                cpl(self)
            }
        }
        
        let animation = CABasicAnimation(keyPath: "bounds")
        animation.duration = speed
        animation.toValue = NSValue(cgRect: label.bounds)
        animation.fromValue = NSValue(cgRect: destinationRect)
        animation.fillMode = "forwards"
        animation.beginTime = CACurrentMediaTime() + delay
        animation.isRemovedOnCompletion = false
        animation.timingFunction = timingFunction
        
        label.layer.add(animation, forKey:"hide")
        CATransaction.commit()
    }
}


