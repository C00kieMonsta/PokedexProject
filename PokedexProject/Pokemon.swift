//
//  Pokemon.swift
//  PokedexProject
//
//  Created by Antoine Boxho on 02/11/2016.
//  Copyright © 2016 KaraganApp. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon{
    
    // MARK: - Properties
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _pokemonURL: String!
    private var _nextEvoTxt: String!
    private var _nextEvoName: String!
    private var _nextEvoId: String!
    private var _nextEvoLvl: String!
    
    // MARK: - Getters for private properties
    var name: String{
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String{
        if _description == nil{
            _description = ""
        }
        return _description
    }
    
    var type: String{
        if _type == nil{
            _type = ""
        }
        return _type
    }
    
    var defense: String{
        if _defense == nil{
            _defense = ""
        }
        return _defense
    }
    
    var height: String{
        if _height == nil{
            _height = ""
        }
        return _height
    }
    
    var weight: String{
        if _weight == nil{
            _weight = ""
        }
        return _weight
    }
    
    var attack: String{
        if _attack == nil{
            _attack = ""
        }
        return _attack
    }
    
    
    var pokemonURL: String{
        return _pokemonURL
    }
    
    var nextEvoTxt: String{
        if _nextEvoTxt == nil{
            _nextEvoTxt = ""
        }
        return _nextEvoTxt
    }
    
    var nextEvoName: String{
        if _nextEvoName == nil{
           _nextEvoName = ""
        }
        return _nextEvoName
    }
    
    var nextEvoId: String{
        if _nextEvoId == nil{
            _nextEvoId = ""
        }
        return _nextEvoId;
    }
    
    var nextEvoLvl: String{
        if _nextEvoLvl == nil{
            _nextEvoLvl = ""
        }
        return _nextEvoLvl
    }
    
    
    // MARK: - Constructor
    init(name: String, id: Int) {
        self._name = name
        self._pokedexId = id
        self._pokemonURL = "\(BASE_URL)\(POKEMON_URL)\(self.pokedexId)"
    }
    
    
    /*
        We don't want to call all 718 pokemons in one call, so we don't want to make 718 network calls right off the bat. Instead, whenever we click on one pokemon, than we want to do this network call for this specific pokemon and call down that data. That is called lazy loading
     */
    
    /*
        Network calls are asynchronous, meaning we don't know exactly when these are going to be completed, so in our PokemonDetailVC, we can't just start setting the labels inside the viewDidLoad
     
        What we want to do is a way to let the VC know when that data will be available. We will do that by using a closure
     */
    
    
    func downloadPokemonDetails(completed: @escaping DownloadCompleted){
        
        // First API call
        Alamofire.request(pokemonURL, method: .get).responseJSON{
            response in
            
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject>{
                if let weight = dict["weight"] as? String{
                    self._weight = weight
                }
                if let height = dict["height"] as? String{
                    self._height = height
                }
                if let attack = dict["attack"] as? Int{
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int{
                    self._defense = "\(defense)"
                }
                
                // Extract types
                if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0{
                    
                    // Adding first type
                    if let name1 = types[0]["name"]{
                        self._type = name1.capitalized
                    }
                    
                    // Adding more types if count > 1
                    if types.count > 1{
                        for x in 1..<types.count{
                            if let name = types[x]["name"]{
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                }
                
                // Extract description
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>], descArr.count > 0{
                    if let url = descArr[0]["resource_uri"]{
                        
                        // Create full url
                        let newURL = "\(BASE_URL)\(url)"
                        
                        // Second API call
                        Alamofire.request(newURL, method: .get).responseJSON{
                            response in
                            if let descDict = response.result.value as? Dictionary<String, AnyObject>{
                                if let description = descDict["description"] as? String{
                                    
                                    // This is some bug in the API, we fix it by replacing every POKMON word with Pokemon
                                    let newDesc = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDesc
                                }
                            }
                            // If we don't put this, we won't see the desc
                            completed()
                        }
                    }
                }else{
                    self._description = "";
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0 {
                    if let nextEvo = evolutions[0]["to"] as? String{
                        // We don't want the mega evolution because we did not take these into account
                        if nextEvo.range(of: "mega") == nil {
                            self._nextEvoName = nextEvo
                            
                            // Instead of doing a second API call, we simply extract the id from the uri which corresponds to the pokeId
                            if let uri = evolutions[0]["resource_uri"] as? String{
                                let newString = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newString.replacingOccurrences(of: "/", with: "")
                                self._nextEvoId = nextEvoId
                                
                                // Extract the level if evolution
                                if let lvlExists = evolutions[0]["level"]{
                                    if let lvl = lvlExists as? Int{
                                        self._nextEvoLvl = "\(lvl)"
                                    }
                                }else{
                                    self._nextEvoLvl = ""
                                }
                            }
                            
                        }else{
                            // We don't want to keep going with mega
                        }
                    }
                }
                
            }
            
            // Calling the closure for the first API call, we need a second one for the other API call
            completed()
        }
    }
    
    
    
    
    
}









