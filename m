Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:54371 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751587AbeBROwI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Feb 2018 09:52:08 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] media: rc: fix race condition in ir_raw_event_store_edge() handling
Date: Sun, 18 Feb 2018 14:52:06 +0000
Message-Id: <20180218145206.20800-2-sean@mess.org>
In-Reply-To: <20180218145206.20800-1-sean@mess.org>
References: <20180218145206.20800-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a possible race condition between the IR timeout being generated
from the timer, and new IR arriving. This could result in the timeout
being added to the kfifo after new IR arrives. On top of that, there is
concurrent write access to the kfifo from ir_raw_event_store_edge() and
the timer.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-core-priv.h |  5 +++--
 drivers/media/rc/rc-ir-raw.c    | 24 +++++++++++++++++++++---
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index d09a06e1c17f..5e80b4273e2d 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -50,8 +50,9 @@ struct ir_raw_event_ctrl {
 	DECLARE_KFIFO(kfifo, struct ir_raw_event, MAX_IR_EVENT_SIZE);
 	ktime_t				last_event;	/* when last event occurred */
 	struct rc_dev			*dev;		/* pointer to the parent rc_dev */
-	/* edge driver */
-	struct timer_list edge_handle;
+	/* handle delayed ir_raw_event_store_edge processing */
+	spinlock_t			edge_spinlock;
+	struct timer_list		edge_handle;
 
 	/* raw decoder state follows */
 	struct ir_raw_event prev_ev;
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 2790a0d268fd..984bb82851f9 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -101,6 +101,7 @@ int ir_raw_event_store_edge(struct rc_dev *dev, bool pulse)
 	ev.duration = ktime_to_ns(ktime_sub(now, dev->raw->last_event));
 	ev.pulse = !pulse;
 
+	spin_lock(&dev->raw->edge_spinlock);
 	rc = ir_raw_event_store(dev, &ev);
 
 	dev->raw->last_event = now;
@@ -112,6 +113,7 @@ int ir_raw_event_store_edge(struct rc_dev *dev, bool pulse)
 		mod_timer(&dev->raw->edge_handle,
 			  jiffies + msecs_to_jiffies(15));
 	}
+	spin_unlock(&dev->raw->edge_spinlock);
 
 	return rc;
 }
@@ -462,12 +464,26 @@ int ir_raw_encode_scancode(enum rc_proto protocol, u32 scancode,
 }
 EXPORT_SYMBOL(ir_raw_encode_scancode);
 
-static void edge_handle(struct timer_list *t)
+/**
+ * ir_raw_edge_handle() - Handle ir_raw_event_store_edge() processing
+ *
+ * @t:		timer_list
+ *
+ * This callback is armed by ir_raw_event_store_edge(). It does two things:
+ * first of all, rather than calling ir_raw_event_handle() for each
+ * edge and waking up the rc thread, 15 ms after the first edge
+ * ir_raw_event_handle() is called. Secondly, generate a timeout event
+ * no more IR is received after the rc_dev timeout.
+ */
+static void ir_raw_edge_handle(struct timer_list *t)
 {
 	struct ir_raw_event_ctrl *raw = from_timer(raw, t, edge_handle);
 	struct rc_dev *dev = raw->dev;
-	ktime_t interval = ktime_sub(ktime_get(), dev->raw->last_event);
+	unsigned long flags;
+	ktime_t interval;
 
+	spin_lock_irqsave(&dev->raw->edge_spinlock, flags);
+	interval = ktime_sub(ktime_get(), dev->raw->last_event);
 	if (ktime_to_ns(interval) >= dev->timeout) {
 		DEFINE_IR_RAW_EVENT(ev);
 
@@ -480,6 +496,7 @@ static void edge_handle(struct timer_list *t)
 			  jiffies + nsecs_to_jiffies(dev->timeout -
 						     ktime_to_ns(interval)));
 	}
+	spin_unlock_irqrestore(&dev->raw->edge_spinlock, flags);
 
 	ir_raw_event_handle(dev);
 }
@@ -528,7 +545,8 @@ int ir_raw_event_prepare(struct rc_dev *dev)
 
 	dev->raw->dev = dev;
 	dev->change_protocol = change_protocol;
-	timer_setup(&dev->raw->edge_handle, edge_handle, 0);
+	spin_lock_init(&dev->raw->edge_spinlock);
+	timer_setup(&dev->raw->edge_handle, ir_raw_edge_handle, 0);
 	INIT_KFIFO(dev->raw->kfifo);
 
 	return 0;
-- 
2.14.3
