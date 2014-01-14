Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57283 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaANWbl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jan 2014 17:31:41 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] rc-core: reuse device numbers
Date: Tue, 14 Jan 2014 17:27:55 -0200
Message-Id: <1389727675-23705-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Before changeset d8b4b5822f51e, the remote controller device numbers
were released when the device were unregistered. That helped to maintain
some sanity, as, when USB devices are replugged, the remote controller
would get the same number.

Restore the same behaviour.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/rc/rc-main.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 46da365c9c84..02e2f38c9c85 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -22,6 +22,10 @@
 #include <linux/module.h>
 #include "rc-core-priv.h"
 
+/* Bitmap to store allocated device numbers from 0 to IRRCV_NUM_DEVICES - 1 */
+#define IRRCV_NUM_DEVICES      256
+DECLARE_BITMAP(ir_core_dev_number, IRRCV_NUM_DEVICES);
+
 /* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
 #define IR_TAB_MIN_SIZE	256
 #define IR_TAB_MAX_SIZE	8192
@@ -1065,10 +1069,9 @@ EXPORT_SYMBOL_GPL(rc_free_device);
 int rc_register_device(struct rc_dev *dev)
 {
 	static bool raw_init = false; /* raw decoders loaded? */
-	static atomic_t devno = ATOMIC_INIT(0);
 	struct rc_map *rc_map;
 	const char *path;
-	int rc;
+	int rc, devno;
 
 	if (!dev || !dev->map_name)
 		return -EINVAL;
@@ -1096,7 +1099,15 @@ int rc_register_device(struct rc_dev *dev)
 	 */
 	mutex_lock(&dev->lock);
 
-	dev->devno = (unsigned long)(atomic_inc_return(&devno) - 1);
+	do {
+		devno = find_first_zero_bit(ir_core_dev_number,
+					    IRRCV_NUM_DEVICES);
+		/* No free device slots */
+		if (devno >= IRRCV_NUM_DEVICES)
+			return -ENOMEM;
+	} while (test_and_set_bit(devno, ir_core_dev_number));
+
+	dev->devno = devno;
 	dev_set_name(&dev->dev, "rc%ld", dev->devno);
 	dev_set_drvdata(&dev->dev, dev);
 	rc = device_add(&dev->dev);
@@ -1186,6 +1197,7 @@ out_dev:
 	device_del(&dev->dev);
 out_unlock:
 	mutex_unlock(&dev->lock);
+	clear_bit(dev->devno, ir_core_dev_number);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(rc_register_device);
@@ -1197,6 +1209,8 @@ void rc_unregister_device(struct rc_dev *dev)
 
 	del_timer_sync(&dev->timer_keyup);
 
+	clear_bit(dev->devno, ir_core_dev_number);
+
 	if (dev->driver_type == RC_DRIVER_IR_RAW)
 		ir_raw_event_unregister(dev);
 
-- 
1.8.3.1

