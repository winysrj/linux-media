Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:36615 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaLAMzX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 07:55:23 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Sifan Naeem <sifan.naeem@imgtec.com>,
	James Hogan <james.hogan@imgtec.com>, <stable@vger.kernel.org>,
	<linux-media@vger.kernel.org>
Subject: [REVIEW PATCH 2/2] img-ir/hw: Fix potential deadlock stopping timer
Date: Mon, 1 Dec 2014 12:55:10 +0000
Message-ID: <1417438510-18977-3-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1417438510-18977-1-git-send-email-james.hogan@imgtec.com>
References: <1417438510-18977-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The end timer is used for switching back from repeat code timings when
no repeat codes have been received for a certain amount of time. When
the protocol is changed, the end timer is deleted synchronously with
del_timer_sync(), however this takes place while holding the main spin
lock, and the timer handler also needs to acquire the spin lock.

This opens the possibility of a deadlock on an SMP system if the
protocol is changed just as the repeat timer is expiring. One CPU could
end up in img_ir_set_decoder() holding the lock and waiting for the end
timer to complete, while the other CPU is stuck in the timer handler
spinning on the lock held by the first CPU.

Lockdep also spots a possible lock inversion in the same code, since
img_ir_set_decoder() acquires the img-ir lock before the timer lock, but
the timer handler will try and acquire them the other way around:

=========================================================
[ INFO: possible irq lock inversion dependency detected ]
3.18.0-rc5+ #957 Not tainted
---------------------------------------------------------
swapper/0/0 just changed the state of lock:
 (((&hw->end_timer))){+.-...}, at: [<4006ae5c>] _call_timer_fn+0x0/0xfc
but this lock was taken by another, HARDIRQ-safe lock in the past:
 (&(&priv->lock)->rlock#2){-.....}

and interrupts could create inverse lock ordering between them.

other info that might help us debug this:
 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(((&hw->end_timer)));
                               local_irq_disable();
                               lock(&(&priv->lock)->rlock#2);
                               lock(((&hw->end_timer)));
  <Interrupt>
    lock(&(&priv->lock)->rlock#2);

 *** DEADLOCK ***

This is fixed by releasing the main spin lock while performing the
del_timer_sync() call. The timer is prevented from restarting before the
lock is reacquired by a new "stopping" flag which img_ir_handle_data()
checks before updating the timer.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Sifan Naeem <sifan.naeem@imgtec.com>
Cc: <stable@vger.kernel.org> # v3.15+
Cc: linux-media@vger.kernel.org
---
This patch depends on "img-ir/hw: Always read data to clear buffer" from
my recent img-ir patchset to avoid a conflict.
---
 drivers/media/rc/img-ir/img-ir-hw.c | 22 +++++++++++++++++++---
 drivers/media/rc/img-ir/img-ir-hw.h |  3 +++
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index 1566337c1059..76eaa323ae51 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -530,6 +530,22 @@ static void img_ir_set_decoder(struct img_ir_priv *priv,
 	u32 ir_status, irq_en;
 	spin_lock_irq(&priv->lock);
 
+	/*
+	 * First record that the protocol is being stopped so that the end timer
+	 * isn't restarted while we're trying to stop it.
+	 */
+	hw->stopping = true;
+
+	/*
+	 * Release the lock to stop the end timer, since the end timer handler
+	 * acquires the lock and we don't want to deadlock waiting for it.
+	 */
+	spin_unlock_irq(&priv->lock);
+	del_timer_sync(&hw->end_timer);
+	spin_lock_irq(&priv->lock);
+
+	hw->stopping = false;
+
 	/* switch off and disable interrupts */
 	img_ir_write(priv, IMG_IR_CONTROL, 0);
 	irq_en = img_ir_read(priv, IMG_IR_IRQ_ENABLE);
@@ -547,8 +563,7 @@ static void img_ir_set_decoder(struct img_ir_priv *priv,
 	img_ir_read(priv, IMG_IR_DATA_LW);
 	img_ir_read(priv, IMG_IR_DATA_UP);
 
-	/* stop the end timer and switch back to normal mode */
-	del_timer_sync(&hw->end_timer);
+	/* switch back to normal mode */
 	hw->mode = IMG_IR_M_NORMAL;
 
 	/* clear the wakeup scancode filter */
@@ -825,7 +840,8 @@ static void img_ir_handle_data(struct img_ir_priv *priv, u32 len, u64 raw)
 	}
 
 
-	if (dec->repeat) {
+	/* we mustn't update the end timer while trying to stop it */
+	if (dec->repeat && !hw->stopping) {
 		unsigned long interval;
 
 		img_ir_begin_repeat(priv);
diff --git a/drivers/media/rc/img-ir/img-ir-hw.h b/drivers/media/rc/img-ir/img-ir-hw.h
index a8c6a8d40206..5c2b216c5fe3 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.h
+++ b/drivers/media/rc/img-ir/img-ir-hw.h
@@ -211,6 +211,8 @@ enum img_ir_mode {
  * @flags:		IMG_IR_F_*.
  * @filters:		HW filters (derived from scancode filters).
  * @mode:		Current decode mode.
+ * @stopping:		Indicates that decoder is being taken down and timers
+ *			should not be restarted.
  * @suspend_irqen:	Saved IRQ enable mask over suspend.
  */
 struct img_ir_priv_hw {
@@ -226,6 +228,7 @@ struct img_ir_priv_hw {
 	struct img_ir_filter		filters[RC_FILTER_MAX];
 
 	enum img_ir_mode		mode;
+	bool				stopping;
 	u32				suspend_irqen;
 };
 
-- 
2.0.4

