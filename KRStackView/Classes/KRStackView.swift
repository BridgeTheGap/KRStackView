//
//  KRStackView.swift
//  Pods
//
//  Created by Joshua Park on 7/13/16.
//
//

import UIKit

public enum StackDirection {
    case Vertical
    case Horizontal
}

public enum ItemAlignment {
    case Origin
    case Center
    case EndPoint
}

extension CGRect {
    var endPoint: CGPoint {
        get {
            return CGPointMake(origin.x + width, origin.y + height)
        }
    }
}

public class KRStackView: UIView {
    @IBInspectable public var enabled: Bool = true
    
    public var direction: StackDirection = .Vertical
    
    @IBInspectable public var insets: UIEdgeInsets = UIEdgeInsetsZero
    
    @IBInspectable public var spacing: CGFloat = 8.0
    public var itemSpacing: [CGFloat]?
    
    public var alignment: ItemAlignment = .Origin
    public var itemOffset: [CGFloat]?
    
    @IBInspectable public var shouldWrap: Bool = false
    @IBInspectable public var translatesCurrentState: Bool = false
    
    public override func layoutSubviews() {
        guard enabled else { return }
        guard subviews.count > 0 else { return }
        
        if translatesCurrentState { (itemSpacing, itemOffset) = ([CGFloat](), [CGFloat]()) }
        
        let isVertical = direction == .Vertical

        if !translatesAutoresizingMaskIntoConstraints {
            NSLayoutConstraint.deactivateConstraints(constraints + superview!.constraints.filter{ $0.firstItem === self || $0.secondItem === self })
            translatesAutoresizingMaskIntoConstraints = true
            
            if translatesCurrentState {
                for (i, view) in subviews.enumerate() {
                    view.translatesAutoresizingMaskIntoConstraints = true
                    translateCurrentStateForSubview(view, index: i)
                }
            } else {
                for v in subviews { v.translatesAutoresizingMaskIntoConstraints = true }
            }
        } else if translatesCurrentState {
            for (i, view) in subviews.enumerate() { translateCurrentStateForSubview(view, index: i) }
        }
        
        var endX: CGFloat!
        var endY: CGFloat!
        
        if isVertical {
            var maxWidth = subviews[0].frame.width + (itemOffset?[0] ?? 0.0)
            for (i, view) in subviews.enumerate() {
                if maxWidth < view.frame.width + (itemOffset?[i] ?? 0.0) {
                    maxWidth = view.frame.width + (itemOffset?[i] ?? 0.0)
                }
            }
            let maxX = insets.left + maxWidth + insets.right
            
            endX = shouldWrap ? maxX : max(maxX, frame.width)
            endY = 0.0
        } else {
            endX = 0.0
            
            var maxHeight = subviews[0].frame.height + (itemOffset?[0] ?? 0.0)
            for (i, view) in subviews.enumerate() {
                if maxHeight < view.frame.height + (itemOffset?[i] ?? 0.0) {
                    maxHeight = view.frame.height + (itemOffset?[i] ?? 0.0)
                }
            }
            let maxY = insets.top + maxHeight + insets.bottom
            
            endY = shouldWrap ? maxY : max(maxY, frame.height)
        }
        
        let useItemSpacing = itemSpacing?.count >= subviews.count - 1
        let useItemOffset = itemOffset?.count >= subviews.count
        
        for (i, view) in subviews.enumerate() {
            if isVertical {
                view.frame.origin.y = i == 0 ? insets.top : useItemSpacing ? endY + itemSpacing![i-1] : endY + spacing
                endY = view.frame.endPoint.y
            } else {
                view.frame.origin.x = i == 0 ? insets.left : useItemSpacing ? endX + itemSpacing![i-1] : endX + spacing
                endX = view.frame.endPoint.x
            }
            
            switch alignment {
            case .Origin:
                if isVertical {
                    view.frame.origin.x = useItemOffset ? insets.left + itemOffset![i] : insets.left
                } else {
                    view.frame.origin.y = useItemOffset ? insets.top + itemOffset![i] : insets.top
                }
            case .Center:
                if isVertical {
                    view.center.x = useItemOffset ? round(endX/2.0) + itemOffset![i]/2.0 : round(endX/2.0)
                } else {
                    view.center.y = useItemOffset ? round(endY/2.0) + itemOffset![i]/2.0 : round(endY/2.0)
                }
            case .EndPoint:
                if isVertical {
                    view.frame.origin.x = endX - (insets.right+view.frame.width)
                    if useItemOffset { view.frame.origin.x -= itemOffset![i] }
                } else {
                    view.frame.origin.y = endY - (insets.bottom+view.frame.height)
                    if useItemOffset { view.frame.origin.y -= itemOffset![i] }
                }
            }
        }
        
        if isVertical {
            frame.size.width = endX
            frame.size.height = shouldWrap ? endY + insets.bottom : max(endY + insets.bottom, frame.height)
        } else {
            frame.size.width = shouldWrap ? endX + insets.right : max(endX + insets.right, frame.width)
            frame.size.height = endY
        }
    }
    
    private func translateCurrentStateForSubview(subview: UIView, index: Int) {
        if direction == .Vertical {
            let origin = subview.frame.origin
            if index == 0 { insets.top = origin.y }
            else { itemSpacing!.append(origin.y - subviews[index-1].frame.endPoint.y) }
            
            switch alignment {
            case .Origin: itemOffset!.append(origin.x)
            case .Center: itemOffset!.append(subview.center.x - center.x)
            case .EndPoint: itemOffset!.append(frame.endPoint.x - subview.frame.endPoint.x)
            }
        } else {
            let origin = subview.frame.origin
            if index == 0 { insets.left = origin.x }
            else { itemSpacing!.append(origin.x - subviews[index-1].frame.endPoint.x) }
            
            switch alignment {
            case .Origin: itemOffset!.append(origin.y)
            case .Center: itemOffset!.append(subview.center.y - center.y)
            case .EndPoint: itemOffset!.append(frame.endPoint.y - subview.frame.endPoint.y)
            }
        }
    }
}
