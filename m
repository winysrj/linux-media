Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B29C169C4
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 16:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF85B214DA
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 16:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbfA2QnG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 11:43:06 -0500
Received: from mail-it1-f200.google.com ([209.85.166.200]:44241 "EHLO
        mail-it1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfA2QnF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 11:43:05 -0500
Received: by mail-it1-f200.google.com with SMTP id x82so15915268ita.9
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 08:43:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=8dRJrZLfB6CarDUUkOAxHBvdDCSKoBpervZL3I6QJds=;
        b=Jmq8gb2epeJIsVQi4UG4Le+R3txOBNhN/3usOPG/DD99VBSuxCXzn9hMdiowaMuC6Y
         ruhvPBXDXqs+usMZTG3TNs4p1Ub5xVb0P4G2e4rvQjfTpKZ8ITMrzdmxsW1kdqwuYQSA
         /hjj3ucfhyRuYblm9MRD+DetO5+Xx3Y1Xd4ASZNb7zFuP2QgRWoOSu3KpyVQ0fFs8stx
         A4piYIjzIOi/g/6ZLIMOFZH+NgaB/wbq+0EkhSxlhdwCScbmGgc37v6E67tzNfD7NyMr
         uGPWKo5bUqji2WlQqDzdh9A85gnWP3QCKWbm5KPw+Mr08ljrEBvqHzmMK7PsWEEG5sk7
         KHWg==
X-Gm-Message-State: AHQUAuZyZYBogVMDtoBT0B0ZSvol0YPKMav9lKYn12OEwgOoMG0qYaHJ
        8FCSZgdgRF0hoxTR81pcKqk/4QtZfAzSHETWLDXPFx5/fUZ9
X-Google-Smtp-Source: AHgI3Ia5r3/Zxioj52uYzwZeKTBWPHKvro6jeGDyOu1BkWn62TS89iDMQ7ZZe0DpdtZftinJDa2aoGVd5b0x5t1gH8TeYUJiXkSn
MIME-Version: 1.0
X-Received: by 2002:a02:95ae:: with SMTP id b43mr3509862jai.4.1548780184685;
 Tue, 29 Jan 2019 08:43:04 -0800 (PST)
Date:   Tue, 29 Jan 2019 08:43:04 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000be589d05809b7c8a@google.com>
Subject: WARNING in get_q_data
From:   syzbot <syzbot+44b24cff6bf96006ecfa@syzkaller.appspotmail.com>
To:     hans.verkuil@cisco.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    39ad1c1b6bb8 Add linux-next specific files for 20190129
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=127d3eef400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a2b2e9c0bc43c14d
dashboard link: https://syzkaller.appspot.com/bug?extid=44b24cff6bf96006ecfa
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=126417a0c00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16aa880f400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+44b24cff6bf96006ecfa@syzkaller.appspotmail.com

WARNING: CPU: 1 PID: 7479 at  
drivers/media/platform/vicodec/vicodec-core.c:151 get_q_data  
drivers/media/platform/vicodec/vicodec-core.c:151 [inline]
WARNING: CPU: 1 PID: 7479 at  
drivers/media/platform/vicodec/vicodec-core.c:151 get_q_data+0x53/0x80  
drivers/media/platform/vicodec/vicodec-core.c:140
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 7479 Comm: syz-executor073 Not tainted 5.0.0-rc4-next-20190129  
#21
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1db/0x2d0 lib/dump_stack.c:113
  panic+0x2cb/0x65c kernel/panic.c:214
  __warn.cold+0x20/0x48 kernel/panic.c:571
  report_bug+0x263/0x2b0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:178 [inline]
  fixup_bug arch/x86/kernel/traps.c:173 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:271
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:290
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:973
RIP: 0010:get_q_data drivers/media/platform/vicodec/vicodec-core.c:151  
[inline]
RIP: 0010:get_q_data+0x53/0x80  
drivers/media/platform/vicodec/vicodec-core.c:140
Code: 74 3a 83 fb 02 75 1e e8 eb 6e 33 fc 49 81 c4 70 02 00 00 e8 df 6e 33  
fc 4c 89 e0 5b 41 5c 5d c3 83 fb 0a 74 e2 e8 cd 6e 33 fc <0f> 0b e8 c6 6e  
33 fc 45 31 e4 5b 4c 89 e0 41 5c 5d c3 e8 b6 6e 33
RSP: 0018:ffff88808638f758 EFLAGS: 00010293
RAX: ffff888097a02400 RBX: 000000000000000c RCX: ffffffff854eab2f
RDX: 0000000000000000 RSI: ffffffff854eab63 RDI: 0000000000000005
RBP: ffff88808638f768 R08: ffff888097a02400 R09: ffffed10136ec909
R10: ffffed10136ec908 R11: ffff88809b764843 R12: ffff888098c484c0
R13: 0000000000000002 R14: ffff888098c484c0 R15: ffff88808638f7e4
  vidioc_s_selection+0x9b/0x3e0  
drivers/media/platform/vicodec/vicodec-core.c:997
  v4l_s_selection drivers/media/v4l2-core/v4l2-ioctl.c:2245 [inline]
  v4l_s_crop+0x32a/0x510 drivers/media/v4l2-core/v4l2-ioctl.c:2302
  __video_do_ioctl+0x805/0xd80 drivers/media/v4l2-core/v4l2-ioctl.c:2872
  video_usercopy+0x460/0x16b0 drivers/media/v4l2-core/v4l2-ioctl.c:3054
  video_ioctl2+0x2d/0x35 drivers/media/v4l2-core/v4l2-ioctl.c:3098
  v4l2_ioctl+0x156/0x1b0 drivers/media/v4l2-core/v4l2-dev.c:364
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:509 [inline]
  do_vfs_ioctl+0x107b/0x17d0 fs/ioctl.c:696
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0x1a3/0x800 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440089
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe747247e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440089
RDX: 0000000020000100 RSI: 000000004014563c RDI: 0000000000000003
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000401910
R13: 00000000004019a0 R14: 0000000000000000 R15: 0000000000000000
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
