; RUN: opt -module-summary %s -o %t1.bc
; RUN: opt -module-summary %p/Inputs/index-const-prop-define-g.ll -o %t2.bc
; RUN: llvm-lto2 run -lto-opaque-pointers -opaque-pointers -save-temps %t2.bc -r=%t2.bc,g,pl %t1.bc -r=%t1.bc,main,plx -r=%t1.bc,g, -o %t3
; RUN: llvm-dis %t3.2.3.import.bc -o - | FileCheck %s

; The 'store' instruction in @main should prevent internalization
; even when there is 'load' instruction before it.
; CHECK: @g = available_externally global i32 42

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@g = external global i32

define i32 @main() {
  %v = load i32, ptr @g
  %q = add i32 %v, 1
  store i32 %q, ptr @g
  
  ret i32 %v
}
