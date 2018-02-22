//
//  KRStackView.swift
//  Pods
//
//  Created by Joshua Park on 7/13/16.
//
//

import UIKit

public enum StackDirection {
    case vertical
    case horizontal
}

public enum ItemAlignment {
    case origin
    case center
    case endPoint
}

extension CGRect {
    var endPoint: CGPoint {
        get {
            return CGPoint(x: origin.x + width, y: origin.y + height)
        }
    }
}

open class KRStackView: UIView {

    @IBInspectable open var enabled: Bool = true
    @IBInspectable open var translatesCurrentLayout: Bool = false {
        didSet {
            if translatesCurrentLayout { alignment = .origin }
        }
    }
    @IBInspectable open var shouldWrap: Bool = false
    @IBInspectable open var spacing: CGFloat = 8.0
    
    open var direction: StackDirection = .vertical
    
    open var alignment: ItemAlignment = .origin
    open var insets: UIEdgeInsets = UIEdgeInsets.zero
    open var itemSpacing: [CGFloat]?
    open var itemOffset: [CGFloat]?
    
    private var shouldUseItemSpacing: Bool {
        return itemSpacing != nil &&
               itemSpacing!.count >= subviews.count - 1
    }
    
    private var shouldUseItemOffset: Bool {
        return itemOffset != nil &&
               itemOffset!.count >= subviews.count
    }
    
    private var knownContentSize: CGFloat {
        if direction == .vertical {
            var contentWidth = subviews[0].frame.width + getItemOffset(at: 0)
            for (i, view) in subviews.enumerated() {
                if contentWidth < view.frame.width + getItemOffset(at: i) {
                    contentWidth = view.frame.width + getItemOffset(at: i)
                }
            }
            let maxWidth = insets.left + contentWidth + insets.right
            
            return shouldWrap ? maxWidth : max(maxWidth, frame.width)
        } else {
            var contentHeight = subviews[0].frame.height + getItemOffset(at: 0)
            for (i, view) in subviews.enumerated() {
                if contentHeight < view.frame.height + getItemOffset(at: i) {
                    contentHeight = view.frame.height + getItemOffset(at: i)
                }
            }
            let maxHeight = insets.top + contentHeight + insets.bottom
            
            return shouldWrap ? maxHeight : max(maxHeight, frame.height)
        }
    }
    
    // MARK: -
    
