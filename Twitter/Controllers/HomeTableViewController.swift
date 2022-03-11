//
//  HomeViewController.swift
//  Twitter
//
//  Created by Blaine Beltran on 3/5/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var tweetList = [NSDictionary]()
    var numberOfTweet: Int!
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTweets()
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.estimatedRowHeight = 200
        tableView.refreshControl = myRefreshControl
    }
    
    @objc func loadTweets() {
        
        numberOfTweet = 20
        
        let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count" : numberOfTweet]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: myParams as [String : Any], success: { [weak self] (tweets: [NSDictionary]) in
            
            guard let strongSelf = self else { return }
            
            strongSelf.tweetList.removeAll()
            for tweet in tweets {
                strongSelf.tweetList.append(tweet)
            }
            
            strongSelf.tableView.reloadData()
            strongSelf.myRefreshControl.endRefreshing()
          
            
        }, failure: { [weak self] error in
            print(error.localizedDescription)
            guard let strongSelf = self else { return }

            let tweetAlert = UIAlertController(title: "Tweet Erorr",
                                               message: "\(error.localizedDescription)",
                                               preferredStyle: .actionSheet)

            let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { _ in
                tweetAlert.dismiss(animated: true, completion: nil)
            }

            let retryAction = UIAlertAction(title: "Retry", style: .destructive) { _ in
                strongSelf.loadTweets()
            }

            tweetAlert.addAction(dismissAction)
            tweetAlert.addAction(retryAction)
            strongSelf.present(tweetAlert, animated: true, completion: nil)
            
        })
    }
    
    
    
    func loadMoreTweets() {
        
        let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweet += 20
        let myParams = ["count":numberOfTweet]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: myParams as [String : Any], success: { [weak self] (tweets: [NSDictionary]) in
            
            guard let strongSelf = self else { return }
            
            strongSelf.tweetList.removeAll()
            for tweet in tweets {
                strongSelf.tweetList.append(tweet)
            }
            
            strongSelf.tableView.reloadData()
          
            
        }, failure: { [weak self] error in
            guard let strongSelf = self else { return }

            let tweetAlert = UIAlertController(title: "Tweet Erorr",
                                               message: "\(error.localizedDescription)",
                                               preferredStyle: .actionSheet)

            let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { _ in
                tweetAlert.dismiss(animated: true, completion: nil)
            }

            let retryAction = UIAlertAction(title: "Retry", style: .destructive) { _ in
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
    
// MARK: - TableView Set up
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tweetList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as? TweetCell else {
            return UITableViewCell()
        }
        
        let user = tweetList[indexPath.row]["user"] as! NSDictionary
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        cell.nameLabel.text = user["name"] as? String
        cell.tweetContentLabel.text = tweetList[indexPath.row]["text"] as? String
        if let imageData = data {
            cell.tweetImage.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row + 1 == tweetList.count {
            loadMoreTweets()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

