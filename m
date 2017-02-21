Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:38343 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753829AbdBUUnv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 15:43:51 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 18/19] [media] lirc: scancode rc devices should have a lirc device too
Date: Tue, 21 Feb 2017 20:43:42 +0000
Message-Id: <47bf02e61e548bb542c059687c6589562d877393.1487709384.git.sean@mess.org>
In-Reply-To: <cover.1487709384.git.sean@mess.org>
References: <cover.1487709384.git.sean@mess.org>
In-Reply-To: <cover.1487709384.git.sean@mess.org>
References: <cover.1487709384.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the lirc interface supports scancodes, RC scancode devices
can also have a lirc device, except for cec devices which have their
own /dev/cecN interface.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c      | 106 ++++++++++++++--------------------
 drivers/media/rc/ir-mce_kbd-decoder.c |   2 +-
 drivers/media/rc/rc-core-priv.h       |  15 -----
 drivers/media/rc/rc-main.c            |   9 +--
 include/media/rc-core.h               |  10 ++++
 5 files changed, 60 insertions(+), 82 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 1847f5f..d0dc9b4 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -85,7 +85,7 @@ int ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 	}
 
 	kfifo_put(&lirc->kfifo, sample);
-	wake_up_poll(&lirc->wait_poll, POLLIN);
+	wake_up_poll(&dev->wait_poll, POLLIN);
 
 	return 0;
 }
