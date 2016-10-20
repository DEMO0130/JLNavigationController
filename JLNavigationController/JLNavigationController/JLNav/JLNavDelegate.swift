//
//  JLNavDelegate.swift
//  ggg
//
//  Created by DEMO on 16/7/30.
//  Copyright © 2016年 DEMO. All rights reserved.
//

import UIKit

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
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        
        switch operation {
            
        case .Push:
            
            return pushAnimationObj
            
        case .Pop:
            
            return popAnimationObj
            
        default:
            return nil
        }
        
        
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        guard animationController.isKindOfClass(PopAnimation) else {
            
            return nil
            
        }
        
        return interactiveTransition
        
    }
    
    
}

// MARK: - UIGestureRecognizerDelegate
extension JLNavDelegate: UIGestureRecognizerDelegate {
    
    func navigationPop(sender: UIPanGestureRecognizer) {
        
        let senderX = sender.translationInView(sender.view).x
        
        let progress = senderX / CGRectGetWidth(sender.view?.bounds ?? CGRectZero)
        
        switch sender.state {
        case .Began:
            
            self.interactiveTransition = UIPercentDrivenInteractiveTransition()
            
            self.navigation?.popViewControllerAnimated(true)
            
        case .Changed:
            
            interactiveTransition?.updateInteractiveTransition(progress)
            
        case .Ended, .Cancelled:
            
            if progress > 0.5 {
                interactiveTransition?.finishInteractiveTransition()
            } else {
                interactiveTransition?.cancelInteractiveTransition()
            }
            
            interactiveTransition = nil
            
        default:
            
            interactiveTransition?.cancelInteractiveTransition()
            
            interactiveTransition = nil
            
        }
        
        
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        guard self.navigation?.viewControllers.count > 1 else {
            
            return false
            
        }
        
        guard self.navigation?.topViewController?.interactivePopGestureAble == true else {
            
            return false
            
        }
        
        
        guard let sender = gestureRecognizer as? UIPanGestureRecognizer else {
            
            return false
            
        }
        
        guard sender.translationInView(sender.view).x >= 0 else {
            
            return false
            
        }
        
        return true
        
    }
    
}
