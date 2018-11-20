//
//  ViewController.swift
//  EachNavigationBar
//
//  Created by Pircate on 04/19/2018.
//  Copyright (c) 2018 Pircate. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 1000)
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var tipLabel: UILabel = {
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
        lable.center = view.center
        lable.textAlignment = .center
        lable.text = "上下滑动试试"
        return lable
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(scrollView)
        view.addSubview(tipLabel)
        
        navigation.bar.statusBarStyle = .lightContent
        navigation.bar.setBackgroundImage(#imageLiteral(resourceName: "nav"), for: .default)
        
        navigation.item.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(rightBarButtonAction))
        navigation.item.title = "Home"
        navigation.bar.titleTextAttributes = [
            .foregroundColor: UIColor.blue,
            .font: UIFont.systemFont(ofSize: 24)]
        
        let backButton = UIButton(type: .custom)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(UIColor.red, for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(backBarButtonAction), for: .touchUpInside)
        navigation.item.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        // if you want change navigation bar position
        navigation.bar.isUnrestoredWhenViewWillLayoutSubviews = true
        
        if #available(iOS 11.0, *) {
            navigation.bar.prefersLargeTitles = true
        }
    }
    
    @objc private func backBarButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func rightBarButtonAction() {
        navigationController?.pushViewController(NextViewController(), animated: true)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let statusBarMaxY = UIApplication.shared.statusBarFrame.maxY
        let originY = -scrollView.contentOffset.y + statusBarMaxY
        if originY <= statusBarMaxY {
            if originY > -49 {
                let alpha = 1 - (scrollView.contentOffset.y) / 49
                if #available(iOS 11.0, *) {
                    navigation.bar.setLargeTitleAlpha(alpha)
                }
                navigation.bar.largeTitleAdditionalHeight = originY
            } else {
                let minY = statusBarMaxY - navigation.bar.frame.height
                if originY + 49 > minY {
                    navigation.bar.frame.origin.y = originY + 49
                } else {
                    navigation.bar.setTitleAlpha(0)
                    navigation.bar.setTintAlpha(0)
                    navigation.item.leftBarButtonItem?.customView?.alpha = 0
                    navigation.bar.frame.origin.y = minY
                }
            }
        } else {
            if #available(iOS 11.0, *) {
                navigation.bar.setLargeTitleAlpha(1)
            }
            navigation.bar.setTitleAlpha(1)
            navigation.bar.setTintAlpha(1)
            navigation.item.leftBarButtonItem?.customView?.alpha = 1
            navigation.bar.largeTitleAdditionalHeight = 0
            navigation.bar.frame.origin.y = statusBarMaxY
        }
    }
}
