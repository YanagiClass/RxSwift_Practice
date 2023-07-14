import RxSwift

let disposeBag = DisposeBag()

enum TraitsError: Error {
    case single
    case maybe
    case completable
    
    
}
print("------Single1------")
Single<String>.just("✅")
    .subscribe(
        onSuccess: {
            print($0)
        }, //onNext와 onCompleted와 합친 것과 같다.
        onFailure: {
            print("error \($0)")
        }, //onError와 비슷함
        onDisposed: {
            print("disposed")
            
        }
    )
    .disposed(by: disposeBag)

print("------Single2------")

Observable<String>.create{ observers -> Disposable in
    observers.onError(TraitsError.single)
    return Disposables.create()
}
    .asSingle() //이렇게하면 싱글로 바뀜
    .subscribe(
    onSuccess: {print($0)},
    onFailure: {$0.localizedDescription},
    onDisposed: {print("disposed")}
    )

print("------Single3------")
struct SomeJSON : Decodable {
    let name: String //디코딩하기 위하여 json의 키값을 설정해둠
}

enum JSONError: Error {
    case decodingError
}
let json1 = """
    {"name":"hello"}
"""
let json2 = """
    {"my_name":"hello"}
"""


func decode(json:String) -> Single<SomeJSON> {
    Single<SomeJSON>.create { observer in
        let disposable = Disposables.create()
        
        guard let data = json.data(using: .utf8),
              let json = try? JSONDecoder().decode(SomeJSON.self, from: data) else {
            observer(.failure(JSONError.decodingError))
            return disposable
        }
        observer(.success(json))
        return disposable
    }
}

decode(json: json1)
    .subscribe{
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    .disposed(by: disposeBag)

decode(json: json2) //이름값이 안맞는 json을 보내서 의도로 에러를 발생시킴.
    .subscribe{
        switch $0 {
        case .success(let json):
            print(json)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)



print("------Maybe1------")
Maybe<String>.just("✅")
    .subscribe(onSuccess: {
        print($0)
    },
               onError: {
        print($0)
    },
               onCompleted: {
        print("completed")
    },
               onDisposed: {
        print("disposed")
    }
    )
    .disposed(by: disposeBag)


print("------Maybe2------")
Observable<String>.create { observer -> Disposable in
    observer.onError(TraitsError.maybe)
    return Disposables.create()
}
.asMaybe() //maybe로 바꿔준다.
.subscribe(onSuccess: {print("성공\($0)")}, onError: { print("실패\($0)") }, onCompleted: {print("completed")}, onDisposed: {print("disposed")})
.disposed(by: disposeBag)

print("-------Completable1-------")
Completable.create { completable in
    completable(.error(TraitsError.completable))
    return Disposables.create()
}
.subscribe(onCompleted: {
    print("completed")
}, onError: {
    print("error: \($0.localizedDescription)")
}, onDisposed: {
    print("disposed")
})
.disposed(by: disposeBag)

print("-------Completable2-------")
Completable.create { completable in
    completable(.completed)
    return Disposables.create()
}
.subscribe(onCompleted: {
    print("completed")
}, onError: {
    print("error: \($0.localizedDescription)")
}, onDisposed: {
    print("disposed")
})
.disposed(by: disposeBag)

//Single Maybe, Completable 의 차이점은 구독했을때 나오는 것의 차이점이 있다 Completable의 경우 컴플리트와 에러만 등장하는데 이게 왜필요하냐 싶겠지만 성공유무확인에는 아주 와따다.
