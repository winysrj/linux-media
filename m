Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40394 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751423AbdJDVvB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 17:51:01 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v15 26/32] v4l: fwnode: Add a convenience function for registering sensors
Date: Thu,  5 Oct 2017 00:50:45 +0300
Message-Id: <20171004215051.13385-27-sakari.ailus@linux.intel.com>
In-Reply-To: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a convenience function for parsing firmware for information on related
devices using v4l2_async_notifier_parse_fwnode_sensor_common() registering
the notifier and finally the async sub-device itself.

This should be useful for sensor drivers that do not have device specific
requirements related to firmware information parsing or the async
framework.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-async.c  | 19 ++++++++++++----
 drivers/media/v4l2-core/v4l2-fwnode.c | 41 +++++++++++++++++++++++++++++++++++
 include/media/v4l2-async.h            | 22 +++++++++++++++++++
 include/media/v4l2-subdev.h           |  3 +++
 4 files changed, 81 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index e1fe3567127a..ae026eee3d03 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -496,19 +496,25 @@ int v4l2_async_subdev_notifier_register(struct v4l2_subdev *sd,
 }
 EXPORT_SYMBOL(v4l2_async_subdev_notifier_register);
 
-void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
+static void __v4l2_async_notifier_unregister(
+	struct v4l2_async_notifier *notifier)
 {
-	if (!notifier->v4l2_dev && !notifier->sd)
+	if (!notifier || (!notifier->v4l2_dev && !notifier->sd))
 		return;
 
-	mutex_lock(&list_lock);
-
 	v4l2_async_notifier_unbind_all_subdevs(notifier);
 
 	notifier->sd = NULL;
 	notifier->v4l2_dev = NULL;
 
 	list_del(&notifier->list);
+}
+
+void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
+{
+	mutex_lock(&list_lock);
+
+	__v4l2_async_notifier_unregister(notifier);
 
 	mutex_unlock(&list_lock);
 }
@@ -618,6 +624,11 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 {
 	mutex_lock(&list_lock);
 
+	__v4l2_async_notifier_unregister(sd->subdev_notifier);
+	v4l2_async_notifier_cleanup(sd->subdev_notifier);
+	kfree(sd->subdev_notifier);
+	sd->subdev_notifier = NULL;
+
 	if (sd->asd) {
 		struct v4l2_async_notifier *notifier = sd->notifier;
 
diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 18ea7cd34f21..e5856f1e39b9 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -29,6 +29,7 @@
 
 #include <media/v4l2-async.h>
 #include <media/v4l2-fwnode.h>
+#include <media/v4l2-subdev.h>
 
 enum v4l2_fwnode_bus_type {
 	V4L2_FWNODE_BUS_TYPE_GUESS = 0,
@@ -820,6 +821,46 @@ int v4l2_async_notifier_parse_fwnode_sensor_common(
 }
 EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_sensor_common);
 
+int v4l2_async_register_subdev_sensor_common(struct v4l2_subdev *sd)
+{
+	struct v4l2_async_notifier *notifier;
+	int ret;
+
+	if (WARN_ON(!sd->dev))
+		return -ENODEV;
+
+	notifier = kzalloc(sizeof(*notifier), GFP_KERNEL);
+	if (!notifier)
+		return -ENOMEM;
+
+	ret = v4l2_async_notifier_parse_fwnode_sensor_common(sd->dev,
+							     notifier);
+	if (ret < 0)
+		goto out_cleanup;
+
+	ret = v4l2_async_subdev_notifier_register(sd, notifier);
+	if (ret < 0)
+		goto out_cleanup;
+
+	ret = v4l2_async_register_subdev(sd);
+	if (ret < 0)
+		goto out_unregister;
+
+	sd->subdev_notifier = notifier;
+
+	return 0;
+
+out_unregister:
+	v4l2_async_notifier_unregister(notifier);
+
+out_cleanup:
+	v4l2_async_notifier_cleanup(notifier);
+	kfree(notifier);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_async_register_subdev_sensor_common);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
 MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 1e5e3f186b38..65f87e80081a 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -173,6 +173,28 @@ void v4l2_async_notifier_cleanup(struct v4l2_async_notifier *notifier);
 int v4l2_async_register_subdev(struct v4l2_subdev *sd);
 
 /**
+ * v4l2_async_register_subdev_sensor_common - registers a sensor sub-device to
+ *					      the asynchronous sub-device
+ *					      framework and parse set up common
+ *					      sensor related devices
+ *
+ * @sd: pointer to struct &v4l2_subdev
+ *
+ * This function is just like v4l2_async_register_subdev() with the exception
+ * that calling it will also parse firmware interfaces for remote references
+ * using v4l2_async_notifier_parse_fwnode_sensor_common() and registers the
+ * async sub-devices. The sub-device is similarly unregistered by calling
+ * v4l2_async_unregister_subdev().
+ *
+ * While registered, the subdev module is marked as in-use.
+ *
+ * An error is returned if the module is no longer loaded on any attempts
+ * to register it.
+ */
+int __must_check v4l2_async_register_subdev_sensor_common(
+	struct v4l2_subdev *sd);
+
+/**
  * v4l2_async_unregister_subdev - unregisters a sub-device to the asynchronous
  * 	subdevice framework
  *
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index e83872078376..ec399c770301 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -793,6 +793,8 @@ struct v4l2_subdev_platform_data {
  *	list.
  * @asd: Pointer to respective &struct v4l2_async_subdev.
  * @notifier: Pointer to the managing notifier.
+ * @subdev_notifier: A sub-device notifier implicitly registered for the sub-
+ *		     device using v4l2_device_register_sensor_subdev().
  * @pdata: common part of subdevice platform data
  *
  * Each instance of a subdev driver should create this struct, either
@@ -823,6 +825,7 @@ struct v4l2_subdev {
 	struct list_head async_list;
 	struct v4l2_async_subdev *asd;
 	struct v4l2_async_notifier *notifier;
+	struct v4l2_async_notifier *subdev_notifier;
 	struct v4l2_subdev_platform_data *pdata;
 };
 
-- 
2.11.0
