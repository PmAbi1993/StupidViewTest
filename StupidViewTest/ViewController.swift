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

class ViewController: UIViewController, ControllerHandler, UIScrollViewDelegate {
    
    private var viewModel: UnstableViewModel!
    
    // Track active text field for keyboard handling
    private weak var activeField: UIView?
    
    // Scroll view to handle keyboard avoidance
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    
    // Container for all content
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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

    // Add a container view that will be used for keyboard adjustments
    private var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("🔍 viewDidLoad")
        setupUI()
        setupViewModel()
        setupKeyboardHandling()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("🔍 viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("🔍 viewDidAppear")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("🔍 viewWillLayoutSubviews - view.frame.origin.y = \(view.frame.origin.y)")
    }
    
    override func updateViewConstraints() {
        print("🔍 updateViewConstraints - view.frame.origin.y = \(view.frame.origin.y)")
        super.updateViewConstraints()
    }
    
    private func setupUI() {
        print("🔍 setupUI")
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        // Add scroll view to main view
        view.addSubview(scrollView)
        scrollView.delegate = self
        
        // Add container view to scroll view
        scrollView.addSubview(containerView)
        
        // Add content to container view
        containerView.addSubview(headerView)
        headerView.addSubview(headerLabel)
        headerView.addSubview(searchBar)
        containerView.addSubview(contentView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            // Scroll view fills the entire view
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Container view is the same width as the scroll view
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            // Height will be determined by content
            
            // Header view at the top of the container
            headerView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 300),
            
            // Header label within header view
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            
            // Search bar within header view
            searchBar.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -8),
            searchBar.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
            
            // Content view below header
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func setupViewModel() {
        viewModel = UnstableViewModel(controllerHandler: self)
        viewModel.loadData()
        
        // Add a slight delay to ensure proper layout before updating content size
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateScrollViewContentSize()
        }
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
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            // Set a minimum height for the content view to ensure it's visible
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: 400)
        ])
        
        // After adding the view, update the scroll view's content size
        updateScrollViewContentSize()
    }
}

extension ViewController {
    private func setupKeyboardHandling() {
        print("🔍 setupKeyboardHandling")
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        // Monitor all text fields and text views for editing events
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), 
                                               name: UITextField.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidBeginEditing), 
                                               name: UITextView.textDidBeginEditingNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        print("🔍 keyboardWillShow")
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let activeField = self.activeField ?? findFirstResponder(in: view) else {
            print("🔍 keyboardWillShow - No active field found")
            return
        }
        
        // Calculate the active field's position in the scroll view
        let activeFieldFrame = activeField.convert(activeField.bounds, to: scrollView)
        
        // Calculate the keyboard's top position
        let keyboardY = scrollView.frame.height - keyboardSize.height
        
        // Calculate the area that needs to be visible
        let visibleRect = CGRect(
            x: 0,
            y: activeFieldFrame.origin.y - 20, // Add some padding above the field
            width: scrollView.frame.width,
            height: activeFieldFrame.height + 40 // Add padding below too
        )
        
        // Check if the field would be covered by the keyboard
        if visibleRect.maxY > keyboardY {
            // Get animation details from the notification
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.3
            let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            
            // Calculate the scroll offset needed
            let offset = visibleRect.maxY - keyboardY + 20 // Add extra padding
            
            print("🔍 keyboardWillShow - Scrolling to make field visible, offset: \(offset)")
            
            // Animate the scroll
            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
                self.scrollView.contentOffset = CGPoint(x: 0, y: offset)
            })
        }
    }
    
    // UIScrollViewDelegate method to handle scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("🔍 scrollViewDidScroll - contentOffset.y: \(scrollView.contentOffset.y)")
    }
    
    // Update the scroll view's content size based on its content
    private func updateScrollViewContentSize() {
        // Give the layout a chance to update
        DispatchQueue.main.async {
            // Calculate the total height of the content
            let headerHeight = self.headerView.frame.height
            let contentHeight = self.contentView.frame.height
            let totalHeight = headerHeight + contentHeight
            
            // Set the content size of the scroll view
            self.containerView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
            
            print("🔍 updateScrollViewContentSize - totalHeight: \(totalHeight)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("🔍 viewDidLayoutSubviews - view.frame.origin.y = \(view.frame.origin.y)")
        
        // Update the scroll view's content size after layout
        updateScrollViewContentSize()
    }
    
    // We're not using this method anymore as we've simplified the approach
    
    private func findFirstResponder(in view: UIView) -> UIView? {
        // Check if this view is the first responder
        if view.isFirstResponder {
            return view
        }
        
        // Recursively search through subviews
        for subview in view.subviews {
            if let firstResponder = findFirstResponder(in: subview) {
                return firstResponder
            }
        }
        
        return nil
    }
    
    @objc private func textFieldDidBeginEditing(notification: Notification) {
        activeField = notification.object as? UITextField
        print("🔍 textFieldDidBeginEditing - activeField set")
    }
    
    @objc private func textViewDidBeginEditing(notification: Notification) {
        activeField = notification.object as? UITextView
        print("🔍 textViewDidBeginEditing - activeField set")
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        print("🔍 keyboardWillHide")
        
        // Get animation details from the notification
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.3
        let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        
        // Animate scrolling back to the top
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        })
        
        // Clear the active field reference
        activeField = nil
    }
    
    @objc private func dismissKeyboard() {
        print("🔍 dismissKeyboard called")
        view.endEditing(true)
    }
}

//Issue happening when keyboard is observing keyboardWillChangeFrameNotification and the translation logic is self.view.frame.origin.y -= offset
//Solution:
//For monitering keyboard use keyboardWillShowNotification and while handling use below code
//self.contentView.transform = CGAffineTransform(translationX: 0, y: -offset)
