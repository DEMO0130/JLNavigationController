//
//  TransitioningAnimation.swift
//  JLNavigationController
//
//  Created by DEMO on 16/7/29.
//  Copyright © 2016年 DEMO. All rights reserved.
//

import UIKit

internal let kAnimationDuration: TimeInterval = 0.8

internal let kAffineTransformScale: CGFloat = 0.2

class PushAnimation: NSObject {
    
}

extension PushAnimation: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            
            return
            
        }
        
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            
            return
            
        }
        
        guard let containerView: UIView = transitionContext.containerView else {
            
            return
            
        }
        
        let toVCFrame = transitionContext.finalFrame(for: toVC)
        
        toVC.view.frame = toVCFrame.offsetBy(dx: 0, dy: UIScreen.main.bounds.height)
        
        containerView.addSubview(toVC.view)

        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                                   delay: 0.0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.0,
                                   options: UIViewAnimationOptions(),
                                   animations: {
                                    
            fromVC.view.alpha = 0.8
            
            toVC.view.frame = toVCFrame
            
        }) { (finished: Bool) in
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
            fromVC.view.alpha = 1.0
        }
        
    }
    
}


class PopAnimation: NSObject {
    
}

extension PopAnimation: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
        
            return
        
        }
        
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
        
            return
            
        }
        
        guard let containerView: UIView = transitionContext.containerView else {
            
            return
            
        }

        
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            
            fromVC.view.transform = CGAffineTransform(scaleX: kAffineTransformScale, y: kAffineTransformScale)
            
            fromVC.view.alpha = 0.5
            
        }, completion: { (finished: Bool) in
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
        }) 
        
    }
    
}
