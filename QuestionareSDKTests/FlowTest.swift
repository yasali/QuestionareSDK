//
//  FlowTest.swift
//  QuestionareSDKTests
//
//  Created by SWE-PC-110 on 2021-08-06.
//

import XCTest
@testable import QuestionareSDK

class QProcedureTest: XCTestCase {

    func test_no_questions_routeToNoQuestion() {
        makeSUT(question: []).startProcedure()
        XCTAssertTrue(router.movedQuestion.isEmpty)
    }
    
    func test_one_questions_routeToOneQuestion() {
        makeSUT(question: ["Questionare1"]).startProcedure()
        XCTAssertEqual(router.movedQuestion, ["Questionare1"])
    }
    
    func test_two_questions_routeToTwoQuestion() {
        makeSUT(question: ["Questionare1", "Questionare2"]).startProcedure()
        XCTAssertEqual(router.movedQuestion, ["Questionare1"])
    }
    
    func test_two_questions_routeToFirstQuestionTwice() {
        let sut = makeSUT(question: ["Questionare1", "Questionare2"])
        sut.startProcedure()
        sut.startProcedure()
        XCTAssertEqual(router.movedQuestion, ["Questionare1", "Questionare1"])
    }
    
    func test_start_and_answer_first_question_with_two_questions_routeToSecondQuestion() {
        let sut = makeSUT(question: ["Questionare1", "Questionare2"])
        sut.startProcedure()
        router.answerCallBack("Answer1")
        XCTAssertEqual(router.movedQuestion, ["Questionare1", "Questionare2"])
    }
    
    func test_start_and_answer_first_and_second_question_with_three_questions_routeToSecondAndThirdQuestion() {
        let sut = makeSUT(question: ["Questionare1", "Questionare2", "Questionare3"])
        sut.startProcedure()
        router.answerCallBack("Answer1")
        router.answerCallBack("Answer2")
        XCTAssertEqual(router.movedQuestion, ["Questionare1", "Questionare2", "Questionare3"])
    }

    func test_start_and_answer_one_question_with_one_questions_doesNotRouteToAnyQuestion() {
        let sut = makeSUT(question: ["Questionare1"])
        sut.startProcedure()
        router.answerCallBack("Answer1")
        XCTAssertEqual(router.movedQuestion, ["Questionare1"])
    }
    
    
    // MARK: Helpers
        
    let router = QRouterSpy()
    
    func makeSUT(question: [String]) -> QProcedure {
        return QProcedure(questions: question, router: router)
    }
    
    class QRouterSpy: QRouter {
        var movedCount: Int = 0
        var movedQuestion: [String] = []
        var answerCallBack: QRouter.AnswerCallback = { _ in }
        func moveTo(question: String, answerCallBack: @escaping QRouter.AnswerCallback) {
            movedCount += 1
            movedQuestion.append(question)
            self.answerCallBack = answerCallBack
        }
    }
    
}
