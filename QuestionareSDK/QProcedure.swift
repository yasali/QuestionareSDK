//
//  Flow.swift
//  QuestionareSDK
//
//  Created by SWE-PC-110 on 2021-08-06.
//

import Foundation

protocol QRouter {
    typealias AnswerCallback = (String) -> Void
    func moveTo(question: String, answerCallBack: @escaping AnswerCallback)
}

class QProcedure {
    private let router: QRouter
    private let questions: [String]
    
    init(questions: [String], router: QRouter) {
        self.questions = questions
        self.router = router
    }
    
    func startProcedure() {
        if let fQuestion = questions.first {
            router.moveTo(question: fQuestion, answerCallBack: moveToNext(from: fQuestion))
        }
    }
    
    
    private func moveToNext(from question: String) -> QRouter.AnswerCallback {
        return { [weak self] _ in
            guard let strongSelf = self else { return }
            if var currentIndex = strongSelf.questions.firstIndex(of: question) {
                currentIndex = currentIndex+1
                if currentIndex < strongSelf.questions.count {
                    let nQuestion = strongSelf.questions[currentIndex]
                    strongSelf.router.moveTo(question: nQuestion, answerCallBack: strongSelf.moveToNext(from: nQuestion))
                }
            }
        }
    }
}
