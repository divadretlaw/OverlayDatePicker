//
//  UIApplicationExtensions.swift
//  OverlayDatePicker
//
//  Created by David Walter on 12.03.22.
//

import Foundation
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
