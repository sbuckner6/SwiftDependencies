//
//  DependencyInjectionError.swift
//  SwiftDependencies
//
//  Copyright © 2020 Simon Buckner. All rights reserved.
//

///
/// Error type for Dependency Injection-related exceptions.
///
public enum DependencyInjectionError: LocalizedError {
    
    ///
    /// An attempt was made to provide a key that was not registered to the `ObjectGraph`.
    ///
    case UnregisteredKey(key: String)
    
    public var errorDescription: String? {
        switch self {
            case let .UnregisteredKey(key):
                return "Failed to inject dependency for key: \(key). Either confirm that \(key) inherits `Injectable`, or register its subclass or provider in your `RegisterDependenciesDelegate`."
            default:
                return localizedDescription
        }
    }
}
