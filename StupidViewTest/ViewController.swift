//
//  ViewController.swift
//  StupidViewTest
//
//  Created by Abhijith Pm on 7/5/25.
//

//
//  ViewController.swift
//  StupidViewTest
//
//  Created by Abhijith Pm on 7/5/25.
//
//  Main controller for handling user interactions and displaying profile content.
//  This controller coordinates between profile views and the underlying data model.

import UIKit

class ViewController: UIViewController, ControllerHandler {
    
    private var viewModel: UnstableViewModel!
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "User Profiles"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search profiles..."
        searchBar.searchBarStyle = .minimal
        searchBar.barTintColor = .white
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        setupKeyboardHandling()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        view.addSubview(headerView)
        headerView.addSubview(headerLabel)
        headerView.addSubview(searchBar)
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 300),
            
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            
            searchBar.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -8),
            searchBar.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
            
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupViewModel() {
        viewModel = UnstableViewModel(controllerHandler: self)
        viewModel.loadData()
    }
    
    func configureView(_ view: UIView) {
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension ViewController {
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    // Requirement:
    // only move the view above the keyboard if the view is below the keyboard
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        // Convert keyboard frame to view coordinates
        let keyboardTopY = view.frame.height - keyboardHeight
        
        // Find the active text field
        guard let activeField = findActiveTextField(in: contentView) else { return }
        
        // Convert text field frame to view coordinates
        let textFieldFrame = activeField.convert(activeField.bounds, to: view)
        let textFieldBottomY = textFieldFrame.origin.y + textFieldFrame.height
        
        // Only move if text field is below or covered by keyboard
        if textFieldBottomY > keyboardTopY {
            let offset = textFieldBottomY - keyboardTopY + 10 // 10 points of padding
            UIView.animate(withDuration: 0.3) {
//                self.contentView.transform = CGAffineTransform(translationX: 0, y: -offset)
                self.view.frame.origin.y -= offset
            }
        }
    }
    
    private func findActiveTextField(in view: UIView) -> UITextField? {
        if let textField = view as? UITextField, textField.isFirstResponder {
            return textField
        }
        
        for subview in view.subviews {
            if let textField = findActiveTextField(in: subview) {
                return textField
            }
        }
        
        return nil
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

//Issue happening when keyboard is observing keyboardWillChangeFrameNotification and the translation logic is self.view.frame.origin.y -= offset
//Solution:
//For monitering keyboard use keyboardWillShowNotification and while handling use below code
//self.contentView.transform = CGAffineTransform(translationX: 0, y: -offset)
