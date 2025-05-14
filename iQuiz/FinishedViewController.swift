//
//  FinishedViewController.swift
//  iQuiz
//
//  Created by Mor Vered on 5/14/25.
//

//

import UIKit

class FinishedViewController: UIViewController {
    var correctCount: Int = 0
        var totalQuestions: Int = 0

        @IBOutlet weak var summary: UILabel!
        @IBOutlet weak var score: UILabel!

        override func viewDidLoad() {
            super.viewDidLoad()

            score.text = "You got \(correctCount) out of \(totalQuestions) correct."

            switch Double(correctCount) / Double(totalQuestions) {
            case 1.0:
                summary.text = "🎉 Perfect!"
            case 0.7...0.99:
                summary.text = "👍 Almost!"
            default:
                summary.text = "💪 Keep practicing!"
            }
        }

        @IBAction func backToMainTapped(_ sender: UIButton) {
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
