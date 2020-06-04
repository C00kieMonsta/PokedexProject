//
//  RoundedImage.swift
//  ModelViewController
//
//  Created by Antoine Boxho on 31/10/2016.
//  Copyright © 2016 KaraganApp. All rights reserved.
//

import UIKit

class RoundedImage: UIImageView {
    
    // Similar to ViewDidLoad
    override func awakeFromNib() {
        self.layer.cornerRadius = 20.0
        self.layer.masksToBounds = true
    }
    
}
