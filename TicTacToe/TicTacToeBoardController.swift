//
//  TicTacToeBoardController.swift
//  TicTacToe
//
//

import UIKit

enum GameBoardOptions {
    case Cross
    case Circle
    case None
    
    func image() -> UIImage? {
        switch self {
        case .Cross:
            return UIImage(named: "X")!
            
        case .Circle:
            return UIImage(named: "O")!
            
        case .None:
            return nil
        }
    }
    
    func text() -> String {
        switch self {
        case .Cross:
            return "X"
            
        case .Circle:
            return "O"
            
        case .None:
            return ""
        }
    }
}

enum State {
    case playing
    case won
    case tied
}

struct Player {
    var name: String
    var sign: GameBoardOptions
}

class TicTacToeBoardController: UIViewController {
    
    var playerOneWon = 0 {
        didSet {
            updateWinningCountViews()
        }
    }
    var playerTwoWon = 0 {
        didSet {
            updateWinningCountViews()
        }
    }
    var gameDraw = 0 {
        didSet {
            updateWinningCountViews()
        }
    }
    
    var isGameWon = false {
        didSet {
            updatePlayAgainButton()
        }
    }
    
    var totalMovesDone = 0 {
        didSet {
            updatePlayAgainButton()
        }
    }
    
    var isPlayer1Turn = false
    var isVsComputer = false
    var gridImages: [UIImageView] = []
    var gridButtons: [UIButton] = []
    
    var player1 = Player(name: "Player 1", sign:  .Cross)
    var player2 = Player(name: "Player 2", sign: .Circle)
    var gameBoard: [[GameBoardOptions]] = Array(repeating: Array(repeating: .None, count: 3), count: 3)
    
    @IBOutlet weak var imageItem1: UIImageView!
    @IBOutlet weak var imageItem2: UIImageView!
    @IBOutlet weak var imageItem3: UIImageView!
    @IBOutlet weak var imageItem4: UIImageView!
    @IBOutlet weak var imageItem5: UIImageView!
    @IBOutlet weak var imageItem6: UIImageView!
    @IBOutlet weak var imageItem7: UIImageView!
    @IBOutlet weak var imageItem8: UIImageView!
    @IBOutlet weak var imageItem9: UIImageView!
    
    @IBOutlet weak var buttonItem1: UIButton!
    @IBOutlet weak var buttonItem2: UIButton!
    @IBOutlet weak var buttonItem3: UIButton!
    @IBOutlet weak var buttonItem4: UIButton!
    @IBOutlet weak var buttonItem5: UIButton!
    @IBOutlet weak var buttonItem6: UIButton!
    @IBOutlet weak var buttonItem7: UIButton!
    @IBOutlet weak var buttonItem8: UIButton!
    @IBOutlet weak var buttonItem9: UIButton!
    
    @IBOutlet weak var gameDescriptionLabel: UILabel!
    @IBOutlet weak var totalGamesPlayedLabel: UILabel!
    @IBOutlet weak var playerOneWonLabel: UILabel!
    @IBOutlet weak var playerTwoWonLabel: UILabel!
    @IBOutlet weak var drawLabel: UILabel!
    @IBOutlet weak var playerOneSignLabel: UILabel!
    @IBOutlet weak var playerTwoSignLabel: UILabel!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridImages = [imageItem1, imageItem2, imageItem3, imageItem4, imageItem5, imageItem6, imageItem7, imageItem8, imageItem9]
        gridButtons = [buttonItem1, buttonItem2, buttonItem3, buttonItem4, buttonItem5, buttonItem6, buttonItem7, buttonItem8, buttonItem9]
        
        resetGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        playerOneSignLabel.text = "\(player1.name): \(player1.sign.text())"
        playerTwoSignLabel.text = "\(player2.name): \(player2.sign.text())"
    }
    
    @IBAction
    func playAgainPressed(_ sender: UIButton) {
        playAgain()
    }
    
    @IBAction
    func backPressed(_ sender: UIButton) {
        guard (getTotalGames() > 0) || (totalMovesDone > 0) else {
            self.dismiss(animated: true)
            return
        }
        
        let alertController = UIAlertController(title: "Exit", message: "You will loose your progress.\nAre you sure you want to go back?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {_ in
            self.dismiss(animated: true)
        })
        alertController.addAction(yesAction)
        
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alertController.addAction(noAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction
    func resetPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Reset Game", message: "Resetting will clear all stats.\nAre you sure you want to reset the game?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {_ in
            self.resetGame()
        })
        alertController.addAction(yesAction)
        
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alertController.addAction(noAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction
    func gridButtonTapped(_ sender: UIButton) {
        
        let gameState = getGameState()
        
        if gameState == .tied {
            gameDraw += 1
            gameDescriptionLabel.text = "Game Draw"
        }
        
        guard gameState == .playing else { return }
        
        guard let index = gridButtons.firstIndex(of: sender) else { return }
        let row = index / 3
        let col = index % 3
        
        if gameBoard[row][col] == .None {
            gameBoard[row][col] = isPlayer1Turn ? player1.sign : player2.sign
            totalMovesDone += 1
            populateGrid()
            
            print("Row: \(row), Column: \(col) Tapped")
            
            if let winner = checkForWinner() {
                isGameWon = true
                if isPlayer1Turn {
                    playerOneWon += 1
                    
                } else {
                    playerTwoWon += 1
                }
                gameDescriptionLabel.text = "\(isPlayer1Turn ? player1.name : player2.name) has won"
                print("Winner: \(winner)")
                
            } else {
                isPlayer1Turn = !isPlayer1Turn
                gameDescriptionLabel.text = "\(isPlayer1Turn ? player1.name : player2.name)'s Turn"
            }
            
            guard (totalMovesDone < 9) else {
                gameDraw += 1
                gameDescriptionLabel.text = "Game Draw"
                return
            }
            
            if (isVsComputer) && (isGameWon == false) && (isPlayer1Turn == false) {
                if let index = getComputerMoveIndex() {
                    gameBoard[index.row][index.col] = player2.sign
                    
                } else {
                    let index = getRandomIndex()
                    gameBoard[index.row][index.col] = player2.sign
                }
                
                totalMovesDone += 1
                self.view.isUserInteractionEnabled = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[self] in
                    self.view.isUserInteractionEnabled = true
                    
                    self.populateGrid()
                    
                    if let winner = checkForWinner() {
                        isGameWon = true
                        if isPlayer1Turn {
                            playerOneWon += 1
                            
                        } else {
                            playerTwoWon += 1
                        }
                        gameDescriptionLabel.text = "\(isPlayer1Turn ? player1.name : player2.name) has won"
                        print("Winner: \(winner)")
                        
                    } else {
                        isPlayer1Turn = !isPlayer1Turn
                        gameDescriptionLabel.text = "\(isPlayer1Turn ? player1.name : player2.name)'s Turn"
                    }
                }
                
            }
        }
    }
    
    private func getGameState() -> State {
        if ((isGameWon == false) && (totalMovesDone >= 9)) {
            return .tied
        }
        
        if isGameWon {
            return .won
        }
        
        return .playing
    }
    
    private func updatePlayAgainButton() {
        let gameState = getGameState()
        playAgainButton.isHidden = (gameState == .playing)
    }
    
    private func getTotalGames() -> Int {
        return (playerOneWon + playerTwoWon + gameDraw)
    }
    
    private func updateWinningCountViews() {
        totalGamesPlayedLabel.text = "Total Games: \(getTotalGames())"
        playerOneWonLabel.text = "\(player1.name): \(playerOneWon)"
        playerTwoWonLabel.text = "\(player2.name): \(playerTwoWon)"
        drawLabel.text = "Draw: \(gameDraw)"
    }
    
    private func getRandomIndex() -> (row: Int, col: Int) {
        let row = Int.random(in: 0..<3)
        let column = Int.random(in: 0..<3)
        
        if gameBoard[row][column] == .None {
            return (row, column)
            
        } else {
            return getRandomIndex()
        }
    }
    
    private func resetGame() {
        playerOneWon = 0
        playerTwoWon = 0
        gameDraw = 0
        totalMovesDone = 0
        isGameWon = false
        gameBoard = Array(repeating: Array(repeating: .None, count: 3), count: 3)
        isPlayer1Turn = true
        gameDescriptionLabel.text = "\(player1.name)'s Turn"
        resetBorders()
        populateGrid()
    }
    
    private func playAgain() {
        totalMovesDone = 0
        isGameWon = false
        gameBoard = Array(repeating: Array(repeating: .None, count: 3), count: 3)
        isPlayer1Turn = true
        gameDescriptionLabel.text = "\(player1.name)'s Turn"
        resetBorders()
        populateGrid()
    }
    
    private func resetBorders() {
        gridButtons[0].layer.borderColor = UIColor.clear.cgColor
        gridButtons[1].layer.borderColor = UIColor.clear.cgColor
        gridButtons[2].layer.borderColor = UIColor.clear.cgColor
        gridButtons[3].layer.borderColor = UIColor.clear.cgColor
        gridButtons[4].layer.borderColor = UIColor.clear.cgColor
        gridButtons[5].layer.borderColor = UIColor.clear.cgColor
        gridButtons[6].layer.borderColor = UIColor.clear.cgColor
        gridButtons[7].layer.borderColor = UIColor.clear.cgColor
        gridButtons[8].layer.borderColor = UIColor.clear.cgColor
        
        gridButtons[0].layer.borderWidth = 2.0
        gridButtons[1].layer.borderWidth = 2.0
        gridButtons[2].layer.borderWidth = 2.0
        gridButtons[3].layer.borderWidth = 2.0
        gridButtons[4].layer.borderWidth = 2.0
        gridButtons[5].layer.borderWidth = 2.0
        gridButtons[6].layer.borderWidth = 2.0
        gridButtons[7].layer.borderWidth = 2.0
        gridButtons[8].layer.borderWidth = 2.0
        
    }
    
    private func populateGrid() {
        gridImages[0].image = gameBoard[0][0].image()
        gridImages[1].image = gameBoard[0][1].image()
        gridImages[2].image = gameBoard[0][2].image()
        gridImages[3].image = gameBoard[1][0].image()
        gridImages[4].image = gameBoard[1][1].image()
        gridImages[5].image = gameBoard[1][2].image()
        gridImages[6].image = gameBoard[2][0].image()
        gridImages[7].image = gameBoard[2][1].image()
        gridImages[8].image = gameBoard[2][2].image()
    }
    
    func getComputerMoveIndex() -> (row: Int, col: Int)? {
        var playerSign: GameBoardOptions = .None
        
        for move in 0..<2 {
            //Comment: need to check for computer's sign first. If computer's combination is winning, prioritize that and check for computer index to make it win in the first loop. In the second loop, it means there is no computer winning combination so check index for player winning combination so that computer can block the user at that index
            if move == 0 {
                playerSign = player2.sign
            } else {
                playerSign = player1.sign
            }
            
            for row in 0..<3 {
                if gameBoard[row][0] == playerSign && gameBoard[row][1] == playerSign && gameBoard[row][2] == .None {
                    return (row, 2)
                }
                if gameBoard[row][0] == playerSign && gameBoard[row][2] == playerSign && gameBoard[row][1] == .None {
                    return (row, 1)
                }
                if gameBoard[row][1] == playerSign && gameBoard[row][2] == playerSign && gameBoard[row][0] == .None {
                    return (row, 0)
                }
            }
            
            // Check columns
            for col in 0..<3 {
                if gameBoard[0][col] == playerSign && gameBoard[1][col] == playerSign && gameBoard[2][col] == .None {
                    return (2, col)
                }
                if gameBoard[0][col] == playerSign && gameBoard[2][col] == playerSign && gameBoard[1][col] == .None {
                    return (1, col)
                }
                if gameBoard[1][col] == playerSign && gameBoard[2][col] == playerSign && gameBoard[0][col] == .None {
                    return (0, col)
                }
            }
            
            // Check diagonals
            if gameBoard[0][0] == playerSign && gameBoard[1][1] == playerSign && gameBoard[2][2] == .None {
                return (2, 2)
            }
            if gameBoard[0][0] == playerSign && gameBoard[2][2] == playerSign && gameBoard[1][1] == .None {
                return (1, 1)
            }
            if gameBoard[1][1] == playerSign && gameBoard[2][2] == playerSign && gameBoard[0][0] == .None {
                return (0, 0)
            }
            if gameBoard[0][2] == playerSign && gameBoard[1][1] == playerSign && gameBoard[2][0] == .None {
                return (2, 0)
            }
            if gameBoard[0][2] == playerSign && gameBoard[2][0] == playerSign && gameBoard[1][1] == .None {
                return (1, 1)
            }
            if gameBoard[1][1] == playerSign && gameBoard[2][0] == playerSign && gameBoard[0][2] == .None {
                return (0, 2)
            }
        }
        return nil
    }
    
    func checkForWinner() -> GameBoardOptions? {
        
        for i in 0..<3 {
            // Rows
            if gameBoard[i][0] != .None && gameBoard[i][0] == gameBoard[i][1] && gameBoard[i][1] == gameBoard[i][2] {
                gridButtons[(i*3)].layer.borderColor = UIColor.red.cgColor
                gridButtons[(i*3) + 1].layer.borderColor = UIColor.red.cgColor
                gridButtons[(i*3) + 2].layer.borderColor = UIColor.red.cgColor
                
                return gameBoard[i][0]
            }
            // Columns
            if gameBoard[0][i] != .None && gameBoard[0][i] == gameBoard[1][i] && gameBoard[1][i] == gameBoard[2][i] {
                gridButtons[i].layer.borderColor = UIColor.red.cgColor
                gridButtons[(1*3) + i].layer.borderColor = UIColor.red.cgColor
                gridButtons[(2*3) + i].layer.borderColor = UIColor.red.cgColor
                
                return gameBoard[0][i]
            }
        }
        // Diagonals
        if gameBoard[0][0] != .None && gameBoard[0][0] == gameBoard[1][1] && gameBoard[1][1] == gameBoard[2][2] {
            gridButtons[0].layer.borderColor = UIColor.red.cgColor
            gridButtons[(1*3) + 1].layer.borderColor = UIColor.red.cgColor
            gridButtons[(2*3) + 2].layer.borderColor = UIColor.red.cgColor
            
            return gameBoard[0][0]
        }
        if gameBoard[0][2] != .None && gameBoard[0][2] == gameBoard[1][1] && gameBoard[1][1] == gameBoard[2][0] {
            gridButtons[2].layer.borderColor = UIColor.red.cgColor
            gridButtons[(1*3) + 1].layer.borderColor = UIColor.red.cgColor
            gridButtons[(2*3) + 0].layer.borderColor = UIColor.red.cgColor
            
            return gameBoard[0][2]
        }
        
        return nil
    }
}
