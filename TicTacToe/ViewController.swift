//
//  ViewController.swift
//  TicTacToe
//
//

import UIKit



class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let signs = ["X", "O"]
    var selectedSign: String?
    
    @IBOutlet weak var TwoPlayerButton: UIButton!
    @IBOutlet weak var vsComputerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TwoPlayerButton.layer.cornerRadius = 25
        TwoPlayerButton.layer.masksToBounds = true
        
        vsComputerButton.layer.cornerRadius = 25
        vsComputerButton.layer.masksToBounds = true
    }

    @IBAction
    func twoPlayerBtnAction(_ sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        if let gameVC = storyBoard.instantiateViewController(withIdentifier: "TicTacToeBoardController") as? TicTacToeBoardController {
            
            gameVC.modalPresentationStyle = .overFullScreen
            self.present(gameVC, animated: true)
        }
    }
    
    @IBAction
    func vsComputerBtnAction(_ sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        if let gameVC = storyBoard.instantiateViewController(withIdentifier: "TicTacToeBoardController") as? TicTacToeBoardController {
            
            gameVC.player2 = Player(name: "Computer", sign: .Circle)
            gameVC.isVsComputer = true
            gameVC.modalPresentationStyle = .overFullScreen
            self.present(gameVC, animated: true)
        }
    }
    
    func navigateToGame(withFirstAction: String, isForComputer: Bool) {
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        if let gameVC = storyBoard.instantiateViewController(withIdentifier: "TicTacToeBoardController") as? TicTacToeBoardController {
            
            gameVC.modalPresentationStyle = .overFullScreen
            self.present(gameVC, animated: true)
        }
    }
    
    // MARK: - UIPickerView DataSource and Delegate methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return signs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return signs[row]
    }
}

