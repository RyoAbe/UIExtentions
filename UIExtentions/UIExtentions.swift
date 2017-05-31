//
//  UIKitExtentions.swift
//  Mimamori
//
//  Created by RyoAbe on 2015/12/12.
//  Copyright © 2015年 Myuon Corp. All rights reserved.
//

import UIKit

// MARK: - UIViewController

extension UIViewController {
    
    /// Main.storyboard の インスタンスを返します。見つからなかった場合は例外が発生します。
    var mainStoryBoard: UIStoryboard { return UIStoryboard(name: "Main", bundle: nil) }
    
    /// AlertViewController を presentします。
    func presentAlertViewController(_ title: String?, _ message: String? = nil, okActionHandler: ((UIAlertAction) -> ())? ) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: okActionHandler)
        alertViewController.addAction(action)
        present(alertViewController, animated: true, completion: nil)
    }
    
    /// AlertViewController を presentします。
    func presentAlertViewController(_ title: String?, _ message: String? = nil) {
        presentAlertViewController(title, message, okActionHandler: nil)
    }
    
    /// AlertViewController を presentします。
    func presentErrorAlertViewController(_ message: String?) {
        presentAlertViewController(NSLocalizedString("Error", comment: ""), message)
    }
    
    /// UINavigationController を生成します。
    func withNavigationController(_ enableCanelButton: Bool = true) -> UINavigationController {
        if let nav = self as? UINavigationController {
            return nav
        }
        
        let nav = UINavigationController(rootViewController: self)
        if enableCanelButton {
            let height = nav.navigationBar.frame.size.height
            let size = height - (height * 0.6)
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.xMark(size), style: .plain, target: self, action: #selector(UIViewController.dismissViewController(_:)))
        }
        return nav
    }
    
    func dismissViewController(_ sender: AnyObject) {
        dismissViewController(true, completion: nil)
    }
    
    func dismissViewController(_ flag: Bool = true, completion: (() -> Void)? = nil) {
        dismiss(animated: flag, completion: completion)
    }
    
    func loadViewFromXib() -> UIView {
        guard let view = UINib(nibName: String(describing: type(of: self)), bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else {
            abort()
        }
        return view
    }
}

// MARK: - UITableView

extension UITableView {
    func registerClass<T: UITableViewCell>(_ aClass: T.Type) {
        register(aClass, forCellReuseIdentifier: String(describing: aClass))
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ aClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: String(describing: aClass), for: indexPath) as! T
    }
}

// MARK: - UICollectionView

extension UICollectionView {
    func registerNib<T: UICollectionViewCell>(_ aClass: T.Type) {
        let reuseIdentifier = String(describing: aClass)
        let nib = UINib(nibName: String(describing: aClass), bundle: nil)
        register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }
    func dequeueReusableCell<T: UICollectionViewCell>(_ aClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: String(describing: aClass), for: indexPath) as! T
    }
}

// MARK: - UIStoryboard

extension UIStoryboard {
    /// Storyboardから引数で渡したクラス名と一致するStoryboradIDのViewControllerを返します
    func instantiateViewController<T>(_ aClass: T.Type) -> T {
        return self.instantiateViewController(withIdentifier: String(describing: aClass.self)) as! T
    }
}

