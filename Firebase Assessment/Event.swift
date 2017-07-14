//
//  Event.swift
//  Firebase Assessment
//
//  Created by David Kleyman on 7/13/17.
//  Copyright © 2017 David Kleyman. All rights reserved.
//

import UIKit

class Event{
    
    private var _name: String!
    private var _image: UIImage!
    private var _price: String!
    private var _address: String!
    private var _time: String!
    
    var id: String!
    

    var name: String{
        if _name == nil{
            return ""
        }else{
            return _name
        }
    }
    
    var image: UIImage{
        if _image == nil{
            return #imageLiteral(resourceName: "NoImage")
        }else{
            return _image
        }
    }
    
    var price: String{
        if _price == nil{
            return ""
        }else{
            return _price
        }
    }
    
    var address: String{
        if _address == nil{
            return ""
        }else{
            return _address
        }
    }
    
    var time: String{
        if _time == nil{
            return ""
        }else{
            return _time
        }
    }
    
    init(name: String, image: UIImage, price: String, address: String, time: String){
        self._name = name
        self._image = image
        self._price = price
        self._address = address
        self._time = time
    }
    
    func setID(id: String){
        self.id = id
    }
    
    
}
