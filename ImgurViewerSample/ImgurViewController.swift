//
//  ViewController.swift
//  
//
//  Created by Yuta on 2015/12/19.
//  Copyright © 2015年 Yabuzaki Yuta. All rights reserved.
//

import UIKit
import SafariServices
import Alamofire
import SwiftyJSON
import SDWebImage

public struct ImageInfo {
    public var title: String = ""
    public var link: String = ""
    public var score: Int = 0
    public var views: Int = 0
    public var id: String = ""
    public var animated:Bool = false
    public var thumbnailLink : String {
        get {
            return "http://i.imgur.com/" + id + "m.jpg"
        }
    }
}

class ImgurViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let imgurCliendId = "" // Get Client ID https://api.imgur.com/
    
    var imageInfos = [ImageInfo]()
    var tagWord = "cat"
    var loading = false
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 36))
        footerView.backgroundColor = UIColor.whiteColor()
        let activity = UIActivityIndicatorView(frame: CGRect(x: footerView.frame.width/2 - 15, y: footerView.frame.height/2 - 15, width: 30, height: 30))
        activity.activityIndicatorViewStyle = .Gray
        activity.startAnimating()
        footerView.addSubview(activity)
        tableView.tableFooterView = footerView
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        if loading { return }
        loading = true
        
        if imgurCliendId == "" {
            print("imgurClientId is empty.")
            return
        }
        
        Alamofire.request(.GET, "https://api.imgur.com/3/gallery/t/" + tagWord.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())! + "/viral/" + String(page), headers: ["Authorization": "Client-Id \(imgurCliendId)"])
            .response { request, response, data, error in

                var json = JSON.null
                if error == nil && data != nil {
                    json = SwiftyJSON.JSON(data: data!)
                }
                
                for (_, item) in json["data"]["items"] {
                    //print(item)
                    if item["is_album"].bool == true { continue }
                    
                    var imageInfo = ImageInfo()
                    imageInfo.title = item["title"].string ?? ""
                    imageInfo.link = item["link"].string ?? ""
                    imageInfo.score = item["score"].int ?? 0
                    imageInfo.views = item["views"].int ?? 0
                    imageInfo.id = item["id"].string ?? ""
                    imageInfo.animated = item["animated"].bool ?? false
                    self.imageInfos.append(imageInfo)
                }
                
                self.loading = false
                self.page++
                self.tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomTableViewCell
        let imageInfo = imageInfos[indexPath.row]
        cell.photoImageView.sd_setImageWithURL(NSURL(string: imageInfo.thumbnailLink)!)
        cell.titleLabel.text = imageInfo.title
        cell.favoriteLabel.text = "♥︎" + String(imageInfo.score)
        cell.gifLabel.hidden = !imageInfo.animated
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageInfos.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let imageInfo = imageInfos[indexPath.row]
        let imgurURL = "https://imgur.com/" + imageInfo.id
        if #available(iOS 9.0, *) {
            let safariVC = SFSafariViewController(URL: NSURL(string: imgurURL)!)
            navigationController?.pushViewController(safariVC, animated: true)
        } else {
            let vc = UIViewController()
            let webView = UIWebView(frame: vc.view.frame)
            vc.view.addSubview(webView)
            webView.loadRequest(NSURLRequest(URL: NSURL(string: imgurURL)!))
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // scrolled to the bottom
        if tableView.contentOffset.y >= tableView.contentSize.height - tableView.bounds.size.height {
            loadData()
        }
    }
}

