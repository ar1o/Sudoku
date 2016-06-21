//
//  SudokuCellButton.swift
//  sudoku
//
//  Created by Ario K on 2016-01-20.
//  Copyright © 2016 Ario K. All rights reserved.
//

import UIKit

class SudokuCellButton: UIButton {

    // Create sudokuCell and set some parameters in the board immediately after
    var sudokuCell: SudokuCell? {
        didSet {
            //Set the numbers
            self.givenCell = sudokuCell!.given
            if self.givenCell! { //if the cell is part of the problem
                self.value = sudokuCell!.number
            } else { //leave blank
                self.value = .None
            }
            
            //Set the element color
            if let value = self.value {
                self.setTitle(String(value), forState: UIControlState.Normal)
                self.setTitleColor(UIColor.blackColor(), forState: .Normal)
            } else {
                self.setTitleColor(UIColor.init(red: 5/255, green: 99/255, blue: 125/255, alpha: 1), forState: .Normal)
            }
        }
    }

    var givenCell: Bool?
    
    // Change values
    var value: Int? {
        didSet {
            if let number = value {
                self.setTitle(String(number), forState: .Normal)
            } else {
                self.setTitle("", forState: .Normal)
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 230/255, green: 226/255, blue: 181/255, alpha: 1)
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.yellowColor().CGColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
