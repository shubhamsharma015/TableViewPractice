//
//  NameOfStateViewCell.swift
//  TableViewPractice
//
//  Created by shubham sharma on 27/11/23.
//

import UIKit

class NameOfStateViewCell: UITableViewCell {

    @IBOutlet weak var stateNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
