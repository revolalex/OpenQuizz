//
//  ViewController.swift
//  OpenQuizz
//
//  Created by Alexandre RODRIGUEZ on 17/02/2020.
//  Copyright © 2020 Alexandre Rodriguez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gameOverImage: UIImageView!
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionView: QuestionView!
    @IBOutlet weak var answerIs: UILabel!
    
    //permet de communiquer avec le modele (via propriété)
    var game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        let name = Notification.Name(rawValue: "QuestionsLoaded")
        //on se branche à la notification dés que le controleur est chargé - addObserver
        // selector permet de passer en parametre une fonction #selector(nomDeLaFonction)
        NotificationCenter.default.addObserver(self, selector: #selector(questionsLaded), name: name, object: nil)
        
        startNewgame()
        
        // reconnaitre les geste: (UIPanGestureRecogniser)
        // 1-Cible, 2-Action, 3-Vue
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
        // onprécise la vue qui doit détecter le geste
        questionView.addGestureRecognizer(panGestureRecognizer)
    }
    
    
    @objc func questionsLaded() {
        activityIndicator.isHidden = true
        newGameButton.isHidden = false
        
        // affiche la premiere question de la partie
        questionView.title = game.currentQuestion.title
        
    }

    @IBAction func didTapNewGameButton() {
        startNewgame()
    }
    
    private func startNewgame() {
        gameOverImage.isHidden = true
        activityIndicator.isHidden = false
        newGameButton.isHidden = true
        questionView.title = "Loading..."
        questionView.style = .standard
        scoreLabel.text = "0/10"
       
        
        // télécharge de nouvelles questions
        game.refresh()
        
    }
    
    @IBAction func dragQuestionView(_ sender: UIPanGestureRecognizer) {
        // seulement si le jeux est en cours
        if game.state == .ongoing {
            switch sender.state {
            // état de notre geste
            case .began, .changed:
                // la vue suis le geste
                transformQuestionViewWith(gesture: sender)
            // état de notre geste
            case .cancelled, .ended:
                // enregistre la réponse choisi et propose la suivante
                answerQuestion()
            default:
                break
            }
        }
    }
    
    private func transformQuestionViewWith(gesture: UIPanGestureRecognizer) {
        // récupere la translation du doigt sur l'écran
        let translation = gesture.translation(in: questionView)
        
        // on créer une transformation avec comme parametre la translation du doigt, la vue suis donc le doigt
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        
        // on récupère la largeur de l'écran
        let screenWidth = UIScreen.main.bounds.width
        
        // permet de savoir ou on est par rapport au bors de l'écran
        let translationPercent = translation.x / (screenWidth / 2)
        
        let rotationAngle = (CGFloat.pi / 6 ) * translationPercent
        
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        
        // on combine les 2 transformation  (translate et rotation)
        let transform = translationTransform.concatenating(rotationTransform)
        
        // on affecte la transformation à la vue
        questionView.transform = transform
        
        // si x est positif la vue est déplacé vers la droite
        if translation.x > 0 {
            questionView.style = .correct
        } else {
            questionView.style = .incorrect
        }
    }
    
    private func answerQuestion() {
        //envoie la réponse au modele
        switch questionView.style {
        case .correct:
            game.answerCurrentQuestion(with: true)
        case .incorrect:
            game.answerCurrentQuestion(with: true)
        case .standard:
            break
        }
        
        answerIs.text = "\(game.answerIsA)"
        scoreLabel.text = "\(game.score) / 10"
        
        // animation permettant de faire sortir la question par les bords de l'écran
        // on récupère la largeur de l'écran
        let screenWidth = UIScreen.main.bounds.width
        
        // création de la transformation
        var translationTransform: CGAffineTransform
        
        // translaction à droite ou à gauche en fonction de la réponse choisi
        if questionView.style == .correct{
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
            // droite
        } else {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0) // gauche
        }
        
        // création de l'animation
        UIView.animate(withDuration: 0.3, animations: {
                self.questionView.transform = translationTransform
            }, completion: { (success) in
                if success { // vérification si animation terminé
                    self.showQuestionView()
                }
            })
        }
    
    private func showQuestionView () {
        // ramene la vue a sa place d'origine
        questionView.transform = .identity
        
        //reduit la taille de la vue (trés petit 0.01)
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        // la vue est standard donc de couleur grise
        questionView.style = .standard
        
        // affiche la nouvele question
        questionView.title = game.currentQuestion.title
        
        //Aprés dix réponse affiche Game Over
        switch game.state {
        case .ongoing:
            questionView.title = game.currentQuestion.title
        case .over:
            questionView.title = "Game Over"
            gameOverImage.isHidden = false
            gameOverImage.transform = CGAffineTransform(scaleX: 3, y: 3)
  
        }
        
        // animation de l'affichage de la question effet ressort "Boing"
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.questionView.transform = .identity
        }, completion: nil)
    }
    
//    func changeBackgroundColor () {
//        UIView.animate(withDuration: 0.7) {
//            if self.questionView.style == .correct {
//                self.view.backgroundColor = #colorLiteral(red: 0.4816305637, green: 1, blue: 0.5521656275, alpha: 1)
//            } else {
//                self.view.backgroundColor = #colorLiteral(red: 0.9534618258, green: 0.5292481184, blue: 0.5808439851, alpha: 1)
//            }
//        }
//    }
//
 
    
}

