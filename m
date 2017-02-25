Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:43467 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751402AbdBYMWI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Feb 2017 07:22:08 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 13/19] [media] lirc: use plain kfifo rather than lirc_buffer
Date: Sat, 25 Feb 2017 11:51:28 +0000
Message-Id: <7c5ebc74c044a7a9a4e69a1662dc71bd87e421da.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since a lirc char device can only be opened once, there can only be one
reader. By using a plain kfifo we don't need a spinlock and we can use
kfifo_to_user. The code is much simplified.

Unfortunately we cannot eliminate lirc_buffer from the tree yet, as there
are still some staging lirc drivers which use it.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c | 136 ++++++++++++++++++++++++---------------
 drivers/media/rc/lirc_dev.c      |   5 +-
 drivers/media/rc/rc-core-priv.h  |  33 ++++++----
 include/media/rc-core.h          |   2 +
 4 files changed, 107 insertions(+), 69 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 78f354a..74f7863 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -19,23 +19,16 @@
 #include <media/rc-core.h>
 #include "rc-core-priv.h"
 
-#define LIRCBUF_SIZE 256
-
 /**
  * ir_lirc_raw_event() - Send raw IR data to lirc to be relayed to userspace
  *
  * @input_dev:	the struct rc_dev descriptor of the device
  * @duration:	the struct ir_raw_event descriptor of the pulse/space
- *
- * This function returns -EINVAL if the lirc interfaces aren't wired up.
  */
-int ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
+void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 {
-	struct lirc_codec *lirc = &dev->raw->lirc;
-	int sample;
-
-	if (!dev->raw->lirc.drv || !dev->raw->lirc.drv->rbuf)
-		return -EINVAL;
+	struct lirc_node *lirc = dev->lirc;
+	unsigned int sample;
 
 	/* Packet start */
 	if (ev.reset) {
@@ -54,26 +47,22 @@ int ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 
 	/* Packet end */
 	} else if (ev.timeout) {
-
 		if (lirc->gap)
-			return 0;
+			return;
 
 		lirc->gap_start = ktime_get();
 		lirc->gap = true;
 		lirc->gap_duration = ev.duration;
 
 		if (!lirc->send_timeout_reports)
-			return 0;
+			return;
 
 		sample = LIRC_TIMEOUT(ev.duration / 1000);
 		IR_dprintk(2, "timeout report (duration: %d)\n", sample);
 
 	/* Normal sample */
 	} else {
-
 		if (lirc->gap) {
-			int gap_sample;
-
 			lirc->gap_duration += ktime_to_ns(ktime_sub(ktime_get(),
 				lirc->gap_start));
 
@@ -82,9 +71,7 @@ int ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 			lirc->gap_duration = min(lirc->gap_duration,
 							(u64)LIRC_VALUE_MASK);
 
-			gap_sample = LIRC_SPACE(lirc->gap_duration);
-			lirc_buffer_write(dev->raw->lirc.drv->rbuf,
-						(unsigned char *) &gap_sample);
+			kfifo_put(&lirc->rawir, LIRC_SPACE(lirc->gap_duration));
 			lirc->gap = false;
 		}
 
@@ -94,17 +81,14 @@ int ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 			   TO_US(ev.duration), TO_STR(ev.pulse));
 	}
 
-	lirc_buffer_write(dev->raw->lirc.drv->rbuf,
-			  (unsigned char *) &sample);
-	wake_up(&dev->raw->lirc.drv->rbuf->wait_poll);
-
-	return 0;
+	kfifo_put(&lirc->rawir, sample);
+	wake_up_poll(&lirc->wait_poll, POLLIN | POLLRDNORM);
 }
 
 static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 				   size_t n, loff_t *ppos)
 {
-	struct lirc_codec *lirc;
+	struct lirc_node *lirc;
 	struct rc_dev *dev;
 	unsigned int *txbuf; /* buffer with values to transmit */
 	ssize_t ret = -EINVAL;
@@ -179,7 +163,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 			unsigned long arg)
 {
-	struct lirc_codec *lirc;
+	struct lirc_node *lirc;
 	struct rc_dev *dev;
 	u32 __user *argp = (u32 __user *)(arg);
 	int ret = 0;
@@ -248,7 +232,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 			return -EINVAL;
 
 		return dev->s_rx_carrier_range(dev,
-					       dev->raw->lirc.carrier_low,
+					       dev->lirc->carrier_low,
 					       val);
 
 	case LIRC_SET_REC_CARRIER_RANGE:
@@ -258,7 +242,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		if (val <= 0)
 			return -EINVAL;
 
-		dev->raw->lirc.carrier_low = val;
+		dev->lirc->carrier_low = val;
 		return 0;
 
 	case LIRC_GET_REC_RESOLUTION:
@@ -326,8 +310,64 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	return ret;
 }
 
