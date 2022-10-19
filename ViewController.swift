//
//  ViewController.swift
//  MyBff
//
//  Created by Carme on 18/10/2022.
//

import UIKit

class ViewController: UIViewController, ChatViewDelegate {
    func chatDidSend(text: String) {
        message = text
        setImageSentiment(message: message)
        
        
    }
    

    @IBOutlet var avatarIA: UIImageView!
  
    var message: String = ""
    
    private let sentime = SentimentsRecognizer()
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chatViewController = segue.destination as? ChatViewController {
            chatViewController.delegate = self
        }
    }
    
   
    
    
    
    func setImageSentiment(message : String) {
    
        var sentimentsReco = SentimentsRecognizer()
        var sentiment = sentimentsReco.predictSentiment(from: message)
        print(sentiment)
        switch sentiment{
        case .sad:
            avatarIA.image = Sentiments.sad.imageAI
        case .neutral:
            avatarIA.image = Sentiments.neutral.imageAI
        case .happy:
            avatarIA.image = Sentiments.happy.imageAI
        }
    }
}
