Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36906 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965887AbeEIWrX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 18:47:23 -0400
Received: by mail-pf0-f195.google.com with SMTP id e9-v6so81936pfi.4
        for <linux-media@vger.kernel.org>; Wed, 09 May 2018 15:47:23 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        niklas.soderlund@ragnatech.se, Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v4 06/14] media: v4l2-fwnode: Add a convenience function for registering subdevs with notifiers
Date: Wed,  9 May 2018 15:46:55 -0700
Message-Id: <1525906023-827-7-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1525906023-827-1-git-send-email-steve_longerbeam@mentor.com>
References: <1525906023-827-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds v4l2_async_register_fwnode_subdev(), which is a convenience function
for parsing a sub-device's fwnode port endpoints for connected remote
sub-devices, registering a sub-device notifier, and then registering
the sub-device itself.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
Changes since v3:
- remove support for port sub-devices, such sub-devices will have to
  role their own.
Changes since v2:
- fix error-out path in v4l2_async_register_fwnode_subdev() that forgot
  to put device.
Changes since v1:
- add #include <media/v4l2-subdev.h> to v4l2-fwnode.h for
  'struct v4l2_subdev' declaration.
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 62 +++++++++++++++++++++++++++++++++++
 include/media/v4l2-fwnode.h           | 38 +++++++++++++++++++++
 2 files changed, 100 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 0f88856..87c70e3 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -870,6 +870,68 @@ int v4l2_async_register_subdev_sensor_common(struct v4l2_subdev *sd)
 }
 EXPORT_SYMBOL_GPL(v4l2_async_register_subdev_sensor_common);
 
+int v4l2_async_register_fwnode_subdev(
+	struct v4l2_subdev *sd, size_t asd_struct_size,
+	unsigned int *ports, unsigned int num_ports,
+	int (*parse_endpoint)(struct device *dev,
+			      struct v4l2_fwnode_endpoint *vep,
+			      struct v4l2_async_subdev *asd))
+{
+	struct v4l2_async_notifier *notifier;
+	struct device *dev = sd->dev;
+	struct fwnode_handle *fwnode;
+	int ret;
+
+	if (WARN_ON(!dev))
+		return -ENODEV;
+
+	fwnode = dev_fwnode(dev);
+	if (!fwnode_device_is_available(fwnode))
+		return -ENODEV;
+
+	notifier = kzalloc(sizeof(*notifier), GFP_KERNEL);
+	if (!notifier)
+		return -ENOMEM;
+
+	if (!ports) {
+		ret = v4l2_async_notifier_parse_fwnode_endpoints(
+			dev, notifier, asd_struct_size, parse_endpoint);
+		if (ret < 0)
+			goto out_cleanup;
+	} else {
+		unsigned int i;
+
+		for (i = 0; i < num_ports; i++) {
+			ret = v4l2_async_notifier_parse_fwnode_endpoints_by_port(
+				dev, notifier, asd_struct_size,
+				ports[i], parse_endpoint);
+			if (ret < 0)
+				goto out_cleanup;
+		}
+	}
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
+out_cleanup:
+	v4l2_async_notifier_cleanup(notifier);
+	kfree(notifier);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_async_register_fwnode_subdev);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
 MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index ea7a8b2..031ebb0 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -23,6 +23,7 @@
 #include <linux/types.h>
 
 #include <media/v4l2-mediabus.h>
+#include <media/v4l2-subdev.h>
 
 struct fwnode_handle;
 struct v4l2_async_notifier;
@@ -360,4 +361,41 @@ int v4l2_async_notifier_parse_fwnode_endpoints_by_port(
 int v4l2_async_notifier_parse_fwnode_sensor_common(
 	struct device *dev, struct v4l2_async_notifier *notifier);
 
+/**
+ * v4l2_async_register_fwnode_subdev - registers a sub-device to the
+ *					asynchronous sub-device framework
+ *					and parses fwnode endpoints
+ *
+ * @sd: pointer to struct &v4l2_subdev
+ * @asd_struct_size: size of the driver's async sub-device struct, including
+ *		     sizeof(struct v4l2_async_subdev). The &struct
+ *		     v4l2_async_subdev shall be the first member of
+ *		     the driver's async sub-device struct, i.e. both
+ *		     begin at the same memory address.
+ * @ports: array of port id's to parse for fwnode endpoints. If NULL, will
+ *	   parse all ports owned by the sub-device.
+ * @num_ports: number of ports in @ports array. Ignored if @ports is NULL.
+ * @parse_endpoint: Driver's callback function called on each V4L2 fwnode
+ *		    endpoint. Optional.
+ *
+ * This function is just like v4l2_async_register_subdev() with the
+ * exception that calling it will also allocate a notifier for the
+ * sub-device, parse the sub-device's firmware node endpoints using
+ * v4l2_async_notifier_parse_fwnode_endpoints() or
+ * v4l2_async_notifier_parse_fwnode_endpoints_by_port(), and
+ * registers the sub-device notifier. The sub-device is similarly
+ * unregistered by calling v4l2_async_unregister_subdev().
+ *
+ * While registered, the subdev module is marked as in-use.
+ *
+ * An error is returned if the module is no longer loaded on any attempts
+ * to register it.
+ */
+int v4l2_async_register_fwnode_subdev(
+	struct v4l2_subdev *sd, size_t asd_struct_size,
+	unsigned int *ports, unsigned int num_ports,
+	int (*parse_endpoint)(struct device *dev,
+			      struct v4l2_fwnode_endpoint *vep,
+			      struct v4l2_async_subdev *asd));
+
 #endif /* _V4L2_FWNODE_H */
-- 
2.7.4
