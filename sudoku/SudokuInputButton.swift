//
//  SudokuInputButton.swift
//  sudoku
//
//  Created by Ario K on 2016-01-20.
//  Copyright © 2016 Ario K. All rights reserved.
//

import UIKit

class SudokuInputButton: UIButton {

        let number: Int
        
        init(frame: CGRect, number: Int) {
            self.number = number
            super.init(frame: frame)
            self.backgroundColor = UIColor.init(red: 5/255, green: 99/255, blue: 125/255, alpha: 1)
            self.setTitle(String(self.number), forState: UIControlState.Normal)
            self.setTitleColor(UIColor.init(red: 239/255, green: 236/255, blue: 206/255, alpha: 1), forState: .Normal)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

}
