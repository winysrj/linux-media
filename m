Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:40713 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965925AbdIZUOH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 16:14:07 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 17/20] media: lirc: implement reading scancode
Date: Tue, 26 Sep 2017 21:13:56 +0100
Message-Id: <7c3a08bfc80c32abdfa9f6ee067c4310082e7156.1506455086.git.sean@mess.org>
In-Reply-To: <2d8072bb3a5e80de4a6dd175a358cb2034c12d3e.1506455086.git.sean@mess.org>
References: <2d8072bb3a5e80de4a6dd175a358cb2034c12d3e.1506455086.git.sean@mess.org>
In-Reply-To: <cover.1506455086.git.sean@mess.org>
References: <cover.1506455086.git.sean@mess.org>
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
			scancode.rc_proto, scancode.scancode,
			!!(scancode.flags & LIRC_SCANCODE_FLAG_TOGGLE),
			!!(scancode.flags & LIRC_SCANCODE_FLAG_REPEAT));
	}
	close(fd);
}

Note that the translated KEY_* is not included, that information is
published to the input device.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c      | 87 ++++++++++++++++++++++++++++++-----
 drivers/media/rc/ir-mce_kbd-decoder.c |  6 +++
 drivers/media/rc/lirc_dev.c           | 12 +++++
 drivers/media/rc/rc-core-priv.h       |  3 ++
 drivers/media/rc/rc-main.c            | 14 ++++++
 include/media/rc-core.h               |  5 ++
 6 files changed, 116 insertions(+), 11 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index fb5df6c8208f..43936128e303 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -88,6 +88,15 @@ void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev)
 	wake_up_poll(&dev->wait_poll, POLLIN | POLLRDNORM);
 }
 
