//
//  ViperOpenModulePromise.swift
//  ViperTransitions
//
//  Created by Tayphoon on 04/01/2018.
//  Copyright © 2018 Tayphoon. All rights reserved.
//

import Foundation

public typealias ViperModuleLinkBlock = (_ moduleInput: ViperModuleInput?) -> ViperModuleOutput?

public class ViperOpenModulePromise {
    
    private var linkBlockWasSet: Bool = false
    private var moduleInputWasSet: Bool = false
    private var linkBlock: ViperModuleLinkBlock?

    public var moduleInput : ViperModuleInput? {
        didSet {
            moduleInputWasSet = true
            tryPerformLink()
        }
    }

    public func thenChainUsingBlock(linkBlock: @escaping ViperModuleLinkBlock) -> Void {
        self.linkBlock = linkBlock
        linkBlockWasSet = true
        tryPerformLink()
    }
    
    private func tryPerformLink() -> Void {
        if moduleInputWasSet && linkBlockWasSet {
            performLink()
        }
    }
    
    private func performLink() -> Void {
        if let linkBlockHandler = linkBlock {
            if let moduleOutput = linkBlockHandler(self.moduleInput) {
                self.moduleInput?.setModuleOutput(moduleOutput)
            }
        }
    }
}
