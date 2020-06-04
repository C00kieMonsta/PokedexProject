//
//  PokedexVC.swift
//  PokedexProject
//
//  Created by Antoine Boxho on 02/11/2016.
//  Copyright © 2016 KaraganApp. All rights reserved.
//

import UIKit
import AVFoundation

typealias completed = () -> ()

class PokedexVC: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    let cellIdentifier = "cell"
    var pokemonArray = [Pokemon]()
    var filteredPokemonArray = [Pokemon]()
    var searchMode = false
    var musicPlayer: AVAudioPlayer!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting of collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Settings of searchbar
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        // Update Pokemon array
        parsePokemonCSV {
            self.collectionView.reloadData()
            initAudio()
        }
        
    }
    
    // MARK: - Controller Logic
    func parsePokemonCSV(completion: completed){
        // Create path to CSV file
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            for row in rows{
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let pokemon = Pokemon(name: name, id: pokeId)
                pokemonArray.append(pokemon)
            }
        }catch let error as NSError{
            print(error.debugDescription)
        }
        completion()
    }
    
    func initAudio(){
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        let musicURL = URL(string: path)!
        
        // AudioPlayer can throw an error so we need a way to catch it
        do {
            // Here we initialise musicPlayer
            musicPlayer = try AVAudioPlayer(contentsOf: musicURL)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1 // Infinite
            musicPlayer.play()
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    @IBAction func musiceBtn(_ sender: UIButton) {
        if musicPlayer.isPlaying{
            musicPlayer.pause()
            sender.alpha = 0.2
        }else{
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
}

// MARK: - Extensions
extension PokedexVC: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchMode{
            return filteredPokemonArray.count
        }else{
            return pokemonArray.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PokeCell else {return PokeCell()}
        let pokemon: Pokemon!
        if searchMode{
            pokemon = filteredPokemonArray[indexPath.row]
        }else{
            pokemon = pokemonArray[indexPath.row]
        }
        cell.configureCell(pokemon: pokemon)
        return cell
    }
    
}

extension PokedexVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var pokemon: Pokemon!
        if searchMode{
            pokemon = filteredPokemonArray[indexPath.row]
            performSegue(withIdentifier: "PokemonDetailVC", sender: pokemon)
        }else{
            pokemon = pokemonArray[indexPath.row]
            performSegue(withIdentifier: "PokemonDetailVC", sender: pokemon)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC"{
            if let destination = segue.destination as? PokemonDetailVC{
                if let pokemon = sender as? Pokemon{
                    destination.pokemon = pokemon
                }
            }
        }
    }
    
}

// This protocol is used to modify the layout of the collection view
extension PokedexVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
}

extension PokedexVC: UISearchBarDelegate{
    // When the text in the searchbar changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            searchMode = false
            collectionView.reloadData()
            view.endEditing(true)
        }else{
            searchMode = true
            let loweredSearch = searchBar.text!.lowercased()
            filteredPokemonArray = pokemonArray.filter({ $0.name.range(of: loweredSearch) != nil})
            collectionView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
