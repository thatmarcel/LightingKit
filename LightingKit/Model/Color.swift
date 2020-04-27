//
//  Color.swift
//  LightingKit
//
//  Created by Marcel Braun on 27.04.20.
//  Copyright © 2020 Pete Morris. All rights reserved.
//

import Foundation
import HomeKit

/// Used to represent a `Light` object's color.
public final class Color: Characteristic {
    /// The current brightness value.
    public var value: UIColor? {
        guard let value = homeKitCharacteristic.value as? Int else { return nil }
        return color(from: value)
    }
    
    /// Convert color to hue value
    internal func hue(from color: UIColor) -> Int {
        var hue: CGFloat = 0
        var sat: CGFloat = 0
        var bri: CGFloat = 0
        var alpha: CGFloat = 0
        color.getHue(&hue, saturation: &sat, brightness: &bri, alpha: &alpha)
        return Int(hue * 360) // HomeKit Hue values range from 0-360
    }
    
    /// Convert hue value to color
    internal func color(from hue: Int) -> UIColor {
        return UIColor(hue: CGFloat(hue) / 360, saturation: 1, brightness: 1, alpha: 1)
    }
    
    /// The `HMCharacteristic` that represents the light's color.
    internal let homeKitCharacteristic: HomeKitCharacteristicProtocol
    /**
     Initializes a `Color` object.
     - Parameters:
     - characteristic: The `HMCharacteristic` that represents the light's brightness state.
     - returns: An initialized `Color` object.
     */
    internal init?(homeKitCharacteristic: HomeKitCharacteristicProtocol?) {
        guard let homeKitCharacteristic = homeKitCharacteristic, homeKitCharacteristic.type == .color else {
            return nil
        }
        self.homeKitCharacteristic = homeKitCharacteristic
    }
    /**
     Sets the brightness of the `Light` to a new value **immediately**.
     - Parameters:
     - brightness: The new brightness value. 0-100.
     - completion: The closure that should be execute when the brightness value has been updated.
     */
    public func set(color: UIColor, completion: @escaping (Error?) -> Void) {
        homeKitCharacteristic.writeValue(hue(from: color), completionHandler: completion)
    }
}
