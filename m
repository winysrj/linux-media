Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:40249 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032869AbeEXLGU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 07:06:20 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: stable@vger.kernel.org, #@mess.org, v4.16+@mess.org
Subject: [PATCH] media: rc: ensure input/lirc device can be opened after register
Date: Thu, 24 May 2018 12:06:18 +0100
Message-Id: <20180524110618.15558-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit cb84343fced1 ("media: lirc: do not call close() or open() on
unregistered devices") rc_open() will return -ENODEV if rcdev->registered
is false. Ensure this is set before we register the input device and the
lirc device, else we have a short window where the neither the lirc or
input device can be opened.

Fixes: cb84343fced1 ("media: lirc: do not call close() or open() on unregistered devices")
Cc: stable@vger.kernel.org # v4.16+
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index b7071bde670a..2e222d9ee01f 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1862,6 +1862,8 @@ int rc_register_device(struct rc_dev *dev)
 		 dev->device_name ?: "Unspecified device", path ?: "N/A");
 	kfree(path);
 
+	dev->registered = true;
+
 	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
 		rc = rc_setup_rx_device(dev);
 		if (rc)
@@ -1881,8 +1883,6 @@ int rc_register_device(struct rc_dev *dev)
 			goto out_lirc;
 	}
 
-	dev->registered = true;
-
 	dev_dbg(&dev->dev, "Registered rc%u (driver: %s)\n", dev->minor,
 		dev->driver_name ? dev->driver_name : "unknown");
 
-- 
2.17.0