@@ -93,8 +93,7 @@ int ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 				   size_t n, loff_t *ppos)
 {
-	struct lirc_codec *lirc;
-	struct rc_dev *dev;
+	struct rc_dev *dev = lirc_get_pdata(file);
 	unsigned int *txbuf = NULL; /* buffer with values to transmit */
 	struct ir_raw_event *raw = NULL;
 	ssize_t ret = -EINVAL;
@@ -106,18 +105,10 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 
 	start = ktime_get();
 
-	lirc = lirc_get_pdata(file);
-	if (!lirc)
-		return -EFAULT;
-
-	dev = lirc->dev;
-	if (!dev)
-		return -EFAULT;
-
 	if (!dev->tx_ir)
 		return -EINVAL;
 
-	if (lirc->send_mode == LIRC_MODE_SCANCODE) {
+	if (dev->send_mode == LIRC_MODE_SCANCODE) {
 		struct lirc_scancode scan;
 
 		if (n != sizeof(scan))
@@ -185,7 +176,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	for (duration = i = 0; i < ret; i++)
 		duration += txbuf[i];
 
-	if (lirc->send_mode == LIRC_MODE_SCANCODE)
+	if (dev->send_mode == LIRC_MODE_SCANCODE)
 		ret = n;
 	else
 		ret *= sizeof(unsigned int);
@@ -210,20 +201,11 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 			unsigned long arg)
 {
-	struct lirc_codec *lirc;
-	struct rc_dev *dev;
+	struct rc_dev *dev = lirc_get_pdata(filep);
 	u32 __user *argp = (u32 __user *)(arg);
 	int ret = 0;
 	__u32 val = 0, tmp;
 
-	lirc = lirc_get_pdata(filep);
-	if (!lirc)
-		return -EFAULT;
-
-	dev = lirc->dev;
-	if (!dev)
-		return -EFAULT;
-
 	if (_IOC_DIR(cmd) & _IOC_WRITE) {
 		ret = get_user(val, argp);
 		if (ret)
@@ -235,7 +217,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		if (dev->driver_type == RC_DRIVER_IR_RAW_TX)
 			return -ENOTTY;
 
-		val = lirc->rec_mode;
+		val = dev->rec_mode;
 		break;
 
 	case LIRC_SET_REC_MODE:
@@ -253,14 +235,14 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 			return -ENOTTY;
 		}
 
-		lirc->rec_mode = val;
+		dev->rec_mode = val;
 		return 0;
 
 	case LIRC_GET_SEND_MODE:
 		if (!dev->tx_ir)
 			return -ENOTTY;
 
-		val = lirc->send_mode;
+		val = dev->send_mode;
 		break;
 
 	case LIRC_SET_SEND_MODE:
@@ -270,7 +252,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		if (!(val == LIRC_MODE_PULSE || val == LIRC_MODE_SCANCODE))
 			return -EINVAL;
 
-		lirc->send_mode = val;
+		dev->send_mode = val;
 		return 0;
 
 	/* TX settings */
@@ -297,7 +279,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 
 	/* RX settings */
 	case LIRC_SET_REC_CARRIER:
-		if (!dev->s_rx_carrier_range)
+		if (!dev->s_rx_carrier_range || !dev->raw)
 			return -ENOTTY;
 
 		if (val <= 0)
@@ -308,7 +290,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 					       val);
 
 	case LIRC_SET_REC_CARRIER_RANGE:
-		if (!dev->s_rx_carrier_range)
+		if (!dev->s_rx_carrier_range || !dev->raw)
 			return -ENOTTY;
 
 		if (val <= 0)
@@ -366,10 +348,10 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		break;
 
 	case LIRC_SET_REC_TIMEOUT_REPORTS:
-		if (!dev->timeout)
+		if (!dev->timeout || !dev->raw)
 			return -ENOTTY;
 
-		lirc->send_timeout_reports = !!val;
+		dev->raw->lirc.send_timeout_reports = !!val;
 		break;
 
 	default:
@@ -385,10 +367,11 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 static unsigned int ir_lirc_poll(struct file *filep,
 				 struct poll_table_struct *wait)
 {
-	struct lirc_codec *lirc = lirc_get_pdata(filep);
+	struct rc_dev *dev = lirc_get_pdata(filep);
+	struct lirc_driver *drv = dev->lirc_drv;
 	unsigned int events = 0;
 
-	poll_wait(filep, &lirc->wait_poll, wait);
+	poll_wait(filep, &dev->wait_poll, wait);
 
 	if (!drv->attached) {
 		events = POLLERR;
@@ -406,35 +389,35 @@ static unsigned int ir_lirc_poll(struct file *filep,
 static ssize_t ir_lirc_read(struct file *filep, char __user *buffer,
 			    size_t length, loff_t *ppos)
 {
-	struct lirc_codec *lirc = lirc_get_pdata(filep);
+	struct rc_dev *dev = lirc_get_pdata(filep);
+	struct lirc_driver *drv = dev->lirc_drv;
+	struct lirc_codec *lirc = &dev->raw->lirc;
 	unsigned int copied;
 	int ret;
 
-	if (!lirc->drv->attached)
+	if (!drv->attached)
 		return -ENODEV;
 
-	if (lirc->rec_mode == LIRC_MODE_SCANCODE) {
-		struct rc_dev *rcdev = lirc->dev;
-
+	if (dev->rec_mode == LIRC_MODE_SCANCODE) {
 		if (length % sizeof(struct lirc_scancode))
 			return -EINVAL;
 
 		do {
-			if (kfifo_is_empty(&rcdev->kfifo)) {
+			if (kfifo_is_empty(&dev->kfifo)) {
 				if (filep->f_flags & O_NONBLOCK)
 					return -EAGAIN;
 
-				ret = wait_event_interruptible(lirc->wait_poll,
-					!kfifo_is_empty(&rcdev->kfifo) ||
-					!lirc->drv->attached);
+				ret = wait_event_interruptible(dev->wait_poll,
+					!kfifo_is_empty(&dev->kfifo) ||
+					!drv->attached);
 				if (ret)
 					return ret;
 			}
 
-			if (!lirc->drv->attached)
+			if (!drv->attached)
 				return -ENODEV;
 
-			ret = kfifo_to_user(&rcdev->kfifo, buffer, length,
+			ret = kfifo_to_user(&dev->kfifo, buffer, length,
 					    &copied);
 			if (ret)
 				return ret;
@@ -448,14 +431,14 @@ static ssize_t ir_lirc_read(struct file *filep, char __user *buffer,
 				if (filep->f_flags & O_NONBLOCK)
 					return -EAGAIN;
 
-				ret = wait_event_interruptible(lirc->wait_poll,
+				ret = wait_event_interruptible(dev->wait_poll,
 						!kfifo_is_empty(&lirc->kfifo) ||
-						!lirc->drv->attached);
+						!drv->attached);
 				if (ret)
 					return ret;
 			}
 
-			if (!lirc->drv->attached)
+			if (!drv->attached)
 				return -ENODEV;
 
 			ret = kfifo_to_user(&lirc->kfifo, buffer, length,
@@ -470,10 +453,11 @@ static ssize_t ir_lirc_read(struct file *filep, char __user *buffer,
 
 static int ir_lirc_open(void *data)
 {
-	struct lirc_codec *lirc = data;
+	struct rc_dev *dev = data;
 
-	kfifo_reset_out(&lirc->kfifo);
-	kfifo_reset_out(&lirc->dev->kfifo);
+	kfifo_reset_out(&dev->kfifo);
+	if (dev->raw)
+		kfifo_reset_out(&dev->raw->lirc.kfifo);
 
 	return 0;
 }
@@ -509,15 +493,15 @@ int ir_lirc_register(struct rc_dev *dev)
 
 	if (dev->driver_type == RC_DRIVER_SCANCODE) {
 		features |= LIRC_CAN_REC_SCANCODE;
-		dev->raw->lirc.rec_mode = LIRC_MODE_SCANCODE;
+		dev->rec_mode = LIRC_MODE_SCANCODE;
 	} else if (dev->driver_type == RC_DRIVER_IR_RAW) {
 		features |= LIRC_CAN_REC_MODE2 | LIRC_CAN_REC_SCANCODE;
 		if (dev->rx_resolution)
 			features |= LIRC_CAN_GET_REC_RESOLUTION;
-		dev->raw->lirc.rec_mode = LIRC_MODE_MODE2;
+		dev->rec_mode = LIRC_MODE_MODE2;
 	}
 	if (dev->tx_ir) {
-		dev->raw->lirc.send_mode = LIRC_MODE_PULSE;
+		dev->send_mode = LIRC_MODE_PULSE;
 		features |= LIRC_CAN_SEND_PULSE | LIRC_CAN_SEND_SCANCODE;
 		if (dev->s_tx_mask)
 			features |= LIRC_CAN_SET_TRANSMITTER_MASK;
@@ -544,16 +528,16 @@ int ir_lirc_register(struct rc_dev *dev)
 		 dev->driver_name);
 	drv->minor = -1;
 	drv->features = features;
-	drv->data = &dev->raw->lirc;
 	drv->set_use_inc = &ir_lirc_open;
 	drv->set_use_dec = &ir_lirc_close;
 	drv->code_length = sizeof(struct ir_raw_event) * 8;
 	drv->fops = &lirc_fops;
 	drv->dev.parent = &dev->dev;
+	drv->data = dev;
 	drv->rdev = dev;
 	drv->owner = THIS_MODULE;
-	INIT_KFIFO(dev->raw->lirc.kfifo);
-	init_waitqueue_head(&dev->raw->lirc.wait_poll);
+	if (dev->raw)
+		INIT_KFIFO(dev->raw->lirc.kfifo);
 
 	drv->minor = lirc_register_driver(drv);
 	if (drv->minor < 0) {
@@ -561,8 +545,8 @@ int ir_lirc_register(struct rc_dev *dev)
 		goto lirc_register_failed;
 	}
 
-	dev->raw->lirc.drv = drv;
-	dev->raw->lirc.dev = dev;
+	dev->lirc_drv = drv;
+
 	return 0;
 
 lirc_register_failed:
@@ -572,8 +556,6 @@ int ir_lirc_register(struct rc_dev *dev)
 
 void ir_lirc_unregister(struct rc_dev *dev)
 {
-	struct lirc_codec *lirc = &dev->raw->lirc;
-
-	wake_up_poll(&lirc->wait_poll, POLLERR);
-	lirc_unregister_driver(lirc->drv->minor);
+	wake_up_poll(&dev->wait_poll, POLLERR);
+	lirc_unregister_driver(dev->lirc_drv->minor);
 }
diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index c4b2998..552d0fe 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -344,7 +344,7 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		lsc.scancode = scancode;
 		lsc.flags = 0;
 		if (kfifo_put(&dev->kfifo, lsc))
-			ir_wakeup_poll(dev->raw);
+			wake_up_poll(&dev->wait_poll, POLLIN);
 		data->state = STATE_INACTIVE;
 		input_event(data->idev, EV_MSC, MSC_SCAN, scancode);
 		input_sync(data->idev);
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 858c467..001911d 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -126,18 +126,13 @@ struct ir_raw_event_ctrl {
 #endif
 #if IS_ENABLED(CONFIG_IR_LIRC_CODEC)
 	struct lirc_codec {
-		struct rc_dev *dev;
-		struct lirc_driver *drv;
 		DECLARE_KFIFO(kfifo, unsigned int, LIRCBUF_SIZE);
-		wait_queue_head_t wait_poll;
 		int carrier_low;
 
 		ktime_t gap_start;
 		u64 gap_duration;
 		bool gap;
 		bool send_timeout_reports;
-		int send_mode;
-		int rec_mode;
 	} lirc;
 #endif
 #if IS_ENABLED(CONFIG_IR_XMP_DECODER)
@@ -149,16 +144,6 @@ struct ir_raw_event_ctrl {
 #endif
 };
 
-#if IS_ENABLED(CONFIG_IR_LIRC_CODEC)
-static inline void ir_wakeup_poll(struct ir_raw_event_ctrl *ctrl)
-{
-	if (ctrl)
-		wake_up_poll(&ctrl->lirc.wait_poll, POLLIN);
-}
-#else
-static inline void ir_wakeup_poll(struct ir_raw_event_ctrl *ctrl) {}
-#endif
-
 /* macros for IR decoders */
 static inline bool geq_margin(unsigned d1, unsigned d2, unsigned margin)
 {
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index feff1f3..ebca5bf 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -622,7 +622,7 @@ void rc_repeat(struct rc_dev *dev)
 	};
 
 	if (kfifo_put(&dev->kfifo, sc))
-		ir_wakeup_poll(dev->raw);
+		wake_up_poll(&dev->wait_poll, POLLIN);
 
 	spin_lock_irqsave(&dev->keylock, flags);
 
@@ -664,7 +664,7 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
 	};
 
 	if (kfifo_put(&dev->kfifo, sc))
-		ir_wakeup_poll(dev->raw);
+		wake_up_poll(&dev->wait_poll, POLLIN);
 
 	if (new_event && dev->keypressed)
 		ir_do_keyup(dev, false);
@@ -1606,6 +1606,7 @@ struct rc_dev *rc_allocate_device(enum rc_driver_type type)
 		spin_lock_init(&dev->rc_map.lock);
 		spin_lock_init(&dev->keylock);
 		INIT_KFIFO(dev->kfifo);
+		init_waitqueue_head(&dev->wait_poll);
 	}
 	mutex_init(&dev->lock);
 
@@ -1794,7 +1795,7 @@ int rc_register_device(struct rc_dev *dev)
 			goto out_rx;
 	}
 
-	if (dev->driver_type != RC_DRIVER_SCANCODE) {
+	if (dev->allowed_protocols != RC_BIT_CEC) {
 		rc = ir_lirc_register(dev);
 		if (rc < 0)
 			goto out_raw;
@@ -1859,7 +1860,7 @@ void rc_unregister_device(struct rc_dev *dev)
 	if (dev->driver_type == RC_DRIVER_IR_RAW)
 		ir_raw_event_unregister(dev);
 
-	if (dev->driver_type != RC_DRIVER_SCANCODE)
+	if (dev->allowed_protocols != RC_BIT_CEC)
 		ir_lirc_unregister(dev);
 
 	rc_free_rx_device(dev);
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 24486d7..52e818d 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -111,6 +111,12 @@ enum rc_filter_type {
  * @last_protocol: protocol of last keypress
  * @last_scancode: scancode of last keypress
  * @last_toggle: toggle value of last command
+ * @lirc_drv: lirc driver associated with this rc device
+ * @wait_poll: used for implementing poll on lirc char device
+ * @rec_mode: lirc char device recording mode (LIRC_MODE_MODE2 or
+ *	LIRC_MODE_SCANCODE).
+ * @send_mode: lirc char device sending mode (LIRC_MODE_PULSE or
+ *	LIRC_MODE_SCANCODE).
  * @timeout: optional time after which device stops sending data
  * @min_timeout: minimum timeout supported by device
  * @max_timeout: maximum timeout supported by device
@@ -172,6 +178,10 @@ struct rc_dev {
 	enum rc_type			last_protocol;
 	u32				last_scancode;
 	u8				last_toggle;
+	struct lirc_driver		*lirc_drv;
+	wait_queue_head_t		wait_poll;
+	u8				rec_mode;
+	u8				send_mode;
 	u32				timeout;
 	u32				min_timeout;
 	u32				max_timeout;
-- 
2.9.3
