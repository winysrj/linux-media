Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33200 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750703AbcI3Umd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Sep 2016 16:42:33 -0400
Received: by mail-wm0-f65.google.com with SMTP id p138so5000925wmb.0
        for <linux-media@vger.kernel.org>; Fri, 30 Sep 2016 13:42:32 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 1/2] rc: core: add managed versions of rc_allocate_device and
 rc_register_device
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <9979eabf-3b3c-8ed2-4298-b25bed348aee@gmail.com>
Date: Fri, 30 Sep 2016 22:42:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Introduce managed versions of both functions.
They allows to simplify the error path in the probe function of
rc drivers, and usually also to simplify the remove function.

New element managed_alloc in struct rc_dev is needed to correctly
handle mixed use, e.g. managed version of rc_register_device and
normal version of rc_allocate_device.

In addition devm_rc_allocate_device sets rc->dev.parent as having a
reference to the parent device might be useful for future extensions.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/rc-main.c | 58 +++++++++++++++++++++++++++++++++++++++++++++-
 include/media/rc-core.h    | 18 ++++++++++++++
 2 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index d9c1f2f..c8c6aa5 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1403,6 +1403,34 @@ void rc_free_device(struct rc_dev *dev)
 }
 EXPORT_SYMBOL_GPL(rc_free_device);
 
+static void devm_rc_alloc_release(struct device *dev, void *res)
+{
+	rc_free_device(*(struct rc_dev **)res);
+}
+
+struct rc_dev *devm_rc_allocate_device(struct device *dev)
+{
+	struct rc_dev **dr, *rc;
+
+	dr = devres_alloc(devm_rc_alloc_release, sizeof(*dr), GFP_KERNEL);
+	if (!dr)
+		return NULL;
+
+	rc = rc_allocate_device();
+	if (!rc) {
+		devres_free(dr);
+		return NULL;
+	}
+
+	rc->dev.parent = dev;
+	rc->managed_alloc = true;
+	*dr = rc;
+	devres_add(dev, dr);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(devm_rc_allocate_device);
+
 int rc_register_device(struct rc_dev *dev)
 {
 	static bool raw_init = false; /* raw decoders loaded? */
@@ -1531,6 +1559,33 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(rc_register_device);
 
+static void devm_rc_release(struct device *dev, void *res)
+{
+	rc_unregister_device(*(struct rc_dev **)res);
+}
+
+int devm_rc_register_device(struct device *parent, struct rc_dev *dev)
+{
+	struct rc_dev **dr;
+	int ret;
+
+	dr = devres_alloc(devm_rc_release, sizeof(*dr), GFP_KERNEL);
+	if (!dr)
+		return -ENOMEM;
+
+	ret = rc_register_device(dev);
+	if (ret) {
+		devres_free(dr);
+		return ret;
+	}
+
+	*dr = dev;
+	devres_add(parent, dr);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devm_rc_register_device);
+
 void rc_unregister_device(struct rc_dev *dev)
 {
 	if (!dev)
@@ -1552,7 +1607,8 @@ void rc_unregister_device(struct rc_dev *dev)
 
 	ida_simple_remove(&rc_ida, dev->minor);
 
-	rc_free_device(dev);
+	if (!dev->managed_alloc)
+		rc_free_device(dev);
 }
 
 EXPORT_SYMBOL_GPL(rc_unregister_device);
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 40188d3..55281b9 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -68,6 +68,7 @@ enum rc_filter_type {
  * struct rc_dev - represents a remote control device
  * @dev: driver model's view of this device
  * @initialized: 1 if the device init has completed, 0 otherwise
+ * @managed_alloc: devm_rc_allocate_device was used to create rc_dev
  * @sysfs_groups: sysfs attribute groups
  * @input_name: name of the input child device
  * @input_phys: physical path to the input child device
@@ -131,6 +132,7 @@ enum rc_filter_type {
 struct rc_dev {
 	struct device			dev;
 	atomic_t			initialized;
+	bool				managed_alloc;
 	const struct attribute_group	*sysfs_groups[5];
 	const char			*input_name;
 	const char			*input_phys;
@@ -203,6 +205,14 @@ struct rc_dev {
 struct rc_dev *rc_allocate_device(void);
 
 /**
+ * devm_rc_allocate_device - Managed RC device allocation
+ *
+ * @dev: pointer to struct device
+ * returns a pointer to struct rc_dev.
+ */
+struct rc_dev *devm_rc_allocate_device(struct device *dev);
+
+/**
  * rc_free_device - Frees a RC device
  *
  * @dev: pointer to struct rc_dev.
@@ -217,6 +227,14 @@ void rc_free_device(struct rc_dev *dev);
 int rc_register_device(struct rc_dev *dev);
 
 /**
+ * devm_rc_register_device - Manageded registering of a RC device
+ *
+ * @parent: pointer to struct device.
+ * @dev: pointer to struct rc_dev.
+ */
+int devm_rc_register_device(struct device *parent, struct rc_dev *dev);
+
+/**
  * rc_unregister_device - Unregisters a RC device
  *
  * @dev: pointer to struct rc_dev.
-- 
2.10.0

