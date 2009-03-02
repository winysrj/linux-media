Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:21656 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbZCBTFY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2009 14:05:24 -0500
Date: Mon, 2 Mar 2009 20:05:13 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org
Subject: Re: General protection fault on rmmod cx8800
Message-ID: <20090302200513.7fc3568e@hyperion.delvare>
In-Reply-To: <20090302170349.18c8fd75@hyperion.delvare>
References: <20090215214108.34f31c39@hyperion.delvare>
	<20090302133936.00899692@hyperion.delvare>
	<1236003365.3071.6.camel@palomino.walls.org>
	<20090302170349.18c8fd75@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2 Mar 2009 17:03:49 +0100, Jean Delvare wrote:
> As far as I can see the key difference between bttv-input and
> cx88-input is that bttv-input only uses a simple self-rearming timer,
> while cx88-input uses a timer and a separate workqueue. The timer runs
> the workqueue, which rearms the timer, etc. When you flush the timer,
> the separate workqueue can be still active. I presume this is what
> happens on my system. I guess the reason for the separate workqueue is
> that the processing may take some time and we don't want to hurt the
> system's performance?
> 
> So we need to flush both the event workqueue (with
> flush_scheduled_work) and the separate workqueue (with
> flush_workqueue), at the same time, otherwise the active one may rearm
> the flushed one again. This looks tricky, as obviously we can't flush
> both at the exact same time. Alternatively, if we could get rid of one
> of the queues, we'd have only one that needs flushing, this would be a
> lot easier...

Switching to delayed_work seems to do the trick (note this is a 2.6.28
patch):

---
 drivers/media/video/cx88/cx88-input.c |   26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

--- linux-2.6.28.orig/drivers/media/video/cx88/cx88-input.c	2009-03-02 19:11:24.000000000 +0100
+++ linux-2.6.28/drivers/media/video/cx88/cx88-input.c	2009-03-02 19:49:31.000000000 +0100
@@ -48,8 +48,7 @@ struct cx88_IR {
 
 	/* poll external decoder */
 	int polling;
-	struct work_struct work;
-	struct timer_list timer;
+	struct delayed_work work;
 	u32 gpio_addr;
 	u32 last_gpio;
 	u32 mask_keycode;
@@ -143,27 +142,20 @@ static void cx88_ir_handle_key(struct cx
 	}
 }
 
-static void ir_timer(unsigned long data)
-{
-	struct cx88_IR *ir = (struct cx88_IR *)data;
-
-	schedule_work(&ir->work);
-}
-
 static void cx88_ir_work(struct work_struct *work)
 {
-	struct cx88_IR *ir = container_of(work, struct cx88_IR, work);
+	struct delayed_work *dwork = container_of(work, struct delayed_work, work);
+	struct cx88_IR *ir = container_of(dwork, struct cx88_IR, work);
 
 	cx88_ir_handle_key(ir);
-	mod_timer(&ir->timer, jiffies + msecs_to_jiffies(ir->polling));
+	schedule_delayed_work(dwork, msecs_to_jiffies(ir->polling));
 }
 
 void cx88_ir_start(struct cx88_core *core, struct cx88_IR *ir)
 {
 	if (ir->polling) {
-		setup_timer(&ir->timer, ir_timer, (unsigned long)ir);
-		INIT_WORK(&ir->work, cx88_ir_work);
-		schedule_work(&ir->work);
+		INIT_DELAYED_WORK(&ir->work, cx88_ir_work);
+		schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
 	}
 	if (ir->sampling) {
 		core->pci_irqmask |= PCI_INT_IR_SMPINT;
@@ -179,10 +171,8 @@ void cx88_ir_stop(struct cx88_core *core
 		core->pci_irqmask &= ~PCI_INT_IR_SMPINT;
 	}
 
-	if (ir->polling) {
-		del_timer_sync(&ir->timer);
-		flush_scheduled_work();
-	}
+	if (ir->polling)
+		cancel_delayed_work_sync(&ir->work);
 }
 
 /* ---------------------------------------------------------------------- */

At least I didn't have any general protection fault with this patch
applied. Comments?

Thanks,
-- 
Jean Delvare
