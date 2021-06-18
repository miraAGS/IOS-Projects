//
//  ViewController.swift
//  bgTasks
//

import UIKit
import BackgroundTasks

class ViewController: UIViewController {
  
  @IBOutlet weak var image: UIImageView!
  @IBOutlet weak var name: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    registerForNotifications()
    fetchPokemon(id: 10)
  }
  
  func registerForNotifications() {
    NotificationCenter.default.addObserver(
      forName: .newPokemonFetched,
      object: nil,
      queue: nil) { (notification) in
        print("notification received")
        if let uInfo = notification.userInfo,
           let pokemon = uInfo["pokemon"] as? Pokemon {
          self.updateWithPokemon(pokemon)
        }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
  }
  
  func fetchPokemon(id: Int) {
    PokeManager.pokemon(id: id) { (pokemon) in
      self.name.text = pokemon.species.name
      PokeManager.downloadImage(url: pokemon.sprites.backDefault!) { (image) in
        self.image.image = image
      }
    }
  }
  
  func updateWithPokemon(_ pokemon: Pokemon) {
    name.text = pokemon.species.name
    PokeManager.downloadImage(url: pokemon.sprites.backDefault!) { (image) in
      self.image.image = image
    }
  }
}
