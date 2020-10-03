; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp -enable-arm-maskedldst -enable-mem-access-versioning=false -tail-predication=force-enabled %s -o - | FileCheck %s

define dso_local void @mve_gather_qi_wb(i32* noalias nocapture readonly %A, i32* noalias nocapture readonly %B, i32* noalias nocapture %C, i32 %n, i32 %m, i32 %l) {
; CHECK-LABEL: mve_gather_qi_wb:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    add.w r12, r0, r3, lsl #2
; CHECK-NEXT:    adr r0, .LCPI0_0
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    movw lr, #1250
; CHECK-NEXT:    vmov.i32 q1, #0x0
; CHECK-NEXT:    vadd.i32 q0, q0, r1
; CHECK-NEXT:    adds r1, r3, #4
; CHECK-NEXT:    dls lr, lr
; CHECK-NEXT:  .LBB0_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vctp.32 r3
; CHECK-NEXT:    vmov q2, q1
; CHECK-NEXT:    vpstt
; CHECK-NEXT:    vldrwt.u32 q1, [r12], #16
; CHECK-NEXT:    vldrwt.u32 q3, [q0, #80]!
; CHECK-NEXT:    subs r3, #4
; CHECK-NEXT:    vmul.i32 q1, q3, q1
; CHECK-NEXT:    vadd.i32 q1, q2, q1
; CHECK-NEXT:    le lr, .LBB0_1
; CHECK-NEXT:  @ %bb.2: @ %middle.block
; CHECK-NEXT:    vpsel q0, q1, q2
; CHECK-NEXT:    vaddv.u32 r0, q0
; CHECK-NEXT:    str.w r0, [r2, r1, lsl #2]
; CHECK-NEXT:    pop {r7, pc}
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.3:
; CHECK-NEXT:  .LCPI0_0:
; CHECK-NEXT:    .long 4294967228 @ 0xffffffbc
; CHECK-NEXT:    .long 4294967248 @ 0xffffffd0
; CHECK-NEXT:    .long 4294967268 @ 0xffffffe4
; CHECK-NEXT:    .long 4294967288 @ 0xfffffff8
entry:                                  ; preds = %middle.
  %add.us.us = add i32 4, %n
  %arrayidx.us.us = getelementptr inbounds i32, i32* %C, i32 %add.us.us
  br label %vector.body
vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i32 [ 0, %entry ], [ %index.next, %vector.body ]
  %vec.phi = phi <4 x i32> [ zeroinitializer, %entry ], [ %7, %vector.body ]
  %vec.ind = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, %entry ], [ %vec.ind.next, %vector.body ]
  %0 = add i32 %index, %n
  %1 = getelementptr inbounds i32, i32* %A, i32 %0
  %active.lane.mask = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %n)
  %2 = bitcast i32* %1 to <4 x i32>*
  %wide.masked.load = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* %2, i32 4, <4 x i1> %active.lane.mask, <4 x i32> undef)
  %3 = mul <4 x i32> %vec.ind, <i32 5, i32 5, i32 5, i32 5>
  %4 = add <4 x i32> %3, <i32 3, i32 3, i32 3, i32 3>
  %5 = getelementptr inbounds i32, i32* %B, <4 x i32> %4
  %wide.masked.gather = call <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*> %5, i32 4, <4 x i1> %active.lane.mask, <4 x i32> undef)
  %6 = mul nsw <4 x i32> %wide.masked.gather, %wide.masked.load
  %7 = add <4 x i32> %vec.phi, %6
  %index.next = add i32 %index, 4
  %vec.ind.next = add <4 x i32> %vec.ind, <i32 4, i32 4, i32 4, i32 4>
  %8 = icmp eq i32 %index.next, 5000
  br i1 %8, label %middle.block, label %vector.body
middle.block:                                     ; preds = %vector.body
  %9 = select <4 x i1> %active.lane.mask, <4 x i32> %7, <4 x i32> %vec.phi
  %10 = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %9)
  store i32 %10, i32* %arrayidx.us.us, align 4
  %inc21.us.us = add nuw i32 4, 1
  %exitcond81.not = icmp eq i32 %inc21.us.us, %n
  br label %end
end:                                 ; preds = %middle.block
  ret void
}

