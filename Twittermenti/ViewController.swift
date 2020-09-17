//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

let apiSecrets = getSecrets()

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let numTweets = 100
    
    let sentimentClassifier = TweetSentimentClassifier()
    let swifter = Swifter(consumerKey: apiSecrets!["API Key"]!, consumerSecret: apiSecrets!["API Secret"]!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func predictPressed(_ sender: Any) {
        fetchTweets()
    }
    
    func fetchTweets() {
        if let searchText = textField.text {
            swifter.searchTweet(using: searchText, lang: "en", count: numTweets, tweetMode: .extended, success: { (results, metadata) in
                    
                    var tweets = [TweetSentimentClassifierInput]()
                    
                for i in 0...(self.numTweets - 1) {
                        if let tweet = results[i]["full_text"].string {
                            tweets.append(TweetSentimentClassifierInput(text: tweet))
                        }
                }
            
                self.makePrediction(with: tweets)

                }) { (error) in
                    print("An error has occurred with Twitter API Request: \(error)")
                }
        }
    }
    
    func makePrediction(with tweets: [TweetSentimentClassifierInput]) {
        do {
            let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
            
            var sentimentScore = 0
            
            for pred in predictions {
                if pred.label == "Pos" {
                    sentimentScore += 1
                } else if pred.label == "Neg" {
                    sentimentScore -= 1
                }
            }
            
            updateUI(with: sentimentScore)
            
        } catch {
            print("There was an error making a prediction: \(error)")
        }
    }
    
    func updateUI(with sentimentScore: Int) {
        if sentimentScore > 20 {
                       self.sentimentLabel.text = "😍"
                   } else if sentimentScore > 10 {
                       self.sentimentLabel.text = "😃"
                   } else if sentimentScore > 0 {
                       self.sentimentLabel.text = "🙂"
                   } else if sentimentScore == 0 {
                       self.sentimentLabel.text = "😐"
                   } else if sentimentScore > -10 {
                       self.sentimentLabel.text = "🙁"
                   } else if sentimentScore > -20 {
                       self.sentimentLabel.text = "😡"
                   } else {
                       self.sentimentLabel.text = "🤮"
                   }
    }
}

func getSecrets() -> [String: String]? {
    guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
        print("Error finding plist file.")
        return nil
    }
    let url = URL(fileURLWithPath: path)
    let data = try! Data(contentsOf: url)
    guard let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: .none) as? [String: String] else {
        print("Error extracting plist data.")
        return nil
    }
    
    return plist
}
