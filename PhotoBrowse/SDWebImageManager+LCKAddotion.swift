//
//  SDWebImageManager+LCKAddotion.swift
//  LessChatKit
//
//  Created by darui on 16/3/17.
//  Copyright © 2016年 Worktile. All rights reserved.
//

extension SDWebImageManager {
  
  /**
   下载Worktile Box图片
   */
  @discardableResult
  public func lck_downloadImageWithURL(_ url: URL!, options: SDWebImageOptions, progress progressBlock: SDWebImageDownloaderProgressBlock!, completed completedBlock: SDWebImageCompletionWithFinishedBlock!) -> SDWebImageOperation! {
    
    let headers = LCCNetworkingObject.currentTeamHTTPHeaderFields()
    for key in (headers?.keys)! {
      SDWebImageManager.shared().imageDownloader.setValue(headers?[key] as! String, forHTTPHeaderField: key as! String)
    }
    
    return downloadImage(with: url, options: options, progress: progressBlock, completed: completedBlock)
  }
}
