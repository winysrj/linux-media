Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f69.google.com ([209.85.166.69]:46160 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbeKSGaQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 01:30:16 -0500
Received: by mail-io1-f69.google.com with SMTP id e144-v6so29345921iof.13
        for <linux-media@vger.kernel.org>; Sun, 18 Nov 2018 12:09:03 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 18 Nov 2018 12:09:03 -0800
In-Reply-To: <0000000000001c2b95057ad0935b@google.com>
Message-ID: <000000000000c881ea057af5f8a6@google.com>
Subject: Re: kernel BUG at arch/x86/mm/physaddr.c:LINE! (2)
From: syzbot <syzbot+6c0effb5877f6b0344e2@syzkaller.appspotmail.com>
To: hverkuil@xs4all.nl, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

syzbot has found a reproducer for the following crash on:

HEAD commit:    1ce80e0fe98e Merge tag 'fsnotify_for_v4.20-rc3' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10fd0893400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d86f24333880b605
dashboard link: https://syzkaller.appspot.com/bug?extid=6c0effb5877f6b0344e2
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1312062b400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=131bd093400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6c0effb5877f6b0344e2@syzkaller.appspotmail.com

audit: type=1800 audit(1542571519.564:30): pid=5852 uid=0 auid=4294967295  
ses=4294967295 subj==unconfined op=collect_data cause=failed(directio)  
comm="startpar" name="rmnologin" dev="sda1" ino=2423 res=0
------------[ cut here ]------------
kernel BUG at arch/x86/mm/physaddr.c:27!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 6007 Comm: syz-executor386 Not tainted 4.20.0-rc2+ #338
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__phys_addr+0xb5/0x120 arch/x86/mm/physaddr.c:27
Code: 08 4c 89 e3 31 ff 48 d3 eb 48 89 de e8 b4 bb 45 00 48 85 db 75 0f e8  
7a ba 45 00 4c 89 e0 5b 41 5c 41 5d 5d c3 e8 6b ba 45 00 <0f> 0b e8 64 ba  
45 00 48 c7 c7 10 20 47 89 48 b8 00 00 00 00 00 fc
RSP: 0018:ffff8881c3567410 EFLAGS: 00010093
RAX: ffff8881d32b4080 RBX: 0000000000000001 RCX: ffffffff8139cd5c
RDX: 0000000000000000 RSI: ffffffff8139cd75 RDI: 0000000000000007
RBP: ffff8881c3567428 R08: ffff8881d32b4080 R09: ffffed103b5c5b67
R10: ffffed103b5c5b67 R11: ffff8881dae2db3b R12: 0000408005dd6000
R13: 0000000000000000 R14: 0000000000000010 R15: ffff8881c3567ab8
FS:  0000000001f9e880(0000) GS:ffff8881dae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000203e8008 CR3: 00000001c24cd000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
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
RIP: 0033:0x4442c9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b d8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff0d831768 EFLAGS: 00000207 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000004002e0 RCX: 00000000004442c9
RDX: 0000000020000000 RSI: 00000000c040565f RDI: 0000000000000005
RBP: 00000000006ce018 R08: 00000000004002e0 R09: 00000000004002e0
R10: 0000000000000000 R11: 0000000000000207 R12: 0000000000401fd0
R13: 0000000000402060 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 57f6f02b74dd3e8e ]---
RIP: 0010:__phys_addr+0xb5/0x120 arch/x86/mm/physaddr.c:27
Code: 08 4c 89 e3 31 ff 48 d3 eb 48 89 de e8 b4 bb 45 00 48 85 db 75 0f e8  
7a ba 45 00 4c 89 e0 5b 41 5c 41 5d 5d c3 e8 6b ba 45 00 <0f> 0b e8 64 ba  
45 00 48 c7 c7 10 20 47 89 48 b8 00 00 00 00 00 fc
RSP: 0018:ffff8881c3567410 EFLAGS: 00010093
RAX: ffff8881d32b4080 RBX: 0000000000000001 RCX: ffffffff8139cd5c
RDX: 0000000000000000 RSI: ffffffff8139cd75 RDI: 0000000000000007
RBP: ffff8881c3567428 R08: ffff8881d32b4080 R09: ffffed103b5c5b67
R10: ffffed103b5c5b67 R11: ffff8881dae2db3b R12: 0000408005dd6000
R13: 0000000000000000 R14: 0000000000000010 R15: ffff8881c3567ab8
FS:  0000000001f9e880(0000) GS:ffff8881dae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000203e8008 CR3: 00000001c24cd000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
