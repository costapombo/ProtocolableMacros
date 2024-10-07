//
//  ProtocolableMacro.swift
//  ProtocolableMacros
//
//  Created by Pedro Costa on 07/10/2024.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics


let MACRO_NAME = "Protocolable"

public struct ProtocolableMacro: PeerMacro {

	public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
		guard let classSyntax = declaration.as(ClassDeclSyntax.self) else {
			let error = Diagnostic(
				node: node,
				message: ErrorsDiagnostic.onlyClasses
			)
			context.diagnose(error)
			return []
		}

		let name: String = classSyntax.name.text + "Protocol"
		var membersDecl: [DeclSyntaxProtocol] = []

	membersLoop:
		for member in classSyntax.memberBlock.members {
			// func
			if var funcDecl = member.decl.as(FunctionDeclSyntax.self) {
				// ignore private
				if funcDecl.modifiers.contains(where: { $0.name.text == "private" || $0.name.text == "fileprivate" }) {
					continue membersLoop
				}

				funcDecl.modifiers = []
				funcDecl.body = nil

				membersDecl.append(DeclSyntax(funcDecl.trimmed))
				continue membersLoop
			}


			// variables
			if var variableDecl = member.decl.as(VariableDeclSyntax.self) {

				// Check if the property has macro related configuration
				for attribute in variableDecl.attributes.compactMap({ $0.as(AttributeSyntax.self )}) {
					if ProtocolableOptionsMacro.shouldIgnore(attribute: attribute) {
						continue membersLoop
					}

					if let declaration = try ProtocolableOptionsMacro.replcaceDeclaration(attribute: attribute) {
						membersDecl.append(declaration)
						continue membersLoop
					}
				}

				var isPrivateSetter: Bool = variableDecl.bindingSpecifier.text == "let"

				// ignore private properties
				for modifier in variableDecl.modifiers {
					guard modifier.name.text == "private" || modifier.name.text == "fileprivate" else { continue }

					if modifier.detail?.detail.text == "set" {
						isPrivateSetter = true
						continue
					}

					continue membersLoop // ignore private members
				}

				if let accessorBlock = variableDecl.bindings.first?.accessorBlock?.accessors.as(CodeBlockItemListSyntax.self) {
					isPrivateSetter = true
				}

				variableDecl.modifiers = []
				variableDecl.bindingSpecifier = .keyword(.var, trailingTrivia: .space)

				if let binding = variableDecl.bindings.first {
					variableDecl.bindings = [
						PatternBindingSyntax(
							pattern:binding.pattern,
							typeAnnotation: binding.typeAnnotation
						)
					]
				}

				variableDecl.trailingTrivia = isPrivateSetter ? " { get }" : " { get set }"

				membersDecl.append(variableDecl)
				continue
			}
		}


		let members = MemberBlockSyntax(membersBuilder: { membersDecl })
		var protocolDec = ProtocolDeclSyntax(name: .stringSegment(name), memberBlock: members)
		protocolDec.modifiers = [ .init(name: "public") ]
		return [DeclSyntax(protocolDec)]
	}

}

@main
struct ProtocolablePlugin: CompilerPlugin {
	let providingMacros: [Macro.Type] = [
		ProtocolableMacro.self,
		ProtocolableOptionsMacro.self
	]
}
