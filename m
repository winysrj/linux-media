Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f198.google.com ([209.85.166.198]:35836 "EHLO
        mail-it1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389129AbeKGLUQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Nov 2018 06:20:16 -0500
Received: by mail-it1-f198.google.com with SMTP id n135-v6so19540206ita.0
        for <linux-media@vger.kernel.org>; Tue, 06 Nov 2018 17:52:04 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 06 Nov 2018 17:52:03 -0800
Message-ID: <000000000000684853057a095db3@google.com>
Subject: INFO: task hung in v4l2_release
From: syzbot <syzbot+04358ffffff96230ad9a@syzkaller.appspotmail.com>
To: ezequiel@collabora.com, hans.verkuil@cisco.com,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, sque@chromium.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

syzbot found the following crash on:

HEAD commit:    337734cbca74 Add linux-next specific files for 20181106
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=158ad2f5400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=350e6ed8e2c7f2e1
dashboard link: https://syzkaller.appspot.com/bug?extid=04358ffffff96230ad9a
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+04358ffffff96230ad9a@syzkaller.appspotmail.com

INFO: task syz-executor3:13875 blocked for more than 140 seconds.
       Not tainted 4.20.0-rc1-next-20181106+ #106
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor3   D23400 13875   5736 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:2831 [inline]
  __schedule+0x8cf/0x21d0 kernel/sched/core.c:3472
  schedule+0xfe/0x460 kernel/sched/core.c:3516
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:3574
  __mutex_lock_common kernel/locking/mutex.c:1002 [inline]
  __mutex_lock+0xaff/0x16f0 kernel/locking/mutex.c:1072
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
  v4l2_release+0x1d7/0x3a0 drivers/media/v4l2-core/v4l2-dev.c:455
  __fput+0x3bc/0xa70 fs/file_table.c:279
  ____fput+0x15/0x20 fs/file_table.c:312
  task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x318/0x380 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_64+0x6be/0x820 arch/x86/entry/common.c:293
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x411021
Code: 4c 89 f6 48 89 c7 48 89 ca 48 89 4c 24 10 4c 89 54 24 08 e8 b1 a3 ff  
ff 48 8b 4c 24 10 41 c6 04 0f 00 4c 8b 7c 24 28 4c 8b 54 <24> 08 45 0f b6  
37 e9 db fc ff ff 0f 1f 40 00 41 80 f8 29 74 7f ba
RSP: 002b:00007ffd4b98ca60 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000007 RCX: 0000000000411021
RDX: 0000000000000000 RSI: 0000000000730d58 RDI: 0000000000000006
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 00007ffd4b98c990 R11: 0000000000000293 R12: 0000000000000000
R13: 0000000000000001 R14: 00000000000000f8 R15: 0000000000000003
INFO: task syz-executor5:13877 blocked for more than 140 seconds.
       Not tainted 4.20.0-rc1-next-20181106+ #106
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor5   D23384 13877   5810 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:2831 [inline]
  __schedule+0x8cf/0x21d0 kernel/sched/core.c:3472
  schedule+0xfe/0x460 kernel/sched/core.c:3516
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:3574
  __mutex_lock_common kernel/locking/mutex.c:1002 [inline]
  __mutex_lock+0xaff/0x16f0 kernel/locking/mutex.c:1072
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
  v4l2_release+0x1d7/0x3a0 drivers/media/v4l2-core/v4l2-dev.c:455
  __fput+0x3bc/0xa70 fs/file_table.c:279
  ____fput+0x15/0x20 fs/file_table.c:312
  task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x318/0x380 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_64+0x6be/0x820 arch/x86/entry/common.c:293
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x411021
Code: Bad RIP value.
RSP: 002b:00007ffe6457c900 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000411021
RDX: 0000000000000000 RSI: 0000000000730d58 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 00007ffe6457c830 R11: 0000000000000293 R12: 0000000000000000
R13: 0000000000000001 R14: 000000000000011c R15: 0000000000000005
INFO: task syz-executor4:13878 blocked for more than 140 seconds.
       Not tainted 4.20.0-rc1-next-20181106+ #106
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor4   D23384 13878   5779 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:2831 [inline]
  __schedule+0x8cf/0x21d0 kernel/sched/core.c:3472
  schedule+0xfe/0x460 kernel/sched/core.c:3516
  schedule_timeout+0x1cc/0x260 kernel/time/timer.c:1780
  do_wait_for_common kernel/sched/completion.c:83 [inline]
  __wait_for_common kernel/sched/completion.c:104 [inline]
  wait_for_common kernel/sched/completion.c:115 [inline]
  wait_for_completion+0x427/0x8a0 kernel/sched/completion.c:136
  flush_workqueue+0x742/0x1e10 kernel/workqueue.c:2707
  flush_scheduled_work include/linux/workqueue.h:599 [inline]
  vim2m_stop_streaming+0x7c/0x2c0 drivers/media/platform/vim2m.c:811
  __vb2_queue_cancel+0x171/0xd20  
drivers/media/common/videobuf2/videobuf2-core.c:1823
  vb2_core_queue_release+0x26/0x80  
drivers/media/common/videobuf2/videobuf2-core.c:2229
  vb2_queue_release+0x15/0x20  
drivers/media/common/videobuf2/videobuf2-v4l2.c:837
  v4l2_m2m_ctx_release+0x1e/0x35 drivers/media/v4l2-core/v4l2-mem2mem.c:930
  vim2m_release+0xe6/0x150 drivers/media/platform/vim2m.c:977
  v4l2_release+0x224/0x3a0 drivers/media/v4l2-core/v4l2-dev.c:456
  __fput+0x3bc/0xa70 fs/file_table.c:279
  ____fput+0x15/0x20 fs/file_table.c:312
  task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x318/0x380 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_64+0x6be/0x820 arch/x86/entry/common.c:293
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x411021
Code: Bad RIP value.
RSP: 002b:00007ffdaa37b4a0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000411021
RDX: 0000000000000000 RSI: 0000000000731270 RDI: 0000000000000004
RBP: 0000000000000000 R08: ffffffff8100c717 R09: 00000000abbee66b
R10: 00007ffdaa37b3d0 R11: 0000000000000293 R12: 0000000000000000
R13: 0000000000000001 R14: 0000000000000114 R15: 0000000000000004

Showing all locks held in the system:
1 lock held by khungtaskd/1008:
  #0: 00000000ed38eb10 (rcu_read_lock){....}, at:  
debug_show_all_locks+0xd0/0x424 kernel/locking/lockdep.c:4379
2 locks held by kworker/0:2/2895:
  #0: 000000002e0c0567 ((wq_completion)"events"){+.+.}, at:  
__write_once_size include/linux/compiler.h:209 [inline]
  #0: 000000002e0c0567 ((wq_completion)"events"){+.+.}, at:  
arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
  #0: 000000002e0c0567 ((wq_completion)"events"){+.+.}, at: atomic64_set  
include/asm-generic/atomic-instrumented.h:855 [inline]
  #0: 000000002e0c0567 ((wq_completion)"events"){+.+.}, at: atomic_long_set  
include/asm-generic/atomic-long.h:40 [inline]
  #0: 000000002e0c0567 ((wq_completion)"events"){+.+.}, at: set_work_data  
kernel/workqueue.c:617 [inline]
  #0: 000000002e0c0567 ((wq_completion)"events"){+.+.}, at:  
set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
  #0: 000000002e0c0567 ((wq_completion)"events"){+.+.}, at:  
process_one_work+0xb43/0x1c40 kernel/workqueue.c:2124
  #1: 00000000da82564a ((work_completion)(&smc->tcp_listen_work)){+.+.}, at:  
process_one_work+0xb9a/0x1c40 kernel/workqueue.c:2128
1 lock held by rsyslogd/5540:
2 locks held by getty/5630:
  #0: 00000000efc28675 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 0000000035b6a41c (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1e80 drivers/tty/n_tty.c:2154
2 locks held by getty/5631:
  #0: 00000000c82febb3 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 0000000056a592af (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1e80 drivers/tty/n_tty.c:2154
2 locks held by getty/5632:
  #0: 00000000f20cd548 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 00000000c9808e8a (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1e80 drivers/tty/n_tty.c:2154
2 locks held by getty/5633:
  #0: 00000000af555bd9 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 00000000df290bec (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1e80 drivers/tty/n_tty.c:2154
2 locks held by getty/5634:
  #0: 000000001a06628e (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 00000000289f9c9a (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1e80 drivers/tty/n_tty.c:2154
2 locks held by getty/5635:
  #0: 00000000d9e26688 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 0000000048b8aeef (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1e80 drivers/tty/n_tty.c:2154
2 locks held by getty/5636:
  #0: 00000000ea8d0ac8 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 00000000a23c157e (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1e80 drivers/tty/n_tty.c:2154
1 lock held by syz-executor3/13875:
  #0: 00000000580cc067 (&mdev->req_queue_mutex){+.+.}, at:  
v4l2_release+0x1d7/0x3a0 drivers/media/v4l2-core/v4l2-dev.c:455
1 lock held by syz-executor5/13877:
  #0: 00000000580cc067 (&mdev->req_queue_mutex){+.+.}, at:  
v4l2_release+0x1d7/0x3a0 drivers/media/v4l2-core/v4l2-dev.c:455
2 locks held by syz-executor4/13878:
  #0: 00000000580cc067 (&mdev->req_queue_mutex){+.+.}, at:  
v4l2_release+0x1d7/0x3a0 drivers/media/v4l2-core/v4l2-dev.c:455
  #1: 00000000813f08e9 (&dev->dev_mutex){+.+.}, at: vim2m_release+0xbc/0x150  
drivers/media/platform/vim2m.c:976

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1008 Comm: khungtaskd Not tainted 4.20.0-rc1-next-20181106+ #106
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x244/0x39d lib/dump_stack.c:113
  nmi_cpu_backtrace.cold.2+0x5c/0xa1 lib/nmi_backtrace.c:101
  nmi_trigger_cpumask_backtrace+0x1e8/0x22a lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_all_cpu_backtrace include/linux/nmi.h:144 [inline]
  check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
  watchdog+0xb4c/0x1060 kernel/hung_task.c:289
  kthread+0x35a/0x440 kernel/kthread.c:246
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.20.0-rc1-next-20181106+ #106
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:rcu_dynticks_curr_cpu_in_eqs+0x4e/0x170 kernel/rcu/tree.c:289
Code: 48 c1 eb 03 48 83 ec 68 48 c7 45 80 b3 8a b5 41 4a 8d 04 33 48 c7 45  
88 d8 7b 0f 89 48 c7 45 90 30 45 6a 81 c7 00 f1 f1 f1 f1 <c7> 40 04 04 f2  
f2 f2 65 48 8b 04 25 28 00 00 00 48 89 45 d8 31 c0
RSP: 0018:ffff8801dae07b50 EFLAGS: 00000086
RAX: ffffed003b5c0f6b RBX: 1ffff1003b5c0f6b RCX: 0000000000000002
RDX: 0000000000000000 RSI: ffffffff8394ec58 RDI: ffffffff8947773c
RBP: ffff8801dae07bd8 R08: ffffffff89476ec0 R09: ffffed003b5c59a9
R10: ffffed003b5c59a9 R11: ffff8801dae2cd4b R12: 000000000002da80
R13: ffff8801dae07bb8 R14: dffffc0000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8801dae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa5fbc574c1 CR3: 00000001bc1bd000 CR4: 00000000001406f0
DR0: 000000000000b8c4 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  <IRQ>
  rcu_is_watching+0x10/0x30 kernel/rcu/tree.c:906
  rcu_read_lock_sched_held+0x91/0x180 kernel/rcu/update.c:112
  trace_softirq_raise include/trace/events/irq.h:156 [inline]
  __raise_softirq_irqoff kernel/softirq.c:451 [inline]
  raise_softirq_irqoff+0x269/0x2e0 kernel/softirq.c:425
  scheduler_ipi+0x70c/0xad0 kernel/sched/core.c:1783
  smp_reschedule_interrupt+0x109/0x650 arch/x86/kernel/smp.c:278
  reschedule_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:828
  </IRQ>
RIP: 0010:native_safe_halt+0x6/0x10 arch/x86/include/asm/irqflags.h:57
Code: 45 d8 e8 cd 35 f2 f9 48 8b 45 d8 e9 ca fe ff ff 48 89 df e8 bc 35 f2  
f9 eb 82 90 90 90 90 90 90 90 90 90 90 55 48 89 e5 fb f4 <5d> c3 0f 1f 84  
00 00 00 00 00 55 48 89 e5 f4 5d c3 90 90 90 90 90
RSP: 0018:ffffffff89407c10 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff02
RAX: dffffc0000000000 RBX: 1ffffffff1280f86 RCX: 0000000000000000
RDX: 1ffffffff12a3f79 RSI: 0000000000000001 RDI: ffffffff8951fbc8
RBP: ffffffff89407c10 R08: ffffffff89476ec0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff89407cd0
R13: ffffffff8a151e60 R14: 0000000000000000 R15: 0000000000000000
  arch_safe_halt arch/x86/include/asm/paravirt.h:151 [inline]
  default_idle+0xbf/0x490 arch/x86/kernel/process.c:498
  arch_cpu_idle+0x10/0x20 arch/x86/kernel/process.c:489
  default_idle_call+0x6d/0x90 kernel/sched/idle.c:93
  cpuidle_idle_call kernel/sched/idle.c:153 [inline]
  do_idle+0x49b/0x5c0 kernel/sched/idle.c:262
  cpu_startup_entry+0x18/0x20 kernel/sched/idle.c:353
  rest_init+0x243/0x372 init/main.c:443
  arch_call_rest_init+0xe/0x1b
  start_kernel+0x9f0/0xa2b init/main.c:745
  x86_64_start_reservations+0x2e/0x30 arch/x86/kernel/head64.c:472
  x86_64_start_kernel+0x76/0x79 arch/x86/kernel/head64.c:451
  secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:243


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
