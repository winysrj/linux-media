Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f72.google.com ([209.85.166.72]:36051 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731508AbeKNAKZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 19:10:25 -0500
Received: by mail-io1-f72.google.com with SMTP id w5-v6so13066640ioj.3
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2018 06:12:05 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 13 Nov 2018 06:12:04 -0800
In-Reply-To: <000000000000a91c14057a28a4ae@google.com>
Message-ID: <000000000000f4d1fb057a8c6621@google.com>
Subject: Re: KASAN: global-out-of-bounds Read in tpg_print_str_4
From: syzbot <syzbot+ccf0a61ed12f2a7313ee@syzkaller.appspotmail.com>
To: bwinther@cisco.com, hverkuil@xs4all.nl, keescook@chromium.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        mchehab@kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

syzbot has found a reproducer for the following crash on:

HEAD commit:    ccda4af0f4b9 Linux 4.20-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1779cb0b400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4a0a89f12ca9b0f5
dashboard link: https://syzkaller.appspot.com/bug?extid=ccf0a61ed12f2a7313ee
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=126f0ed5400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15ed6c25400000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ccf0a61ed12f2a7313ee@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: global-out-of-bounds in tpg_print_str_4+0xbc9/0xd70  
drivers/media/common/v4l2-tpg/v4l2-tpg-core.c:1820
Read of size 1 at addr ffffffff88632850 by task vivid-000-vid-c/5989

CPU: 0 PID: 5989 Comm: vivid-000-vid-c Not tainted 4.20.0-rc2+ #236
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x244/0x39d lib/dump_stack.c:113
  print_address_description.cold.7+0x58/0x1ff mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.8+0x242/0x309 mm/kasan/report.c:412
  __asan_report_load1_noabort+0x14/0x20 mm/kasan/report.c:430
  tpg_print_str_4+0xbc9/0xd70  
drivers/media/common/v4l2-tpg/v4l2-tpg-core.c:1820
  tpg_gen_text+0x4ba/0x540 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c:1874
  vivid_fillbuff+0x3ff7/0x68e0  
drivers/media/platform/vivid/vivid-kthread-cap.c:532
  vivid_thread_vid_cap_tick  
drivers/media/platform/vivid/vivid-kthread-cap.c:709 [inline]
  vivid_thread_vid_cap+0xbc1/0x2650  
drivers/media/platform/vivid/vivid-kthread-cap.c:813
  kthread+0x35a/0x440 kernel/kthread.c:246
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

The buggy address belongs to the variable:
  font_vga_8x16+0x50/0x60

Memory state around the buggy address:
  ffffffff88632700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffffffff88632780: 00 00 00 00 fa fa fa fa 00 fa fa fa fa fa fa fa
> ffffffff88632800: 00 00 00 00 00 fa fa fa fa fa fa fa 00 00 00 00
                                                  ^
  ffffffff88632880: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffffffff88632900: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================
