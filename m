Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f72.google.com ([209.85.166.72]:56681 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728468AbeJ3FIS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 01:08:18 -0400
Received: by mail-io1-f72.google.com with SMTP id x12-v6so8904867iob.23
        for <linux-media@vger.kernel.org>; Mon, 29 Oct 2018 13:18:03 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 29 Oct 2018 13:18:02 -0700
Message-ID: <000000000000204051057963c4dc@google.com>
Subject: KASAN: use-after-free Write in __vb2_cleanup_fileio
From: syzbot <syzbot+4e12d2d56f8ccc65c180@syzkaller.appspotmail.com>
To: hverkuil@xs4all.nl, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, satendra.t@samsung.com,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

syzbot found the following crash on:

HEAD commit:    9f51ae62c84a Merge git://git.kernel.org/pub/scm/linux/kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=130e0599400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=62118286bb772a24
dashboard link: https://syzkaller.appspot.com/bug?extid=4e12d2d56f8ccc65c180
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1346e183400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=117c2713400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4e12d2d56f8ccc65c180@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __vb2_cleanup_fileio+0x13d/0x160  
drivers/media/common/videobuf2/videobuf2-core.c:2318
Write of size 4 at addr ffff8801d7730040 by task syz-executor965/5707

CPU: 1 PID: 5707 Comm: syz-executor965 Not tainted 4.19.0+ #309
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x244/0x39d lib/dump_stack.c:113
  print_address_description.cold.7+0x9/0x1ff mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.8+0x242/0x309 mm/kasan/report.c:412
  __asan_report_store4_noabort+0x17/0x20 mm/kasan/report.c:437
  __vb2_cleanup_fileio+0x13d/0x160  
drivers/media/common/videobuf2/videobuf2-core.c:2318
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
RIP: 0033:0x400f30
Code: 01 f0 ff ff 0f 83 b0 0a 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f  
44 00 00 83 3d 9d 57 2d 00 00 75 14 b8 03 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 84 0a 00 00 c3 48 83 ec 08 e8 3a 01 00 00
RSP: 002b:00007ffd05f62478 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000400f30
RDX: 0000000000000001 RSI: 0000000020000280 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00000000004002e0 R09: 00000000004002e0
R10: 0000000000a73880 R11: 0000000000000246 R12: 0000000000401e40
R13: 0000000000401ed0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 5702:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc7/0xe0 mm/kasan/kasan.c:553
  kmem_cache_alloc_trace+0x152/0x750 mm/slab.c:3620
  kmalloc include/linux/slab.h:546 [inline]
  kzalloc include/linux/slab.h:741 [inline]
  __vb2_init_fileio+0x1ce/0xc90  
drivers/media/common/videobuf2/videobuf2-core.c:2227
  __vb2_perform_fileio+0xcfb/0x1210  
drivers/media/common/videobuf2/videobuf2-core.c:2361
  vb2_read+0x3b/0x50 drivers/media/common/videobuf2/videobuf2-core.c:2493
  vb2_fop_read+0x20a/0x400  
drivers/media/common/videobuf2/videobuf2-v4l2.c:898
  v4l2_read+0x168/0x220 drivers/media/v4l2-core/v4l2-dev.c:317
  do_loop_readv_writev fs/read_write.c:700 [inline]
  do_iter_read+0x4a3/0x650 fs/read_write.c:924
  vfs_readv+0x175/0x1c0 fs/read_write.c:986
  do_readv+0x11a/0x310 fs/read_write.c:1019
  __do_sys_readv fs/read_write.c:1106 [inline]
  __se_sys_readv fs/read_write.c:1103 [inline]
  __x64_sys_readv+0x75/0xb0 fs/read_write.c:1103
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 5702:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/kasan.c:521
  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
  __cache_free mm/slab.c:3498 [inline]
  kfree+0xcf/0x230 mm/slab.c:3817
  __vb2_cleanup_fileio+0xf8/0x160  
drivers/media/common/videobuf2/videobuf2-core.c:2320
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

The buggy address belongs to the object at ffff8801d7730040
  which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 0 bytes inside of
  1024-byte region [ffff8801d7730040, ffff8801d7730440)
The buggy address belongs to the page:
page:ffffea00075dcc00 count:1 mapcount:0 mapping:ffff8801da800ac0 index:0x0  
compound_mapcount: 0
flags: 0x2fffc0000010200(slab|head)
raw: 02fffc0000010200 ffffea00075dcb88 ffffea00075dde08 ffff8801da800ac0
raw: 0000000000000000 ffff8801d7730040 0000000100000007 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8801d772ff00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8801d772ff80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff8801d7730000: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
                                            ^
  ffff8801d7730080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801d7730100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
