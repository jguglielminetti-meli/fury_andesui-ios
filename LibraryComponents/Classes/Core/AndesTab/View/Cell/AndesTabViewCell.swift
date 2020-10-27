//
//  AndesTabViewCell.swift
//  AndesUI
//
//  Created by Jose Antonio Guglielminetti on 27/10/2020.
//

import Foundation

internal class AndesTabViewCell: UIButton {
    private var backgroundColorDictionary: [String: UIColor] = [:]
    private let backgroundLayer: CALayer = CALayer()

    override internal var isHighlighted: Bool {
        didSet {
            self.setNeedsDisplay()
        }
    }

    internal init() {
        super.init(frame: .zero)
        self.setupUI()
    }

    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }

    override internal func layoutSubviews() {
        super.layoutSubviews()

        self.backgroundLayer.frame = self.bounds
    }

    override internal func draw(_ rect: CGRect) {
        super.draw(rect)

        let color = self.backgroundColor(for: self.state)?.cgColor
        self.backgroundLayer.backgroundColor = color
    }

    internal func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        let key = backgroundColorKey(for: state)
        self.backgroundColorDictionary[key] = color

        self.setNeedsDisplay()
    }

    internal func backgroundColor(for state: UIControl.State) -> UIColor? {
        let key = backgroundColorKey(for: state)
        if let color = self.backgroundColorDictionary[key] {
            return color
        }
        return nil
    }

    private func setupUI() {
        self.layer.addSublayer(self.backgroundLayer)
        self.roundCorners(radius: 6.0, corners: [.topLeft, .topRight])
    }

    private func backgroundColorKey(for state: UIControl.State) -> String {
        return "bg\(state.rawValue)"
    }
}
