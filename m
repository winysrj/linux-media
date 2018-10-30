Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f200.google.com ([209.85.166.200]:42151 "EHLO
        mail-it1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbeJaEpz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 00:45:55 -0400
Received: by mail-it1-f200.google.com with SMTP id v125-v6so14621514ita.7
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2018 12:51:03 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 30 Oct 2018 12:51:02 -0700
Message-ID: <00000000000069922505797781b0@google.com>
Subject: WARNING in vb2_core_reqbufs
From: syzbot <syzbot+f9966a25169b6d66d61f@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=16680f9d400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=93932074d01b4a5
dashboard link: https://syzkaller.appspot.com/bug?extid=f9966a25169b6d66d61f
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f9966a25169b6d66d61f@syzkaller.appspotmail.com

WARNING: CPU: 0 PID: 24550 at  
drivers/media/common/videobuf2/videobuf2-core.c:727  
vb2_core_reqbufs+0x5c7/0x1040  
drivers/media/common/videobuf2/videobuf2-core.c:727
Kernel panic - not syncing: panic_on_warn set ...

CPU: 0 PID: 24550 Comm: syz-executor0 Not tainted 4.19.0+ #311
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x244/0x39d lib/dump_stack.c:113
kobject: 'loop1' (00000000ed4787c1): kobject_uevent_env
  panic+0x238/0x4e7 kernel/panic.c:184
  __warn.cold.8+0x20/0x4a kernel/panic.c:536
  report_bug+0x254/0x2d0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:178 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:271
  do_invalid_op+0x36/0x40 arch/x86/kernel/traps.c:290
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:966
RIP: 0010:vb2_core_reqbufs+0x5c7/0x1040  
drivers/media/common/videobuf2/videobuf2-core.c:727
Code: 83 c0 03 38 d0 7c 08 84 d2 0f 85 15 09 00 00 44 8b 3b 31 ff 48 83 c3  
04 44 89 fe e8 03 47 34 fc 45 85 ff 75 9e e8 e9 45 34 fc <0f> 0b bb ea ff  
ff ff e8 dd 45 34 fc 48 b8 00 00 00 00 00 fc ff df
RSP: 0018:ffff8801884ff538 EFLAGS: 00010212
RAX: 0000000000040000 RBX: 0000000000000000 RCX: ffffc9000ba50000
RDX: 00000000000000c3 RSI: ffffffff854b1e17 RDI: 0000000000000005
RBP: ffff8801884ff6d0 R08: ffff8801cb208240 R09: ffff8801cbba62b8
R10: ffffed0039774c5e R11: ffff8801cbba62f7 R12: 0000000000000008
R13: 0000000000000001 R14: ffff8801cbba6258 R15: ffff8801b88c8080
  vb2_ioctl_reqbufs+0x1c2/0x350  
drivers/media/common/videobuf2/videobuf2-v4l2.c:721
  v4l_reqbufs+0xae/0xd0 drivers/media/v4l2-core/v4l2-ioctl.c:1882
  __video_do_ioctl+0x519/0xf00 drivers/media/v4l2-core/v4l2-ioctl.c:2833
  video_usercopy+0x5c1/0x1760 drivers/media/v4l2-core/v4l2-ioctl.c:3013
  video_ioctl2+0x2c/0x33 drivers/media/v4l2-core/v4l2-ioctl.c:3057
  v4l2_ioctl+0x154/0x1b0 drivers/media/v4l2-core/v4l2-dev.c:364
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:501 [inline]
  do_vfs_ioctl+0x1de/0x1720 fs/ioctl.c:685
  ksys_ioctl+0xa9/0xd0 fs/ioctl.c:702
  __do_sys_ioctl fs/ioctl.c:709 [inline]
  __se_sys_ioctl fs/ioctl.c:707 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:707
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x457569
Code: fd b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f5481b79c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000457569
RDX: 0000000020000100 RSI: 00000000c0145608 RDI: 0000000000000003
RBP: 000000000072bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f5481b7a6d4
R13: 00000000004c1cca R14: 00000000004d2bb8 R15: 00000000ffffffff
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
