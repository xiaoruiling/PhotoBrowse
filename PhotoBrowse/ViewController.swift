//
//  ViewController.swift
//  PhotoBrowse
//
//  Created by xiaorui on 2016/10/21.
//  Copyright © 2016年 Worktile. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBAction func liulanAction(_ sender: AnyObject) {
    let btn: UIButton = sender as! UIButton
    
    let data: [String] = ["photo1.jpg", "photo2.jpg", "photo3.jpg", "photo4.jpg", "photo5.jpg", "photo6.jpg", "photo7.jpg", "photo8.jpg"]
    
//    let btnFrame: CGRect = btn.convert(btn.frame, to: view)
    
    let photoBrowseVc: LCKPhotoBrowseViewController = LCKPhotoBrowseViewController.showImageFromRect(btn.frame, fromView: view, initalImage: UIImage.init(named: "photo1.jpg"), imageSourceID: "", imageSourceType: .none)
    photoBrowseVc.setPhotoBrowse(data: data, currentIndex: 1)
  }
  
  @IBAction func secondAction(_ sender: AnyObject) {
    _ = SecondViewController.showVC()
    
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

