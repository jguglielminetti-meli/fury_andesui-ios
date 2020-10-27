//
//  AndesTabView.swift
//  AndesUI
//
//  Created by Jose Antonio Guglielminetti on 27/10/2020.
//

import Foundation

internal protocol AndesTabView: UIView {
    var selectedIndex: Int? { get }
    var count: Int { get }
    var delegate: AndesTabViewDelegate? { get set }

    func addItem(title: String)
    func removeItem(at index: Int)
    func setActive(at index: Int)
    func setInactive(at index: Int)
}
