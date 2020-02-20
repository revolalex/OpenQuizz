//
//  QuestionView.swift
//  OpenQuizz
//
//  Created by Alexandre RODRIGUEZ on 18/02/2020.
//  Copyright © 2020 Alexandre Rodriguez. All rights reserved.
//

import UIKit

class QuestionView: UIView {
    
    @IBOutlet private var label: UILabel!
    @IBOutlet private var icon: UIImageView!
    
    // Différent post-it des questions
    enum Style {
        case correct, incorrect, standard
    }
    
    // Observation des propriéte : Dés que style est modifié la fonction setStyle modifie l'apparence en focntion du style sélectionné
    var style: Style = .standard {
        didSet {
            setStyle(style)
        }
    }
    
    private func setStyle(_ style: Style) {
        switch style {
        case .correct:
            backgroundColor = #colorLiteral(red: 0.4816305637, green: 1, blue: 0.5521656275, alpha: 1) // color litéral
            icon.image = UIImage(named: "Icon Correct")
            icon.isHidden = false
        case .incorrect:
            backgroundColor = #colorLiteral(red: 0.9534618258, green: 0.5292481184, blue: 0.5808439851, alpha: 1)
            icon.image = UIImage(named: "Icon Correct")
            icon.isHidden = false
        case .standard:
            backgroundColor = #colorLiteral(red: 0.747472167, green: 0.7676818967, blue: 0.7890835404, alpha: 1)
            icon.isHidden = true
        }
        
    }
    
    // dés que title est modifié le texte du label aussi
    var title = "" {
        didSet {
            label.text = title
        }
    }
    
}
