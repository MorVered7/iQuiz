//
//  ViewController.swift
//  iQuiz
//
//  Created by Mor Vered on 5/3/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
   
    
    @IBAction func settings(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        table.dataSource = stringTableData
        table.delegate = self
        table.reloadData()

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

