Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f70.google.com ([209.85.166.70]:47492 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727564AbeKBCg7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2018 22:36:59 -0400
Received: by mail-io1-f70.google.com with SMTP id y8-v6so18299874ioc.14
        for <linux-media@vger.kernel.org>; Thu, 01 Nov 2018 10:33:04 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 01 Nov 2018 10:33:04 -0700
In-Reply-To: <000000000000fd734c05799d3c90@google.com>
Message-ID: <000000000000a6278f05799dcf0a@google.com>
Subject: Re: BUG: pagefault on kernel address ADDR in non-whitelisted uaccess
From: syzbot <syzbot+0cc8e3cc63ca373722c6@syzkaller.appspotmail.com>
To: hverkuil@xs4all.nl, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

syzbot has found a reproducer for the following crash on:

HEAD commit:    4db9d11bcbef Add linux-next specific files for 20181101
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13fa9e05400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2a22859d870756c1
dashboard link: https://syzkaller.appspot.com/bug?extid=0cc8e3cc63ca373722c6
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11227e05400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0cc8e3cc63ca373722c6@syzkaller.appspotmail.com

BUG: pagefault on kernel address 0xffffc90003dbe000 in non-whitelisted  
uaccess
BUG: unable to handle kernel paging request at ffffc90003dbe000
PGD 1da948067 P4D 1da948067 PUD 1da949067 PMD 1d884f067 PTE 0
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 12256 Comm: syz-executor3 Not tainted 4.19.0-next-20181101+ #103
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:copy_user_enhanced_fast_string+0xe/0x20  
arch/x86/lib/copy_user_64.S:180
Code: 89 d1 c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 31 c0 0f 1f 00 c3 0f 1f  
80 00 00 00 00 0f 1f 00 83 fa 40 0f 82 70 ff ff ff 89 d1 <f3> a4 31 c0 0f  
1f 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 83
RSP: 0018:ffff8801a779f680 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 00000000000fd200 RCX: 00000000000f5200
RDX: 00000000000fd200 RSI: ffffc90003dbe000 RDI: 00000000200080c0
RBP: ffff8801a779f6b8 R08: 0000000000000000 R09: 0000000000003f48
R10: fffff520007d663f R11: ffffc90003eb31ff R12: 00000000200fd2c0
R13: 00000000200000c0 R14: ffffc90003db6000 R15: 00007ffffffff000
FS:  00007f6d98b26700(0000) GS:ffff8801daf00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90003dbe000 CR3: 00000001d794d000 CR4: 00000000001406e0
Call Trace:
  copy_to_user include/linux/uaccess.h:155 [inline]
  vidioc_g_fmt_vid_overlay+0x392/0x550  
drivers/media/platform/vivid/vivid-vid-cap.c:1084
  v4l_g_fmt+0x2ad/0x640 drivers/media/v4l2-core/v4l2-ioctl.c:1489
  __video_do_ioctl+0x8b1/0x1050 drivers/media/v4l2-core/v4l2-ioctl.c:2853
  video_usercopy+0x5c1/0x1750 drivers/media/v4l2-core/v4l2-ioctl.c:3035
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
RSP: 002b:00007f6d98b25c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000457569
RDX: 00000000200000c0 RSI: 00000000c0d05604 RDI: 0000000000000012
RBP: 000000000072c220 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f6d98b266d4
R13: 00000000004c1acf R14: 00000000004d29c8 R15: 00000000ffffffff
Modules linked in:
CR2: ffffc90003dbe000
---[ end trace faa0b92998172ee0 ]---
RIP: 0010:copy_user_enhanced_fast_string+0xe/0x20  
arch/x86/lib/copy_user_64.S:180
Code: 89 d1 c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 31 c0 0f 1f 00 c3 0f 1f  
80 00 00 00 00 0f 1f 00 83 fa 40 0f 82 70 ff ff ff 89 d1 <f3> a4 31 c0 0f  
1f 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 83
RSP: 0018:ffff8801a779f680 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 00000000000fd200 RCX: 00000000000f5200
RDX: 00000000000fd200 RSI: ffffc90003dbe000 RDI: 00000000200080c0
RBP: ffff8801a779f6b8 R08: 0000000000000000 R09: 0000000000003f48
R10: fffff520007d663f R11: ffffc90003eb31ff R12: 00000000200fd2c0
R13: 00000000200000c0 R14: ffffc90003db6000 R15: 00007ffffffff000
FS:  00007f6d98b26700(0000) GS:ffff8801daf00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90003dbe000 CR3: 00000001d794d000 CR4: 00000000001406e0
