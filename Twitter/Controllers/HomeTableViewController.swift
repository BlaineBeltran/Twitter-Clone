//
//  HomeViewController.swift
//  Twitter
//
//  Created by Blaine Beltran on 3/5/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var tweetList: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTweets()
    }
    
    func loadTweets() {
        
        let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = [String:Any]()
        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: myParams, success: { [weak self] (tweets: [NSDictionary]) in
            
            guard let strongSelf = self else { return }
            
            if strongSelf.tweetList != nil {
                strongSelf.tweetList?.removeAll()
                for tweet in tweets {
                    strongSelf.tweetList?.append(tweet)
                }
            }
            
            
            strongSelf.tableView.reloadData()
            
        }, failure: { [weak self] error in
            print(error.localizedDescription)
            guard let strongSelf = self else { return }

            let tweetAlert = UIAlertController(title: "Tweet Erorr",
                                               message: "Could not retrive tweet.",
                                               preferredStyle: .actionSheet)

            let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { _ in
                tweetAlert.dismiss(animated: true, completion: nil)
            }

            let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
                strongSelf.loadTweets()
            }

            tweetAlert.addAction(dismissAction)
            tweetAlert.addAction(retryAction)
            strongSelf.present(tweetAlert, animated: true, completion: nil)
            
        })
    }
    
// MARK: - IBActions
    
    @IBAction func logoutPressed(_ sender: Any) {
        
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        self.dismiss(animated: true, completion: nil)
    }
    
// MARK: - TableView Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let listOfTweets = tweetList {
            return listOfTweets.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as? TweetCell else {
            return UITableViewCell()
        }
        
        if let listOfTweets = tweetList {
            let user = listOfTweets[indexPath.row]["user"] as! NSDictionary
            cell.nameLabel.text = user["name"] as? String
            cell.tweetContentLabel.text = listOfTweets[indexPath.row]["text"] as? String
        }
        return cell
    }

}
