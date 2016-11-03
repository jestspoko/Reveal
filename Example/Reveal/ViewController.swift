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

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    let r = Reveal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        r.add([label1,label2,label3,label4], options: [.delay(0.4),
                                                       .direction(.fromLeft),
                                                       .speed(1.0)])
        r.reveal {
            self.r.hide()
        }
    }
}

