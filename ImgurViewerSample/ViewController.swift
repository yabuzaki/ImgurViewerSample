//
//  ViewController.swift
//
//
//  Created by Yuta on 2015/12/20.
//  Copyright © 2015年 Yabuzaki Yuta. All rights reserved.
//

import UIKit
import PagingMenuController

class ViewController: UIViewController, PagingMenuControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let words = ["cat","dog","hamster","rabbit", "bear", "penguin", "giraffe"]
        let viewControllers = words.reduce([ImgurViewController]()) { (var array , word) in
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("imgurVC") as! ImgurViewController
            vc.tagWord = word
            vc.title = word
            array.append(vc)
            return array
        }
        
        let options = PagingMenuOptions()
        options.font = UIFont(name: "Avenir Next", size: 17)!
        options.selectedFont = options.font
        options.menuHeight = 40
        options.menuDisplayMode = .Standard(widthMode: .Flexible, centerItem: false, scrollingMode: .ScrollEnabled)
        options.menuItemMode = .RoundRect(radius: 7, horizontalPadding: 4, verticalPadding: 4, selectedColor: UIColor.purpleColor())
        options.selectedTextColor = UIColor.whiteColor()
        
        let pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
        pagingMenuController.view.frame.origin.y += 15
        pagingMenuController.view.frame.size.height -= 15
        self.addChildViewController(pagingMenuController)
        self.view.addSubview(pagingMenuController.view)
        pagingMenuController.didMoveToParentViewController(self)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - PagingMenuControllerDelegate
    
    func willMoveToMenuPage(page: Int) {
    }
    
    func didMoveToMenuPage(page: Int) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
