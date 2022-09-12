//
//  ViewController.swift
//  ProtoTask
//
//  Created by Aya Bassi on 12/09/2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Proto"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
    }()
    
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private let emailTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Email",
                                       isSecureTextEntry: false)
    }()
    
    // ************** password
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private let passwordTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Password",
                                       isSecureTextEntry: true)
    }()
    
    
    // MARK: - ************** Login Button *************
    
    lazy private var loginButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        
        addTitleLableToView()
        
        addStackOfEmailPasswordContainerAndLoginButtonToView()
        
    }
    
    // MARK: - Helper functions
    
    func addTitleLableToView(){
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: view)
    }
    
    func addStackOfEmailPasswordContainerAndLoginButtonToView(){
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   loginButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 24
        
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingTop: 40, paddingLeft: 16,
                     paddingRight: 16)
    }
    
    // MARK: - Selectors
    
    @objc func loginButtonClicked() {
        guard let email = emailTextField.text,email.contains("@"),email.contains(".")
        else {
            emailTextField.text == "" ? presentAlertController(withTitle: "Email field is empty",
                                                               message: "Please type your email address!"):
            presentAlertController(withTitle: "Wrong Email Format",
                                   message: "Please include an '@' and '.' character!")
            return
        }

        let passwordMinimumLength : Int = 6
        guard let password = passwordTextField.text, password.count >= passwordMinimumLength
        else {
            passwordTextField.text == "" ? presentAlertController(withTitle: "Password Field is empty",
                                                                  message: "Please type in a minimum of 6 characters!") :
            presentAlertController(withTitle: "Not Enough Characters",
                                   message: "Please use a minimum of 6 characters!")
            return
        }
        
        // successful email and password format
        print("Successl email and password format")
        print("Email: ", email)
        print("Password: ", password)
        
        // MARK: - TO-DO
        
    }
    
   
    
}

