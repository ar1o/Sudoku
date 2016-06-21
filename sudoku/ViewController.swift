//
//  ViewController.swift - This is the main ViewController
//  sudoku
//
//  Created by Ario K on 2016-01-20.


import UIKit


class ViewController: UIViewController, SudokuDelegates {
    
    var sudokuBoard: SudokuBoard!
    var game: Sudoku!
    var currentSelectedCell: SudokuCellButton?
    var validCurrentSelectedCell: Int?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.game = Sudoku.game
    }

    @IBAction func resetNow(sender: AnyObject) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func newGameButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("segue2", sender: nil)
    }
 
    @IBAction func startButtonPressed(sender: AnyObject) {
        // Show that it is doing work
        self.activityIndicator.startAnimating()
        // This is the background thread
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // process sudoku game things
            self.game.newSudokuGamePuzzle()
            dispatch_async(dispatch_get_main_queue()) {
                // Do UI things
                self.performSegueWithIdentifier("segue", sender: nil)
            }
        }
    }
    
    func sudokuInputButtonSelected(sender: SudokuInputButton) {
        if let currentSelectedCell = currentSelectedCell {
            // Only allow sudoku element to be filled with valid number
            if !currentSelectedCell.givenCell! && sender.number == validCurrentSelectedCell {
                game.updateGivenSolutionCount()
                // Winner?
                if(game.getGivenSolutionCount() == 81) {
                    // create the alert
                    let alert = UIAlertController(title: "Sudoku", message: "Congrats! You won!", preferredStyle: UIAlertControllerStyle.Alert)
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    // show the alert
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                if let currentUserAnswer = currentSelectedCell.value {
                    if (currentUserAnswer == sender.number) {
                        currentSelectedCell.value = .None
                    } else {
                        currentSelectedCell.value = sender.number
                    }
                } else {
                    currentSelectedCell.value = sender.number
                }
            }
        }
        print("input selected", (sender.number))
        
    }

    
    func sudokuCellButtonSelected(sender: SudokuCellButton) {
        currentSelectedCell?.layer.borderWidth = 0
        currentSelectedCell = sender
        currentSelectedCell?.layer.borderWidth = 2
        validCurrentSelectedCell = sender.sudokuCell?.number
        print("CurrentSelectedCell value", validCurrentSelectedCell)
        
    }
    


}


