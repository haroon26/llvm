; RUN: opt -module-summary -o %t.bc %s
; RUN: llvm-lto2 run -lto-opaque-pointers -opaque-pointers %t.bc -r %t.bc,foo,pl -o %t2
; RUN: llvm-nm %t2.1 | FileCheck %s
; CHECK: i foo
; CHECK: t foo_resolver

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@foo = ifunc i32 (i32), ptr @foo_resolver

define internal ptr @foo_resolver() {
entry:
  ret ptr null
}
