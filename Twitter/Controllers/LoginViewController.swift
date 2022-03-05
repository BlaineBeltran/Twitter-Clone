//
//  LoginViewController.swift
//  Twitter
//
//  Created by Blaine Beltran on 3/5/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        
        let url = "https://api.twitter.com/oauth/request_token"
        
        TwitterAPICaller.client?.login(url: url, success: { [weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.performSegue(withIdentifier: "loginToHome", sender: strongSelf)
        }, failure: {  [weak self ] error in
            
            guard let strongSelf = self else { return }
            let alert = UIAlertController(title: "Login Failure", message: error.localizedDescription, preferredStyle: .actionSheet)
            let dismissAction = UIAlertAction(title: "OK", style: .default) { action in
                
                
                strongSelf.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(dismissAction)
            strongSelf.present(alert, animated: true, completion: nil)
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
