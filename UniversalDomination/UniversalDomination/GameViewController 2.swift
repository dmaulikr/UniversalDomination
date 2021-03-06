//
//  GameViewController.swift
//  UniversalDomination
//
//  Created by Pranay Jay Patel on 6/1/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController
{
    let numberOfPlanets = 10
    var currentPlayer = 3
    var planets = [Planet]()
    var players = [Player]()
    var imageList:[Int] = [0,1,2,3]
    var playerNames: [String] = ["name", "name", "name", "name"]
    var numTroops = 0
    var attackFlag = 0
    var addBool = true
    @IBOutlet var PlanetButtons: [UIButton]!
    @IBOutlet weak var Dice: UIImageView!
    @IBOutlet weak var troopCountLabel: UILabel!
    @IBOutlet weak var DoneButton: UIButton!
    @IBOutlet weak var Action: UIImageView!
    
    @IBOutlet var TurnShadow: [UIImageView]!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!

    //Player 1
    @IBOutlet weak var player1Image: UIImageView!
    @IBOutlet weak var player1Name: UILabel!
    @IBOutlet weak var player1Score: UILabel!
    
    //Player 2
    @IBOutlet weak var player2Image: UIImageView!
    @IBOutlet weak var player2Name: UILabel!
    @IBOutlet weak var player2Score: UILabel!
    
    //Player 3
    @IBOutlet weak var player3Image: UIImageView!
    @IBOutlet weak var player3Name: UILabel!
    @IBOutlet weak var player3Score: UILabel!
    
    //Player 4
    @IBOutlet weak var player4Image: UIImageView!
    @IBOutlet weak var player4Name: UILabel!
    @IBOutlet weak var player4Score: UILabel!
    
    @IBOutlet weak var startGame: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let scene = GameScene(size: view.bounds.size)
        
        // configure the view
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
        // add the planets
        for index in 1...numberOfPlanets
        {
            planets.append(Planet(bttn: PlanetButtons[index-1]))
        }
        
        // add the players
        for index in 0...3
        {
            if playerNames[index].isEmpty {
                playerNames[index] = "Player\(index + 1):"
            }
            players.append(Player(name: playerNames[index]))
        }
        
        for i in TurnShadow
        {
            i.isHidden = true
        }
        
        player1Name.text = playerNames[0]
        player1Score.text = String(players[0].score)
        player1Image.image = UIImage(named: "alien\(imageList[0])")!
        
        player2Name.text = playerNames[1]
        player2Score.text = String(players[1].score)
        player2Image.image = UIImage(named: "alien\(imageList[1])")!

        player3Name.text = playerNames[2]
        player3Score.text = String(players[2].score)
        player3Image.image = UIImage(named: "alien\(imageList[2])")!

        player4Name.text = playerNames[3]
        player4Score.text = String(players[3].score)
        player4Image.image = UIImage(named: "alien\(imageList[3])")!

    }
    
    // timer to control the turns
    var GameTimer = Timer()
    var ActionTimer = Timer()
    var initFort = true
    
    // 0 == fortify, 1 == attack, 2 == reinforce
    var currentAction = 0
    
    var numTurns = 0
    let totalTurns = 25 // make it a multiple of 12 + 1
    
    override func viewDidAppear(_ animated: Bool) {
        
        // controls the start of the game and the initial round of fortify
        GameTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(GameViewController.turn), userInfo: nil, repeats: true)
        
    }

    func initFortify() {
        
        startButton() // <--- starts the timer for a turn

        TurnShadow[currentPlayer].isHidden = true
        currentPlayer = (currentPlayer+1) % 4
        
        TurnShadow[currentPlayer].isHidden = false
        
        // enable or disable buttons
        for i in planets
        {
                if i.owner == nil
                {
                    // i.planetButton. <<-- do something with the planets without owners
                }
        }
        
        print("initfortify") //<<-- I was using this for debug
        
        if currentPlayer == 3 {
            initFort = false
        }
    
    }
    
    func turn() {
        
        startGame.isHidden = true
        
        if initFort == true {
            initFortify()
        }
        else {
            
            numTurns += 1
            
            if numTurns == totalTurns {
                GameTimer.invalidate()
                endGame()
            }

            
            // fortify
            if currentAction == 0 {
                
                TurnShadow[currentPlayer].isHidden = true
                currentPlayer = (currentPlayer+1) % 4
                
                TurnShadow[currentPlayer].isHidden = false
                
                currentAction = (currentAction+1) % 3
                
                print("fortify")
                startButton()
                Action.image = UIImage(named: "Fortify")
                
                // do any other preparation for fortify
            }
            else if currentAction == 1 {
                
                currentAction = (currentAction+1) % 3
                
                print("attack")
                startButton()
                Action.image = UIImage(named: "Attack")
                
                // do any other preparation for attack
            
            }
            else if currentAction == 2 {
                
                currentAction = (currentAction+1) % 3
                
                print("reinforce")
                startButton()
                Action.image = UIImage(named: "Reinforce")
                
                // do any other preparation for reinforce
            }
            
        }
        
    
    }
    
       
    func endGame()
    {
        // announce winner, end the game, and return to main menu
        
        print("endGame")
    }
    
    
    @IBAction func buttonClicked(_ sender: Any) {
        
        let button = sender as AnyObject
        
        if (currentAction == 0) {
            
            players[currentPlayer].fortify(player: players[currentPlayer], planet: planets[button.tag], numTroops: &numTroops)
        }
            
        else if (currentAction == 1) {
            
            players[currentPlayer].attack(attacker: planets[button.tag], defender: planets[button.tag], whatToDo: &attackFlag)
            
            attackFlag += 1 % 3
            
        }
            
        else if (currentAction == 2) {
            
            players[currentPlayer].reinforce(planet: planets[button.tag], numTroops: &numTroops, addBool: addBool)
        }
        
        troopCountLabel.text = String(numTroops)
    
    }
    
   
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return .landscapeLeft
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    @IBOutlet weak internal var countDownTimer: UILabel!
    
    var seconds = 0
    var timer = Timer()
    var timerIsOn = false
    
    func startButton()
    {
        //if timerIsOn == false {
            seconds = 10
            timerIsOn = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.updateTimer), userInfo: nil, repeats: true)
        //}
        
    }
   
    func endButton() {
        //seconds = 0
        countDownTimer.text = "\(seconds)"
        timerIsOn = false
        timer.invalidate()
    }

    func updateTimer() {
        
        //print(seconds) //<-- I was using this for debug
        
        // stops the timer from going negative
        if timerIsOn == true {
            seconds -= 1
            countDownTimer.text = "\(seconds)"
        }
        
        if seconds == 0 {
            endButton()
        }
    }

    @IBAction func DiceRoll(_ sender: UIButton) {
        let Number = arc4random_uniform(5) + 1
        Dice.image = UIImage(named: "Dice\(Number)")
        troopCountLabel.text = String(Number)
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when){
            let Number2 = arc4random_uniform(5) + 1
            self.Dice.image = UIImage(named: "Dice\(Number2)")
            let totalTroops = Number + Number2
            self.numTroops = Int(totalTroops)
            self.troopCountLabel.text = String(totalTroops)
        }
    }
    
    // this ends the visible timer but doesn't change the turn
    @IBAction func doneClicked(_ sender: Any) {
        endButton()
    }
}
