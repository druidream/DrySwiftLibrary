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

/// Utility functions for color manipulation
public struct ColorUtils {
    /// Returns a color that is interpolated between two colors based on progress (0-1)
    /// - Parameters:
    ///   - from: The starting color (at progress = 0)
    ///   - to: The ending color (at progress = 1)
    ///   - progress: The progress value between 0 and 1
    /// - Returns: The interpolated color
    public static func interpolate(from start: Color, to end: Color, progress: Double) -> Color {
        // Ensure progress is between 0 and 1
        let t = max(0, min(1, progress))

        // Get color components for both colors
        let startComponents = start.rgbaComponents
        let endComponents = end.rgbaComponents

        // Interpolate each component
        let r = startComponents.r + (endComponents.r - startComponents.r) * CGFloat(t)
        let g = startComponents.g + (endComponents.g - startComponents.g) * CGFloat(t)
        let b = startComponents.b + (endComponents.b - startComponents.b) * CGFloat(t)
        let a = startComponents.a + (endComponents.a - startComponents.a) * CGFloat(t)

        // Create new color from interpolated components
        return Color(.displayP3,
                     red: Double(r),
                     green: Double(g),
                     blue: Double(b),
                     opacity: Double(a))
    }
}

// MARK: - Private Color Extensions
private extension Color {
    /// Extract RGBA components from a Color
    var rgbaComponents: RGBAComponents {
        // Need to use UIColor as bridge since SwiftUI's Color doesn't expose components directly
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        // Get components - defaulting to black transparent if conversion fails
        if !uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            // Conversion to RGB failed, try getting white value
            uiColor.getWhite(&red, alpha: &alpha)
            green = red
            blue = red
        }

        return RGBAComponents(r: red, g: green, b: blue, a: alpha)
    }
}
