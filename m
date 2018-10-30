Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f199.google.com ([209.85.166.199]:36870 "EHLO
        mail-it1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbeJaFfF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 01:35:05 -0400
Received: by mail-it1-f199.google.com with SMTP id m8-v6so14791380iti.2
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2018 13:40:03 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 30 Oct 2018 13:40:03 -0700
In-Reply-To: <00000000000003920305797785a0@google.com>
Message-ID: <000000000000aeaf8a057978304e@google.com>
Subject: Re: general protection fault in __vb2_queue_free
From: syzbot <syzbot+e1fb118a2ebb88031d21@syzkaller.appspotmail.com>
To: kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, m.szyprowski@samsung.com,
        mchehab@kernel.org, pawel@osciak.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

syzbot has found a reproducer for the following crash on:

HEAD commit:    11743c56785c Merge tag 'rpmsg-v4.20' of git://github.com/a..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14c8eb5b400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=93932074d01b4a5
dashboard link: https://syzkaller.appspot.com/bug?extid=e1fb118a2ebb88031d21
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=158fdbcb400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11d7d06d400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e1fb118a2ebb88031d21@syzkaller.appspotmail.com

audit: type=1800 audit(1540931695.249:30): pid=5573 uid=0 auid=4294967295  
ses=4294967295 subj=_ op=collect_data cause=failed(directio)  
comm="startpar" name="rmnologin" dev="sda1" ino=2423 res=0
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 5728 Comm: syz-executor006 Not tainted 4.19.0+ #88
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:vb2_vmalloc_put_userptr+0x73/0x250  
drivers/media/common/videobuf2/videobuf2-vmalloc.c:136
Code: fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 c2 01 00 00 48 b8 00 00 00 00  
00 fc ff df 49 8b 5e 08 48 8d 7b 09 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48  
89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 72 01 00 00
RSP: 0018:ffff8801d2d77408 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 1ffffffff113e0ac
RDX: 0000000000000001 RSI: ffffffff854c11d9 RDI: 0000000000000009
RBP: ffff8801d2d77438 R08: ffff8801d4b246c0 R09: ffffed003a5d044e
R10: ffff8801d2d77530 R11: ffff8801d2e82277 R12: ffffc90002551000
R13: 0000000000000000 R14: ffff8801cec5f380 R15: ffff8801cec5f380
FS:  0000000000000000(0000) GS:ffff8801dae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000043e910 CR3: 000000000946a000 CR4: 00000000001406f0
Call Trace:
  __vb2_buf_userptr_put drivers/media/common/videobuf2/videobuf2-core.c:258  
[inline]
  __vb2_free_mem drivers/media/common/videobuf2/videobuf2-core.c:415 [inline]
  __vb2_queue_free+0x4b1/0xa30  
drivers/media/common/videobuf2/videobuf2-core.c:456
  vb2_core_queue_release+0x62/0x80  
drivers/media/common/videobuf2/videobuf2-core.c:2055
  vb2_queue_release+0x15/0x20  
drivers/media/common/videobuf2/videobuf2-v4l2.c:672
  v4l2_m2m_ctx_release+0x1e/0x35 drivers/media/v4l2-core/v4l2-mem2mem.c:927
  vicodec_release+0xbd/0x120  
drivers/media/platform/vicodec/vicodec-core.c:1236
  v4l2_release+0xfb/0x1a0 drivers/media/v4l2-core/v4l2-dev.c:448
  __fput+0x385/0xa30 fs/file_table.c:278
  ____fput+0x15/0x20 fs/file_table.c:309
  task_work_run+0x1e8/0x2a0 kernel/task_work.c:113
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0x1ad6/0x26d0 kernel/exit.c:867
  do_group_exit+0x177/0x440 kernel/exit.c:970
  __do_sys_exit_group kernel/exit.c:981 [inline]
  __se_sys_exit_group kernel/exit.c:979 [inline]
  __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:979
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x442d98
Code: Bad RIP value.
RSP: 002b:00007ffc32d53f78 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000442d98
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00000000004c2968 R08: 00000000000000e7 R09: ffffffffffffffd0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006d4180 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 894fb90190094ea9 ]---
RIP: 0010:vb2_vmalloc_put_userptr+0x73/0x250  
drivers/media/common/videobuf2/videobuf2-vmalloc.c:136
Code: fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 c2 01 00 00 48 b8 00 00 00 00  
00 fc ff df 49 8b 5e 08 48 8d 7b 09 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48  
89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 72 01 00 00
RSP: 0018:ffff8801d2d77408 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 1ffffffff113e0ac
RDX: 0000000000000001 RSI: ffffffff854c11d9 RDI: 0000000000000009
RBP: ffff8801d2d77438 R08: ffff8801d4b246c0 R09: ffffed003a5d044e
R10: ffff8801d2d77530 R11: ffff8801d2e82277 R12: ffffc90002551000
R13: 0000000000000000 R14: ffff8801cec5f380 R15: ffff8801cec5f380
FS:  000000000073c880(0000) GS:ffff8801dae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000442d6e CR3: 000000000946a000 CR4: 00000000001406f0
