Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:46083 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032324AbdAFMtQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Jan 2017 07:49:16 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 3/9] [media] lirc: use plain kfifo rather than lirc_buffer
Date: Fri,  6 Jan 2017 12:49:06 +0000
Message-Id: <7d93613edfd25752a3a958cea0b19c8c90e0a47c.1483706563.git.sean@mess.org>
In-Reply-To: <cover.1483706563.git.sean@mess.org>
References: <cover.1483706563.git.sean@mess.org>
In-Reply-To: <cover.1483706563.git.sean@mess.org>
References: <cover.1483706563.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since a lirc char device can only be opened once, there can only be one
reader. By using a plain kfifo we don't need a spinlock and we can use
kfifo_to_user. The code is much simplified.

Unfortunately we cannot eliminate lirc_buffer from the tree yet, as there
are still some staging lirc drivers which use it.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c | 105 ++++++++++++++++++++++++++-------------
 drivers/media/rc/rc-core-priv.h  |  26 ++++++++++
 2 files changed, 96 insertions(+), 35 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index b78a402..46dfcec 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -19,8 +19,6 @@
 #include <media/rc-core.h>
 #include "rc-core-priv.h"
 
-#define LIRCBUF_SIZE 256
-
 /**
  * ir_lirc_raw_event() - Send raw IR data to lirc to be relayed to userspace
  *
@@ -32,10 +30,7 @@
 int ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 {
 	struct lirc_codec *lirc = &dev->raw->lirc;
-	int sample;
-
-	if (!dev->raw->lirc.drv || !dev->raw->lirc.drv->rbuf)
-		return -EINVAL;
+	unsigned int sample;
 
 	/* Packet start */
 	if (ev.reset) {
@@ -70,10 +65,7 @@ int ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 
 	/* Normal sample */
 	} else {
-
 		if (lirc->gap) {
-			int gap_sample;
-
 			lirc->gap_duration += ktime_to_ns(ktime_sub(ktime_get(),
 				lirc->gap_start));
 
@@ -82,9 +74,7 @@ int ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 			lirc->gap_duration = min(lirc->gap_duration,
 							(u64)LIRC_VALUE_MASK);
 
-			gap_sample = LIRC_SPACE(lirc->gap_duration);
-			lirc_buffer_write(dev->raw->lirc.drv->rbuf,
-						(unsigned char *) &gap_sample);
+			kfifo_put(&lirc->kfifo, LIRC_SPACE(lirc->gap_duration));
 			lirc->gap = false;
 		}
 
@@ -94,9 +84,8 @@ int ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 			   TO_US(ev.duration), TO_STR(ev.pulse));
 	}
 
-	lirc_buffer_write(dev->raw->lirc.drv->rbuf,
-			  (unsigned char *) &sample);
-	wake_up(&dev->raw->lirc.drv->rbuf->wait_poll);
+	kfifo_put(&lirc->kfifo, sample);
+	wake_up_poll(&lirc->wait_poll, POLLIN);
 
 	return 0;
 }
@@ -317,8 +306,67 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	return ret;
 }
 
+static unsigned int ir_lirc_poll_ir(struct file *filep,
+				    struct poll_table_struct *wait)
+{
+	struct lirc_codec *lirc = lirc_get_pdata(filep);
+	unsigned int events = 0;
+
+	if (!lirc->drv->attached)
+		return POLLERR;
+
+	poll_wait(filep, &lirc->wait_poll, wait);
+
+	if (!lirc->drv->attached)
+		events = POLLERR;
+	else if (!kfifo_is_empty(&lirc->kfifo))
+		events = POLLIN | POLLRDNORM;
+
+	return events;
+}
+
+static ssize_t ir_lirc_read_ir(struct file *filep, char __user *buffer,
+			       size_t length, loff_t *ppos)
+{
+	struct lirc_codec *lirc = lirc_get_pdata(filep);
+	unsigned int copied;
+	int ret;
+
+	if (length % sizeof(unsigned int))
+		return -EINVAL;
+
+	if (!lirc->drv->attached)
+		return -ENODEV;
+
+	do {
+		if (kfifo_is_empty(&lirc->kfifo)) {
+			if (filep->f_flags & O_NONBLOCK)
+				return -EAGAIN;
+
+			ret = wait_event_interruptible(lirc->wait_poll,
+					!kfifo_is_empty(&lirc->kfifo) ||
+					!lirc->drv->attached);
+			if (ret)
+				return ret;
+		}
+
+		if (!lirc->drv->attached)
+			return -ENODEV;
+
+		ret = kfifo_to_user(&lirc->kfifo, buffer, length, &copied);
+		if (ret)
+			return ret;
+	} while (copied == 0);
+
+	return copied;
+}
+
 static int ir_lirc_open(void *data)
 {
+	struct lirc_codec *lirc = data;
+
+	kfifo_reset_out(&lirc->kfifo);
+
 	return 0;
 }
 
@@ -334,8 +382,8 @@ static const struct file_operations lirc_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ir_lirc_ioctl,
 #endif
-	.read		= lirc_dev_fop_read,
-	.poll		= lirc_dev_fop_poll,
+	.read		= ir_lirc_read_ir,
+	.poll		= ir_lirc_poll_ir,
 	.open		= lirc_dev_fop_open,
 	.release	= lirc_dev_fop_close,
 	.llseek		= no_llseek,
