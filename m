Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:54753 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751421AbdBYLwv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Feb 2017 06:52:51 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 17/19] [media] lirc: implement reading scancode
Date: Sat, 25 Feb 2017 11:51:32 +0000
Message-Id: <b9722d41efc7dd75ddbab78a62f654aa56d9a0a3.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This implements LIRC_MODE_SCANCODE reading from the lirc device. The
scancode can be read from the input device too, but with this interface
you get the rc protocol, toggle and repeat status in addition too just
the scancode.

int main()
{
	int fd, mode, rc;
	fd = open("/dev/lirc0", O_RDWR);

	mode = LIRC_MODE_SCANCODE;
	if (ioctl(fd, LIRC_SET_REC_MODE, &mode)) {
		// kernel too old or lirc does not support transmit
	}
	struct lirc_scancode scancode;
	while (read(fd, &scancode, sizeof(scancode)) == sizeof(scancode)) {
		printf("protocol:%d scancode:0x%x toggle:%d repeat:%d\n",
			scancode.rc_type, scancode.scancode,
			!!(scancode.flags & LIRC_SCANCODE_FLAG_TOGGLE),
			!!(scancode.flags & LIRC_SCANCODE_FLAG_REPEAT));
	}
	close(fd);
}

Note that the translated KEY_* is not included, that information is
published to the input device.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c      | 115 +++++++++++++++++++++++++++-------
 drivers/media/rc/ir-mce_kbd-decoder.c |   6 ++
 drivers/media/rc/rc-core-priv.h       |   5 ++
 drivers/media/rc/rc-main.c            |  14 +++++
 4 files changed, 118 insertions(+), 22 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index c57ab6c..7cad192 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -85,6 +85,15 @@ void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 	wake_up_poll(&lirc->wait_poll, POLLIN | POLLRDNORM);
 }
 
