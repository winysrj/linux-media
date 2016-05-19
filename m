Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34268 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbcESTCq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2016 15:02:46 -0400
Received: by mail-wm0-f67.google.com with SMTP id n129so23531642wmn.1
        for <linux-media@vger.kernel.org>; Thu, 19 May 2016 12:02:45 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 1/2] media: rc: make fifo size for raw events configurable
 via rc_dev
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <67474fa8-4f58-75e4-f5b2-1b07c6b21009@gmail.com>
Date: Thu, 19 May 2016 21:01:56 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently the fifo size is 512 elements. After a recent patch the size
of struct ir_raw_event is down to 8 bytes, so the fifo still consumes
4KB. In most cases a much smaller fifo is sufficient, e.g. nuvoton-cir
triggers event processing after 24 events latest.

This patch introduces an element raw_fifo_size to struct rc_dev to
allow configuring the fifo size. If not set the current default
MAX_IR_EVENT_SIZE is used.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
v2:
- access dev->raw_fifo_size only after check for !dev
---
 drivers/media/rc/rc-core-priv.h |  2 +-
 drivers/media/rc/rc-ir-raw.c    | 14 ++++++++++++--
 include/media/rc-core.h         |  2 ++
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 585d5e5..ae6f81e 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -39,7 +39,7 @@ struct ir_raw_event_ctrl {
 	struct task_struct		*thread;
 	spinlock_t			lock;
 	/* fifo for the pulse/space durations */
-	DECLARE_KFIFO(kfifo, struct ir_raw_event, MAX_IR_EVENT_SIZE);
+	DECLARE_KFIFO_PTR(kfifo, struct ir_raw_event);
 	ktime_t				last_event;	/* when last event occurred */
 	enum raw_event_type		last_type;	/* last event type */
 	struct rc_dev			*dev;		/* pointer to the parent rc_dev */
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 144304c..f9b7734 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -261,17 +261,24 @@ int ir_raw_event_register(struct rc_dev *dev)
 {
 	int rc;
 	struct ir_raw_handler *handler;
+	unsigned fifo_size = MAX_IR_EVENT_SIZE;
 
 	if (!dev)
 		return -EINVAL;
 
+	if (dev->raw_fifo_size)
+		fifo_size = dev->raw_fifo_size;
+
 	dev->raw = kzalloc(sizeof(*dev->raw), GFP_KERNEL);
 	if (!dev->raw)
 		return -ENOMEM;
 
 	dev->raw->dev = dev;
 	dev->change_protocol = change_protocol;
-	INIT_KFIFO(dev->raw->kfifo);
+
+	rc = kfifo_alloc(&dev->raw->kfifo, fifo_size, GFP_KERNEL);
+	if (rc)
+		goto out;
 
 	spin_lock_init(&dev->raw->lock);
 	dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
@@ -279,7 +286,7 @@ int ir_raw_event_register(struct rc_dev *dev)
 
 	if (IS_ERR(dev->raw->thread)) {
 		rc = PTR_ERR(dev->raw->thread);
-		goto out;
+		goto out_kfifo;
 	}
 
 	mutex_lock(&ir_raw_handler_lock);
@@ -291,6 +298,8 @@ int ir_raw_event_register(struct rc_dev *dev)
 
 	return 0;
 
+out_kfifo:
+	kfifo_free(&dev->raw->kfifo);
 out:
 	kfree(dev->raw);
 	dev->raw = NULL;
@@ -313,6 +322,7 @@ void ir_raw_event_unregister(struct rc_dev *dev)
 			handler->raw_unregister(dev);
 	mutex_unlock(&ir_raw_handler_lock);
 
+	kfifo_free(&dev->raw->kfifo);
 	kfree(dev->raw);
 	dev->raw = NULL;
 }
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index f6f55b7..07e096b 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -72,6 +72,7 @@ enum rc_filter_type {
  *	anyone can call show_protocols or store_protocols
  * @minor: unique minor remote control device number
  * @raw: additional data for raw pulse/space devices
+ * @raw_fifo_size: size of fifo for raw events
  * @input_dev: the input child device used to communicate events to userspace
  * @driver_type: specifies if protocol decoding is done in hardware or software
  * @idle: used to keep track of RX state
@@ -133,6 +134,7 @@ struct rc_dev {
 	struct mutex			lock;
 	unsigned int			minor;
 	struct ir_raw_event_ctrl	*raw;
+	unsigned			raw_fifo_size;
 	struct input_dev		*input_dev;
 	enum rc_driver_type		driver_type;
 	bool				idle;
-- 
2.8.2


