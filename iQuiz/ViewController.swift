//
//  ViewController.swift
//  iQuiz
//
//  Created by Mor Vered on 5/3/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
   

    struct QuizQuestion {
        let question: String
        let options: [String]
        let correctAnswerIndex: Int
    }

    struct QuizTopic {
        let title: String
        let description: String
        let imageName: String
        let questions: [QuizQuestion]
    }
    var quizTopics: [QuizTopic] = []



    @IBAction func settings(_ sender: Any) {
//        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            present(alert, animated: true, completion: nil)
        performSegue(withIdentifier: "showSettings", sender: self)
    }
    
    @IBOutlet weak var table: UITableView!
    let stringTableData = StringTableDataModel([
        ("Mathematics", "Solve math questions!", "math.icon"),
        ("Marvel Superheroes", "Test your Marvel knowledge!", "marvel.icon"),
        ("Science", "Fun science facts!", "science.icon")
    ])

    class StringTableDataModel : NSObject, UITableViewDataSource {
        let data: [(title: String, description: String, imageName: String)]

        init(_ items: [(String, String, String)]) {
            data = items
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StringCell") ?? UITableViewCell(style: .default, reuseIdentifier: "StringCell")
            
            let item = data[indexPath.row]
            
            // Set text
            cell.textLabel?.numberOfLines = 2
            cell.textLabel?.text = "\(item.title)\n\(item.description)"
            
            // Set image
            cell.imageView?.image = UIImage(named: item.imageName)
            
            
            // Make the cell full-width
            cell.separatorInset = .zero
            cell.layoutMargins = .zero
            cell.preservesSuperviewLayoutMargins = false
            
            return cell
        }


    }
    let defaultQuizTopics: [QuizTopic] = [
        QuizTopic(
            title: "Mathematics",
            description: "Solve math questions!",
            imageName: "math.icon",
            questions: [
                QuizQuestion(question: "What is 2 + 2?", options: ["3", "4", "5"], correctAnswerIndex: 1),
                QuizQuestion(question: "What is 5 x 3?", options: ["15", "10", "20"], correctAnswerIndex: 0),
                QuizQuestion(question: "What is 25 - 3?", options: ["3", "28", "22"], correctAnswerIndex: 2),
                QuizQuestion(question: "What is 9 x 3?", options: ["49", "27", "46"], correctAnswerIndex: 1),
                QuizQuestion(question: "What is 56 / 8?", options: ["7", "10", "6"], correctAnswerIndex: 0)
            ]
        ),
        QuizTopic(
            title: "Marvel Superheroes",
            description: "Test your Marvel knowledge!",
            imageName: "marvel.icon",
            questions: [
                QuizQuestion(question: "Who is Iron Man?", options: ["Bruce Wayne", "Tony Stark", "Clark Kent"], correctAnswerIndex: 1),
                QuizQuestion(question: "Which Infinity Stone does Vision have?", options: ["Mind Stone", "Time Stone", "Soul Stone"], correctAnswerIndex: 0),
                QuizQuestion(question: "What is Thor's hammer called?", options: ["Stormbreaker", "Mjolnir", "Gungnir"], correctAnswerIndex: 1),
                QuizQuestion(question: "What is the real name of the Scarlet Witch?", options: ["Natasha Romanoff", "Wanda Maximoff", "Carol Danvers"], correctAnswerIndex: 1),
                QuizQuestion(question: "Who is Peter Parker’s best friend in the MCU?", options: ["Flash Thompson", "Harry Osborn", "Ned Leeds"], correctAnswerIndex: 2)
            ]
        ),
        QuizTopic(
            title: "Science",
            description: "Fun science facts!",
            imageName: "science.icon",
            questions: [
                QuizQuestion(question: "What planet is known as the Red Planet?", options: ["Mars", "Earth", "Jupiter"], correctAnswerIndex: 0),
                QuizQuestion(question: "What force keeps planets in orbit around the sun?", options: ["Magnetism", "Gravity", "Friction"], correctAnswerIndex: 1),
                QuizQuestion(question: "What is the center of an atom called?", options: ["Electron", "Proton", "Nucleus"], correctAnswerIndex: 2),
                QuizQuestion(question: "What vitamin do we get from sunlight?", options: ["Vitamin C", "Vitamin D", "Vitamin B12"], correctAnswerIndex: 1),
                QuizQuestion(question: "Which organ is responsible for pumping blood?", options: ["Liver", "Lung", "Heart"], correctAnswerIndex: 2)
            ]
        )
    ]

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        quizTopics = defaultQuizTopics
        
        table.dataSource = stringTableData
        table.delegate = self
        NotificationCenter.default.addObserver(forName: NSNotification.Name("QuizDataUpdated"), object: nil, queue: .main) { notification in
                    if let json = notification.object as? [[String: Any]] {
                        self.quizTopics = self.parseQuizTopics(from: json)
                        self.table.reloadData()
                    }
                }

        table.reloadData()

    }
    func parseQuizTopics(from json: [[String: Any]]) -> [QuizTopic] {
            var topics: [QuizTopic] = []

            for item in json {
                guard let title = item["title"] as? String,
                      let desc = item["desc"] as? String,
                      let questions = item["questions"] as? [[String: Any]] else {
                    continue
                }

                let parsedQuestions = questions.compactMap { q -> QuizQuestion? in
                    guard let text = q["text"] as? String,
                          let options = q["answers"] as? [String],
                          let correctStr = q["answer"] as? String,
                          let correctIndex = Int(correctStr) else {
                        return nil
                    }
                    return QuizQuestion(question: text, options: options, correctAnswerIndex: correctIndex)
                }

                let topic = QuizTopic(title: title, description: desc, imageName: "default.icon", questions: parsedQuestions)
                topics.append(topic)
            }

            return topics
        }
   

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("User selected \(indexPath)")
        let alert = UIAlertController(title: "You selected", message: indexPath.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Close the alert"), style: .default, handler: { _ in
            NSLog("User said OK.")
            alert.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }

}

