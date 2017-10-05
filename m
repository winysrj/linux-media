Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:39977 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751423AbdJEIpl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 04:45:41 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 22/25] media: lirc: scancode rc devices should have a lirc device too
Date: Thu,  5 Oct 2017 09:45:24 +0100
Message-Id: <4ea86e683f43a1f277e3966e678c49267baa829d.1507192752.git.sean@mess.org>
In-Reply-To: <88e30a50734f7d132ac8a6234acc7335cbbb3a56.1507192751.git.sean@mess.org>
References: <88e30a50734f7d132ac8a6234acc7335cbbb3a56.1507192751.git.sean@mess.org>
In-Reply-To: <cover.1507192751.git.sean@mess.org>
References: <cover.1507192751.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the lirc interface supports scancodes, RC scancode devices
can also have a lirc device. The only feature they will have
enabled is LIRC_CAN_REC_SCANCODE.

Note that CEC devices will have no lirc device yet, as this is
still under discussion.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c | 34 ++++++++++++++++++++++++++--------
 drivers/media/rc/lirc_dev.c      |  9 +++++++--
 drivers/media/rc/rc-main.c       |  6 +++---
 3 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 1f1811c080af..c2154d54d631 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -303,6 +303,9 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 
 	switch (cmd) {
 	case LIRC_GET_FEATURES:
+		if (dev->driver_type == RC_DRIVER_SCANCODE)
+			val |= LIRC_CAN_REC_SCANCODE;
+
 		if (dev->driver_type == RC_DRIVER_IR_RAW) {
 			val |= LIRC_CAN_REC_MODE2 | LIRC_CAN_REC_SCANCODE;
 			if (dev->rx_resolution)
@@ -346,22 +349,37 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
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
index aee7cbb04439..6fc1ec257153 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -61,8 +61,13 @@ int ir_lirc_register(struct rc_dev *dev)
 	else
 		dev->send_mode = LIRC_MODE_PULSE;
 
-	dev->rec_mode = LIRC_MODE_MODE2;
-	dev->poll_mode = LIRC_MODE_MODE2;
+	if (dev->driver_type == RC_DRIVER_SCANCODE) {
+		dev->rec_mode = LIRC_MODE_SCANCODE;
+		dev->poll_mode = LIRC_MODE_SCANCODE;
+	} else {
+		dev->rec_mode = LIRC_MODE_MODE2;
+		dev->poll_mode = LIRC_MODE_MODE2;
+	}
 
 	if (dev->driver_type == RC_DRIVER_IR_RAW) {
 		if (kfifo_alloc(&dev->rawir, MAX_IR_EVENT_SIZE, GFP_KERNEL))
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 7f137bbb6eee..c1eae5c10c8d 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1794,7 +1794,7 @@ int rc_register_device(struct rc_dev *dev)
 	}
 
 	/* Ensure that the lirc kfifo is setup before we start the thread */
-	if (dev->driver_type != RC_DRIVER_SCANCODE) {
+	if (dev->allowed_protocols != RC_PROTO_BIT_CEC) {
 		rc = ir_lirc_register(dev);
 		if (rc < 0)
 			goto out_rx;
@@ -1815,7 +1815,7 @@ int rc_register_device(struct rc_dev *dev)
 	return 0;
 
 out_lirc:
-	if (dev->driver_type != RC_DRIVER_SCANCODE)
+	if (dev->allowed_protocols != RC_PROTO_BIT_CEC)
 		ir_lirc_unregister(dev);
 out_rx:
 	rc_free_rx_device(dev);
@@ -1876,7 +1876,7 @@ void rc_unregister_device(struct rc_dev *dev)
 	 * lirc device should be freed with dev->registered = false, so
 	 * that userspace polling will get notified.
 	 */
-	if (dev->driver_type != RC_DRIVER_SCANCODE)
+	if (dev->allowed_protocols != RC_PROTO_BIT_CEC)
 		ir_lirc_unregister(dev);
 
 	device_del(&dev->dev);
-- 
2.13.6
