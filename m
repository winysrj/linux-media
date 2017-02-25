Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:33267 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751615AbdBYLwv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Feb 2017 06:52:51 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 18/19] [media] lirc: scancode rc devices should have a lirc device too
Date: Sat, 25 Feb 2017 11:51:33 +0000
Message-Id: <e6392194341869bd5a0c86eaee5e870b28f9fe73.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the lirc interface supports scancodes, RC scancode devices
can also have a lirc device, except for cec devices which have their
own /dev/cecN interface.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 08b318f..438362b 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1791,7 +1791,7 @@ int rc_register_device(struct rc_dev *dev)
 			goto out_rx;
 	}
 
-	if (dev->driver_type != RC_DRIVER_SCANCODE) {
+	if (dev->allowed_protocols != RC_BIT_CEC) {
 		rc = ir_lirc_register(dev);
 		if (rc < 0)
 			goto out_raw;
@@ -1856,7 +1856,7 @@ void rc_unregister_device(struct rc_dev *dev)
 	if (dev->driver_type == RC_DRIVER_IR_RAW)
 		ir_raw_event_unregister(dev);
 
-	if (dev->driver_type != RC_DRIVER_SCANCODE)
+	if (dev->allowed_protocols != RC_BIT_CEC)
 		ir_lirc_unregister(dev);
 
 	rc_free_rx_device(dev);
-- 
2.9.3
