Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:51275 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965968AbdIZUOH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 16:14:07 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 19/20] media: lirc: scancode rc devices should have a lirc device too
Date: Tue, 26 Sep 2017 21:13:58 +0100
Message-Id: <d3f44abd15dce3a9a20dafd013b5fa38735f0496.1506455086.git.sean@mess.org>
In-Reply-To: <2d8072bb3a5e80de4a6dd175a358cb2034c12d3e.1506455086.git.sean@mess.org>
References: <2d8072bb3a5e80de4a6dd175a358cb2034c12d3e.1506455086.git.sean@mess.org>
In-Reply-To: <cover.1506455086.git.sean@mess.org>
References: <cover.1506455086.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the lirc interface supports scancodes, RC scancode devices
can also have a lirc device.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c | 34 ++++++++++++++++++++++++++--------
 drivers/media/rc/lirc_dev.c      | 13 ++++++++++---
 drivers/media/rc/rc-main.c       | 14 +++++---------
 3 files changed, 41 insertions(+), 20 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 46c6e05e85a6..eff4e1e40be9 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -292,6 +292,9 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 
 	switch (cmd) {
 	case LIRC_GET_FEATURES:
+		if (dev->driver_type == RC_DRIVER_SCANCODE)
+			val |= LIRC_CAN_REC_SCANCODE;
+
 		if (dev->driver_type == RC_DRIVER_IR_RAW) {
 			val |= LIRC_CAN_REC_MODE2 | LIRC_CAN_REC_SCANCODE;
 			if (dev->rx_resolution)
@@ -335,22 +338,37 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		break;
 
 	case LIRC_SET_REC_MODE:
-		if (dev->driver_type == RC_DRIVER_IR_RAW_TX)
+		switch (dev->driver_type) {
+		case RC_DRIVER_IR_RAW_TX:
 			return -ENOTTY;
-
-		if (!(val == LIRC_MODE_MODE2 || val == LIRC_MODE_SCANCODE))
-			return -EINVAL;
+		case RC_DRIVER_SCANCODE:
+			if (val != LIRC_MODE_SCANCODE)
+				return -EINVAL;
+			break;
+		case RC_DRIVER_IR_RAW:
+			if (!(val == LIRC_MODE_MODE2 ||
+			      val == LIRC_MODE_SCANCODE))
+				return -EINVAL;
+			break;
+		}
 
 		dev->rec_mode = val;
 		dev->poll_mode = val;
 		return 0;
 
 	case LIRC_SET_POLL_MODE:
-		if (dev->driver_type == RC_DRIVER_IR_RAW_TX)
+		switch (dev->driver_type) {
+		case RC_DRIVER_IR_RAW_TX:
 			return -ENOTTY;
-
-		if (val & ~(LIRC_MODE_MODE2 | LIRC_MODE_SCANCODE))
-			return -EINVAL;
+		case RC_DRIVER_SCANCODE:
+			if (val != LIRC_MODE_SCANCODE)
+				return -EINVAL;
+			break;
+		case RC_DRIVER_IR_RAW:
+			if (val & ~(LIRC_MODE_MODE2 | LIRC_MODE_SCANCODE))
+				return -EINVAL;
+			break;
+		}
 
 		dev->poll_mode = val;
 		return 0;
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index df592240f1e5..06bbf421ca00 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -55,9 +55,16 @@ int ir_lirc_register(struct rc_dev *dev)
 	device_initialize(&dev->lirc_dev);
 	dev->lirc_dev.class = lirc_class;
 	dev->lirc_dev.release = lirc_release_device;
-	dev->send_mode = LIRC_MODE_PULSE;
-	dev->rec_mode = LIRC_MODE_MODE2;
-	dev->poll_mode = LIRC_MODE_MODE2;
+
+	if (dev->driver_type == RC_DRIVER_SCANCODE) {
+		dev->send_mode = LIRC_MODE_SCANCODE;
+		dev->rec_mode = LIRC_MODE_SCANCODE;
+		dev->poll_mode = LIRC_MODE_SCANCODE;
+	} else {
+		dev->send_mode = LIRC_MODE_PULSE;
+		dev->rec_mode = LIRC_MODE_MODE2;
+		dev->poll_mode = LIRC_MODE_MODE2;
+	}
 
 	if (dev->driver_type == RC_DRIVER_IR_RAW) {
 		if (kfifo_alloc(&dev->rawir, MAX_IR_EVENT_SIZE, GFP_KERNEL))
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index b58ddc8c1abf..94ad08ee9229 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1784,11 +1784,9 @@ int rc_register_device(struct rc_dev *dev)
 	}
 
 	/* Ensure that the lirc kfifo is setup before we start the thread */
-	if (dev->driver_type != RC_DRIVER_SCANCODE) {
-		rc = ir_lirc_register(dev);
-		if (rc < 0)
-			goto out_rx;
-	}
+	rc = ir_lirc_register(dev);
+	if (rc < 0)
+		goto out_rx;
 
 	if (dev->driver_type == RC_DRIVER_IR_RAW) {
 		rc = ir_raw_event_register(dev);
@@ -1805,8 +1803,7 @@ int rc_register_device(struct rc_dev *dev)
 	return 0;
 
 out_lirc:
-	if (dev->driver_type != RC_DRIVER_SCANCODE)
-		ir_lirc_unregister(dev);
+	ir_lirc_unregister(dev);
 out_rx:
 	rc_free_rx_device(dev);
 out_dev:
@@ -1870,8 +1867,7 @@ void rc_unregister_device(struct rc_dev *dev)
 	 * lirc device should be freed with dev->registered = false, so
 	 * that userspace polling will get notified.
 	 */
-	if (dev->driver_type != RC_DRIVER_SCANCODE)
-		ir_lirc_unregister(dev);
+	ir_lirc_unregister(dev);
 
 	if (!dev->managed_alloc)
 		rc_free_device(dev);
-- 
2.13.5
