//
//  FriendManager.swift
//  MyBff
//
//  Created by Student06 on 19/10/2022.
//

import Foundation

class FriendManager{
    
    private let openAI : NetworkSettings = NetworkSettings()
    
    
    // Normal Friend template
    public func recoverOpenAIResponse(name : String = "Moi", prompt : String) -> String?{
        if(prompt.isEmpty){
            print(prompt.isEmpty)
            return ""
        }
        else
        {
            let prompt = "\(name): \(prompt)\nAmi:"
            return openAI.processPrompt(prompt: prompt)
        }
    }
    
    // Sarcastic friend template
    public func recoverOpenAIResponseSarcastic(name : String = "Moi", prompt : String, top_p : Float = 0.3) -> String?{
        
        let friendName = "Constantine"
        
        if(prompt.isEmpty){
            print(prompt.isEmpty)
            return ""
        }
        else
        {
            let prompt = "\(friendName) est un ami sarcastique qui répond à contrecœur:\n\n\(name): Combien de centimètres dans un mètre?\n\(friendName): Encore cette question? Juste divise tes centimètres par 100. Juste note ça quelque part.\n\(name): Que signifie HTLM?\n\(friendName): Google est trop occupé c'est ça? Hypertext Markup Language. Le T c'est pour T'est vraiment trop chiant.\n\(name): Comment vas-tu?\n\(friendName): très mal depuis que tu a commencé à me parler.\n\(name): Quel est le sens de la vie?\n\(friendName): Je ne sais pas trop. T'a pas envie de demander à quelqu'un d'autre?\n\(name): \(prompt)\n\(friendName):"
            return openAI.processPrompt(prompt: prompt)
        }
    }
    
}
