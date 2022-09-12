//
//  ViewController.swift
//  ProtoTask
//
//  Created by Aya Bassi on 12/09/2022.
//

import UIKit
private let myEmail = "a@gmail.com"
private let myPassword = "qqqqqq"

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    var isLoggedIn:Bool = false
    
    // MARK: - ************** Title Label *************
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Proto"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
    }()
    
    // MARK: - ************** email *************
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private let emailTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Email",
                                       isSecureTextEntry: false)
    }()
    
    // MARK: - ************** Password *************
    
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
    
    // MARK: - Selectors
    
    @objc func loginButtonClicked() {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        // successful email and password format
        
        if email.lowercased() == myEmail && password == myPassword {
            
            // Correct email and password entered
            loginAndMakeHomeVCon_RootVConAndSetItUpAndDismissLoginVC()
        } else {
            // wrong email or password
            presentAlertController(withTitle: "Wrong Email or Password", message: "Please type in a correct Email and  Password!")
        }
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
    
    func loginAndMakeHomeVCon_RootVConAndSetItUpAndDismissLoginVC(){
        print("********** Successful logging in *********")
        isLoggedIn = true
    
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0}).first?.windows
            .filter({$0.isKeyWindow}).first
        
        guard let homeViewController = keyWindow?.rootViewController as? HomeViewController else { return }
        homeViewController.callAllUIComponentsToShow()
        dismiss(animated: true, completion: nil)
    }
    
}

