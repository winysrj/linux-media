Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D829C43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 12:41:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C244217D8
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 12:41:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbeLRMlE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 07:41:04 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:37478 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbeLRMlE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 07:41:04 -0500
Received: by mail-io1-f70.google.com with SMTP id d63so15364383iog.4
        for <linux-media@vger.kernel.org>; Tue, 18 Dec 2018 04:41:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=mUfbHQ74N9uH9Gs2f8y9eJBQ3F7xR2hO6D0FQiQnrTE=;
        b=JqodzZPa6JXhUJ/cCFoiF75TkO5m22j2Y5tLZZRfzaHcCTpTfTgwUKoGIfDMM8k2Q4
         hwyGUa1u15c8Yun+xL2ajyrpNHhyQkYH4T2l4Q3/IpQwanXx0vf7wkk4URyE8K20utze
         1j3StY89YpCvIj6KACERsrKPt1UFPL8nmVQm4NAAwwCmfKzrIggiLeFZGK1oXg5VPOoL
         nUfKJ/8C7zau1Khpih4FqB2j3o8TfCQMMKM+8hpjwDjjSSnDlIlqcq3EI6v6NXm39P6I
         3upCT+fSlJCoVbRNdwKrjSiWkZXIJI57eHjgfCkd2hYj0pEwgOs0hTc+JBP7RDpaoJY4
         5xtw==
X-Gm-Message-State: AA+aEWadaE46g/cLlH4AQxn0KmbtMgypdMdYUBVlWS8cIzMRz+fLyc1z
        WkA3+nuIFL7j6KmEMkelb0Tu/8Y1Ak/9begBqHhEDk8D8l/M
X-Google-Smtp-Source: AFSGD/X8jxKZtOXoTaBL+j49PJOgrlBDsy5WVPt5wxeATTydgm+p6MLOJpq1xO/04tXZum5cGibvsRKJ7x5sKUrB1im1Ad/eUPJj
MIME-Version: 1.0
X-Received: by 2002:a02:2b18:: with SMTP id h24mr14084363jaa.7.1545136862827;
 Tue, 18 Dec 2018 04:41:02 -0800 (PST)
Date:   Tue, 18 Dec 2018 04:41:02 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d69d87057d4b3550@google.com>
Subject: KMSAN: kernel-infoleak in video_usercopy
From:   syzbot <syzbot+4f021cf3697781dbd9fb@syzkaller.appspotmail.com>
To:     glider@google.com, hansverk@cisco.com, hdegoede@redhat.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        mchehab@kernel.org, niklas.soderlund+renesas@ragnatech.se,
        paul.kocialkowski@bootlin.com, sakari.ailus@linux.intel.com,
        samitolvanen@google.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    0a602458c72c kmsan: random: another take at unpoisoning CR..
git tree:       kmsan
console output: https://syzkaller.appspot.com/x/log.txt?x=12f2cd5d400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9b071100dcf8e641
dashboard link: https://syzkaller.appspot.com/bug?extid=4f021cf3697781dbd9fb
compiler:       clang version 8.0.0 (trunk 348261)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15d6b21b400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17f15885400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4f021cf3697781dbd9fb@syzkaller.appspotmail.com

==================================================================
BUG: KMSAN: kernel-infoleak in _copy_to_user+0x1a4/0x250 lib/usercopy.c:32
CPU: 0 PID: 6254 Comm: syz-executor456 Not tainted 4.20.0-rc5+ #2
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1c9/0x220 lib/dump_stack.c:113
  kmsan_report+0x12d/0x290 mm/kmsan/kmsan.c:682
  kmsan_internal_check_memory+0x334/0xa60 mm/kmsan/kmsan.c:742
  kmsan_copy_to_user+0x8d/0xa0 mm/kmsan/kmsan_hooks.c:604
  _copy_to_user+0x1a4/0x250 lib/usercopy.c:32
  copy_to_user include/linux/uaccess.h:177 [inline]
  video_usercopy+0x16c9/0x17d0 drivers/media/v4l2-core/v4l2-ioctl.c:3066
  video_ioctl2+0x9f/0xb0 drivers/media/v4l2-core/v4l2-ioctl.c:3079
  v4l2_ioctl+0x23f/0x270 drivers/media/v4l2-core/v4l2-dev.c:364
  do_vfs_ioctl+0xf36/0x2d30 fs/ioctl.c:46
  ksys_ioctl fs/ioctl.c:713 [inline]
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl+0x1da/0x270 fs/ioctl.c:718
  __x64_sys_ioctl+0x4a/0x70 fs/ioctl.c:718
  do_syscall_64+0xcd/0x110 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7
