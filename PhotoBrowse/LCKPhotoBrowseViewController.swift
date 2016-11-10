//
//  LCKPhotoBrowseViewController.swift
//  PhotoBrowse
//
//  Created by xiaorui on 2016/10/21.
//  Copyright © 2016年 Worktile. All rights reserved.
//

import UIKit

let imagePreviewWindow = UIWindow(frame: UIScreen.main.bounds)

/// 图片连续预览页面
///
/// 参数: 无
///
/// @since 2.6.1
/// @author 李瑞玲
public class LCKPhotoBrowseViewController: UIViewController {
  
  //MARK: - Public
  
  public enum ImageSourceType {
    case none   //图片
    case entity //聊天中的文件
    case drive  //网盘
  }
  
  public var imageSourceID: String? //图片源ID（entityID\fileID等）
  
  public var previewImageViewIntialFrame: CGRect = CGRect.zero
  public var initalImage: UIImage?
  public var detailImageURL: URL?
  public var sourceView: UIView?
  public var imageSourceType: ImageSourceType = .none
  public var sourceData: [String] = []
  public var preViewIndexPath: IndexPath = IndexPath(row: 0, section: 0)
  public var currentIndexPath: IndexPath = IndexPath(row: 0, section: 0)
  
  public class func showImageFromRect(_ initalFrame: CGRect, fromView: UIView, initalImage: UIImage?, detailImageURL: URL?=nil, imageSourceID: String?, imageSourceType: ImageSourceType) -> LCKPhotoBrowseViewController {
    
    var initalFrame = initalFrame
    initalFrame.origin.y += 64
    
    let imagePrevireVC: LCKPhotoBrowseViewController = LCKPhotoBrowseViewController()
    
    imagePrevireVC.previewImageViewIntialFrame = initalFrame
    imagePrevireVC.detailImageURL = detailImageURL
    imagePrevireVC.sourceView = fromView
    imagePrevireVC.imageSourceID = imageSourceID
    imagePrevireVC.imageSourceType = imageSourceType
    imagePrevireVC.initalImage = initalImage
    imagePrevireVC.showImage()
    
    return imagePrevireVC
  }
  
  public func setPhotoBrowse(data: [String], currentIndex: Int) {
    sourceData = data
    preViewIndexPath = IndexPath(row: currentIndex == 0 ? 0 : (currentIndex - 1), section: 0)
    currentIndexPath = preViewIndexPath
    _collectionView.reloadData()
    pageScrollView.contentSize = CGSize(width: CGFloat(_collectionView.numberOfItems(inSection: 0)) * (UIScreen.main.bounds.width + 10), height: 0.1)
    pageScrollView.setContentOffset(CGPoint.init(x: CGFloat(currentIndexPath.row) * (UIScreen.main.bounds.width + 10), y: 0) , animated: false)
  }
  
  func showImage() {
    UIApplication.shared.statusBarStyle = .lightContent
    imagePreviewWindow.rootViewController = self
    imagePreviewWindow.windowLevel = UIWindowLevelStatusBar - 1
    imagePreviewWindow.makeKeyAndVisible()
  }
  
  func hiddenImage() {
    imagePreviewWindow.windowLevel = UIWindowLevelNormal
    imagePreviewWindow.rootViewController = nil
    guard let sourceView = self.sourceView else { return }
    sourceView.window?.makeKeyAndVisible()
  }
  
  
  //MARK: - Property
  
  fileprivate lazy var _previewImageView: UIImageView = {
    return UIImageView()
  }()
  fileprivate var _collectionView: UICollectionView!
  fileprivate var flowlayout: UICollectionViewFlowLayout!
  fileprivate var _toolView: UIView!
  fileprivate var _saveButton: UIButton!
  fileprivate var _shareButton: UIButton!
  fileprivate var pageScrollView: UIScrollView!

  
  //MARK: - Lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    _setupAppearance()
  }
}

