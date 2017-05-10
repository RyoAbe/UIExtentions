//
//  Button.swift
//  Moopa
//
//  Created by RyoAbe on 2015/11/02.
//  Copyright © 2015年 RyoAbe. All rights reserved.
//

import UIKit

class BaseButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        tintColor = UIColor.textColor
    }
}

class AccentButton: BaseButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.textColor.cgColor
        layer.borderWidth = 2
        toRounded()
    }
}

extension AppDelegate {
    func applyAppearance_specific() {
        UIView.appearance(whenContainedInInstancesOf: [ViewController.self]).backgroundColor = UIColor.backgroundColor
    }
}

extension UIColor: Palette {
    static var darkPrimaryColor: UIColor { return UIColor(rgb: 0x689F38) }
    static var primaryColor: UIColor { return UIColor(rgb: 0x8BC34A) }
    static var lightPrimaryColor: UIColor { return UIColor(rgb: 0xDCEDC8) }
    static var accentColor: UIColor { return UIColor(rgb: 0xFF9800) }
    static var textColor: UIColor { return UIColor(rgb: 0x689F38) }
    static var primaryTextColor: UIColor { return UIColor(rgb: 0x212121) }
    static var secondaryTextColor: UIColor { return UIColor(rgb: 0x757575) }
    static var backgroundColor: UIColor { return UIColor(rgb: 0xFFFFFF) }
    static var dviderTextColor: UIColor { return UIColor(rgb: 0xBDBDBD) }
}

