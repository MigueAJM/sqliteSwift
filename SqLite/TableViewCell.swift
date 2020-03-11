//
//  TableViewCell.swift
//  SqLite
//
//  Created by Jose-Omar-GM on 3/4/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var lbnombre: UILabel!
    
    @IBOutlet weak var lbemail: UILabel!
    
    @IBOutlet weak var lbp: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
