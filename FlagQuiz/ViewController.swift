//
//  ViewController.swift
//  FlagQuiz
//
//  Created by Ivan Jovanovik on 20/11/2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var nextCountryBtn: UIButton!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var countryObject: [String] = []
    var rightAnswer: String = ""
    var csvRows: [[String]] = []
    var answersArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextCountryBtn.layer.cornerRadius = 10
        foundCountry()
        setupCollectionView()
        print(countryObject) //UXM n. 166/167.
    }
    
    @IBAction func chooseNextCountry(_ sender: Any) {
        foundCountry()
    }
    @objc func foundCountry(){
        rightAnswer = ""
        var data = Utils.shared.readDataFromCSV(fileName: "countryNamesWithTranslate", fileType: "csv")
        data = Utils.shared.cleanRows(file: data!)
        csvRows = Utils.shared.csv(data: data!)
        
        let randomCountry = Int(arc4random_uniform(245) + 1)
        
        let oneCountry = csvRows[randomCountry].first
        if let oneCountry = oneCountry {
            countryObject = oneCountry.components(separatedBy: ",")
        }
        countryFlag.image = UIImage(named: countryObject[1])
//        countryName.text = countryObject[2]
        rightAnswer = countryObject[2]
        debugPrint("CountryFlagName: \(countryObject[1])")
        getAnswersArray()
        collectionView.reloadData()
    }
    
    func getAnswersArray(){
        var answersArray: [String] = []
        answersArray.append(countryObject[2])
        
        for _ in 1...3 {
            let randomCountry = Int(arc4random_uniform(245) + 1)
            let oneCountry = csvRows[randomCountry].first
            var helperCountryObject : [String] = []
            if let oneCountry = oneCountry {
                helperCountryObject = oneCountry.components(separatedBy: ",")
            }
            if rightAnswer != helperCountryObject[2] {
                answersArray.append(helperCountryObject[2])
            }
        }
        answersArray.shuffle()
        self.answersArray = answersArray
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.itemSize = CGSize(width: (view.frame.size.width / 2.5), height: 40)
        collectionLayout.minimumInteritemSpacing = 2
        collectionLayout.minimumLineSpacing = 2
        
        collectionView.collectionViewLayout = collectionLayout
        
        collectionView.register(UINib(nibName: "AnswersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AnswersCollectionViewCell")
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnswersCollectionViewCell", for: indexPath) as? AnswersCollectionViewCell {
            
            cell.answerLbl.text = self.answersArray[indexPath.row]
            cell.answerLbl.textColor = .black
            cell.backgroundCellView?.backgroundColor = .white
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? AnswersCollectionViewCell {
            
            if self.answersArray[indexPath.row] == rightAnswer {
                cell.backgroundCellView?.backgroundColor = .green
            } else {
                cell.backgroundCellView?.backgroundColor = .red
            }
        }
        
        
    }
}

