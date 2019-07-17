//
//  CardView.swift
//  IOSHealthKit
//
//  Created by Fauzi Fauzi on 17/07/19.
//  Copyright © 2019 Fauzi. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = false
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.shadowRadius = newValue
            layer.masksToBounds = false
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
            layer.shadowColor = UIColor.darkGray.cgColor
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
            layer.shadowColor = UIColor.black.cgColor
            layer.masksToBounds = false
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0{
        
        didSet{
            
            self.layer.borderWidth = borderWidth
        }
    }
    
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        
        didSet {
            
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
//    override func prepareForInterfaceBuilder() {
//        
//        super.prepareForInterfaceBuilder()
//    }
    
    
}
