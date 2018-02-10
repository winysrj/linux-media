Return-path: <linux-media-owner@vger.kernel.org>
Received: from parrot.pmhahn.de ([88.198.50.102]:57264 "EHLO parrot.pmhahn.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750832AbeBJMhp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Feb 2018 07:37:45 -0500
Date: Sat, 10 Feb 2018 13:28:15 +0100
From: Philipp Matthias Hahn <pmhahn+video@pmhahn.de>
To: Andrey Utkin <andrey_utkin@fastmail.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH] Potential fix for "[BUG] process stuck when closing
 saa7146 [dvb_ttpci]"
Message-ID: <20180210122815.GA21239@pmhahn.de>
References: <20160911133317.whw3j2pok4sktkeo@pmhahn.de>
 <20160916100028.8856-1-andrey_utkin@fastmail.com>
 <41790808-9100-2999-3d92-921d2076be3e@pmhahn.de>
 <20161016215219.4xob7nrbmrr7uxlj@pmhahn.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161016215219.4xob7nrbmrr7uxlj@pmhahn.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Andrey,

On Sun, Oct 16, 2016 at 11:52:19PM +0200, Philipp Matthias Hahn wrote:
> On Mon, Sep 19, 2016 at 07:08:52AM +0200, Philipp Hahn wrote:
> > Am 16.09.2016 um 12:00 schrieb Andrey Utkin:
> > > Please try this patch. It is purely speculative as I don't have the hardware,
> > > but I hope my approach is right.
> > 
> > Thanks you for the patch; I've built a new kernel but didn't have the
> > time to test it yet; I'll mail you again as soon as I have tested it.
> 
> I tested your patch and during my limites testing I wan't able to
> reproduce the previous problem. Seems you fixed it.
> 
> Tested-by: Philipp Matthias Hahn <pmhahn@pmhahn.de>
> 
> Thanks you again for looking into that issues.

Bad news: I'm running linux-4.15.2 by now and again got a stuck ffmpeg
process after accessing /dev/video0:

| INFO: task read_thread:20579 blocked for more than 120 seconds.
|       Tainted: P           O     4.15.2 #1
| "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
| read_thread     D    0 20579   2949 0x80000000
| Call Trace:
|  ? __schedule+0x646/0x697
|  schedule+0x79/0x94
|  videobuf_waiton+0x11c/0x148 [videobuf_core]
|  ? wait_woken+0x68/0x68
|  saa7146_dma_free+0x34/0x55 [saa7146_vv]
|  buffer_release+0x25/0x33 [saa7146_vv]
|  videobuf_vm_close+0xd6/0x103 [videobuf_dma_sg]
|  remove_vma+0x23/0x49
|  exit_mmap+0xea/0x114
|  mmput+0x45/0xdb
|  do_exit+0x3a0/0x8c1
|  do_group_exit+0x95/0x95
|  get_signal+0x41c/0x447
|  do_signal+0x1e/0x4c2
|  ? __schedule+0x646/0x697
|  ? do_task_dead+0x38/0x3a
|  ? SyS_futex+0x127/0x137
|  exit_to_usermode_loop+0x1f/0x69
|  do_syscall_64+0xe3/0xea
|  entry_SYSCALL_64_after_hwframe+0x21/0x86
| RIP: 0033:0x7f56429927fd
| RSP: 002b:00007f56217b3550 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
| RAX: fffffffffffffe00 RBX: 00007f5608002320 RCX: 00007f56429927fd
| RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f560800234c
| RBP: 0000000000000000 R08: 0000000000000000 R09: 00007f5608002320
| R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
| R13: 00007f56080022f8 R14: 0000000000000000 R15: 00007f560800234c

Your previous patch is applied since v4.10-rc1~71^2^2~34 , so the issue seems
to be not fixed.
The tainting is from the NVidia driver.

Philipp
