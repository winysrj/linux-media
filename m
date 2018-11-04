Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f70.google.com ([209.85.166.70]:40463 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727603AbeKDBMp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Nov 2018 21:12:45 -0400
Received: by mail-io1-f70.google.com with SMTP id r14-v6so5196608ioc.7
        for <linux-media@vger.kernel.org>; Sat, 03 Nov 2018 09:01:04 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 03 Nov 2018 09:01:03 -0700
In-Reply-To: <000000000000fd734c05799d3c90@google.com>
Message-ID: <0000000000004928fe0579c4c240@google.com>
Subject: Re: BUG: pagefault on kernel address ADDR in non-whitelisted uaccess
From: syzbot <syzbot+0cc8e3cc63ca373722c6@syzkaller.appspotmail.com>
To: hverkuil@xs4all.nl, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

syzbot has found a reproducer for the following crash on:

HEAD commit:    5f21585384a4 Merge tag 'for-linus-20181102' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=103c9825400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9384ecb1c973baed
dashboard link: https://syzkaller.appspot.com/bug?extid=0cc8e3cc63ca373722c6
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=112736eb400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14e2d82b400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0cc8e3cc63ca373722c6@syzkaller.appspotmail.com

sshd (5636) used greatest stack depth: 15744 bytes left
BUG: pagefault on kernel address 0xffffc90002569000 in non-whitelisted  
uaccess
BUG: unable to handle kernel paging request at ffffc90002569000
PGD 1da948067 P4D 1da948067 PUD 1da949067 PMD 1c0211067 PTE 0
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 5650 Comm: syz-executor571 Not tainted 4.19.0+ #317
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:copy_user_enhanced_fast_string+0xe/0x20  
arch/x86/lib/copy_user_64.S:180
Code: 89 d1 c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 31 c0 0f 1f 00 c3 0f 1f  
80 00 00 00 00 0f 1f 00 83 fa 40 0f 82 70 ff ff ff 89 d1 <f3> a4 31 c0 0f  
1f 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 83
RSP: 0018:ffff8801d8fcf680 EFLAGS: 00010202
RAX: 0000000000000000 RBX: 000000000000ca80 RCX: 0000000000004a80
RDX: 000000000000ca80 RSI: ffffc90002569000 RDI: 00000000200080c0
RBP: ffff8801d8fcf6b8 R08: 0000000000000000 R09: 000000000000032a
R10: fffff520004adb4f R11: ffffc9000256da7f R12: 000000002000cb40
R13: 00000000200000c0 R14: ffffc90002561000 R15: 00007ffffffff000
FS:  00000000017ca880(0000) GS:ffff8801dae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90002569000 CR3: 00000001ba5d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  copy_to_user include/linux/uaccess.h:155 [inline]
  vidioc_g_fmt_vid_overlay+0x392/0x550  
drivers/media/platform/vivid/vivid-vid-cap.c:1084
  v4l_g_fmt+0x2ad/0x640 drivers/media/v4l2-core/v4l2-ioctl.c:1489
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
RIP: 0033:0x443f49
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b d8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fffbe4a44c8 EFLAGS: 00000217 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000004002e0 RCX: 0000000000443f49
RDX: 00000000200000c0 RSI: 00000000c0d05604 RDI: 0000000000000004
RBP: 00000000006ce018 R08: 00000000004002e0 R09: 00000000004002e0
R10: 00000000004002e0 R11: 0000000000000217 R12: 0000000000401c50
R13: 0000000000401ce0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
CR2: ffffc90002569000
---[ end trace e294d16803c6d199 ]---
RIP: 0010:copy_user_enhanced_fast_string+0xe/0x20  
arch/x86/lib/copy_user_64.S:180
Code: 89 d1 c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 31 c0 0f 1f 00 c3 0f 1f  
80 00 00 00 00 0f 1f 00 83 fa 40 0f 82 70 ff ff ff 89 d1 <f3> a4 31 c0 0f  
1f 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 83
RSP: 0018:ffff8801d8fcf680 EFLAGS: 00010202
RAX: 0000000000000000 RBX: 000000000000ca80 RCX: 0000000000004a80
RDX: 000000000000ca80 RSI: ffffc90002569000 RDI: 00000000200080c0
RBP: ffff8801d8fcf6b8 R08: 0000000000000000 R09: 000000000000032a
R10: fffff520004adb4f R11: ffffc9000256da7f R12: 000000002000cb40
R13: 00000000200000c0 R14: ffffc90002561000 R15: 00007ffffffff000
FS:  00000000017ca880(0000) GS:ffff8801dae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90002569000 CR3: 00000001ba5d7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
