import Foundation

public func makeInput() -> String {
    Bundle.main.url(forResource: "input", withExtension: "")
        .flatMap { try? Data(contentsOf:$0) }
        .flatMap { String(data: $0, encoding: .utf8) } ?? ""
}