define dso_local void @mve_gatherscatter_offset(i32* noalias nocapture readonly %A, i32* noalias nocapture readonly %B, i32* noalias nocapture %C, i32 %n, i32 %m, i32 %l) {
; CHECK-LABEL: mve_gatherscatter_offset:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    .vsave {d8, d9}
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    add.w r4, r0, r3, lsl #2
; CHECK-NEXT:    adr r0, .LCPI1_0
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    add.w r12, r3, #4
; CHECK-NEXT:    movw lr, #1250
; CHECK-NEXT:    vmov.i32 q2, #0x0
; CHECK-NEXT:    vmov.i32 q0, #0x14
; CHECK-NEXT:    dls lr, lr
; CHECK-NEXT:  .LBB1_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vctp.32 r3
; CHECK-NEXT:    vmov q3, q2
; CHECK-NEXT:    vpstt
; CHECK-NEXT:    vldrwt.u32 q2, [r1, q1, uxtw #2]
; CHECK-NEXT:    vldrwt.u32 q4, [r4], #16
; CHECK-NEXT:    subs r3, #4
; CHECK-NEXT:    vmul.i32 q2, q2, q4
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vstrwt.32 q2, [r1, q1, uxtw #2]
; CHECK-NEXT:    vadd.i32 q1, q1, q0
; CHECK-NEXT:    vadd.i32 q2, q3, q2
; CHECK-NEXT:    le lr, .LBB1_1
; CHECK-NEXT:  @ %bb.2: @ %middle.block
; CHECK-NEXT:    vpsel q0, q2, q3
; CHECK-NEXT:    vaddv.u32 r0, q0
; CHECK-NEXT:    str.w r0, [r2, r12, lsl #2]
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    pop {r4, pc}
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.3:
; CHECK-NEXT:  .LCPI1_0:
; CHECK-NEXT:    .long 3 @ 0x3
; CHECK-NEXT:    .long 8 @ 0x8
; CHECK-NEXT:    .long 13 @ 0xd
; CHECK-NEXT:    .long 18 @ 0x12
entry:                                  ; preds = %middle.
  %add.us.us = add i32 4, %n
  %arrayidx.us.us = getelementptr inbounds i32, i32* %C, i32 %add.us.us
  br label %vector.body
vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i32 [ 0, %entry ], [ %index.next, %vector.body ]
  %vec.phi = phi <4 x i32> [ zeroinitializer, %entry ], [ %7, %vector.body ]
  %vec.ind = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, %entry ], [ %vec.ind.next, %vector.body ]
  %0 = add i32 %index, %n
  %1 = getelementptr inbounds i32, i32* %A, i32 %0
  %active.lane.mask = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %n)
  %2 = bitcast i32* %1 to <4 x i32>*
  %wide.masked.load = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* %2, i32 4, <4 x i1> %active.lane.mask, <4 x i32> undef)
  %3 = mul <4 x i32> %vec.ind, <i32 5, i32 5, i32 5, i32 5>
  %4 = add <4 x i32> %3, <i32 3, i32 3, i32 3, i32 3>
  %5 = getelementptr inbounds i32, i32* %B, <4 x i32> %4
  %wide.masked.gather = call <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*> %5, i32 4, <4 x i1> %active.lane.mask, <4 x i32> undef)
  %6 = mul nsw <4 x i32> %wide.masked.gather, %wide.masked.load
  call void @llvm.masked.scatter.v4i32.v4p0i32(<4 x i32> %6, <4 x i32*> %5, i32 4, <4 x i1> %active.lane.mask)
  %7 = add <4 x i32> %vec.phi, %6
  %index.next = add i32 %index, 4
  %vec.ind.next = add <4 x i32> %vec.ind, <i32 4, i32 4, i32 4, i32 4>
  %8 = icmp eq i32 %index.next, 5000
  br i1 %8, label %middle.block, label %vector.body
middle.block:                                     ; preds = %vector.body
  %9 = select <4 x i1> %active.lane.mask, <4 x i32> %7, <4 x i32> %vec.phi
  %10 = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %9)
  store i32 %10, i32* %arrayidx.us.us, align 4
  %inc21.us.us = add nuw i32 4, 1
  %exitcond81.not = icmp eq i32 %inc21.us.us, %n
  br label %end
