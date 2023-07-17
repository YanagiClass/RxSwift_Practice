import RxSwift


let disposeBag = DisposeBag()
print("------ignoreElements------")
let 취침모드 = PublishSubject<String>()

취침모드
    .ignoreElements()
    .subscribe{
        print($0)
    }
    .disposed(by: disposeBag)

취침모드.onNext("스피커")
취침모드.onNext("스피커")
취침모드.onNext("스피커")
//igonore는 onNext를 무시한다.

취침모드.onCompleted() //이때는 completed가 나온다

print("------elementAt------")
let 두번울면깨는사람 = PublishSubject<String>()

두번울면깨는사람
    .element(at: 2)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

두번울면깨는사람.onNext("삐삐") //index0
두번울면깨는사람.onNext("삐삐") //index1
두번울면깨는사람.onNext("😭") //index2 해당인덱스의 해당하는 값만 방출해준다.
두번울면깨는사람.onNext("삐삐") //index3


print("------filter------")

Observable.of(1, 2, 3, 4, 5, 6, 7, 8) //[1, 2, 3, 4, 5,6, 7, 7]
    .filter{ $0 % 2 == 0 } // 짝수만 방출하도록 클로저 만듬 여기서 트루가 되는 값만 리턴한다.. Array에 filter쓰는 것과 비슷하다.
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------skip------")

Observable.of("1", "2", "3", "4", "5", "6")
    .skip(5) // 이번호까지 스킵함
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------skipWhile------")

Observable.of("1", "2", "3", "4", "5", "6","7")
    .skip(while: {
        $0 != "3" //이 값이 false일때부터 방출함
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
print("------skipUntil------")
let 손님 = PublishSubject<String>()
let 문여는시간 = PublishSubject<String>()

손님
    .skip(until: 문여는시간) //다른 옵저버블이 시도할때 까지 스킵한다
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

손님.onNext("ㅇㅇ")
손님.onNext("ㅇㅇ")
문여는시간.onNext("문열었다!")
손님.onNext("ㅎㅇ") //여기서부터 나온다.


print("------take------")
Observable.of("1", "2", "3", "4", "5", "6","7")
    .take(3) //첫번쨰부터 take에 들어간데까지만 나온다.
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------takeWhile------")

Observable.of("1", "2", "3", "4", "5", "6","7")
    .take(while: {
        $0 != "3" //이 값이 true일 동안 방출함
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)



print("------enumerated------")
Observable.of("1", "2", "3", "4", "5", "6","7")
    .enumerated() //방출된 요소의 인덱스를 참고하고싶을때..
    .takeWhile{
        $0.index < 3 //index가 3이하일때까지만 방출
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("------takeUntil------")
let 수강신청 = PublishSubject<String>()
let 신청마감 = PublishSubject<String>()

수강신청
    .take(until: 신청마감) //안에 있는 옵저버블이 구독되기 전까지만 이벤트를 받는다.
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

수강신청.onNext("츄라이")
수강신청.onNext("츄라이2")
신청마감.onNext("ㅅㄱ")
수강신청.onNext("츄라이3") //여기서부터 안나옴

print("------distinctUntilChanged------")
Observable.of("1","1","1","1","1", "2", "3", "4", "5", "6","7")
    .distinctUntilChanged() // 같은게 나오면 생략함. 닉값을 한다고 보면된다. 구분한다 / 언제까지? / 바뀔때까지!
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
