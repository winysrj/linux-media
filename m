Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49664 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbcCBLPw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2016 06:15:52 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
	James Hogan <james@albanarts.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH] [media] rc-core: allow calling rc_open with device not initialized
Date: Wed,  2 Mar 2016 08:15:28 -0300
Message-Id: <f7275a1d6b799860c479cd616af0933b40d70136.1456917323.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The device initialization completes only after calling
input_register_device(). However, rc_open() can be called while
the device is being registered by the input/evdev core. So, we
can't expect that rc_dev->initialized to be true.

Change the logic to don't require initialized == true at rc_open
and change the type of initialized to be atomic.

this way, we can check for it earlier where it is really needed,
without needing to lock the mutex just for testing it.

Reported-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/rc/rc-main.c | 47 +++++++++++++++++++++-------------------------
 include/media/rc-core.h    |  4 ++--
 2 files changed, 23 insertions(+), 28 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index dcf20d9cbe09..4e9bbe735ae9 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -13,6 +13,7 @@
  */
 
 #include <media/rc-core.h>
+#include <linux/atomic.h>
 #include <linux/spinlock.h>
 #include <linux/delay.h>
 #include <linux/input.h>
@@ -723,10 +724,6 @@ int rc_open(struct rc_dev *rdev)
 		return -EINVAL;
 
 	mutex_lock(&rdev->lock);
-	if (!rdev->initialized) {
-		rval = -EINVAL;
-		goto unlock;
-	}
 
 	if (!rdev->users++ && rdev->open != NULL)
 		rval = rdev->open(rdev);
@@ -734,7 +731,6 @@ int rc_open(struct rc_dev *rdev)
 	if (rval)
 		rdev->users--;
 
-unlock:
 	mutex_unlock(&rdev->lock);
 
 	return rval;
@@ -879,11 +875,10 @@ static ssize_t show_protocols(struct device *device,
 	if (!dev)
 		return -EINVAL;
 
+	if (!atomic_read(&dev->initialized))
+		return -ERESTARTSYS;
+
 	mutex_lock(&dev->lock);
-	if (!dev->initialized) {
-		mutex_unlock(&dev->lock);
-		return -EINVAL;
-	}
 
 	if (fattr->type == RC_FILTER_NORMAL) {
 		enabled = dev->enabled_protocols;
@@ -1064,6 +1059,9 @@ static ssize_t store_protocols(struct device *device,
 	if (!dev)
 		return -EINVAL;
 
+	if (!atomic_read(&dev->initialized))
+		return -ERESTARTSYS;
+
 	if (fattr->type == RC_FILTER_NORMAL) {
 		IR_dprintk(1, "Normal protocol change requested\n");
 		current_protocols = &dev->enabled_protocols;
@@ -1084,10 +1082,6 @@ static ssize_t store_protocols(struct device *device,
 	}
 
 	mutex_lock(&dev->lock);
-	if (!dev->initialized) {
-		rc = -EINVAL;
-		goto out;
-	}
 
 	old_protocols = *current_protocols;
 	new_protocols = old_protocols;
@@ -1168,11 +1162,10 @@ static ssize_t show_filter(struct device *device,
 	if (!dev)
 		return -EINVAL;
 
+	if (!atomic_read(&dev->initialized))
+		return -ERESTARTSYS;
+
 	mutex_lock(&dev->lock);
-	if (!dev->initialized) {
-		mutex_unlock(&dev->lock);
-		return -EINVAL;
-	}
 
 	if (fattr->type == RC_FILTER_NORMAL)
 		filter = &dev->scancode_filter;
@@ -1223,6 +1216,9 @@ static ssize_t store_filter(struct device *device,
 	if (!dev)
 		return -EINVAL;
 
+	if (!atomic_read(&dev->initialized))
+		return -ERESTARTSYS;
+
 	ret = kstrtoul(buf, 0, &val);
 	if (ret < 0)
 		return ret;
@@ -1241,10 +1237,6 @@ static ssize_t store_filter(struct device *device,
 		return -EINVAL;
 
 	mutex_lock(&dev->lock);
-	if (!dev->initialized) {
-		ret = -EINVAL;
-		goto unlock;
-	}
 
 	new_filter = *filter;
 	if (fattr->mask)
@@ -1431,6 +1423,7 @@ int rc_register_device(struct rc_dev *dev)
 	dev->minor = minor;
 	dev_set_name(&dev->dev, "rc%u", dev->minor);
 	dev_set_drvdata(&dev->dev, dev);
+	atomic_set(&dev->initialized, 0);
 
 	dev->dev.groups = dev->sysfs_groups;
 	dev->sysfs_groups[attr++] = &rc_dev_protocol_attr_grp;
@@ -1455,10 +1448,6 @@ int rc_register_device(struct rc_dev *dev)
 	dev->input_dev->phys = dev->input_phys;
 	dev->input_dev->name = dev->input_name;
 
-	rc = input_register_device(dev->input_dev);
-	if (rc)
-		goto out_table;
-
 	/*
 	 * Default delay of 250ms is too short for some protocols, especially
 	 * since the timeout is currently set to 250ms. Increase it to 500ms,
@@ -1474,6 +1463,11 @@ int rc_register_device(struct rc_dev *dev)
 	 */
 	dev->input_dev->rep[REP_PERIOD] = 125;
 
+	/* rc_open will be called here */
+	rc = input_register_device(dev->input_dev);
+	if (rc)
+		goto out_table;
+
 	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
 	dev_info(&dev->dev, "%s as %s\n",
 		dev->input_name ?: "Unspecified device", path ?: "N/A");
@@ -1497,8 +1491,9 @@ int rc_register_device(struct rc_dev *dev)
 		dev->enabled_protocols = rc_type;
 	}
 
+	/* Allow the RC sysfs nodes to be accessible */
 	mutex_lock(&dev->lock);
-	dev->initialized = true;
+	atomic_set(&dev->initialized, 1);
 	mutex_unlock(&dev->lock);
 
 	IR_dprintk(1, "Registered rc%u (driver: %s, remote: %s, mode %s)\n",
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index c41dd7018fa8..0f77b3dffb37 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -60,7 +60,7 @@ enum rc_filter_type {
 /**
  * struct rc_dev - represents a remote control device
  * @dev: driver model's view of this device
- * @initialized: true if the device init has completed
+ * @initialized: 1 if the device init has completed, 0 otherwise
  * @sysfs_groups: sysfs attribute groups
  * @input_name: name of the input child device
  * @input_phys: physical path to the input child device
@@ -122,7 +122,7 @@ enum rc_filter_type {
  */
 struct rc_dev {
 	struct device			dev;
-	bool				initialized;
+	atomic_t			initialized;
 	const struct attribute_group	*sysfs_groups[5];
 	const char			*input_name;
 	const char			*input_phys;
-- 
2.5.0