+static unsigned int ir_lirc_poll(struct file *filep,
+				 struct poll_table_struct *wait)
+{
+	struct lirc_node *lirc = lirc_get_pdata(filep);
+	unsigned int events = 0;
+
+	poll_wait(filep, &lirc->wait_poll, wait);
+
+	if (!lirc->drv.attached)
+		events = POLLHUP;
+	else if (!kfifo_is_empty(&lirc->rawir))
+		events = POLLIN | POLLRDNORM;
+
+	return events;
+}
+
+static ssize_t ir_lirc_read(struct file *filep, char __user *buffer,
+			    size_t length, loff_t *ppos)
+{
+	struct lirc_node *lirc = lirc_get_pdata(filep);
+	unsigned int copied;
+	int ret;
+
+	if (length % sizeof(unsigned int))
+		return -EINVAL;
+
+	if (!lirc->drv.attached)
+		return -ENODEV;
+
+	do {
+		if (kfifo_is_empty(&lirc->rawir)) {
+			if (filep->f_flags & O_NONBLOCK)
+				return -EAGAIN;
+
+			ret = wait_event_interruptible(lirc->wait_poll,
+					!kfifo_is_empty(&lirc->rawir) ||
+					!lirc->drv.attached);
+			if (ret)
+				return ret;
+		}
+
+		if (!lirc->drv.attached)
+			return -ENODEV;
+
+		ret = kfifo_to_user(&lirc->rawir, buffer, length, &copied);
+		if (ret)
+			return ret;
+	} while (copied == 0);
+
+	return copied;
+}
+
 static int ir_lirc_open(void *data)
 {
+	struct lirc_node *lirc = data;
+
+	kfifo_reset_out(&lirc->rawir);
+
 	return 0;
 }
 
@@ -343,8 +383,8 @@ static const struct file_operations lirc_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ir_lirc_ioctl,
 #endif
-	.read		= lirc_dev_fop_read,
-	.poll		= lirc_dev_fop_poll,
+	.read		= ir_lirc_read,
+	.poll		= ir_lirc_poll,
 	.open		= lirc_dev_fop_open,
 	.release	= lirc_dev_fop_close,
 	.llseek		= no_llseek,
@@ -353,22 +393,14 @@ static const struct file_operations lirc_fops = {
 int ir_lirc_register(struct rc_dev *dev)
 {
 	struct lirc_driver *drv;
-	struct lirc_buffer *rbuf;
+	struct lirc_node *node;
 	int rc = -ENOMEM;
 	unsigned long features = 0;
 
-	drv = kzalloc(sizeof(struct lirc_driver), GFP_KERNEL);
-	if (!drv)
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node)
 		return rc;
 
-	rbuf = kzalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
-	if (!rbuf)
-		goto rbuf_alloc_failed;
-
-	rc = lirc_buffer_init(rbuf, sizeof(int), LIRCBUF_SIZE);
-	if (rc)
-		goto rbuf_init_failed;
-
 	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
 		features |= LIRC_CAN_REC_MODE2;
 		if (dev->rx_resolution)
@@ -397,12 +429,12 @@ int ir_lirc_register(struct rc_dev *dev)
 	if (dev->max_timeout)
 		features |= LIRC_CAN_SET_REC_TIMEOUT;
 
+	drv = &node->drv;
 	snprintf(drv->name, sizeof(drv->name), "ir-lirc-codec (%s)",
 		 dev->driver_name);
 	drv->minor = -1;
 	drv->features = features;
-	drv->data = &dev->raw->lirc;
-	drv->rbuf = rbuf;
+	drv->data = node;
 	drv->set_use_inc = &ir_lirc_open;
 	drv->set_use_dec = &ir_lirc_close;
 	drv->code_length = sizeof(struct ir_raw_event) * 8;
@@ -411,30 +443,28 @@ int ir_lirc_register(struct rc_dev *dev)
 	drv->rdev = dev;
 	drv->owner = THIS_MODULE;
 
+	INIT_KFIFO(node->rawir);
+	init_waitqueue_head(&node->wait_poll);
+
 	drv->minor = lirc_register_driver(drv);
 	if (drv->minor < 0) {
 		rc = -ENODEV;
 		goto lirc_register_failed;
 	}
 
-	dev->raw->lirc.drv = drv;
-	dev->raw->lirc.dev = dev;
+	node->dev = dev;
+	dev->lirc = node;
 	return 0;
 
 lirc_register_failed:
-rbuf_init_failed:
-	kfree(rbuf);
-rbuf_alloc_failed:
 	kfree(drv);
-
 	return rc;
 }
 
 void ir_lirc_unregister(struct rc_dev *dev)
 {
-	struct lirc_codec *lirc = &dev->raw->lirc;
+	struct lirc_node *lirc = dev->lirc;
 
-	lirc_unregister_driver(lirc->drv->minor);
-	lirc_buffer_free(lirc->drv->rbuf);
-	kfree(lirc->drv->rbuf);
+	wake_up_poll(&lirc->wait_poll, POLLHUP);
+	lirc_unregister_driver(lirc->drv.minor);
 }
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 44650e4..7d705af 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -328,7 +328,7 @@ int lirc_register_driver(struct lirc_driver *d)
 	if (minor < 0)
 		return minor;
 
