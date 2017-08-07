Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:49185 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751704AbdHGUVB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Aug 2017 16:21:01 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/6] [media] rc-core: improve ir_raw_store_edge() handling
Date: Mon,  7 Aug 2017 21:20:54 +0100
Message-Id: <e342b90298f42087d9b0dabf5263d25aa542ca96.1502137028.git.sean@mess.org>
In-Reply-To: <cover.1502137028.git.sean@mess.org>
References: <cover.1502137028.git.sean@mess.org>
In-Reply-To: <cover.1502137028.git.sean@mess.org>
References: <cover.1502137028.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The gpio-ir-recv driver does many spurious wakeups (once per edge);
the saa7134 driver has special handling to only wakeup 15ms after the
first edge. Make this part of rc-core so gpio-ir-recv also benefits from
this (so a rc-5 keypress now causes 3 wakeups rather than 24).

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/pci/saa7134/saa7134-input.c | 26 +-------------------------
 drivers/media/rc/rc-core-priv.h           |  2 ++
 drivers/media/rc/rc-ir-raw.c              | 15 +++++++++++++++
 3 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index ba1fc77a6f7b..81e27ddcf6df 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -452,13 +452,6 @@ static void saa7134_input_timer(unsigned long data)
 	mod_timer(&ir->timer, jiffies + msecs_to_jiffies(ir->polling));
 }
 
-static void ir_raw_decode_timer_end(unsigned long data)
-{
-	struct saa7134_dev *dev = (struct saa7134_dev *)data;
-
-	ir_raw_event_handle(dev->remote->dev);
-}
-
 static int __saa7134_ir_start(void *priv)
 {
 	struct saa7134_dev *dev = priv;
@@ -514,10 +507,6 @@ static int __saa7134_ir_start(void *priv)
 			    (unsigned long)dev);
 		ir->timer.expires = jiffies + HZ;
 		add_timer(&ir->timer);
-	} else if (ir->raw_decode) {
-		/* set timer_end for code completion */
-		setup_timer(&ir->timer, ir_raw_decode_timer_end,
-			    (unsigned long)dev);
 	}
 
 	return 0;
@@ -535,7 +524,7 @@ static void __saa7134_ir_stop(void *priv)
 	if (!ir->running)
 		return;
 
-	if (ir->polling || ir->raw_decode)
+	if (ir->polling)
 		del_timer_sync(&ir->timer);
 
 	ir->running = false;
@@ -1057,7 +1046,6 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 static int saa7134_raw_decode_irq(struct saa7134_dev *dev)
 {
 	struct saa7134_card_ir *ir = dev->remote;
-	unsigned long timeout;
 	int space;
 
 	/* Generate initial event */
@@ -1066,17 +1054,5 @@ static int saa7134_raw_decode_irq(struct saa7134_dev *dev)
 	space = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2) & ir->mask_keydown;
 	ir_raw_event_store_edge(dev->remote->dev, space ? IR_SPACE : IR_PULSE);
 
-	/*
-	 * Wait 15 ms from the start of the first IR event before processing
-	 * the event. This time is enough for NEC protocol. May need adjustments
-	 * to work with other protocols.
-	 */
-	smp_mb();
-
-	if (!timer_pending(&ir->timer)) {
-		timeout = jiffies + msecs_to_jiffies(15);
-		mod_timer(&ir->timer, timeout);
-	}
-
 	return 1;
 }
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index b3e7cac2c3ee..cae13efc1a88 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -43,6 +43,8 @@ struct ir_raw_event_ctrl {
 	ktime_t				last_event;	/* when last event occurred */
 	enum raw_event_type		last_type;	/* last event type */
 	struct rc_dev			*dev;		/* pointer to the parent rc_dev */
+	/* edge driver */
+	struct timer_list edge_handle;
 
 	/* raw decoder state follows */
 	struct ir_raw_event prev_ev;
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index b6d256f03847..07a694298119 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -133,6 +133,11 @@ int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type)
 
 	dev->raw->last_event = now;
 	dev->raw->last_type = type;
+
+	if (!timer_pending(&dev->raw->edge_handle))
+		mod_timer(&dev->raw->edge_handle,
+			  jiffies + msecs_to_jiffies(15));
+
 	return rc;
 }
 EXPORT_SYMBOL_GPL(ir_raw_event_store_edge);
@@ -483,6 +488,13 @@ int ir_raw_encode_scancode(enum rc_type protocol, u32 scancode,
 }
 EXPORT_SYMBOL(ir_raw_encode_scancode);
 
+static void edge_handle(unsigned long arg)
+{
+	struct rc_dev *dev = (struct rc_dev *)arg;
+
+	ir_raw_event_handle(dev);
+}
+
 /*
  * Used to (un)register raw event clients
  */
@@ -504,6 +516,8 @@ int ir_raw_event_prepare(struct rc_dev *dev)
 
 	dev->raw->dev = dev;
 	dev->change_protocol = change_protocol;
+	setup_timer(&dev->raw->edge_handle, edge_handle,
+		    (unsigned long)dev);
 	INIT_KFIFO(dev->raw->kfifo);
 
 	return 0;
@@ -555,6 +569,7 @@ void ir_raw_event_unregister(struct rc_dev *dev)
 		return;
 
 	kthread_stop(dev->raw->thread);
+	del_timer_sync(&dev->raw->edge_handle);
 
 	mutex_lock(&ir_raw_handler_lock);
 	list_del(&dev->raw->list);
-- 
2.13.4
