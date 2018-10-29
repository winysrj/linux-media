Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f199.google.com ([209.85.166.199]:43548 "EHLO
        mail-it1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727597AbeJ3BLV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Oct 2018 21:11:21 -0400
Received: by mail-it1-f199.google.com with SMTP id m198-v6so4012931itm.8
        for <linux-media@vger.kernel.org>; Mon, 29 Oct 2018 09:22:03 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 29 Oct 2018 09:22:03 -0700
In-Reply-To: <00000000000080601805795ada2e@google.com>
Message-ID: <000000000000264267057960782a@google.com>
Subject: Re: INFO: task hung in vivid_stop_generating_vid_cap
From: syzbot <syzbot+06283a66a648cd073885@syzkaller.appspotmail.com>
To: hverkuil@xs4all.nl, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

syzbot has found a reproducer for the following crash on:

HEAD commit:    9f51ae62c84a Merge git://git.kernel.org/pub/scm/linux/kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14bfad7b400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=62118286bb772a24
dashboard link: https://syzkaller.appspot.com/bug?extid=06283a66a648cd073885
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15701a33400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=154c8e4d400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+06283a66a648cd073885@syzkaller.appspotmail.com

INFO: task syz-executor686:5724 blocked for more than 140 seconds.
       Not tainted 4.19.0+ #309
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor686 D24208  5724   5716 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:2831 [inline]
  __schedule+0x8cf/0x21d0 kernel/sched/core.c:3480
  schedule+0xfe/0x460 kernel/sched/core.c:3524
  schedule_timeout+0x1cc/0x260 kernel/time/timer.c:1780
  do_wait_for_common kernel/sched/completion.c:83 [inline]
  __wait_for_common kernel/sched/completion.c:104 [inline]
  wait_for_common kernel/sched/completion.c:115 [inline]
  wait_for_completion+0x427/0x8a0 kernel/sched/completion.c:136
  kthread_stop+0x1a9/0x900 kernel/kthread.c:550
  vivid_stop_generating_vid_cap+0x2bc/0x93b  
drivers/media/platform/vivid/vivid-kthread-cap.c:919
  vid_cap_stop_streaming+0x8d/0xe0  
drivers/media/platform/vivid/vivid-vid-cap.c:256
  __vb2_queue_cancel+0x171/0xca0  
drivers/media/common/videobuf2/videobuf2-core.c:1659
  vb2_core_streamoff+0x60/0x140  
drivers/media/common/videobuf2/videobuf2-core.c:1795
  __vb2_cleanup_fileio+0x73/0x160  
drivers/media/common/videobuf2/videobuf2-core.c:2316
  vb2_core_queue_release+0x1e/0x80  
drivers/media/common/videobuf2/videobuf2-core.c:2043
  vb2_queue_release drivers/media/common/videobuf2/videobuf2-v4l2.c:672  
[inline]
  _vb2_fop_release+0x1d2/0x2b0  
drivers/media/common/videobuf2/videobuf2-v4l2.c:843
  vb2_fop_release+0x77/0xc0  
drivers/media/common/videobuf2/videobuf2-v4l2.c:857
  vivid_fop_release+0x18e/0x440 drivers/media/platform/vivid/vivid-core.c:474
  v4l2_release+0xfb/0x1a0 drivers/media/v4l2-core/v4l2-dev.c:448
  __fput+0x385/0xa30 fs/file_table.c:278
  ____fput+0x15/0x20 fs/file_table.c:309
  task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x318/0x380 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_64+0x6be/0x820 arch/x86/entry/common.c:293
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x400f00
Code: 00 00 00 00 00 00 00 00 00 00 d6 01 00 00 12 00 00 00 00 00 00 00 00  
00 00 00 00 00 00 00 00 00 00 00 00 03 00 00 12 00 00 00 <00> 00 00 00 00  
00 00 00 00 00 00 00 00 00 00 00 b8 02 00 00 12 00
RSP: 002b:00007ffc53169f28 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000400f00
RDX: 00000000000000d6 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00000000024b1880 R09: 00000000004002e0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401e10
R13: 0000000000401ea0 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor686:5730 blocked for more than 140 seconds.
       Not tainted 4.19.0+ #309
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor686 D24208  5730   5721 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:2831 [inline]
  __schedule+0x8cf/0x21d0 kernel/sched/core.c:3480
  schedule+0xfe/0x460 kernel/sched/core.c:3524
  schedule_timeout+0x1cc/0x260 kernel/time/timer.c:1780
  do_wait_for_common kernel/sched/completion.c:83 [inline]
  __wait_for_common kernel/sched/completion.c:104 [inline]
  wait_for_common kernel/sched/completion.c:115 [inline]
  wait_for_completion+0x427/0x8a0 kernel/sched/completion.c:136
  kthread_stop+0x1a9/0x900 kernel/kthread.c:550
  vivid_stop_generating_vid_cap+0x2bc/0x93b  
drivers/media/platform/vivid/vivid-kthread-cap.c:919
  vid_cap_stop_streaming+0x8d/0xe0  
drivers/media/platform/vivid/vivid-vid-cap.c:256
  __vb2_queue_cancel+0x171/0xca0  
drivers/media/common/videobuf2/videobuf2-core.c:1659
  vb2_core_streamoff+0x60/0x140  
drivers/media/common/videobuf2/videobuf2-core.c:1795
  __vb2_cleanup_fileio+0x73/0x160  
drivers/media/common/videobuf2/videobuf2-core.c:2316
  vb2_core_queue_release+0x1e/0x80  
drivers/media/common/videobuf2/videobuf2-core.c:2043
  vb2_queue_release drivers/media/common/videobuf2/videobuf2-v4l2.c:672  
[inline]
  _vb2_fop_release+0x1d2/0x2b0  
drivers/media/common/videobuf2/videobuf2-v4l2.c:843
  vb2_fop_release+0x77/0xc0  
drivers/media/common/videobuf2/videobuf2-v4l2.c:857
  vivid_fop_release+0x18e/0x440 drivers/media/platform/vivid/vivid-core.c:474
  v4l2_release+0xfb/0x1a0 drivers/media/v4l2-core/v4l2-dev.c:448
  __fput+0x385/0xa30 fs/file_table.c:278
  ____fput+0x15/0x20 fs/file_table.c:309
  task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x318/0x380 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_64+0x6be/0x820 arch/x86/entry/common.c:293
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x400f00
Code: 00 00 00 00 00 00 00 00 00 00 d6 01 00 00 12 00 00 00 00 00 00 00 00  
00 00 00 00 00 00 00 00 00 00 00 00 03 00 00 12 00 00 00 <00> 00 00 00 00  
00 00 00 00 00 00 00 00 00 00 00 b8 02 00 00 12 00
RSP: 002b:00007ffc53169f28 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000400f00
RDX: 00000000000000d6 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00000000024b1880 R09: 00000000004002e0
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000003fbb5
R13: 0000000000401ea0 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor686:5734 blocked for more than 140 seconds.
       Not tainted 4.19.0+ #309
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor686 D21848  5734   5720 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:2831 [inline]
  __schedule+0x8cf/0x21d0 kernel/sched/core.c:3480
  schedule+0xfe/0x460 kernel/sched/core.c:3524
  schedule_timeout+0x1cc/0x260 kernel/time/timer.c:1780
  do_wait_for_common kernel/sched/completion.c:83 [inline]
  __wait_for_common kernel/sched/completion.c:104 [inline]
  wait_for_common kernel/sched/completion.c:115 [inline]
  wait_for_completion+0x427/0x8a0 kernel/sched/completion.c:136
  kthread_stop+0x1a9/0x900 kernel/kthread.c:550
  vivid_stop_generating_vid_cap+0x2bc/0x93b  
drivers/media/platform/vivid/vivid-kthread-cap.c:919
  vid_cap_stop_streaming+0x8d/0xe0  
drivers/media/platform/vivid/vivid-vid-cap.c:256
  __vb2_queue_cancel+0x171/0xca0  
drivers/media/common/videobuf2/videobuf2-core.c:1659
  vb2_core_streamoff+0x60/0x140  
drivers/media/common/videobuf2/videobuf2-core.c:1795
  __vb2_cleanup_fileio+0x73/0x160  
drivers/media/common/videobuf2/videobuf2-core.c:2316
  vb2_core_queue_release+0x1e/0x80  
drivers/media/common/videobuf2/videobuf2-core.c:2043
  vb2_queue_release drivers/media/common/videobuf2/videobuf2-v4l2.c:672  
[inline]
  _vb2_fop_release+0x1d2/0x2b0  
drivers/media/common/videobuf2/videobuf2-v4l2.c:843
  vb2_fop_release+0x77/0xc0  
drivers/media/common/videobuf2/videobuf2-v4l2.c:857
  vivid_fop_release+0x18e/0x440 drivers/media/platform/vivid/vivid-core.c:474
  v4l2_release+0xfb/0x1a0 drivers/media/v4l2-core/v4l2-dev.c:448
  __fput+0x385/0xa30 fs/file_table.c:278
  ____fput+0x15/0x20 fs/file_table.c:309
  task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x318/0x380 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_64+0x6be/0x820 arch/x86/entry/common.c:293
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x400f00
Code: 00 00 00 00 00 00 a8 01 00 00 00 00 00 00 36 01 00 00 b5 00 00 00 01  
02 00 00 00 00 00 00 00 00 00 00 6a 01 00 00 00 00 00 00 <00> 00 00 00 00  
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
RSP: 002b:00007ffc53169f28 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000400f00
RDX: 00000000000000d6 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00000000024b1880 R09: 00000000004002e0
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000003fbc6
R13: 0000000000401ea0 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor686:5881 blocked for more than 140 seconds.
       Not tainted 4.19.0+ #309
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor686 D24208  5881   5715 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:2831 [inline]
  __schedule+0x8cf/0x21d0 kernel/sched/core.c:3480
  schedule+0xfe/0x460 kernel/sched/core.c:3524
  schedule_timeout+0x1cc/0x260 kernel/time/timer.c:1780
  do_wait_for_common kernel/sched/completion.c:83 [inline]
  __wait_for_common kernel/sched/completion.c:104 [inline]
  wait_for_common kernel/sched/completion.c:115 [inline]
  wait_for_completion+0x427/0x8a0 kernel/sched/completion.c:136
  kthread_stop+0x1a9/0x900 kernel/kthread.c:550
  vivid_stop_generating_vid_cap+0x2bc/0x93b  
drivers/media/platform/vivid/vivid-kthread-cap.c:919
  vid_cap_stop_streaming+0x8d/0xe0  
drivers/media/platform/vivid/vivid-vid-cap.c:256
  __vb2_queue_cancel+0x171/0xca0  
drivers/media/common/videobuf2/videobuf2-core.c:1659
  vb2_core_streamoff+0x60/0x140  
drivers/media/common/videobuf2/videobuf2-core.c:1795
  __vb2_cleanup_fileio+0x73/0x160  
drivers/media/common/videobuf2/videobuf2-core.c:2316
  vb2_core_queue_release+0x1e/0x80  
drivers/media/common/videobuf2/videobuf2-core.c:2043
  vb2_queue_release drivers/media/common/videobuf2/videobuf2-v4l2.c:672  
[inline]
  _vb2_fop_release+0x1d2/0x2b0  
drivers/media/common/videobuf2/videobuf2-v4l2.c:843
  vb2_fop_release+0x77/0xc0  
drivers/media/common/videobuf2/videobuf2-v4l2.c:857
  vivid_fop_release+0x18e/0x440 drivers/media/platform/vivid/vivid-core.c:474
  v4l2_release+0xfb/0x1a0 drivers/media/v4l2-core/v4l2-dev.c:448
  __fput+0x385/0xa30 fs/file_table.c:278
  ____fput+0x15/0x20 fs/file_table.c:309
  task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x318/0x380 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_64+0x6be/0x820 arch/x86/entry/common.c:293
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x400f00
Code: 00 00 00 00 00 00 a8 01 00 00 00 00 00 00 36 01 00 00 b5 00 00 00 01  
02 00 00 00 00 00 00 00 00 00 00 6a 01 00 00 00 00 00 00 <00> 00 00 00 00  
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
RSP: 002b:00007ffc53169f28 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000400f00
RDX: 00000000000000d6 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00000000024b1880 R09: 00000000004002e0
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000003fc9c
R13: 0000000000401ea0 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor686:5883 blocked for more than 140 seconds.
       Not tainted 4.19.0+ #309
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor686 D24208  5883   5718 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:2831 [inline]
  __schedule+0x8cf/0x21d0 kernel/sched/core.c:3480
  schedule+0xfe/0x460 kernel/sched/core.c:3524
  schedule_timeout+0x1cc/0x260 kernel/time/timer.c:1780
  do_wait_for_common kernel/sched/completion.c:83 [inline]
  __wait_for_common kernel/sched/completion.c:104 [inline]
  wait_for_common kernel/sched/completion.c:115 [inline]
  wait_for_completion+0x427/0x8a0 kernel/sched/completion.c:136
  kthread_stop+0x1a9/0x900 kernel/kthread.c:550
  vivid_stop_generating_vid_cap+0x2bc/0x93b  
drivers/media/platform/vivid/vivid-kthread-cap.c:919
  vid_cap_stop_streaming+0x8d/0xe0  
drivers/media/platform/vivid/vivid-vid-cap.c:256
  __vb2_queue_cancel+0x171/0xca0  
drivers/media/common/videobuf2/videobuf2-core.c:1659
  vb2_core_streamoff+0x60/0x140  
drivers/media/common/videobuf2/videobuf2-core.c:1795
  __vb2_cleanup_fileio+0x73/0x160  
drivers/media/common/videobuf2/videobuf2-core.c:2316
  vb2_core_queue_release+0x1e/0x80  
drivers/media/common/videobuf2/videobuf2-core.c:2043
  vb2_queue_release drivers/media/common/videobuf2/videobuf2-v4l2.c:672  
[inline]
  _vb2_fop_release+0x1d2/0x2b0  
drivers/media/common/videobuf2/videobuf2-v4l2.c:843
  vb2_fop_release+0x77/0xc0  
drivers/media/common/videobuf2/videobuf2-v4l2.c:857
  vivid_fop_release+0x18e/0x440 drivers/media/platform/vivid/vivid-core.c:474
  v4l2_release+0xfb/0x1a0 drivers/media/v4l2-core/v4l2-dev.c:448
  __fput+0x385/0xa30 fs/file_table.c:278
  ____fput+0x15/0x20 fs/file_table.c:309
  task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x318/0x380 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_64+0x6be/0x820 arch/x86/entry/common.c:293
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x400f00
Code: 00 00 00 00 00 00 a8 01 00 00 00 00 00 00 36 01 00 00 b5 00 00 00 01  
02 00 00 00 00 00 00 00 00 00 00 6a 01 00 00 00 00 00 00 <00> 00 00 00 00  
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
RSP: 002b:00007ffc53169f28 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000400f00
RDX: 00000000000000d6 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00000000024b1880 R09: 00000000004002e0
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000003fca0
R13: 0000000000401ea0 R14: 0000000000000000 R15: 0000000000000000

Showing all locks held in the system:
1 lock held by khungtaskd/1008:
  #0: 00000000313d48c2 (rcu_read_lock){....}, at:  
debug_show_all_locks+0xd0/0x424 kernel/locking/lockdep.c:4379
2 locks held by rsyslogd/5598:
  #0: 00000000b3518de3 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0x1bb/0x200  
fs/file.c:766
  #1: 0000000038ba078b (logbuf_lock){-.-.}, at:  
is_bpf_text_address+0x0/0x170 kernel/bpf/core.c:533
2 locks held by getty/5688:
  #0: 0000000076b566f1 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 00000000d605404c (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1ce0 drivers/tty/n_tty.c:2140
2 locks held by getty/5689:
  #0: 0000000001bbb883 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 00000000bd2d67d2 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1ce0 drivers/tty/n_tty.c:2140
2 locks held by getty/5690:
  #0: 000000006d0f3ae6 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 0000000043ffd330 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1ce0 drivers/tty/n_tty.c:2140
2 locks held by getty/5691:
  #0: 000000007bbc59b2 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 000000002498a126 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1ce0 drivers/tty/n_tty.c:2140
2 locks held by getty/5692:
  #0: 000000007b579bf2 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 000000002e537c6f (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1ce0 drivers/tty/n_tty.c:2140
2 locks held by getty/5693:
  #0: 0000000034f4df10 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 00000000d5e3a383 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1ce0 drivers/tty/n_tty.c:2140
2 locks held by getty/5694:
  #0: 00000000b9babf44 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x32/0x40 drivers/tty/tty_ldsem.c:353
  #1: 0000000080bdfa70 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x335/0x1ce0 drivers/tty/n_tty.c:2140

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1008 Comm: khungtaskd Not tainted 4.19.0+ #309
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x244/0x39d lib/dump_stack.c:113
  nmi_cpu_backtrace.cold.1+0x5c/0xa1 lib/nmi_backtrace.c:101
  nmi_trigger_cpumask_backtrace+0x1b3/0x1ed lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_all_cpu_backtrace include/linux/nmi.h:144 [inline]
  check_hung_uninterruptible_tasks kernel/hung_task.c:204 [inline]
  watchdog+0xb3e/0x1050 kernel/hung_task.c:265
  kthread+0x35a/0x440 kernel/kthread.c:246
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:350
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0 skipped: idling at native_safe_halt+0x6/0x10  
arch/x86/include/asm/irqflags.h:57
