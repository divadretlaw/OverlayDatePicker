//
//  Localizable.swift
//  OverlayDatePicker
//
//  Created by David Walter on 13.03.22.
//

import Foundation

private class Localizable {
}

extension String {
    func localized(comment: String = "") -> String {
        let bundle = Bundle.main.path(forResource: "OverlayDatePicker", ofType: "strings") != nil ? Bundle.main : Bundle.module
        
        return NSLocalizedString(self, tableName: "OverlayDatePicker", bundle: bundle, comment: comment)
    }
}
