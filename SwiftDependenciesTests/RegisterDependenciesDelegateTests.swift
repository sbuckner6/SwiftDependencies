//
//  RegisterDependenciesDelegateTests.swift
//  SwiftDependenciesTests
//
//  Copyright © 2020 Simon Buckner. All rights reserved.
//

import XCTest
@testable import SwiftDependencies

class RegisterDependenciesDelegateTests: XCTestCase {
    
    private var delegate: RegisterDependenciesDelegate!
    private var validator: DependencyValidator!

    override func setUpWithError() throws {
        delegate = TestRegisterDependenciesDelegate()
        validator = DependencyValidator()
    }

    override func tearDownWithError() throws {
        delegate.clearDependencies()
    }

    func testRegisterTypeMapping() throws {
        delegate.registerTypeMapping(BaseType.self, ImplType.self)
        if !(validator.getBaseType() is ImplType) {
            XCTFail()
        }
    }
    
    func testRegisterProviderFunction() throws {
        delegate.registerProviderFunction(BaseType.self) {
            return ImplType()
        }
        if !(validator.getBaseType() is ImplType) {
            XCTFail()
        }
    }
    
    func testRegisterProviderDelegate_withBaseType() throws {
        delegate.registerProviderDelegate(BaseType.self, ImplProviderType.self)
        if !(validator.getBaseType() is ImplType) {
            XCTFail()
        }
    }

    func testRegisterProviderDelegate_withoutBaseType() throws {
        delegate.registerProviderDelegate(ImplProviderType.self)
        validator.getImplType()
    }
}


