//
//  PokeCell.swift
//  PokedexProject
//
//  Created by Antoine Boxho on 02/11/2016.
//  Copyright © 2016 KaraganApp. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var pokemon: Pokemon!
    
    // MARK: - Setting Cell
    func configureCell(pokemon: Pokemon){
        self.pokemon = pokemon
        thumbImage.image = UIImage(named: "\(self.pokemon.pokedexId)")
        nameLabel.text = self.pokemon.name.capitalized
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // We want to round the corner of the cell so we need to call the requiered initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
}
