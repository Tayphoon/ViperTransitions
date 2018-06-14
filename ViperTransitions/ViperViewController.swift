//
//  ViperViewController.swift
//  ViperTransitions
//
//  Created by Tayphoon on 01/04/2018.
//  Copyright © 2018 Tayphoon. All rights reserved.
//

import UIKit

public protocol ViperController: ViperModuleWithInput {
    
    associatedtype T
    
    var output: T? { get set}
}

extension ViperController where Self: UIViewController {
    
    public var moduleInput: ViperModuleInput? {
        get {
            return output as? ViperModuleInput
        }
    }
}

open class ViperViewController<T>: UIViewController, ViperModuleWithInput {
    
    public var output: T?

    public var moduleInput: ViperModuleInput? {
        get {
            return output as? ViperModuleInput
        }
    }
}