extension LCKPhotoBrowseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return sourceData.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: LCKPhotoBrowseCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoBrowseCell", for: indexPath) as! LCKPhotoBrowseCollectionViewCell
    cell.imageView.image = UIImage.init(named: sourceData[indexPath.row])
    cell.tapCancelClosure = { [weak self] in
      self?._dismissViewController()
    }
    cell.longGuestureClosure = { [weak self] in
      self?._showAlterSheet()
    }
    cell.scrollViewBeginScrollActionClosure = { [weak self] in
      self?._hiddenToolView()
    }
    cell.scrollViewEndScrollActionClosure = { [weak self] in
      self?._showToolView()
    }
    return cell
  }
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    _dismissViewController()
  }
}

extension LCKPhotoBrowseViewController: UIScrollViewDelegate {
  public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    _hiddenToolView()
  }
  public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    _showToolView()

    // 将collectionView在控制器view的中心点转化成collectionView上的坐标
    let pInView: CGPoint = view.convert(_collectionView.center, to: _collectionView)
    guard let indexPathNow: IndexPath = _collectionView.indexPathForItem(at: pInView) else { return }
    currentIndexPath = indexPathNow
  }
  //MARK: - UIScrollViewDelegate
  
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == pageScrollView { //ignore collection view scrolling callbacks
      _collectionView.contentOffset.x = scrollView.contentOffset.x
    }
  }

}
extension LCKPhotoBrowseViewController {
  
  //MARK: - Private
  
  fileprivate func _showToolView() {
    let screenHeight = UIScreen.main.bounds.height
    UIView.animate(withDuration: 0.25, animations: {
      self._toolView.frame.origin.y = screenHeight - self._toolView.bounds.height
    })
  }
  
  fileprivate func _hiddenToolView() {
    let screenHeight = UIScreen.main.bounds.height
    UIView.animate(withDuration: 0.25, animations: {
      self._toolView.frame.origin.y = screenHeight
    })
  }
  
  fileprivate func _showAlterSheet() {
    print("长按")
  }
  
  fileprivate func _dismissViewController() {
    if currentIndexPath != preViewIndexPath {
      self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
      UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions(), animations: {
        self.view.transform = CGAffineTransform(scaleX: 2, y: 2)
        self.view.alpha = 0
        }, completion: { (finshed: Bool) in
          self.hiddenImage()
      })
      
    } else {
      _toolView.alpha = 0
      _previewImageView.isHidden = false
      self._collectionView.alpha = 0
      
      UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: {
        self.view.backgroundColor = UIColor.clear
        self._previewImageView.frame = self.previewImageViewIntialFrame
        self._previewImageView.alpha = 0
        
      }) { (finished: Bool) in
       self.hiddenImage()
      }
    }
  }
  
  fileprivate func _setupAppearance() {
    
    view.backgroundColor = UIColor.clear
    
    flowlayout = UICollectionViewFlowLayout.init()
    flowlayout.itemSize = CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    flowlayout.minimumLineSpacing = 10.0
    flowlayout.minimumInteritemSpacing = 0.0
    flowlayout.scrollDirection = .horizontal
    
    _collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: flowlayout)
    _collectionView.showsVerticalScrollIndicator = false
    _collectionView.showsHorizontalScrollIndicator = false
    _collectionView.delegate = self
    _collectionView.dataSource = self
    _collectionView.panGestureRecognizer.isEnabled = false
    _collectionView.register(LCKPhotoBrowseCollectionViewCell.self, forCellWithReuseIdentifier: "photoBrowseCell")
    
    _toolView = UIView()
    _toolView.backgroundColor = UIColor.gray
    
    _saveButton = UIButton()
    _saveButton.setTitle("保存", for: .normal)
    _saveButton.setTitleColor(UIColor.white, for: .normal)
    _saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    
    _shareButton = UIButton()
    _shareButton.setTitle("分享", for: .normal)
    _shareButton.setTitleColor(UIColor.white, for: .normal)
    _shareButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    
    _collectionView.frame = self.previewImageViewIntialFrame
    view.addSubview(_collectionView)

    view.addSubview(_toolView)
    _toolView.snp.makeConstraints { (make) in
      make.leading.bottom.trailing.equalTo(0)
      make.height.equalTo(80)
    }
    
    _toolView.addSubview(_saveButton)
    _saveButton.snp.makeConstraints { (make) in
      make.leading.equalTo(20)
      make.top.bottom.equalTo(0)
      make.width.equalTo(100)
    }
    
    _toolView.addSubview(_shareButton)
    _shareButton.snp.makeConstraints { (make) in
      make.centerY.equalTo(_saveButton.snp.centerY)
      make.width.equalTo(_saveButton.snp.width)
      make.trailing.equalTo(-20)
    }
    
    _previewImageView.frame = previewImageViewIntialFrame
    _previewImageView.image = initalImage
    _previewImageView.contentMode = .scaleAspectFit
