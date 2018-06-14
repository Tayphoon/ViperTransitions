//
//  ViperModuleTransitionHandler.swift
//  ViperTransitions
//
//  Created by Tayphoon on 04/01/2018.
//  Copyright © 2018 Tayphoon. All rights reserved.
//

import UIKit

public protocol ViperModuleTransitionHandler: class {

    @discardableResult
    func moduleOpenPromiseForController<T>(controller: T) -> ViperOpenModulePromise where T: UIViewController

    @discardableResult
    func openModuleController<T>(controller: T, animated: Bool) -> ViperOpenModulePromise where T: UIViewController

    @discardableResult
    func presentModuleController<T>(controller: T, animated: Bool) -> ViperOpenModulePromise where T: UIViewController

    @discardableResult
    func openSubmoduleController<T>(controller: T, containerView: UIView) -> ViperOpenModulePromise where T: UIViewController

    func closeCurrentModule(animated: Bool)

    func closeCurrentSubmodule()

    func closeLastSubmoduleIfNeeded()
}


// MARK: - Default parameters
public extension ViperModuleTransitionHandler {

    @discardableResult
    public func openModuleController<T>(controller: T, animated: Bool = true) -> ViperOpenModulePromise where T: UIViewController {
        return openModuleController(controller: controller, animated: animated)
    }

    @discardableResult
    public func presentModuleController<T>(controller: T, animated: Bool = true) -> ViperOpenModulePromise where T: UIViewController {
        return presentModuleController(controller: controller, animated: animated)
    }


    public func closeCurrentModule(animated: Bool = true) {
        closeCurrentModule(animated: animated)
    }

}

extension UIViewController : ViperModuleTransitionHandler {
    
    public func moduleOpenPromiseForController<T>(controller: T) -> ViperOpenModulePromise where T: UIViewController {
        let openModulePromise: ViperOpenModulePromise = ViperOpenModulePromise()
        var destinationController: UIViewController? = controller
        
        if let navigationController = controller as? UINavigationController {
            destinationController = navigationController.topViewController
        }
        
        if let module = destinationController as? ViperModuleWithInput {
            openModulePromise.moduleInput = module.moduleInput
        }

        return openModulePromise;
    }
    
    // Method opens module controller
    public func openModuleController<T>(controller: T, animated: Bool = true) -> ViperOpenModulePromise where T: UIViewController {
        let openModulePromise = moduleOpenPromiseForController(controller: controller)
        
        self.navigationController?.pushViewController(controller, animated: animated)
        
        return openModulePromise
    }
    
    // Method present module controller
    public func presentModuleController<T>(controller: T, animated: Bool = true) -> ViperOpenModulePromise where T: UIViewController {
        let openModulePromise = moduleOpenPromiseForController(controller: controller)
        
        //Call present module controller in next chain, because loadView called immediately after presentViewController call
        DispatchQueue.main.async {
            self.present(controller, animated: animated, completion: nil)
        }
        
        return openModulePromise
    }
    
    // Method removes/closes module
    public func closeCurrentModule(animated: Bool = true) {
        let isInNavigationStack = (self.parent is UINavigationController)
        if let navigationController = self.parent as? UINavigationController, navigationController.childViewControllers.count > 1 {
            navigationController.popViewController(animated: animated)
        }
        else if self.presentingViewController != nil {
            self.dismiss(animated: animated, completion: nil)
        }
        else if !isInNavigationStack && self.view.superview != nil {
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        }
    }
    
    // Method openes submodule 
    public func openSubmoduleController<T>(controller: T, containerView: UIView) -> ViperOpenModulePromise where T: UIViewController {
        let openModulePromise = moduleOpenPromiseForController(controller: controller)
        let destinationController: UIViewController = controller

        DispatchQueue.main.async {
            destinationController.willMove(toParentViewController: self)

            self.addChildViewController(destinationController)
            destinationController.beginAppearanceTransition(true, animated: true)
            containerView.addSubview(destinationController.view)
            destinationController.endAppearanceTransition()

            destinationController.view.translatesAutoresizingMaskIntoConstraints = false
            destinationController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            destinationController.view.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
            destinationController.view.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
            destinationController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

            destinationController.didMove(toParentViewController: self)
        }
        
        return openModulePromise
    }
    
    // Methods closees submodule
    public func closeCurrentSubmodule() {
        self.willMove(toParentViewController: nil)
        self.beginAppearanceTransition(false, animated: true)
        self.view.removeFromSuperview()
        self.endAppearanceTransition()
        self.removeFromParentViewController()
    }
    
    public func closeLastSubmoduleIfNeeded() {
        if (self.childViewControllers.count > 1) {
            self.childViewControllers.last?.closeCurrentModule()
        }
    }
}
