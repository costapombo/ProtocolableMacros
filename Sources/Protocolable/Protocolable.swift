// The Swift Programming Language
// https://docs.swift.org/swift-book



@attached(peer, names: suffixed(Protocol))
public macro Protocolable() = #externalMacro(module: "ProtocolableMacrosSource", type: "ProtocolableMacro")


@attached(peer)
public macro Protocolable(ignore: Bool) = #externalMacro(module: "ProtocolableMacrosSource", type: "ProtocolableOptionsMacro")

@attached(peer)
public macro Protocolable(decl: String) = #externalMacro(module: "ProtocolableMacrosSource", type: "ProtocolableOptionsMacro")