@@ -344,21 +392,12 @@ static const struct file_operations lirc_fops = {
 int ir_lirc_register(struct rc_dev *dev)
 {
 	struct lirc_driver *drv;
-	struct lirc_buffer *rbuf;
 	int rc = -ENOMEM;
 	unsigned long features;
 
-	drv = kzalloc(sizeof(struct lirc_driver), GFP_KERNEL);
+	drv = kzalloc(sizeof(*drv), GFP_KERNEL);
 	if (!drv)
-		return rc;
-
-	rbuf = kzalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
-	if (!rbuf)
-		goto rbuf_alloc_failed;
-
-	rc = lirc_buffer_init(rbuf, sizeof(int), LIRCBUF_SIZE);
-	if (rc)
-		goto rbuf_init_failed;
+		return -ENOMEM;
 
 	features = LIRC_CAN_REC_MODE2;
 	if (dev->tx_ir) {
@@ -389,7 +428,6 @@ int ir_lirc_register(struct rc_dev *dev)
 	drv->minor = -1;
 	drv->features = features;
 	drv->data = &dev->raw->lirc;
-	drv->rbuf = rbuf;
 	drv->set_use_inc = &ir_lirc_open;
 	drv->set_use_dec = &ir_lirc_close;
 	drv->code_length = sizeof(struct ir_raw_event) * 8;
@@ -397,6 +435,8 @@ int ir_lirc_register(struct rc_dev *dev)
 	drv->dev = &dev->dev;
 	drv->rdev = dev;
 	drv->owner = THIS_MODULE;
+	INIT_KFIFO(dev->raw->lirc.kfifo);
+	init_waitqueue_head(&dev->raw->lirc.wait_poll);
 
 	drv->minor = lirc_register_driver(drv);
 	if (drv->minor < 0) {
@@ -409,11 +449,7 @@ int ir_lirc_register(struct rc_dev *dev)
 	return 0;
 
 lirc_register_failed:
-rbuf_init_failed:
-	kfree(rbuf);
-rbuf_alloc_failed:
 	kfree(drv);
-
 	return rc;
 }
 
@@ -421,9 +457,8 @@ int ir_lirc_unregister(struct rc_dev *dev)
 {
 	struct lirc_codec *lirc = &dev->raw->lirc;
 
+	wake_up_poll(&lirc->wait_poll, POLLERR);
 	lirc_unregister_driver(lirc->drv->minor);
-	lirc_buffer_free(lirc->drv->rbuf);
-	kfree(lirc->drv->rbuf);
 
 	return 0;
 }
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 6819310..f612340 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -19,7 +19,11 @@
 /* Define the max number of pulse/space transitions to buffer */
 #define	MAX_IR_EVENT_SIZE	512
 
+/* Define the number */
+#define LIRCBUF_SIZE		256
+
 #include <linux/slab.h>
+#include <media/lirc_dev.h>
 #include <media/rc-core.h>
 
 struct ir_raw_handler {
@@ -47,6 +51,7 @@ struct ir_raw_event_ctrl {
 	/* raw decoder state follows */
 	struct ir_raw_event prev_ev;
 	struct ir_raw_event this_ev;
+#if IS_ENABLED(CONFIG_IR_NEC_DECODER)
 	struct nec_dec {
 		int state;
 		unsigned count;
@@ -54,12 +59,16 @@ struct ir_raw_event_ctrl {
 		bool is_nec_x;
 		bool necx_repeat;
 	} nec;
+#endif
+#if IS_ENABLED(CONFIG_IR_RC5_DECODER)
 	struct rc5_dec {
 		int state;
 		u32 bits;
 		unsigned count;
 		bool is_rc5x;
 	} rc5;
+#endif
+#if IS_ENABLED(CONFIG_IR_RC6_DECODER)
 	struct rc6_dec {
 		int state;
 		u8 header;
@@ -68,11 +77,15 @@ struct ir_raw_event_ctrl {
 		unsigned count;
 		unsigned wanted_bits;
 	} rc6;
+#endif
+#if IS_ENABLED(CONFIG_IR_SONY_DECODER)
 	struct sony_dec {
 		int state;
 		u32 bits;
 		unsigned count;
 	} sony;
+#endif
+#if IS_ENABLED(CONFIG_IR_JVC_DECODER)
 	struct jvc_dec {
 		int state;
 		u16 bits;
@@ -81,17 +94,23 @@ struct ir_raw_event_ctrl {
 		bool first;
 		bool toggle;
 	} jvc;
+#endif
+#if IS_ENABLED(CONFIG_IR_SANYO_DECODER)
 	struct sanyo_dec {
 		int state;
 		unsigned count;
 		u64 bits;
 	} sanyo;
+#endif
+#if IS_ENABLED(CONFIG_IR_SHARP_DECODER)
 	struct sharp_dec {
 		int state;
 		unsigned count;
 		u32 bits;
 		unsigned int pulse_len;
 	} sharp;
+#endif
+#if IS_ENABLED(CONFIG_IR_MCE_KBD_DECODER)
 	struct mce_kbd_dec {
 		struct input_dev *idev;
 		struct timer_list rx_timeout;
@@ -103,9 +122,13 @@ struct ir_raw_event_ctrl {
 		unsigned count;
 		unsigned wanted_bits;
 	} mce_kbd;
+#endif
+#if IS_ENABLED(CONFIG_IR_LIRC_CODEC)
 	struct lirc_codec {
 		struct rc_dev *dev;
 		struct lirc_driver *drv;
+		DECLARE_KFIFO(kfifo, unsigned int, LIRCBUF_SIZE);
+		wait_queue_head_t wait_poll;
 		int carrier_low;
 
 		ktime_t gap_start;
@@ -114,11 +137,14 @@ struct ir_raw_event_ctrl {
 		bool send_timeout_reports;
 
 	} lirc;
+#endif
+#if IS_ENABLED(CONFIG_IR_XMP_DECODER)
 	struct xmp_dec {
 		int state;
 		unsigned count;
 		u32 durations[16];
 	} xmp;
+#endif
 };
 
 /* macros for IR decoders */
-- 
2.9.3

