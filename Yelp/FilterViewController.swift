//
//  FilterViewController.swift
//  Yelp
//
//  Created by Rajat Bhargava on 9/22/17.
//  Copyright © 2017 RNR. All rights reserved.
//

import UIKit

@objc protocol FilterViewControllerDelegate {
  @objc optional func filterViewController(filterViewController: FilterViewController, didUpdateFilters filter: [String: Any])
}

struct SectionStruct {
    var headerTitle: String = ""
    var cellType: String?
    var data: [(String, Any)]?
    var results: [Int: Bool]=[Int: Bool]()
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let dealsSection: SectionStruct = SectionStruct(headerTitle: "Deals", cellType: "switchCell",
                                                    data:[("Offering Deals", "Offering Deals")],
                                                    results:[Int: Bool]())
    let distanceSection: SectionStruct = SectionStruct(headerTitle: "Distance", cellType: "filterCell",
                                                       data:[("Auto", ""), ("0.2 miles", "0.2"),
                                                             ("1 mile", "1"), ("5 miles", "5"),
                                                             ("10 miles", "10"), ("20 miles", "20")],
                                                       results:[Int: Bool]())
    let sortBySection: SectionStruct = SectionStruct(headerTitle: "SortBy", cellType: "filterCell",
                                                       data:[("Best Match", YelpSortMode.bestMatched), ("Distance", YelpSortMode.distance),
                                                             ("Highest Rates", YelpSortMode.highestRated)],
                                                       results:[Int: Bool]())
    let categorySection: SectionStruct = SectionStruct(headerTitle: "Category", cellType: "switchCell",
                                                    data:[("African", "african"), ("Afghan", "afghani"),
                                                          ("American", "tradamerican"),("Arabic","Arabian"), ("Indian", "indpak")],
                                                    results:[Int: Bool]())
    
    
    var sections: [Int:SectionStruct]?
    
    weak var delegate: FilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        sections = [0: dealsSection, 1: distanceSection, 2: sortBySection, 3: categorySection]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
 
    @IBAction func onSave(_ sender: Any) {
        var filters = [String:Any]()
        
        //Get Deals
        let isDeal = sections?[0]?.results[0]
        filters["deals"] = isDeal
        
        //Get categories
        var categories = [String]()
        let results = sections?[3]?.results
        for (index, isSelected) in results! {
            if isSelected{
                categories.append(sections?[3]?.data?[index].1 as! String)
            }
        }
        if categories.count > 0 {
            filters["categories"] = categories
        }
        //Add the categories in filter if more that 0
        delegate?.filterViewController?(filterViewController: self, didUpdateFilters: filters)
        //print(sections?[3]?.results)
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: - TableView Setup
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       return sections?[section]?.data!.count ?? 0
        
    }

    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section_index = indexPath.section
        let row = indexPath.row
        var cell: UITableViewCell?
        let cellType = sections?[section_index]?.cellType ?? "filterCell"
        
        
        switch cellType {
        case "filterCell":
            cell = tableView.dequeueReusableCell(withIdentifier: "filterCell")
            let filterCell = cell as! FilterCell
            filterCell.displayLabel.text = sections?[section_index]?.data?[row].0
            let checked = sections?[section_index]?.results[row] ?? false
            if checked {
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            } else {
                cell?.accessoryType = UITableViewCellAccessoryType.none
            }
        case "switchCell":
            cell = tableView.dequeueReusableCell(withIdentifier: "switchCell")
            let switchCell = cell as! SwitchCell
            switchCell.delegate = self
            
            switchCell.displayLabel.text = sections?[section_index]?.data?[row].0
            switchCell.onSwitch.isOn = sections?[section_index]?.results[row] ?? false
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "filterCell") as! FilterCell
        }
        
        cell?.layer.borderWidth = 1.0
        cell?.layer.borderColor = UIColor.gray.cgColor
        cell?.layer.cornerRadius = 5
        
//        switch section_index {
//        case 1:
//            //cell = tableView.dequeueReusableCell(withIdentifier: "filterCell") as! FilterCell
//        case 2:
//           // cell = tableView.dequeueReusableCell(withIdentifier: "switchCell") as! SwitchCell
//        default:
//            //cell = tableView.dequeueReusableCell(withIdentifier: "switchCell") as! SwitchCell
//        }
        return cell!
    }
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections?.count ?? 0
        
    }
    

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections?[section]?.headerTitle
    }
    
    // MARK: - SwitchCell Delegate
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool){
        let indexPath = tableView.indexPath(for: switchCell)
        let section_index = indexPath?.section
        let row = indexPath?.row
        //results[row!] = value
        sections?[section_index!]?.results[row!] = value
        
        //get the value fo the selected switch
        let value: String = sections?[section_index!]?.data![row!].1 as! String
        print("The value selected is:\(value)")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
