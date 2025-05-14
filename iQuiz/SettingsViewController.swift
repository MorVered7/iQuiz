//
//  SettingsViewController.swift
//  iQuiz
//
//  Created by Mor Vered on 5/13/25.
//

import UIKit

class SettingsViewController: UIViewController {
    var quizData: [[String: Any]] = []
    
    @IBOutlet weak var url: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedURL = UserDefaults.standard.string(forKey: "quizDataURL") {
            url.text = savedURL
        } else {
            url.text = "Enter URL Here"
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func checkNow(_ sender: Any) {
        
        guard let urlString = url.text, let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            return
        }
        
        UserDefaults.standard.set(urlString, forKey: "quizDataURL")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                
                if let error = error {
                    let alert = UIAlertController(
                        title: "Network Error",
                        message: error.localizedDescription,
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                    return
                }
                
                guard let data = data else {
                    print("no data received")
                    return
                }
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let array = json as? [[String: Any]] {
                        self.quizData = array

                        NotificationCenter.default.post(name: NSNotification.Name("QuizDataUpdated"), object: array)

                       print("✅ \(array.count) quiz topics loaded.")
                    } else {
                        print( "❌ Unexpected JSON format.")
                    }
                } catch {
                    print("❌ JSON error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
