//
//  ProviderDelegate.swift
//  SwiftDependencies
//
//  Copyright © 2020 Simon Buckner. All rights reserved.
//

///
/// Generic class for handling custom `Injectable` instantiation.
///
open class ProviderDelegate<T: Injectable> {
    private var instance = ProviderDelegate<T>()
    
    ///
    /// Provide an instance of `T: Injectable`
    ///
    ///  - returns: An instance of `T: Injectable`. By default, it will make an empty `init()` call with no arguments.
    ///
    open class func provide() -> T {
        return T.provide()
    }
}
