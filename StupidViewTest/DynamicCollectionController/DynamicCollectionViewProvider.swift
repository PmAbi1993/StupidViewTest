//
//  DynamicCollectionViewProvider.swift
//  StupidViewTest
//
//  Created by Abhijith Pm on 8/5/25.
//

import UIKit

protocol DynamicViewProvider: AnyObject {
    func getContainerView() -> UIView
}

class DynamicCollectionViewProvider: DynamicViewProvider {
    
    func getContainerView() -> UIView {
        let view: SimpleCollectionView = SimpleCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}