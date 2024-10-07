import ProtocolableMacros

let a = 17
let b = 25


@Protocolable
class SomeService {
	private var yolo: String = ""
	var s: String { "Hello, World!" }
	let a: String = "as"
	func sss() {}

	@Protocolable(ignore: false)
	private(set) var prv: Int = 0
}





