Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f70.google.com ([209.85.166.70]:55012 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbeKBBzu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2018 21:55:50 -0400
Received: by mail-io1-f70.google.com with SMTP id q26-v6so18082096ioi.21
        for <linux-media@vger.kernel.org>; Thu, 01 Nov 2018 09:52:04 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 01 Nov 2018 09:52:04 -0700
Message-ID: <00000000000003dc7805799d3dd8@google.com>
Subject: INFO: task hung in flush_workqueue
From: syzbot <syzbot+69780d144754b8071f4b@syzkaller.appspotmail.com>
To: ezequiel@collabora.com, hansverk@cisco.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        mchehab@kernel.org, sakari.ailus@linux.intel.com,
        scileont@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

syzbot found the following crash on:

HEAD commit:    4db9d11bcbef Add linux-next specific files for 20181101
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16bb4425400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2a22859d870756c1
dashboard link: https://syzkaller.appspot.com/bug?extid=69780d144754b8071f4b
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+69780d144754b8071f4b@syzkaller.appspotmail.com

IPVS: wrr: SCTP 172.20.20.170:0 - no destination available
EXT4-fs error (device sda1): ext4_remount:5216: Abort forced by user
EXT4-fs (sda1): Remounting filesystem read-only
INFO: task syz-executor0:12469 blocked for more than 140 seconds.
       Not tainted 4.19.0-next-20181101+ #103
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor0   D21208 12469  11524 0x00000004
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
  v4l2_m2m_ctx_release+0x2a/0x35 drivers/media/v4l2-core/v4l2-mem2mem.c:931
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
RIP: 0033:0x457569
Code: Bad RIP value.
RSP: 002b:00007fac56403c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000457569
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 000000000072bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fac564046d4
R13: 00000000004efe32 R14: 00000000004cc6e0 R15: 00000000ffffffff

Showing all locks held in the system:
1 lock held by khungtaskd/1009:
  #0: 00000000e84c6b38 (rcu_read_lock){....}, at:  
debug_show_all_locks+0xd0/0x424 kernel/locking/lockdep.c:4379
1 lock held by udevd/3501:
1 lock held by rsyslogd/5533:
  #0: 000000006dc20f7b (&f->f_pos_lock){+.+.}, at: __fdget_pos+0x1bb/0x200  
fs/file.c:766
2 locks held by getty/5623:
  #0: 0000000031a1a60d (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 0000000015d4fdea (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1e80 drivers/tty/n_tty.c:2154
2 locks held by getty/5624:
  #0: 000000004fa09fe3 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 00000000e2ec2afa (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1e80 drivers/tty/n_tty.c:2154
2 locks held by getty/5625:
  #0: 000000000b6bdc9d (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 000000000ad48c56 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1e80 drivers/tty/n_tty.c:2154
2 locks held by getty/5626:
  #0: 000000007720a28b (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 0000000090a35a2c (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1e80 drivers/tty/n_tty.c:2154
2 locks held by getty/5627:
  #0: 00000000c511ad6c (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 00000000beb7d44a (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1e80 drivers/tty/n_tty.c:2154
2 locks held by getty/5628:
  #0: 000000009dbb3d36 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 00000000de06e26d (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1e80 drivers/tty/n_tty.c:2154
2 locks held by getty/5629:
  #0: 00000000ccb92b09 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 00000000191edc69 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1e80 drivers/tty/n_tty.c:2154
2 locks held by kworker/0:4/7412:
  #0: 00000000062cd1fa ((wq_completion)"events"){+.+.}, at:  
__write_once_size include/linux/compiler.h:209 [inline]
  #0: 00000000062cd1fa ((wq_completion)"events"){+.+.}, at:  
arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
  #0: 00000000062cd1fa ((wq_completion)"events"){+.+.}, at: atomic64_set  
include/asm-generic/atomic-instrumented.h:40 [inline]
  #0: 00000000062cd1fa ((wq_completion)"events"){+.+.}, at: atomic_long_set  
include/asm-generic/atomic-long.h:59 [inline]
  #0: 00000000062cd1fa ((wq_completion)"events"){+.+.}, at: set_work_data  
kernel/workqueue.c:617 [inline]
  #0: 00000000062cd1fa ((wq_completion)"events"){+.+.}, at:  
set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
  #0: 00000000062cd1fa ((wq_completion)"events"){+.+.}, at:  
process_one_work+0xb43/0x1c40 kernel/workqueue.c:2124
  #1: 000000003fe6abd7 ((work_completion)(&smc->tcp_listen_work)){+.+.}, at:  
process_one_work+0xb9a/0x1c40 kernel/workqueue.c:2128
2 locks held by syz-executor0/12469:
  #0: 00000000e32d2d8c (&mdev->req_queue_mutex){+.+.}, at:  
v4l2_release+0x1d7/0x3a0 drivers/media/v4l2-core/v4l2-dev.c:455
  #1: 0000000023d4a01f (&dev->dev_mutex){+.+.}, at: vim2m_release+0xbc/0x150  
drivers/media/platform/vim2m.c:976

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1009 Comm: khungtaskd Not tainted 4.19.0-next-20181101+ #103
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
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.004  
msecs
NMI backtrace for cpu 0
CPU: 0 PID: 3501 Comm: udevd Not tainted 4.19.0-next-20181101+ #103
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__lock_acquire+0xc9/0x4c20 kernel/locking/lockdep.c:3206
Code: c7 40 24 f2 f2 f2 f2 c7 40 28 04 f2 f2 f2 c7 40 2c f2 f2 f2 f2 c7 40  
30 00 f2 f2 f2 c7 40 34 f2 f2 f2 f2 c7 40 38 00 f2 f2 f2 <c7> 40 3c f2 f2  
f2 f2 c7 40 40 00 f2 f2 f2 c7 40 44 f2 f2 f2 f2 c7
RSP: 0018:ffff8801c7387190 EFLAGS: 00000082
RAX: ffffed0038e70e46 RBX: 1ffff10038e70eae RCX: 0000000000000000
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: ffff8801c6a42b18
RBP: ffff8801c7387518 R08: 0000000000000001 R09: 0000000000000001
R10: ffffed0038e6c6f7 R11: ffff8801c73637bf R12: ffff8801c7378580
R13: ffff8801c6a42b18 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fa5bdbf37a0(0000) GS:ffff8801dae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 00000001c72bd000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000020000000 DR2: 0000000020000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000010602
Call Trace:
  lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3844
  __raw_spin_lock_irq include/linux/spinlock_api_smp.h:128 [inline]
  _raw_spin_lock_irq+0x61/0x80 kernel/locking/spinlock.c:160
  spin_lock_irq include/linux/spinlock.h:354 [inline]
  ep_scan_ready_list+0x4cb/0x1050 fs/eventpoll.c:710
  ep_send_events fs/eventpoll.c:1713 [inline]
  ep_poll+0x572/0x13d0 fs/eventpoll.c:1840
  do_epoll_wait+0x1b0/0x200 fs/eventpoll.c:2198
  __do_sys_epoll_wait fs/eventpoll.c:2208 [inline]
  __se_sys_epoll_wait fs/eventpoll.c:2205 [inline]
  __x64_sys_epoll_wait+0x97/0xf0 fs/eventpoll.c:2205
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7fa5bd307943
Code: 00 31 d2 48 29 c2 64 89 11 48 83 c8 ff eb ea 90 90 90 90 90 90 90 90  
83 3d b5 dc 2a 00 00 75 13 49 89 ca b8 e8 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 73 34 c3 48 83 ec 08 e8 3b c4 00 00 48 89 04 24
RSP: 002b:00007ffd0f4810e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
RAX: ffffffffffffffda RBX: 0000000000000bb8 RCX: 00007fa5bd307943
RDX: 0000000000000008 RSI: 00007ffd0f4811e0 RDI: 000000000000000a
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000bb8 R11: 0000000000000246 R12: 0000000000000003
R13: 0000000000000000 R14: 0000000000db8230 R15: 0000000000db2250


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
