//
//  ViewController.swift
//  TestAuth
//
//  Created by Victoria Isaeva on 04.09.2025.
//

import UIKit
import SafariServices


class LoginViewController: UIViewController {
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome"
        label.font = .systemFont(ofSize: 64, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your phon number. We will send you an SMS with a confirmation code to this number"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "background")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let roseImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "rose")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let appleButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.cornerStyle = .medium
        
        let title = "Continue with Apple"
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]))
        config.titleAlignment = .leading
        config.imagePadding = 8
        
        if let googleImage = UIImage(named: "apple")?.withRenderingMode(.alwaysOriginal) {
            config.image = googleImage
        }
        let button = UIButton(configuration: config, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    private let googleButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.cornerStyle = .medium
        
        let title = "Continue with Google"
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]))
        config.titleAlignment = .leading
        config.imagePadding = 8
        
        if let googleImage = UIImage(named: "googleImage")?.withRenderingMode(.alwaysOriginal) {
            config.image = googleImage
        }
        let button = UIButton(configuration: config, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let termsLabel: UILabel = {
        let label = UILabel()
        label.text = "By continuing, you agree to Assetsy's Terms of Use and Privacy Policy"
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        setupNavigationBar()
        
        view.addSubview(backgroundImage)
        view.addSubview(roseImage)
        view.addSubview(welcomeLabel)
        view.addSubview(infoLabel)
        
        view.addSubview(appleButton)
        view.addSubview(googleButton)
        view.addSubview(termsLabel)
        
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        let skipButton = UIBarButtonItem(
            title: "Skip",
            style: .plain,
            target: self,
            action: #selector(skipTapped)
        )
        skipButton.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor.black
        ], for: .normal)
        navigationItem.rightBarButtonItem = skipButton
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            infoLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            backgroundImage.topAnchor.constraint(equalTo: infoLabel.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -48),
            
            roseImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            roseImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            appleButton.bottomAnchor.constraint(equalTo: googleButton.topAnchor, constant: -12),
            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            appleButton.heightAnchor.constraint(equalToConstant: 50),
            
            googleButton.bottomAnchor.constraint(equalTo: termsLabel.topAnchor, constant: -20),
            googleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            googleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            googleButton.heightAnchor.constraint(equalToConstant: 50),
            
            termsLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            termsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            termsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            termsLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
            
            
        ])
    }
    
    @objc private func skipTapped() {
        print("Skip tapped")
        
    }
    
}

