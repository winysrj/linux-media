Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:56589 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752302AbeDOJyj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Apr 2018 05:54:39 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Warren Sturm <warren.sturm@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Andy Walls <awalls.cx18@gmail.com>, stable@vger.kernel.org,
        #@mess.org
Subject: [PATCH stable v4.15 3/3] media: staging: lirc_zilog: incorrect reference counting
Date: Sun, 15 Apr 2018 10:54:22 +0100
Message-Id: <c67bdbce646f1d2aba24d62c365b99f43c3cd077.1523785117.git.sean@mess.org>
In-Reply-To: <cover.1523785117.git.sean@mess.org>
References: <cover.1523785117.git.sean@mess.org>
In-Reply-To: <cover.1523785117.git.sean@mess.org>
References: <cover.1523785117.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Whenever poll is called, the reference count is increased but never
decreased. This means that on rmmod, the lirc_thread is not stopped,
and will trample over freed memory.

Zilog/Hauppauge IR driver unloaded
BUG: unable to handle kernel paging request at ffffffffc17ba640
Oops: 0010 [#1] SMP
CPU: 1 PID: 667 Comm: zilog-rx-i2c-1 Tainted: P         C OE   4.13.16-302.fc27.x86_64 #1
Hardware name: Gigabyte Technology Co., Ltd. GA-MA790FXT-UD5P/GA-MA790FXT-UD5P, BIOS F6 08/06/2009
task: ffff964eb452ca00 task.stack: ffffb254414dc000
RIP: 0010:0xffffffffc17ba640
RSP: 0018:ffffb254414dfe78 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff964ec1b35890 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000246 RDI: 0000000000000246
RBP: ffffb254414dff00 R08: 000000000000036e R09: ffff964ecfc8dfd0
R10: ffffb254414dfe78 R11: 00000000000f4240 R12: ffff964ec2bf28a0
R13: ffff964ec1b358a8 R14: ffff964ec1b358d0 R15: ffff964ec1b35800
FS:  0000000000000000(0000) GS:ffff964ecfc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffc17ba640 CR3: 000000023058c000 CR4: 00000000000006e0
Call Trace:
 kthread+0x125/0x140
 ? kthread_park+0x60/0x60
 ? do_syscall_64+0x67/0x140
 ret_from_fork+0x25/0x30
Code:  Bad RIP value.
RIP: 0xffffffffc17ba640 RSP: ffffb254414dfe78
CR2: ffffffffc17ba640

Note that zilog-rx-i2c-1 should have exited by now, but hasn't due to
the missing put in poll().

This code has been replaced completely in kernel v4.16 by a new driver,
see commit acaa34bf06e9 ("media: rc: implement zilog transmitter"), and
commit f95367a7b758 ("media: staging: remove lirc_zilog driver").

Cc: stable@vger.kernel.org # v4.15- (all up to and including v4.15)
Reported-by: Warren Sturm <warren.sturm@gmail.com>
Tested-by: Warren Sturm <warren.sturm@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/staging/media/lirc/lirc_zilog.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index e8d6c1abc6d8..022720210f70 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -1227,6 +1227,7 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 
 	dev_dbg(ir->dev, "%s result = %s\n", __func__,
 		ret ? "POLLIN|POLLRDNORM" : "none");
+	put_ir_rx(rx, false);
 	return ret;
 }
 
-- 
2.14.3
