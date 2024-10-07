//
//  ProtocolableTest.swift
//  ProtocolableMacro
//
//  Created by Pedro Costa on 07/10/2024.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import ProtocolableMacrosSource

let testMacros: [String: Macro.Type] = [
	"Protocolable": ProtocolableMacro.self,
]

final class ProtocolableTest: XCTestCase {

	func testSimple() throws {
		let input = """
		@Protocolable
		class DemoService {
			var somestring: String = "s"
			func test() {}
		}
		"""


		let output = """
		class DemoService {
			var somestring: String = "s"
			func test() {}
		}

		public protocol DemoServiceProtocol{
		    var somestring: String { get set }
		    func test()
		}
		"""

		assertMacroExpansion(input, expandedSource: output, macros: testMacros)
	}


	func testPrivateSetters() throws {
		let input = """
			@Protocolable
			class DemoService {
			    private(set) var somestring: String = "s"
			    let nosetter: String = ""
			    var nosetter2: Bool { true }
			}
		"""

		let output = """
			class DemoService {
			    private(set) var somestring: String = "s"
			    let nosetter: String = ""
			    var nosetter2: Bool { true }
			}

			public protocol DemoServiceProtocol{
			    var somestring: String { get }
			    var nosetter: String { get }
			    var nosetter2: Bool { get }
			}
		"""

		assertMacroExpansion(input, expandedSource: output, macros: testMacros)
	}

}
