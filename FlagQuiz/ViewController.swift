//
//  ViewController.swift
//  FlagQuiz
//
//  Created by Ivan Jovanovik on 20/11/2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryFlag: UIImageView!
    var countryArray: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foundCountry()
        print(countryArray) //UXM n. 166/167.
    }
    
    @IBAction func chooseNextCountry(_ sender: Any) {
        foundCountry()
    }
    @objc func foundCountry(){
        var data = readDataFromCSV(fileName: "countryNamesWithTranslate", fileType: "csv")
        data = cleanRows(file: data!)
        let csvRows = csv(data: data!)
        
        let randomCountry = Int(arc4random_uniform(245) + 1)
        
        let oneCountry = csvRows[randomCountry].first
        if let oneCountry = oneCountry {
            countryArray = oneCountry.components(separatedBy: ",")
        }
        countryFlag.image = UIImage(named: countryArray[1])
        countryName.text = countryArray[2]
        debugPrint("CountryFlagName: \(countryArray[1])")
    }

    
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ";")
            result.append(columns)
        }
        return result
    }
    
    func readDataFromCSV(fileName:String, fileType: String)-> String!{
            guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
                else {
                    return nil
            }
            do {
                var contents = try String(contentsOfFile: filepath, encoding: .utf8)
                contents = cleanRows(file: contents)
                return contents
            } catch {
                print("File Read Error for file \(filepath)")
                return nil
            }
        }


    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";;", with: "")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";\n", with: "")
        return cleanFile
    }

}

