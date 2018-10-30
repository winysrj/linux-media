Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f71.google.com ([209.85.166.71]:55065 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727231AbeJaEqz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 00:46:55 -0400
Received: by mail-io1-f71.google.com with SMTP id q26-v6so11893804ioi.21
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2018 12:52:03 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 30 Oct 2018 12:52:03 -0700
Message-ID: <00000000000003920305797785a0@google.com>
Subject: general protection fault in __vb2_queue_free
From: syzbot <syzbot+e1fb118a2ebb88031d21@syzkaller.appspotmail.com>
To: kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, m.szyprowski@samsung.com,
        mchehab@kernel.org, pawel@osciak.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

syzbot found the following crash on:

HEAD commit:    11743c56785c Merge tag 'rpmsg-v4.20' of git://github.com/a..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14bf1713400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=93932074d01b4a5
dashboard link: https://syzkaller.appspot.com/bug?extid=e1fb118a2ebb88031d21
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e1fb118a2ebb88031d21@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 21444 Comm: syz-executor2 Not tainted 4.19.0+ #88
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:vb2_vmalloc_put_userptr+0x73/0x250  
drivers/media/common/videobuf2/videobuf2-vmalloc.c:136
Code: fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 c2 01 00 00 48 b8 00 00 00 00  
00 fc ff df 49 8b 5e 08 48 8d 7b 09 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48  
89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 72 01 00 00
kobject: 'loop5' (000000004024c834): kobject_uevent_env
RSP: 0018:ffff8801bef179c8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 1ffffffff113e0ac
RDX: 0000000000000001 RSI: ffffffff854c11d9 RDI: 0000000000000009
RBP: ffff8801bef179f8 R08: ffff880185bd6080 R09: ffffed0037896c66
R10: ffff8801bef17af0 R11: ffff8801bc4b6337 R12: ffffc900021cb000
kobject: 'loop5' (000000004024c834): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
R13: 0000000000000000 R14: ffff8801c02be500 R15: ffff8801c02be500
FS:  0000000002556940(0000) GS:ffff8801daf00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000625208 CR3: 00000001cc0f1000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
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
RSP: 002b:00007ffdeb7c5970 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000411021
RDX: 0000000000000000 RSI: 0000000000730ff0 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 00007ffdeb7c5890 R11: 0000000000000293 R12: 0000000000000000
R13: 0000000000000001 R14: 00000000000002f3 R15: 0000000000000002
Modules linked in:
kobject: 'loop4' (00000000ce261bad): kobject_uevent_env
kobject: 'loop4' (00000000ce261bad): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
---[ end trace 7be6f1c122f23a75 ]---
RIP: 0010:vb2_vmalloc_put_userptr+0x73/0x250  
drivers/media/common/videobuf2/videobuf2-vmalloc.c:136
Code: fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 c2 01 00 00 48 b8 00 00 00 00  
00 fc ff df 49 8b 5e 08 48 8d 7b 09 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48  
89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 72 01 00 00
kobject: 'loop1' (00000000b4e7381a): kobject_uevent_env
RSP: 0018:ffff8801bef179c8 EFLAGS: 00010202
kobject: 'loop1' (00000000b4e7381a): fill_kobj_path: path  
= '/devices/virtual/block/loop1'
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 1ffffffff113e0ac
RDX: 0000000000000001 RSI: ffffffff854c11d9 RDI: 0000000000000009
kobject: 'loop5' (000000004024c834): kobject_uevent_env
RBP: ffff8801bef179f8 R08: ffff880185bd6080 R09: ffffed0037896c66
kobject: 'loop5' (000000004024c834): fill_kobj_path: path  
= '/devices/virtual/block/loop5'
R10: ffff8801bef17af0 R11: ffff8801bc4b6337 R12: ffffc900021cb000
R13: 0000000000000000 R14: ffff8801c02be500 R15: ffff8801c02be500
kobject: 'loop4' (00000000ce261bad): kobject_uevent_env
FS:  0000000002556940(0000) GS:ffff8801dae00000(0000) knlGS:0000000000000000
kobject: 'loop4' (00000000ce261bad): fill_kobj_path: path  
= '/devices/virtual/block/loop4'
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2e622000 CR3: 00000001cc0f1000 CR4: 00000000001406f0
kobject: 'loop0' (00000000b291ab68): kobject_uevent_env
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kobject: 'loop0' (00000000b291ab68): fill_kobj_path: path  
= '/devices/virtual/block/loop0'
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
kobject: 'loop3' (00000000e559060a): kobject_uevent_env
kobject: 'loop3' (00000000e559060a): fill_kobj_path: path  
= '/devices/virtual/block/loop3'


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
