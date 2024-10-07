//
//  ErrorsDiagnostic.swift
//  ProtocolableMacros
//
//  Created by Pedro Costa on 07/10/2024.
//

import SwiftDiagnostics

enum ErrorsDiagnostic: String, DiagnosticMessage, Error {

	case onlyClasses

	case invalidArgument

	var severity: DiagnosticSeverity { .error }

	var message: String {
		switch self {
			case .onlyClasses:
				"@Protocolable can only be applied to 'class'"

			case .invalidArgument:
				"Invalid argument"
		}
	}

	var diagnosticID: MessageID {
		MessageID(domain: "protocolable", id: rawValue)
	}
}
