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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard enabled else { return }
        
        let isVertical = direction == .Vertical
        if translatesAutoresizingMaskIntoConstraints {  // Auto resizing
            let maxX = insets.left + subviews.reduce(0.0) { return $0.0 < $0.1.frame.width ? $0.1.frame.width : $0.0 } + insets.right
            let maxY = insets.top + subviews.reduce(0.0) { return $0.0 < $0.1.frame.height ? $0.1.frame.height : $0.0 } + insets.bottom
            var endX: CGFloat = isVertical ? shouldWrap ? maxX : max(frame.width, maxX) : 0.0
            var endY: CGFloat = isVertical ? 0.0 : shouldWrap ? maxY : max(frame.height, maxY)
            
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
                        view.center.x = useItemOffset ? round(endX/2.0) + itemOffset![i] : round(endX/2.0)
                    } else {
                        view.center.y = useItemOffset ? round(endY/2.0) + itemOffset![i] : round(endY/2.0)
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
        } else {    // Auto layout
            
        }
    }
}
