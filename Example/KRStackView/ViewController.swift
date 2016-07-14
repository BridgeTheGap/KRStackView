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

private var DEFAULT_FRAME = CGRectMake(20.0, 20.0, 148.0, 400.0)

class ViewController: UIViewController {
    @IBOutlet weak var stackView: KRStackView!
    
    @IBOutlet weak var viewControls: UIView!
    @IBOutlet weak var switchEnabled: UISwitch!
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

        stackView.enabled = false
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
    
    // MARK: - Controls
    @IBAction func enabledAction(sender: AnyObject) {
        let enabled = (sender as! UISwitch).on
        stackView.frame = DEFAULT_FRAME
        
        stackView.enabled = enabled
        
        for view in viewControls.subviews {
            if view === switchEnabled { continue }
            if let control = view as? UIControl { control.enabled = enabled }
        }
        
        stackView.setNeedsLayout()
    }
    
    @IBAction func directionAction(sender: AnyObject) {
        stackView.frame = DEFAULT_FRAME
        
        if stackView.direction == .Vertical { stackView.direction = .Horizontal }
        else { stackView.direction = .Vertical }
        
        stackView.setNeedsLayout()
    }
    
    @IBAction func wrapAction(sender: AnyObject) {
        stackView.frame = DEFAULT_FRAME

        stackView.shouldWrap = (sender as! UISwitch).on
        
        stackView.setNeedsLayout()
    }
    
    @IBAction func alignmentAction(sender: AnyObject) {
        stackView.frame = DEFAULT_FRAME

        guard let control = sender as? UISegmentedControl else { return }
        switch control.selectedSegmentIndex {
        case 0: stackView.alignment = .Origin
        case 1: stackView.alignment = .Center
        default: stackView.alignment = .EndPoint
        }
        
        stackView.setNeedsLayout()
    }
    
    @IBAction func topInsetAction(sender: AnyObject) {
        stackView.frame = DEFAULT_FRAME
        stackView.insets.top = CGFloat((sender as! UISlider).value)
        
        stackView.setNeedsLayout()
    }
    
    @IBAction func rightInsetAction(sender: AnyObject) {
        stackView.frame = DEFAULT_FRAME
        stackView.insets.right = CGFloat((sender as! UISlider).value)
        
        stackView.setNeedsLayout()
    }
    
    @IBAction func bottomInsetAction(sender: AnyObject) {
        stackView.frame = DEFAULT_FRAME
        stackView.insets.bottom = CGFloat((sender as! UISlider).value)
        
        stackView.setNeedsLayout()
    }
    
    @IBAction func leftInsetAction(sender: AnyObject) {
        stackView.frame = DEFAULT_FRAME
        stackView.insets.left = CGFloat((sender as! UISlider).value)
        
        stackView.setNeedsLayout()
    }
}

