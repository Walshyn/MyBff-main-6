//
//  ViewController.swift
//  MessageKitTest
//
//  Created by Student01 on 19/10/2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView

protocol ChatViewDelegate{
    func chatDidSend(text : String)
    
}

class ChatViewController: MessagesViewController, InputBarAccessoryViewDelegate {
    
    var delegate: ChatViewDelegate?
    // Some global variables for the sake of the example. Using globals is not recommended!
    let moi = Sender(senderId: "moi", displayName: "Moi")
    let ami = Sender(senderId: "ami", displayName: "Ami")
    var messages: [MessageType] = []
    private let friendManager : FriendManager = FriendManager()
    
    func changeUser() -> Sender {
        if (currentSender as? Sender == moi ){
            return ami
        }
        return moi
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        delegate?.chatDidSend(text: text)
        let message = Message(sender: moi, messageId: UUID().uuidString, sentDate: Date(), kind: .text(text))
        messages.append(message)
        let message2 = Message(sender: self.ami, messageId: UUID().uuidString, sentDate: Date(), kind: .text("..."))
        messages.append(message2)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3){
            self.messages.removeLast()
            let message3 = Message(sender: self.ami, messageId: UUID().uuidString, sentDate: Date(), kind: .text(self.sendMessageGetResponse(message: text)))
            self.messages.append(message3)
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToLastItem(animated: true)
        }
        
        
        
        messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToLastItem(animated: true)
    }
    
    func sendMessageGetResponse(message : String) -> String{
        let response = friendManager.recoverOpenAIResponse(prompt: message) ?? ""
        return response
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self

    }
}

extension ChatViewController : MessagesDataSource{
    var currentSender: SenderType {
            
            return Sender(senderId: "moi", displayName: "Moi")
        }

        func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
            return messages.count
        }

        func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
            return messages[indexPath.section]
        }
}
extension ChatViewController: MessagesLayoutDelegate{
    
}
extension ChatViewController: MessagesDisplayDelegate{
    
}
public struct Message: MessageType {
    public var sender: MessageKit.SenderType
    
    public var messageId: String
    
    public var sentDate: Date
    
    public var kind: MessageKind
}
public struct Sender: SenderType, Equatable {
    public let senderId: String

    public let displayName: String
}


