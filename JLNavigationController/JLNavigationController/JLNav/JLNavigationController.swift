//
//  JLNavigationController.swift
//  JLNavigationController
//
//  Created by DEMO on 16/7/29.
//  Copyright © 2016年 DEMO. All rights reserved.
//

import UIKit

typealias JLNavgationControllerProtocol = protocol<UINavigationControllerDelegate, UIGestureRecognizerDelegate, JLNavgationControllerDelegate>

class JLNavigationController: UINavigationController {
    
    lazy var jlDelegate: JLNavgationControllerProtocol = {
        
        return JLNavDelegate(nav: self)
        
    }()
    
    // MARK: - life circle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.interactivePopGestureRecognizer?.enabled = false

    }
    
    deinit {  print("deinit") }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {

        if self.interactivePopGestureRecognizer?.view?.gestureRecognizers?.contains(jlDelegate.interactiveGesture) != true {
            
            self.interactivePopGestureRecognizer?.view?.addGestureRecognizer(jlDelegate.interactiveGesture)
                        
        }
        
        super.pushViewController(viewController, animated: animated)
        
    }
    
    
}

