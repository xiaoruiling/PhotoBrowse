//
//  LCKPhotoBrowseCollectionViewCell.swift
//  PhotoBrowse
//
//  Created by xiaorui on 2016/10/21.
//  Copyright © 2016年 Worktile. All rights reserved.
//

import UIKit

class LCKPhotoBrowseCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Public
  
  var imageView: UIImageView
  var backScrollView: UIScrollView
  var scrollViewBeginScrollActionClosure: (() -> Void)?
  var scrollViewEndScrollActionClosure: (() -> Void)?
  var tapCancelClosure: (() -> Void)?
  var longGuestureClosure: (() -> Void)?
		
		
  override init(frame: CGRect) {

    backScrollView = UIScrollView()
    backScrollView.showsHorizontalScrollIndicator = false
    backScrollView.showsVerticalScrollIndicator = false
    backScrollView.maximumZoomScale = 4
    backScrollView.minimumZoomScale = 1
    backScrollView.backgroundColor = UIColor.clear
    
    imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit

    super.init(frame: frame)
    
    backScrollView.delegate = self
    
    let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
    backScrollView.addGestureRecognizer(tapGestureRecognizer)
    
    let longGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(longAction(_:)))
    backScrollView.addGestureRecognizer(longGestureRecognizer)
    
    let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(tapAction(_:)))
    swipeUp.direction = .up
    backScrollView.addGestureRecognizer(swipeUp)
    
    let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(tapAction(_:)))
    swipeDown.direction = .down
    backScrollView.addGestureRecognizer(swipeDown)

    contentView.addSubview(backScrollView)
    backScrollView.snp.makeConstraints { (make) in
      make.top.leading.trailing.bottom.equalTo(0)
    }
    
    backScrollView.addSubview(imageView)
    imageView.snp.makeConstraints { (make) in
      make.top.leading.equalTo(0)
      make.centerX.equalTo(backScrollView.snp.centerX)
      make.centerY.equalTo(backScrollView.snp.centerY)
//      make.width.equalTo(UIScreen.main.bounds.width)
//      make.height.equalTo(UIScreen.main.bounds.height)
    }
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
}

extension LCKPhotoBrowseCollectionViewCell {
  
  @objc fileprivate func tapAction(_ tap: UIGestureRecognizer) {
    tapCancelClosure?()
  }
  
  @objc func longAction(_ longGesture: UIGestureRecognizer) {
    longGuestureClosure?()
  }
}

extension LCKPhotoBrowseCollectionViewCell: UIScrollViewDelegate {
  
  //MARK: - UIScrollViewDelegate
  
  public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
  public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
  }
  
  public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    scrollViewEndScrollActionClosure?()
  }
  
  public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
    scrollViewBeginScrollActionClosure?()

  }
  
  public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    scrollViewEndScrollActionClosure?()
  }
}
