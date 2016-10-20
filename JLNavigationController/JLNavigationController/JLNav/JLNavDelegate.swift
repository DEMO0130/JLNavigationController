//
//  JLNavDelegate.swift
//  ggg
//
//  Created by DEMO on 16/7/30.
//  Copyright © 2016年 DEMO. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


protocol JLNavgationControllerDelegate {
    
    var interactiveGesture: UIPanGestureRecognizer { get }
    
    var interactiveTransition: UIPercentDrivenInteractiveTransition? { get }
    
    var popAnimationObj: UIViewControllerAnimatedTransitioning { get }
    
    var pushAnimationObj: UIViewControllerAnimatedTransitioning { get }
    
    weak var navigation: UINavigationController? { get }
    
}

class JLNavDelegate: NSObject, JLNavgationControllerDelegate {
    
    lazy var interactiveGesture: UIPanGestureRecognizer = {
        
        var pan = UIPanGestureRecognizer()
        
        pan.maximumNumberOfTouches = 1
        
        pan.delegate = self
        
        return pan
        
    }()
    
    var interactiveTransition: UIPercentDrivenInteractiveTransition?
    
    lazy var popAnimationObj: UIViewControllerAnimatedTransitioning = {
        
        return PopAnimation()
        
    }()
    
    lazy var pushAnimationObj: UIViewControllerAnimatedTransitioning = {
        
        return PushAnimation()
        
    }()
    
    weak var navigation: UINavigationController?
    
    init(nav: UINavigationController) {
        
        self.navigation = nav
        
        super.init()
        
        navigation?.delegate = self
        
        interactiveGesture.addTarget(self, action: #selector(JLNavDelegate.navigationPop(_:)))
        
    }
    
}

// MARK: - UINavigationControllerDelegate
extension JLNavDelegate: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        
        switch operation {
            
        case .push:
            
            return pushAnimationObj
            
        case .pop:
            
            return popAnimationObj
            
        default:
            return nil
        }
        
        
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        guard animationController.isKind(of: PopAnimation.self) else {
            
            return nil
            
        }
        
        return interactiveTransition
        
    }
    
    
}

// MARK: - UIGestureRecognizerDelegate
extension JLNavDelegate: UIGestureRecognizerDelegate {
    
    func navigationPop(_ sender: UIPanGestureRecognizer) {
        
        let senderX = sender.translation(in: sender.view).x
        
        let progress = senderX / (sender.view?.bounds ?? CGRect.zero).width
        
        switch sender.state {
        case .began:
            
            self.interactiveTransition = UIPercentDrivenInteractiveTransition()
            
            self.navigation?.popViewController(animated: true)
            
        case .changed:
            
            interactiveTransition?.update(progress)
            
        case .ended, .cancelled:
            
            if progress > 0.5 {
                interactiveTransition?.finish()
            } else {
                interactiveTransition?.cancel()
            }
            
            interactiveTransition = nil
            
        default:
            
            interactiveTransition?.cancel()
            
            interactiveTransition = nil
            
        }
        
        
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        guard self.navigation?.viewControllers.count > 1 else {
            
            return false
            
        }
        
        guard self.navigation?.topViewController?.interactivePopGestureAble == true else {
            
            return false
            
        }
        
        
        guard let sender = gestureRecognizer as? UIPanGestureRecognizer else {
            
            return false
            
        }
        
        guard sender.translation(in: sender.view).x >= 0 else {
            
            return false
            
        }
        
        return true
        
    }
    
}
