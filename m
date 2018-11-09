Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f72.google.com ([209.85.166.72]:39647 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728364AbeKJD7t (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 22:59:49 -0500
Received: by mail-io1-f72.google.com with SMTP id o8-v6so3018099iom.6
        for <linux-media@vger.kernel.org>; Fri, 09 Nov 2018 10:18:04 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 09 Nov 2018 10:18:04 -0800
Message-ID: <000000000000519231057a3f5fc2@google.com>
Subject: possible deadlock in v4l2_m2m_fop_poll
From: syzbot <syzbot+2178a0152e4d91ab271c@syzkaller.appspotmail.com>
To: ezequiel@collabora.com, hans.verkuil@cisco.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        mchehab@kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

syzbot found the following crash on:

HEAD commit:    24ccea7e102d Merge tag 'xfs-4.20-fixes-1' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=107166a3400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8f559fee2fc3375a
dashboard link: https://syzkaller.appspot.com/bug?extid=2178a0152e4d91ab271c
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2178a0152e4d91ab271c@syzkaller.appspotmail.com

netlink: 'syz-executor1': attribute type 1 has an invalid length.

======================================================
WARNING: possible circular locking dependency detected
4.20.0-rc1+ #327 Not tainted
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
------------------------------------------------------
syz-executor3/22066 is trying to acquire lock:
00000000875c8131 (&dev->dev_mutex){+.+.}, at: v4l2_m2m_fop_poll+0x98/0x120  
drivers/media/v4l2-core/v4l2-mem2mem.c:1105

but task is already holding lock:
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
00000000114dc15b (&ep->mtx){+.+.}, at: __do_sys_epoll_ctl  
fs/eventpoll.c:2085 [inline]
00000000114dc15b (&ep->mtx){+.+.}, at: __se_sys_epoll_ctl  
fs/eventpoll.c:2007 [inline]
00000000114dc15b (&ep->mtx){+.+.}, at: __x64_sys_epoll_ctl+0x7d4/0x1080  
fs/eventpoll.c:2007

which lock already depends on the new lock.

kobject: 'loop2' (0000000099e50969): kobject_uevent_env

the existing dependency chain (in reverse order) is:

-> #4 (&ep->mtx){+.+.}:
        __mutex_lock_common kernel/locking/mutex.c:925 [inline]
        __mutex_lock+0x166/0x16f0 kernel/locking/mutex.c:1072
        mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
        ep_free+0x160/0x300 fs/eventpoll.c:849
        ep_eventpoll_release+0x44/0x60 fs/eventpoll.c:869
        __fput+0x385/0xa30 fs/file_table.c:278
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
        ____fput+0x15/0x20 fs/file_table.c:309
        task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
        tracehook_notify_resume include/linux/tracehook.h:188 [inline]
        exit_to_usermode_loop+0x318/0x380 arch/x86/entry/common.c:166
        prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
        syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
        do_syscall_64+0x6be/0x820 arch/x86/entry/common.c:293
        entry_SYSCALL_64_after_hwframe+0x49/0xbe
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env

-> #3 (epmutex){+.+.}:
        __mutex_lock_common kernel/locking/mutex.c:925 [inline]
        __mutex_lock+0x166/0x16f0 kernel/locking/mutex.c:1072
        mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
        ep_free+0xf6/0x300 fs/eventpoll.c:829
        ep_eventpoll_release+0x44/0x60 fs/eventpoll.c:869
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
        __fput+0x385/0xa30 fs/file_table.c:278
        delayed_fput+0x55/0x80 fs/file_table.c:304
        process_one_work+0xc90/0x1c40 kernel/workqueue.c:2153
        worker_thread+0x17f/0x1390 kernel/workqueue.c:2296
        kthread+0x35a/0x440 kernel/kthread.c:246
        ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

-> #2 ((delayed_fput_work).work){+.+.}:
        process_one_work+0xc0a/0x1c40 kernel/workqueue.c:2129
        worker_thread+0x17f/0x1390 kernel/workqueue.c:2296
        kthread+0x35a/0x440 kernel/kthread.c:246
        ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

-> #1 ((wq_completion)"events"){+.+.}:
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

-> #0 (&dev->dev_mutex){+.+.}:
        lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3844
        __mutex_lock_common kernel/locking/mutex.c:925 [inline]
        __mutex_lock+0x166/0x16f0 kernel/locking/mutex.c:1072
        mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
        v4l2_m2m_fop_poll+0x98/0x120  
drivers/media/v4l2-core/v4l2-mem2mem.c:1105
        v4l2_poll+0x153/0x200 drivers/media/v4l2-core/v4l2-dev.c:350
        vfs_poll include/linux/poll.h:86 [inline]
        ep_item_poll.isra.15+0x15c/0x400 fs/eventpoll.c:892
        ep_insert+0x781/0x1dd0 fs/eventpoll.c:1464
        __do_sys_epoll_ctl fs/eventpoll.c:2121 [inline]
        __se_sys_epoll_ctl fs/eventpoll.c:2007 [inline]
        __x64_sys_epoll_ctl+0xeda/0x1080 fs/eventpoll.c:2007
        do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
        entry_SYSCALL_64_after_hwframe+0x49/0xbe

other info that might help us debug this:

Chain exists of:
   &dev->dev_mutex --> epmutex --> &ep->mtx

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&ep->mtx);
                                lock(epmutex);
                                lock(&ep->mtx);
   lock(&dev->dev_mutex);

  *** DEADLOCK ***

1 lock held by syz-executor3/22066:
  #0: 00000000114dc15b (&ep->mtx){+.+.}, at: __do_sys_epoll_ctl  
fs/eventpoll.c:2085 [inline]
  #0: 00000000114dc15b (&ep->mtx){+.+.}, at: __se_sys_epoll_ctl  
fs/eventpoll.c:2007 [inline]
  #0: 00000000114dc15b (&ep->mtx){+.+.}, at:  
__x64_sys_epoll_ctl+0x7d4/0x1080 fs/eventpoll.c:2007

stack backtrace:
CPU: 1 PID: 22066 Comm: syz-executor3 Not tainted 4.20.0-rc1+ #327
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
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
  v4l2_m2m_fop_poll+0x98/0x120 drivers/media/v4l2-core/v4l2-mem2mem.c:1105
  v4l2_poll+0x153/0x200 drivers/media/v4l2-core/v4l2-dev.c:350
  vfs_poll include/linux/poll.h:86 [inline]
  ep_item_poll.isra.15+0x15c/0x400 fs/eventpoll.c:892
  ep_insert+0x781/0x1dd0 fs/eventpoll.c:1464
  __do_sys_epoll_ctl fs/eventpoll.c:2121 [inline]
  __se_sys_epoll_ctl fs/eventpoll.c:2007 [inline]
  __x64_sys_epoll_ctl+0xeda/0x1080 fs/eventpoll.c:2007
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x457569
Code: fd b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fa4744a6c78 EFLAGS: 00000246 ORIG_RAX: 00000000000000e9
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000000457569
RDX: 0000000000000008 RSI: 0000000000000001 RDI: 0000000000000009
RBP: 000000000072bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000020000280 R11: 0000000000000246 R12: 00007fa4744a76d4
R13: 00000000004bdb6c R14: 00000000004cc9b0 R15: 00000000ffffffff
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
netlink: 'syz-executor1': attribute type 1 has an invalid length.
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
netlink: 'syz-executor1': attribute type 1 has an invalid length.
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
netlink: 'syz-executor1': attribute type 1 has an invalid length.
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
netlink: 'syz-executor1': attribute type 1 has an invalid length.
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
netlink: 'syz-executor1': attribute type 1 has an invalid length.
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
netlink: 'syz-executor1': attribute type 1 has an invalid length.
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
validate_nla: 30 callbacks suppressed
netlink: 'syz-executor1': attribute type 1 has an invalid length.
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
netlink: 'syz-executor1': attribute type 1 has an invalid length.
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
netlink: 'syz-executor1': attribute type 1 has an invalid length.
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
netlink: 'syz-executor1': attribute type 1 has an invalid length.
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
netlink: 'syz-executor1': attribute type 1 has an invalid length.
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
netlink: 'syz-executor1': attribute type 1 has an invalid length.
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
netlink: 'syz-executor1': attribute type 1 has an invalid length.
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
netlink: 'syz-executor1': attribute type 1 has an invalid length.
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
netlink: 'syz-executor1': attribute type 1 has an invalid length.
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
netlink: 'syz-executor1': attribute type 1 has an invalid length.
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop1' (00000000d3c6e9ae): kobject_uevent_env
kobject: 'loop1' (00000000d3c6e9ae): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
validate_nla: 47 callbacks suppressed
netlink: 'syz-executor1': attribute type 1 has an invalid length.
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
netlink: 'syz-executor1': attribute type 1 has an invalid length.
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
netlink: 'syz-executor1': attribute type 1 has an invalid length.
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop4' (0000000063546ed3): kobject_uevent_env
netlink: 'syz-executor1': attribute type 1 has an invalid length.
kobject: 'loop4' (0000000063546ed3): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (000000007e59c04e): kobject_uevent_env
kobject: 'loop3' (000000007e59c04e): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop2' (0000000099e50969): kobject_uevent_env
kobject: 'loop2' (0000000099e50969): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
netlink: 'syz-executor1': attribute type 1 has an invalid length.
kobject: 'loop5' (00000000f83a2beb): kobject_uevent_env
kobject: 'loop5' (00000000f83a2beb): fill_kobj_path: path  
= '/devices/virtual/block/loop5'


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
