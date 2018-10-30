Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f200.google.com ([209.85.166.200]:56653 "EHLO
        mail-it1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbeJ3TlB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 15:41:01 -0400
Received: by mail-it1-f200.google.com with SMTP id w20-v6so12306256itb.6
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2018 03:48:04 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 30 Oct 2018 03:48:03 -0700
Message-ID: <0000000000008e601f05796feb24@google.com>
Subject: KASAN: use-after-free Read in vb2_mmap
From: syzbot <syzbot+be93025dd45dccd8923c@syzkaller.appspotmail.com>
To: kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, m.szyprowski@samsung.com,
        mchehab@kernel.org, pawel@osciak.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

syzbot found the following crash on:

HEAD commit:    4b42745211af Merge tag 'armsoc-soc' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=114278d5400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=93932074d01b4a5
dashboard link: https://syzkaller.appspot.com/bug?extid=be93025dd45dccd8923c
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15b8dbe5400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15c71e83400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+be93025dd45dccd8923c@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in vb2_mmap+0x65f/0x6e0  
drivers/media/common/videobuf2/videobuf2-core.c:1971
Read of size 8 at addr ffff8801bcddaac0 by task syz-executor694/5674

CPU: 1 PID: 5674 Comm: syz-executor694 Not tainted 4.19.0+ #213
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x244/0x39d lib/dump_stack.c:113
  print_address_description.cold.7+0x9/0x1ff mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.8+0x242/0x309 mm/kasan/report.c:412
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
  vb2_mmap+0x65f/0x6e0 drivers/media/common/videobuf2/videobuf2-core.c:1971
  vb2_fop_mmap+0x4b/0x70 drivers/media/common/videobuf2/videobuf2-v4l2.c:832
  v4l2_mmap+0x153/0x200 drivers/media/v4l2-core/v4l2-dev.c:401
  call_mmap include/linux/fs.h:1844 [inline]
  mmap_region+0xe85/0x1cd0 mm/mmap.c:1786
  do_mmap+0xa22/0x1230 mm/mmap.c:1559
  do_mmap_pgoff include/linux/mm.h:2320 [inline]
  vm_mmap_pgoff+0x213/0x2c0 mm/util.c:350
  ksys_mmap_pgoff+0x4da/0x660 mm/mmap.c:1609
  __do_sys_mmap_pgoff mm/mmap.c:1620 [inline]
  __se_sys_mmap_pgoff mm/mmap.c:1616 [inline]
  __ia32_sys_mmap_pgoff+0xdd/0x1a0 mm/mmap.c:1616
  do_syscall_32_irqs_on arch/x86/entry/common.c:326 [inline]
  do_fast_syscall_32+0x34d/0xfb2 arch/x86/entry/common.c:397
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7fcba29
Code: 85 d2 74 02 89 0a 5b 5d c3 8b 04 24 c3 8b 14 24 c3 8b 3c 24 c3 90 90  
90 90 90 90 90 90 90 90 90 90 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90  
90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000ffb6de5c EFLAGS: 00000286 ORIG_RAX: 00000000000000c0
RAX: ffffffffffffffda RBX: 0000000020fff000 RCX: 0000000000001000
RDX: 0000000002000002 RSI: 0000000000000013 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 5673:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc7/0xe0 mm/kasan/kasan.c:553
  __do_kmalloc mm/slab.c:3722 [inline]
  __kmalloc+0x15b/0x760 mm/slab.c:3731
  kmalloc include/linux/slab.h:551 [inline]
  kzalloc include/linux/slab.h:741 [inline]
  __vb2_queue_alloc+0xf7/0xf20  
drivers/media/common/videobuf2/videobuf2-core.c:343
  vb2_core_reqbufs+0x971/0x1040  
drivers/media/common/videobuf2/videobuf2-core.c:732
  __vb2_init_fileio+0x344/0xc90  
drivers/media/common/videobuf2/videobuf2-core.c:2251
  __vb2_perform_fileio+0xcfb/0x1210  
drivers/media/common/videobuf2/videobuf2-core.c:2370
  vb2_write+0x38/0x50 drivers/media/common/videobuf2/videobuf2-core.c:2509
  vb2_fop_write+0x20a/0x400  
drivers/media/common/videobuf2/videobuf2-v4l2.c:874
  v4l2_write+0x168/0x220 drivers/media/v4l2-core/v4l2-dev.c:334
  __vfs_write+0x119/0x9f0 fs/read_write.c:485
  vfs_write+0x1fc/0x560 fs/read_write.c:549
  ksys_write+0x101/0x260 fs/read_write.c:598
  __do_sys_write fs/read_write.c:610 [inline]
  __se_sys_write fs/read_write.c:607 [inline]
  __ia32_sys_write+0x71/0xb0 fs/read_write.c:607
  do_syscall_32_irqs_on arch/x86/entry/common.c:326 [inline]
  do_fast_syscall_32+0x34d/0xfb2 arch/x86/entry/common.c:397
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139

Freed by task 5673:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/kasan.c:521
  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
  __cache_free mm/slab.c:3498 [inline]
  kfree+0xcf/0x230 mm/slab.c:3817
  __vb2_queue_free+0x5e2/0xa30  
drivers/media/common/videobuf2/videobuf2-core.c:523
  vb2_core_reqbufs+0x2da/0x1040  
drivers/media/common/videobuf2/videobuf2-core.c:691
  __vb2_cleanup_fileio+0xf0/0x160  
drivers/media/common/videobuf2/videobuf2-core.c:2328
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
  __fput+0x385/0xa30 fs/file_table.c:278
  ____fput+0x15/0x20 fs/file_table.c:309
  task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x318/0x380 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_32_irqs_on arch/x86/entry/common.c:341 [inline]
  do_fast_syscall_32+0xcd5/0xfb2 arch/x86/entry/common.c:397
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139

The buggy address belongs to the object at ffff8801bcddaac0
  which belongs to the cache kmalloc-512 of size 512
The buggy address is located 0 bytes inside of
  512-byte region [ffff8801bcddaac0, ffff8801bcddacc0)
The buggy address belongs to the page:
page:ffffea0006f37680 count:1 mapcount:0 mapping:ffff8801da800940 index:0x0
flags: 0x2fffc0000000200(slab)
raw: 02fffc0000000200 ffffea0006f11d08 ffffea0006edf908 ffff8801da800940
raw: 0000000000000000 ffff8801bcdda0c0 0000000100000006 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8801bcdda980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801bcddaa00: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> ffff8801bcddaa80: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
                                            ^
  ffff8801bcddab00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801bcddab80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
