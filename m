Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F28C1C169C4
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 07:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCD062177E
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 07:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725779AbfA2H6F (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 02:58:05 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:43083 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfA2H6F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 02:58:05 -0500
Received: by mail-io1-f70.google.com with SMTP id k4so16305096ioc.10
        for <linux-media@vger.kernel.org>; Mon, 28 Jan 2019 23:58:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=q1eYfQpz394h4N3SD6yLnKuMfsw9YGLfZVmc+FZ5xxI=;
        b=FxD/YIODJ3LpTeiKnXxNlN7xqvZf93BZue3I1kO8Yu7GRGCTtHgg89C1MxdIGhb+8Y
         4mSjPUJyLGu/nJHozAGziCXdXNIrPKo5z7wFqfNQYgeYTfppKLGNegarQROnN1nC/f7C
         JLR4imHjsIMLUUF+zLaTNbA4ImeaBHPPfDNFUv5wkOiNJyNeIu7z2N6YloDf2U1BL6xu
         Kdd+NhfGeljzEXbCNnpzMLspa0WzPWgSDOicyndAdEKShyqUZKKLZfoR8ubHvlsPjSjR
         WtWRNHYCztiRlGPgPBrUAHOy7SrMUnxaWtyAy7ER1+cuBBJ7OljqrngH0KF0wDHSO8QR
         SGyw==
X-Gm-Message-State: AHQUAuYbdaxumq6okkV4wvdFugRmKt4sGbs1KUZuDZVUs695HxWujhNE
        vJIRmiRSTYAC30xkDX+QZ8MSiwXICoo6yL9xH+6sdOIKSoP0
X-Google-Smtp-Source: AHgI3IZ3pk50CnTWpkitzslGAZ133+AR6Tocl4CBMHRZysLWQAaGz3zeufRV+BHvkpjlFcTtXMSQPxDU6fPthWMjwYzPlur6r3VW
MIME-Version: 1.0
X-Received: by 2002:a24:9411:: with SMTP id j17mr2074218ite.18.1548748683889;
 Mon, 28 Jan 2019 23:58:03 -0800 (PST)
Date:   Mon, 28 Jan 2019 23:58:03 -0800
In-Reply-To: <00000000000069922505797781b0@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000026533a05809427c7@google.com>
Subject: Re: WARNING in vb2_core_reqbufs
From:   syzbot <syzbot+f9966a25169b6d66d61f@syzkaller.appspotmail.com>
To:     kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, m.szyprowski@samsung.com,
        mchehab@kernel.org, pawel@osciak.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    39ad1c1b6bb8 Add linux-next specific files for 20190129
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17971f17400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a2b2e9c0bc43c14d
dashboard link: https://syzkaller.appspot.com/bug?extid=f9966a25169b6d66d61f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1342c7a0c00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15a241c4c00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f9966a25169b6d66d61f@syzkaller.appspotmail.com

WARNING: CPU: 1 PID: 8082 at  
drivers/media/common/videobuf2/videobuf2-core.c:728  
vb2_core_reqbufs+0x59b/0xf10  
drivers/media/common/videobuf2/videobuf2-core.c:728
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 8082 Comm: syz-executor505 Not tainted 5.0.0-rc4-next-20190129  
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
RIP: 0010:vb2_core_reqbufs+0x59b/0xf10  
drivers/media/common/videobuf2/videobuf2-core.c:728
Code: 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 56 08 00 00 45 8b 3c 9e 31  
ff 44 89 fe e8 9f 41 3d fc 45 85 ff 75 9f e8 15 40 3d fc <0f> 0b 41 bc ea  
ff ff ff e8 08 40 3d fc 48 b8 00 00 00 00 00 fc ff
RSP: 0018:ffff88809d8e7680 EFLAGS: 00010293
RAX: ffff88809138e3c0 RBX: 0000000000000000 RCX: ffffffff8544da11
RDX: 0000000000000000 RSI: ffffffff8544da1b RDI: 0000000000000005
RBP: ffff88809d8e77b0 R08: ffff88809138e3c0 R09: ffff88808d42d6f0
R10: ffffed1011a85ae5 R11: ffff88808d42d72f R12: 0000000000000001
R13: dffffc0000000000 R14: ffff88809d8e7728 R15: 0000000000000000
  vb2_reqbufs drivers/media/common/videobuf2/videobuf2-v4l2.c:664 [inline]
  vb2_reqbufs+0x1cb/0x210 drivers/media/common/videobuf2/videobuf2-v4l2.c:659
  v4l2_m2m_reqbufs+0x90/0x1d0 drivers/media/v4l2-core/v4l2-mem2mem.c:457
  v4l2_m2m_ioctl_reqbufs+0x6b/0x80  
drivers/media/v4l2-core/v4l2-mem2mem.c:1051
  v4l_reqbufs drivers/media/v4l2-core/v4l2-ioctl.c:1932 [inline]
  v4l_reqbufs+0xad/0xe0 drivers/media/v4l2-core/v4l2-ioctl.c:1921
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
RIP: 0033:0x440049
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc76fc9aa8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440049
RDX: 0000000020000400 RSI: 00000000c0145608 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004018d0
R13: 0000000000401960 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..

