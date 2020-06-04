//
//  PokemonDetailVC.swift
//  PokedexProject
//
//  Created by Antoine Boxho on 08/11/2016.
//  Copyright © 2016 KaraganApp. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    // MARK: - Properties
    var pokemon: Pokemon!
    @IBOutlet weak var pokemonImg: UIImageView!
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokemonIDLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var evolutionPokemonImg: UIImageView!
    @IBOutlet weak var nextEvolutionLbl: UILabel!
    @IBOutlet weak var currentPokemonImg: UIImageView!
    
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemon.downloadPokemonDetails { 
            // Whatever we call here will be called whenever the network call is comlete
            self.updateUI()
        }
    }
    
    // MARK: - Contoller Logic
    @IBAction func backBtn(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateUI(){
        baseAttackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        weightLbl.text = pokemon.weight
        heightLbl.text = pokemon.height
        pokemonIDLbl.text = "\(pokemon.pokedexId)"
        pokemonImg.image = UIImage(named: "\(pokemon.pokedexId)")
        currentPokemonImg.image = UIImage(named: "\(pokemon.pokedexId)")
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        
        // Checking for cases where there is no evolution
        if pokemon.nextEvoId == ""{
            nextEvolutionLbl.text = "no Evolution"
            evolutionPokemonImg.isHidden = true
        }else{
            evolutionPokemonImg.isHidden = false
            evolutionPokemonImg.image = UIImage(named: pokemon.nextEvoId)
            let str = "Next Evolution: \(pokemon.nextEvoName) - LVL \(pokemon.nextEvoLvl)"
            nextEvolutionLbl.text = str
        }
    }
    
}
