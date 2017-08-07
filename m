Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:37521 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751891AbdHGUVC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Aug 2017 16:21:02 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/6] [media] rc: simplify ir_raw_event_store_edge()
Date: Mon,  7 Aug 2017 21:20:56 +0100
Message-Id: <3bebe168dc8933b48de5e7e39a4e9fa00c27cb7b.1502137028.git.sean@mess.org>
In-Reply-To: <cover.1502137028.git.sean@mess.org>
References: <cover.1502137028.git.sean@mess.org>
In-Reply-To: <cover.1502137028.git.sean@mess.org>
References: <cover.1502137028.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit 12749b198fa4 ("[media] rc: saa7134: add trailing space for
timely decoding"), the workaround of inserting reset events is no
longer needed.

Verified on a HVR-1150.

Fixes: 3f5c4c73322e ("[media] rc: fix ghost keypresses with certain hw")

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/pci/saa7134/saa7134-input.c |  2 +-
 drivers/media/rc/gpio-ir-recv.c           |  6 +-----
 drivers/media/rc/img-ir/img-ir-raw.c      |  4 ++--
 drivers/media/rc/rc-core-priv.h           |  1 -
 drivers/media/rc/rc-ir-raw.c              | 31 +++++--------------------------
 include/media/rc-core.h                   | 10 +---------
 6 files changed, 10 insertions(+), 44 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 4b58c129be92..e7b386ee3ff9 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -1055,7 +1055,7 @@ static int saa7134_raw_decode_irq(struct saa7134_dev *dev)
 	saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
 	saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
 	space = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2) & ir->mask_keydown;
-	ir_raw_event_store_edge(dev->remote->dev, space ? IR_SPACE : IR_PULSE);
+	ir_raw_event_store_edge(dev->remote->dev, !space);
 
 	return 1;
 }
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 512e31593a77..24c7ac8f1b82 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -76,7 +76,6 @@ static irqreturn_t gpio_ir_recv_irq(int irq, void *dev_id)
 	struct gpio_rc_dev *gpio_dev = dev_id;
 	int gval;
 	int rc = 0;
-	enum raw_event_type type = IR_SPACE;
 
 	gval = gpio_get_value(gpio_dev->gpio_nr);
 
@@ -86,10 +85,7 @@ static irqreturn_t gpio_ir_recv_irq(int irq, void *dev_id)
 	if (gpio_dev->active_low)
 		gval = !gval;
 
-	if (gval == 1)
-		type = IR_PULSE;
-
-	rc = ir_raw_event_store_edge(gpio_dev->rcdev, type);
+	rc = ir_raw_event_store_edge(gpio_dev->rcdev, gval == 1);
 	if (rc < 0)
 		goto err_get_value;
 
diff --git a/drivers/media/rc/img-ir/img-ir-raw.c b/drivers/media/rc/img-ir/img-ir-raw.c
index 7f23a863310c..64714efc1145 100644
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
index cae13efc1a88..5e5b10fbc47e 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -41,7 +41,6 @@ struct ir_raw_event_ctrl {
 	/* fifo for the pulse/space durations */
 	DECLARE_KFIFO(kfifo, struct ir_raw_event, MAX_IR_EVENT_SIZE);
 	ktime_t				last_event;	/* when last event occurred */
-	enum raw_event_type		last_type;	/* last event type */
 	struct rc_dev			*dev;		/* pointer to the parent rc_dev */
 	/* edge driver */
 	struct timer_list edge_handle;
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index ef5efd994eef..1761be8c7028 100644
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
+	ev.duration = ktime_sub(now, dev->raw->last_event);
+	ev.pulse = !pulse;
 
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
 
 	/* timer could be set to timeout (125ms by default) */
 	if (!timer_pending(&dev->raw->edge_handle) ||
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index b6c18840d125..5be527ff851d 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -272,14 +272,6 @@ u32 rc_g_keycode_from_table(struct rc_dev *dev, u32 scancode);
  * The Raw interface is specific to InfraRed. It may be a good idea to
  * split it later into a separate header.
  */
-
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
@@ -308,7 +300,7 @@ static inline void init_ir_raw_event(struct ir_raw_event *ev)
 
 void ir_raw_event_handle(struct rc_dev *dev);
 int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev);
-int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type);
+int ir_raw_event_store_edge(struct rc_dev *dev, bool pulse);
 int ir_raw_event_store_with_filter(struct rc_dev *dev,
 				struct ir_raw_event *ev);
 void ir_raw_event_set_idle(struct rc_dev *dev, bool idle);
-- 
2.13.4
