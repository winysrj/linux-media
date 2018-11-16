Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f71.google.com ([209.85.166.71]:47692 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728760AbeKQIXQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Nov 2018 03:23:16 -0500
Received: by mail-io1-f71.google.com with SMTP id y8-v6so24105943ioc.14
        for <linux-media@vger.kernel.org>; Fri, 16 Nov 2018 14:09:05 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 16 Nov 2018 14:09:04 -0800
Message-ID: <0000000000005943f3057acf6a1e@google.com>
Subject: possible deadlock in v4l2_release
From: syzbot <syzbot+ea05c832a73d0615bf33@syzkaller.appspotmail.com>
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

HEAD commit:    5929a1f0ff30 Merge tag 'riscv-for-linus-4.20-rc2' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1443d26d400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4a0a89f12ca9b0f5
dashboard link: https://syzkaller.appspot.com/bug?extid=ea05c832a73d0615bf33
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ea05c832a73d0615bf33@syzkaller.appspotmail.com

netlink: 'syz-executor0': attribute type 1 has an invalid length.
netlink: 4 bytes leftover after parsing attributes in process  
`syz-executor0'.

======================================================
WARNING: possible circular locking dependency detected
kobject: 'loop0' (000000009dc3fb20): kobject_uevent_env
4.20.0-rc2+ #335 Not tainted
------------------------------------------------------
kworker/1:0/17 is trying to acquire lock:
00000000651ab15a (&mdev->req_queue_mutex){+.+.}, at:  
v4l2_release+0x1d7/0x3a0 drivers/media/v4l2-core/v4l2-dev.c:455

but task is already holding lock:
kobject: 'loop0' (000000009dc3fb20): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
000000001fd67464 ((delayed_fput_work).work){+.+.}, at:  
process_one_work+0xb9a/0x1c40 kernel/workqueue.c:2128

which lock already depends on the new lock.

netlink: 'syz-executor0': attribute type 1 has an invalid length.

the existing dependency chain (in reverse order) is:

-> #3 ((delayed_fput_work).work){+.+.}:
        process_one_work+0xc0a/0x1c40 kernel/workqueue.c:2129
        worker_thread+0x17f/0x1390 kernel/workqueue.c:2296
        kthread+0x35a/0x440 kernel/kthread.c:246
        ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
kobject: 'loop5' (00000000e380a391): kobject_uevent_env

-> #2 ((wq_completion)"events"){+.+.}:
        flush_workqueue+0x30a/0x1e10 kernel/workqueue.c:2655
        flush_scheduled_work include/linux/workqueue.h:599 [inline]
        vim2m_stop_streaming+0x7c/0x2c0 drivers/media/platform/vim2m.c:811
        __vb2_queue_cancel+0x171/0xd20  
drivers/media/common/videobuf2/videobuf2-core.c:1823
kobject: 'loop5' (00000000e380a391): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
        vb2_core_queue_release+0x26/0x80  
drivers/media/common/videobuf2/videobuf2-core.c:2229
        vb2_queue_release+0x15/0x20  
drivers/media/common/videobuf2/videobuf2-v4l2.c:837
        v4l2_m2m_ctx_release+0x1e/0x35  
drivers/media/v4l2-core/v4l2-mem2mem.c:930
netlink: 4 bytes leftover after parsing attributes in process  
`syz-executor0'.
        vim2m_release+0xe6/0x150 drivers/media/platform/vim2m.c:977
        v4l2_release+0x224/0x3a0 drivers/media/v4l2-core/v4l2-dev.c:456
        __fput+0x385/0xa30 fs/file_table.c:278
        ____fput+0x15/0x20 fs/file_table.c:309
kobject: 'loop0' (000000009dc3fb20): kobject_uevent_env
        task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
        tracehook_notify_resume include/linux/tracehook.h:188 [inline]
        exit_to_usermode_loop+0x318/0x380 arch/x86/entry/common.c:166
kobject: 'loop0' (000000009dc3fb20): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
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
kobject: 'loop2' (000000001e25d2fb): kobject_uevent_env

-> #0 (&mdev->req_queue_mutex){+.+.}:
kobject: 'loop2' (000000001e25d2fb): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
        lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3844
        __mutex_lock_common kernel/locking/mutex.c:925 [inline]
        __mutex_lock+0x166/0x16f0 kernel/locking/mutex.c:1072
        mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
        v4l2_release+0x1d7/0x3a0 drivers/media/v4l2-core/v4l2-dev.c:455
        __fput+0x385/0xa30 fs/file_table.c:278
        delayed_fput+0x55/0x80 fs/file_table.c:304
kobject: 'loop5' (00000000e380a391): kobject_uevent_env
        process_one_work+0xc90/0x1c40 kernel/workqueue.c:2153
        worker_thread+0x17f/0x1390 kernel/workqueue.c:2296
        kthread+0x35a/0x440 kernel/kthread.c:246
        ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

other info that might help us debug this:

kobject: 'loop5' (00000000e380a391): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
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

2 locks held by kworker/1:0/17:
  #0: 00000000c02a64cb ((wq_completion)"events"){+.+.}, at:  
__write_once_size include/linux/compiler.h:209 [inline]
  #0: 00000000c02a64cb ((wq_completion)"events"){+.+.}, at:  
arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
  #0: 00000000c02a64cb ((wq_completion)"events"){+.+.}, at: atomic64_set  
include/asm-generic/atomic-instrumented.h:40 [inline]
  #0: 00000000c02a64cb ((wq_completion)"events"){+.+.}, at: atomic_long_set  
include/asm-generic/atomic-long.h:59 [inline]
  #0: 00000000c02a64cb ((wq_completion)"events"){+.+.}, at: set_work_data  
kernel/workqueue.c:617 [inline]
  #0: 00000000c02a64cb ((wq_completion)"events"){+.+.}, at:  
set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
  #0: 00000000c02a64cb ((wq_completion)"events"){+.+.}, at:  
process_one_work+0xb43/0x1c40 kernel/workqueue.c:2124
  #1: 000000001fd67464 ((delayed_fput_work).work){+.+.}, at:  
process_one_work+0xb9a/0x1c40 kernel/workqueue.c:2128

stack backtrace:
CPU: 1 PID: 17 Comm: kworker/1:0 Not tainted 4.20.0-rc2+ #335
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
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
kobject: 'loop0' (000000009dc3fb20): kobject_uevent_env
kobject: 'loop0' (000000009dc3fb20): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop0' (000000009dc3fb20): kobject_uevent_env
kobject: 'loop0' (000000009dc3fb20): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: '0:40' (000000007a7460e1): kobject_uevent_env
kobject: '0:40' (000000007a7460e1): fill_kobj_path: path  
= '/devices/virtual/bdi/0:40'
kobject: '0:40' (000000007a7460e1): kobject_cleanup, parent           (null)
kobject: '0:40' (000000007a7460e1): calling ktype release
kobject: '0:40': free name
kobject: 'loop4' (0000000069488bfb): kobject_uevent_env
kobject: '0:40' (0000000085b8916c): kobject_add_internal: parent: 'bdi',  
set: 'devices'
kobject: '0:40' (0000000085b8916c): kobject_uevent_env
kobject: '0:40' (0000000085b8916c): fill_kobj_path: path  
= '/devices/virtual/bdi/0:40'
kobject: 'loop4' (0000000069488bfb): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop2' (000000001e25d2fb): kobject_uevent_env
kobject: 'loop2' (000000001e25d2fb): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop3' (0000000083011be5): kobject_uevent_env
kobject: 'integrity' (0000000043bbd25a): kobject_uevent_env
kobject: 'loop3' (0000000083011be5): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop1' (00000000ccd5dd1a): kobject_uevent_env
kobject: 'loop1' (00000000ccd5dd1a): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'integrity' (0000000043bbd25a): kobject_uevent_env: filter  
function caused the event to drop!
kobject: 'loop5' (00000000e380a391): kobject_uevent_env
kobject: 'loop5' (00000000e380a391): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop2' (000000001e25d2fb): kobject_uevent_env
kobject: 'loop2' (000000001e25d2fb): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'integrity' (0000000043bbd25a): kobject_cleanup, parent            
(null)
kobject: 'integrity' (0000000043bbd25a): does not have a release()  
function, it is broken and must be fixed.
kobject: 'integrity': free name
kobject: '7:0' (0000000070602fa0): kobject_uevent_env
kobject: '7:0' (0000000070602fa0): fill_kobj_path: path  
= '/devices/virtual/bdi/7:0'
kobject: '7:0' (0000000070602fa0): kobject_cleanup, parent           (null)
kobject: '7:0' (0000000070602fa0): calling ktype release
kobject: '7:0': free name
kobject: 'mq' (00000000db9a50f0): kobject_uevent_env
kobject: 'mq' (00000000db9a50f0): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'queue' (0000000051e17239): kobject_uevent_env
kobject: 'queue' (0000000051e17239): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'iosched' (0000000048b5576d): kobject_uevent_env
kobject: 'iosched' (0000000048b5576d): kobject_uevent_env: attempted to  
send uevent without kset!
kobject: 'holders' (00000000175a2248): kobject_cleanup, parent  
000000009dc3fb20
kobject: 'holders' (00000000175a2248): auto cleanup kobject_del
kobject: 'holders' (00000000175a2248): calling ktype release
kobject: (00000000175a2248): dynamic_kobj_release
kobject: 'holders': free name
kobject: 'slaves' (00000000caebcf7f): kobject_cleanup, parent  
000000009dc3fb20
kobject: 'slaves' (00000000caebcf7f): auto cleanup kobject_del
kobject: 'slaves' (00000000caebcf7f): calling ktype release
kobject: (00000000caebcf7f): dynamic_kobj_release
kobject: 'slaves': free name
kobject: 'loop0' (000000009dc3fb20): kobject_uevent_env
kobject: 'loop0' (000000009dc3fb20): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'iosched' (0000000048b5576d): kobject_cleanup, parent            
(null)
kobject: 'iosched' (0000000048b5576d): calling ktype release
kobject: 'iosched': free name
kobject: 'loop0' (000000009dc3fb20): kobject_cleanup, parent            
(null)
kobject: 'loop0' (000000009dc3fb20): calling ktype release
kobject: '7:0' (00000000f0389899): kobject_add_internal: parent: 'bdi',  
set: 'devices'
kobject: 'queue' (0000000051e17239): kobject_cleanup, parent            
(null)
kobject: '7:0' (00000000f0389899): kobject_uevent_env
kobject: 'queue' (0000000051e17239): calling ktype release
kobject: '7:0' (00000000f0389899): fill_kobj_path: path  
= '/devices/virtual/bdi/7:0'
kobject: 'loop0' (0000000079c85b46): kobject_add_internal: parent: 'block',  
set: 'devices'
kobject: 'queue': free name
kobject: 'loop0' (0000000079c85b46): kobject_uevent_env
kobject: '0' (00000000a47afb53): kobject_cleanup, parent           (null)
kobject: 'loop0' (0000000079c85b46): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: '0' (00000000a47afb53): calling ktype release
kobject: 'holders' (000000006061d428): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: '0': free name
kobject: 'slaves' (0000000092b86788): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: 'cpu0' (0000000004b99a3b): kobject_cleanup, parent           (null)
kobject: 'loop0': free name
kobject: 'cpu0' (0000000004b99a3b): calling ktype release
kobject: 'loop0' (0000000079c85b46): kobject_uevent_env
kobject: 'cpu0': free name
kobject: 'loop0' (0000000079c85b46): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'cpu1' (000000000175e0e6): kobject_cleanup, parent           (null)
kobject: 'queue' (000000008ca0932e): kobject_add_internal: parent: 'loop0',  
set: '<NULL>'
kobject: 'cpu1' (000000000175e0e6): calling ktype release
kobject: 'cpu1': free name
kobject: 'mq' (00000000db9a50f0): kobject_cleanup, parent           (null)
kobject: 'mq' (00000000dcc29f43): kobject_add_internal: parent: 'loop0',  
set: '<NULL>'
kobject: 'mq' (00000000db9a50f0): calling ktype release
bridge: RTM_NEWNEIGH bridge0 without NUD_PERMANENT
kobject: 'mq': free name
bridge: RTM_NEWNEIGH bridge0 without NUD_PERMANENT
kobject: 'mq' (00000000dcc29f43): kobject_uevent_env
kobject: '0:40' (0000000085b8916c): kobject_uevent_env
kobject: 'mq' (00000000dcc29f43): kobject_uevent_env: filter function  
caused the event to drop!
kobject: '0:40' (0000000085b8916c): fill_kobj_path: path  
= '/devices/virtual/bdi/0:40'
kobject: '0' (000000009280b857): kobject_add_internal: parent: 'mq',  
set: '<NULL>'
kobject: 'cpu0' (00000000d4cf0527): kobject_add_internal: parent: '0',  
set: '<NULL>'
kobject: 'cpu1' (0000000065a7e78d): kobject_add_internal: parent: '0',  
set: '<NULL>'
kobject: 'queue' (000000008ca0932e): kobject_uevent_env
kobject: 'queue' (000000008ca0932e): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'iosched' (00000000cf653225): kobject_add_internal:  
parent: 'queue', set: '<NULL>'
kobject: 'iosched' (00000000cf653225): kobject_uevent_env
kobject: '0:40' (0000000085b8916c): kobject_cleanup, parent           (null)
kobject: 'iosched' (00000000cf653225): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'integrity' (00000000875dd409): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: 'integrity' (00000000875dd409): kobject_uevent_env
kobject: 'integrity' (00000000875dd409): kobject_uevent_env: filter  
function caused the event to drop!
kobject: '0:40' (0000000085b8916c): calling ktype release
kobject: 'loop1' (00000000ccd5dd1a): kobject_uevent_env
kobject: 'integrity' (00000000875dd409): kobject_uevent_env
kobject: '0:40': free name
kobject: 'loop1' (00000000ccd5dd1a): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
bridge: RTM_NEWNEIGH bridge0 without NUD_PERMANENT
kobject: 'integrity' (00000000875dd409): kobject_uevent_env: filter  
function caused the event to drop!
kobject: 'integrity' (00000000875dd409): kobject_cleanup, parent            
(null)
kobject: 'integrity' (00000000875dd409): does not have a release()  
function, it is broken and must be fixed.
kobject: 'integrity': free name
kobject: '7:0' (00000000f0389899): kobject_uevent_env
kobject: '7:0' (00000000f0389899): fill_kobj_path: path  
= '/devices/virtual/bdi/7:0'
kobject: '7:0' (00000000f0389899): kobject_cleanup, parent           (null)
kobject: '7:0' (00000000f0389899): calling ktype release
kobject: '7:0': free name
kobject: 'mq' (00000000dcc29f43): kobject_uevent_env
kobject: 'mq' (00000000dcc29f43): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'queue' (000000008ca0932e): kobject_uevent_env
kobject: 'queue' (000000008ca0932e): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'iosched' (00000000cf653225): kobject_uevent_env
kobject: 'iosched' (00000000cf653225): kobject_uevent_env: attempted to  
send uevent without kset!
kobject: 'holders' (000000006061d428): kobject_cleanup, parent  
0000000079c85b46
kobject: 'holders' (000000006061d428): auto cleanup kobject_del
kobject: 'holders' (000000006061d428): calling ktype release
kobject: (000000006061d428): dynamic_kobj_release
kobject: 'holders': free name
kobject: 'slaves' (0000000092b86788): kobject_cleanup, parent  
0000000079c85b46
kobject: 'slaves' (0000000092b86788): auto cleanup kobject_del
kobject: 'slaves' (0000000092b86788): calling ktype release
kobject: (0000000092b86788): dynamic_kobj_release
kobject: 'slaves': free name
kobject: 'loop0' (0000000079c85b46): kobject_uevent_env
kobject: 'loop0' (0000000079c85b46): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'iosched' (00000000cf653225): kobject_cleanup, parent            
(null)
kobject: 'iosched' (00000000cf653225): calling ktype release
kobject: 'iosched': free name
kobject: 'loop0' (0000000079c85b46): kobject_cleanup, parent            
(null)
kobject: 'loop0' (0000000079c85b46): calling ktype release
kobject: 'queue' (000000008ca0932e): kobject_cleanup, parent            
(null)
kobject: 'queue' (000000008ca0932e): calling ktype release
kobject: 'queue': free name
kobject: '0' (000000009280b857): kobject_cleanup, parent           (null)
kobject: 'loop0': free name
kobject: '0' (000000009280b857): calling ktype release
kobject: '7:0' (000000006977d38d): kobject_add_internal: parent: 'bdi',  
set: 'devices'
kobject: '0': free name
kobject: '7:0' (000000006977d38d): kobject_uevent_env
kobject: 'cpu0' (00000000d4cf0527): kobject_cleanup, parent           (null)
kobject: 'cpu0' (00000000d4cf0527): calling ktype release
kobject: 'cpu0': free name
kobject: '7:0' (000000006977d38d): fill_kobj_path: path  
= '/devices/virtual/bdi/7:0'
kobject: 'cpu1' (0000000065a7e78d): kobject_cleanup, parent           (null)
kobject: 'cpu1' (0000000065a7e78d): calling ktype release
kobject: 'cpu1': free name
kobject: 'mq' (00000000dcc29f43): kobject_cleanup, parent           (null)
kobject: 'mq' (00000000dcc29f43): calling ktype release
kobject: 'loop0' (000000003af2323a): kobject_add_internal: parent: 'block',  
set: 'devices'
kobject: 'mq': free name
kobject: 'loop0' (000000003af2323a): kobject_uevent_env
kobject: 'loop0' (000000003af2323a): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'holders' (00000000112a596d): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: 'slaves' (00000000fda2bbf0): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: 'loop0' (000000003af2323a): kobject_uevent_env
kobject: 'loop0' (000000003af2323a): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'queue' (00000000d3767fc5): kobject_add_internal: parent: 'loop0',  
set: '<NULL>'
kobject: 'mq' (000000003b9efe44): kobject_add_internal: parent: 'loop0',  
set: '<NULL>'
kobject: 'mq' (000000003b9efe44): kobject_uevent_env
kobject: 'mq' (000000003b9efe44): kobject_uevent_env: filter function  
caused the event to drop!
kobject: '0' (0000000090b1f5b5): kobject_add_internal: parent: 'mq',  
set: '<NULL>'
kobject: 'cpu0' (00000000c221c143): kobject_add_internal: parent: '0',  
set: '<NULL>'
kobject: 'cpu1' (0000000023ab86cf): kobject_add_internal: parent: '0',  
set: '<NULL>'
kobject: 'queue' (00000000d3767fc5): kobject_uevent_env
kobject: 'queue' (00000000d3767fc5): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'iosched' (00000000460ced90): kobject_add_internal:  
parent: 'queue', set: '<NULL>'
kobject: 'iosched' (00000000460ced90): kobject_uevent_env
kobject: 'iosched' (00000000460ced90): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'integrity' (000000005ccddd52): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: 'integrity' (000000005ccddd52): kobject_uevent_env
kobject: 'integrity' (000000005ccddd52): kobject_uevent_env: filter  
function caused the event to drop!
kobject: 'loop3' (0000000083011be5): kobject_uevent_env
kobject: 'loop3' (0000000083011be5): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: '0:40' (00000000449511ea): kobject_add_internal: parent: 'bdi',  
set: 'devices'
bridge: RTM_NEWNEIGH bridge0 without NUD_PERMANENT
kobject: '0:40' (00000000449511ea): kobject_uevent_env
kobject: 'loop5' (00000000e380a391): kobject_uevent_env
kobject: '0:40' (00000000449511ea): fill_kobj_path: path  
= '/devices/virtual/bdi/0:40'
kobject: 'loop5' (00000000e380a391): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'integrity' (000000005ccddd52): kobject_uevent_env
kobject: 'loop2' (000000001e25d2fb): kobject_uevent_env
kobject: 'integrity' (000000005ccddd52): kobject_uevent_env: filter  
function caused the event to drop!
kobject: 'loop2' (000000001e25d2fb): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'integrity' (000000005ccddd52): kobject_cleanup, parent            
(null)
kobject: 'loop0' (000000003af2323a): kobject_uevent_env
kobject: 'loop0' (000000003af2323a): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'integrity' (000000005ccddd52): does not have a release()  
function, it is broken and must be fixed.
kobject: 'integrity': free name
kobject: 'loop5' (00000000e380a391): kobject_uevent_env
bridge: RTM_NEWNEIGH bridge0 without NUD_PERMANENT
kobject: 'loop5' (00000000e380a391): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: '7:0' (000000006977d38d): kobject_uevent_env
kobject: 'loop1' (00000000ccd5dd1a): kobject_uevent_env
kobject: '7:0' (000000006977d38d): fill_kobj_path: path  
= '/devices/virtual/bdi/7:0'
kobject: '7:0' (000000006977d38d): kobject_cleanup, parent           (null)
kobject: '0:40' (00000000449511ea): kobject_uevent_env
kobject: 'loop1' (00000000ccd5dd1a): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: '0:40' (00000000449511ea): fill_kobj_path: path  
= '/devices/virtual/bdi/0:40'
kobject: '7:0' (000000006977d38d): calling ktype release
kobject: '0:40' (00000000449511ea): kobject_cleanup, parent           (null)
kobject: '7:0': free name
kobject: '0:40' (00000000449511ea): calling ktype release
kobject: 'mq' (000000003b9efe44): kobject_uevent_env
kobject: '0:40': free name
kobject: 'mq' (000000003b9efe44): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'queue' (00000000d3767fc5): kobject_uevent_env
kobject: 'queue' (00000000d3767fc5): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'iosched' (00000000460ced90): kobject_uevent_env
kobject: 'iosched' (00000000460ced90): kobject_uevent_env: attempted to  
send uevent without kset!
kobject: 'holders' (00000000112a596d): kobject_cleanup, parent  
000000003af2323a
kobject: 'holders' (00000000112a596d): auto cleanup kobject_del
kobject: 'holders' (00000000112a596d): calling ktype release
kobject: (00000000112a596d): dynamic_kobj_release
kobject: 'holders': free name
kobject: 'slaves' (00000000fda2bbf0): kobject_cleanup, parent  
000000003af2323a
kobject: 'slaves' (00000000fda2bbf0): auto cleanup kobject_del
kobject: 'slaves' (00000000fda2bbf0): calling ktype release
kobject: (00000000fda2bbf0): dynamic_kobj_release
kobject: 'slaves': free name
kobject: 'loop0' (000000003af2323a): kobject_uevent_env
kobject: 'loop0' (000000003af2323a): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'iosched' (00000000460ced90): kobject_cleanup, parent            
(null)
kobject: 'iosched' (00000000460ced90): calling ktype release
kobject: 'iosched': free name
kobject: 'loop0' (000000003af2323a): kobject_cleanup, parent            
(null)
kobject: 'loop0' (000000003af2323a): calling ktype release
kobject: 'queue' (00000000d3767fc5): kobject_cleanup, parent            
(null)
kobject: 'queue' (00000000d3767fc5): calling ktype release
kobject: '0' (0000000090b1f5b5): kobject_cleanup, parent           (null)
kobject: 'queue': free name
kobject: '0' (0000000090b1f5b5): calling ktype release
kobject: '0': free name
kobject: 'loop0': free name
kobject: 'cpu0' (00000000c221c143): kobject_cleanup, parent           (null)
kobject: 'cpu0' (00000000c221c143): calling ktype release
kobject: 'cpu0': free name
kobject: 'cpu1' (0000000023ab86cf): kobject_cleanup, parent           (null)
kobject: 'cpu1' (0000000023ab86cf): calling ktype release
kobject: 'cpu1': free name
kobject: '7:0' (00000000a988cd45): kobject_add_internal: parent: 'bdi',  
set: 'devices'
kobject: 'mq' (000000003b9efe44): kobject_cleanup, parent           (null)
kobject: 'mq' (000000003b9efe44): calling ktype release
kobject: 'mq': free name
kobject: '7:0' (00000000a988cd45): kobject_uevent_env
kobject: '7:0' (00000000a988cd45): fill_kobj_path: path  
= '/devices/virtual/bdi/7:0'
kobject: 'loop0' (00000000ab201e06): kobject_add_internal: parent: 'block',  
set: 'devices'
kobject: 'loop0' (00000000ab201e06): kobject_uevent_env
kobject: 'loop0' (00000000ab201e06): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'holders' (00000000d34d2b6e): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: 'slaves' (000000006477d341): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: 'loop0' (00000000ab201e06): kobject_uevent_env
kobject: 'loop0' (00000000ab201e06): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'queue' (00000000b78327cc): kobject_add_internal: parent: 'loop0',  
set: '<NULL>'
kobject: 'mq' (00000000998f011e): kobject_add_internal: parent: 'loop0',  
set: '<NULL>'
kobject: 'mq' (00000000998f011e): kobject_uevent_env
kobject: 'mq' (00000000998f011e): kobject_uevent_env: filter function  
caused the event to drop!
kobject: '0' (00000000c9ee7068): kobject_add_internal: parent: 'mq',  
set: '<NULL>'
kobject: 'cpu0' (00000000d4cf0527): kobject_add_internal: parent: '0',  
set: '<NULL>'
kobject: 'cpu1' (0000000065a7e78d): kobject_add_internal: parent: '0',  
set: '<NULL>'
kobject: 'queue' (00000000b78327cc): kobject_uevent_env
kobject: 'queue' (00000000b78327cc): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'iosched' (000000002a000ab8): kobject_add_internal:  
parent: 'queue', set: '<NULL>'
kobject: 'iosched' (000000002a000ab8): kobject_uevent_env
kobject: 'iosched' (000000002a000ab8): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'integrity' (00000000ae331374): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: 'integrity' (00000000ae331374): kobject_uevent_env
kobject: 'integrity' (00000000ae331374): kobject_uevent_env: filter  
function caused the event to drop!
kobject: 'loop3' (0000000083011be5): kobject_uevent_env
kobject: 'loop3' (0000000083011be5): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop2' (000000001e25d2fb): kobject_uevent_env
kobject: 'loop2' (000000001e25d2fb): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop5' (00000000e380a391): kobject_uevent_env
kobject: 'loop5' (00000000e380a391): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop0' (00000000ab201e06): kobject_uevent_env
kobject: 'loop0' (00000000ab201e06): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop4' (0000000069488bfb): kobject_uevent_env
kobject: 'integrity' (00000000ae331374): kobject_uevent_env
kobject: 'loop4' (0000000069488bfb): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'integrity' (00000000ae331374): kobject_uevent_env: filter  
function caused the event to drop!
kobject: 'integrity' (00000000ae331374): kobject_cleanup, parent            
(null)
kobject: 'integrity' (00000000ae331374): does not have a release()  
function, it is broken and must be fixed.
kobject: 'integrity': free name
kobject: '7:0' (00000000a988cd45): kobject_uevent_env
kobject: '7:0' (00000000a988cd45): fill_kobj_path: path  
= '/devices/virtual/bdi/7:0'
kobject: '7:0' (00000000a988cd45): kobject_cleanup, parent           (null)
kobject: '7:0' (00000000a988cd45): calling ktype release
kobject: '7:0': free name
kobject: 'mq' (00000000998f011e): kobject_uevent_env
kobject: 'mq' (00000000998f011e): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'queue' (00000000b78327cc): kobject_uevent_env
kobject: 'queue' (00000000b78327cc): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'iosched' (000000002a000ab8): kobject_uevent_env
kobject: 'iosched' (000000002a000ab8): kobject_uevent_env: attempted to  
send uevent without kset!
kobject: 'holders' (00000000d34d2b6e): kobject_cleanup, parent  
00000000ab201e06
kobject: 'holders' (00000000d34d2b6e): auto cleanup kobject_del
kobject: 'holders' (00000000d34d2b6e): calling ktype release
kobject: (00000000d34d2b6e): dynamic_kobj_release
kobject: 'holders': free name
kobject: 'slaves' (000000006477d341): kobject_cleanup, parent  
00000000ab201e06
kobject: 'slaves' (000000006477d341): auto cleanup kobject_del
kobject: 'slaves' (000000006477d341): calling ktype release
kobject: (000000006477d341): dynamic_kobj_release
kobject: 'slaves': free name
kobject: 'loop0' (00000000ab201e06): kobject_uevent_env
kobject: 'loop0' (00000000ab201e06): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'iosched' (000000002a000ab8): kobject_cleanup, parent            
(null)
kobject: 'iosched' (000000002a000ab8): calling ktype release
kobject: 'iosched': free name
kobject: 'loop0' (00000000ab201e06): kobject_cleanup, parent            
(null)
kobject: 'loop0' (00000000ab201e06): calling ktype release
kobject: 'queue' (00000000b78327cc): kobject_cleanup, parent            
(null)
kobject: 'queue' (00000000b78327cc): calling ktype release
kobject: '0' (00000000c9ee7068): kobject_cleanup, parent           (null)
kobject: 'queue': free name
kobject: '0' (00000000c9ee7068): calling ktype release
kobject: 'loop0': free name
kobject: '0': free name
kobject: 'cpu0' (00000000d4cf0527): kobject_cleanup, parent           (null)
kobject: 'cpu0' (00000000d4cf0527): calling ktype release
kobject: 'loop2' (000000001e25d2fb): kobject_uevent_env
kobject: '7:0' (000000008a775ca0): kobject_add_internal: parent: 'bdi',  
set: 'devices'
kobject: 'loop2' (000000001e25d2fb): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'cpu0': free name
kobject: '7:0' (000000008a775ca0): kobject_uevent_env
kobject: 'cpu1' (0000000065a7e78d): kobject_cleanup, parent           (null)
kobject: '7:0' (000000008a775ca0): fill_kobj_path: path  
= '/devices/virtual/bdi/7:0'
kobject: 'cpu1' (0000000065a7e78d): calling ktype release
kobject: 'loop0' (00000000c1f8624c): kobject_add_internal: parent: 'block',  
set: 'devices'
kobject: 'cpu1': free name
kobject: 'mq' (00000000998f011e): kobject_cleanup, parent           (null)
kobject: 'loop0' (00000000c1f8624c): kobject_uevent_env
kobject: 'mq' (00000000998f011e): calling ktype release
kobject: 'mq': free name
kobject: 'loop0' (00000000c1f8624c): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'holders' (000000009d79da8a): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: 'slaves' (000000005de79b8f): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: 'loop0' (00000000c1f8624c): kobject_uevent_env
kobject: 'loop0' (00000000c1f8624c): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'queue' (000000002ed0d1ed): kobject_add_internal: parent: 'loop0',  
set: '<NULL>'
kobject: 'mq' (000000005d342873): kobject_add_internal: parent: 'loop0',  
set: '<NULL>'
kobject: 'mq' (000000005d342873): kobject_uevent_env
kobject: 'mq' (000000005d342873): kobject_uevent_env: filter function  
caused the event to drop!
kobject: '0' (0000000096eb6389): kobject_add_internal: parent: 'mq',  
set: '<NULL>'
kobject: 'cpu0' (00000000c221c143): kobject_add_internal: parent: '0',  
set: '<NULL>'
kobject: 'cpu1' (0000000023ab86cf): kobject_add_internal: parent: '0',  
set: '<NULL>'
kobject: 'queue' (000000002ed0d1ed): kobject_uevent_env
kobject: 'queue' (000000002ed0d1ed): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'iosched' (00000000e1544fa5): kobject_add_internal:  
parent: 'queue', set: '<NULL>'
kobject: 'iosched' (00000000e1544fa5): kobject_uevent_env
kobject: 'iosched' (00000000e1544fa5): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'integrity' (00000000ec92212b): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: 'integrity' (00000000ec92212b): kobject_uevent_env
kobject: 'integrity' (00000000ec92212b): kobject_uevent_env: filter  
function caused the event to drop!
kobject: 'loop3' (0000000083011be5): kobject_uevent_env
kobject: 'integrity' (00000000ec92212b): kobject_uevent_env
kobject: 'loop3' (0000000083011be5): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'integrity' (00000000ec92212b): kobject_uevent_env: filter  
function caused the event to drop!
kobject: 'loop5' (00000000e380a391): kobject_uevent_env
kobject: 'integrity' (00000000ec92212b): kobject_cleanup, parent            
(null)
kobject: 'loop5' (00000000e380a391): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'integrity' (00000000ec92212b): does not have a release()  
function, it is broken and must be fixed.
kobject: 'integrity': free name
kobject: '7:0' (000000008a775ca0): kobject_uevent_env
kobject: '7:0' (000000008a775ca0): fill_kobj_path: path  
= '/devices/virtual/bdi/7:0'
kobject: '7:0' (000000008a775ca0): kobject_cleanup, parent           (null)
kobject: '7:0' (000000008a775ca0): calling ktype release
kobject: '7:0': free name
kobject: 'mq' (000000005d342873): kobject_uevent_env
kobject: 'mq' (000000005d342873): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'queue' (000000002ed0d1ed): kobject_uevent_env
kobject: 'queue' (000000002ed0d1ed): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'iosched' (00000000e1544fa5): kobject_uevent_env
kobject: 'iosched' (00000000e1544fa5): kobject_uevent_env: attempted to  
send uevent without kset!
kobject: 'holders' (000000009d79da8a): kobject_cleanup, parent  
00000000c1f8624c
kobject: 'holders' (000000009d79da8a): auto cleanup kobject_del
kobject: 'holders' (000000009d79da8a): calling ktype release
kobject: (000000009d79da8a): dynamic_kobj_release
kobject: 'holders': free name
kobject: 'slaves' (000000005de79b8f): kobject_cleanup, parent  
00000000c1f8624c
kobject: 'slaves' (000000005de79b8f): auto cleanup kobject_del
kobject: 'slaves' (000000005de79b8f): calling ktype release
kobject: (000000005de79b8f): dynamic_kobj_release
kobject: 'slaves': free name
kobject: 'loop0' (00000000c1f8624c): kobject_uevent_env
kobject: 'loop0' (00000000c1f8624c): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'iosched' (00000000e1544fa5): kobject_cleanup, parent            
(null)
kobject: 'iosched' (00000000e1544fa5): calling ktype release
kobject: 'iosched': free name
kobject: 'loop1' (00000000ccd5dd1a): kobject_uevent_env
kobject: 'loop0' (00000000c1f8624c): kobject_cleanup, parent            
(null)
kobject: 'loop1' (00000000ccd5dd1a): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: '7:0' (0000000042182656): kobject_add_internal: parent: 'bdi',  
set: 'devices'
kobject: 'loop0' (00000000c1f8624c): calling ktype release
kobject: '7:0' (0000000042182656): kobject_uevent_env
kobject: 'loop2' (000000001e25d2fb): kobject_uevent_env
kobject: '7:0' (0000000042182656): fill_kobj_path: path  
= '/devices/virtual/bdi/7:0'
kobject: 'queue' (000000002ed0d1ed): kobject_cleanup, parent            
(null)
kobject: 'loop0' (00000000e846e269): kobject_add_internal: parent: 'block',  
set: 'devices'
kobject: 'loop2' (000000001e25d2fb): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop0' (00000000e846e269): kobject_uevent_env
kobject: 'queue' (000000002ed0d1ed): calling ktype release
kobject: 'loop0' (00000000e846e269): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'loop4' (0000000069488bfb): kobject_uevent_env
kobject: 'queue': free name
kobject: '0' (0000000096eb6389): kobject_cleanup, parent           (null)
kobject: 'holders' (00000000c09da7de): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: '0' (0000000096eb6389): calling ktype release
kobject: 'slaves' (0000000051b93405): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: 'loop0': free name
kobject: 'loop0' (00000000e846e269): kobject_uevent_env
kobject: 'loop4' (0000000069488bfb): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop0' (00000000e846e269): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: '0': free name
kobject: 'queue' (000000000dd9aad6): kobject_add_internal: parent: 'loop0',  
set: '<NULL>'
kobject: 'cpu0' (00000000c221c143): kobject_cleanup, parent           (null)
kobject: 'mq' (0000000002e79e66): kobject_add_internal: parent: 'loop0',  
set: '<NULL>'
kobject: 'cpu0' (00000000c221c143): calling ktype release
kobject: 'mq' (0000000002e79e66): kobject_uevent_env
kobject: 'cpu0': free name
kobject: 'mq' (0000000002e79e66): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'cpu1' (0000000023ab86cf): kobject_cleanup, parent           (null)
kobject: '0' (00000000934c8b41): kobject_add_internal: parent: 'mq',  
set: '<NULL>'
kobject: 'cpu1' (0000000023ab86cf): calling ktype release
kobject: 'cpu0' (00000000d4cf0527): kobject_add_internal: parent: '0',  
set: '<NULL>'
kobject: 'cpu1': free name
kobject: 'cpu1' (0000000065a7e78d): kobject_add_internal: parent: '0',  
set: '<NULL>'
kobject: 'mq' (000000005d342873): kobject_cleanup, parent           (null)
kobject: 'queue' (000000000dd9aad6): kobject_uevent_env
kobject: 'queue' (000000000dd9aad6): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'mq' (000000005d342873): calling ktype release
kobject: 'iosched' (000000006e45def7): kobject_add_internal:  
parent: 'queue', set: '<NULL>'
kobject: 'mq': free name
kobject: 'iosched' (000000006e45def7): kobject_uevent_env
kobject: 'iosched' (000000006e45def7): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'integrity' (0000000084d03129): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: 'integrity' (0000000084d03129): kobject_uevent_env
kobject: 'integrity' (0000000084d03129): kobject_uevent_env: filter  
function caused the event to drop!
kobject: 'integrity' (0000000084d03129): kobject_uevent_env
kobject: 'integrity' (0000000084d03129): kobject_uevent_env: filter  
function caused the event to drop!
kobject: 'integrity' (0000000084d03129): kobject_cleanup, parent            
(null)
kobject: 'integrity' (0000000084d03129): does not have a release()  
function, it is broken and must be fixed.
kobject: 'integrity': free name
kobject: '7:0' (0000000042182656): kobject_uevent_env
kobject: '7:0' (0000000042182656): fill_kobj_path: path  
= '/devices/virtual/bdi/7:0'
kobject: '7:0' (0000000042182656): kobject_cleanup, parent           (null)
kobject: '7:0' (0000000042182656): calling ktype release
kobject: '7:0': free name
kobject: 'mq' (0000000002e79e66): kobject_uevent_env
kobject: 'mq' (0000000002e79e66): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'queue' (000000000dd9aad6): kobject_uevent_env
kobject: 'queue' (000000000dd9aad6): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'iosched' (000000006e45def7): kobject_uevent_env
kobject: 'iosched' (000000006e45def7): kobject_uevent_env: attempted to  
send uevent without kset!
kobject: 'holders' (00000000c09da7de): kobject_cleanup, parent  
00000000e846e269
kobject: 'holders' (00000000c09da7de): auto cleanup kobject_del
kobject: 'holders' (00000000c09da7de): calling ktype release
kobject: (00000000c09da7de): dynamic_kobj_release
kobject: 'holders': free name
kobject: 'slaves' (0000000051b93405): kobject_cleanup, parent  
00000000e846e269
kobject: 'slaves' (0000000051b93405): auto cleanup kobject_del
kobject: 'slaves' (0000000051b93405): calling ktype release
kobject: (0000000051b93405): dynamic_kobj_release
kobject: 'slaves': free name
kobject: 'loop0' (00000000e846e269): kobject_uevent_env
kobject: 'loop0' (00000000e846e269): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'iosched' (000000006e45def7): kobject_cleanup, parent            
(null)
kobject: 'iosched' (000000006e45def7): calling ktype release
kobject: 'iosched': free name
kobject: '7:0' (00000000c7ce6b70): kobject_add_internal: parent: 'bdi',  
set: 'devices'
kobject: '7:0' (00000000c7ce6b70): kobject_uevent_env
kobject: '7:0' (00000000c7ce6b70): fill_kobj_path: path  
= '/devices/virtual/bdi/7:0'
kobject: 'loop0' (00000000d3975188): kobject_add_internal: parent: 'block',  
set: 'devices'
kobject: 'loop0' (00000000d3975188): kobject_uevent_env
kobject: 'loop0' (00000000d3975188): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'holders' (000000000d6f1dcc): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: 'slaves' (0000000003f0c160): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: 'loop0' (00000000d3975188): kobject_uevent_env
kobject: 'loop0' (00000000d3975188): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'queue' (00000000a0174471): kobject_add_internal: parent: 'loop0',  
set: '<NULL>'
kobject: 'mq' (0000000008bd5ae2): kobject_add_internal: parent: 'loop0',  
set: '<NULL>'
kobject: 'mq' (0000000008bd5ae2): kobject_uevent_env
kobject: 'mq' (0000000008bd5ae2): kobject_uevent_env: filter function  
caused the event to drop!
kobject: '0' (00000000a0ddde50): kobject_add_internal: parent: 'mq',  
set: '<NULL>'
kobject: 'cpu0' (00000000c221c143): kobject_add_internal: parent: '0',  
set: '<NULL>'
kobject: 'cpu1' (0000000023ab86cf): kobject_add_internal: parent: '0',  
set: '<NULL>'
kobject: 'queue' (00000000a0174471): kobject_uevent_env
kobject: 'queue' (00000000a0174471): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'iosched' (000000009bbaa4e4): kobject_add_internal:  
parent: 'queue', set: '<NULL>'
kobject: 'iosched' (000000009bbaa4e4): kobject_uevent_env
kobject: 'iosched' (000000009bbaa4e4): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'integrity' (000000001fd01dc2): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: 'integrity' (000000001fd01dc2): kobject_uevent_env
kobject: 'integrity' (000000001fd01dc2): kobject_uevent_env: filter  
function caused the event to drop!
kobject: 'integrity' (000000001fd01dc2): kobject_uevent_env
kobject: 'integrity' (000000001fd01dc2): kobject_uevent_env: filter  
function caused the event to drop!
kobject: 'integrity' (000000001fd01dc2): kobject_cleanup, parent            
(null)
kobject: 'integrity' (000000001fd01dc2): does not have a release()  
function, it is broken and must be fixed.
kobject: 'integrity': free name
kobject: '7:0' (00000000c7ce6b70): kobject_uevent_env
kobject: '7:0' (00000000c7ce6b70): fill_kobj_path: path  
= '/devices/virtual/bdi/7:0'
kobject: '7:0' (00000000c7ce6b70): kobject_cleanup, parent           (null)
kobject: '7:0' (00000000c7ce6b70): calling ktype release
kobject: '7:0': free name
kobject: 'mq' (0000000008bd5ae2): kobject_uevent_env
kobject: 'mq' (0000000008bd5ae2): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'queue' (00000000a0174471): kobject_uevent_env
kobject: 'queue' (00000000a0174471): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'iosched' (000000009bbaa4e4): kobject_uevent_env
kobject: 'iosched' (000000009bbaa4e4): kobject_uevent_env: attempted to  
send uevent without kset!
kobject: 'holders' (000000000d6f1dcc): kobject_cleanup, parent  
00000000d3975188
kobject: 'holders' (000000000d6f1dcc): auto cleanup kobject_del
kobject: 'holders' (000000000d6f1dcc): calling ktype release
kobject: (000000000d6f1dcc): dynamic_kobj_release
kobject: 'holders': free name
kobject: 'slaves' (0000000003f0c160): kobject_cleanup, parent  
00000000d3975188
kobject: 'slaves' (0000000003f0c160): auto cleanup kobject_del
kobject: 'slaves' (0000000003f0c160): calling ktype release
kobject: (0000000003f0c160): dynamic_kobj_release
kobject: 'slaves': free name
kobject: 'loop0' (00000000d3975188): kobject_uevent_env
kobject: 'loop0' (00000000d3975188): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'iosched' (000000009bbaa4e4): kobject_cleanup, parent            
(null)
kobject: 'iosched' (000000009bbaa4e4): calling ktype release
kobject: 'iosched': free name
kobject: 'loop0' (00000000d3975188): kobject_cleanup, parent            
(null)
kobject: 'loop0' (00000000d3975188): calling ktype release
kobject: 'queue' (00000000a0174471): kobject_cleanup, parent            
(null)
kobject: 'queue' (00000000a0174471): calling ktype release
kobject: 'queue': free name
kobject: '0' (00000000a0ddde50): kobject_cleanup, parent           (null)
kobject: 'loop0': free name
kobject: '0' (00000000a0ddde50): calling ktype release
kobject: 'loop0' (00000000e846e269): kobject_cleanup, parent            
(null)
kobject: '0': free name
kobject: 'loop0' (00000000e846e269): calling ktype release
kobject: '7:0' (00000000d779594a): kobject_add_internal: parent: 'bdi',  
set: 'devices'
kobject: 'queue' (000000000dd9aad6): kobject_cleanup, parent            
(null)
kobject: 'cpu0' (00000000c221c143): kobject_cleanup, parent           (null)
kobject: 'queue' (000000000dd9aad6): calling ktype release
kobject: '7:0' (00000000d779594a): kobject_uevent_env
kobject: 'queue': free name
kobject: 'cpu0' (00000000c221c143): calling ktype release
kobject: '0' (00000000934c8b41): kobject_cleanup, parent           (null)
kobject: '7:0' (00000000d779594a): fill_kobj_path: path  
= '/devices/virtual/bdi/7:0'
kobject: 'loop0': free name
kobject: 'cpu0': free name
kobject: '0' (00000000934c8b41): calling ktype release
kobject: 'cpu1' (0000000023ab86cf): kobject_cleanup, parent           (null)
kobject: '0': free name
kobject: 'cpu1' (0000000023ab86cf): calling ktype release
kobject: 'cpu0' (00000000d4cf0527): kobject_cleanup, parent           (null)
kobject: 'loop0' (000000000c1282a5): kobject_add_internal: parent: 'block',  
set: 'devices'
kobject: 'cpu0' (00000000d4cf0527): calling ktype release
kobject: 'cpu1': free name
kobject: 'mq' (0000000008bd5ae2): kobject_cleanup, parent           (null)
kobject: 'cpu0': free name
kobject: 'loop0' (000000000c1282a5): kobject_uevent_env
kobject: 'cpu1' (0000000065a7e78d): kobject_cleanup, parent           (null)
kobject: 'mq' (0000000008bd5ae2): calling ktype release
kobject: 'cpu1' (0000000065a7e78d): calling ktype release
kobject: 'mq': free name
kobject: 'cpu1': free name
kobject: 'loop0' (000000000c1282a5): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'holders' (000000000f9ab04c): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: 'mq' (0000000002e79e66): kobject_cleanup, parent           (null)
kobject: 'slaves' (00000000998b395d): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: 'mq' (0000000002e79e66): calling ktype release
kobject: 'loop0' (000000000c1282a5): kobject_uevent_env
kobject: 'mq': free name
kobject: 'loop0' (000000000c1282a5): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'queue' (00000000bc815593): kobject_add_internal: parent: 'loop0',  
set: '<NULL>'
kobject: 'mq' (00000000c600fa9c): kobject_add_internal: parent: 'loop0',  
set: '<NULL>'
kobject: 'mq' (00000000c600fa9c): kobject_uevent_env
kobject: 'mq' (00000000c600fa9c): kobject_uevent_env: filter function  
caused the event to drop!
kobject: '0' (000000001894b71a): kobject_add_internal: parent: 'mq',  
set: '<NULL>'
kobject: 'cpu0' (00000000d1aaad77): kobject_add_internal: parent: '0',  
set: '<NULL>'
kobject: 'cpu1' (00000000dffe2062): kobject_add_internal: parent: '0',  
set: '<NULL>'
kobject: 'queue' (00000000bc815593): kobject_uevent_env
kobject: 'queue' (00000000bc815593): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'iosched' (00000000503550bf): kobject_add_internal:  
parent: 'queue', set: '<NULL>'
kobject: 'iosched' (00000000503550bf): kobject_uevent_env
kobject: 'iosched' (00000000503550bf): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'integrity' (000000009b782ce0): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: 'integrity' (000000009b782ce0): kobject_uevent_env
kobject: 'integrity' (000000009b782ce0): kobject_uevent_env: filter  
function caused the event to drop!
kobject: 'loop3' (0000000083011be5): kobject_uevent_env
kobject: 'loop3' (0000000083011be5): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'integrity' (000000009b782ce0): kobject_uevent_env
kobject: 'integrity' (000000009b782ce0): kobject_uevent_env: filter  
function caused the event to drop!
kobject: 'loop5' (00000000e380a391): kobject_uevent_env
kobject: 'loop5' (00000000e380a391): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'integrity' (000000009b782ce0): kobject_cleanup, parent            
(null)
kobject: 'loop1' (00000000ccd5dd1a): kobject_uevent_env
kobject: 'integrity' (000000009b782ce0): does not have a release()  
function, it is broken and must be fixed.
kobject: 'loop1' (00000000ccd5dd1a): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'integrity': free name
kobject: 'loop4' (0000000069488bfb): kobject_uevent_env
kobject: 'loop4' (0000000069488bfb): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: '7:0' (00000000d779594a): kobject_uevent_env
kobject: '7:0' (00000000d779594a): fill_kobj_path: path  
= '/devices/virtual/bdi/7:0'
kobject: '7:0' (00000000d779594a): kobject_cleanup, parent           (null)
kobject: '7:0' (00000000d779594a): calling ktype release
kobject: '7:0': free name
kobject: 'mq' (00000000c600fa9c): kobject_uevent_env
kobject: 'mq' (00000000c600fa9c): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'queue' (00000000bc815593): kobject_uevent_env
kobject: 'queue' (00000000bc815593): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'iosched' (00000000503550bf): kobject_uevent_env
kobject: 'iosched' (00000000503550bf): kobject_uevent_env: attempted to  
send uevent without kset!
kobject: 'holders' (000000000f9ab04c): kobject_cleanup, parent  
000000000c1282a5
kobject: 'holders' (000000000f9ab04c): auto cleanup kobject_del
kobject: 'holders' (000000000f9ab04c): calling ktype release
kobject: (000000000f9ab04c): dynamic_kobj_release
kobject: 'holders': free name
kobject: 'slaves' (00000000998b395d): kobject_cleanup, parent  
000000000c1282a5
kobject: 'slaves' (00000000998b395d): auto cleanup kobject_del
kobject: 'slaves' (00000000998b395d): calling ktype release
kobject: (00000000998b395d): dynamic_kobj_release
kobject: 'slaves': free name
kobject: 'loop0' (000000000c1282a5): kobject_uevent_env
kobject: 'loop0' (000000000c1282a5): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'iosched' (00000000503550bf): kobject_cleanup, parent            
(null)
kobject: 'iosched' (00000000503550bf): calling ktype release
kobject: 'iosched': free name
kobject: 'loop0' (000000000c1282a5): kobject_cleanup, parent            
(null)
kobject: 'loop0' (000000000c1282a5): calling ktype release
kobject: 'queue' (00000000bc815593): kobject_cleanup, parent            
(null)
kobject: 'queue' (00000000bc815593): calling ktype release
kobject: '0' (000000001894b71a): kobject_cleanup, parent           (null)
kobject: '0' (000000001894b71a): calling ktype release
kobject: 'queue': free name
kobject: 'loop0': free name
kobject: '0': free name
kobject: 'cpu0' (00000000d1aaad77): kobject_cleanup, parent           (null)
kobject: '7:0' (000000004397ece3): kobject_add_internal: parent: 'bdi',  
set: 'devices'
kobject: 'cpu0' (00000000d1aaad77): calling ktype release
kobject: 'cpu0': free name
kobject: 'cpu1' (00000000dffe2062): kobject_cleanup, parent           (null)
kobject: '7:0' (000000004397ece3): kobject_uevent_env
kobject: 'cpu1' (00000000dffe2062): calling ktype release
kobject: '7:0' (000000004397ece3): fill_kobj_path: path  
= '/devices/virtual/bdi/7:0'
kobject: 'cpu1': free name
kobject: 'loop0' (000000008e3fb47c): kobject_add_internal: parent: 'block',  
set: 'devices'
kobject: 'mq' (00000000c600fa9c): kobject_cleanup, parent           (null)
kobject: 'loop0' (000000008e3fb47c): kobject_uevent_env
kobject: 'mq' (00000000c600fa9c): calling ktype release
kobject: 'loop0' (000000008e3fb47c): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'mq': free name
kobject: 'holders' (0000000020f0de39): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: 'slaves' (000000001494dd85): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: 'loop0' (000000008e3fb47c): kobject_uevent_env
kobject: 'loop0' (000000008e3fb47c): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'queue' (0000000085a2a2c8): kobject_add_internal: parent: 'loop0',  
set: '<NULL>'
kobject: 'mq' (000000008ef59ef5): kobject_add_internal: parent: 'loop0',  
set: '<NULL>'
kobject: 'mq' (000000008ef59ef5): kobject_uevent_env
kobject: 'mq' (000000008ef59ef5): kobject_uevent_env: filter function  
caused the event to drop!
kobject: '0' (00000000e39fe280): kobject_add_internal: parent: 'mq',  
set: '<NULL>'
kobject: 'cpu0' (0000000096f4d280): kobject_add_internal: parent: '0',  
set: '<NULL>'
kobject: 'cpu1' (0000000082769fb8): kobject_add_internal: parent: '0',  
set: '<NULL>'
kobject: 'queue' (0000000085a2a2c8): kobject_uevent_env
kobject: 'queue' (0000000085a2a2c8): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'iosched' (000000009dca673b): kobject_add_internal:  
parent: 'queue', set: '<NULL>'
kobject: 'iosched' (000000009dca673b): kobject_uevent_env
kobject: 'iosched' (000000009dca673b): kobject_uevent_env: filter function  
caused the event to drop!
kobject: 'integrity' (000000001224c3c2): kobject_add_internal:  
parent: 'loop0', set: '<NULL>'
kobject: 'integrity' (000000001224c3c2): kobject_uevent_env
kobject: 'integrity' (000000001224c3c2): kobject_uevent_env: filter  
function caused the event to drop!
kobject: 'loop2' (000000001e25d2fb): kobject_uevent_env
kobject: 'loop2' (000000001e25d2fb): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop1' (00000000ccd5dd1a): kobject_uevent_env
bridge: RTM_NEWNEIGH bridge0 without NUD_PERMANENT
kobject: 'loop1' (00000000ccd5dd1a): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop4' (0000000069488bfb): kobject_uevent_env
kobject: 'loop4' (0000000069488bfb): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
bridge: RTM_NEWNEIGH bridge0 without NUD_PERMANENT
kobject: 'loop0' (000000008e3fb47c): kobject_uevent_env
kobject: 'loop0' (000000008e3fb47c): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
bridge: RTM_NEWNEIGH bridge0 without NUD_PERMANENT
kobject: 'loop5' (00000000e380a391): kobject_uevent_env
kobject: 'loop5' (00000000e380a391): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (0000000083011be5): kobject_uevent_env
bridge: RTM_NEWNEIGH bridge0 without NUD_PERMANENT
kobject: 'loop3' (0000000083011be5): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000e380a391): kobject_uevent_env
kobject: 'loop5' (00000000e380a391): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (0000000083011be5): kobject_uevent_env
kobject: 'loop3' (0000000083011be5): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
bridge: RTM_NEWNEIGH bridge0 without NUD_PERMANENT
kobject: 'loop5' (00000000e380a391): kobject_uevent_env
bridge: RTM_NEWNEIGH bridge0 without NUD_PERMANENT
kobject: 'loop5' (00000000e380a391): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop3' (0000000083011be5): kobject_uevent_env
kobject: 'loop3' (0000000083011be5): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop3' (0000000083011be5): kobject_uevent_env
kobject: 'loop3' (0000000083011be5): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop2' (000000001e25d2fb): kobject_uevent_env
kobject: 'loop2' (000000001e25d2fb): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop3' (0000000083011be5): kobject_uevent_env
kobject: 'loop3' (0000000083011be5): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop0' (000000008e3fb47c): kobject_uevent_env
kobject: 'loop0' (000000008e3fb47c): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
kobject: 'loop1' (00000000ccd5dd1a): kobject_uevent_env
kobject: 'loop1' (00000000ccd5dd1a): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
kobject: 'loop4' (0000000069488bfb): kobject_uevent_env
kobject: 'loop4' (0000000069488bfb): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
kobject: 'loop5' (00000000e380a391): kobject_uevent_env
kobject: 'loop5' (00000000e380a391): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop2' (000000001e25d2fb): kobject_uevent_env
kobject: 'loop2' (000000001e25d2fb): fill_kobj_path: path  
= '/devices/virtual/block/loop2'
kobject: 'loop3' (0000000083011be5): kobject_uevent_env
kobject: 'loop3' (0000000083011be5): fill_kobj_path: path  
= '/devices/virtual/block/loop3'
kobject: 'loop5' (00000000e380a391): kobject_uevent_env
kobject: 'loop5' (00000000e380a391): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
kobject: 'loop2' (000000001e25d2fb): kobject_uevent_env
kobject: 'loop2' (000000001e25d2fb): fill_kobj_path: path  
= '/devices/virtual/block/loop2'


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
