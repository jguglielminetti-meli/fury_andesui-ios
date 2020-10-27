//
//  UIView+roundCorners.swift
//  AndesUI
//
//  Created by Jose Antonio Guglielminetti on 27/10/2020.
//

import Foundation

extension UIView {
    internal enum RoundingCorner {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight

        internal func toCACornerMask() -> CACornerMask {
            switch self {
                case .topLeft:
                    return .layerMinXMinYCorner
                case .topRight:
                    return .layerMaxXMinYCorner
                case .bottomLeft:
                    return .layerMinXMaxYCorner
                case .bottomRight:
                    return .layerMaxXMaxYCorner
            }
        }

        internal func toUIRectCorner() -> UIRectCorner {
            switch self {
                case .topLeft:
                    return .topLeft
                case .topRight:
                    return .topRight
                case .bottomLeft:
                    return .bottomLeft
                case .bottomRight:
                    return .bottomRight
            }
        }
    }

    internal func roundCorners(radius: CGFloat, corners: [RoundingCorner]) {
        self.clipsToBounds = true
        if #available(iOS 11.0, *) {
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = corners.map { $0.toCACornerMask() }.reduce(CACornerMask(rawValue: 0), { $0.union($1) })
        } else {
            let path = UIBezierPath(
                roundedRect: self.bounds,
                byRoundingCorners: corners.map { $0.toUIRectCorner() }.reduce(UIRectCorner(rawValue: 0), { $0.union($1) }),
                cornerRadii: CGSize(width: radius, height: radius)
            )
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath

            self.layer.mask = maskLayer
        }
    }
}
