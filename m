Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36175 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbcGaL4X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jul 2016 07:56:23 -0400
Received: by mail-wm0-f65.google.com with SMTP id x83so22171318wma.3
        for <linux-media@vger.kernel.org>; Sun, 31 Jul 2016 04:56:22 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] media: rc: fix deadlock when module ir_lirc_codec is removed
Message-ID: <376e679b-1506-e437-8945-9161dc309150@gmail.com>
Date: Sun, 31 Jul 2016 13:56:15 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When removing module ir_lirc_codec I got this deadlock warning.
Fix this by introducing a separate mutex to protect access
to available_protocols instead of using ir_raw_handler_lock
for this purpose.

======================================================
[ INFO: possible circular locking dependency detected ]
4.7.0-next-20160729 #1 Not tainted
-------------------------------------------------------
rmmod/2542 is trying to acquire lock:
 (&dev->lock){+.+.+.}, at: [<ffffffffa03b1267>]
			ir_raw_handler_unregister+0x77/0xd0 [rc_core]

but task is already holding lock:
 (ir_raw_handler_lock){+.+.+.}, at: [<ffffffffa03b1212>]
			ir_raw_handler_unregister+0x22/0xd0 [rc_core]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (ir_raw_handler_lock){+.+.+.}:
       [<ffffffff810ab1f2>] lock_acquire+0xb2/0x1e0
       [<ffffffff815c087f>] mutex_lock_nested+0x5f/0x360
       [<ffffffffa03b1403>] ir_raw_get_allowed_protocols+0x13/0x30 [rc_core]
       [<ffffffffa03af8ea>] store_protocols+0x2fa/0x480 [rc_core]
       [<ffffffff8143e143>] dev_attr_store+0x13/0x20
       [<ffffffff81213c50>] sysfs_kf_write+0x40/0x50
       [<ffffffff81212f60>] kernfs_fop_write+0x150/0x1e0
       [<ffffffff81197613>] __vfs_write+0x23/0x120
       [<ffffffff81198740>] vfs_write+0xb0/0x190
       [<ffffffff81199a34>] SyS_write+0x44/0xa0
       [<ffffffff815c55a5>] entry_SYSCALL_64_fastpath+0x18/0xa8

-> #0 (&dev->lock){+.+.+.}:
       [<ffffffff810aac8c>] __lock_acquire+0x10fc/0x1270
       [<ffffffff810ab1f2>] lock_acquire+0xb2/0x1e0
       [<ffffffff815c087f>] mutex_lock_nested+0x5f/0x360
       [<ffffffffa03b1267>] ir_raw_handler_unregister+0x77/0xd0 [rc_core]
       [<ffffffffa03c8c05>] ir_lirc_codec_exit+0x10/0x12 [ir_lirc_codec]
       [<ffffffff810e1b88>] SyS_delete_module+0x168/0x220
       [<ffffffff815c55a5>] entry_SYSCALL_64_fastpath+0x18/0xa8

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(ir_raw_handler_lock);
                               lock(&dev->lock);
                               lock(ir_raw_handler_lock);
  lock(&dev->lock);

 *** DEADLOCK ***

1 lock held by rmmod/2542:
 #0:  (ir_raw_handler_lock){+.+.+.}, at: [<ffffffffa03b1212>]
			ir_raw_handler_unregister+0x22/0xd0 [rc_core]

stack backtrace:
CPU: 0 PID: 2542 Comm: rmmod Not tainted 4.7.0-next-20160729 #1
Hardware name: ZOTAC ZBOX-CI321NANO/ZBOX-CI321NANO, BIOS B246P105 06/01/2015
 0000000000000000 ffff88006e607cc0 ffffffff812715f5 ffffffff8232b230
 ffffffff8232b230 ffff88006e607d00 ffffffff810a846e 00000000790107f0
 ffff880079010818 ffff8800790107f0 1efeb9f4f0dd2e6f ffff880079010000
Call Trace:
 [<ffffffff812715f5>] dump_stack+0x68/0x93
 [<ffffffff810a846e>] print_circular_bug+0x1be/0x210
 [<ffffffff810aac8c>] __lock_acquire+0x10fc/0x1270
 [<ffffffff810bcead>] ? debug_lockdep_rcu_enabled+0x1d/0x20
 [<ffffffff810ab1f2>] lock_acquire+0xb2/0x1e0
 [<ffffffffa03b1267>] ? ir_raw_handler_unregister+0x77/0xd0 [rc_core]
 [<ffffffff815c087f>] mutex_lock_nested+0x5f/0x360
 [<ffffffffa03b1267>] ? ir_raw_handler_unregister+0x77/0xd0 [rc_core]
 [<ffffffff810a980e>] ? trace_hardirqs_on_caller+0xee/0x1b0
 [<ffffffffa03b1267>] ir_raw_handler_unregister+0x77/0xd0 [rc_core]
 [<ffffffffa03c8c05>] ir_lirc_codec_exit+0x10/0x12 [ir_lirc_codec]
 [<ffffffff810e1b88>] SyS_delete_module+0x168/0x220
 [<ffffffff815c55a5>] entry_SYSCALL_64_fastpath+0x18/0xa8

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/rc-ir-raw.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 144304c..205ecc6 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -26,6 +26,7 @@ static LIST_HEAD(ir_raw_client_list);
 /* Used to handle IR raw handler extensions */
 static DEFINE_MUTEX(ir_raw_handler_lock);
 static LIST_HEAD(ir_raw_handler_list);
+static DEFINE_MUTEX(available_protocols_lock);
 static u64 available_protocols;
 
 static int ir_raw_event_thread(void *data)
@@ -234,9 +235,9 @@ u64
 ir_raw_get_allowed_protocols(void)
 {
 	u64 protocols;
-	mutex_lock(&ir_raw_handler_lock);
+	mutex_lock(&available_protocols_lock);
 	protocols = available_protocols;
-	mutex_unlock(&ir_raw_handler_lock);
+	mutex_unlock(&available_protocols_lock);
 	return protocols;
 }
 
@@ -330,7 +331,9 @@ int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler)
 	if (ir_raw_handler->raw_register)
 		list_for_each_entry(raw, &ir_raw_client_list, list)
 			ir_raw_handler->raw_register(raw->dev);
+	mutex_lock(&available_protocols_lock);
 	available_protocols |= ir_raw_handler->protocols;
+	mutex_unlock(&available_protocols_lock);
 	mutex_unlock(&ir_raw_handler_lock);
 
 	return 0;
@@ -349,7 +352,9 @@ void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
 		if (ir_raw_handler->raw_unregister)
 			ir_raw_handler->raw_unregister(raw->dev);
 	}
+	mutex_lock(&available_protocols_lock);
 	available_protocols &= ~protocols;
+	mutex_unlock(&available_protocols_lock);
 	mutex_unlock(&ir_raw_handler_lock);
 }
 EXPORT_SYMBOL(ir_raw_handler_unregister);
-- 
2.9.0

