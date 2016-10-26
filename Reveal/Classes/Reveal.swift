import UIKit

/**
 # Description
 Reveal is small untility to perform reveal/hide animation on UILabel.
 
 # Installation
 ### CocoaPods
 To install add following line to your Podfile:
 
 `pod Reveal`
 
 # How To Use Reveal
 
 ### 1) Create instance of Reval and define some options
 
 `let reveal = Reveal(options:[.direction(.fromLeft), .speed(2)])`
 
 ### 2) Pass label instance
 
 `reveal.add(someLabel)`
 
 ### 3) Reveal lable when ready!
 
 `reveal.reveal()`
 
 ### 4) To reverse animation call:
 
 `hide()`
 
 # Features
 
 ### You can pass array of labels and Reveal show them in order
 
 `let reveal = Reveal(options:[.delay(0.6)])
 reveal.add([label1, label2, label3])
 reveal.reveal()`
 
 ### If you want to know when animation ended add completion handler
 
 `reveal.reveal {
 print("all labels are visible now.")
 }`
 
 ### If you want to know when animation ended add completion handler
 
 `reveal.reveal {
 print("all labels are visible now.")
 }`
 
 ### You can track when particular animation ended
 
 `reveal.reveal { index in
 print("label at \(index) is visible now.")
 }`
 
 # Options
 - animation speed in speconds
 `speed(Double)`
 - delay in seconds between animations
 `delay(Double)`
 - Edge where animation starts from
 `direction(RevealDirection)`
 
 # Update Log
 ### 0.3 Release (26.10.2016)
 - first release
 */
public class Reveal {
    
    /**
     Reveal animation direction.
     - formLeft: starts from left edge
     - fromRight: starts from right edge
     */
    public enum RevealDirection {
        case fromLeft
        case fromRight
    }
    
    /**
     Possible animation options.
     - speed: animation speed in seconds
     - delay: delay in seconds between animations
     - timingFunction: function describing timing curve
     - direction: animation's start direction
     */
    public enum RevealLabelOptions {
        case speed(Double)
        case delay(Double)
        case timingFunction(CAMediaTimingFunction)
        case direction(RevealDirection)
    }
    
    //animation options
    private(set) var speed:Double = 0.4
    private(set) var delay:Double = 0.0
    private(set) var timingFunction:CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    private(set) var direction:RevealDirection = .fromLeft
    
    /// holds queue of labels
    private(set) var labels:Array<RevealLabel> = []
    
    ///alias for animation complete handler
    public typealias completionHandler = (()->())?
    
    //alias for animation complete at index handler
    public typealias completionAtHandler = ((_ index:Int)->())?
    
    /**
     Initializes new Reveal with options
     
     - Paramteres:
     - options: animation options
     
     - Returns: new Reveal object
     */
    public init(options:[RevealLabelOptions]?=nil) {
        if let o = options {
            self.options = o
        }
    }
    
    /**
     Creates and setup new queue of labels and prepares animation
     
     - Parameters:
     - labels: array of UILabels
     - options: animation options
     */
    @discardableResult
    public func add(_ labels:Array<UILabel>, options:[RevealLabelOptions]? = nil) -> Reveal{
        if let o = options {
            self.options = o
        }
        
        self.labels = labels.enumerated().map {
            RevealLabel($1, speed:speed, delay:delay*Double($0), timingFunction:timingFunction, direction:direction)
        }
        return self
    }
    
    /**
     Adds single label and prepares animation
     
     - Parameters:
     - label: label to reveal
     - options: animation options
     */
    @discardableResult
    public func add(_ label:UILabel, options:[RevealLabelOptions]? = nil) -> Reveal{
        return add([label], options: options)
    }
    
    /**
     Performes animations on labels queue
     
     - Parameters:
     - allComplete: completion handler fires when all labels are reveled
     */
    public func reveal(allComplete:@escaping ()->()){
        self.reveal(complete: {index in
            if index == (self.labels.count-1) {
                allComplete()
            }
        })
    }
    
    /**
     Performes animations on labels queue
     
     - Parameters:
     - complete: completion handler fires when label at specifc index is reveled
     */
    public func reveal(complete:completionAtHandler = nil) {
        self.labels.enumerated().forEach {
            self.revealLabel(revalLabel: $1, complete: complete)
        }
    }
    
    /**
     Performes animation on single label
     
     - Parameters:
     - revalLabel: single reveal label
     - complete: completion handler fires when label at specifc index is reveled
     */
    private func revealLabel(revalLabel:RevealLabel, complete:completionAtHandler) {
        revalLabel.reaval(complete: { revealLabel in
            if let cpl = complete {
                cpl(self.labels.index(of:revealLabel)!)
            }
        })
    }
    
    /**
     Performes hide animation on single label
     
     - Parameters:
     - revalLabel: single reveal label
     - complete: completion handler fires when label at specifc index is reveled
     */
    private func hideLabel(revalLabel:RevealLabel, complete:completionAtHandler) {
        revalLabel.hide(complete: { revealLabel in
            if let cpl = complete {
                cpl(self.labels.index(of:revealLabel)!)
            }
        })
    }
    
    /**
     Performes reveal animation on label at specifix index
     
     - Parameters:
     - at: index in labels array
     - complete: completion handler fires when label is reveled
     */
    public func reveal(at:Int, complete:completionHandler = nil){
        if self.labels.indices.contains(at) {
            self.revealLabel(revalLabel: self.labels[at], complete: { _ in
                if let cpl = complete {
                    cpl()
                }
            })
        }
    }
    
    /**
     Performes hide animation
     */
    
    public func hide() {
        self.labels.enumerated().forEach {
            self.hideLabel(revalLabel: $1, complete: nil)
        }
    }
    
    /**
     Updates contents of label at specifix index and performs animation
     
     - Parameters:
     - at: index in labels array
     - text: label's new value
     */
    public func update(at:Int, text:String) {
        if self.labels.indices.contains(at) {
            self.hideLabel(revalLabel: self.labels[at], complete: { _ in
                self.labels[at].text = text
                self.revealLabel(revalLabel: self.labels[at], complete: nil)
            })
        }
    }
    
    /**
     Updates contents of label and performs animation
     
     - Parameters:
     - text: label's new value
     */
    public func update(text:String) {
        self.update(at: 0, text: text)
    }
    
    /// holds animation options
    private(set) var options:[RevealLabelOptions] {
        set {
            for option in newValue {
                switch option {
                case let .delay(v):
                    delay = v
                case let .speed(v):
                    speed = v
                case let .timingFunction(v):
                    timingFunction = v
                case let .direction(v):
                    direction = v
                    
                }
            }
        }
        get {
            return [.speed(speed), .delay(delay), .timingFunction(timingFunction), .direction(direction)]
        }
    }
    
    
}
