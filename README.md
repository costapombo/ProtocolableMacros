# ProtocolableMacros


## Usage

```swift
@Protocolable
class DemoService {
  let id: String = "some"
  var name: String = "s"
  @Protocolable(ignore: true)
  var email: String?
  func test() {}
}

// Generated
public protocol DemoServiceProtocol {
  var id: String { get }
  var name: string { get set }
  func test()
}
```

## Ignore
