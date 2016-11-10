
//
//  LCKPhotoBrowseFlowLayout.swift
//  PhotoBrowse
//
//  Created by xiaorui on 2016/10/24.
//  Copyright © 2016年 Worktile. All rights reserved.
//

import UIKit

public class LCKPhotoBrowseFlowLayout: UICollectionViewFlowLayout {
  
  override init() {
    super.init()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    var offsetAdjustment = CGFloat.greatestFiniteMagnitude
//    let horizontalOffset = proposedContentOffset.x + ((UIScreen.main.bounds.width - self.itemSize.width) / 2)
    let horizontalOffset = proposedContentOffset.x + 10

    let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: self.collectionView?.frame.width ?? 0, height: self.collectionView?.frame.height ?? 0)
    let array = super.layoutAttributesForElements(in: targetRect)
    
    for layoutAttributes in array! {
      let itemOffset = layoutAttributes.frame.origin.x
      if (abs(itemOffset - horizontalOffset) < abs(offsetAdjustment)) {
        offsetAdjustment = itemOffset - horizontalOffset
      }
    }
    
    return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
  }

}
