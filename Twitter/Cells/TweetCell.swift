//
//  TweetCell.swift
//  Twitter
//
//  Created by Blaine Beltran on 3/7/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

protocol TweetTableViewDelegate {
    
    func didTapLikeOrRetweet()
    func didTapShareButton(presentedWith: UIViewController)
}

class TweetCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var likeButtonImage: UIButton!
    @IBOutlet weak var retweetButtonImage: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    
    var delegate: TweetTableViewDelegate?
    
    var isLiked: Bool = false
    var retweeted: Bool = false
    var tweetID: Int = -1

// MARK: - IBActions
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        
        if !isLiked {
            DispatchQueue.global(qos: .background).async {
                TwitterAPICaller.client?.favoriteTweet(tweetID: self.tweetID, success: { [weak self] in
                    
                    guard let strongSelf = self else { return }
                    
                    
                    DispatchQueue.main.async {
                        strongSelf.setFavorited(true)
                    }
                    strongSelf.delegate?.didTapLikeOrRetweet()
                    
                }, failure: { [weak self] _ in
                    
                    guard let strongSelf = self else { return }
                    
                    let failureToFavoriteAlert = UIAlertController(title: "Unable to like tweet", message: nil, preferredStyle: .actionSheet)
                    
                    let okayAction = UIAlertAction(title: "OK", style: .default) { _ in
                        failureToFavoriteAlert.dismiss(animated: true, completion: nil)
                    }
                    
                    failureToFavoriteAlert.addAction(okayAction)
                    // show alert -> fix later
                })
            }
        } else {
            DispatchQueue.global(qos: .background).async {
                TwitterAPICaller.client?.unFavoriteTweet(tweetID: self.tweetID, success: { [weak self] in
                    
                    guard let strongSelf = self else { return }
                    
                    DispatchQueue.main.async {
                        print("UI Updated on this thread when unliking ...")
                        print(Thread.current)
                        strongSelf.setFavorited(false)
                    }
                    strongSelf.delegate?.didTapLikeOrRetweet()
                    
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
    }
    
    
    @IBAction func retweetButtonPressed(_ sender: Any) {
        if !retweeted {
            DispatchQueue.global(qos: .background).async {
                TwitterAPICaller.client?.retweet(tweetID: self.tweetID, success: { [weak self] in
                    
                    guard let strongSelf = self else { return }
                    
                    DispatchQueue.main.async {
                        strongSelf.setRetweet(true)
                    }
                    strongSelf.delegate?.didTapLikeOrRetweet()
                    
                }, failure: { [weak self] _ in
                    
                    guard let strongSelf = self else { return }
                    // show failure alert
                })
            }
        } else {
            DispatchQueue.global(qos: .background).async {
                TwitterAPICaller.client?.unRetweet(tweetID: self.tweetID, success: { [weak self] in
                    guard let strongSelf = self else { return }
                    
                    DispatchQueue.main.async {
                        strongSelf.setRetweet(false)
                    }
                    strongSelf.delegate?.didTapLikeOrRetweet()
                }, failure: { [weak self] _ in
                    
                    guard let strongSelf = self else { return }
                    //show failure alert
                })
            }
        }
    }
    
    
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        
        guard let safeText = tweetContentLabel.text else {
            print("No text found")
            return
        }
        
        let shareVC = UIActivityViewController(activityItems: [safeText], applicationActivities: [])
        delegate?.didTapShareButton(presentedWith: shareVC)
    }
    
    
    
    
    

// MARK: - Update tweet like/retweet buttons
    
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
