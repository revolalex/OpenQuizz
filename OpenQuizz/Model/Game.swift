//
//  Game.swift
//  OpenQuizz
//
//  Created by Alexandre RODRIGUEZ on 17/02/2020.
//  Copyright © 2020 Alexandre Rodriguez. All rights reserved.
//

import Foundation


class Game {
    
    // MARK: - Attributes
    
    var score = 0
    var answerIsA = ""
    private var questions = [Question]()
    private var currentIndex = 0
    var state: State = .ongoing

    // MARK: - Initializers
    
    enum State {
        case ongoing, over
    }

    var currentQuestion: Question {
        return questions[currentIndex]
    }

    func refresh() {
        score = 0
        currentIndex = 0
        answerIsA = ""
        state = .over
        
        
        // fermeture permet de recevoir la question
        QuestionManager.shared.get {(questions) in
            self.questions = questions
            self.state = .ongoing
            
            // notification comme une radio (émetteur)
            let name = Notification.Name(rawValue: "QuestionsLoaded") // nom de ma radio
            let notification = Notification(name: name) // création de la notification
            NotificationCenter.default.post(notification) // envoie la notification
        }
    }

    func answerCurrentQuestion(with answer: Bool) {
        if (currentQuestion.isCorrect && answer) || (!currentQuestion.isCorrect && !answer) {
            score += 1
            answerIsA += "✅"
        } else {
            answerIsA += "❌"
        }
        
        goToNextQuestion()
    }

    private func goToNextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        } else {
            finishGame()
        }
    }

    private func finishGame() {
        state = .over
    }
}
