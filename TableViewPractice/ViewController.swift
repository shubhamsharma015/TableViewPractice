//
//  ViewController.swift
//  TableViewPractice
//
//  Created by shubham sharma on 27/11/23.
//

//Modal

struct StateNameWithSection {
    var sectionTitle : String
    var stateNames : [String]
}



import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stateTableView: UITableView!
    
    let statesOfIndia = ["Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh", "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jharkhand", "Karnataka", "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Odisha", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh", "Uttarakhand", "West Bengal", "Jammu and Kashmir", "Ladakh", "Delhi", "Puducherry", "Chandigarh", "Dadra and Nagar Haveli and Daman and Diu", "Lakshadweep", "Andaman and Nicobar Islands"]
    
    var statesWithSection = [StateNameWithSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        statesWithSection = self.creatingArrayWithSection(stateNames: statesOfIndia)
        print(statesWithSection)
        
    }


}

// Implementing table view

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        statesOfIndia.count
        statesWithSection[section].stateNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = stateTableView.dequeueReusableCell(withIdentifier: "states") as! NameOfStateViewCell
         
//        cell.stateNameLabel.text = statesOfIndia[indexPath.row]
        cell.stateNameLabel.text = statesWithSection[indexPath.section].stateNames[indexPath.row]
        return cell

    }
    

}

// Implementing Header View

extension ViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        statesWithSection.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = .gray
        
        let label = UILabel(frame: CGRect(x: 15, y: -5, width: tableView.frame.width, height: 40))
        label.textColor = .black
        label.text = statesWithSection[section].sectionTitle
        headerView.addSubview(label)
        
        return headerView
        
    }
    
    
//    function
    
    func creatingArrayWithSection( stateNames: [String] ) -> [StateNameWithSection] {
        
        var stateNamesArray = [String]()
        var arrayOfStateWithSection = [StateNameWithSection]()
        
        let alphabets = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
        
//        Logic
        
        for alphabet in alphabets {
            for stateName in stateNames {
                
                if stateName.hasPrefix(alphabet){
                    stateNamesArray.append(stateName)
                }else {
                    continue
                }
                
            }
          
            if !stateNamesArray.isEmpty {
                let stateNamesWithSection = StateNameWithSection(sectionTitle: alphabet, stateNames: stateNamesArray)
                arrayOfStateWithSection.append(stateNamesWithSection)
                stateNamesArray = []
            }
            
        }
        
        return arrayOfStateWithSection
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        tableView.sectionIndexColor = .darkText
        tableView.sectionIndexBackgroundColor = .lightGray
        
        return statesWithSection.compactMap({ $0.sectionTitle })
    }
    
}

extension ViewController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, _, complition) in
            self?.showDeleteAlert(at: indexPath)
        }
        
        let updateAction = UIContextualAction(style: .normal, title: "update") { [weak self] (action, _, complition) in
            self?.showUpdateAlert(at: indexPath)
        }
        updateAction.backgroundColor = .blue
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }
    
    func showDeleteAlert(at indexPath : IndexPath){
        let alert = UIAlertController(title: "Delete Item", message: "Are you sure to delete this row", preferredStyle: .alert)
        let cancelBtn = UIAlertAction(title: "Cancle", style: .cancel)
        let okBtn = UIAlertAction(title: "Ok", style: .destructive) { [weak self] action in
            self?.deleteItem(at: indexPath)
        }
        
        alert.addAction(cancelBtn)
        alert.addAction(okBtn)
        
        present(alert, animated: false)
    }
    
    func deleteItem(at indexPath: IndexPath){
        stateTableView.beginUpdates()
        statesWithSection[indexPath.section].stateNames.remove(at: indexPath.row)
        stateTableView.deleteRows(at: [indexPath], with: .automatic)
        stateTableView.endUpdates()
    }
    
    func showUpdateAlert(at indexPath: IndexPath){
        let alert = UIAlertController(title: "UpdateItem", message: "Enter new item here", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "enter here....."
        }
        
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel)
        
        let okBtn = UIAlertAction(title: "OK", style: .default) { [weak self] action in
            if let alertTextField = alert.textFields?.first , let newValue = alertTextField.text {
                self?.statesWithSection[indexPath.section].stateNames[indexPath.row] = newValue
                self?.stateTableView.reloadRows(at: [indexPath], with: .automatic)
                
            }
        }
        
        alert.addAction(cancelBtn)
        alert.addAction(okBtn)
        present(alert, animated: true)
    }
    
}

extension ViewController{
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,previewProvider: nil) { action in
            let deleteAction = UIAction(title: NSLocalizedString("Delete", comment: ""),image: UIImage(systemName: "trash"),attributes: .destructive) { [weak self] _ in
                self?.deleteItem(at: indexPath)
            }
            
            let copyAction = UIAction(title: "Copy",image: UIImage(systemName: "doc.on.doc")) { _ in
                let textToCopy = self.statesWithSection[indexPath.section].stateNames[indexPath.row]
                UIPasteboard.general.string = textToCopy
            }
            return UIMenu(children: [deleteAction,copyAction])
        }
    }
}
