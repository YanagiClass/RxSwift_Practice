import RxSwift
let disposeBag = DisposeBag()
print("------publishSubject------")
let publishSubject = PublishSubject<String>()

publishSubject.onNext("1ㅎㅇㅎㅇ")

let 구독자1 = publishSubject
    .subscribe(onNext: {
        print("첫번째구독자")
        print($0)
    })


publishSubject.onNext("2들림?")
publishSubject.onNext("3안들림?")
구독자1.dispose() //dispose되기까지 계속 나옴


let 구독자2 = publishSubject
    .subscribe(onNext: {
        print("두번째구독자")
        print($0)
    })


publishSubject.onNext("4can you hear me?")
publishSubject.onCompleted()

publishSubject.onNext("5.마지막 역시 안나옴 ㅋㅋ 위에 컴플리트함")

구독자2.dispose()

publishSubject
    .subscribe{print("세번째 구독: ", $0.element ?? $0)}
    .disposed(by: disposeBag)

publishSubject.onNext("6.나올까?")


print("------BehaiviorSubject------")
enum SubjectError: Error{
    case error1
}
let behaviorSubject = BehaviorSubject<String>(value: "초기값") //초기값은 못받음

behaviorSubject.onNext("1. 첫번째 값") //직전 구독한 것만 받음.

behaviorSubject.subscribe{
    print("첫번째구독: ", $0.element ?? $0)
        
}.disposed(by: disposeBag)
//behaviorSubject.onError(SubjectError.error1) //첫번쨰 구독자도 받는다(이걸 봐서는 Subject가 업데이트 될 때마다 dispose백에 담는듯) 뒤에 두번째 구독도 발생직전에 있는 에러는 받음
behaviorSubject.subscribe{
    print("두번째 구독 ", $0.element ?? $0)
        
}.disposed(by: disposeBag)


let value = try? behaviorSubject.value()
print(value) //nil //가장 최근의 onNext값을 옵셔널로 리턴해줌 왠만한경우엔 잘 안씀

print("------ReplaySubject------")
let replaySubject = ReplaySubject<String>.create(bufferSize: 3) //이 크기에따라 받을수있는것과 못받는 것이 갈린다.

replaySubject.onNext("1. 여러분")
replaySubject.onNext("2. 힘내세요")
replaySubject.onNext("3. 아자아자")

replaySubject.subscribe{
    print("첫번째구독", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.subscribe{
    print("두번째 구독: ", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.onNext("4. 하뚜이따!")
replaySubject.onError(SubjectError.error1)
replaySubject.dispose()


replaySubject.subscribe{
    print("세번쨰구독", $0.element ?? $0) //이미 dispose되어 에러가 발생한다.
}
.disposed(by: disposeBag)




