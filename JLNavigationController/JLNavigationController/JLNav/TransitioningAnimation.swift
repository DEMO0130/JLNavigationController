//
//  TransitioningAnimation.swift
//  JLNavigationController
//
//  Created by DEMO on 16/7/29.
//  Copyright © 2016年 DEMO. All rights reserved.
//

import UIKit

internal let kAnimationDuration: NSTimeInterval = 0.8

internal let kAffineTransformScale: CGFloat = 0.2

class PushAnimation: NSObject {
    
}

extension PushAnimation: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return kAnimationDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) else {
            
            return
            
        }
        
        guard let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
            
            return
            
        }
        
        guard let containerView = transitionContext.containerView() else {
            
            return
            
        }
        
        let toVCFrame = transitionContext.finalFrameForViewController(toVC)
        
        toVC.view.frame = CGRectOffset(toVCFrame, 0, CGRectGetHeight(UIScreen.mainScreen().bounds))
        
        containerView.addSubview(toVC.view)

        UIView.animateWithDuration(self.transitionDuration(transitionContext),
                                   delay: 0.0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.0,
                                   options: .CurveEaseInOut,
                                   animations: {
                                    
            fromVC.view.alpha = 0.8
            
            toVC.view.frame = toVCFrame
            
        }) { (finished: Bool) in
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            
            fromVC.view.alpha = 1.0
        }
        
    }
    
}


class PopAnimation: NSObject {
    
}

extension PopAnimation: UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return kAnimationDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) else {
        
            return
        
        }
        
        guard let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
        
            return
            
        }
        
        guard let containerView = transitionContext.containerView() else {
            
            return
            
        }

        
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
            
            fromVC.view.transform = CGAffineTransformMakeScale(kAffineTransformScale, kAffineTransformScale)
            
            fromVC.view.alpha = 0.5
            
        }) { (finished: Bool) in
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            
        }
        
    }
    
}