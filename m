Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:47013 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab2HMM7z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 08:59:55 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Stefan Macher <st_maker-lirc@yahoo.de>,
	linux-media@vger.kernel.org
Subject: [PATCH 10/13] [media] saa7134: simplify timer activation
Date: Mon, 13 Aug 2012 13:59:48 +0100
Message-Id: <1344862791-30352-10-git-send-email-sean@mess.org>
In-Reply-To: <1344862791-30352-1-git-send-email-sean@mess.org>
References: <1344862791-30352-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This simplies the code and resolves a possible race condition between
ir_raw_decode_timer_end() and saa7134_raw_decode_irq().

If the interrupt handler is called after ir_raw_decode_timer_end()
calls ir_raw_event_handle() but before clearing ir->active, then the
timer won't be rearmed.

Compile tested only.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/video/saa7134/saa7134-input.c | 10 +++-------
 drivers/media/video/saa7134/saa7134.h       |  1 -
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 05c6e21..0f78f5e 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -446,11 +446,8 @@ static void saa7134_input_timer(unsigned long data)
 static void ir_raw_decode_timer_end(unsigned long data)
 {
 	struct saa7134_dev *dev = (struct saa7134_dev *)data;
-	struct saa7134_card_ir *ir = dev->remote;
 
 	ir_raw_event_handle(dev->remote->dev);
-
-	ir->active = false;
 }
 
 static int __saa7134_ir_start(void *priv)
@@ -501,7 +498,6 @@ static int __saa7134_ir_start(void *priv)
 	}
 
 	ir->running = true;
-	ir->active = false;
 
 	if (ir->polling) {
 		setup_timer(&ir->timer, saa7134_input_timer,
@@ -532,7 +528,6 @@ static void __saa7134_ir_stop(void *priv)
 	if (ir->polling || ir->raw_decode)
 		del_timer_sync(&ir->timer);
 
-	ir->active = false;
 	ir->running = false;
 
 	return;
@@ -1035,10 +1030,11 @@ static int saa7134_raw_decode_irq(struct saa7134_dev *dev)
 	 * the event. This time is enough for NEC protocol. May need adjustments
 	 * to work with other protocols.
 	 */
-	if (!ir->active) {
+	smp_mb();
+
+	if (!timer_pending(&ir->timer)) {
 		timeout = jiffies + msecs_to_jiffies(15);
 		mod_timer(&ir->timer, timeout);
-		ir->active = true;
 	}
 
 	return 1;
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index 89c8333..c24b651 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -130,7 +130,6 @@ struct saa7134_card_ir {
 	u32			mask_keycode, mask_keydown, mask_keyup;
 
 	bool                    running;
-	bool			active;
 
 	struct timer_list       timer;
 
-- 
1.7.11.2