//    if let imageOriginalURL = detailImageURL {
//      _previewImageView.lck_setImageWithURL(imageOriginalURL, placeholderImage: initalImage)
//      
//      SDWebImageManager.shared().lck_downloadImageWithURL(imageOriginalURL,
//                                                          options: .highPriority,
//                                                          progress: nil,
//                                                          completed: { (image: UIImage?,
//                                                            error: Error?,
//                                                            cacheType: SDImageCacheType,
//                                                            finished: Bool,
//                                                            imageURL: URL?) -> Void in
//                                                            
//                                                            DispatchQueue.main.async(execute: { () -> Void in
//                                                              self._previewImageView.image = image ?? self.initalImage
//                                                            })
//      })
//    }
    view.insertSubview(_previewImageView, aboveSubview: _collectionView)
    
    pageScrollView = UIScrollView(frame: CGRect(x: -5, y: 0, width: UIScreen.main.bounds.width + 10, height: 0.1))
    pageScrollView.contentSize = CGSize(width: CGFloat(_collectionView.numberOfItems(inSection: 0)) * UIScreen.main.bounds.width + 10, height: 0.1)
    pageScrollView.isPagingEnabled = true
    pageScrollView.delegate = self
    _collectionView.addGestureRecognizer(pageScrollView.panGestureRecognizer)
    _collectionView.removeGestureRecognizer(pageScrollView.panGestureRecognizer)

    view.addSubview(pageScrollView)
    _setPageable(true)

    _collectionView.alpha = 0
    _toolView.alpha = 0
    
    UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions(), animations: {
      self.view.backgroundColor = UIColor.black
      self._previewImageView.frame = self.view.frame
      self._collectionView.frame = self.view.frame
      self._toolView.alpha = 1
    }) { (finshed: Bool) in
      self._previewImageView.snp.makeConstraints({ (make) in
        make.top.leading.bottom.trailing.equalTo(0)
      })
      self._previewImageView.isHidden = true
      self._collectionView.alpha = 1
      self._collectionView.snp.makeConstraints { (make) in
        make.top.leading.bottom.trailing.equalTo(0)
      }
    }
  }
}
extension LCKPhotoBrowseViewController {
  
  public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    
//    if size.width > size.height {
//      screenWidth = UIScreen.main.bounds.height
//      screenHeight = UIScreen.main.bounds.width
//    }
//    UIView.animate(withDuration: coordinator.transitionDuration, animations: {
    self.flowlayout.itemSize = CGSize.init(width: screenWidth, height: screenHeight)
      self._collectionView.frame.size.width = screenWidth
      self._collectionView.frame.size.height = screenHeight
//    })
    self._collectionView.collectionViewLayout.invalidateLayout()
//    self._collectionView.reloadData()
    pageScrollView.frame = CGRect.init(x: -5, y: 0, width: screenWidth + 10, height: 0.1)
    pageScrollView.contentSize = CGSize(width: CGFloat(_collectionView.numberOfItems(inSection: 0)) * (screenWidth + 10), height: 0.1)
    pageScrollView.setContentOffset(CGPoint.init(x: CGFloat(currentIndexPath.row) * (screenWidth + 10), y: 0) , animated: false)
  }
  
  fileprivate func _setPageable(_ pageable: Bool) {
    if pageable {
      _collectionView.addGestureRecognizer(pageScrollView.panGestureRecognizer)
    } else {
      _collectionView.removeGestureRecognizer(pageScrollView.panGestureRecognizer)
    }
    
    _collectionView.panGestureRecognizer.isEnabled = false
    _collectionView.showsHorizontalScrollIndicator = false
  }
}

