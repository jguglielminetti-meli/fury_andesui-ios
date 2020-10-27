//
//  AndesTabDelegate.swift
//  AndesUI
//
//  Created by Jose Antonio Guglielminetti on 27/10/2020.
//

import Foundation

internal protocol AndesTabViewDelegate: AnyObject {
    func tab(didSelectItemAt index: Int)
    func tab(didDeselectItemAt index: Int)
}
