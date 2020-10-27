//
//  AndesTabDelegate.swift
//  AndesUI
//
//  Created by Jose Antonio Guglielminetti on 27/10/2020.
//

import Foundation

/// Delegado para los eventos del tab
public protocol AndesTabDelegate: AnyObject {
    /// Notifica el cambio de selección del componente de tabs.
    /// - Parameters:
    ///   - tab: la instancia del componente que emitió el evento de cambio de selección.
    ///   - index: el índice del tab que se acaba de seleccionar.
    func tab(_ tab: AndesTab, didSelectItemAt index: Int)

    /// Notifica la deselección de un tab del componente de tabs.
    /// - Parameters:
    ///   - tab: la instancia del componente que emitió el evento de cambio de deselección.
    ///   - index: el índicice del tab que se acaba de deseleccionar.
    func tab(_ tab: AndesTab, didDeselectItemAt index: Int)
}

public extension AndesTabDelegate {
    /// Notifica la selección de un tab del componente de tabs.
    /// - Parameters:
    ///   - tab: la instancia del componente que emitió el evento de cambio de selección.
    ///   - index: el índice del tab que se acaba de seleccionar.
    func tab(_ tab: AndesTab, didSelectItemAt index: Int) {
        // default implementation to mimic objective-c optional method.
    }

    /// Notifica la deselección de un tab del componente de tabs.
    /// - Parameters:
    ///   - tab: la instancia del componente que emitió el evento de cambio de deselección.
    ///   - index: el índicice del tab que se acaba de deseleccionar.
    func tab(_ tab: AndesTab, didDeselectItemAt index: Int) {
        // default implementation to mimic objective-c optional method.
    }
}
