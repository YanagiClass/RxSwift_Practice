import UIKit
import RxSwift

print("----Just----")
Observable<Int>.just(1) //하나의 엘리멘트 방출
    .subscribe(onNext:{
        print($0)
    })
print("----Of----")
Observable<Int>.of(1, 2, 3, 4, 5) //하나 이상의 이벤트
    .subscribe(onNext:{
        print($0)
    })

print("----Of2----")
Observable.of([1, 2, 3, 4, 5]) //이러면 하나의 Array만 배출한다. Just쓴 것과 같음.
    .subscribe(onNext:{
        print($0)
    })
print("----From----")


Observable.from([1, 2, 3, 4, 5]) //Array만 받고 Array안의 요소를 순서대로 배출해줌.
    .subscribe(onNext:{
        print($0)
    })

//Observable은 시퀀스일 뿐이다. (정의내린 것에 지나지 않음) 구독을 해야한다.



print("----Subscribe1----")

Observable.of(1, 2, 3) //그냥 subscribe쓰면 어떤 이벤트에 나오는지 알려줌 마지막에 컴프리트 된 것도 알려준다.
    .subscribe{
        print($0)
    }
print("----Subscribe2----")
Observable.of(1, 2, 3)
    .subscribe{
        if let element = $0.element{
            print(element)
        }
    } //element만 나온다
print("----Subscribe3----")
Observable.of(1, 2, 3)
    .subscribe(onNext: {
        print($0)
    })//element만 나온다

print("----empty-----")
Observable<Void>.empty()
    .subscribe{
        print($0)
    } //아무것도 나오지않음. 아무 이벤트도 나오지 않는다는 말이다.
    
//Rx는 타입추론을 지원한다.

//empty의 용도는 의도적으로 0개의 값을 가지는 observable을 리턴하거나 바로 끝내고싶을때 사용함

print("----never----")

Observable<Void>.never()
    .debug("never")
    .subscribe(onNext: {
        print("$0")
    }, onCompleted: {
        print("completed")
    }
    )
    //구독은 됐지만 아무것도 내뱉지 않는다.
print("----range-----")
Observable.range(start: 1, count: 9)
    .subscribe(onNext: {
        print("2*\($0) = \(2*$0)")
    }) //스타트값부터 카운트를 늘려가면서 실행함..


//subscribe는 방아쇠같은 느낌임

print("----dispose----")
Observable.of(1, 2, 3)
    .subscribe {
        print($0)
    }
    .dispose() //구독을 취소하는 기능임. 이벤트 방출이 더이상 되지 않음. 무한한 요소를 구독할 때는 이걸 넣어줘야 complete가나온다.


print("----disposedBag-----")
let disposeBag = DisposeBag() //
Observable.of(1, 2, 3)
    .subscribe{
        print($0)
    }
    .disposed(by: disposeBag) //구독에서 방출된 disposedBag에 추가됨. 그러다가 한꺼번에 dispose 해줌.
//수동적으로 dispose를하면 빼먹는 경우가 생길 수도 있기 떄문에 이것을 사용한다고 함. 결국 메모리누수를 방지하기위함이라고 이해하면 용이하다.


print("----create1----")
Observable.create { observer -> Disposable in
    observer.onNext(1)// .on(.next(1))과 같음
    observer.onCompleted() //여기서 컴플리트가 되어서 종료됨
    observer.onNext(2) //따라서 이거 실행안됨
    return Disposables.create()
}
.subscribe{
    print($0)
}
.disposed(by: disposeBag)
print("----create2----")
enum MyError: Error{
    case anError
}
Observable<Int>.create { observer -> Disposable in
    observer.onNext(1)
    observer.onError(MyError.anError)
    observer.onCompleted()
    observer.onNext(2)
    return Disposables.create()
}.subscribe(
    onNext: {
        print($0)
    },
    onError: {
        print($0.localizedDescription)
        
    },
    onCompleted: {
        print("completed")
    },
    onDisposed: {
        print("disposed")
    }
)
.disposed(by: disposeBag) //이거 안넣으면 메모리낭비 ㅅㄱ


print("----defferd1----")

Observable.deferred {
    Observable.of(1, 2, 3)
    
}
.subscribe{
    print($0)
}
.disposed(by: disposeBag)
print("----defferd2----")
var 뒤집기: Bool = false

let factory: Observable<String> = Observable.deferred {
    뒤집기 = !뒤집기
    if 뒤집기 {
        return Observable.of("✋")
    }else{
        return Observable.of("👎")
    }
}


for _ in 0...3{
    factory.subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
}
