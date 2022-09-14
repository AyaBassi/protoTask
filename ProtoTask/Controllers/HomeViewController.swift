//
//  HomeViewController.swift
//  ProtoTask
//
//  Created by Aya Bassi on 12/09/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    let urlSring = "https://content-cache.watchcorridor.com/v6/interview"
    
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
    
    // When Login button is clicked in LoginViewController,if there is a successful logging in,with correct email and password, login view controller is dismissed and this function is called.Which we will try
    // to then make the api calls and set up every thing from here
    func callAllUIComponentsToShow(){
        fetchMovieData()
    }
    
    // MARK: - API CALLS
    func fetchMovieData(){
        guard let url = URL(string: urlSring) else {
            print("Something wrong with url!")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { jsonData , _ , error in
            guard let jsonData = jsonData , error == nil else {
                print("No data received, error: ",error!.localizedDescription)
                return
            }
                print("got data!")
            
            let jsonItems = try? JSONDecoder().decode(Welcome.self, from: jsonData)
            
            guard let jsonItems = jsonItems else {
                return
            }
            // now can access moviInformation data


        }
            task.resume()
    }
    
}


//
//        for jsonItem in jsonItems {
//            print(jsonItem.id)
//
//            if let jsonItemImages = jsonItem.images {
//
//                for jsonItemImage in jsonItemImages {
//                    print(jsonItemImage.url)
//                }
//            } else {
//                print("No image")
//            }
//        }
