Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:42098 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753046AbaLTMpT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Dec 2014 07:45:19 -0500
In-Reply-To: <20141220124448.GG11285@n2100.arm.linux.org.uk>
References: <20141220124448.GG11285@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/8] [media] em28xx: fix em28xx-input removal
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1Y2JPH-0006UN-SW@rmk-PC.arm.linux.org.uk>
Date: Sat, 20 Dec 2014 12:45:15 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Removing the em28xx-rc module results in the following lockdep splat,
which is caused by trying to call cancel_delayed_work_sync() on an
uninitialised delayed work.  Fix this by ensuring we always initialise
the work.

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 0 PID: 2183 Comm: rmmod Not tainted 3.18.0+ #1464
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
Backtrace:
[<c0012228>] (dump_backtrace) from [<c00123c0>] (show_stack+0x18/0x1c)
 r6:c1419d2c r5:00000000 r4:00000000 r3:00000000
[<c00123a8>] (show_stack) from [<c06e2550>] (dump_stack+0x7c/0x98)
[<c06e24d4>] (dump_stack) from [<c0061c94>] (__lock_acquire+0x16d4/0x1bb0)
 r4:edf19f74 r3:df049380
[<c00605c0>] (__lock_acquire) from [<c00626d4>] (lock_acquire+0xb0/0x124)
 r10:00000000 r9:c003ba90 r8:00000000 r7:00000000 r6:00000000 r5:edf19f74
 r4:00000000
[<c0062624>] (lock_acquire) from [<c003bad4>] (flush_work+0x44/0x264)
 r10:00000000 r9:eaa86000 r8:edf190b0 r7:edf19f74 r6:00000001 r5:edf19f64
 r4:00000000
[<c003ba90>] (flush_work) from [<c003d8f0>] (__cancel_work_timer+0x8c/0x124)
 r7:00000000 r6:00000001 r5:00000000 r4:edf19f64
[<c003d864>] (__cancel_work_timer) from [<c003d99c>] (cancel_delayed_work_sync+0x14/0x18)
 r7:00000000 r6:eccc3600 r5:00000000 r4:edf19000
[<c003d988>] (cancel_delayed_work_sync) from [<bf0b5c10>] (em28xx_ir_fini+0x48/0xd8 [em28xx_rc])
[<bf0b5bc8>] (em28xx_ir_fini [em28xx_rc]) from [<bf08a0a8>] (em28xx_unregister_extension+0x40/0x94 [em28xx])
 r8:c000edc4 r7:00000081 r6:bf092bf4 r5:bf0b6a2c r4:edf19000 r3:bf0b5bc8
[<bf08a068>] (em28xx_unregister_extension [em28xx]) from [<bf0b64dc>] (em28xx_rc_unregister+0x14/0x1c [em28xx_rc])
 r6:00000800 r5:00000000 r4:bf0b6a50 r3:bf0b64c8
[<bf0b64c8>] (em28xx_rc_unregister [em28xx_rc]) from [<c0096710>] (SyS_delete_module+0x11c/0x180)
[<c00965f4>] (SyS_delete_module) from [<c000ec00>] (ret_fast_syscall+0x0/0x48)
 r6:00000001 r5:beb0f813 r4:b8b17d00

Cc: <stable@vger.kernel.org>
Fixes: f52226099382 ("[media] em28xx: extend the support for device buttons")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/media/usb/em28xx/em28xx-input.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index d8dc03aadfbd..ef36c49ef166 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -654,8 +654,6 @@ static void em28xx_init_buttons(struct em28xx *dev)
 	if (dev->num_button_polling_addresses) {
 		memset(dev->button_polling_last_values, 0,
 		       EM28XX_NUM_BUTTON_ADDRESSES_MAX);
-		INIT_DELAYED_WORK(&dev->buttons_query_work,
-				  em28xx_query_buttons);
 		schedule_delayed_work(&dev->buttons_query_work,
 				      msecs_to_jiffies(dev->button_polling_interval));
 	}
@@ -689,6 +687,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 	}
 
 	kref_get(&dev->ref);
+	INIT_DELAYED_WORK(&dev->buttons_query_work, em28xx_query_buttons);
 
 	if (dev->board.buttons)
 		em28xx_init_buttons(dev);
-- 
1.8.3.1

