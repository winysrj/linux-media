Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:42817 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab2KRPNN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Nov 2012 10:13:13 -0500
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
To: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 1/7] ir-rx51: Handle signals properly
Date: Sun, 18 Nov 2012 17:13:03 +0200
Message-Id: <1353251589-26143-2-git-send-email-timo.t.kokkonen@iki.fi>
In-Reply-To: <1353251589-26143-1-git-send-email-timo.t.kokkonen@iki.fi>
References: <1353251589-26143-1-git-send-email-timo.t.kokkonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The lirc-dev expects the ir-code to be transmitted when the write call
returns back to the user space. We should not leave TX ongoing no
matter what is the reason we return to the user space. Easiest
solution for that is to simply remove interruptible sleeps.

The first wait_event_interruptible is thus replaced with return -EBUSY
in case there is still ongoing transfer. This should suffice as the
concept of sending multiple codes in parallel does not make sense.

The second wait_event_interruptible call is replaced with
wait_even_timeout with a fixed and safe timeout that should prevent
the process from getting stuck in kernel for too long.

Also, from now on we will force the TX to stop before we return from
write call. If the TX happened to time out for some reason, we should
not leave the HW transmitting anything.

Signed-off-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>
---
 drivers/media/rc/ir-rx51.c | 39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index 546199e..125d4c3 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -74,6 +74,19 @@ static void lirc_rx51_off(struct lirc_rx51 *lirc_rx51)
 			      OMAP_TIMER_TRIGGER_NONE);
 }
 
+static void lirc_rx51_stop_tx(struct lirc_rx51 *lirc_rx51)
+{
+	if (lirc_rx51->wbuf_index < 0)
+		return;
+
+	lirc_rx51_off(lirc_rx51);
+	lirc_rx51->wbuf_index = -1;
+	omap_dm_timer_stop(lirc_rx51->pwm_timer);
+	omap_dm_timer_stop(lirc_rx51->pulse_timer);
+	omap_dm_timer_set_int_enable(lirc_rx51->pulse_timer, 0);
+	wake_up(&lirc_rx51->wqueue);
+}
+
 static int init_timing_params(struct lirc_rx51 *lirc_rx51)
 {
 	u32 load, match;
@@ -163,13 +176,7 @@ static irqreturn_t lirc_rx51_interrupt_handler(int irq, void *ptr)
 
 	return IRQ_HANDLED;
 end:
-	/* Stop TX here */
-	lirc_rx51_off(lirc_rx51);
-	lirc_rx51->wbuf_index = -1;
-	omap_dm_timer_stop(lirc_rx51->pwm_timer);
-	omap_dm_timer_stop(lirc_rx51->pulse_timer);
-	omap_dm_timer_set_int_enable(lirc_rx51->pulse_timer, 0);
-	wake_up_interruptible(&lirc_rx51->wqueue);
+	lirc_rx51_stop_tx(lirc_rx51);
 
 	return IRQ_HANDLED;
 }
@@ -249,8 +256,9 @@ static ssize_t lirc_rx51_write(struct file *file, const char *buf,
 	if ((count > WBUF_LEN) || (count % 2 == 0))
 		return -EINVAL;
 
-	/* Wait any pending transfers to finish */
-	wait_event_interruptible(lirc_rx51->wqueue, lirc_rx51->wbuf_index < 0);
+	/* We can have only one transmit at a time */
+	if (lirc_rx51->wbuf_index >= 0)
+		return -EBUSY;
 
 	if (copy_from_user(lirc_rx51->wbuf, buf, n))
 		return -EFAULT;
@@ -276,9 +284,18 @@ static ssize_t lirc_rx51_write(struct file *file, const char *buf,
 
 	/*
 	 * Don't return back to the userspace until the transfer has
-	 * finished
+	 * finished. However, we wish to not spend any more than 500ms
+	 * in kernel. No IR code TX should ever take that long.
+	 */
+	i = wait_event_timeout(lirc_rx51->wqueue, lirc_rx51->wbuf_index < 0,
+			HZ / 2);
+
+	/*
+	 * Ensure transmitting has really stopped, even if the timers
+	 * went mad or something else happened that caused it still
+	 * sending out something.
 	 */
-	wait_event_interruptible(lirc_rx51->wqueue, lirc_rx51->wbuf_index < 0);
+	lirc_rx51_stop_tx(lirc_rx51);
 
 	/* We can sleep again */
 	lirc_rx51->pdata->set_max_mpu_wakeup_lat(lirc_rx51->dev, -1);
-- 
1.8.0

