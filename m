Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:46667 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750937AbeC0RWR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 13:22:17 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: rc: report receiver and transmitter type on device register
Date: Tue, 27 Mar 2018 18:22:15 +0100
Message-Id: <20180327172215.22906-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On the raspberry pi, we might have two lirc devices; one for sending and
one for receiving. This change makes it much more apparent which one
is which.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/media/uapi/rc/lirc-dev-intro.rst |  2 +-
 drivers/media/rc/lirc_dev.c                    | 22 ++++++++++++++++++++--
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/uapi/rc/lirc-dev-intro.rst b/Documentation/media/uapi/rc/lirc-dev-intro.rst
index 698e4f80270e..11516c8bff62 100644
--- a/Documentation/media/uapi/rc/lirc-dev-intro.rst
+++ b/Documentation/media/uapi/rc/lirc-dev-intro.rst
@@ -18,7 +18,7 @@ Example dmesg output upon a driver registering w/LIRC:
 .. code-block:: none
 
     $ dmesg |grep lirc_dev
-    rc rc0: lirc_dev: driver mceusb registered at minor = 0
+    rc rc0: lirc_dev: driver mceusb registered at minor = 0, raw IR receiver, raw IR transmitter
 
 What you should see for a chardev:
 
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 19660f9757e1..cc58ed78462f 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -742,6 +742,7 @@ static void lirc_release_device(struct device *ld)
 
 int ir_lirc_register(struct rc_dev *dev)
 {
+	const char *rx_type, *tx_type;
 	int err, minor;
 
 	minor = ida_simple_get(&lirc_ida, 0, RC_DEV_MAX, GFP_KERNEL);
@@ -766,8 +767,25 @@ int ir_lirc_register(struct rc_dev *dev)
 
 	get_device(&dev->dev);
 
-	dev_info(&dev->dev, "lirc_dev: driver %s registered at minor = %d",
-		 dev->driver_name, minor);
+	switch (dev->driver_type) {
+	case RC_DRIVER_SCANCODE:
+		rx_type = "scancode";
+		break;
+	case RC_DRIVER_IR_RAW:
+		rx_type = "raw IR";
+		break;
+	default:
+		rx_type = "no";
+		break;
+	}
+
+	if (dev->tx_ir)
+		tx_type = "raw IR";
+	else
+		tx_type = "no";
+
+	dev_info(&dev->dev, "lirc_dev: driver %s registered at minor = %d, %s receiver, %s transmitter",
+		 dev->driver_name, minor, rx_type, tx_type);
 
 	return 0;
 
-- 
2.14.3
