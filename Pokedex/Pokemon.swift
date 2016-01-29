//
//  Pokemon.swift
//  Pokedex
//
//  Created by Aris Doxakis on 1/26/16.
//  Copyright © 2016 DASoftware. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defence: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonUrl: String!
    
    var name: String {
        if _name == nil {
            _name = ""
        }
        return _name
    }
    var pokedexId: Int {
        if _pokedexId == nil {
            _pokedexId = 0
        }
        return _pokedexId
    }
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    var defence: String {
        if _defence == nil {
            _defence = ""
        }
        return _defence
    }
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
    }
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    var pokemonUrl: String {
        if _pokemonUrl == nil {
            _pokemonUrl = ""
        }
        return _pokemonUrl
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name;
        self._pokedexId = pokedexId
        self._pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        let url = NSURL(string: self._pokemonUrl)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            switch response.result {
            case .Success:
                if let dict = response.result.value as? Dictionary<String, AnyObject> {
                    
                    if let weight = dict["weight"] as? String {
                        self._weight = weight
                    }
                    
                    if let height = dict["height"] as? String {
                        self._height = height
                    }
                    
                    if let attack = dict["attack"] as? Int {
                        self._attack = "\(attack)"
                    }
                    
                    if let defence = dict["defence"] as? Int {
                        self._defence = "\(defence)"
                    }
                    
                    if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                        if let name = types[0]["name"] {
                            self._type = name.capitalizedString
                        }
                        
                        if types.count > 1 {
                            for var x = 1; x < types.count; x++ {
                                if let name = types[x]["name"] {
                                   self._type! += "/\(name.capitalizedString)"
                                }
                            }
                        }
                    } else {
                        self._type = ""
                    }
                    
                    if let descrArr = dict["descriptions"] as? [Dictionary<String,String>] where descrArr.count > 0{
                        if let url = descrArr[0]["resource_uri"] {
                            let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                            
                            Alamofire.request(.GET, nsurl).responseJSON { response in
                                switch response.result {
                                    case .Success:
                                        if let descr = response.result.value as? Dictionary<String,AnyObject> {
                                            if let description = descr["description"] as? String {
                                                self._description = description                                            }
                                        }
                                    
                                        completed()
                                    case .Failure(let error):
                                        print(error)
                                }
                            }
                        }
                        
                    } else {
                        self._description = ""
                    }
                    
                    if let evolutionArr = dict["evolutions"] as? [Dictionary<String,AnyObject>] where evolutionArr.count > 0 {
                        if let to = evolutionArr[0]["to"] as? String {
                            if to.rangeOfString("mega") == nil {
                                if let uri = evolutionArr[0]["resource_uri"] as? String {
                                    let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                    let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                    
                                    self._nextEvolutionId = num
                                    self._nextEvolutionText = to
                                    
                                    if let level = evolutionArr[0]["level"] as? Int?{
                                        self._nextEvolutionLevel = "\(level)"
                                    }
                                }
                            }
                        }
                    }
                    
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
}