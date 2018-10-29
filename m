Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f198.google.com ([209.85.166.198]:55928 "EHLO
        mail-it1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727683AbeJ3CRg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Oct 2018 22:17:36 -0400
Received: by mail-it1-f198.google.com with SMTP id u72-v6so10129840itc.5
        for <linux-media@vger.kernel.org>; Mon, 29 Oct 2018 10:28:03 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 29 Oct 2018 10:28:03 -0700
Message-ID: <0000000000002cf4a10579616456@google.com>
Subject: WARNING in __vb2_queue_cancel
From: syzbot <syzbot+736c3aae4af7b50d9683@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=11f0dbe5400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=62118286bb772a24
dashboard link: https://syzkaller.appspot.com/bug?extid=736c3aae4af7b50d9683
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16ffc90b400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147dd1c5400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+736c3aae4af7b50d9683@syzkaller.appspotmail.com

WARNING: CPU: 1 PID: 5722 at  
drivers/media/common/videobuf2/videobuf2-core.c:1667  
__vb2_queue_cancel+0x89d/0xca0  
drivers/media/common/videobuf2/videobuf2-core.c:1667
Kernel panic - not syncing: panic_on_warn set ...

CPU: 1 PID: 5722 Comm: syz-executor576 Not tainted 4.19.0+ #309
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x244/0x39d lib/dump_stack.c:113
  panic+0x238/0x4e7 kernel/panic.c:184
  __warn.cold.8+0x20/0x4a kernel/panic.c:536
  report_bug+0x254/0x2d0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:178 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:271
  do_invalid_op+0x36/0x40 arch/x86/kernel/traps.c:290
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:966
RIP: 0010:__vb2_queue_cancel+0x89d/0xca0  
drivers/media/common/videobuf2/videobuf2-core.c:1667
Code: 48 8b 45 d0 65 48 33 04 25 28 00 00 00 0f 85 88 03 00 00 48 81 c4 b0  
01 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 83 9f 34 fc <0f> 0b 48 8b 85  
70 fe ff ff 48 05 28 02 00 00 48 89 85 40 fe ff ff
RSP: 0018:ffff8801d5a9f878 EFLAGS: 00010293
RAX: ffff8801d482c680 RBX: ffff8801d5a9fa28 RCX: ffffffff854abdf8
RDX: 0000000000000000 RSI: ffffffff854ac47d RDI: 0000000000000005
RBP: ffff8801d5a9fa50 R08: ffff8801d482c680 R09: ffffed003977abbf
R10: ffffed003977abbf R11: ffff8801cbbd5dff R12: ffff8801cbbd5dfc
R13: dffffc0000000000 R14: 0000000000000002 R15: ffff8801cbbd0d08
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
RIP: 0033:0x405591
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 94 17 00 00 c3 48  
83 ec 08 e8 6a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 b3 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffd801e3640 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000405591
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 0000000000000003
RBP: 00000000000003e8 R08: 00000000000003e8 R09: 0000000000000000
R10: 00007ffd801e3650 R11: 0000000000000293 R12: 00000000006dbc2c
R13: 000000000000002d R14: 0000000000000003 R15: 00000000006dbc20
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
