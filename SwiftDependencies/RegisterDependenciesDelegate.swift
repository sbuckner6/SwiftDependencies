//
//  RegisterDependenciesDelegate.swift
//  SwiftDependencies
//
//  Copyright © 2020 Simon Buckner. All rights reserved.
//

///
/// Defines a protocol for registering Dependency Injection mappings to be used in your app.
///
public protocol RegisterDependenciesDelegate {
    
    ///
    /// Registers a class, maps it to an implementation that extends `Injectable`, and tells the `ObjectGraph` to use its own `init` function as the provider.
    ///
    ///  - parameters
    ///    - type: Any class.
    ///    - mapping: A class that extends `Injectable`.
    ///
    func registerTypeMapping<T: Injectable>(_ type: Any.Type, _ mapping: T.Type)
    
    ///
    /// Registers a class and delegates a `ProviderFunction` closure to provide an instance of its associated `Injectable` type when the registered class is requested.
    ///
    ///  - parameters
    ///    - type: Any class.
    ///    - providerFunction]: A `ProviderFunction` delegated to provide the requested instance.
    ///
    func registerProviderFunction(_ type: Any.Type, _ providerFunction: @escaping ProviderFunction)

    ///
    /// Delegates a `Provider` to provide an instance of its associated `Injectable` type when requested.
    ///
    ///  - parameters
    ///    - provider: A `ProviderDelegate` whose static `provide()` method returns an instance of an `Injectable`.
    ///
    func registerProviderDelegate<T: Injectable>(_ provider: ProviderDelegate<T>.Type)
    
    ///
    /// Preloads dependencies for specified types (as opposed to lazily loading them).
    ///
    ///  - parameters
    ///    - args: Any classes that have mapped dependencies.
    ///  - throws
    ///    - `DependencyInjectionError.UnregisteredKey`
    ///
    func preloadDependencies(_ args: Any.Type...) throws
    
    ///
    /// Clears all dependency mappings.
    ///
    func clearDependencies()
}

extension RegisterDependenciesDelegate {
    
    public func registerTypeMapping<T: Injectable>(_ type: Any.Type, _ mapping: T.Type) {
        ObjectGraph.default._register(type, mapping)
    }
    
    public func registerProviderFunction(_ type: Any.Type, _ providerFunction: @escaping ProviderFunction) {
        ObjectGraph.default._register(type, providerFunction)
    }
    
    public func registerProviderDelegate<T: Injectable>(_ type: Any.Type, _ provider: ProviderDelegate<T>.Type) {
        ObjectGraph.default._register(type, provider)
    }
    
    public func registerProviderDelegate<T: Injectable>(_ provider: ProviderDelegate<T>.Type) {
        ObjectGraph.default._register(nil, provider)
    }
    
    public func preloadDependencies(_ args: Any.Type...) throws {
        try args.forEach { t in
            try ObjectGraph.default._preload(t)
        }
    }
    
    public func clearDependencies() {
        ObjectGraph.default.clearAll()
    }
}

