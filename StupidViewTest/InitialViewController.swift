//
//  InitialViewController.swift
//  StupidViewTest
//
//  Created by Abhijith Pm on 7/5/25.
//

import UIKit

class InitialViewController: UIViewController {
    
    private let executeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Execute", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .red
        
        view.addSubview(executeButton)
        
        NSLayoutConstraint.activate([
            executeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            executeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            executeButton.widthAnchor.constraint(equalToConstant: 200),
            executeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        executeButton.addTarget(self, action: #selector(executeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func executeButtonTapped() {
        let viewController = ViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
