Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f69.google.com ([209.85.166.69]:54635 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728950AbeJ2VGa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Oct 2018 17:06:30 -0400
Received: by mail-io1-f69.google.com with SMTP id q26-v6so7806344ioi.21
        for <linux-media@vger.kernel.org>; Mon, 29 Oct 2018 05:18:04 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 29 Oct 2018 05:18:03 -0700
Message-ID: <00000000000091818d05795d0f2f@google.com>
Subject: KASAN: use-after-free Read in __vb2_perform_fileio
From: syzbot <syzbot+4180ff9ca6810b06c1e9@syzkaller.appspotmail.com>
To: kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, m.szyprowski@samsung.com,
        mchehab@kernel.org, pawel@osciak.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

syzbot found the following crash on:

HEAD commit:    8c60c36d0b8c Add linux-next specific files for 20181019
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13c73a33400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ddc97ab84fb1ff2a
dashboard link: https://syzkaller.appspot.com/bug?extid=4180ff9ca6810b06c1e9
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13d0dbe5400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1688efc5400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4180ff9ca6810b06c1e9@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __vb2_perform_fileio+0x10da/0x1210  
drivers/media/common/videobuf2/videobuf2-core.c:2391
Read of size 4 at addr ffff8801b6c52c5c by task syz-executor081/7270

CPU: 0 PID: 7270 Comm: syz-executor081 Not tainted  
4.19.0-rc8-next-20181019+ #99
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x244/0x39d lib/dump_stack.c:113
  print_address_description.cold.7+0x9/0x1ff mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.8+0x242/0x309 mm/kasan/report.c:412
  __asan_report_load4_noabort+0x14/0x20 mm/kasan/report.c:432
  __vb2_perform_fileio+0x10da/0x1210  
drivers/media/common/videobuf2/videobuf2-core.c:2391
  vb2_read+0x3b/0x50 drivers/media/common/videobuf2/videobuf2-core.c:2502
  vb2_fop_read+0x20a/0x400  
drivers/media/common/videobuf2/videobuf2-v4l2.c:898
  v4l2_read+0x168/0x220 drivers/media/v4l2-core/v4l2-dev.c:317
  __vfs_read+0x117/0x9b0 fs/read_write.c:416
  vfs_read+0x17f/0x3c0 fs/read_write.c:452
  ksys_pread64+0x181/0x1b0 fs/read_write.c:626
  __do_sys_pread64 fs/read_write.c:636 [inline]
  __se_sys_pread64 fs/read_write.c:633 [inline]
  __x64_sys_pread64+0x97/0xf0 fs/read_write.c:633
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x447a59
Code: e8 fc e6 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 4b c5 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fffcdab1c58 EFLAGS: 00000286 ORIG_RAX: 0000000000000011
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000447a59
RDX: 00000000000000d6 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 0000000000000000 R08: 000000000000000f R09: 000000000000000f
R10: 0000000000000000 R11: 0000000000000286 R12: 000000000000000f
R13: 000000000000b864 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 7270:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc7/0xe0 mm/kasan/kasan.c:553
  kmem_cache_alloc_trace+0x152/0x750 mm/slab.c:3620
  kmalloc include/linux/slab.h:546 [inline]
  kzalloc include/linux/slab.h:741 [inline]
  __vb2_init_fileio+0x1ce/0xc90  
drivers/media/common/videobuf2/videobuf2-core.c:2236
  __vb2_perform_fileio+0xcfb/0x1210  
drivers/media/common/videobuf2/videobuf2-core.c:2370
  vb2_read+0x3b/0x50 drivers/media/common/videobuf2/videobuf2-core.c:2502
  vb2_fop_read+0x20a/0x400  
drivers/media/common/videobuf2/videobuf2-v4l2.c:898
  v4l2_read+0x168/0x220 drivers/media/v4l2-core/v4l2-dev.c:317
  __vfs_read+0x117/0x9b0 fs/read_write.c:416
  vfs_read+0x17f/0x3c0 fs/read_write.c:452
  ksys_pread64+0x181/0x1b0 fs/read_write.c:626
  __do_sys_pread64 fs/read_write.c:636 [inline]
  __se_sys_pread64 fs/read_write.c:633 [inline]
  __x64_sys_pread64+0x97/0xf0 fs/read_write.c:633
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 7274:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/kasan.c:521
  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
  __cache_free mm/slab.c:3498 [inline]
  kfree+0xcf/0x230 mm/slab.c:3817
  __vb2_cleanup_fileio+0xf8/0x160  
drivers/media/common/videobuf2/videobuf2-core.c:2329
  vb2_core_queue_release+0x1e/0x80  
drivers/media/common/videobuf2/videobuf2-core.c:2052
  vb2_queue_release drivers/media/common/videobuf2/videobuf2-v4l2.c:672  
[inline]
  _vb2_fop_release+0x1d2/0x2b0  
drivers/media/common/videobuf2/videobuf2-v4l2.c:843
  vb2_fop_release+0x77/0xc0  
drivers/media/common/videobuf2/videobuf2-v4l2.c:857
  vivid_fop_release+0x18e/0x440 drivers/media/platform/vivid/vivid-core.c:474
  v4l2_release+0xfb/0x1a0 drivers/media/v4l2-core/v4l2-dev.c:448
  __fput+0x3bc/0xa70 fs/file_table.c:279
  ____fput+0x15/0x20 fs/file_table.c:312
  task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x318/0x380 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_64+0x6be/0x820 arch/x86/entry/common.c:293
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8801b6c52940
  which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 796 bytes inside of
  1024-byte region [ffff8801b6c52940, ffff8801b6c52d40)
The buggy address belongs to the page:
page:ffffea0006db1480 count:1 mapcount:0 mapping:ffff8801da800ac0 index:0x0  
compound_mapcount: 0
flags: 0x2fffc0000010200(slab|head)
raw: 02fffc0000010200 ffffea00071f9e88 ffffea0006db1608 ffff8801da800ac0
raw: 0000000000000000 ffff8801b6c52040 0000000100000007 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8801b6c52b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801b6c52b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff8801b6c52c00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                     ^
  ffff8801b6c52c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801b6c52d00: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
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
