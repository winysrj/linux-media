Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40294 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbaDCXci (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:32:38 -0400
Subject: [PATCH 16/49] rc-core: use an IDA rather than a bitmap
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:32:36 +0200
Message-ID: <20140403233236.27099.65581.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch changes rc-core to use an IDA rather than a bitmap to assign
unique numbers to each rc device. This is in preparation for introducing
rc-core chardevs.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-raw.c  |    2 +-
 drivers/media/rc/rc-main.c |   40 ++++++++++++++++++++--------------------
 include/media/rc-core.h    |    4 ++--
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 2a7f858..aed2997 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -271,7 +271,7 @@ int ir_raw_event_register(struct rc_dev *dev)
 
 	spin_lock_init(&dev->raw->lock);
 	dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
-				       "rc%ld", dev->devno);
+				       "rc%u", dev->minor);
 
 	if (IS_ERR(dev->raw->thread)) {
 		rc = PTR_ERR(dev->raw->thread);
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 2788102..42268f3 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -18,17 +18,15 @@
 #include <linux/input.h>
 #include <linux/leds.h>
 #include <linux/slab.h>
+#include <linux/idr.h>
 #include <linux/device.h>
 #include <linux/module.h>
 #include "rc-core-priv.h"
 
-/* Bitmap to store allocated device numbers from 0 to IRRCV_NUM_DEVICES - 1 */
-#define IRRCV_NUM_DEVICES      256
-static DECLARE_BITMAP(ir_core_dev_number, IRRCV_NUM_DEVICES);
-
 /* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
 #define IR_TAB_MIN_SIZE	256
 #define IR_TAB_MAX_SIZE	8192
+#define RC_DEV_MAX	256
 
 /* FIXME: IR_KEYPRESS_TIMEOUT should be protocol specific */
 #define IR_KEYPRESS_TIMEOUT 250
@@ -38,6 +36,9 @@ static LIST_HEAD(rc_map_list);
 static DEFINE_SPINLOCK(rc_map_lock);
 static struct led_trigger *led_feedback;
 
+/* Used to keep track of rc devices */
+static DEFINE_IDA(rc_ida);
+
 static struct rc_map_list *seek_rc_map(const char *name)
 {
 	struct rc_map_list *map = NULL;
@@ -1442,7 +1443,9 @@ int rc_register_device(struct rc_dev *dev)
 	static bool raw_init = false; /* raw decoders loaded? */
 	struct rc_map *rc_map;
 	const char *path;
-	int rc, devno, attr = 0;
+	int attr = 0;
+	int minor;
+	int rc;
 
 	if (!dev || !dev->map_name)
 		return -EINVAL;
@@ -1462,13 +1465,13 @@ int rc_register_device(struct rc_dev *dev)
 	if (dev->close)
 		dev->input_dev->close = ir_close;
 
-	do {
-		devno = find_first_zero_bit(ir_core_dev_number,
-					    IRRCV_NUM_DEVICES);
-		/* No free device slots */
-		if (devno >= IRRCV_NUM_DEVICES)
-			return -ENOMEM;
-	} while (test_and_set_bit(devno, ir_core_dev_number));
+	minor = ida_simple_get(&rc_ida, 0, RC_DEV_MAX, GFP_KERNEL);
+	if (minor < 0)
+		return minor;
+
+	dev->minor = minor;
+	dev_set_name(&dev->dev, "rc%u", dev->minor);
+	dev_set_drvdata(&dev->dev, dev);
 
 	dev->dev.groups = dev->sysfs_groups;
 	dev->sysfs_groups[attr++] = &rc_dev_protocol_attr_grp;
@@ -1488,9 +1491,6 @@ int rc_register_device(struct rc_dev *dev)
 	 */
 	mutex_lock(&dev->lock);
 
-	dev->devno = devno;
-	dev_set_name(&dev->dev, "rc%ld", dev->devno);
-	dev_set_drvdata(&dev->dev, dev);
 	rc = device_add(&dev->dev);
 	if (rc)
 		goto out_unlock;
@@ -1558,8 +1558,8 @@ int rc_register_device(struct rc_dev *dev)
 
 	mutex_unlock(&dev->lock);
 
-	IR_dprintk(1, "Registered rc%ld (driver: %s, remote: %s, mode %s)\n",
-		   dev->devno,
+	IR_dprintk(1, "Registered rc%u (driver: %s, remote: %s, mode %s)\n",
+		   dev->minor,
 		   dev->driver_name ? dev->driver_name : "unknown",
 		   rc_map->name ? rc_map->name : "unknown",
 		   dev->driver_type == RC_DRIVER_IR_RAW ? "raw" : "cooked");
@@ -1578,7 +1578,7 @@ out_dev:
 	device_del(&dev->dev);
 out_unlock:
 	mutex_unlock(&dev->lock);
-	clear_bit(dev->devno, ir_core_dev_number);
+	ida_simple_remove(&rc_ida, minor);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(rc_register_device);
@@ -1590,8 +1590,6 @@ void rc_unregister_device(struct rc_dev *dev)
 
 	del_timer_sync(&dev->timer_keyup);
 
-	clear_bit(dev->devno, ir_core_dev_number);
-
 	if (dev->driver_type == RC_DRIVER_IR_RAW)
 		ir_raw_event_unregister(dev);
 
@@ -1604,6 +1602,8 @@ void rc_unregister_device(struct rc_dev *dev)
 
 	device_del(&dev->dev);
 
+	ida_simple_remove(&rc_ida, dev->minor);
+
 	rc_free_device(dev);
 }
 
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 5a082e7..ca3d836 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -87,7 +87,7 @@ enum rc_filter_type {
  * @rc_map: current scan/key table
  * @lock: used to ensure we've filled in all protocol details before
  *	anyone can call show_protocols or store_protocols
- * @devno: unique remote control device number
+ * @minor: unique minor remote control device number
  * @raw: additional data for raw pulse/space devices
  * @input_dev: the input child device used to communicate events to userspace
  * @driver_type: specifies if protocol decoding is done in hardware or software
@@ -147,7 +147,7 @@ struct rc_dev {
 	const char			*map_name;
 	struct rc_map			rc_map;
 	struct mutex			lock;
-	unsigned long			devno;
+	unsigned int			minor;
 	struct ir_raw_event_ctrl	*raw;
 	struct input_dev		*input_dev;
 	enum rc_driver_type		driver_type;

