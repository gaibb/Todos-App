//
//  TodoCell.swift
//  Todos
//
//  Created by gaibb on 2020/7/3.
//  Copyright © 2020 gaibb. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var checkMark: UILabel!
    @IBOutlet weak var todo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
