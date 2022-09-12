//
//  HomeViewController.swift
//  ProtoTask
//
//  Created by Aya Bassi on 12/09/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    let loginViewController = LoginViewController()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .backgroundColor
            
        if !loginViewController.isLoggedIn {
            // not logged in so present login view controller to login
            presentLogInViewController()
        }
    }
    
    // MARK: - Helper functions
    
    func presentLogInViewController(){
        DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: LoginViewController())
            if #available(iOS 13.0, *) {
                nav.isModalInPresentation = true
            }
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    
    func callAllUIComponentsToShow(){
        print("set up and show all componenets of homeView")
    }

}
