//
//  FlowTest.swift
//  QuestionareSDKTests
//
//  Created by SWE-PC-110 on 2021-08-06.
//

import XCTest
@testable import QuestionareSDK

class FlowTest: XCTestCase {

    func test_no_questions_routeToNoQuestion() {
        makeSUT(question: []).start()
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_one_questions_routeToOneQuestion() {
        makeSUT(question: ["Q1"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_two_questions_routeToTwoQuestion() {
        makeSUT(question: ["Q1", "Q2"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_two_questions_routeToFirstQuestionTwice() {
        let sut = makeSUT(question: ["Q1", "Q2"])
        sut.start()
        sut.start()
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    func test_start_and_answer_first_question_with_two_questions_routeToSecondQuestion() {
        let sut = makeSUT(question: ["Q1", "Q2"])
        sut.start()
        router.answerCallBack("A1")
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2"])
    }
    
    func test_start_and_answer_first_and_second_question_with_three_questions_routeToSecondAndThirdQuestion() {
        let sut = makeSUT(question: ["Q1", "Q2", "Q3"])
        sut.start()
        router.answerCallBack("A1")
        router.answerCallBack("A2")
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
    }

    func test_start_and_answer_one_question_with_one_questions_doesNotRouteToAnyQuestion() {
        let sut = makeSUT(question: ["Q1"])
        sut.start()
        router.answerCallBack("A1")
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    
    // MARK: Helpers
        
    let router = RouterSpy()
    
    func makeSUT(question: [String]) -> Flow {
        return Flow(questions: question, router: router)
    }
    
    class RouterSpy: Router {
        var routedCount: Int = 0
        var routedQuestions: [String] = []
        var answerCallBack: Router.AnswerCallback = { _ in }
        func routeTo(question: String, answerCallBack: @escaping Router.AnswerCallback) {
            routedCount += 1
            routedQuestions.append(question)
            self.answerCallBack = answerCallBack
        }
    }
    
}
