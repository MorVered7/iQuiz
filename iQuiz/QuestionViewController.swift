//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Mor Vered on 5/12/25.
//

import UIKit
struct AnswerPayload {
    let question: String
    let correctAnswer: String
    let isCorrect: Bool
    let quizTopic: ViewController.QuizTopic
    let questionIndex: Int
    let correctCount: Int
}
class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var quizTopic: ViewController.QuizTopic!
    var currentQuestionIndex = 0
    var selectedAnswerIndex: Int?
    var correctCount = 0

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var question: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        question.text = quizTopic.questions[currentQuestionIndex].question
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return quizTopic.questions[currentQuestionIndex].options.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell") ?? UITableViewCell(style: .default, reuseIdentifier: "AnswerCell")
            cell.textLabel?.text = quizTopic.questions[currentQuestionIndex].options[indexPath.row]

            // Show checkmark if selected
            if indexPath.row == selectedAnswerIndex {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }

            return cell
        }

        

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAnswerIndex = indexPath.row
        tableView.reloadData()
    }
    
    @IBAction func backToMainTapped(_ sender: UIButton) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAnswer",
            let destination = segue.destination as? AnswerViewController,
            let data = sender as? AnswerPayload {

                destination.questionText = data.question
                destination.correctAnswer = data.correctAnswer
                destination.wasCorrect = data.isCorrect
                destination.quizTopic = data.quizTopic
                destination.currentQuestionIndex = data.questionIndex
                destination.correctCount = data.correctCount
            }
    }

        @IBAction func submitTapped(_ sender: UIButton) {
            guard let selected = selectedAnswerIndex else {
                return
            }

            let currentQuestion = quizTopic.questions[currentQuestionIndex]
            let correctAnswer = currentQuestion.options[currentQuestion.correctAnswerIndex]
            let isCorrect = selected == currentQuestion.correctAnswerIndex

            let payload = AnswerPayload(
                question: currentQuestion.question,
                correctAnswer: correctAnswer,
                isCorrect: isCorrect,
                quizTopic: quizTopic,
                questionIndex: currentQuestionIndex,
                correctCount: correctCount
            )

            performSegue(withIdentifier: "showAnswer", sender: payload)
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
