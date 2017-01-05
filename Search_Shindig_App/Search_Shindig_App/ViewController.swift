//
//  ViewController.swift
//  Search_Shindig_App
//
//  Created by Kyle Stewart on 1/3/17.
//  Copyright © 2017 Kyle Stewart. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var tableData = [String: UIImageView] ()
    
    var selectedThumbnailTitle = ""
    var selectedThumbnailImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        search(searchText: searchBar.text!)
        
    }

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 25
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! QueryResultTableViewCell
        
        cell.thumbnailTitle.text = "TEST \(indexPath.row)"
        cell.thumbnail.image = #imageLiteral(resourceName: "Check Mark.png")
        
        return cell
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let currentCell = tableView.cellForRow(at: indexPath) as! QueryResultTableViewCell
        
        print(currentCell.thumbnailTitle!.text!)
        selectedThumbnailImage = currentCell.thumbnail
        selectedThumbnailTitle = currentCell.thumbnailTitle.text!
   
        self.performSegue(withIdentifier: "showImagePopup", sender: self)
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showImagePopup" {
            
            let nextSegue = (segue.destination as! ThumbnailImageViewController)
            
            nextSegue.selectedThumbnailTitle = selectedThumbnailTitle
            nextSegue.selectedThumbnailImage = selectedThumbnailImage
            
        }
        
        
    }
    
    func search(searchText: String)
    {
    
        let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=29fd4744809cf869f303930c8825538c&format=json&nojsoncallback=1&text=" + searchText)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                
                print(error!)
                
            } else {
                
                if let urlContent = data {
                    
                    do {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
                        
                        if let photosArray = jsonResult["photos"]?["photo"] as? [[String: AnyObject]] {
                            
                             for photos in photosArray {
                                
                             let farm = photos["farm"] as? Int
                             let id = photos["id"] as?  String
                             let secret = photos["secret"] as? String
                             let server = photos["server"] as? String
                             let title = photos["title"] as? String
                             
                                
                                getThumbnailImage(farm: farm!, server: server!, id: id!, secret: secret)
                                
                                self.tableData[title!] = nil
                                
                             print("Farm = \(farm!)")
                             print("ID = " + id!)
                             print("Secret = " + secret!)
                             print("Server = " + server!)
                             print("Title = " + title!)
                             
                             }
                            
                        } else {
                            
                            print("ERROR")
                            
                        }
                        
                    } catch {
                        
                        print("Error processing data")
                        
                    }
                    
                }
                
            
            }
    
        }
        task.resume()
    }
    
    func getThumbnailImage(farm: Int, server: String, id: String, secret: Int) {
    
        
    
    }
        
    

}

