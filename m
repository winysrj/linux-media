Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:33347 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932069AbdJJHSr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 03:18:47 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 23/26] media: lirc: scancode rc devices should have a lirc device too
Date: Tue, 10 Oct 2017 08:18:45 +0100
Message-Id: <90f04ac86e35cd93a2c024f2dadba3818428e198.1507618841.git.sean@mess.org>
In-Reply-To: <cover.1507618840.git.sean@mess.org>
References: <cover.1507618840.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the lirc interface supports scancodes, RC scancode devices
can also have a lirc device. The only feature they will have
enabled is LIRC_CAN_REC_SCANCODE.

Note that CEC devices have no lirc device, since they can be controlled
from their /dev/cecN chardev.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c | 34 ++++++++++++++++++++++++++--------
 drivers/media/rc/lirc_dev.c      |  9 +++++++--
 drivers/media/rc/rc-main.c       |  6 +++---
 3 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 559a4049151e..6f1d9dd766d5 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -309,6 +309,9 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 
 	switch (cmd) {
 	case LIRC_GET_FEATURES:
+		if (dev->driver_type == RC_DRIVER_SCANCODE)
+			val |= LIRC_CAN_REC_SCANCODE;
+
 		if (dev->driver_type == RC_DRIVER_IR_RAW) {
 			val |= LIRC_CAN_REC_MODE2 | LIRC_CAN_REC_SCANCODE;
 			if (dev->rx_resolution)
@@ -352,22 +355,37 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
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
 
 	case LIRC_SET_POLL_MODES:
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
index dae427e25d71..9f39bc074837 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1810,7 +1810,7 @@ int rc_register_device(struct rc_dev *dev)
 	}
 
 	/* Ensure that the lirc kfifo is setup before we start the thread */
-	if (dev->driver_type != RC_DRIVER_SCANCODE) {
+	if (dev->allowed_protocols != RC_PROTO_BIT_CEC) {
 		rc = ir_lirc_register(dev);
 		if (rc < 0)
 			goto out_rx;
@@ -1831,7 +1831,7 @@ int rc_register_device(struct rc_dev *dev)
 	return 0;
 
 out_lirc:
-	if (dev->driver_type != RC_DRIVER_SCANCODE)
+	if (dev->allowed_protocols != RC_PROTO_BIT_CEC)
 		ir_lirc_unregister(dev);
 out_rx:
 	rc_free_rx_device(dev);
@@ -1892,7 +1892,7 @@ void rc_unregister_device(struct rc_dev *dev)
 	 * lirc device should be freed with dev->registered = false, so
 	 * that userspace polling will get notified.
 	 */
-	if (dev->driver_type != RC_DRIVER_SCANCODE)
+	if (dev->allowed_protocols != RC_PROTO_BIT_CEC)
 		ir_lirc_unregister(dev);
 
 	device_del(&dev->dev);
-- 
2.13.6
