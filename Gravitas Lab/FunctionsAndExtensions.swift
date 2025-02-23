//
//  FunctionsAndExtensions.swift
//  Gravitas Lab
//
//  Created by Miro Pletscher on 23/02/25.
//

import Foundation
import SwiftUI

extension Color {
    static func fromRGB(red: Int, green: Int, blue: Int) -> Color {
        return Color(
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255
        )
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64
        var a: UInt64 = 255  // Default alpha to fully opaque

        switch hex.count {
        case 6: // RGB (e.g., "#RRGGBB")
            (r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        case 8: // RGBA (e.g., "#RRGGBBAA")
            (r, g, b, a) = (int >> 24 & 0xFF, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (255, 255, 255) // Default to white for invalid hex
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension CGFloat {
    func degreesToRadians() -> CGFloat {
        return self * .pi / 180.0
    }
}
