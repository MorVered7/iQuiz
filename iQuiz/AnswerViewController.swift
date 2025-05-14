//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Mor Vered on 5/13/25.
//


import UIKit

class AnswerViewController: UIViewController {
    var questionText: String!
    var correctAnswer: String!
    var wasCorrect: Bool?
    var quizTopic: ViewController.QuizTopic!
    var currentQuestionIndex: Int!
    var correctCount: Int!
    @IBOutlet weak var feedback: UILabel!
    @IBOutlet weak var answer: UILabel!
    @IBOutlet weak var question: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        question.text = questionText
        answer.text = "Correct Answer: \(correctAnswer ?? "N/A")"
        feedback.text = (wasCorrect == true) ? "✅ You were correct!" : "❌ You were incorrect"
        // Do any additional setup after loading the view.
        if wasCorrect == true {
            correctCount += 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNextQuestion",
           let nextVC = segue.destination as? QuestionViewController {
            nextVC.quizTopic = quizTopic
            nextVC.currentQuestionIndex = currentQuestionIndex + 1
            nextVC.correctCount = correctCount
        }
        
        if segue.identifier == "showFinished",
           let finishedVC = segue.destination as? FinishedViewController {
            finishedVC.correctCount = correctCount
            finishedVC.totalQuestions = quizTopic.questions.count
        }
    }
    
    @IBAction func nextButton(_ sender: Any) {
        if currentQuestionIndex + 1 < quizTopic.questions.count {
            performSegue(withIdentifier: "showNextQuestion", sender: nil)
        } else {
            performSegue(withIdentifier: "showFinished", sender: nil)
        }
    }
    @IBAction func backToMainTapped(_ sender: UIButton) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
