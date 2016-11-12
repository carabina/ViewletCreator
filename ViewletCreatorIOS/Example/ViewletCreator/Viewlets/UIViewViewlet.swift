//
//  UIViewViewlet.swift
//  Viewlet creator example
//
//  Create a simple view
//

import UIKit
import ViewletCreator

class UIViewViewlet: Viewlet {

    // --
    // MARK: Implementation
    // --

    func create() -> UIView {
        return UIView()
    }
    
    func update(view: UIView, attributes: [String: Any], parent: UIView?, binder: ViewletBinder?) {
        if view is UIView {
            UIViewViewlet.applyDefaultAttributes(view: view, attributes: attributes)
        }
    }
    
    func canRecycle(view: UIView, attributes: [String : Any]) -> Bool {
        return true
    }
    
    
    // --
    // MARK: Shared
    // --
    
    static func applyDefaultAttributes(view: UIView, attributes: [String: Any]) {
        view.backgroundColor = ViewletConvUtil.asColor(value: attributes["backgroundColor"] as Any) ?? UIColor.clear
        view.isHidden = ViewletConvUtil.asBoolean(value: attributes["hidden"] as Any) ?? false
    }
    
}
