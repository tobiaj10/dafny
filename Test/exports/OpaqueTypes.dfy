// RUN: %dafny /env:0 /dprint:"%t.dfy" /compile:0 "%s" > "%t.result"
// RUN: %diff "%s.expect" "%t.result"

module A {
  export A opaque T, f
  export B extends A reveal T
  type T = nat
  function f() : T
}

module B {
  import A.A
  function G() : nat { A.f() } // error, T not known to be nat

  function H(n : A.T) : bool
  requires 0 <= n; // error

}

module C {
  import A.B

  function G(): nat { A.f() } // T is now known

  function H(n : A.T, m : A.T, h : nat) : bool
  requires 0 <= n && n == m && h <= m;

}


module AA {
  export A opaque T, f
  export B extends A reveal T
  newtype T = x: nat | 0 <= x < 3 && [5, 7, 8][x] % 2 != 0
  function f() : T
}

module BB {
  import A = AA.A
  function G() : int { int(A.f()) } // error, T not known to be nat

  function H(n : A.T) : bool
  requires 0 <= n; // error

}

module CC {
  import A = AA.B

  function G(): nat { A.f() } // T is now known

  function H(n : A.T, m : A.T) : bool
  requires 0 <= n && n == m && 1 <= m;

}


