//
//  TestHelpers.swift
//  SwiftDependenciesTests
//
//  Copyright © 2020 Simon Buckner. All rights reserved.
//

import SwiftDependencies

///
/// Base type to be mapped.
///
protocol BaseType {}

///
/// Implementation of `Injectable` and `BaseType`.
///
final class ImplType: Injectable, BaseType {
    init() {}
}

///
/// Testable implementation of `RegisterDependenciesDelegate`.
///
class TestRegisterDependenciesDelegate: RegisterDependenciesDelegate {}

///
/// Helper class that can show us what type `BaseType` was mapped to.
///
class DependencyValidator {
    @Inject var baseType: BaseType
    @Inject var implType: ImplType
    
    @discardableResult func getBaseType() -> BaseType {
        return baseType
    }
    
    @discardableResult func getImplType() -> ImplType {
        return implType
    }
}

///
/// `ProviderDelegate` implementation for implicit mapping.
///
class ImplProviderType: ProviderDelegate<ImplType> {}
