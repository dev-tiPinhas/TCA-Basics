//
//  Timer_Composable_ArchitectureTests.swift
//  Timer Composable ArchitectureTests
//
//  Created by Tiago Pinheiro on 12/10/2023.
//
import ComposableArchitecture
import XCTest
@testable import Timer_Composable_Architecture

@MainActor
final class Timer_Composable_ArchitectureTests: XCTestCase {
    func testCounter() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }
    }
    
    func testTimer() async throws {
        let clock = TestClock()
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerOn = true
        }
        
        await clock.advance(by: .seconds(1))
        await store.receive(.timerTicked) {
            $0.count = 1
        }
        await clock.advance(by: .seconds(1))
        await store.receive(.timerTicked) {
            $0.count = 2
        }
        
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerOn = false
        }
    }
    
    func testGetFact() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.numberFact.fetch = { "\($0) is Pimenta's number."}
        }
        
        await store.send(.getFactButtonTapped) {
            $0.isLoading = true
        }
        await store.receive(.factResponse("0 is Pimenta's number.")) {
            $0.fact = "0 is Pimenta's number."
            $0.isLoading = false
        }
    }
    
    func testGetFact_Error() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.numberFact.fetch = { _ in
                struct SomeError: Error {}
                throw SomeError()
            }
        }
        
        XCTExpectFailure()
        await store.send(.getFactButtonTapped) {
            $0.isLoading = true
        }
    }
}
