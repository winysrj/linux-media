Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60042 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752019AbdGRTEJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 15:04:09 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        niklas.soderlund@ragnatech.se, hverkuil@xs4all.nl
Subject: [RFC 18/19] v4l2-fwnode: Add abstracted sub-device notifiers
Date: Tue, 18 Jul 2017 22:04:00 +0300
Message-Id: <20170718190401.14797-19-sakari.ailus@linux.intel.com>
In-Reply-To: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add notifiers for sub-devices. The notifiers themselves are not visible for
the sub-device drivers but instead are accessed through interface functions
v4l2_subdev_fwnode_endpoints_parse() and
v4l2_subdev_fwnode_reference_parse_sensor_common().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-async.c  | 27 +++++++++++++++++----
 drivers/media/v4l2-core/v4l2-subdev.c | 44 +++++++++++++++++++++++++++++++++--
 include/media/v4l2-fwnode.h           |  1 +
 include/media/v4l2-subdev.h           | 11 +++++++++
 4 files changed, 77 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 55fa7106345c..411deadf5d85 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -134,10 +134,14 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
 
 	if (notifier->bound) {
 		ret = notifier->bound(notifier, sd, asd);
-		if (ret < 0) {
-			v4l2_device_unregister_subdev(sd);
-			return ret;
-		}
+		if (ret < 0)
+			goto err_unregister;
+	}
+
+	if (sd->subnotifier) {
+		ret = v4l2_async_subnotifier_register(sd, sd->subnotifier);
+		if (ret < 0)
+			goto err_unbind;
 	}
 
 	/* Remove from the waiting list */
@@ -152,6 +156,15 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
 		return notifier->complete(notifier);
 
 	return 0;
+
+err_unbind:
+	if (notifier->unbind)
+		notifier->unbind(notifier, sd, asd);
+
+err_unregister:
+	v4l2_device_unregister_subdev(sd);
+
+	return ret;
 }
 
 static void v4l2_async_cleanup(struct v4l2_subdev *sd)
@@ -283,6 +296,9 @@ v4l2_async_do_notifier_unregister(struct v4l2_async_notifier *notifier,
 		/* If we handled USB devices, we'd have to lock the parent too */
 		device_release_driver(d);
 
+		if (sd->subnotifier)
+			v4l2_async_subnotifier_unregister(sd->subnotifier);
+
 		if (notifier->unbind)
 			notifier->unbind(notifier, sd, sd->asd);
 
@@ -396,6 +412,9 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 
 	v4l2_async_cleanup(sd);
 
+	if (sd->subnotifier)
+		v4l2_async_subnotifier_unregister(sd->subnotifier);
+
 	if (notifier->unbind)
 		notifier->unbind(notifier, sd, sd->asd);
 
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 43fefa73e0a3..a6976d4a52ac 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -25,9 +25,10 @@
 
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-ioctl.h>
-#include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-fwnode.h>
+#include <media/v4l2-ioctl.h>
 
 static int subdev_fh_init(struct v4l2_subdev_fh *fh, struct v4l2_subdev *sd)
 {
@@ -626,3 +627,42 @@ void v4l2_subdev_notify_event(struct v4l2_subdev *sd,
 	v4l2_subdev_notify(sd, V4L2_DEVICE_NOTIFY_EVENT, (void *)ev);
 }
 EXPORT_SYMBOL_GPL(v4l2_subdev_notify_event);
+
+static struct v4l2_async_notifier *v4l2_subdev_get_subnotifier(
+	struct v4l2_subdev *sd)
+{
+	if (sd->subnotifier)
+		return sd->subnotifier;
+
+	return (sd->subnotifier = devm_kzalloc(
+			sd->dev, sizeof(*sd->subnotifier), GFP_KERNEL));
+}
+
+int v4l2_subdev_fwnode_endpoints_parse(
+	struct v4l2_subdev *sd,	size_t asd_struct_size,
+	int (*parse_single)(struct device *dev,
+			    struct v4l2_fwnode_endpoint *vep,
+			    struct v4l2_async_subdev *asd))
+{
+	struct v4l2_async_notifier *subnotifier =
+		v4l2_subdev_get_subnotifier(sd);
+
+	if (!subnotifier)
+		return -ENOMEM;
+
+	return v4l2_fwnode_endpoints_parse(sd->dev, subnotifier,
+					   asd_struct_size, parse_single);
+}
+EXPORT_SYMBOL_GPL(v4l2_subdev_fwnode_endpoints_parse);
+
+int v4l2_subdev_fwnode_reference_parse_sensor_common(struct v4l2_subdev *sd)
+{
+	struct v4l2_async_notifier *subnotifier =
+		v4l2_subdev_get_subnotifier(sd);
+
+	if (!subnotifier)
+		return -ENOMEM;
+
+	return v4l2_fwnode_reference_parse_sensor_common(sd->dev, subnotifier);
+}
+EXPORT_SYMBOL_GPL(v4l2_subdev_fwnode_reference_parse_sensor_common);
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index 8cd4f8a75c3d..0a3f869ead52 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -27,6 +27,7 @@
 struct fwnode_handle;
 struct v4l2_async_notifier;
 struct v4l2_async_subdev;
+struct v4l2_subdev;
 
 /**
  * struct v4l2_fwnode_bus_mipi_csi2 - MIPI CSI-2 bus data structure
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 0f92ebd2d710..e309a2e2030b 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -43,6 +43,7 @@ struct v4l2_ctrl_handler;
 struct v4l2_event;
 struct v4l2_event_subscription;
 struct v4l2_fh;
+struct v4l2_fwnode_endpoint;
 struct v4l2_subdev;
 struct v4l2_subdev_fh;
 struct tuner_setup;
@@ -793,6 +794,7 @@ struct v4l2_subdev_platform_data {
  *	list.
  * @asd: Pointer to respective &struct v4l2_async_subdev.
  * @notifier: Pointer to the managing notifier.
+ * @subnotifier: Pointer to the async sub-device notifier.
  * @pdata: common part of subdevice platform data
  *
  * Each instance of a subdev driver should create this struct, either
@@ -823,6 +825,7 @@ struct v4l2_subdev {
 	struct list_head async_list;
 	struct v4l2_async_subdev *asd;
 	struct v4l2_async_notifier *notifier;
+	struct v4l2_async_notifier *subnotifier;
 	struct v4l2_subdev_platform_data *pdata;
 };
 
@@ -1001,4 +1004,12 @@ void v4l2_subdev_init(struct v4l2_subdev *sd,
 void v4l2_subdev_notify_event(struct v4l2_subdev *sd,
 			      const struct v4l2_event *ev);
 
+int v4l2_subdev_fwnode_endpoints_parse(
+	struct v4l2_subdev *sd,	size_t asd_struct_size,
+	int (*parse_single)(struct device *dev,
+			    struct v4l2_fwnode_endpoint *vep,
+			    struct v4l2_async_subdev *asd));
+
+int v4l2_subdev_fwnode_reference_parse_sensor_common(struct v4l2_subdev *sd);
+
 #endif
-- 
2.11.0
