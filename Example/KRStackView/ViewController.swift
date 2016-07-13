//
//  ViewController.swift
//  KRStackView
//
//  Created by Joshua Park on 07/13/2016.
//  Copyright (c) 2016 Joshua Park. All rights reserved.
//

import UIKit
import KRStackView

class ViewController: UIViewController {

    @IBOutlet weak var stackView: KRStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        stackView.shouldWrap = true
        stackView.direction = .Horizontal
        stackView.insets = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func layoutAction(sender: AnyObject) {
        view.setNeedsLayout()
    }
}

