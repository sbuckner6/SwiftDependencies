//
//  Inject.swift
//  SwiftDependencies
//
//  Copyright © 2020 Simon Buckner. All rights reserved.
//

///
/// `PropertyWrapper` used to indicate a property that will be injected by the `ObjectGraph`.
///
@propertyWrapper
public struct Inject<T> {
        
    public init() {}

    public var wrappedValue: T {
        get {
            do {
                return try ObjectGraph.default.provide(T.self) as! T
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}

