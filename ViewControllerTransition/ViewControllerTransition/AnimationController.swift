//
//  AnimationController.swift
//  ViewControllerTransition
//
//  Created by Nelson Gonzalez on 5/27/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class AnimationController: NSObject {
    
    private let animationDuration: Double
    private let animationType: AnimationType
    
    enum AnimationType {
        case present
        case dismiss
    }
    
    init(animationDuration: Double, animationType: AnimationType) {
        self.animationDuration = animationDuration
        self.animationType = animationType
    }
    
}
extension AnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: animationDuration) ?? 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to), let fromVC = transitionContext.viewController(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        
        switch animationType {
        case .present:
            transitionContext.containerView.addSubview(toVC.view)
            presentAnimation(with: transitionContext, viewToAnimate: toVC.view)
        case .dismiss:
            transitionContext.containerView.addSubview(toVC.view)
            transitionContext.containerView.addSubview(fromVC.view)
            dismissAnimation(with: transitionContext, viewToAnimate: fromVC.view)
        }
    }
    
    
    func presentAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate: UIView) {
        viewToAnimate.clipsToBounds = true
        viewToAnimate.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        let duration = transitionDuration(using: transitionContext)
        
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.80, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            viewToAnimate.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    
    func dismissAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate: UIView) {
        
        let duration = transitionDuration(using: transitionContext)
        let scaleDown = CGAffineTransform(scaleX: 0.3, y: 0.3)
        let moveOut = CGAffineTransform(translationX: -viewToAnimate.frame.width, y: 0)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.7, animations: {
                viewToAnimate.transform = scaleDown
            })
            
            UIView.addKeyframe(withRelativeStartTime: 3.0/duration, relativeDuration: 1.0, animations: {
                viewToAnimate.transform = scaleDown.concatenating(moveOut)
                viewToAnimate.alpha = 0
            })
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    
}
