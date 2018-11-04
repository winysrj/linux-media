Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f70.google.com ([209.85.166.70]:53546 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728884AbeKDQxE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Nov 2018 11:53:04 -0500
Received: by mail-io1-f70.google.com with SMTP id z17-v6so6811750iol.20
        for <linux-media@vger.kernel.org>; Sun, 04 Nov 2018 00:39:04 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 04 Nov 2018 00:39:03 -0700
In-Reply-To: <00000000000003dc7805799d3dd8@google.com>
Message-ID: <000000000000d575800579d1dc22@google.com>
Subject: Re: INFO: task hung in flush_workqueue
From: syzbot <syzbot+69780d144754b8071f4b@syzkaller.appspotmail.com>
To: ezequiel@collabora.com, hansverk@cisco.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        mchehab@kernel.org, sakari.ailus@linux.intel.com,
        scileont@gmail.com, syzkaller-bugs@googlegroups.com,
        tfiga@chromium.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

syzbot has found a reproducer for the following crash on:

HEAD commit:    d2ff0ff2c23f Merge tag 'armsoc-fixes' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1128a447400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9384ecb1c973baed
dashboard link: https://syzkaller.appspot.com/bug?extid=69780d144754b8071f4b
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12c67583400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15ce682b400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+69780d144754b8071f4b@syzkaller.appspotmail.com

sshd (5562) used greatest stack depth: 15232 bytes left
INFO: task syz-executor757:5654 blocked for more than 140 seconds.
       Not tainted 4.19.0+ #96
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor757 D23632  5654   5653 0x00000004
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
  __fput+0x385/0xa30 fs/file_table.c:278
  ____fput+0x15/0x20 fs/file_table.c:309
  task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x318/0x380 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_64+0x6be/0x820 arch/x86/entry/common.c:293
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x401010
Code: 01 f0 ff ff 0f 83 b0 0a 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f  
44 00 00 83 3d bd 56 2d 00 00 75 14 b8 03 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 84 0a 00 00 c3 48 83 ec 08 e8 3a 01 00 00
RSP: 002b:00007ffea5ab70f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000401010
RDX: 0000000000444bb9 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00000000004002e0 R09: 00000000004002e0
R10: 00000000004002e0 R11: 0000000000000246 R12: 0000000000401f20
R13: 0000000000401fb0 R14: 0000000000000000 R15: 0000000000000000

Showing all locks held in the system:
2 locks held by kworker/0:1/12:
  #0: 000000003db4b92e ((wq_completion)"events"){+.+.}, at:  
__write_once_size include/linux/compiler.h:209 [inline]
  #0: 000000003db4b92e ((wq_completion)"events"){+.+.}, at:  
arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
  #0: 000000003db4b92e ((wq_completion)"events"){+.+.}, at: atomic64_set  
include/asm-generic/atomic-instrumented.h:40 [inline]
  #0: 000000003db4b92e ((wq_completion)"events"){+.+.}, at: atomic_long_set  
include/asm-generic/atomic-long.h:59 [inline]
  #0: 000000003db4b92e ((wq_completion)"events"){+.+.}, at: set_work_data  
kernel/workqueue.c:617 [inline]
  #0: 000000003db4b92e ((wq_completion)"events"){+.+.}, at:  
set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
  #0: 000000003db4b92e ((wq_completion)"events"){+.+.}, at:  
process_one_work+0xb43/0x1c40 kernel/workqueue.c:2124
  #1: 0000000083c4fc0a ((work_completion)(&smc->tcp_listen_work)){+.+.}, at:  
process_one_work+0xb9a/0x1c40 kernel/workqueue.c:2128
1 lock held by khungtaskd/1008:
  #0: 000000003c4b94d4 (rcu_read_lock){....}, at:  
debug_show_all_locks+0xd0/0x424 kernel/locking/lockdep.c:4379
1 lock held by rsyslogd/5534:
  #0: 0000000041dcaab2 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0x1bb/0x200  
fs/file.c:766
2 locks held by getty/5624:
  #0: 0000000073aea0d8 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 000000004c00cd31 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1e80 drivers/tty/n_tty.c:2154
2 locks held by getty/5625:
  #0: 00000000c279c8f4 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 00000000eaef601a (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1e80 drivers/tty/n_tty.c:2154
2 locks held by getty/5626:
  #0: 00000000567f14a1 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 0000000058a33d5c (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1e80 drivers/tty/n_tty.c:2154
2 locks held by getty/5627:
  #0: 000000000f3b388a (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 000000000aaec5cb (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1e80 drivers/tty/n_tty.c:2154
2 locks held by getty/5628:
  #0: 0000000035919afe (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 000000005e82b5c4 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1e80 drivers/tty/n_tty.c:2154
2 locks held by getty/5629:
  #0: 00000000a3f8ebad (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 00000000781d9ee1 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1e80 drivers/tty/n_tty.c:2154
2 locks held by getty/5630:
  #0: 00000000a18cad08 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 000000004050d1ff (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1e80 drivers/tty/n_tty.c:2154
2 locks held by syz-executor757/5654:
  #0: 00000000d91243c4 (&mdev->req_queue_mutex){+.+.}, at:  
v4l2_release+0x1d7/0x3a0 drivers/media/v4l2-core/v4l2-dev.c:455
  #1: 000000005b9f9534 (&dev->dev_mutex){+.+.}, at: vim2m_release+0xbc/0x150  
drivers/media/platform/vim2m.c:976

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1008 Comm: khungtaskd Not tainted 4.19.0+ #96
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
  watchdog+0xb51/0x1060 kernel/hung_task.c:289
  kthread+0x35a/0x440 kernel/kthread.c:246
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.19.0+ #96
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__sanitizer_cov_trace_pc+0x0/0x50 kernel/kcov.c:146
Code: 14 dd 28 00 00 00 4d 39 d0 72 1b 49 83 c1 01 4a 89 7c 10 e0 4a 89 74  
10 e8 4a 89 54 10 f0 4a 89 4c d8 20 4c 89 08 5d c3 66 90 <55> 48 89 e5 48  
8b 75 08 65 48 8b 04 25 40 ee 01 00 65 8b 15 c8 75
RSP: 0018:ffff8801dae07c18 EFLAGS: 00000082
RAX: ffffffff89476ec0 RBX: 0000000000026620 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffffffff8860b9e0 RDI: ffffffff8860ba20
RBP: ffff8801dae07c50 R08: 0000000000000000 R09: 0000000000000001
R10: ffffed003b5c5b67 R11: ffff8801dae2db3b R12: 1ffff1003b5c0fa1
R13: ffffffff8860ba20 R14: ffffffff8860b9e0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8801dae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000b0e000 CR3: 00000001bb536000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  <IRQ>
  debug_smp_processor_id+0x1c/0x20 lib/smp_processor_id.c:56
  tick_check_oneshot_broadcast_this_cpu+0x15/0x130  
kernel/time/tick-broadcast.c:581
  tick_irq_enter+0x22/0x3e0 kernel/time/tick-sched.c:1248
  irq_enter+0xbd/0xe0 kernel/softirq.c:354
  scheduler_ipi+0x3d0/0xad0 kernel/sched/core.c:1775
  smp_reschedule_interrupt+0x109/0x650 arch/x86/kernel/smp.c:278
  reschedule_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:828
  </IRQ>
RIP: 0010:native_safe_halt+0x6/0x10 arch/x86/include/asm/irqflags.h:57
Code: e9 2c ff ff ff 48 89 c7 48 89 45 d8 e8 83 d8 f3 f9 48 8b 45 d8 e9 ca  
fe ff ff 48 89 df e8 72 d8 f3 f9 eb 82 55 48 89 e5 fb f4 <5d> c3 0f 1f 84  
00 00 00 00 00 55 48 89 e5 f4 5d c3 90 90 90 90 90
RSP: 0018:ffffffff89407c10 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff02
RAX: dffffc0000000000 RBX: 1ffffffff1280f86 RCX: 0000000000000000
RDX: 1ffffffff12a3f59 RSI: 0000000000000001 RDI: ffffffff8951fac8
RBP: ffffffff89407c10 R08: ffffffff89476ec0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff89407cd0
R13: ffffffff8a14c8a0 R14: 0000000000000000 R15: 0000000000000000
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
