Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:33401 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750791AbdE1Qt3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 12:49:29 -0400
Date: Sun, 28 May 2017 17:49:27 +0100
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: [PATCH] [media] rc-core: simplify ir_raw_event_store_edge()
Message-ID: <20170528164927.GC18977@gofer.mess.org>
References: <149365487447.13489.15793446874818182829.stgit@zeus.hardeman.nu>
 <149365501711.13489.17027324920634077369.stgit@zeus.hardeman.nu>
 <20170523092026.GA30040@gofer.mess.org>
 <20170528083150.l3qs5jmkl4smm3vk@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170528083150.l3qs5jmkl4smm3vk@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to called ir_raw_event_reset() either after a long
space or on startup. Many rc drivers never do this.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/pci/saa7134/saa7134-input.c |  2 +-
 drivers/media/rc/gpio-ir-recv.c           |  6 +++---
 drivers/media/rc/img-ir/img-ir-raw.c      |  4 ++--
 drivers/media/rc/rc-core-priv.h           |  1 -
 drivers/media/rc/rc-ir-raw.c              | 31 +++++--------------------------
 include/media/rc-core.h                   |  9 +--------
 6 files changed, 12 insertions(+), 41 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 78849c1..8784bc8 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -1064,7 +1064,7 @@ static int saa7134_raw_decode_irq(struct saa7134_dev *dev)
 	saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
 	saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
 	space = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2) & ir->mask_keydown;
-	ir_raw_event_store_edge(dev->remote->dev, space ? IR_SPACE : IR_PULSE);
+	ir_raw_event_store_edge(dev->remote->dev, !space);
 
 	/*
 	 * Wait 15 ms from the start of the first IR event before processing
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index b4f773b..09889d0 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -77,7 +77,7 @@ static irqreturn_t gpio_ir_recv_irq(int irq, void *dev_id)
 	struct gpio_rc_dev *gpio_dev = dev_id;
 	int gval;
 	int rc = 0;
-	enum raw_event_type type = IR_SPACE;
+	bool pulse = false;
 
 	gval = gpio_get_value(gpio_dev->gpio_nr);
 
@@ -88,9 +88,9 @@ static irqreturn_t gpio_ir_recv_irq(int irq, void *dev_id)
 		gval = !gval;
 
 	if (gval == 1)
-		type = IR_PULSE;
+		pulse = true;
 
-	rc = ir_raw_event_store_edge(gpio_dev->rcdev, type);
+	rc = ir_raw_event_store_edge(gpio_dev->rcdev, pulse);
 	if (rc < 0)
 		goto err_get_value;
 
diff --git a/drivers/media/rc/img-ir/img-ir-raw.c b/drivers/media/rc/img-ir/img-ir-raw.c
index 8d2f8e2..ddb7fb4 100644
--- a/drivers/media/rc/img-ir/img-ir-raw.c
+++ b/drivers/media/rc/img-ir/img-ir-raw.c
@@ -40,9 +40,9 @@ static void img_ir_refresh_raw(struct img_ir_priv *priv, u32 irq_status)
 
 	/* report the edge to the IR raw decoders */
 	if (ir_status) /* low */
-		ir_raw_event_store_edge(rc_dev, IR_SPACE);
+		ir_raw_event_store_edge(rc_dev, false);
 	else /* high */
-		ir_raw_event_store_edge(rc_dev, IR_PULSE);
+		ir_raw_event_store_edge(rc_dev, true);
 	ir_raw_event_handle(rc_dev);
 }
 
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 0455b27..d31ad6a 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -41,7 +41,6 @@ struct ir_raw_event_ctrl {
 	/* fifo for the pulse/space durations */
 	DECLARE_KFIFO(kfifo, struct ir_raw_event, MAX_IR_EVENT_SIZE);
 	ktime_t				last_event;	/* when last event occurred */
-	enum raw_event_type		last_type;	/* last event type */
 	struct rc_dev			*dev;		/* pointer to the parent rc_dev */
 
 	/* raw decoder state follows */
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 90f66dc..16ef236 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -88,7 +88,7 @@ EXPORT_SYMBOL_GPL(ir_raw_event_store);
 /**
  * ir_raw_event_store_edge() - notify raw ir decoders of the start of a pulse/space
  * @dev:	the struct rc_dev device descriptor
- * @type:	the type of the event that has occurred
+ * @pulse:	true for pulse, false for space
  *
  * This routine (which may be called from an interrupt context) is used to
  * store the beginning of an ir pulse or space (or the start/end of ir
@@ -96,43 +96,22 @@ EXPORT_SYMBOL_GPL(ir_raw_event_store);
  * hardware which does not provide durations directly but only interrupts
  * (or similar events) on state change.
  */
-int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type)
+int ir_raw_event_store_edge(struct rc_dev *dev, bool pulse)
 {
 	ktime_t			now;
-	s64			delta; /* ns */
 	DEFINE_IR_RAW_EVENT(ev);
 	int			rc = 0;
-	int			delay;
 
 	if (!dev->raw)
 		return -EINVAL;
 
 	now = ktime_get();
-	delta = ktime_to_ns(ktime_sub(now, dev->raw->last_event));
-	delay = MS_TO_NS(dev->input_dev->rep[REP_DELAY]);
+	ev.duration = ktime_to_ns(ktime_sub(now, dev->raw->last_event));
+	ev.pulse = pulse;
 
-	/* Check for a long duration since last event or if we're
-	 * being called for the first time, note that delta can't
-	 * possibly be negative.
-	 */
-	if (delta > delay || !dev->raw->last_type)
-		type |= IR_START_EVENT;
-	else
-		ev.duration = delta;
-
-	if (type & IR_START_EVENT)
-		ir_raw_event_reset(dev);
-	else if (dev->raw->last_type & IR_SPACE) {
-		ev.pulse = false;
-		rc = ir_raw_event_store(dev, &ev);
-	} else if (dev->raw->last_type & IR_PULSE) {
-		ev.pulse = true;
-		rc = ir_raw_event_store(dev, &ev);
-	} else
-		return 0;
+	rc = ir_raw_event_store(dev, &ev);
 
 	dev->raw->last_event = now;
-	dev->raw->last_type = type;
 	return rc;
 }
 EXPORT_SYMBOL_GPL(ir_raw_event_store_edge);
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 73ddd721..b1466e1 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -275,13 +275,6 @@ u32 rc_g_keycode_from_table(struct rc_dev *dev, u32 scancode);
  * split it later into a separate header.
  */
 
-enum raw_event_type {
-	IR_SPACE        = (1 << 0),
-	IR_PULSE        = (1 << 1),
-	IR_START_EVENT  = (1 << 2),
-	IR_STOP_EVENT   = (1 << 3),
-};
-
 struct ir_raw_event {
 	union {
 		u32             duration;
@@ -310,7 +303,7 @@ static inline void init_ir_raw_event(struct ir_raw_event *ev)
 
 void ir_raw_event_handle(struct rc_dev *dev);
 int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev);
-int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type);
+int ir_raw_event_store_edge(struct rc_dev *dev, bool pulse);
 int ir_raw_event_store_with_filter(struct rc_dev *dev,
 				struct ir_raw_event *ev);
 void ir_raw_event_set_idle(struct rc_dev *dev, bool idle);
-- 
2.9.4
