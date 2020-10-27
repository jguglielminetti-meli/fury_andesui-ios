//
//  AndesTab.swift
//  AndesUI
//
//  Created by Jose Antonio Guglielminetti on 26/10/2020.
//

import Foundation

import Foundation

/**
 User interface element to present mutually exclusive content areas. Each segment of a tabbed control is known as a tab,
 and clicking a tab displays its corresponding content area.
 ...
 */
public class AndesTab: UIControl {
    private var view: AndesTabView

    public weak var delegate: AndesTabDelegate?

    /**
     Get the number of tab in the component.
     */
    public var count: Int {
        return self.view.count
    }
    /**
     Get the index of the selected tab if one is selected.
     */
    public var selectedIndex: Int? {
        return self.view.selectedIndex
    }

    /**
     Constructor for the tab when it is used programmatically.
     */
    public init() {
        self.view = AndesTabViewBase()

        super.init(frame: .zero)

        self.setup()
    }

    /**
     Constructor for the tab when it is used by interface builder
     */
    public required init?(coder: NSCoder) {
        self.view = AndesTabViewBase()

        super.init(coder: coder)

        self.setup()
    }

    /**
     Add a new tab to the component.
     - parameter title: the title use in the tab.
     */
    public func addItem(_ title: String) {
        self.view.addItem(title: title)
    }

    /**
     Removes a existing tab from the component.
     - parameter at: the index of the tab to be removed.
     */
    public func removeItem(at index: Int) {
        self.view.removeItem(at: index)
    }

    /**
     Change the state of a tab to active (seleted).
     - parameter at: the index of the tab to set as active.
     */
    public func setActive(at index: Int) {
        self.view.setActive(at: index)
    }

    /**
     Change the sstate of a tab to inactive (normal).
     - parameter at: the index of the tab to set as inactive.
     */
    public func setInactive(at index: Int) {
        self.view.setActive(at: index)
    }

    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false

        self.drawContentView()
        self.backgroundColor = .clear
    }

    private func drawContentView() {
        self.addSubview(self.view)
        self.view.delegate = self
        self.setSubviewConstraints()
    }

    private func setSubviewConstraints() {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                self.view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                self.view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                self.view.topAnchor.constraint(equalTo: self.topAnchor),
                self.view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
        )
    }
}

extension AndesTab: AndesTabViewDelegate {
    internal func tab(didSelectItemAt index: Int) {
        self.delegate?.tab(self, didSelectItemAt: index)
    }

    internal func tab(didDeselectItemAt index: Int) {
        self.delegate?.tab(self, didDeselectItemAt: index)
    }
}
