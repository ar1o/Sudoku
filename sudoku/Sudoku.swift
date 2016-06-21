
//  Sudoku.swift - Handle sudoku processing
//  sudoku
//
//  Created by Ario K on 2016-01-22.
//  Copyright © 2016 Ario K. All rights reserved.
//

import Foundation

struct SudokuCell {
    var number: Int
    let given: Bool
}

class Sudoku {
    // Make this a singleton since we only need one instance throughout the app
    static let game = Sudoku()
    // For grabbing random sudoku puzzle from .db
    var random:Int!
    // Sudoku puzzle structured for solving
    var problem = [[Int]]()
    // Single array puzzle fun
    var problem_ = [Int]()
    // The main data structure for the view
    var main_puzzle = [[SudokuCell]]()
    // Keeps a count to determine solution complete
    var solutionCount:Int
    
    init() {
        random = Int(arc4random_uniform(1464))
        solutionCount = 0
        problem =
            [[0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0]]
        print("Configuring sudoku puzzle...")
        configureSudokuDB(random)
        configureDataStructure()

    }

    func getGivenSolutionCount() -> Int {
        return solutionCount
    }
    
    func updateGivenSolutionCount() {
        solutionCount += 1
    }
    
    //merged in the solved solution to main data structure
    func mergeSolution() {
        for row in 0..<problem.count {
            for col in 0..<problem[row].count {
               if main_puzzle[row][col].given == false {
                    main_puzzle[row][col].number = problem[row][col]
                }
                
            }
        }
    }
    
    // Configure the data structures for the UI and solving
    func configureDataStructure() {
        // create 9 rows
        let sudoku_row = [SudokuCell]()
        for var i = 0; i<9; i++ {
            main_puzzle.append(sudoku_row)
        }
        var number = 0
        for row in 0..<problem.count {
            for col in 0..<problem[row].count {
                if problem_[number] == 0 {
                    main_puzzle[row].append(SudokuCell(number: problem_[number], given: false))
                } else {
                    updateGivenSolutionCount()
                    main_puzzle[row].append(SudokuCell(number: problem_[number], given: true))
                }
                problem[row][col] = problem_[number]
                number++
            }
        }
    }
    
    // New sudoku puzzle creation
    func newSudokuGamePuzzle() {
        random = Int(arc4random_uniform(1400))
        solutionCount = 0
        problem.removeAll()
        problem_.removeAll()
        main_puzzle.removeAll()
        problem = [
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0]
        ]
        configureSudokuDB(random)
        configureDataStructure()
        print("Solving the sudoku...")
        if solveSudoku() == true {
            print("Solved sudoku!");
            //Add to the main_puzzle
            mergeSolution()
        } else {
            print("Cannot solve")
        }
    }
    
    // Read from the .db file
    func configureSudokuDB(puzzle:Int) {
        print("Puzzle number: ",puzzle)
        let path = NSBundle.mainBundle().pathForResource("sudoku.db", ofType: "")
        do {
            if let data: NSString = try NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding) {
                // we have a sudoku problem now
                let sudokuData = data.componentsSeparatedByString("\n")
                for char in sudokuData[puzzle].characters {
                    if let number = Int(String(char)) {
                        problem_.append(number)
                    } else {
                        problem_.append(0)
                    }
                }
            }
        } catch {
            print("Error")
        }
    }
    
    // Solve sudoku puzzle
    func solveSudoku() -> Bool {
        var temp = determineUnknowns()
        if !temp.isEmpty {
            let row = temp[0]
            let col = temp[1]
            for var i = 1; i <= 9; i++ {
                if isSudokuCorrect(row, col: col, num: i) {
                    problem[row][col] = i
                    if solveSudoku() {
                        return true
                    }
                    problem[row][col] = 0
                }
            }
        } else {
            return true
        }
        return false
    }
    
    // Find out which index must be solved
    func determineUnknowns() -> [Int] {
        var temp = [Int]()
        for var row = 0; row < problem.count; row++ {
            for var col = 0; col < problem.count; col++ {
                if problem[row][col] == 0 {
                    temp = [row,col]
                    return temp
                }
            }
        }
        return temp
    }
    
    // Check for correctness
    func isSudokuCorrect(row:Int, col:Int, num:Int) -> Bool {
        return checkRow(row, col: col, num: num)
            && checkCol(row, col: col, num: num)
            && checkGrid(row, col: col, num: num)
    }
    
    func checkRow(row: Int, col: Int, num: Int) -> Bool {
        for var i = 0; i < problem.count; i++ {
            if (problem[row][i] == num) {
                return false
            }
        }
        return true
    }
    
    func checkCol(row: Int, col: Int, num: Int) -> Bool {
        for var i = 0; i < problem.count; i++ {
            if (problem[i][col] == num) {
                return false
            }
        }
        return true
    }
    
    func checkGrid(var row: Int, var col: Int, num: Int) -> Bool {
        row = row - (row % 3)
        col = col - (col % 3)
        for var i = 0; i < 3; i++ {
            for var j = 0; j < 3; j++ {
                if problem[i + row][j + col] == num {
                    return false
                }
            }
        }
        return true
    }

    
}