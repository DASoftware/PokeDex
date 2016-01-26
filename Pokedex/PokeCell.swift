//
//  PokeCell.swift
//  Pokedex
//
//  Created by Aris Doxakis on 1/26/16.
//  Copyright © 2016 DASoftware. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    required init? (coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    func configureCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        self.nameLbl.text = self.pokemon.name.capitalizedString
        self.thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
}