// MARK: - UIColor

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(r: r, g: g, b: b, a:1)
    }
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red:r/255.0, green:g/255.0, blue:b/255.0, alpha:a)
    }
    convenience init(grayScale gray: CGFloat) {
        self.init(white: gray / 255.0, alpha: 1)
    }
    convenience init(rgb: UInt, alpha: CGFloat = 1.0) {
        let red: CGFloat = CGFloat((rgb & 0xff0000) >> 16) / 255.0
        let green: CGFloat = CGFloat((rgb & 0x00ff00) >> 8) / 255.0
        let blue: CGFloat = CGFloat(rgb & 0x0000ff) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

// MARK: - UIView

extension UIView {
    func toRounded(_ cornerRadius: CGFloat = 6.0) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
    func toCircle() {
        layer.cornerRadius = frame.width * 0.5
        clipsToBounds = true
    }
    
    /// SuperView 全体を覆うようにレイアウトします。
    func toFullScreenLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        superview?.addConstraints([
            NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 1.0, constant: 0)
            ])
    }
    
    /// SuperView に対して上下左右中央に配置します。
    func toCenterLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        superview?.addConstraints([
            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: 0)
            ])
    }
    
    /// 受け取ったinsetsに応じてレイアウトをします。
    func withInsetsLayout(insets: UIEdgeInsets) {
        translatesAutoresizingMaskIntoConstraints = false
        superview?.addConstraints([
            NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1.0, constant: insets.left),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: insets.bottom),
            NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1.0, constant: insets.right),
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: insets.top)
            ])
    }
    
    //// 下端に貼り付いたレイアウトをします。
    func toBottomAlignment() {
        translatesAutoresizingMaskIntoConstraints = false
        superview?.addConstraints([
            NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0)
            ])
    }
}

// MARK: - UIBezierPath

extension UIBezierPath {
    convenience init(start: CGPoint, end: CGPoint, tintColor: UIColor = UIColor.black, lineWidth: CGFloat = 1 / UIScreen.main.scale, lineCapStyle: CGLineCap = .butt) {
        self.init()
        move(to: start)
        addLine(to: end)
        tintColor.setStroke()
        self.lineWidth = lineWidth
        self.lineCapStyle = lineCapStyle
    }
}

// MARK: - UIImage

extension UIImage {
    // 閉じるボタン
    static func xMark(_ lengthOfside: CGFloat, tintColor: UIColor = UIColor.black) -> UIImage {
        let size = CGSize(width: lengthOfside, height: lengthOfside)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        let lineWidth = lengthOfside * 0.05
        
        UIBezierPath(start: CGPoint(x: lineWidth, y: lineWidth),
                     end: CGPoint(x: size.width - lineWidth, y: size.height - lineWidth),
                     tintColor: tintColor,
                     lineWidth: lineWidth,
                     lineCapStyle: .round).stroke()
        
        UIBezierPath(start: CGPoint(x: size.width - lineWidth, y: lineWidth),
                     end: CGPoint(x: lineWidth, y: size.height - lineWidth),
                     tintColor: tintColor,
                     lineWidth: lineWidth,
                     lineCapStyle: .round).stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

// MARK: - CGPoint

extension CGPoint {
    func insetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}

// MARK: - CGSize

extension CGSize {
    func insetBy(dWidth: CGFloat, dHeight: CGFloat) -> CGSize {
        return CGSize(width: width + dWidth, height: height + dHeight)
    }
}

// MARK: - CALayer

extension CALayer {
    func addBorder(_ edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            break
        default:
            break
        }
        border.backgroundColor = color.cgColor;
        addSublayer(border)
    }
}

// MARK: - AppDelegate

extension AppDelegate {
    func applyAppearance() {
        UINavigationBar.appearance().barTintColor = UIColor.darkPrimaryColor
        UINavigationBar.appearance().tintColor = UIColor.primaryColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UIToolbar.appearance().barTintColor = UIColor.backgroundColor
        UIBarButtonItem.appearance().tintColor = UIColor.primaryColor
        applyAppearance_specific()
    }
}

// MARK: - Color

protocol Palette {
    static var darkPrimaryColor: UIColor { get }
    static var primaryColor: UIColor { get }
    static var lightPrimaryColor: UIColor { get }
    static var accentColor: UIColor { get }
    static var backgroundColor: UIColor { get }
    static var textColor: UIColor { get }
    static var primaryTextColor: UIColor { get }
    static var secondaryTextColor: UIColor { get }
    static var dviderTextColor: UIColor { get }
}