    public init(frame: CGRect, subviews: [UIView]) {
        super.init(frame: frame)
        for view in subviews { addSubview(view) }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init(subviews: [UIView]) {
        self.init(frame: CGRect.zero, subviews: subviews)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func layoutSubviews() {
        guard enabled else { super.layoutSubviews(); return }
        guard subviews.count > 0 else { return }
        
        if translatesCurrentLayout { (itemSpacing, itemOffset) = ([CGFloat](), [CGFloat]()) }
        
        let isVertical = direction == .vertical

        if !translatesAutoresizingMaskIntoConstraints {
            let filterFunction: (NSLayoutConstraint) -> Bool = {
                $0.firstItem === self || $0.secondItem === self
            }
            
            let existingConstraints = constraints +
                superview!.constraints.filter(filterFunction)
            
            NSLayoutConstraint.deactivate(existingConstraints)
            translatesAutoresizingMaskIntoConstraints = true
            
            if translatesCurrentLayout {
                translateCurrentStateForSubviews()
            } else {
                for v in subviews { v.translatesAutoresizingMaskIntoConstraints = true }
            }
        } else if translatesCurrentLayout {
            translateCurrentStateForSubviews()
        }
        
        var lastX: CGFloat!
        var lastY: CGFloat!
        
        if isVertical {
            lastX = knownContentSize
            lastY = 0.0
        } else {
            lastX = 0.0
            lastY = knownContentSize
        }
        
        for (i, view) in subviews.enumerated() {
            if isVertical {
                view.frame.origin.y = getOrigin(at: i,
                                                offset: lastY)
                lastY = view.frame.endPoint.y
            } else {
                view.frame.origin.x = getOrigin(at: i,
                                                offset: lastX)
                lastX = view.frame.endPoint.x
            }
            
            switch alignment {
                
            case .origin:
                if isVertical {
                    view.frame.origin.x = shouldUseItemOffset ?
                        insets.left + itemOffset![i] :
                        insets.left
                } else {
                    view.frame.origin.y = shouldUseItemOffset ?
                        insets.top + itemOffset![i] :
                        insets.top
                }
                
            case .center:
                if isVertical {
                    view.center.x = shouldUseItemOffset ?
                        round(lastX*0.5 + itemOffset![i]*0.5) :
                        round(lastX*0.5)
                } else {
                    view.center.y = shouldUseItemOffset ?
                        round(lastY*0.5 + itemOffset![i]*0.5) :
                        round(lastY*0.5)
                }
                
            case .endPoint:
                if isVertical {
                    view.frame.origin.x = lastX - (insets.right+view.frame.width)
                    if shouldUseItemOffset { view.frame.origin.x -= itemOffset![i] }
                } else {
                    view.frame.origin.y = lastY - (insets.bottom+view.frame.height)
                    if shouldUseItemOffset { view.frame.origin.y -= itemOffset![i] }
                }
            }
            
            adjustViewFrame(view)
        }
        
        adjustSize(width: lastX,
                   height: lastY)
        
        defer { translatesCurrentLayout = false }
    }
    
    open override func setValue(_ value: Any?,
                                forKey key: String)
    {
        switch key {
            
        case "enabled":
            enabled = value as! Bool
        
        case "translatesCurrentLayout":
            translatesCurrentLayout = value as! Bool
        
        case "shouldWrap":
            shouldWrap = value as! Bool
        
        case "spacing":
            spacing = value as! CGFloat
        
        case "direction":
            direction = value as! StackDirection
        
        case "alignment":
            alignment = value as! ItemAlignment
        
        case "insets":
            insets = value as! UIEdgeInsets
        
        case "itemSpacing":
            itemSpacing = value as? [CGFloat]
        
        case "itemOffset":
            itemOffset = value as? [CGFloat]
            
        default:
            super.setValue(value,
                           forKey: key)

        }
    }
    
    open override func value(forKey key: String) -> Any? {
        switch key {
            
        case "enabled":
            return enabled
            
        case "translatesCurrentLayout":
            return translatesCurrentLayout
            
        case "shouldWrap":
            return shouldWrap
            
        case "spacing":
            return spacing
            
        case "direction":
            return direction
            
        case "alignment":
            return alignment
            
        case "insets":
            return insets
            
        case "itemSpacing":
            return itemSpacing
            
        case "itemOffset":
            return itemOffset
            
        default:
            return super.value(forKey: key)
            
        }

    }
    
    // MARK: - Private
    
    private func getItemOffset(at index: Int) -> CGFloat {
        if let itemOffset = itemOffset { return itemOffset[index] }
        return 0.0
    }
    
    private func getOrigin(at index: Int,
                           offset: CGFloat) -> CGFloat
    {
        if direction == .vertical {
            if index == 0 {
                return insets.top
            } else {
                return shouldUseItemSpacing ?
                    offset + itemSpacing![index-1] :
                    offset + spacing
            }
        } else {
            if index == 0 {
                return insets.left
            } else {
                return shouldUseItemSpacing ?
                    offset + itemSpacing![index-1] :
                    offset + spacing
            }
        }
    }
    
    private func translateCurrentStateForSubviews() {
        for (i, view) in subviews.enumerated() {
            view.translatesAutoresizingMaskIntoConstraints = true
            
            if direction == .vertical {
                let origin = view.frame.origin
                if i == 0 { insets.top = origin.y }
                else { itemSpacing!.append(origin.y - subviews[i-1].frame.endPoint.y) }
                
                itemOffset!.append(origin.x)
            } else {
                let origin = view.frame.origin
                if i == 0 { insets.left = origin.x }
                else { itemSpacing!.append(origin.x - subviews[i-1].frame.endPoint.x) }
                
                itemOffset!.append(origin.y)
            }
        }
    }
    
    private func adjustViewFrame(_ view: UIView) {
        view.frame.origin.x = view.frame.origin.x.rounded(.toNearestOrAwayFromZero)
        view.frame.origin.y = view.frame.origin.y.rounded(.toNearestOrAwayFromZero)
        view.frame.size.width = {
            return view.intrinsicContentSize.width > 0.0 ?
                ceil(view.frame.size.width) :
                view.frame.size.width.rounded(.toNearestOrAwayFromZero)
        }()
        view.frame.size.height = {
            return view.intrinsicContentSize.height > 0.0 ?
                ceil(view.frame.size.height) :
                view.frame.size.height.rounded(.toNearestOrAwayFromZero)
        }()
    }
    
    private func adjustSize(width: CGFloat, height: CGFloat) {
        if direction == .vertical {
            frame.size.width = width
            frame.size.height = shouldWrap ?
                height + insets.bottom :
                max(height + insets.bottom, frame.height)
        } else {
            frame.size.width = shouldWrap ?
                width + insets.right :
                max(width + insets.right, frame.width)
            frame.size.height = height
        }
        
        frame.size.width = round(frame.size.width)
        frame.size.height = round(frame.size.height)
    }
    
}
