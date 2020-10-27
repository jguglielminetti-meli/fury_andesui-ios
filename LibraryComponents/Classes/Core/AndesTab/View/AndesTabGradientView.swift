//
//  AndesTabGradientView.swift
//  AndesUI
//
//  Created by Jose Antonio Guglielminetti on 27/10/2020.
//

import Foundation

internal class AndesTabGradientView: UIView {
    private let backgroundLayer: CAGradientLayer = CAGradientLayer()
    internal var colors: [UIColor] = [] {
        didSet {
            self.backgroundLayer.colors = self.colors.map({ $0.cgColor })
        }
    }

    override internal init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }

    internal required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }

    override internal func layoutSubviews() {
        super.layoutSubviews()

        self.backgroundLayer.frame = self.bounds
        self.backgroundLayer.locations = [0.0, 1.0]
        self.backgroundLayer.startPoint = CGPoint(x: self.backgroundLayer.bounds.minX, y: self.backgroundLayer.bounds.minY)
        self.backgroundLayer.endPoint = CGPoint(x: self.backgroundLayer.bounds.minX + 1, y: self.backgroundLayer.bounds.minY)
    }

    private func setupUI() {
        self.layer.addSublayer(self.backgroundLayer)
    }
}
