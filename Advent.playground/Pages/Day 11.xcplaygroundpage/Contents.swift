import Foundation

func monkeyBusiness(from input: String, rounds: Int, divideWorry: Bool) -> Int {
    struct Monkey {
        var items: [Int]
        var operation: (Int) -> Int
        var donorIndex: (Int) -> Int
        var inspected = 0
        var divisor: Int
    }
    var monkeys = Array(sequence(state: Scanner(string: input)) { scanner -> Monkey? in
        scanner.charactersToBeSkipped = .newlines
        let _ = scanner.scanUpToCharacters(from: .newlines)
        let items = scanner.scanUpToCharacters(from: .newlines).map { string in
            let scanner = Scanner(string: string)
            scanner.charactersToBeSkipped = .decimalDigits.inverted
            return sequence(state: scanner) { $0.scanInt() }.map {$0}
        }
        let op = scanner.scanUpToCharacters(from: .newlines).map { String($0.dropFirst(18)).split(separator: " ")}
        scanner.charactersToBeSkipped = .decimalDigits.inverted
        let divisor = scanner.scanInt()
        let left = scanner.scanInt()
        let right = scanner.scanInt()
        guard let items, let op, let divisor, let left, let right else { return nil }
        return Monkey(
            items: items,
            operation: { old in
                let lhs = Int(op[0]) ?? old
                let rhs = Int(op[2]) ?? old
                return op[1] == "+" ? lhs + rhs : lhs * rhs
            },
            donorIndex:  { $0.isMultiple(of: divisor) ? left : right },
            divisor: divisor
        )
    })

    let gcd = monkeys.map(\.divisor).reduce(1, *)
    let divisor = divideWorry ? 3 : 1
    let totals = (0..<rounds * monkeys.count).reduce(into: monkeys) { monkeys, turn in
        let index = turn % monkeys.count
        monkeys[index].items.forEach { item in
            let worry = monkeys[index].operation(item) % gcd / divisor
            let donor = monkeys[index].donorIndex(worry)
            monkeys[donor].items.append(worry)
        }
        monkeys[index].inspected += monkeys[index].items.count
        monkeys[index].items.removeAll(keepingCapacity: true)
    }
        .map(\.inspected)
        .sorted(by: >)
    return totals[0] * totals[1]
}

print(monkeyBusiness(from: makeInput(), rounds: 20, divideWorry: true))
//110888
print(monkeyBusiness(from: makeInput(), rounds: 10000, divideWorry: false))
//25590400731