end:                                 ; preds = %middle.block
  ret void
}
define dso_local void @mve_scatter_qi(i32* noalias nocapture readonly %A, i32* noalias nocapture readonly %B, i32* noalias nocapture %C, i32 %n, i32 %m, i32 %l) {
; CHECK-LABEL: mve_scatter_qi:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    add.w r12, r0, r3, lsl #2
; CHECK-NEXT:    adr r0, .LCPI2_0
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    movw lr, #1250
; CHECK-NEXT:    vmov.i32 q1, #0x0
; CHECK-NEXT:    vmov.i32 q2, #0x3
; CHECK-NEXT:    vadd.i32 q0, q0, r1
; CHECK-NEXT:    adds r1, r3, #4
; CHECK-NEXT:    dls lr, lr
; CHECK-NEXT:  .LBB2_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vctp.32 r3
; CHECK-NEXT:    vmov q3, q1
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vldrwt.u32 q1, [r12], #16
; CHECK-NEXT:    subs r3, #4
; CHECK-NEXT:    vmul.i32 q1, q1, q2
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vstrwt.32 q1, [q0, #80]!
; CHECK-NEXT:    vadd.i32 q1, q3, q1
; CHECK-NEXT:    le lr, .LBB2_1
; CHECK-NEXT:  @ %bb.2: @ %middle.block
; CHECK-NEXT:    vpsel q0, q1, q3
; CHECK-NEXT:    vaddv.u32 r0, q0
; CHECK-NEXT:    str.w r0, [r2, r1, lsl #2]
; CHECK-NEXT:    pop {r7, pc}
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.3:
; CHECK-NEXT:  .LCPI2_0:
; CHECK-NEXT:    .long 4294967228 @ 0xffffffbc
; CHECK-NEXT:    .long 4294967248 @ 0xffffffd0
; CHECK-NEXT:    .long 4294967268 @ 0xffffffe4
; CHECK-NEXT:    .long 4294967288 @ 0xfffffff8
entry:                                  ; preds = %middle.
  %add.us.us = add i32 4, %n
  %arrayidx.us.us = getelementptr inbounds i32, i32* %C, i32 %add.us.us
  br label %vector.body
vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i32 [ 0, %entry ], [ %index.next, %vector.body ]
  %vec.phi = phi <4 x i32> [ zeroinitializer, %entry ], [ %7, %vector.body ]
  %vec.ind = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, %entry ], [ %vec.ind.next, %vector.body ]
  %0 = add i32 %index, %n
  %1 = getelementptr inbounds i32, i32* %A, i32 %0
  %active.lane.mask = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %n)
  %2 = bitcast i32* %1 to <4 x i32>*
  %wide.masked.load = call <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>* %2, i32 4, <4 x i1> %active.lane.mask, <4 x i32> undef)
  %3 = mul <4 x i32> %vec.ind, <i32 5, i32 5, i32 5, i32 5>
  %4 = add <4 x i32> %3, <i32 3, i32 3, i32 3, i32 3>
  %5 = getelementptr inbounds i32, i32* %B, <4 x i32> %4
  %6 = mul nsw <4 x i32> <i32 3, i32 3, i32 3, i32 3>, %wide.masked.load
  call void @llvm.masked.scatter.v4i32.v4p0i32(<4 x i32> %6, <4 x i32*> %5, i32 4, <4 x i1> %active.lane.mask)
  %7 = add <4 x i32> %vec.phi, %6
  %index.next = add i32 %index, 4
  %vec.ind.next = add <4 x i32> %vec.ind, <i32 4, i32 4, i32 4, i32 4>
  %8 = icmp eq i32 %index.next, 5000
  br i1 %8, label %middle.block, label %vector.body
middle.block:                                     ; preds = %vector.body
  %9 = select <4 x i1> %active.lane.mask, <4 x i32> %7, <4 x i32> %vec.phi
  %10 = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %9)
  store i32 %10, i32* %arrayidx.us.us, align 4
  %inc21.us.us = add nuw i32 4, 1
  %exitcond81.not = icmp eq i32 %inc21.us.us, %n
  br label %end
end:                                 ; preds = %middle.block
  ret void
}

