//
//  TweetViewController.swift
//  Twitter
//
//  Created by Blaine Beltran on 3/14/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var characterCount: UILabel!
    @IBOutlet weak var tweetTextField: UITextView!
    
    var maxCount =  140
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetTextField.becomeFirstResponder()
        tweetTextField.delegate = self
        characterCount.text = String(maxCount)
    }
    
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func TweetButtonPressed(_ sender: Any) {
        
        if !tweetTextField.text.isEmpty {
            let text = tweetTextField.text!
            TwitterAPICaller.client?.postTweet(tweet: text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { [weak self] error in
                
                guard let strongSelf = self else { return }
                
                let title = "Unable to post tweet"
                let message = error.localizedDescription
                let tweetFailureAlert = UIAlertController(title: title , message: message, preferredStyle: .actionSheet)
                
                let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { _ in
                    tweetFailureAlert.dismiss(animated: true, completion: nil)
                }
                
                tweetFailureAlert.addAction(dismissAction)
                
                strongSelf.present(tweetFailureAlert, animated: true, completion: nil)
            })
        } else {
            //Empty text alert
            
            let title = "Post Error"
            let message = "Unable to post tweets without text. Please provide a tweet that is not empty"
            let emptyTextAlert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let okayAction = UIAlertAction(title: "OK", style: .default) { _ in
                
                emptyTextAlert.dismiss(animated: true, completion: nil)
            }
            
            emptyTextAlert.addAction(okayAction)
            
            present(emptyTextAlert, animated: true, completion: nil)
        }
    }
}

extension TweetViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = tweetTextField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        let charactersLeft = String(maxCount - updatedText.count)
        characterCount.text = charactersLeft
        return updatedText.count < maxCount
    }
}

