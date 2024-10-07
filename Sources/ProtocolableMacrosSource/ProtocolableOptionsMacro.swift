//
//  ProtocolableOptionsMacro.swift
//  ProtocolableMacros
//
//  Created by Pedro Costa on 07/10/2024.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct ProtocolableOptionsMacro: PeerMacro {
	public static func expansion(
		of node: SwiftSyntax.AttributeSyntax,
		providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
		in context: some SwiftSyntaxMacros.MacroExpansionContext
	) throws -> [SwiftSyntax.DeclSyntax] {
		return []
	}



	internal static func shouldIgnore(attribute: SwiftSyntax.AttributeSyntax) -> Bool {
		guard attribute.attributeName.trimmedDescription == MACRO_NAME else { return false } // ignore attributes not related to this macro
		let arguments = attribute.arguments?.as(LabeledExprListSyntax.self)
		return arguments?.first?.label?.text == "ignore"
	}

	// Returns declaration if needed
	internal static func replcaceDeclaration(attribute: SwiftSyntax.AttributeSyntax) throws -> DeclSyntax? {
		guard attribute.attributeName.trimmedDescription == MACRO_NAME else { return nil } // ignore attributes not related to this macro
		guard let argument = attribute.arguments?.as(LabeledExprListSyntax.self)?.first(where: { $0.label?.text == "decl" }) else { return nil }
		guard let parameter = argument.expression.as(StringLiteralExprSyntax.self)?.segments.first?.as(StringSegmentSyntax.self) else {
			throw ErrorsDiagnostic.invalidArgument
		}

		return DeclSyntax(stringLiteral: parameter.content.text)
	}

}