define void @justoffsets(i8* noalias nocapture readonly %r, i8* noalias nocapture %w, i32 %N) {
; CHECK-LABEL: justoffsets:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r5, r6, r7, r8, lr}
; CHECK-NEXT:    push.w {r4, r5, r6, r7, r8, lr}
; CHECK-NEXT:    .vsave {d8, d9, d10, d11, d12, d13, d14, d15}
; CHECK-NEXT:    vpush {d8, d9, d10, d11, d12, d13, d14, d15}
; CHECK-NEXT:    .pad #216
; CHECK-NEXT:    sub sp, #216
; CHECK-NEXT:    cmp r2, #0
; CHECK-NEXT:    beq.w .LBB3_3
; CHECK-NEXT:  @ %bb.1: @ %vector.ph
; CHECK-NEXT:    adr r7, .LCPI3_5
; CHECK-NEXT:    vmov.i32 q0, #0x8000
; CHECK-NEXT:    adr r6, .LCPI3_4
; CHECK-NEXT:    adr r5, .LCPI3_3
; CHECK-NEXT:    adr r4, .LCPI3_2
; CHECK-NEXT:    vstrw.32 q0, [sp, #160] @ 16-byte Spill
; CHECK-NEXT:    vldrw.u32 q0, [r7]
; CHECK-NEXT:    adr.w r8, .LCPI3_1
; CHECK-NEXT:    adr.w r12, .LCPI3_0
; CHECK-NEXT:    adr r3, .LCPI3_6
; CHECK-NEXT:    vstrw.32 q0, [sp, #176] @ 16-byte Spill
; CHECK-NEXT:    vldrw.u32 q0, [r6]
; CHECK-NEXT:    vldrw.u32 q1, [r3]
; CHECK-NEXT:    adr r3, .LCPI3_7
; CHECK-NEXT:    vstrw.32 q0, [sp, #144] @ 16-byte Spill
; CHECK-NEXT:    vldrw.u32 q0, [r5]
; CHECK-NEXT:    adr r6, .LCPI3_10
; CHECK-NEXT:    adr r7, .LCPI3_9
; CHECK-NEXT:    vstrw.32 q0, [sp, #128] @ 16-byte Spill
; CHECK-NEXT:    vldrw.u32 q0, [r4]
; CHECK-NEXT:    vstrw.32 q1, [sp, #192] @ 16-byte Spill
; CHECK-NEXT:    vstrw.32 q0, [sp, #112] @ 16-byte Spill
; CHECK-NEXT:    vldrw.u32 q0, [r8]
; CHECK-NEXT:    vstrw.32 q0, [sp, #96] @ 16-byte Spill
; CHECK-NEXT:    vldrw.u32 q0, [r12]
; CHECK-NEXT:    vstrw.32 q0, [sp, #80] @ 16-byte Spill
; CHECK-NEXT:    vmov.i32 q0, #0x7fff
; CHECK-NEXT:    vstrw.32 q0, [sp, #64] @ 16-byte Spill
; CHECK-NEXT:    vldrw.u32 q0, [r3]
; CHECK-NEXT:    adr r3, .LCPI3_8
; CHECK-NEXT:    vstrw.32 q0, [sp, #48] @ 16-byte Spill
; CHECK-NEXT:    vldrw.u32 q0, [r6]
; CHECK-NEXT:    vstrw.32 q0, [sp, #32] @ 16-byte Spill
; CHECK-NEXT:    vldrw.u32 q0, [r7]
; CHECK-NEXT:    vstrw.32 q0, [sp, #16] @ 16-byte Spill
; CHECK-NEXT:    vldrw.u32 q0, [r3]
; CHECK-NEXT:    vstrw.32 q0, [sp] @ 16-byte Spill
; CHECK-NEXT:    dlstp.32 lr, r2
; CHECK-NEXT:  .LBB3_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [sp, #192] @ 16-byte Reload
; CHECK-NEXT:    vldrb.u32 q4, [r0, q0]
; CHECK-NEXT:    vldrw.u32 q0, [sp, #176] @ 16-byte Reload
; CHECK-NEXT:    vldrb.u32 q7, [r0, q0]
; CHECK-NEXT:    vldrw.u32 q0, [sp, #144] @ 16-byte Reload
; CHECK-NEXT:    vldrw.u32 q5, [sp, #112] @ 16-byte Reload
; CHECK-NEXT:    vmul.i32 q6, q7, q0
; CHECK-NEXT:    vldrw.u32 q0, [sp, #128] @ 16-byte Reload
; CHECK-NEXT:    vldrb.u32 q1, [r0, q5]
; CHECK-NEXT:    vldrw.u32 q2, [sp, #80] @ 16-byte Reload
; CHECK-NEXT:    vmul.i32 q3, q4, q0
; CHECK-NEXT:    vldrw.u32 q0, [sp, #96] @ 16-byte Reload
; CHECK-NEXT:    vadd.i32 q3, q3, q6
; CHECK-NEXT:    adds r0, #12
; CHECK-NEXT:    vmul.i32 q6, q1, q0
; CHECK-NEXT:    vldrw.u32 q0, [sp, #160] @ 16-byte Reload
; CHECK-NEXT:    vadd.i32 q3, q3, q6
; CHECK-NEXT:    vadd.i32 q3, q3, q0
; CHECK-NEXT:    vshr.u32 q6, q3, #16
; CHECK-NEXT:    vmul.i32 q3, q7, q2
; CHECK-NEXT:    vldrw.u32 q2, [sp, #64] @ 16-byte Reload
; CHECK-NEXT:    vmul.i32 q2, q4, q2
; CHECK-NEXT:    vadd.i32 q2, q2, q3
; CHECK-NEXT:    vldrw.u32 q3, [sp, #48] @ 16-byte Reload
; CHECK-NEXT:    vmul.i32 q3, q1, q3
; CHECK-NEXT:    vadd.i32 q2, q2, q3
; CHECK-NEXT:    vldrw.u32 q3, [sp, #32] @ 16-byte Reload
; CHECK-NEXT:    vadd.i32 q2, q2, q0
; CHECK-NEXT:    vmul.i32 q3, q7, q3
; CHECK-NEXT:    vldrw.u32 q7, [sp, #16] @ 16-byte Reload
; CHECK-NEXT:    vshr.u32 q2, q2, #16
; CHECK-NEXT:    vmul.i32 q4, q4, q7
; CHECK-NEXT:    vadd.i32 q3, q4, q3
; CHECK-NEXT:    vldrw.u32 q4, [sp] @ 16-byte Reload
; CHECK-NEXT:    vmul.i32 q1, q1, q4
; CHECK-NEXT:    vadd.i32 q1, q3, q1
; CHECK-NEXT:    vadd.i32 q1, q1, q0
; CHECK-NEXT:    vldrw.u32 q0, [sp, #192] @ 16-byte Reload
; CHECK-NEXT:    vshr.u32 q1, q1, #16
; CHECK-NEXT:    vstrb.32 q1, [r1, q0]
; CHECK-NEXT:    vldrw.u32 q0, [sp, #176] @ 16-byte Reload
; CHECK-NEXT:    vstrb.32 q2, [r1, q0]
; CHECK-NEXT:    vstrb.32 q6, [r1, q5]
; CHECK-NEXT:    adds r1, #12
; CHECK-NEXT:    letp lr, .LBB3_2
; CHECK-NEXT:  .LBB3_3: @ %for.cond.cleanup
; CHECK-NEXT:    add sp, #216
; CHECK-NEXT:    vpop {d8, d9, d10, d11, d12, d13, d14, d15}
; CHECK-NEXT:    pop.w {r4, r5, r6, r7, r8, pc}
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.4:
; CHECK-NEXT:  .LCPI3_0:
; CHECK-NEXT:    .long 4294952177 @ 0xffffc4f1
; CHECK-NEXT:    .long 4294952177 @ 0xffffc4f1
; CHECK-NEXT:    .long 4294952177 @ 0xffffc4f1
; CHECK-NEXT:    .long 4294952177 @ 0xffffc4f1
; CHECK-NEXT:  .LCPI3_1:
; CHECK-NEXT:    .long 19485 @ 0x4c1d
; CHECK-NEXT:    .long 19485 @ 0x4c1d
; CHECK-NEXT:    .long 19485 @ 0x4c1d
; CHECK-NEXT:    .long 19485 @ 0x4c1d
; CHECK-NEXT:  .LCPI3_2:
; CHECK-NEXT:    .long 2 @ 0x2
; CHECK-NEXT:    .long 5 @ 0x5
; CHECK-NEXT:    .long 8 @ 0x8
; CHECK-NEXT:    .long 11 @ 0xb
; CHECK-NEXT:  .LCPI3_3:
; CHECK-NEXT:    .long 13282 @ 0x33e2
; CHECK-NEXT:    .long 13282 @ 0x33e2
; CHECK-NEXT:    .long 13282 @ 0x33e2
; CHECK-NEXT:    .long 13282 @ 0x33e2
; CHECK-NEXT:  .LCPI3_4:
; CHECK-NEXT:    .long 4294934529 @ 0xffff8001
; CHECK-NEXT:    .long 4294934529 @ 0xffff8001
; CHECK-NEXT:    .long 4294934529 @ 0xffff8001
; CHECK-NEXT:    .long 4294934529 @ 0xffff8001
; CHECK-NEXT:  .LCPI3_5:
; CHECK-NEXT:    .long 1 @ 0x1
; CHECK-NEXT:    .long 4 @ 0x4
; CHECK-NEXT:    .long 7 @ 0x7
; CHECK-NEXT:    .long 10 @ 0xa
; CHECK-NEXT:  .LCPI3_6:
; CHECK-NEXT:    .long 0 @ 0x0
; CHECK-NEXT:    .long 3 @ 0x3
; CHECK-NEXT:    .long 6 @ 0x6
; CHECK-NEXT:    .long 9 @ 0x9
; CHECK-NEXT:  .LCPI3_7:
; CHECK-NEXT:    .long 4294949648 @ 0xffffbb10
; CHECK-NEXT:    .long 4294949648 @ 0xffffbb10
; CHECK-NEXT:    .long 4294949648 @ 0xffffbb10
; CHECK-NEXT:    .long 4294949648 @ 0xffffbb10
; CHECK-NEXT:  .LCPI3_8:
; CHECK-NEXT:    .long 7471 @ 0x1d2f
; CHECK-NEXT:    .long 7471 @ 0x1d2f
; CHECK-NEXT:    .long 7471 @ 0x1d2f
; CHECK-NEXT:    .long 7471 @ 0x1d2f
; CHECK-NEXT:  .LCPI3_9:
; CHECK-NEXT:    .long 19595 @ 0x4c8b
; CHECK-NEXT:    .long 19595 @ 0x4c8b
; CHECK-NEXT:    .long 19595 @ 0x4c8b
; CHECK-NEXT:    .long 19595 @ 0x4c8b
; CHECK-NEXT:  .LCPI3_10:
; CHECK-NEXT:    .long 38470 @ 0x9646
; CHECK-NEXT:    .long 38470 @ 0x9646
; CHECK-NEXT:    .long 38470 @ 0x9646
; CHECK-NEXT:    .long 38470 @ 0x9646
entry:
  %cmp47.not = icmp eq i32 %N, 0
  br i1 %cmp47.not, label %for.cond.cleanup, label %vector.ph

vector.ph:                                        ; preds = %vector.memcheck
  %n.rnd.up = add i32 %N, 3
  %n.vec = and i32 %n.rnd.up, -4
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %pointer.phi = phi i8* [ %r, %vector.ph ], [ %ptr.ind, %vector.body ]
  %pointer.phi55 = phi i8* [ %w, %vector.ph ], [ %ptr.ind56, %vector.body ]
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %l1 = getelementptr i8, i8* %pointer.phi, <4 x i32> <i32 0, i32 3, i32 6, i32 9>
  %l2 = getelementptr i8, i8* %pointer.phi55, <4 x i32> <i32 0, i32 3, i32 6, i32 9>
  %l3 = getelementptr inbounds i8, <4 x i8*> %l1, i32 1
  %active.lane.mask = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %N)
  %wide.masked.gather = call <4 x i8> @llvm.masked.gather.v4i8.v4p0i8(<4 x i8*> %l1, i32 1, <4 x i1> %active.lane.mask, <4 x i8> undef)
  %l4 = getelementptr inbounds i8, <4 x i8*> %l1, i32 2
  %wide.masked.gather57 = call <4 x i8> @llvm.masked.gather.v4i8.v4p0i8(<4 x i8*> %l3, i32 1, <4 x i1> %active.lane.mask, <4 x i8> undef)
  %wide.masked.gather58 = call <4 x i8> @llvm.masked.gather.v4i8.v4p0i8(<4 x i8*> %l4, i32 1, <4 x i1> %active.lane.mask, <4 x i8> undef)
  %l5 = zext <4 x i8> %wide.masked.gather to <4 x i32>
  %l6 = mul nuw nsw <4 x i32> %l5, <i32 19595, i32 19595, i32 19595, i32 19595>
  %l7 = zext <4 x i8> %wide.masked.gather57 to <4 x i32>
  %l8 = mul nuw nsw <4 x i32> %l7, <i32 38470, i32 38470, i32 38470, i32 38470>
  %l9 = zext <4 x i8> %wide.masked.gather58 to <4 x i32>
  %l10 = mul nuw nsw <4 x i32> %l9, <i32 7471, i32 7471, i32 7471, i32 7471>
  %l11 = add nuw nsw <4 x i32> %l6, <i32 32768, i32 32768, i32 32768, i32 32768>
  %l12 = add nuw nsw <4 x i32> %l11, %l8
  %l13 = add nuw nsw <4 x i32> %l12, %l10
  %l14 = lshr <4 x i32> %l13, <i32 16, i32 16, i32 16, i32 16>
  %l15 = trunc <4 x i32> %l14 to <4 x i8>
  %l16 = mul nuw nsw <4 x i32> %l5, <i32 32767, i32 32767, i32 32767, i32 32767>
  %l17 = mul nsw <4 x i32> %l7, <i32 -15119, i32 -15119, i32 -15119, i32 -15119>
  %l18 = mul nsw <4 x i32> %l9, <i32 -17648, i32 -17648, i32 -17648, i32 -17648>
  %l19 = add nuw nsw <4 x i32> %l16, <i32 32768, i32 32768, i32 32768, i32 32768>
  %l20 = add nsw <4 x i32> %l19, %l17
  %l21 = add nsw <4 x i32> %l20, %l18
  %l22 = lshr <4 x i32> %l21, <i32 16, i32 16, i32 16, i32 16>
  %l23 = trunc <4 x i32> %l22 to <4 x i8>
  %l24 = mul nuw nsw <4 x i32> %l5, <i32 13282, i32 13282, i32 13282, i32 13282>
  %l25 = mul nsw <4 x i32> %l7, <i32 -32767, i32 -32767, i32 -32767, i32 -32767>
  %l26 = mul nuw nsw <4 x i32> %l9, <i32 19485, i32 19485, i32 19485, i32 19485>
  %l27 = add nuw nsw <4 x i32> %l24, <i32 32768, i32 32768, i32 32768, i32 32768>
  %l28 = add nsw <4 x i32> %l27, %l25
  %l29 = add nsw <4 x i32> %l28, %l26
  %l30 = lshr <4 x i32> %l29, <i32 16, i32 16, i32 16, i32 16>
  %l31 = trunc <4 x i32> %l30 to <4 x i8>
  %l32 = getelementptr inbounds i8, <4 x i8*> %l2, i32 1
  call void @llvm.masked.scatter.v4i8.v4p0i8(<4 x i8> %l15, <4 x i8*> %l2, i32 1, <4 x i1> %active.lane.mask)
  %l33 = getelementptr inbounds i8, <4 x i8*> %l2, i32 2
  call void @llvm.masked.scatter.v4i8.v4p0i8(<4 x i8> %l23, <4 x i8*> %l32, i32 1, <4 x i1> %active.lane.mask)
  call void @llvm.masked.scatter.v4i8.v4p0i8(<4 x i8> %l31, <4 x i8*> %l33, i32 1, <4 x i1> %active.lane.mask)
  %index.next = add i32 %index, 4
  %l34 = icmp eq i32 %index.next, %n.vec
  %ptr.ind = getelementptr i8, i8* %pointer.phi, i32 12
  %ptr.ind56 = getelementptr i8, i8* %pointer.phi55, i32 12
  br i1 %l34, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %for.body, %entry
  ret void
}

declare i32 @llvm.vector.reduce.add.v4i32(<4 x i32>)
declare <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*>, i32, <4 x i1>, <4 x i32>)
declare <4 x i8> @llvm.masked.gather.v4i8.v4p0i8(<4 x i8*>, i32, <4 x i1>, <4 x i8>)
declare <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32, i32)
declare <4 x i32> @llvm.masked.load.v4i32.p0v4i32(<4 x i32>*, i32, <4 x i1>, <4 x i32>)
declare void @llvm.masked.scatter.v4i32.v4p0i32(<4 x i32>, <4 x i32*>, i32, <4 x i1>)
declare void @llvm.masked.scatter.v4i8.v4p0i8(<4 x i8>, <4 x i8*>, i32, <4 x i1>)
