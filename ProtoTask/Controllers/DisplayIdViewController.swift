//
//  DisplayIdViewController.swift
//  ProtoTask
//
//  Created by Aya Bassi on 15/09/2022.
//

import UIKit

class DisplayIdViewController: UIViewController {
    
    var someTitle : String = "No Id!" {
        didSet {
            title = someTitle
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dismiss",
                                                            style: .plain,
                                                            target: self,
                                                            action:#selector(dismissSelf))
    }
    
    // MARK: - Selector
    @objc func dismissSelf(){
        dismiss(animated: true,completion: nil)
    }

}
