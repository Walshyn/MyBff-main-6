//
//  SentimentsRecognizer.swift
//  MyBff
//
//  Created by Carme on 19/10/2022.
//

import Foundation
import CoreML

final class SentimentsRecognizer{
    private enum Error: Swift.Error{
        case featuresMissing
    }
    
    private let model = SentimentMdlFull()
    private let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation, .omitOther]
    private lazy var tagger: NSLinguisticTagger = .init(
        tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "fr"),
        options: Int(self.options.rawValue))
    
    
    // MARK: - Prediction
    
    func predictSentiment(from text: String) -> Sentiments{
        do{
            let inputFeatures = features(from: text)
            // Prediction works with at least 2 words
            guard text.count > 1 else{
                throw Error.featuresMissing
            }
            
            let output = try model.prediction(input: .init(text: text))
            switch output.featureValue(for: "label") {
            case MLFeatureValue(string: "positive"):
                return .happy
            case MLFeatureValue(string: "negative"):
                return .sad
            default:
                return .neutral
            }
        }catch{
            return .neutral
        }
    }
}

// MARK: - Features

private extension SentimentsRecognizer{
    func features(from text: String) -> [String: Double]{
        var wordCounts = [String: Double]()
        
        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)
        
        tagger.enumerateTags(in: range, scheme: .nameType, options: options){ _, tokenRange, _, _ in
            let token = (text as NSString).substring(with: tokenRange).lowercased()
            guard token.count >= 3 else
            {
                return
            }
            if let value = wordCounts[token]{
                wordCounts[token] = value + 1.0
            }else {
                wordCounts[token] = 1.0
            }
        }
        return wordCounts
    }
}
