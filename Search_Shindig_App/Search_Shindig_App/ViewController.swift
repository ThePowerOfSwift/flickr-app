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
    var activityIndicator = UIActivityIndicatorView()

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        tableData.removeAll()
        pauseApp()
        view.endEditing(true)
        
        search(searchText: searchBar.text!) { (success) in
            if success {
                
                self.table.reloadData()
                self.restoreApp()
                
            } else {
                
                self.restoreApp()
                
                let alertController = UIAlertController(title: "Oops...", message: "Error has occurred", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    
                }))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    func pauseApp() {
    
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        activityIndicator.center = self.view.center
        
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents() // Changed UIApplication.shared() to UIApplication.shared
    
    }
    
    func restoreApp() {
        
        activityIndicator.stopAnimating()
        
        UIApplication.shared.endIgnoringInteractionEvents() // Changed UIApplication.shared() to UIApplication.shared
        
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return Array(tableData.keys).count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! QueryResultTableViewCell
        
        if Array(tableData.keys).count > 0 {
        
            cell.thumbnailTitle.text = Array(tableData.keys)[indexPath.row]
            cell.thumbnail.image = tableData[Array(tableData.keys)[indexPath.row]]?.image

        }
        
        return cell
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let currentCell = tableView.cellForRow(at: indexPath) as! QueryResultTableViewCell
        
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
    
    func search(searchText: String, completionHandler: @escaping (_ success: Bool) -> Void)
    {
        
        var success = false
    
        let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=29fd4744809cf869f303930c8825538c&format=json&nojsoncallback=1&text=" + searchText)

        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                
                print(error!)
                
            } else {
                
                if let urlContent = data {
                    
                    do {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
                        
                        if let photosArray = jsonResult["photos"]?["photo"] as? [[String: AnyObject]] {
                            
                            if photosArray.count > 0 {
                                
                                var i = 0
                                
                                for photos in photosArray {
                                    
                                    if i < 25 {   // Only pull 25
                                        
                                        let farm = photos["farm"] as? Int
                                        let id = photos["id"] as?  String
                                        let secret = photos["secret"] as? String
                                        let server = photos["server"] as? String
                                        let title = photos["title"] as? String
                                        
                                        //self.tableData[title!] = UIImageView(image: #imageLiteral(resourceName: "Check Mark.png"))
                                        
                                        self.getThumbnailImage(title: title!, farm: farm!, server: server!, id: id!, secret: secret!, completionHandler: { (sucess) in
                                         
                                         completionHandler(success)
                                         
                                         })
                                        
                                        i += 1   // add 1 to number of pics
                                        
                                    }
                                    
                                }

                                success = true
                                
                            }
                            
                        } else {
                            
                            print("ERROR")
                            
                        }
                        
                    } catch {
                        
                        print("Error processing data")
                        
                    }
                    
                }
                
            }
            
            DispatchQueue.main.sync(execute: {
                
                completionHandler(success)
                
            })
    
        }
        task.resume()
        
    }
    
    func getThumbnailImage(title: String, farm: Int, server: String, id: String, secret: String, completionHandler: @escaping (_ success: Bool) -> Void) {
    
        print("Getting thumbnail")
    
        var success = false
        
        let url = URL(string: "https://c5.staticflickr.com/\(farm)/" + server + "/" + id + "_" + secret + ".jpg")
        
        print(url!)
        
        let request = NSMutableURLRequest(url: url!)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                
                print(error!)
                
            } else {
                
                if let data = data {
                    
                    if let iconImage = UIImage(data: data) {
                        
                        self.tableData[title] = UIImageView(image: iconImage)
                        success = true
                        
                    }
                    
                }
                
            }
            
            DispatchQueue.main.sync(execute: {
                
                completionHandler(success)
                
            })
        
        }
        task.resume()
    
    }
    
    func getFullImage(title: String, farm: Int, server: String, id: String, secret: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        
        print("Getting thumbnail")
        
        var success = false
        
        let url = URL(string: "https://c5.staticflickr.com/\(farm)/" + server + "/" + id + "_" + secret + ".jpg")
        
        print(url!)
        
        let request = NSMutableURLRequest(url: url!)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                
                print(error!)
                
            } else {
                
                if let data = data {
                    
                    if let iconImage = UIImage(data: data) {
                        
                        self.tableData[title] = UIImageView(image: iconImage)
                        success = true
                        
                    }
                    
                }
                
            }
            
            DispatchQueue.main.sync(execute: {
                
                completionHandler(success)
                
            })
            
        }
        task.resume()
        
    }
    
}

