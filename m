Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f69.google.com ([209.85.166.69]:35429 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730826AbeKQJq1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Nov 2018 04:46:27 -0500
Received: by mail-io1-f69.google.com with SMTP id n12-v6so24389698ioh.2
        for <linux-media@vger.kernel.org>; Fri, 16 Nov 2018 15:32:03 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 16 Nov 2018 15:32:03 -0800
Message-ID: <0000000000001c2b95057ad0935b@google.com>
Subject: kernel BUG at arch/x86/mm/physaddr.c:LINE! (2)
From: syzbot <syzbot+6c0effb5877f6b0344e2@syzkaller.appspotmail.com>
To: hverkuil@xs4all.nl, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

syzbot found the following crash on:

HEAD commit:    5929a1f0ff30 Merge tag 'riscv-for-linus-4.20-rc2' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=137766a3400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4a0a89f12ca9b0f5
dashboard link: https://syzkaller.appspot.com/bug?extid=6c0effb5877f6b0344e2
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6c0effb5877f6b0344e2@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at arch/x86/mm/physaddr.c:27!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 8479 Comm: syz-executor1 Not tainted 4.20.0-rc2+ #113
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__phys_addr+0xb5/0x120 arch/x86/mm/physaddr.c:27
Code: 08 4c 89 e3 31 ff 48 d3 eb 48 89 de e8 b4 bb 45 00 48 85 db 75 0f e8  
7a ba 45 00 4c 89 e0 5b 41 5c 41 5d 5d c3 e8 6b ba 45 00 <0f> 0b e8 64 ba  
45 00 48 c7 c7 10 20 47 89 48 b8 00 00 00 00 00 fc
RSP: 0018:ffff88815771f410 EFLAGS: 00010016
RAX: 0000000000040000 RBX: 0000000000000001 RCX: ffffc9000fc04000
RDX: 0000000000000119 RSI: ffffffff8139cd75 RDI: 0000000000000007
RBP: ffff88815771f428 R08: ffff888157a101c0 R09: ffffed103b5c5b67
R10: ffffed103b5c5b67 R11: ffff8881dae2db3b R12: 000040801396c000
R13: 0000000000000000 R14: 0000000000000010 R15: ffff88815771fab8
FS:  00007f52131d8700(0000) GS:ffff8881dae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000720f9c CR3: 00000001b5073000 CR4: 00000000001406f0
DR0: 0000000020000000 DR1: 0000000020000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Call Trace:
  virt_to_head_page include/linux/mm.h:658 [inline]
  virt_to_cache mm/slab.c:399 [inline]
  kfree+0x7b/0x230 mm/slab.c:3813
  vivid_vid_cap_s_selection+0x2c31/0x38e0  
drivers/media/platform/vivid/vivid-vid-cap.c:1006
  vidioc_s_selection+0xa4/0xc0 drivers/media/platform/vivid/vivid-core.c:352
  v4l_s_selection+0xba/0x140 drivers/media/v4l2-core/v4l2-ioctl.c:2197
  __video_do_ioctl+0x8b1/0x1050 drivers/media/v4l2-core/v4l2-ioctl.c:2853
  video_usercopy+0x5c1/0x1760 drivers/media/v4l2-core/v4l2-ioctl.c:3035
  video_ioctl2+0x2c/0x33 drivers/media/v4l2-core/v4l2-ioctl.c:3079
  v4l2_ioctl+0x154/0x1b0 drivers/media/v4l2-core/v4l2-dev.c:364
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:509 [inline]
  do_vfs_ioctl+0x1de/0x1790 fs/ioctl.c:696
  ksys_ioctl+0xa9/0xd0 fs/ioctl.c:713
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x457569
Code: fd b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f52131d7c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000457569
RDX: 0000000020000000 RSI: 00000000c040565f RDI: 0000000000000003
RBP: 000000000072bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f52131d86d4
R13: 00000000004c1f77 R14: 00000000004d3090 R15: 00000000ffffffff
Modules linked in:
---[ end trace df884aa85ab852c0 ]---
RIP: 0010:__phys_addr+0xb5/0x120 arch/x86/mm/physaddr.c:27
Code: 08 4c 89 e3 31 ff 48 d3 eb 48 89 de e8 b4 bb 45 00 48 85 db 75 0f e8  
7a ba 45 00 4c 89 e0 5b 41 5c 41 5d 5d c3 e8 6b ba 45 00 <0f> 0b e8 64 ba  
45 00 48 c7 c7 10 20 47 89 48 b8 00 00 00 00 00 fc
RSP: 0018:ffff88815771f410 EFLAGS: 00010016
RAX: 0000000000040000 RBX: 0000000000000001 RCX: ffffc9000fc04000
RDX: 0000000000000119 RSI: ffffffff8139cd75 RDI: 0000000000000007
RBP: ffff88815771f428 R08: ffff888157a101c0 R09: ffffed103b5c5b67
R10: ffffed103b5c5b67 R11: ffff8881dae2db3b R12: 000040801396c000
R13: 0000000000000000 R14: 0000000000000010 R15: ffff88815771fab8
FS:  00007f52131d8700(0000) GS:ffff8881dae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000720f9c CR3: 00000001b5073000 CR4: 00000000001406f0
DR0: 0000000020000000 DR1: 0000000020000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
