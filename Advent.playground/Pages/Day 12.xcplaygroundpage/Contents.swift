import Foundation

struct Node: Hashable {
    var elevation: Int
    var height: Character
    var distance: Int?
    var visited = false
    var coordinate: SIMD2<Int>
}

private extension [[Node]] {
    func find(_ target: Character) -> SIMD2<Int>? {
        for row in self {
            for node in row where node.height == target {
                return node.coordinate
            }
        }
        return nil
    }
    subscript(coordinate: SIMD2<Int>) -> Element.Element {
        get { self[coordinate.y][coordinate.x] }
        set { self[coordinate.y][coordinate.x] = newValue }
    }
}

func total(input: String) -> (Int?, Int?) {
    func bfs(start: SIMD2<Int>, squares input: [[Node]]) -> Int? {
        var squares = input
        squares[start].distance = 0
        var queue = [squares[start]]
        let width = squares[0].count
        let height = squares.count
        let adjacent: [SIMD2<Int>] = [.init(x: 0, y: 1), .init(x: 0, y: -1), .init(x: 1, y: 0), .init(x: -1, y: 0)]
        while !queue.isEmpty {
            let current = queue.removeFirst()
            if current.height == "E" { return current.distance }
            adjacent.forEach { Δ in
                let index = current.coordinate &+ Δ
                guard (0..<width).contains(index.x), (0..<height).contains(index.y) else { return }
                guard squares[index].elevation - current.elevation <= 1 else { return }
                guard squares[index].distance == nil else { return }
                squares[index].distance = current.distance.map {$0 + 1}
                queue.append(squares[index])
            }
        }
        return nil
    }
    let squares = sequence(state: Scanner(string: input)) { scanner in
        scanner.charactersToBeSkipped = .letters.inverted
        return scanner.scanUpToCharacters(from:.newlines)
    }
        .enumerated()
        .map { y, line in
            line.enumerated().map { x, character -> Node in
                let elevation = character == "S" ? 0 : character == "E" ? 25 : Int(character.asciiValue ?? 0) - 97
                return Node(elevation: elevation, height: character, coordinate: .init(x: x,y: y))
            }
        }
    let start = squares.find("S")!
    let part1 = bfs(start: start, squares: squares)
    let part2 = squares.lazy
        .flatMap { row in row.filter { $0.elevation == 0 } }
        .compactMap { start in
            bfs(start: start.coordinate, squares: squares)
        }
        .min()
    return (part1, part2)
}

let (part1, part2) = (total(input: makeInput()))
print(part1!, part2!)
//481 480
