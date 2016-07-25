//
//  ViewController.swift
//  RequestOpenLibrary
//
//  Created by Jonathan Silva on 25/07/16.
//  Copyright © 2016 Coursera. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var textFieldISBN: UITextField!
    @IBOutlet weak var textViewResponse: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func searchBook(sender: AnyObject){
        
        var urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
        urls+=self.textFieldISBN.text!
        let url = NSURL(string: urls)
        let datos: NSData? = NSData(contentsOfURL: url!)
        textViewResponse.text = String(data: datos!, encoding: NSUTF8StringEncoding)
        
    }
    
}

