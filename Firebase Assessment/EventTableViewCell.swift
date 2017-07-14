//
//  EventTableViewCell.swift
//  Firebase Assessment
//
//  Created by David Kleyman on 7/13/17.
//  Copyright © 2017 David Kleyman. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(event: Event){
        eventImage.image = event.image
        eventName.text = event.name
        eventTime.text = event.time
        eventPrice.text = event.price
    }
    
}
