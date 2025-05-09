//
//  SimpleCollectionView.swift
//  StupidViewTest
//
//  Created by Abhijith Pm on 8/5/25.
//

// RCA: The collection view wasn't displaying properly because:
// 1. The collection view was embedded in a UIScrollView but had no intrinsic content size
// 2. The collection view's height wasn't constrained to match its content size
// 3. The layout calculations didn't account for dynamic sizing when the parent view changed
// Solution implemented:
// 1. Added height constraint based on calculated content size
// 2. Implemented calculateCollectionViewHeight() to properly size the collection view
// 3. Added layoutSubviews() to handle dynamic size changes

import UIKit


// Requirement:
// Create a simple collection View and pin it to the edges of SimpleCollectionView.
// There has to be 10 cells.
// Create a mock data source for the collection view.
// Each cell has to be configured with the mock data.
// data can be in the format "Cell i" where i is the index of the cell.
class SimpleCollectionView: UIView {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 200, height: 40)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.register(SimpleCollectionViewCell.self, forCellWithReuseIdentifier: "SimpleCell")
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let mockData: [String] = (0..<10).map { "Cell \($0)" }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: calculateCollectionViewHeight())
        ])
    }
    
    private func calculateCollectionViewHeight() -> CGFloat {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemsPerRow = floor((bounds.width - layout.sectionInset.left - layout.sectionInset.right) / (layout.itemSize.width + layout.minimumInteritemSpacing))
        let rowCount = ceil(CGFloat(mockData.count) / itemsPerRow)
        return (rowCount * layout.itemSize.height) + 
               ((rowCount - 1) * layout.minimumLineSpacing) + 
               layout.sectionInset.top + 
               layout.sectionInset.bottom
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.heightAnchor.constraint(equalToConstant: calculateCollectionViewHeight()).isActive = true
    }
}

extension SimpleCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mockData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimpleCell", for: indexPath) as! SimpleCollectionViewCell
        cell.textField.placeholder = mockData[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 30) / 2
        return CGSize(width: width, height: width * 1.2)
    }
}



class SimpleCollectionViewCell: UICollectionViewCell {
    let textField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
