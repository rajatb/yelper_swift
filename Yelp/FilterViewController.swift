//
//  FilterViewController.swift
//  Yelp
//
//  Created by Rajat Bhargava on 9/22/17.
//  Copyright © 2017 RNR. All rights reserved.
//

import UIKit

struct SectionStruct {
    var headerTitle: String = ""
    var cellType: String?
    var data: [(String, Any)]?
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let dealsSection: SectionStruct = SectionStruct(headerTitle: "Deals", cellType: "switchCell",
                                                    data:[("Offering Deals", true)])
    let distanceSection: SectionStruct = SectionStruct(headerTitle: "Distance", cellType: "filterCell",
                                                       data:[("5 miles", "5"), ("10 miles", "10") ])
    
    
    var sections: [Int:SectionStruct]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        sections = [0: dealsSection, 1: distanceSection]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
 
    @IBAction func onSave(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: - TableView Setup
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       return sections?[section]?.data!.count ?? 0
        
    }

    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section_index = indexPath.section
        var cell: UITableViewCell?
        let cellType = sections?[section_index]?.cellType ?? "filterCell"
        

        
        switch cellType {
        case "filterCell":
            cell = tableView.dequeueReusableCell(withIdentifier: "filterCell") as! FilterCell
        case "switchCell":
            cell = tableView.dequeueReusableCell(withIdentifier: "switchCell") as! SwitchCell
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "filterCell") as! FilterCell
        }
        
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.red.cgColor
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
