//
//  Injectable.swift
//  SwiftDependencies
//
//  Copyright © 2020 Simon Buckner. All rights reserved.
//

///
/// Protocol for objects that can be injected into the `ObjectGraph` for future provision.
/// All `Injectables` must have an `init()` with no arguments.
///
public protocol Injectable {
    
    init()
    
    ///
    /// Provide an instance of `T: Injectable`
    ///
    ///  - returns: An instance of `T: Injectable`. By default, it will make an empty `init()` call with no arguments.
    ///
    static func provide() -> Self
    
    ///
    /// Remove this class from the `ObjectGraph`.
    ///
    func release()
}

extension Injectable {
    
    public static func provide() -> Self {
        return Self()
    }
    
    public func release() {
        ObjectGraph.default._release(Self.self)
    }
}
