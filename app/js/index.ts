/// <reference path="typings/tsd.d.ts" />

class HogeViewModel {
  // 何も指定しないと public になる
  private name: KnockoutObservable<string> = ko.observable('');
  private age: KnockoutObservable<number> = ko.observable(0);

  constructor(name: string, age: number) {
    this.name(name);
    this.age(age);
  }
}

$(function() {
  ko.applyBindings(new HogeViewModel('山田', 32));
});
