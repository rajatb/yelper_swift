//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, UIScrollViewDelegate, FilterViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    
    var businesses: [Business]!
    let refreshControl = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
    
    var isMoreDataLoading = false
    var searchTerm: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        
        configSearchBar()
        
        getData(term: "Thai")
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
        // MARK: -Network Calls
    func getData(term: String){
        // If any previous calls are still going
        MBProgressHUD.hide(for: self.view, animated: true)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        searchTerm = term
   
        Business.searchWithTerm(term: term, offset: 0, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        )
    }
    
    func getDataInfiniteScroll(){
        Business.searchWithTerm(term: self.searchTerm!, offset: self.businesses?.count ?? 0, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            if let businesses = businesses {
                self.businesses? += businesses
            }
            self.isMoreDataLoading = false
            self.tableView.reloadData()
        }
        )
    }
    
    // MARK: - CONFIG
    
    func configSearchBar(){
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        
//        let filterButton: UIBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: nil)
//        self.navigationItem.leftBarButtonItem = filterButton
        
        
    }
    
    // MARK: - Search Bar
    public func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            print("Search Text: \(searchText)")
            getData(term: searchText)
        }
        
    }
    
    // MARK: - Table View
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
//        if let businesses = businesses {
//            return businesses.count
//        } else {
//            return 0
//        }
        guard (businesses != nil) else {
            return 0
        }
        return businesses.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessCell
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Scrolling Code
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading){
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                getDataInfiniteScroll()
            }
        }
    }
    
    // MARK: - Delegate
    func filterViewController(filterViewController: FilterViewController, didUpdateFilters filter: [String: Any]){
        let categories = filter["categories"] as? [String]
        let isDeal = filter["deals"] as? Bool
        let sortBy = filter["sortBy"] as! YelpSortMode
        let distance = filter["distance"] as! Int
       
        // If any previous calls are still going
        MBProgressHUD.hide(for: self.view, animated: true)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Business.searchWithTerm(term: "Resturants", offset: 0, sort: sortBy, categories: categories, deals: isDeal, radius: distance) { (businesses, error) in
            self.businesses = businesses
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filterViewController = navigationController.topViewController as! FilterViewController
        filterViewController.delegate = self
    }
    
    
}
