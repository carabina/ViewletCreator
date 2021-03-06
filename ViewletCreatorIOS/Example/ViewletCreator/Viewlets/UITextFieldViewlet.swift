//
//  UITextFieldViewlet.swift
//  Viewlet creator example
//
//  Create a simple text input field
//

import UIKit
import ViewletCreator

class UITextFieldViewlet: Viewlet {

    func create() -> UIView {
        return UITextField()
    }
    
    func update(view: UIView, attributes: [String: Any], parent: UIView?, binder: ViewletBinder?) {
        if let textField = view as? UITextField {
            // Prefilled text and placeholder
            textField.text = ViewletConvUtil.asString(value: attributes["text"] as Any)
            textField.placeholder = NSLocalizedString(ViewletConvUtil.asString(value: attributes["placeholder"] as Any) ?? "", comment: "")
            
            // Set keyboard mode
            textField.keyboardType = .default
            textField.autocapitalizationType = .sentences
            if let keyboardType = ViewletConvUtil.asString(value: attributes["keyboardType"] as Any) {
                if keyboardType == "email" {
                    textField.keyboardType = .emailAddress
                    textField.autocapitalizationType = .none
                } else if keyboardType == "url" {
                    textField.keyboardType = .URL
                    textField.autocapitalizationType = .none
                }
            }
            
            // Text style
            let fontSize = ViewletConvUtil.asPointValue(value: attributes["textSize"] as Any) ?? 17
            if let font = ViewletConvUtil.asString(value: attributes["font"] as Any) {
                if font == "bold" {
                    textField.font = UIFont.boldSystemFont(ofSize: fontSize)
                } else if font == "italics" {
                    textField.font = UIFont.italicSystemFont(ofSize: fontSize)
                } else {
                    textField.font = UIFont(name: font, size: fontSize)
                }
            } else {
                textField.font = UIFont.systemFont(ofSize: fontSize)
            }
            
            // Standard view attributes
            UIViewViewlet.applyDefaultAttributes(view: view, attributes: attributes)
        }
    }
    
    func canRecycle(view: UIView, attributes: [String : Any]) -> Bool {
        return view is UITextField
    }

}
