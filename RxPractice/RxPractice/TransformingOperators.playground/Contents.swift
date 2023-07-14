import RxSwift

let disposeBag = DisposeBag()

print("------toArray------")
Observable.of("A", "B", "C") // .just넣은것과 비슷함
    .toArray() //이거하면 싱글로 Array리턴함
    .subscribe(onSuccess: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------map------")
Observable.of(Date())
    .map { date -> String in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------flatMap------")

//Observable<Observable<String>>
//[[String]]
protocol 선수 {
    var 점수 : BehaviorSubject<Int>{ get }
    
}

struct 양궁성수: 선수 {
    var 점수 : BehaviorSubject<Int>
}

let 국가대표 = 양궁성수(점수: BehaviorSubject<Int>(value: 10))
let 딴나라대표 = 양궁성수(점수: BehaviorSubject<Int>(value: 8))

let 올림픽경기 = PublishSubject<선수>() //중첩된 observable

올림픽경기
    .flatMap { 선수 in
        선수.점수
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

올림픽경기.onNext(국가대표)//초기 10
국가대표.점수.onNext(10) //10 배출

올림픽경기.onNext(딴나라대표) //초기 8 배출
국가대표.점수.onNext(10) // 10
딴나라대표.점수.onNext(9) // 9
//중첩이되고있는 것을 계속 꺼내고있다.





print("------flatMapLatest------")

struct 높이뛰기선수: 선수{
    var 점수 : BehaviorSubject<Int>
}
let 서울 = 높이뛰기선수(점수: BehaviorSubject<Int>(value: 7))
let 제주 = 높이뛰기선수(점수: BehaviorSubject<Int>(value: 6))
let 전국체전 = PublishSubject<선수>()

전국체전
    .flatMapLatest { 선수 in
        선수.점수 //가장 최신의 값만을 반영함
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

전국체전.onNext(서울) // 초기값 7이 제일 최신
서울.점수.onNext(9) // 9를 내뱉음

전국체전.onNext(제주) // 초기값 6이 제일 최신 새로운 시퀀스가 들어오면서 서울의 시퀀스는 업데이트되지 않는다.
서울.점수.onNext(10)
제주.점수.onNext(7) // 7을 내뱉음

// 네트워킹 조작에서 잘씀
// 새로운스트링을 받을떄마다 쓰면 유용함

print("------materialize and dematerialize------")
enum 반칙: Error {
    case 부정출발
}

struct 달리기선수 : 선수{
    var 점수 : BehaviorSubject<Int>
}
let 김토끼 = 달리기선수(점수: BehaviorSubject<Int>(value: 0))
let 박치타 = 달리기선수(점수: BehaviorSubject<Int>(value: 1))

let 달리기100M = BehaviorSubject<선수>(value: 김토끼)

달리기100M
    .flatMapLatest { 선수 in
        선수.점수
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

김토끼.점수.onNext(1)
김토끼.점수.onError(반칙.부정출발)
김토끼.점수.onNext(2)

달리기100M.onNext(박치타)