+void ir_lirc_scancode_event(struct rc_dev *dev, struct lirc_scancode *lsc)
+{
+	lsc->timestamp = ktime_get_ns();
+
+	if (kfifo_put(&dev->lirc->scancodes, *lsc))
+		wake_up_poll(&dev->lirc->wait_poll, POLLIN | POLLRDNORM);
+}
+EXPORT_SYMBOL_GPL(ir_lirc_scancode_event);
+
 static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 				   size_t n, loff_t *ppos)
 {
@@ -226,8 +235,31 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	}
 
 	switch (cmd) {
+	case LIRC_GET_REC_MODE:
+		if (dev->driver_type == RC_DRIVER_IR_RAW_TX)
+			return -ENOTTY;
+
+		val = lirc->rec_mode;
+		break;
+
+	case LIRC_SET_REC_MODE:
+		switch (dev->driver_type) {
+		case RC_DRIVER_SCANCODE:
+			if (val != LIRC_MODE_SCANCODE)
+				return -EINVAL;
+			break;
+		case RC_DRIVER_IR_RAW:
+			if (!(val == LIRC_MODE_SCANCODE ||
+			      val == LIRC_MODE_MODE2))
+				return -EINVAL;
+			break;
+		default:
+			return -ENOTTY;
+		}
+
+		lirc->rec_mode = val;
+		return 0;
 
-	/* legacy support */
 	case LIRC_GET_SEND_MODE:
 		if (!dev->tx_ir)
 			return -ENOTTY;
@@ -362,10 +394,15 @@ static unsigned int ir_lirc_poll(struct file *filep,
 
 	poll_wait(filep, &lirc->wait_poll, wait);
 
-	if (!lirc->drv.attached)
+	if (!lirc->drv.attached) {
 		events = POLLHUP;
-	else if (!kfifo_is_empty(&lirc->rawir))
-		events = POLLIN | POLLRDNORM;
+	} else if (lirc->rec_mode == LIRC_MODE_SCANCODE) {
+		if (!kfifo_is_empty(&lirc->rawir))
+			events = POLLIN | POLLRDNORM;
+	} else if (lirc->rec_mode == LIRC_MODE_MODE2) {
+		if (!kfifo_is_empty(&lirc->scancodes))
+			events = POLLIN | POLLRDNORM;
+	}
 
 	return events;
 }
@@ -377,31 +414,58 @@ static ssize_t ir_lirc_read(struct file *filep, char __user *buffer,
 	unsigned int copied;
 	int ret;
 
-	if (length % sizeof(unsigned int))
-		return -EINVAL;
-
 	if (!lirc->drv.attached)
 		return -ENODEV;
 
-	do {
-		if (kfifo_is_empty(&lirc->rawir)) {
-			if (filep->f_flags & O_NONBLOCK)
-				return -EAGAIN;
+	if (lirc->rec_mode == LIRC_MODE_SCANCODE) {
+		if (length % sizeof(struct lirc_scancode))
+			return -EINVAL;
+
+		do {
+			if (kfifo_is_empty(&lirc->scancodes)) {
+				if (filep->f_flags & O_NONBLOCK)
+					return -EAGAIN;
 
-			ret = wait_event_interruptible(lirc->wait_poll,
-					!kfifo_is_empty(&lirc->rawir) ||
+				ret = wait_event_interruptible(lirc->wait_poll,
+					!kfifo_is_empty(&lirc->scancodes) ||
 					!lirc->drv.attached);
+				if (ret)
+					return ret;
+			}
+
+			if (!lirc->drv.attached)
+				return -ENODEV;
+
+			ret = kfifo_to_user(&lirc->scancodes, buffer, length,
+					    &copied);
 			if (ret)
 				return ret;
-		}
+		} while (copied == 0);
+	} else {
+		if (length % sizeof(unsigned int))
+			return -EINVAL;
 
-		if (!lirc->drv.attached)
-			return -ENODEV;
+		do {
+			if (kfifo_is_empty(&lirc->rawir)) {
+				if (filep->f_flags & O_NONBLOCK)
+					return -EAGAIN;
 
-		ret = kfifo_to_user(&lirc->rawir, buffer, length, &copied);
-		if (ret)
-			return ret;
-	} while (copied == 0);
+				ret = wait_event_interruptible(lirc->wait_poll,
+						!kfifo_is_empty(&lirc->rawir) ||
+						!lirc->drv.attached);
+				if (ret)
+					return ret;
+			}
+
+			if (!lirc->drv.attached)
+				return -ENODEV;
+
+			ret = kfifo_to_user(&lirc->rawir, buffer, length,
+					    &copied);
+			if (ret)
+				return ret;
+		} while (copied == 0);
+	}
 
 	return copied;
 }
@@ -411,6 +475,7 @@ static int ir_lirc_open(void *data)
 	struct lirc_node *lirc = data;
 
 	kfifo_reset_out(&lirc->rawir);
+	kfifo_reset_out(&lirc->scancodes);
 
 	return 0;
 }
@@ -445,12 +510,17 @@ int ir_lirc_register(struct rc_dev *dev)
 	if (!node)
 		return rc;
 
-	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
-		features |= LIRC_CAN_REC_MODE2;
+	if (dev->driver_type == RC_DRIVER_SCANCODE) {
+		features |= LIRC_CAN_REC_SCANCODE;
+		node->rec_mode = LIRC_MODE_SCANCODE;
+	} else if (dev->driver_type == RC_DRIVER_IR_RAW) {
+		features |= LIRC_CAN_REC_MODE2 | LIRC_CAN_REC_SCANCODE;
 		if (dev->rx_resolution)
 			features |= LIRC_CAN_GET_REC_RESOLUTION;
+		node->rec_mode = LIRC_MODE_MODE2;
 	}
 	if (dev->tx_ir) {
+		node->send_mode = LIRC_MODE_PULSE;
 		features |= LIRC_CAN_SEND_PULSE | LIRC_CAN_SEND_SCANCODE;
 		if (dev->s_tx_mask)
 			features |= LIRC_CAN_SET_TRANSMITTER_MASK;
@@ -488,6 +558,7 @@ int ir_lirc_register(struct rc_dev *dev)
 	drv->owner = THIS_MODULE;
 
 	INIT_KFIFO(node->rawir);
+	INIT_KFIFO(node->scancodes);
 	init_waitqueue_head(&node->wait_poll);
 
 	drv->minor = lirc_register_driver(drv);
diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index 79c8f40..78f8004 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -215,6 +215,7 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct mce_kbd_dec *data = &dev->raw->mce_kbd;
 	u32 scancode;
 	unsigned long delay;
+	struct lirc_scancode lsc;
 
 	if (!is_timing_event(ev)) {
 		if (ev.reset)
@@ -326,18 +327,23 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			mod_timer(&data->rx_timeout, jiffies + delay);
 			/* Pass data to keyboard buffer parser */
 			ir_mce_kbd_process_keyboard_data(data->idev, scancode);
+			lsc.rc_type = RC_TYPE_MCIR2_KBD;
 			break;
 		case MCIR2_MOUSE_NBITS:
 			scancode = data->body & 0x1fffff;
 			IR_dprintk(1, "mouse data 0x%06x\n", scancode);
 			/* Pass data to mouse buffer parser */
 			ir_mce_kbd_process_mouse_data(data->idev, scancode);
+			lsc.rc_type = RC_TYPE_MCIR2_MSE;
 			break;
 		default:
 			IR_dprintk(1, "not keyboard or mouse data\n");
 			goto out;
 		}
 
+		lsc.scancode = scancode;
+		lsc.flags = 0;
+		ir_lirc_scancode_event(dev, &lsc);
 		data->state = STATE_INACTIVE;
 		input_event(data->idev, EV_MSC, MSC_SCAN, scancode);
 		input_sync(data->idev);
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 3306ce1..b73222a 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -45,12 +45,14 @@ struct lirc_node {
 	struct rc_dev *dev;
 	int carrier_low;
 	DECLARE_KFIFO(rawir, unsigned int, LIRCBUF_SIZE);
+	DECLARE_KFIFO(scancodes, struct lirc_scancode, 32);
 	wait_queue_head_t wait_poll;
 	ktime_t gap_start;
 	u64 gap_duration;
 	bool gap;
 	bool send_timeout_reports;
 	int send_mode;
+	int rec_mode;
 };
 
 struct ir_raw_event_ctrl {
@@ -282,11 +284,14 @@ void ir_raw_init(void);
  */
 #ifdef CONFIG_IR_LIRC_CODEC
 void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev);
+void ir_lirc_scancode_event(struct rc_dev *dev, struct lirc_scancode *lsc);
 int ir_lirc_register(struct rc_dev *dev);
 void ir_lirc_unregister(struct rc_dev *dev);
 #else
 static inline void ir_lirc_raw_event(struct rc_dev *dev,
 				     struct ir_raw_event ev) { }
+static inline void ir_lirc_scancode_event(struct rc_dev *dev,
+					  struct lirc_scancode *lsc) { }
 static inline int ir_lirc_register(struct rc_dev *dev) { return 0; }
 static inline void ir_lirc_unregister(struct rc_dev *dev) { }
 #endif
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 68888f3..08b318f 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -614,6 +614,14 @@ static void ir_timer_keyup(unsigned long cookie)
 void rc_repeat(struct rc_dev *dev)
 {
 	unsigned long flags;
+	struct lirc_scancode sc = {
+		.scancode = dev->last_scancode,
+		.rc_type = dev->last_protocol,
+		.flags = LIRC_SCANCODE_FLAG_REPEAT |
+			(dev->last_toggle ? LIRC_SCANCODE_FLAG_TOGGLE : 0),
+	};
+
+	ir_lirc_scancode_event(dev, &sc);
 
 	spin_lock_irqsave(&dev->keylock, flags);
 
@@ -649,6 +657,12 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
 			  dev->last_protocol != protocol ||
 			  dev->last_scancode != scancode ||
 			  dev->last_toggle   != toggle);
+	struct lirc_scancode sc = {
+		.scancode = scancode, .rc_type = protocol,
+		.flags = toggle ? LIRC_SCANCODE_FLAG_TOGGLE : 0
+	};
+
+	ir_lirc_scancode_event(dev, &sc);
 
 	if (new_event && dev->keypressed)
 		ir_do_keyup(dev, false);
-- 
2.9.3
