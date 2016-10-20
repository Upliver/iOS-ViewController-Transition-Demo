//
//  PopViewController.swift
//  NavigationControllerTransitionDemo
//
//  Created by seedante on 15/12/9.
//  Copyright © 2015年 seedante. All rights reserved.
//

import UIKit

class PopViewController: UIViewController {
    
    let edgePanGesture = UIScreenEdgePanGestureRecognizer()
    var navigationDelegate: SDENavigationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "StackTop"
        // Do any additional setup after loading the view.
        edgePanGesture.edges = .left
        edgePanGesture.addTarget(self, action: #selector(PopViewController.handleEdgePanGesture(_:)))
        view.addGestureRecognizer(edgePanGesture)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    func handleEdgePanGesture(_ gesture: UIScreenEdgePanGestureRecognizer){
        let translationX =  gesture.translation(in: view).x
        let translationBase: CGFloat = view.frame.width / 3
        let translationAbs = translationX > 0 ? translationX : -translationX
        let percent = translationAbs > translationBase ? 1.0 : translationAbs / translationBase
        switch gesture.state{
        case .began:
            navigationDelegate = self.navigationController?.delegate as? SDENavigationDelegate
            
            if let navDelegate = navigationDelegate {
                navDelegate.interactive = true
            }
            
            if let vc = self.navigationController {
                vc.popViewController(animated: true)
            }            
            
        case .changed:
            navigationDelegate?.interactionController.update(percent)
        case .cancelled, .ended:
            if percent > 0.5{
                navigationDelegate?.interactionController.finish()
            }else{
                navigationDelegate?.interactionController.cancel()
            }
            navigationDelegate?.interactive = false
        default: break
        }
    }
    
    @IBAction func popMe(_ sender: AnyObject) {
        print(self.navigationController!.view)
        if let vc = self.navigationController {
            vc.popViewController(animated: true)
        }
    }

    deinit{
        edgePanGesture.removeTarget(self, action: #selector(PopViewController.handleEdgePanGesture(_:)))
    }

}
