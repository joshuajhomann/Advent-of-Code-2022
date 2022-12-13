/*
 --- Day 12: Hill Climbing Algorithm ---

 You try contacting the Elves using your handheld device, but the river you're following must be too low to get a decent signal.

 You ask the device for a heightmap of the surrounding area (your puzzle input). The heightmap shows the local area from above broken into a grid; the elevation of each square of the grid is given by a single lowercase letter, where a is the lowest elevation, b is the next-lowest, and so on up to the highest elevation, z.

 Also included on the heightmap are marks for your current position (S) and the location that should get the best signal (E). Your current position (S) has elevation a, and the location that should get the best signal (E) has elevation z.

 You'd like to reach E, but to save energy, you should do it in as few steps as possible. During each step, you can move exactly one square up, down, left, or right. To avoid needing to get out your climbing gear, the elevation of the destination square can be at most one higher than the elevation of your current square; that is, if your current elevation is m, you could step to elevation n, but not to elevation o. (This also means that the elevation of the destination square can be much lower than the elevation of your current square.)

 For example:

 Sabqponm
 abcryxxl
 accszExk
 acctuvwj
 abdefghi
 Here, you start in the top-left corner; your goal is near the middle. You could start by moving down or right, but eventually you'll need to head toward the e at the bottom. From there, you can spiral around to the goal:

 v..v<<<<
 >v.vv<<^
 .>vv>E^^
 ..v>>>^^
 ..>>>>>^
 In the above diagram, the symbols indicate whether the path exits each square moving up (^), down (v), left (<), or right (>). The location that should get the best signal is still E, and . marks unvisited squares.

 This path reaches the goal in 31 steps, the fewest possible.

 What is the fewest steps required to move from your current position to the location that should get the best signal?

 Your puzzle answer was 481.

 --- Part Two ---

 As you walk up the hill, you suspect that the Elves will want to turn this into a hiking trail. The beginning isn't very scenic, though; perhaps you can find a better starting point.

 To maximize exercise while hiking, the trail should start as low as possible: elevation a. The goal is still the square marked E. However, the trail should still be direct, taking the fewest steps to reach its goal. So, you'll need to find the shortest path from any square at elevation a to the square marked E.

 Again consider the example from above:

 Sabqponm
 abcryxxl
 accszExk
 acctuvwj
 abdefghi
 Now, there are six choices for starting position (five marked a, plus the square marked S that counts as being at elevation a). If you start at the bottom-left square, you can reach the goal most quickly:

 ...v<<<<
 ...vv<<^
 ...v>E^^
 .>v>>>^^
 >^>>>>>^
 This path reaches the goal in only 29 steps, the fewest possible.

 What is the fewest steps required to move starting from any square with elevation a to the location that should get the best signal?

 Your puzzle answer was 480.

 Both parts of this puzzle are complete! They provide two gold stars: **
 */
import Foundation

struct Node: Hashable {
    var elevation: Int
    var height: Character
    var coordinate: SIMD2<Int>
}

private extension [[Node]] {
    subscript(coordinate: SIMD2<Int>) -> Element.Element {
        get { self[coordinate.y][coordinate.x] }
        set { self[coordinate.y][coordinate.x] = newValue }
    }
}

func total(input: String) -> (Int?, Int?) {
    func bfs(start: SIMD2<Int>, squares: [[Node]]) -> Int? {
        var distance: [Node: Int] = [squares[start]: 0]
        var queue = [squares[start]]
        let width = squares[0].count
        let height = squares.count
        let adjacent: [SIMD2<Int>] = [.init(x: 0, y: 1), .init(x: 0, y: -1), .init(x: 1, y: 0), .init(x: -1, y: 0)]
        while !queue.isEmpty {
            let current = queue.removeFirst()
            if current.height == "E" { return distance[current] }
            queue.append(contentsOf: adjacent.compactMap { Δ -> Node? in
                let index = current.coordinate &+ Δ
                guard (0..<width).contains(index.x), (0..<height).contains(index.y) else { return nil }
                guard squares[index].elevation - current.elevation <= 1 else { return nil }
                guard distance[squares[index]] == nil else { return nil }
                distance[squares[index]] = distance[current].map {$0 + 1}
                return squares[index]
            })
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
    let start = squares.lazy.flatMap { $0.map { $0 }}.first { $0.height == "S" }!.coordinate
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
