//
//  ProfileCell.swift
//  StupidViewTest
//
//  Created by Abhijith Pm on 7/5/25.
//

import UIKit

public class ProfileCell: UICollectionViewCell {
    private let profileView = ProfileView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(profileView)
        profileView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            profileView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: (image: UIImage?, name: String, description: String)) {
        profileView.configure(image: data.image, name: data.name, description: data.description)
    }
}
