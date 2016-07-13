//
//  ViewController.swift
//  KRStackView
//
//  Created by Joshua Park on 07/13/2016.
//  Copyright (c) 2016 Joshua Park. All rights reserved.
//

import UIKit
import KRStackView

private var Screen: UIScreen {
    return UIScreen.mainScreen()
}

class ViewController: UIViewController {
    @IBOutlet weak var stackView: KRStackView!
    
    @IBOutlet weak var viewControls: UIView!
    @IBOutlet weak var controlDirection: UISegmentedControl!
    @IBOutlet weak var switchShouldWrap: UISwitch!
    
    @IBOutlet weak var controlAlignment: UISegmentedControl!
    @IBOutlet weak var sliderTop: UISlider!
    @IBOutlet weak var sliderRight: UISlider!
    @IBOutlet weak var sliderBottom: UISlider!
    @IBOutlet weak var sliderLeft: UISlider!
    
    @IBOutlet weak var controlView: UISegmentedControl!
    @IBOutlet weak var sliderWidth: UISlider!
    @IBOutlet weak var sliderHeight: UISlider!
    @IBOutlet weak var sliderOffset: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewControls.frame.origin.x = Screen.bounds.width
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backgroundAction(sender: AnyObject) {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 300.0, initialSpringVelocity: 4.0, options: [], animations: { 
            if self.viewControls.frame.origin.x == Screen.bounds.width {
               self.viewControls.frame.origin.x = 401.0
            } else {
               self.viewControls.frame.origin.x = Screen.bounds.width
            }
            }, completion: nil)
    }
}

