Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33596 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbcDDSPb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2016 14:15:31 -0400
Received: by mail-pa0-f42.google.com with SMTP id zm5so149190809pac.0
        for <linux-media@vger.kernel.org>; Mon, 04 Apr 2016 11:15:31 -0700 (PDT)
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Laura Abbott <labbott@redhat.com>
Subject: Incorrect use of blocking ops in lirc_dev_fop_read
Message-ID: <5702AF37.7070100@redhat.com>
Date: Mon, 4 Apr 2016 11:15:19 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

We received a bug report 
(https://bugzilla.redhat.com/show_bug.cgi?id=1323440)

WARNING: CPU: 3 PID: 765 at kernel/sched/core.c:7557 
__might_sleep+0x75/0x80()
do not call blocking ops when !TASK_RUNNING; state=1 set at
[<ffffffffa03b2d31>] lirc_dev_fop_read+0x1e1/0x590 [lirc_dev]
CPU: 3 PID: 765 Comm: lircd Not tainted 4.4.5-300.fc23.x86_64+debug #1
Hardware name:                  /NUC5PPYB, BIOS
PYBSWCEL.86A.0031.2015.0601.1712 06/01/2015
  0000000000000286 00000000d9104369 ffff8801742bfc90 ffffffff8142b543
  ffff8801742bfcd8 ffffffff81c893ec ffff8801742bfcc8 ffffffff810aef42
  ffffffffa03b4428 00000000000002dc 0000000000000000 ffff88007640d380
Call Trace:
  [<ffffffff8142b543>] dump_stack+0x85/0xc2
  [<ffffffff810aef42>] warn_slowpath_common+0x82/0xc0
  [<ffffffff810aefdc>] warn_slowpath_fmt+0x5c/0x80
  [<ffffffff81885186>] ? _raw_spin_unlock_irqrestore+0x36/0x60
  [<ffffffffa03b2d31>] ? lirc_dev_fop_read+0x1e1/0x590 [lirc_dev]
  [<ffffffffa03b2d31>] ? lirc_dev_fop_read+0x1e1/0x590 [lirc_dev]
  [<ffffffff810dc475>] __might_sleep+0x75/0x80
  [<ffffffff8121bcd3>] __might_fault+0x43/0xa0
  [<ffffffffa03b2fe1>] lirc_dev_fop_read+0x491/0x590 [lirc_dev]
  [<ffffffff8110a38d>] ? trace_hardirqs_on+0xd/0x10
  [<ffffffff810e20f0>] ? wake_up_q+0x70/0x70
  [<ffffffff81276dc7>] __vfs_read+0x37/0x100
  [<ffffffff813a0963>] ? security_file_permission+0xa3/0xc0
  [<ffffffff812778d9>] vfs_read+0x89/0x130
  [<ffffffff81278658>] SyS_read+0x58/0xd0
  [<ffffffff81885b72>] entry_SYSCALL_64_fastpath+0x12/0x76

 From looking at the code, it looks like the issue is that copy_to_user
may be called within the block of TASK_INTERRUPTIBLE. I don't know
the code well enough to try and propose a patch to fix this (I broke
code last time I tried to fix something like this)

Thanks,
Laura
