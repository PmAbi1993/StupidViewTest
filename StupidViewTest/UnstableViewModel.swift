//
//  UnstableViewModel.swift
//  StupidViewTest
//
//  Created by Abhijith Pm on 7/5/25.
//

import UIKit

protocol ControllerHandler : AnyObject{
    func configureView(_ view: UIView)
}

protocol ViewModelHandler: AnyObject{
    func loadData()
}
class UnstableViewModel: ViewModelHandler {
    
    let controllerHandler : ControllerHandler?
    
    init(controllerHandler : ControllerHandler){
        self.controllerHandler = controllerHandler
    }
    
    func loadData() {
        let mockView: ProfileHolder = ProfileHolder()
        controllerHandler?.configureView(mockView)
    }
}
