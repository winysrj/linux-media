Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f197.google.com ([209.85.166.197]:56271 "EHLO
        mail-it1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730587AbeKMHlH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 02:41:07 -0500
Received: by mail-it1-f197.google.com with SMTP id 199-v6so13942884ith.5
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 13:46:04 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 12 Nov 2018 13:46:03 -0800
Message-ID: <000000000000aa8703057a7ea0bb@google.com>
Subject: WARNING in dma_buf_vunmap
From: syzbot <syzbot+a9317fe7ad261fc76b88@syzkaller.appspotmail.com>
To: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        sumit.semwal@linaro.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

syzbot found the following crash on:

HEAD commit:    ccda4af0f4b9 Linux 4.20-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12e15b83400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4a0a89f12ca9b0f5
dashboard link: https://syzkaller.appspot.com/bug?extid=a9317fe7ad261fc76b88
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a9317fe7ad261fc76b88@syzkaller.appspotmail.com

WARNING: CPU: 0 PID: 4274 at drivers/dma-buf/dma-buf.c:992  
dma_buf_vunmap+0x1bb/0x220 drivers/dma-buf/dma-buf.c:992
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 4274 Comm: syz-executor4 Not tainted 4.20.0-rc2+ #111
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x244/0x39d lib/dump_stack.c:113
  panic+0x2ad/0x55c kernel/panic.c:188
  __warn.cold.8+0x20/0x45 kernel/panic.c:540
  report_bug+0x254/0x2d0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:178 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:271
  do_invalid_op+0x36/0x40 arch/x86/kernel/traps.c:290
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:969
RIP: 0010:dma_buf_vunmap+0x1bb/0x220 drivers/dma-buf/dma-buf.c:992
Code: 00 00 00 00 e8 b6 f1 27 fd 4c 89 f7 e8 de 1e 77 03 e8 a9 f1 27 fd 48  
83 c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 95 f1 27 fd <0f> 0b eb e3 e8  
8c f1 27 fd 0f 0b e8 85 f1 27 fd 0f 0b e8 7e f1 27
RSP: 0018:ffff88817dff7900 EFLAGS: 00010293
RAX: ffff8881bd4b8580 RBX: 0000000000000000 RCX: ffffffff854cfb50
RDX: 0000000000000000 RSI: ffffffff8457964b RDI: 0000000000000000
RBP: ffff88817dff7930 R08: ffff8881bd4b8580 R09: ffffed103946ee06
R10: ffff88817dff7a88 R11: ffff8881ca377037 R12: ffffc90014b40000
R13: ffff8881cde0e4c0 R14: ffff8881cde0e528 R15: ffff8881bc9f4c00
  vb2_vmalloc_detach_dmabuf+0x5a/0x80  
drivers/media/common/videobuf2/videobuf2-vmalloc.c:406
  __vb2_plane_dmabuf_put.isra.5+0x122/0x310  
drivers/media/common/videobuf2/videobuf2-core.c:275
  __vb2_buf_dmabuf_put drivers/media/common/videobuf2/videobuf2-core.c:291  
[inline]
  __vb2_free_mem drivers/media/common/videobuf2/videobuf2-core.c:415 [inline]
  __vb2_queue_free+0x7f3/0xa30  
drivers/media/common/videobuf2/videobuf2-core.c:458
  vb2_core_queue_release+0x62/0x80  
drivers/media/common/videobuf2/videobuf2-core.c:2231
  vb2_queue_release drivers/media/common/videobuf2/videobuf2-v4l2.c:837  
[inline]
  _vb2_fop_release+0x1d2/0x2b0  
drivers/media/common/videobuf2/videobuf2-v4l2.c:1010
  vb2_fop_release+0x77/0xc0  
drivers/media/common/videobuf2/videobuf2-v4l2.c:1024
  vivid_fop_release+0x18e/0x440 drivers/media/platform/vivid/vivid-core.c:474
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
RIP: 0033:0x411021
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 34 19 00 00 c3 48  
83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffd44e7c0f0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000411021
RDX: 0000000000000001 RSI: 0000000000730e50 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 00007ffd44e7c020 R11: 0000000000000293 R12: 0000000000000000
R13: 0000000000000001 R14: 0000000000002fe8 R15: 0000000000000004
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
