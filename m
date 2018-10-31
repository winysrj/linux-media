Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f199.google.com ([209.85.166.199]:56587 "EHLO
        mail-it1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728141AbeJaMNM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 08:13:12 -0400
Received: by mail-it1-f199.google.com with SMTP id w20-v6so14611523itb.6
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2018 20:17:03 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 30 Oct 2018 20:17:03 -0700
In-Reply-To: <00000000000095ce6305795aafbb@google.com>
Message-ID: <000000000000793b4005797dbc40@google.com>
Subject: Re: KASAN: null-ptr-deref Write in kthread_stop
From: syzbot <syzbot+53d5b2df0d9744411e2e@syzkaller.appspotmail.com>
To: hverkuil@xs4all.nl, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

syzbot has found a reproducer for the following crash on:

HEAD commit:    6201f31a39f8 Add linux-next specific files for 20181030
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=179da7cb400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2a22859d870756c1
dashboard link: https://syzkaller.appspot.com/bug?extid=53d5b2df0d9744411e2e
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=106f6999400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17267233400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+53d5b2df0d9744411e2e@syzkaller.appspotmail.com

sshd (5629) used greatest stack depth: 15744 bytes left
==================================================================
BUG: KASAN: null-ptr-deref in atomic_inc  
include/asm-generic/atomic-instrumented.h:109 [inline]
BUG: KASAN: null-ptr-deref in kthread_stop+0x108/0x8f0 kernel/kthread.c:545
Write of size 4 at addr 0000000000000020 by task syz-executor789/5655

CPU: 1 PID: 5655 Comm: syz-executor789 Not tainted 4.19.0-next-20181030+  
#101
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x244/0x39d lib/dump_stack.c:113
  kasan_report_error mm/kasan/report.c:352 [inline]
  kasan_report.cold.8+0x6d/0x309 mm/kasan/report.c:412
  check_memory_region_inline mm/kasan/kasan.c:260 [inline]
  check_memory_region+0x13e/0x1b0 mm/kasan/kasan.c:267
  kasan_check_write+0x14/0x20 mm/kasan/kasan.c:278
  atomic_inc include/asm-generic/atomic-instrumented.h:109 [inline]
  kthread_stop+0x108/0x8f0 kernel/kthread.c:545
  vivid_stop_generating_vid_cap+0x2bc/0x93b  
drivers/media/platform/vivid/vivid-kthread-cap.c:919
  vid_cap_stop_streaming+0x8d/0xe0  
drivers/media/platform/vivid/vivid-vid-cap.c:259
  __vb2_queue_cancel+0x171/0xca0  
drivers/media/common/videobuf2/videobuf2-core.c:1668
  vb2_core_streamoff+0x60/0x140  
drivers/media/common/videobuf2/videobuf2-core.c:1804
  __vb2_cleanup_fileio+0x73/0x160  
drivers/media/common/videobuf2/videobuf2-core.c:2325
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
RIP: 0033:0x400ef0
Code: 01 f0 ff ff 0f 83 b0 0a 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f  
44 00 00 83 3d dd 57 2d 00 00 75 14 b8 03 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 84 0a 00 00 c3 48 83 ec 08 e8 3a 01 00 00
RSP: 002b:00007fff00659738 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000400ef0
RDX: 0000000020000024 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000001446880 R09: 00000000004002e0
R10: 000000000000000f R11: 0000000000000246 R12: 0000000000401e00
R13: 0000000000401e90 R14: 0000000000000000 R15: 0000000000000000
==================================================================
