//
//  ObjectGraph.swift
//  SwiftDependencies
//
//  Copyright © 2020 Simon Buckner. All rights reserved.
//

///
/// This class keeps track of objects that have been created and stores them in memory for future reusability.
///
internal class ObjectGraph {
    private var _dependencies: [String: Injectable]
    private var _providers: [String: ProviderFunction]
    private var _queue: DispatchQueue
    
    internal static let `default` = ObjectGraph()
    
    private init() {
        self._dependencies = [String : Injectable]()
        self._providers = [String: ProviderFunction]()
        self._queue = DispatchQueue(label: NSUUID().uuidString)
    }
        
    ///
    /// Provides an instance of the requested type if it has been created. Otherwise, create one using the registered `ProviderFunction`, store it, and provide that instead.
    ///
    /// - parameters
    ///   - type: The type of the instance being requested.
    /// - throws: `DependencyInjectionError`
    /// - returns: An instance of the requested type.
    ///
    internal func provide(_ type: Any.Type) throws -> Injectable {
        let key = String(describing: type)
        if let result = try? _safeGetDependency(key) {
            return result
        } else if let provide = try? _safeGetProvider(key) {
            let result = provide()
            return _saveAndReturn(key, result)
        } else if let injectableType = type as? Injectable.Type {
            let result = injectableType.provide()
            return _saveAndReturn(key, result)
        } else {
            throw DependencyInjectionError.UnregisteredKey(key: key)
        }
    }
    
    ///
    /// Clears all dependencies and provider functions.
    ///
    internal func clearAll() {
        self._dependencies = [String : Injectable]()
        self._providers = [String: ProviderFunction]()
    }
    
    internal func _register(_ type: Any.Type, _ mapping: Injectable.Type) {
        let key = String(describing: type)
        _safeSetProvider(key, mapping.provide)
    }
    
    internal func _register(_ type: Any.Type, _ providerFunction: @escaping ProviderFunction) {
        let key = String(describing: type)
        _safeSetProvider(key, providerFunction)
    }
    
    internal func _register<T: Injectable>(_ type: Any.Type?, _ provider: ProviderDelegate<T>.Type) {
        let key = String(describing: (type ?? T.self))
        _safeSetProvider(key, provider.provide)
    }
    
    internal func _preload(_ type: Any.Type) throws {
        let key = String(describing: type)
        let provide: ProviderFunction
        if let provideFunction = try? _safeGetProvider(key) {
            provide = provideFunction
        } else if let injectableType = type as? Injectable.Type {
            provide = injectableType.provide
        } else {
            throw DependencyInjectionError.UnregisteredKey(key: key)
        }
        _safeSetDependency(key, provide())
    }
    
    internal func _release(_ type: Any.Type) {
        let key = String(describing: type)
        if let index = _dependencies.index(forKey: key) {
            _safeRemoveDependency(key, index)
        }
    }
    
    private func _saveAndReturn(_ key: String, _ value: Injectable) -> Injectable {
        _safeSetDependency(key, value)
        return value
    }
    
    private func _safeGetDependency(_ key: String) throws -> Injectable? {
        return _queue.sync {
            return self._dependencies[key]
        }
    }
    
    private func _safeSetDependency(_ key: String, _ value: Injectable) {
        _queue.async {
            self._dependencies[key] = value
        }
    }
    
    private func _safeGetProvider(_ key: String) throws -> ProviderFunction? {
        return _queue.sync {
            return self._providers[key]
        }
    }
    
    private func _safeSetProvider(_ key: String, _ value: @escaping ProviderFunction) {
        _queue.async {
            self._providers[key] = value
        }
    }
    
    private func _safeRemoveDependency(_ key: String, _ index: Dictionary<String, Injectable>.Index) {
        _queue.async {
            self._dependencies.remove(at: index)
        }
    }
}


