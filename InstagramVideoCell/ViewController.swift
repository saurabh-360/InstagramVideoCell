//
//  ViewController.swift
//  EditSoftDemo
//
//  Created by Saurabh Yadav on 31/01/17.
//  Copyright © 2017 Saurabh Yadav. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var avPlayer: AVPlayer!
    var visibleIP : IndexPath?
    var aboutToBecomeInvisibleCell = -1
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    var videoURLs = Array<URL>()
    var firstLoad = true
    
    @IBOutlet weak var feedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.delegate = self
        feedTableView.dataSource = self
        for i in 0..<2{
            let url = Bundle.main.url(forResource:"\(i+1)", withExtension: "mp4")
            videoURLs.append(url!)
        }
        visibleIP = IndexPath.init(row: 0, section: 0)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 290
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 3 == 1{
            let cell = self.feedTableView.dequeueReusableCell(withIdentifier: "videoCell") as! VideoCellTableViewCell
            cell.videoPlayerItem = AVPlayerItem.init(url: videoURLs[indexPath.row % 2])
            return cell
        }else{
            let cell = self.feedTableView.dequeueReusableCell(withIdentifier: "imageCell") as! ImageTableViewCell
            cell.imageView?.image = UIImage.init(named: "user")
            cell.imageView?.contentMode = .scaleAspectFit
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
  
    func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: kCMTimeZero)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indexPaths = self.feedTableView.indexPathsForVisibleRows
        var cells = [Any]()
        for ip in indexPaths!{
            if let videoCell = self.feedTableView.cellForRow(at: ip) as? VideoCellTableViewCell{
                cells.append(videoCell)
            }else{
                let imageCell = self.feedTableView.cellForRow(at: ip) as! ImageTableViewCell
                    cells.append(imageCell)
            }
        }
        let cellCount = cells.count
        if cellCount == 0 {return}
        if cellCount == 1{
            print ("visible = \(indexPaths?[0])")
            if visibleIP != indexPaths?[0]{
                visibleIP = indexPaths?[0]
            }
            if let videoCell = cells.last! as? VideoCellTableViewCell{
                self.playVideoOnTheCell(cell: videoCell, indexPath: (indexPaths?.last)!)
            }
        }
        if cellCount >= 2 {
            for i in 0..<cellCount{
                let cellRect = self.feedTableView.rectForRow(at: (indexPaths?[i])!)
                let completelyVisible = self.feedTableView.bounds.contains(cellRect)
                let intersect = cellRect.intersection(self.feedTableView.bounds)

                let currentHeight = intersect.height
                print("\n \(currentHeight)")
                let cellHeight = (cells[i] as AnyObject).frame.size.height
                if currentHeight > (cellHeight * 0.95){
                    if visibleIP != indexPaths?[i]{
                        visibleIP = indexPaths?[i]
                        print ("visible = \(indexPaths?[i])")
                        if let videoCell = cells[i] as? VideoCellTableViewCell{
                            self.playVideoOnTheCell(cell: videoCell, indexPath: (indexPaths?[i])!)
                        }
                    }
                }
                else{
                    if aboutToBecomeInvisibleCell != indexPaths?[i].row{
                        aboutToBecomeInvisibleCell = (indexPaths?[i].row)!
                        if let videoCell = cells[i] as? VideoCellTableViewCell{
                            self.stopPlayBack(cell: videoCell, indexPath: (indexPaths?[i])!)
                        }
                        
                    }
                }
            }
        }
    }

    func checkVisibilityOfCell(cell : VideoCellTableViewCell, indexPath : IndexPath){
        let cellRect = self.feedTableView.rectForRow(at: indexPath)
        let completelyVisible = self.feedTableView.bounds.contains(cellRect)
        if completelyVisible {
            self.playVideoOnTheCell(cell: cell, indexPath: indexPath)
        }
        else{
            if aboutToBecomeInvisibleCell != indexPath.row{
                aboutToBecomeInvisibleCell = indexPath.row
                self.stopPlayBack(cell: cell, indexPath: indexPath)
            }
        }
    }
    
    func playVideoOnTheCell(cell : VideoCellTableViewCell, indexPath : IndexPath){
        cell.startPlayback()
    }
    
    func stopPlayBack(cell : VideoCellTableViewCell, indexPath : IndexPath){
        cell.stopPlayback()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("end = \(indexPath)")
        if let videoCell = cell as? VideoCellTableViewCell{
            videoCell.stopPlayback()
        }

        paused = true
    }
    
    

}
