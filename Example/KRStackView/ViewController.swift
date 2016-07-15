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
    @IBOutlet weak var viewRed: UIView!
    @IBOutlet weak var viewYellow: UIView!
    @IBOutlet weak var viewBlue: UIView!
    
    @IBOutlet weak var viewControls: UIView!
    @IBOutlet weak var switchEnabled: UISwitch!
    @IBOutlet weak var controlDirection: UISegmentedControl!
    @IBOutlet weak var switchShouldWrap: UISwitch!
    
    @IBOutlet weak var controlAlignment: UISegmentedControl!
    @IBOutlet weak var sliderTop: UISlider!
    @IBOutlet weak var sliderRight: UISlider!
    @IBOutlet weak var sliderBottom: UISlider!
    @IBOutlet weak var sliderLeft: UISlider!
    
    @IBOutlet weak var switchIndividual: UISwitch!
    @IBOutlet weak var controlView: UISegmentedControl!
    @IBOutlet weak var sliderWidth: UISlider!
    @IBOutlet weak var sliderHeight: UISlider!
    @IBOutlet weak var sliderSpacing: UISlider!
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
        
        stackView.enabled = enabled
        
        if !enabled {
            switchIndividual.on = false
            switchIndividual.sendActionsForControlEvents(.ValueChanged)
        }
        
        for view in viewControls.subviews {
            if [switchEnabled, controlView, sliderWidth, sliderHeight, sliderSpacing, sliderOffset].contains(view) { continue }
            if let control = view as? UIControl { control.enabled = enabled }
        }
        
        stackView.setNeedsLayout()
        
        if stackView.translatesCurrentState {
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.1))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.stackView.translatesCurrentState = false
            }
        }
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
    
    @IBAction func individualAction(sender: AnyObject) {
        let enabled = (sender as! UISwitch).on
        controlView.enabled = enabled
        sliderWidth.enabled = enabled
        sliderHeight.enabled = enabled
        sliderSpacing.enabled = enabled && controlView.selectedSegmentIndex != 2
        sliderOffset.enabled = enabled
        
        stackView.itemSpacing = enabled ? [8.0, 8.0] : nil
        stackView.itemOffset = enabled ? [0.0, 0.0, 0.0] : nil
    }
    
    @IBAction func viewSelectAction(sender: AnyObject) {
        let index = (sender as! UISegmentedControl).selectedSegmentIndex
        let view = [viewRed, viewYellow, viewBlue][index]
        sliderWidth.value = Float(view.frame.width)
        sliderHeight.value = Float(view.frame.height)
        sliderSpacing.enabled = switchIndividual.on && controlView.selectedSegmentIndex != 2
        sliderSpacing.value = index != 2 ? Float(stackView.itemSpacing![index]) : sliderSpacing.value
        sliderOffset.value = Float(stackView.itemOffset![index])
    }
    
    @IBAction func widthAction(sender: AnyObject) {
        let index = controlView.selectedSegmentIndex
        let view = [viewRed, viewYellow, viewBlue][index]
        
        view.frame.size.width = CGFloat((sender as! UISlider).value)
        stackView.setNeedsLayout()
    }
    
    @IBAction func heightAction(sender: AnyObject) {
        let index = controlView.selectedSegmentIndex
        let view = [viewRed, viewYellow, viewBlue][index]
        
        view.frame.size.height = CGFloat((sender as! UISlider).value)
        stackView.setNeedsLayout()
    }
    
    @IBAction func spacingAction(sender: AnyObject) {
        let index = controlView.selectedSegmentIndex
        stackView.itemSpacing![index] = CGFloat((sender as! UISlider).value)
        stackView.setNeedsLayout()
    }
    
    @IBAction func offsetAction(sender: AnyObject) {
        let index = controlView.selectedSegmentIndex
        stackView.itemOffset![index] = CGFloat((sender as! UISlider).value)
        stackView.setNeedsLayout()
    }
    
}

