//
//  TweetCell.swift
//  Twitter
//
//  Created by Blaine Beltran on 3/7/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var likeButtonImage: UIButton!
    @IBOutlet weak var retweetButtonImage: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    
    
    
    var isLiked: Bool = false
    var retweeted: Bool = false
    var tweetID: Int = -1


    @IBAction func likeButtonPressed(_ sender: Any) {
        
        if !isLiked {
            TwitterAPICaller.client?.favoriteTweet(tweetID: tweetID, success: { [weak self] in
                
                guard let strongSelf = self else { return }
                strongSelf.setFavorited(true)
                
            }, failure: { [weak self] _ in
                
                guard let strongSelf = self else { return }
                
                let failureToFavoriteAlert = UIAlertController(title: "Unable to like tweet", message: nil, preferredStyle: .actionSheet)
                
                let okayAction = UIAlertAction(title: "OK", style: .default) { _ in
                    failureToFavoriteAlert.dismiss(animated: true, completion: nil)
                }
                
                failureToFavoriteAlert.addAction(okayAction)
                // show alert -> fix later
            })
        } else {
            TwitterAPICaller.client?.unFavoriteTweet(tweetID: tweetID, success: { [weak self] in
                
                guard let strongSelf = self else { return }
                strongSelf.setFavorited(false)
                
            }, failure: { [weak self] _ in
                
                let failureToUnfavoriteAlert = UIAlertController(title: "Unable to like tweet", message: nil, preferredStyle: .actionSheet)
                
                let okayAction = UIAlertAction(title: "OK", style: .default) { _ in
                    failureToUnfavoriteAlert.dismiss(animated: true, completion: nil)
                }
                
                failureToUnfavoriteAlert.addAction(okayAction)
                // show alert -> fix later
            })
        }
    }
    
    
    @IBAction func retweetButtonPressed(_ sender: Any) {
        print("tapped")
        if !retweeted {
            print("making call to retweet")
            TwitterAPICaller.client?.retweet(tweetID: tweetID, success: { [weak self] in
                
                guard let strongSelf = self else { return }
                strongSelf.setRetweet(true)
            }, failure: { [weak self] _ in
                
                guard let strongSelf = self else { return }
                // show failure alert
            })
        } else {
            
            TwitterAPICaller.client?.unRetweet(tweetID: tweetID, success: { [weak self] in
                print("making call to unretweet")
                guard let strongSelf = self else { return }
                strongSelf.setRetweet(false)
            }, failure: { [weak self] _ in
                
                guard let strongSelf = self else { return }
                //show failure alert
            })
            
        }
    }
    
    

    func setFavorited(_ isFavorited: Bool) {
        isLiked = isFavorited
        if isLiked {
            likeButtonImage.setImage(UIImage(named: "favor-icon-red"), for: .normal)
        } else {
            likeButtonImage.setImage(UIImage(named: "favor-icon"), for: .normal)
        }
    }
    
    func setRetweet(_ isRetweeted: Bool) {
        retweeted = isRetweeted
        if retweeted {
            retweetButtonImage.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
        } else {
            retweetButtonImage.setImage(UIImage(named: "retweet-icon"), for: .normal)
        }
    }
}
