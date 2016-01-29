//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Aris Doxakis on 1/26/16.
//  Copyright © 2016 DASoftware. All rights reserved.
//

import UIKit
import Alamofire

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenceLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var pokedexLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var currentEvoImage: UIImageView!
    @IBOutlet weak var nextEvoImage: UIImageView!
    @IBOutlet weak var evoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = pokemon.name
        mainImage.image = UIImage(named: "\(pokemon.pokedexId)")
        
        pokemon.downloadPokemonDetails { () -> () in
            // This will be called after download is done!!
            self.updateUI()
        }
    }
    
    func updateUI() {
        self.heightLabel.text = self.pokemon.height
        self.weightLabel.text = self.pokemon.weight
        self.descriptionLabel.text = self.pokemon.description
        self.typeLabel.text = self.pokemon.type
        self.defenceLabel.text = self.pokemon.defence
        self.pokedexLabel.text = "\(self.pokemon.pokedexId)"
        self.attackLabel.text = self.pokemon.attack
        
        if self.pokemon.nextEvolutionId == "" {
            evoLabel.text = "No Evolutions"
            nextEvoImage.hidden = true
        } else {
            nextEvoImage.image = UIImage(named: "\(self.pokemon.nextEvolutionId)")
            nextEvoImage.hidden = false
            var str = "Next Evolution: \(pokemon.nextEvolutionText)"
            
            if pokemon.nextEvolutionLevel != "" {
                str += " - LVL \(pokemon.nextEvolutionLevel)"
            }
            
            evoLabel.text = str
        }
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
