 //
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by Sambhav Jain on 10/9/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    
    let myRefreshControl = UIRefreshControl()
    
    @IBOutlet var tweetTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfTweets = 20
        loadTweetsTable()
        myRefreshControl.addTarget(self, action: #selector(loadTweetsTable), for: .valueChanged)
        self.tweetTable.refreshControl =  myRefreshControl
        self.loadTweetsTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweetsTable()
    }
    
    
    
    @objc func loadTweetsTable() {
        numberOfTweets = 20
        let myParams = ["count": 10 ]
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success:
         { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
         }, failure: { (Error) in
                print("Could not retrieve tweets!")
        })
    }
    
    func loadMoreTweets() {
        
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets = numberOfTweets + 20
        let myParams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success:
         { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
         }, failure: { (error) in
            print(error.localizedDescription)
            print("Could not retrieve tweets!")
        })
    }
    
   
    /*
      If the user gets to the end of the page load more tweets.
     
     */
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // When we get to the end of the page run more tweets 
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
       
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        
        let imageUrl = URL(string: (user["profile_image_url_https" as? String]) as! String)
        let data = try? Data(contentsOf: imageUrl!)
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
       
        }
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        
        return cell

    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, r     return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

    

}
