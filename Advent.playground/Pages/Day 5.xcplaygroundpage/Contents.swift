import Foundation

func applyMoves(to input: String, shouldReverse: Bool) -> String {
    let scanner = Scanner(string: makeInput())
    let columns = sequence(state: scanner) { scanner -> String? in
        scanner.charactersToBeSkipped = .newlines
        return scanner.scanUpToCharacters(from: .newlines).flatMap { $0 == " 1   2   3   4   5   6   7   8   9" ? nil : $0 }
    }
        .flatMap { line in
            line
                .enumerated()
                .filter { $1.unicodeScalars.first.map(CharacterSet.uppercaseLetters.contains) ?? false }
                .reduce(into: [(Int, Character)]()) { accumulated, next in
                    accumulated.append((column: (next.offset - 1) / 4, value: next.element))
                }
        }
        .reversed()
        .reduce(into: [[Character]](repeating: [], count: 9)) { columns, box in
            columns[box.column].append(box.value)
        }
    return sequence(state: scanner) { scanner -> (quantity: Int, from: Int, to: Int)? in
        scanner.charactersToBeSkipped = .decimalDigits.inverted
        guard let quantity = scanner.scanInt(),
              let from = scanner.scanInt().map({ $0 - 1}),
              let to = scanner.scanInt().map({ $0 - 1}) else {
            return nil
        }
        return (quantity: quantity, from: from, to: to)
    }
    .reduce(into: columns) { columns, move in
        let transfer = shouldReverse
            ? columns[move.from].suffix(move.quantity).reversed()
            : columns[move.from].suffix(move.quantity)
        columns[move.to].append(contentsOf: transfer)
        columns[move.from].removeLast(move.quantity)
    }
    .map { $0.last.map(String.init(describing:)) ?? " " }
    .joined()
}

let Σ = applyMoves(to: makeInput(), shouldReverse: true)
print(Σ)
//VPCDMSLWJ

let Σ2 = applyMoves(to: makeInput(), shouldReverse: false)

print(Σ2)
//TPWCGNCCG