RIP: 0033:0x445659
Code: e8 6c b6 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 2b 12 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ff7a472ada8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000006dac28 RCX: 0000000000445659
RDX: 0000000020000000 RSI: 0000000080885659 RDI: 0000000000000003
RBP: 00000000006dac20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dac2c
R13: 6469762f7665642f R14: 00007ff7a472b9c0 R15: 00000000006dad2c

Uninit was stored to memory at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:247 [inline]
  kmsan_save_stack mm/kmsan/kmsan.c:262 [inline]
  kmsan_internal_chain_origin+0x162/0x260 mm/kmsan/kmsan.c:470
  kmsan_memcpy_memmove_metadata+0x1a9/0xf30 mm/kmsan/kmsan.c:345
  kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:363
  __msan_memcpy+0x61/0x70 mm/kmsan/kmsan_instr.c:148
  __v4l2_event_dequeue+0x2f8/0x730 drivers/media/v4l2-core/v4l2-event.c:54
  v4l2_event_dequeue+0x41c/0x560 drivers/media/v4l2-core/v4l2-event.c:81
  v4l_dqevent+0xba/0xe0 drivers/media/v4l2-core/v4l2-ioctl.c:2427
  __video_do_ioctl+0x1975/0x1fc0 drivers/media/v4l2-core/v4l2-ioctl.c:2853
  video_usercopy+0x8ae/0x17d0 drivers/media/v4l2-core/v4l2-ioctl.c:3035
  video_ioctl2+0x9f/0xb0 drivers/media/v4l2-core/v4l2-ioctl.c:3079
  v4l2_ioctl+0x23f/0x270 drivers/media/v4l2-core/v4l2-dev.c:364
  do_vfs_ioctl+0xf36/0x2d30 fs/ioctl.c:46
  ksys_ioctl fs/ioctl.c:713 [inline]
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl+0x1da/0x270 fs/ioctl.c:718
  __x64_sys_ioctl+0x4a/0x70 fs/ioctl.c:718
  do_syscall_64+0xcd/0x110 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7

Uninit was stored to memory at:
  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:247 [inline]
  kmsan_save_stack mm/kmsan/kmsan.c:262 [inline]
  kmsan_internal_chain_origin+0x162/0x260 mm/kmsan/kmsan.c:470
  kmsan_memcpy_memmove_metadata+0x1a9/0xf30 mm/kmsan/kmsan.c:345
  kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:363
  __msan_memcpy+0x61/0x70 mm/kmsan/kmsan_instr.c:148
  __v4l2_event_queue_fh+0xd2d/0x1260 drivers/media/v4l2-core/v4l2-event.c:145
  v4l2_event_queue_fh+0x1a1/0x270 drivers/media/v4l2-core/v4l2-event.c:185
  v4l2_ctrl_add_event+0x952/0xc20 drivers/media/v4l2-core/v4l2-ctrls.c:4099
  v4l2_event_subscribe+0xf75/0x1240 drivers/media/v4l2-core/v4l2-event.c:251
  v4l2_ctrl_subscribe_event+0xb6/0x110  
drivers/media/v4l2-core/v4l2-ctrls.c:4156
  v4l_subscribe_event+0x9e/0xc0 drivers/media/v4l2-core/v4l2-ioctl.c:2433
  __video_do_ioctl+0x1975/0x1fc0 drivers/media/v4l2-core/v4l2-ioctl.c:2853
  video_usercopy+0x8ae/0x17d0 drivers/media/v4l2-core/v4l2-ioctl.c:3035
  video_ioctl2+0x9f/0xb0 drivers/media/v4l2-core/v4l2-ioctl.c:3079
  v4l2_ioctl+0x23f/0x270 drivers/media/v4l2-core/v4l2-dev.c:364
  do_vfs_ioctl+0xf36/0x2d30 fs/ioctl.c:46
  ksys_ioctl fs/ioctl.c:713 [inline]
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl+0x1da/0x270 fs/ioctl.c:718
  __x64_sys_ioctl+0x4a/0x70 fs/ioctl.c:718
  do_syscall_64+0xcd/0x110 arch/x86/entry/common.c:291
  entry_SYSCALL_64_after_hwframe+0x63/0xe7

Local variable description: ----ev@v4l2_ctrl_add_event
Variable was created at:
  v4l2_ctrl_add_event+0x6e/0xc20 drivers/media/v4l2-core/v4l2-ctrls.c:4080
  v4l2_event_subscribe+0xf75/0x1240 drivers/media/v4l2-core/v4l2-event.c:251

Bytes 44-71 of 136 are uninitialized
Memory access of size 136 starts at ffff8881bcc903c0
Data copied to user address 0000000020000000
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
