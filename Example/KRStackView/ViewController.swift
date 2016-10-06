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
    return UIScreen.main
}

private var DEFAULT_FRAME = CGRect(x: 20.0, y: 20.0, width: 148.0, height: 400.0)

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

    @IBAction func backgroundAction(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 300.0, initialSpringVelocity: 4.0, options: [], animations: { 
            if self.viewControls.frame.origin.x == Screen.bounds.width {
               self.viewControls.frame.origin.x = 401.0
            } else {
               self.viewControls.frame.origin.x = Screen.bounds.width
            }
            }, completion: nil)
    }
    
    // MARK: - Controls
    @IBAction func enabledAction(_ sender: AnyObject) {
        let enabled = (sender as! UISwitch).isOn
        
        stackView.enabled = enabled
        
        if !enabled {
            switchIndividual.isOn = false
            switchIndividual.sendActions(for: .valueChanged)
        }
        
        for view in viewControls.subviews {
            if [switchEnabled, controlView, sliderWidth, sliderHeight, sliderSpacing, sliderOffset].contains(view) { continue }
            if let control = view as? UIControl { control.isEnabled = enabled }
        }
        
        stackView.setNeedsLayout()
    }
    
    @IBAction func directionAction(_ sender: AnyObject) {
        stackView.frame = DEFAULT_FRAME
        
        if stackView.direction == .vertical { stackView.direction = .horizontal }
        else { stackView.direction = .vertical }
        
        stackView.setNeedsLayout()
    }
    
    @IBAction func wrapAction(_ sender: AnyObject) {
        stackView.frame = DEFAULT_FRAME

        stackView.shouldWrap = (sender as! UISwitch).isOn
        
        stackView.setNeedsLayout()
    }
    
    @IBAction func alignmentAction(_ sender: AnyObject) {
        stackView.frame = DEFAULT_FRAME

        guard let control = sender as? UISegmentedControl else { return }
        switch control.selectedSegmentIndex {
        case 0: stackView.alignment = .origin
        case 1: stackView.alignment = .center
        default: stackView.alignment = .endPoint
        }
        
        stackView.setNeedsLayout()
    }
    
    @IBAction func topInsetAction(_ sender: AnyObject) {
        stackView.frame = DEFAULT_FRAME
        stackView.insets.top = CGFloat((sender as! UISlider).value)
        
        stackView.setNeedsLayout()
    }
    
    @IBAction func rightInsetAction(_ sender: AnyObject) {
        stackView.frame = DEFAULT_FRAME
        stackView.insets.right = CGFloat((sender as! UISlider).value)
        
        stackView.setNeedsLayout()
    }
    
    @IBAction func bottomInsetAction(_ sender: AnyObject) {
        stackView.frame = DEFAULT_FRAME
        stackView.insets.bottom = CGFloat((sender as! UISlider).value)
        
        stackView.setNeedsLayout()
    }
    
    @IBAction func leftInsetAction(_ sender: AnyObject) {
        stackView.frame = DEFAULT_FRAME
        stackView.insets.left = CGFloat((sender as! UISlider).value)
        
        stackView.setNeedsLayout()
    }
    
    @IBAction func individualAction(_ sender: AnyObject) {
        let enabled = (sender as! UISwitch).isOn
        controlView.isEnabled = enabled
        sliderWidth.isEnabled = enabled
        sliderHeight.isEnabled = enabled
        sliderSpacing.isEnabled = enabled && controlView.selectedSegmentIndex != 2
        sliderOffset.isEnabled = enabled
        
        stackView.itemSpacing = enabled ? [8.0, 8.0] : nil
        stackView.itemOffset = enabled ? [0.0, 0.0, 0.0] : nil
    }
    
    @IBAction func viewSelectAction(_ sender: AnyObject) {
        let index = (sender as! UISegmentedControl).selectedSegmentIndex
        let view = [viewRed, viewYellow, viewBlue][index]!
        sliderWidth.value = Float(view.frame.width)
        sliderHeight.value = Float(view.frame.height)
        sliderSpacing.isEnabled = switchIndividual.isOn && controlView.selectedSegmentIndex != 2
        sliderSpacing.value = index != 2 ? Float(stackView.itemSpacing![index]) : sliderSpacing.value
        sliderOffset.value = Float(stackView.itemOffset![index])
    }
    
    @IBAction func widthAction(_ sender: AnyObject) {
        let index = controlView.selectedSegmentIndex
        let view = [viewRed, viewYellow, viewBlue][index]!
        
        view.frame.size.width = CGFloat((sender as! UISlider).value)
        stackView.setNeedsLayout()
    }
    
    @IBAction func heightAction(_ sender: AnyObject) {
        let index = controlView.selectedSegmentIndex
        let view = [viewRed, viewYellow, viewBlue][index]
        
        view?.frame.size.height = CGFloat((sender as! UISlider).value)
        stackView.setNeedsLayout()
    }
    
    @IBAction func spacingAction(_ sender: AnyObject) {
        let index = controlView.selectedSegmentIndex
        stackView.itemSpacing![index] = CGFloat((sender as! UISlider).value)
        stackView.setNeedsLayout()
    }
    
    @IBAction func offsetAction(_ sender: AnyObject) {
        let index = controlView.selectedSegmentIndex
        stackView.itemOffset![index] = CGFloat((sender as! UISlider).value)
        stackView.setNeedsLayout()
    }
    
}

