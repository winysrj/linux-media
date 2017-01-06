Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:57067 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033691AbdAFMtb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Jan 2017 07:49:31 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 7/9] [media] lirc: implement reading scancode
Date: Fri,  6 Jan 2017 12:49:10 +0000
Message-Id: <3c3b4d1a1e05253a550c46b389178726a148ed3a.1483706563.git.sean@mess.org>
In-Reply-To: <cover.1483706563.git.sean@mess.org>
References: <cover.1483706563.git.sean@mess.org>
In-Reply-To: <cover.1483706563.git.sean@mess.org>
References: <cover.1483706563.git.sean@mess.org>
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
 drivers/media/rc/ir-lirc-codec.c | 95 ++++++++++++++++++++++++++++++++--------
 drivers/media/rc/rc-core-priv.h  | 11 +++++
 drivers/media/rc/rc-main.c       | 17 +++++++
 include/media/rc-core.h          |  3 +-
 4 files changed, 107 insertions(+), 19 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 4c7dd03..6a15192 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -231,8 +231,31 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
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
+		case RC_DRIVER_IR_RAW_TX:
+			return -ENOTTY;
+		case RC_DRIVER_SCANCODE:
+			if (val != LIRC_MODE_SCANCODE)
+				return -EINVAL;
+			break;
+		case RC_DRIVER_IR_RAW:
+			if (!(val == LIRC_MODE_SCANCODE ||
+			      val == LIRC_MODE_MODE2))
+				return -EINVAL;
+			break;
+		}
+
+		lirc->rec_mode = val;
+		return 0;
 
-	/* legacy support */
 	case LIRC_GET_SEND_MODE:
 		if (!dev->tx_ir)
 			return -ENOTTY;
@@ -376,31 +399,60 @@ static ssize_t ir_lirc_read_ir(struct file *filep, char __user *buffer,
 	unsigned int copied;
 	int ret;
 
-	if (length % sizeof(unsigned int))
-		return -EINVAL;
-
 	if (!lirc->drv->attached)
 		return -ENODEV;
 
-	do {
-		if (kfifo_is_empty(&lirc->kfifo)) {
-			if (filep->f_flags & O_NONBLOCK)
-				return -EAGAIN;
+	if (lirc->rec_mode == LIRC_MODE_SCANCODE) {
+		struct rc_dev *rcdev = lirc->dev;
+
+		if (length % sizeof(struct lirc_scancode))
+			return -EINVAL;
+
+		do {
+			if (kfifo_is_empty(&rcdev->kfifo)) {
+				if (filep->f_flags & O_NONBLOCK)
+					return -EAGAIN;
 
-			ret = wait_event_interruptible(lirc->wait_poll,
-					!kfifo_is_empty(&lirc->kfifo) ||
+				ret = wait_event_interruptible(lirc->wait_poll,
+					!kfifo_is_empty(&rcdev->kfifo) ||
 					!lirc->drv->attached);
+				if (ret)
+					return ret;
+			}
+
+			if (!lirc->drv->attached)
+				return -ENODEV;
+
+			ret = kfifo_to_user(&rcdev->kfifo, buffer, length,
+					    &copied);
 			if (ret)
 				return ret;
-		}
+		} while (copied == 0);
+	} else {
+		if (length % sizeof(unsigned int))
+			return -EINVAL;
 
-		if (!lirc->drv->attached)
-			return -ENODEV;
+		do {
+			if (kfifo_is_empty(&lirc->kfifo)) {
+				if (filep->f_flags & O_NONBLOCK)
+					return -EAGAIN;
 
-		ret = kfifo_to_user(&lirc->kfifo, buffer, length, &copied);
-		if (ret)
-			return ret;
-	} while (copied == 0);
+				ret = wait_event_interruptible(lirc->wait_poll,
+						!kfifo_is_empty(&lirc->kfifo) ||
+						!lirc->drv->attached);
+				if (ret)
+					return ret;
+			}
+
+			if (!lirc->drv->attached)
+				return -ENODEV;
+
+			ret = kfifo_to_user(&lirc->kfifo, buffer, length,
+					    &copied);
+			if (ret)
+				return ret;
+		} while (copied == 0);
+	}
 
 	return copied;
 }
@@ -410,6 +462,7 @@ static int ir_lirc_open(void *data)
 	struct lirc_codec *lirc = data;
 
 	kfifo_reset_out(&lirc->kfifo);
+	kfifo_reset_out(&lirc->dev->kfifo);
 
 	return 0;
 }
