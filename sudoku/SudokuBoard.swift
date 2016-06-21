//
//  SudokuBoard.swift - Setup for the main game board
//  sudoku
//
//  Created by Ario K on 2016-01-20.
//  Copyright © 2016 Ario K. All rights reserved.
//

import UIKit

protocol SudokuDelegates: class {
    func sudokuInputButtonSelected(sender: SudokuInputButton)
    func sudokuCellButtonSelected(sender: SudokuCellButton)
}

@IBDesignable class SudokuBoard: UIView {
    
    var sudokuBoard: UIView!
    var game: Sudoku!
    var delegate: SudokuDelegates?
    var nibName: String = "SudokuBoard"
    var sudokuCells: SudokuCellButton!
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Setup the view
        setup()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    func setup() {
        print("Setting up the sudoku board...")
        sudokuBoard = loadViewFromNib()
        sudokuBoard.frame = bounds
        // Singleton of game data
        game = Sudoku.game
        //sudokuBoard.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        let sudokuBoardLeftRightPadding: CGFloat = 10
        let boardWidth = UIScreen.mainScreen().bounds.width - (sudokuBoardLeftRightPadding*2)
        let dividerThickness: CGFloat = 1
        let sudokuBoardSize: CGFloat = boardWidth - 2 * dividerThickness
        let gridBoardSize: CGFloat = sudokuBoardSize / 3
        let dividerColor: UIColor = UIColor.init(red: 5/255, green: 99/255, blue: 125/255, alpha: 1)
        
        let cellPadding: CGFloat = 1
        let cellDimension: CGFloat = (gridBoardSize - 2 * cellPadding) / 3
        
        //Position of input numbers on the screen
        let inputNumberTopPadding: CGFloat = 50
        let inputNumberYPosition = boardWidth + inputNumberTopPadding
        
        // Line segments
        let dividerOneFrame = CGRectMake(sudokuBoardLeftRightPadding + gridBoardSize, 0, dividerThickness, boardWidth)
        let dividerTwoFrame = CGRectMake(sudokuBoardLeftRightPadding + gridBoardSize * 2 + dividerThickness, 0, dividerThickness, boardWidth)
        let dividerThreeFrame = CGRectMake(sudokuBoardLeftRightPadding, gridBoardSize, boardWidth, dividerThickness)
        let dividerFourFrame = CGRectMake(sudokuBoardLeftRightPadding, gridBoardSize * 2 + dividerThickness, boardWidth, dividerThickness)
        
        //Create line UIViews to depict 3x3 grid division
        let dividerOne = UIView(frame: dividerOneFrame)
        let dividerTwo = UIView(frame: dividerTwoFrame)
        let dividerThree = UIView(frame: dividerThreeFrame)
        let dividerFour = UIView(frame: dividerFourFrame)
        
        //Set the color
        dividerOne.backgroundColor = dividerColor
        dividerTwo.backgroundColor = dividerColor
        dividerThree.backgroundColor = dividerColor
        dividerFour.backgroundColor = dividerColor
        
        //Add UIViews to subview
        addSubview(sudokuBoard)
        sudokuBoard.addSubview(dividerOne)
        sudokuBoard.addSubview(dividerTwo)
        sudokuBoard.addSubview(dividerThree)
        sudokuBoard.addSubview(dividerFour)
        
        //Populate/create elements
        for row in 0...8 {
            let xPos = CGFloat(row) * cellDimension + CGFloat(row) * cellPadding + sudokuBoardLeftRightPadding
            
            //create buttons
            let inputNumbers = SudokuInputButton(frame: CGRectMake(xPos, inputNumberYPosition, cellDimension, cellDimension), number: row + 1)
            //set up event handler
            inputNumbers.addTarget(self.delegate, action: "sudokuInputButtonSelected:", forControlEvents: UIControlEvents.TouchUpInside)
            //add to subview
            sudokuBoard.addSubview(inputNumbers)
            
            for column in 0...8 {
                let yPos = CGFloat(column) * cellDimension + CGFloat(column) * cellPadding
                
                //create sudoku grid
                sudokuCells = SudokuCellButton(frame: CGRectMake(xPos, yPos, cellDimension, cellDimension))
                //populate the board with problem
                sudokuCells.sudokuCell = game.main_puzzle[column][row]
                //set up event handler
                sudokuCells.addTarget(self.delegate, action: "sudokuCellButtonSelected:", forControlEvents: UIControlEvents.TouchUpInside)
                //add to subview
                sudokuBoard.addSubview(sudokuCells)
            }
        }
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    

}
