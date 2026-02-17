//
//  ViewController.swift
//  Dicee-iOS16
//
//  Created by Laszlo Szabo on 2/15/2026
//  My version of the Dice app with add ons
//Enhancments include: Animated dice, two additional dice, and finally, a tally count.
// Animations are made using UIImageView.AnimationImages, they are set to 6 faces (dice) and start/stop animating when needed.

//The duration is random for the spin, but its synced for all dice, I used double.random for duration, and dispatch queue async stops the animation after the random delay.
//The tally works by having an Int array for the 6 dice faces, faceIndex to increment and then print a summary, compact map used connect UIImageviews as an array and it ignores nill outlets which stop the images from being stored in the memory while the animations run


//

import UIKit

class ViewController: UIViewController {
    
    // Tracks if a roll is in progress
    private var isRolling = false

    // All 6 dice images
    private let diceImages: [UIImage] = [
        #imageLiteral(resourceName: "DiceOne"),
        #imageLiteral(resourceName: "DiceTwo"),
        #imageLiteral(resourceName: "DiceThree"),
        #imageLiteral(resourceName: "DiceFour"),
        #imageLiteral(resourceName: "DiceFive"),
        #imageLiteral(resourceName: "DiceSix")
    ]

    // Dice faces tally count 1-6
    private var faceCounts: [Int] = Array(repeating: 0, count: 6)

    // Prints a short tally to the console
    private func printTally() {
        let summary = faceCounts.enumerated().map { idx, count in
            return "\(idx + 1): \(count)"
        }.joined(separator: ", ")
        print("Tally => " + summary)
    }
    
    // Animates 4 dice, then stops on random faces
    private func rollDiceAnimated() {
        guard !isRolling else { return } // prevent overlapping rolls
        isRolling = true

        let totalDuration = Double.random(in: 0.6...1.3) // how long the dices spin for

        // Configures and starts the animations
        for die in diceImageViews {
            die.animationImages = diceImages // frames 1...6
            die.animationDuration = Double.random(in: 0.12...0.18) // speed for each die
            die.animationRepeatCount = 0 // loop until stopped
            die.startAnimating() // start spinning
        }

        // Pick final faces for each die (indices 0...5)
        let finalIndices: [Int] = diceImageViews.map { _ in Int.random(in: 0...5) }

        // Stop after the randomized duration
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) { [weak self] in
            guard let self = self else { return }

            // Clears the animations after stopping
            for die in self.diceImageViews {
                die.stopAnimating()
                die.animationImages = nil
            }

            // Updates console tally
            for (idx, die) in self.diceImageViews.enumerated() {
                let faceIndex = finalIndices[idx]
                die.image = self.diceImages[faceIndex]
                self.faceCounts[faceIndex] += 1 // update counts
            }

            self.printTally() // shows the counts
            self.isRolling = false
        }
    }
    
    @IBOutlet weak var diceImageView1: UIImageView!
    @IBOutlet weak var diceImageView2: UIImageView!
    
    @IBOutlet weak var diceImageView3: UIImageView?
    @IBOutlet weak var diceImageView4: UIImageView?

    // array for holding the four dices
    private var diceImageViews: [UIImageView] {
        return [diceImageView1, diceImageView2, diceImageView3, diceImageView4].compactMap { $0 }
    }
    
    @IBAction func rollButtonPressed(_ sender: UIButton) {
        rollDiceAnimated() // clicking the button spins the dice till they stop at random
    }
    
}
