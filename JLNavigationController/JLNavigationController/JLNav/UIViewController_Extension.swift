//
//  UIViewController_Extension.swift
//  JLNavigationController
//
//  Created by DEMO on 16/7/29.
//  Copyright © 2016年 DEMO. All rights reserved.
//

import UIKit

internal var kInteractivePopGestureAble = "interactivePopGestureAble"

extension UIViewController {

    var interactivePopGestureAble: Bool! {
        
        get {
            
            guard let number = objc_getAssociatedObject(self, &kInteractivePopGestureAble) as? NSNumber else {
                
                return true
                
            }
            
            return number.boolValue
                    
        }
        
        set {
        
            objc_setAssociatedObject(self, &kInteractivePopGestureAble, NSNumber(bool: newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
    
    }

}

