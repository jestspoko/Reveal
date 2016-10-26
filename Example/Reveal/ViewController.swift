//
//  ViewController.swift
//  Reveal
//
//  Created by Lukasz Czechowicz on 10/26/2016.
//  Copyright (c) 2016 Lukasz Czechowicz. All rights reserved.
//

import UIKit
import Reveal
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let r = Reveal(options: [ .delay(12),
                                  .direction(.fromLeft)])
        r.reveal { (index) in
            
        }
        
        r.update(text: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

