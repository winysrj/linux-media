Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:48795 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751126AbdBWK3d (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Feb 2017 05:29:33 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] [media] rc: protocol is not set on register for raw IR devices
Date: Thu, 23 Feb 2017 10:29:01 +0000
Message-Id: <1487845741-21924-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ir_raw_event_register() sets up change_protocol(), and without that set,
rc_setup_rx_device() does not set the protocol for the device on register.

The standard udev rules run ir-keytable, which writes to the protocols
file again, which hides this problem.

Fixes: 7ff2c2b ("[media] rc-main: split setup and unregister functions")

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-main.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index a158b32..d845336 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1781,12 +1781,6 @@ int rc_register_device(struct rc_dev *dev)
 		dev->input_name ?: "Unspecified device", path ?: "N/A");
 	kfree(path);
 
-	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
-		rc = rc_setup_rx_device(dev);
-		if (rc)
-			goto out_dev;
-	}
-
 	if (dev->driver_type == RC_DRIVER_IR_RAW ||
 	    dev->driver_type == RC_DRIVER_IR_RAW_TX) {
 		if (!raw_init) {
@@ -1795,7 +1789,13 @@ int rc_register_device(struct rc_dev *dev)
 		}
 		rc = ir_raw_event_register(dev);
 		if (rc < 0)
-			goto out_rx;
+			goto out_dev;
+	}
+
+	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
+		rc = rc_setup_rx_device(dev);
+		if (rc)
+			goto out_raw;
 	}
 
 	/* Allow the RC sysfs nodes to be accessible */
@@ -1807,8 +1807,8 @@ int rc_register_device(struct rc_dev *dev)
 
 	return 0;
 
-out_rx:
-	rc_free_rx_device(dev);
+out_raw:
+	ir_raw_event_unregister(dev);
 out_dev:
 	device_del(&dev->dev);
 out_unlock:
-- 
2.9.3