@@ -443,8 +496,14 @@ int ir_lirc_register(struct rc_dev *dev)
 	if (!drv)
 		return -ENOMEM;
 
-	features = LIRC_CAN_REC_MODE2;
+	features = LIRC_CAN_REC_SCANCODE;
+	dev->raw->lirc.rec_mode = LIRC_MODE_SCANCODE;
+	if (dev->driver_type == RC_DRIVER_IR_RAW) {
+		features |= LIRC_CAN_REC_MODE2;
+		dev->raw->lirc.rec_mode = LIRC_MODE_MODE2;
+	}
 	if (dev->tx_ir) {
+		dev->raw->lirc.send_mode = LIRC_MODE_PULSE;
 		features |= LIRC_CAN_SEND_PULSE | LIRC_CAN_SEND_SCANCODE;
 		if (dev->s_tx_mask)
 			features |= LIRC_CAN_SET_TRANSMITTER_MASK;
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 337b9ce..daf2429 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -137,6 +137,7 @@ struct ir_raw_event_ctrl {
 		bool gap;
 		bool send_timeout_reports;
 		int send_mode;
+		int rec_mode;
 	} lirc;
 #endif
 #if IS_ENABLED(CONFIG_IR_XMP_DECODER)
@@ -148,6 +149,16 @@ struct ir_raw_event_ctrl {
 #endif
 };
 
+#if IS_ENABLED(CONFIG_IR_LIRC_CODEC)
+static inline void ir_wakeup_poll(struct ir_raw_event_ctrl *ctrl)
+{
+	if (ctrl)
+		wake_up_poll(&ctrl->lirc.wait_poll, POLLIN);
+}
+#else
+static inline void ir_wakeup_poll(struct ir_raw_event_ctrl *ctrl) {}
+#endif
+
 /* macros for IR decoders */
 static inline bool geq_margin(unsigned d1, unsigned d2, unsigned margin)
 {
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index bfc43e9..037ea45 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -614,6 +614,15 @@ static void ir_timer_keyup(unsigned long cookie)
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
+	if (kfifo_put(&dev->kfifo, sc))
+		ir_wakeup_poll(dev->raw);
 
 	spin_lock_irqsave(&dev->keylock, flags);
 
@@ -649,6 +658,13 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
 			  dev->last_protocol != protocol ||
 			  dev->last_scancode != scancode ||
 			  dev->last_toggle   != toggle);
+	struct lirc_scancode sc = {
+		.scancode = scancode, .rc_type = protocol,
+		.flags = toggle ? LIRC_SCANCODE_FLAG_TOGGLE : 0
+	};
+
+	if (kfifo_put(&dev->kfifo, sc))
+		ir_wakeup_poll(dev->raw);
 
 	if (new_event && dev->keypressed)
 		ir_do_keyup(dev, false);
@@ -1586,6 +1602,7 @@ struct rc_dev *rc_allocate_device(enum rc_driver_type type)
 
 		spin_lock_init(&dev->rc_map.lock);
 		spin_lock_init(&dev->keylock);
+		INIT_KFIFO(dev->kfifo);
 	}
 	mutex_init(&dev->lock);
 
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index f06d9ae..5d7093d 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -18,7 +18,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/kfifo.h>
-#include <linux/time.h>
+#include <linux/lirc.h>
 #include <linux/timer.h>
 #include <media/rc-map.h>
 
@@ -160,6 +160,7 @@ struct rc_dev {
 	struct rc_scancode_filter	scancode_filter;
 	struct rc_scancode_filter	scancode_wakeup_filter;
 	u32				scancode_mask;
+	DECLARE_KFIFO(kfifo, struct lirc_scancode, 32);
 	u32				users;
 	void				*priv;
 	spinlock_t			keylock;
-- 
2.9.3

