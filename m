Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f72.google.com ([209.85.166.72]:44956 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbeKQSj6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Nov 2018 13:39:58 -0500
Received: by mail-io1-f72.google.com with SMTP id u5-v6so24851026iol.11
        for <linux-media@vger.kernel.org>; Sat, 17 Nov 2018 00:24:03 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 17 Nov 2018 00:24:02 -0800
In-Reply-To: <0000000000005943f3057acf6a1e@google.com>
Message-ID: <000000000000a93b1d057ad80185@google.com>
Subject: Re: possible deadlock in v4l2_release
From: syzbot <syzbot+ea05c832a73d0615bf33@syzkaller.appspotmail.com>
To: ezequiel@collabora.com, hans.verkuil@cisco.com,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, sque@chromium.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

syzbot has found a reproducer for the following crash on:

HEAD commit:    1ce80e0fe98e Merge tag 'fsnotify_for_v4.20-rc3' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=132ee77b400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d86f24333880b605
dashboard link: https://syzkaller.appspot.com/bug?extid=ea05c832a73d0615bf33
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10b8e6a3400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14e73e2b400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ea05c832a73d0615bf33@syzkaller.appspotmail.com

sshd (5890) used greatest stack depth: 15744 bytes left

======================================================
WARNING: possible circular locking dependency detected
4.20.0-rc2+ #338 Not tainted
------------------------------------------------------
kworker/0:2/3421 is trying to acquire lock:
00000000c364a3bd (&mdev->req_queue_mutex){+.+.}, at:  
v4l2_release+0x1d7/0x3a0 drivers/media/v4l2-core/v4l2-dev.c:455

but task is already holding lock:
000000009258f90c ((delayed_fput_work).work){+.+.}, at:  
process_one_work+0xb9a/0x1c40 kernel/workqueue.c:2128

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 ((delayed_fput_work).work){+.+.}:
        process_one_work+0xc0a/0x1c40 kernel/workqueue.c:2129
        worker_thread+0x17f/0x1390 kernel/workqueue.c:2296
        kthread+0x35a/0x440 kernel/kthread.c:246
        ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

-> #2 ((wq_completion)"events"){+.+.}:
        flush_workqueue+0x30a/0x1e10 kernel/workqueue.c:2655
        flush_scheduled_work include/linux/workqueue.h:599 [inline]
        vim2m_stop_streaming+0x7c/0x2c0 drivers/media/platform/vim2m.c:811
        __vb2_queue_cancel+0x171/0xd20  
drivers/media/common/videobuf2/videobuf2-core.c:1823
        vb2_core_queue_release+0x26/0x80  
drivers/media/common/videobuf2/videobuf2-core.c:2229
        vb2_queue_release+0x15/0x20  
drivers/media/common/videobuf2/videobuf2-v4l2.c:837
        v4l2_m2m_ctx_release+0x1e/0x35  
drivers/media/v4l2-core/v4l2-mem2mem.c:930
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

-> #1 (&dev->dev_mutex){+.+.}:
        __mutex_lock_common kernel/locking/mutex.c:925 [inline]
        __mutex_lock+0x166/0x16f0 kernel/locking/mutex.c:1072
        mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
        vim2m_release+0xbc/0x150 drivers/media/platform/vim2m.c:976
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

-> #0 (&mdev->req_queue_mutex){+.+.}:
        lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3844
        __mutex_lock_common kernel/locking/mutex.c:925 [inline]
        __mutex_lock+0x166/0x16f0 kernel/locking/mutex.c:1072
        mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
        v4l2_release+0x1d7/0x3a0 drivers/media/v4l2-core/v4l2-dev.c:455
        __fput+0x385/0xa30 fs/file_table.c:278
        delayed_fput+0x55/0x80 fs/file_table.c:304
        process_one_work+0xc90/0x1c40 kernel/workqueue.c:2153
        worker_thread+0x17f/0x1390 kernel/workqueue.c:2296
        kthread+0x35a/0x440 kernel/kthread.c:246
        ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

other info that might help us debug this:

Chain exists of:
   &mdev->req_queue_mutex --> (wq_completion)"events" -->  
(delayed_fput_work).work

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock((delayed_fput_work).work);
                                lock((wq_completion)"events");
                                lock((delayed_fput_work).work);
   lock(&mdev->req_queue_mutex);

  *** DEADLOCK ***

2 locks held by kworker/0:2/3421:
  #0: 00000000312444b2 ((wq_completion)"events"){+.+.}, at:  
__write_once_size include/linux/compiler.h:209 [inline]
  #0: 00000000312444b2 ((wq_completion)"events"){+.+.}, at:  
arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
  #0: 00000000312444b2 ((wq_completion)"events"){+.+.}, at: atomic64_set  
include/asm-generic/atomic-instrumented.h:40 [inline]
  #0: 00000000312444b2 ((wq_completion)"events"){+.+.}, at: atomic_long_set  
include/asm-generic/atomic-long.h:59 [inline]
  #0: 00000000312444b2 ((wq_completion)"events"){+.+.}, at: set_work_data  
kernel/workqueue.c:617 [inline]
  #0: 00000000312444b2 ((wq_completion)"events"){+.+.}, at:  
set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
  #0: 00000000312444b2 ((wq_completion)"events"){+.+.}, at:  
process_one_work+0xb43/0x1c40 kernel/workqueue.c:2124
  #1: 000000009258f90c ((delayed_fput_work).work){+.+.}, at:  
process_one_work+0xb9a/0x1c40 kernel/workqueue.c:2128
kobject: 'regulatory.0' (0000000078fe9404): kobject_uevent_env

stack backtrace:
CPU: 0 PID: 3421 Comm: kworker/0:2 Not tainted 4.20.0-rc2+ #338
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
kobject: 'regulatory.0' (0000000078fe9404): fill_kobj_path: path  
= '/devices/platform/regulatory.0'
Workqueue: events delayed_fput
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x244/0x39d lib/dump_stack.c:113
  print_circular_bug.isra.35.cold.54+0x1bd/0x27d  
kernel/locking/lockdep.c:1221
  check_prev_add kernel/locking/lockdep.c:1863 [inline]
  check_prevs_add kernel/locking/lockdep.c:1976 [inline]
  validate_chain kernel/locking/lockdep.c:2347 [inline]
  __lock_acquire+0x3399/0x4c20 kernel/locking/lockdep.c:3341
  lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3844
  __mutex_lock_common kernel/locking/mutex.c:925 [inline]
  __mutex_lock+0x166/0x16f0 kernel/locking/mutex.c:1072
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
  v4l2_release+0x1d7/0x3a0 drivers/media/v4l2-core/v4l2-dev.c:455
  __fput+0x385/0xa30 fs/file_table.c:278
  delayed_fput+0x55/0x80 fs/file_table.c:304
  process_one_work+0xc90/0x1c40 kernel/workqueue.c:2153
  worker_thread+0x17f/0x1390 kernel/workqueue.c:2296
  kthread+0x35a/0x440 kernel/kthread.c:246
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
kobject: 'regulatory.0' (0000000078fe9404): kobject_uevent_env
kobject: 'regulatory.0' (0000000078fe9404): fill_kobj_path: path  
= '/devices/platform/regulatory.0'