+void ir_lirc_scancode_event(struct rc_dev *dev, struct lirc_scancode *lsc)
+{
+	lsc->timestamp = ktime_get_ns();
+
+	if (kfifo_put(&dev->scancodes, *lsc))
+		wake_up_poll(&dev->wait_poll, POLLIN | POLLRDNORM);
+}
+EXPORT_SYMBOL_GPL(ir_lirc_scancode_event);
+
 static int ir_lirc_open(struct inode *inode, struct file *file)
 {
 	struct rc_dev *dev = container_of(inode->i_cdev, struct rc_dev,
@@ -114,6 +123,8 @@ static int ir_lirc_open(struct inode *inode, struct file *file)
 
 	if (dev->driver_type == RC_DRIVER_IR_RAW)
 		kfifo_reset_out(&dev->rawir);
+	if (dev->driver_type != RC_DRIVER_IR_RAW_TX)
+		kfifo_reset_out(&dev->scancodes);
 
 	dev->lirc_open++;
 	file->private_data = dev;
@@ -282,7 +293,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	switch (cmd) {
 	case LIRC_GET_FEATURES:
 		if (dev->driver_type == RC_DRIVER_IR_RAW) {
-			val |= LIRC_CAN_REC_MODE2;
+			val |= LIRC_CAN_REC_MODE2 | LIRC_CAN_REC_SCANCODE;
 			if (dev->rx_resolution)
 				val |= LIRC_CAN_GET_REC_RESOLUTION;
 		}
@@ -320,15 +331,17 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		if (dev->driver_type == RC_DRIVER_IR_RAW_TX)
 			return -ENOTTY;
 
-		val = LIRC_MODE_MODE2;
+		val = dev->rec_mode;
 		break;
 
 	case LIRC_SET_REC_MODE:
 		if (dev->driver_type == RC_DRIVER_IR_RAW_TX)
 			return -ENOTTY;
 
-		if (val != LIRC_MODE_MODE2)
+		if (!(val == LIRC_MODE_MODE2 || val == LIRC_MODE_SCANCODE))
 			return -EINVAL;
+
+		dev->rec_mode = val;
 		return 0;
 
 	case LIRC_GET_SEND_MODE:
@@ -465,16 +478,21 @@ static unsigned int ir_lirc_poll(struct file *file,
 
 	poll_wait(file, &rcdev->wait_poll, wait);
 
-	if (!rcdev->registered)
+	if (!rcdev->registered) {
 		events = POLLHUP | POLLERR;
-	else if (!kfifo_is_empty(&rcdev->rawir))
-		events = POLLIN | POLLRDNORM;
+	} else if (rcdev->rec_mode == LIRC_MODE_SCANCODE) {
+		if (!kfifo_is_empty(&rcdev->scancodes))
+			events = POLLIN | POLLRDNORM;
+	} else if (rcdev->rec_mode == LIRC_MODE_MODE2) {
+		if (!kfifo_is_empty(&rcdev->rawir))
+			events = POLLIN | POLLRDNORM;
+	}
 
 	return events;
 }
 
-static ssize_t ir_lirc_read(struct file *file, char __user *buffer,
-			    size_t length, loff_t *ppos)
+static ssize_t ir_lirc_read_mode2(struct file *file, char __user *buffer,
+				  size_t length)
 {
 	struct rc_dev *rcdev = file->private_data;
 	unsigned int copied;
@@ -483,9 +501,6 @@ static ssize_t ir_lirc_read(struct file *file, char __user *buffer,
 	if (length < sizeof(unsigned int) || length % sizeof(unsigned int))
 		return -EINVAL;
 
-	if (!rcdev->registered)
-		return -ENODEV;
-
 	do {
 		if (kfifo_is_empty(&rcdev->rawir)) {
 			if (file->f_flags & O_NONBLOCK)
@@ -511,6 +526,56 @@ static ssize_t ir_lirc_read(struct file *file, char __user *buffer,
 	return copied;
 }
 
+static ssize_t ir_lirc_read_scancode(struct file *file, char __user *buffer,
+				     size_t length)
+{
+	struct rc_dev *rcdev = file->private_data;
+	unsigned int copied;
+	int ret;
+
+	if (length < sizeof(struct lirc_scancode) ||
+	    length % sizeof(struct lirc_scancode))
+		return -EINVAL;
+
+	do {
+		if (kfifo_is_empty(&rcdev->scancodes)) {
+			if (file->f_flags & O_NONBLOCK)
+				return -EAGAIN;
+
+			ret = wait_event_interruptible(rcdev->wait_poll,
+					!kfifo_is_empty(&rcdev->scancodes) ||
+					!rcdev->registered);
+			if (ret)
+				return ret;
+		}
+
+		if (!rcdev->registered)
+			return -ENODEV;
+
+		mutex_lock(&rcdev->lock);
+		ret = kfifo_to_user(&rcdev->scancodes, buffer, length, &copied);
+		mutex_unlock(&rcdev->lock);
+		if (ret)
+			return ret;
+	} while (copied == 0);
+
+	return copied;
+}
+
+static ssize_t ir_lirc_read(struct file *file, char __user *buffer,
+			    size_t length, loff_t *ppos)
+{
+	struct rc_dev *rcdev = file->private_data;
+
+	if (!rcdev->registered)
+		return -ENODEV;
+
+	if (rcdev->rec_mode == LIRC_MODE_MODE2)
+		return ir_lirc_read_mode2(file, buffer, length);
+	else /* LIRC_MODE_SCANCODE */
+		return ir_lirc_read_scancode(file, buffer, length);
+}
+
 const struct file_operations lirc_fops = {
 	.owner		= THIS_MODULE,
 	.write		= ir_lirc_transmit_ir,
diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index efa3b735dcc4..24daaa4f746f 100644
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
+			lsc.rc_proto = RC_PROTO_MCIR2_KBD;
 			break;
 		case MCIR2_MOUSE_NBITS:
 			scancode = data->body & 0x1fffff;
 			IR_dprintk(1, "mouse data 0x%06x\n", scancode);
 			/* Pass data to mouse buffer parser */
 			ir_mce_kbd_process_mouse_data(data->idev, scancode);
+			lsc.rc_proto = RC_PROTO_MCIR2_MSE;
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
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 155a4de249a0..e5672b0a6dc4 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -42,6 +42,8 @@ static void lirc_release_device(struct device *ld)
 
 	if (rcdev->driver_type == RC_DRIVER_IR_RAW)
 		kfifo_free(&rcdev->rawir);
+	if (rcdev->driver_type != RC_DRIVER_IR_RAW_TX)
+		kfifo_free(&rcdev->scancodes);
 
 	put_device(&rcdev->dev);
 }
@@ -54,12 +56,20 @@ int ir_lirc_register(struct rc_dev *dev)
 	dev->lirc_dev.class = lirc_class;
 	dev->lirc_dev.release = lirc_release_device;
 	dev->send_mode = LIRC_MODE_PULSE;
+	dev->rec_mode = LIRC_MODE_MODE2;
 
 	if (dev->driver_type == RC_DRIVER_IR_RAW) {
 		if (kfifo_alloc(&dev->rawir, MAX_IR_EVENT_SIZE, GFP_KERNEL))
 			return -ENOMEM;
 	}
 
+	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
+		if (kfifo_alloc(&dev->scancodes, 32, GFP_KERNEL)) {
+			kfifo_free(&dev->rawir);
+			return -ENOMEM;
+		}
+	}
+
 	init_waitqueue_head(&dev->wait_poll);
 
 	minor = ida_simple_get(&lirc_ida, 0, RC_DEV_MAX, GFP_KERNEL);
@@ -90,6 +100,8 @@ int ir_lirc_register(struct rc_dev *dev)
 out_kfifo:
 	if (dev->driver_type == RC_DRIVER_IR_RAW)
 		kfifo_free(&dev->rawir);
+	if (dev->driver_type != RC_DRIVER_IR_RAW_TX)
+		kfifo_free(&dev->scancodes);
 	return err;
 }
 
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 10fce47c255d..9630dd52700d 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -285,6 +285,7 @@ void ir_raw_init(void);
 int lirc_dev_init(void);
 void lirc_dev_exit(void);
 void ir_lirc_raw_event(struct rc_dev *dev, struct ir_raw_event ev);
+void ir_lirc_scancode_event(struct rc_dev *dev, struct lirc_scancode *lsc);
 int ir_lirc_register(struct rc_dev *dev);
 void ir_lirc_unregister(struct rc_dev *dev);
 
@@ -294,6 +295,8 @@ static inline int lirc_dev_init(void) { return 0; }
 static inline void lirc_dev_exit(void) {}
 static inline void ir_lirc_raw_event(struct rc_dev *dev,
 				     struct ir_raw_event ev) { }
+static inline void ir_lirc_scancode_event(struct rc_dev *dev,
+					  struct lirc_scancode *lsc) { }
 static inline int ir_lirc_register(struct rc_dev *dev) { return 0; }
 static inline void ir_lirc_unregister(struct rc_dev *dev) { }
 #endif
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 1103930a3a0a..b58ddc8c1abf 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -615,6 +615,14 @@ static void ir_do_keyup(struct rc_dev *dev, bool sync)
 void rc_keyup(struct rc_dev *dev)
 {
 	unsigned long flags;
+	struct lirc_scancode sc = {
+		.scancode = dev->last_scancode,
+		.rc_proto = dev->last_protocol,
+		.flags = LIRC_SCANCODE_FLAG_REPEAT |
+			(dev->last_toggle ? LIRC_SCANCODE_FLAG_TOGGLE : 0),
+	};
+
+	ir_lirc_scancode_event(dev, &sc);
 
 	spin_lock_irqsave(&dev->keylock, flags);
 	ir_do_keyup(dev, true);
@@ -697,6 +705,12 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_proto protocol,
 			  dev->last_protocol != protocol ||
 			  dev->last_scancode != scancode ||
 			  dev->last_toggle   != toggle);
+	struct lirc_scancode sc = {
+		.scancode = scancode, .rc_proto = protocol,
+		.flags = toggle ? LIRC_SCANCODE_FLAG_TOGGLE : 0
+	};
+
+	ir_lirc_scancode_event(dev, &sc);
 
 	if (new_event && dev->keypressed)
 		ir_do_keyup(dev, false);
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index e3db561a9bd7..86f62e75dcab 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -126,9 +126,12 @@ enum rc_filter_type {
  * @gap: true if we're in a gap
  * @send_timeout_reports: report timeouts in lirc raw IR.
  * @rawir: queue for incoming raw IR
+ * @scancodes: queue for incoming decoded scancodes
  * @wait_poll: poll struct for lirc device
  * @send_mode: lirc mode for sending, either LIRC_MODE_SCANCODE or
  *	LIRC_MODE_PULSE
+ * @rec_mode: lirc mode for recording, either LIRC_MODE_SCANCODE or
+ *	LIRC_MODE_MODE2
  * @registered: set to true by rc_register_device(), false by
  *	rc_unregister_device
  * @change_protocol: allow changing the protocol used on hardware decoders
@@ -201,8 +204,10 @@ struct rc_dev {
 	bool				gap;
 	bool				send_timeout_reports;
 	DECLARE_KFIFO_PTR(rawir, unsigned int);
+	DECLARE_KFIFO_PTR(scancodes, struct lirc_scancode);
 	wait_queue_head_t		wait_poll;
 	u8				send_mode;
+	u8				rec_mode;
 #endif
 	bool				registered;
 	int				(*change_protocol)(struct rc_dev *dev, u64 *rc_proto);
-- 
2.13.5
