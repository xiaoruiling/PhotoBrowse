

//
//  SecondViewController.swift
//  PhotoBrowse
//
//  Created by xiaorui on 2016/10/24.
//  Copyright © 2016年 Worktile. All rights reserved.
//

import UIKit


public class SecondViewController: UIViewController {
  
  public class func showVC() -> SecondViewController  {
    let vc: SecondViewController = SecondViewController()
    vc.show1()
    return vc
  }
  func show1()  {
    let imagePreviewWindow = UIWindow(frame: UIScreen.main.bounds)
    UIApplication.shared.statusBarStyle = .lightContent
    imagePreviewWindow.rootViewController = self
    imagePreviewWindow.windowLevel = UIWindowLevelStatusBar - 1
    imagePreviewWindow.makeKeyAndVisible()
  }
    override public func viewDidLoad() {
        super.viewDidLoad()
      view.backgroundColor = UIColor.orange

        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
