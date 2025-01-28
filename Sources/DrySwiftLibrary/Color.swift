//
//  Color.swift
//  DrySwiftLibrary
//
//  Created by Jun Gu on 1/12/25.
//

import SwiftUI
import UIKit

public extension Color {
    init(hex: String, defaultColor: Color = .clear) {
        guard let components = parseHexColor(hex) else {
            self = defaultColor
            return
        }

        self.init(red: components.r, green: components.g, blue: components.b, opacity: components.a)
    }
}

public extension UIColor {
    convenience init(hex: String) {
        guard let components = parseHexColor(hex) else {
            self.init(red: 0, green: 0, blue: 0, alpha: 0)
            return
        }

        self.init(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }
}

private struct RGBAComponents {
    let r: CGFloat
    let g: CGFloat
    let b: CGFloat
    let a: CGFloat
}

private func parseHexColor(_ hex: String) -> RGBAComponents? {
    var cleanedHexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if cleanedHexString.hasPrefix("#") {
        cleanedHexString.remove(at: cleanedHexString.startIndex)
    }

    guard cleanedHexString.count == 6 || cleanedHexString.count == 8 else {
        return nil
    }

    var rgbValue: UInt64 = 0
    Scanner(string: cleanedHexString).scanHexInt64(&rgbValue)

    let r, g, b, a: CGFloat
    if cleanedHexString.count == 6 {
        r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        b = CGFloat(rgbValue & 0x0000FF) / 255.0
        a = 1.0
    } else {
        r = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
        g = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
        b = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
        a = CGFloat(rgbValue & 0x000000FF) / 255.0
    }

    return RGBAComponents(r: r, g: g, b: b, a: a)
}