-	if (LIRC_CAN_REC(d->features)) {
+	if (!d->rdev) {
 		err = lirc_allocate_buffer(irctls[minor]);
 		if (err)
 			lirc_unregister_driver(minor);
@@ -374,7 +374,8 @@ int lirc_unregister_driver(int minor)
 	if (d->open) {
 		dev_dbg(d->dev.parent, LOGHEAD "releasing opened driver\n",
 			d->name, d->minor);
-		wake_up_interruptible(&d->buf->wait_poll);
+		if (d->buf)
+			wake_up_interruptible(&d->buf->wait_poll);
 	}
 
 	mutex_lock(&d->irctl_lock);
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index da31738..9b561c3 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -19,7 +19,11 @@
 /* Define the max number of pulse/space transitions to buffer */
 #define	MAX_IR_EVENT_SIZE	512
 
+/* Define the number of samples lirc can buffer or transmit */
+#define LIRCBUF_SIZE		256
+
 #include <linux/slab.h>
+#include <media/lirc_dev.h>
 #include <media/rc-core.h>
 
 struct ir_raw_handler {
@@ -35,6 +39,18 @@ struct ir_raw_handler {
 	int (*raw_unregister)(struct rc_dev *dev);
 };
 
+struct lirc_node {
+	struct lirc_driver drv;
+	struct rc_dev *dev;
+	int carrier_low;
+	DECLARE_KFIFO(rawir, unsigned int, LIRCBUF_SIZE);
+	wait_queue_head_t wait_poll;
+	ktime_t gap_start;
+	u64 gap_duration;
+	bool gap;
+	bool send_timeout_reports;
+};
+
 struct ir_raw_event_ctrl {
 	struct list_head		list;		/* to keep track of raw clients */
 	struct task_struct		*thread;
@@ -103,17 +119,6 @@ struct ir_raw_event_ctrl {
 		unsigned count;
 		unsigned wanted_bits;
 	} mce_kbd;
-	struct lirc_codec {
-		struct rc_dev *dev;
-		struct lirc_driver *drv;
-		int carrier_low;
-
-		ktime_t gap_start;
-		u64 gap_duration;
-		bool gap;
-		bool send_timeout_reports;
-
-	} lirc;
 	struct xmp_dec {
 		int state;
 		unsigned count;
@@ -273,12 +278,12 @@ void ir_raw_init(void);
  * lirc interface bridge
  */
 #ifdef CONFIG_IR_LIRC_CODEC
-int ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev);
+void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev);
 int ir_lirc_register(struct rc_dev *dev);
 void ir_lirc_unregister(struct rc_dev *dev);
 #else
-static inline int ir_lirc_raw_event(struct rc_dev *dev,
-				    struct ir_raw_event ev) { return 0; }
+static inline void ir_lirc_raw_event(struct rc_dev *dev,
+				     struct ir_raw_event ev) { }
 static inline int ir_lirc_register(struct rc_dev *dev) { return 0; }
 static inline void ir_lirc_unregister(struct rc_dev *dev) { }
 #endif
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 73ddd721..45e8623 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -115,6 +115,7 @@ enum rc_filter_type {
  * @max_timeout: maximum timeout supported by device
  * @rx_resolution : resolution (in ns) of input sampler
  * @tx_resolution: resolution (in ns) of output sampler
+ * @lirc: lirc chardev node
  * @change_protocol: allow changing the protocol used on hardware decoders
  * @open: callback to allow drivers to enable polling/irq when IR input device
  *	is opened.
@@ -175,6 +176,7 @@ struct rc_dev {
 	u32				max_timeout;
 	u32				rx_resolution;
 	u32				tx_resolution;
+	struct lirc_node		*lirc;
 	int				(*change_protocol)(struct rc_dev *dev, u64 *rc_type);
 	int				(*open)(struct rc_dev *dev);
 	void				(*close)(struct rc_dev *dev);
-- 
2.9.3
