Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:38991 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751725AbeBVBkK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 20:40:10 -0500
Received: by mail-pf0-f193.google.com with SMTP id c143so1460069pfb.6
        for <linux-media@vger.kernel.org>; Wed, 21 Feb 2018 17:40:09 -0800 (PST)
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
Subject: [PATCH 05/13] media: v4l2-fwnode: Add a convenience function for registering subdevs with notifiers
Date: Wed, 21 Feb 2018 17:39:41 -0800
Message-Id: <1519263589-19647-6-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1519263589-19647-1-git-send-email-steve_longerbeam@mentor.com>
References: <1519263589-19647-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds v4l2_async_register_fwnode_subdev(), which is a convenience function
for parsing a sub-device's fwnode port endpoints for connected remote
sub-devices, registering a sub-device notifier, and then registering
the sub-device itself.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 98 +++++++++++++++++++++++++++++++++++
 include/media/v4l2-fwnode.h           | 42 +++++++++++++++
 2 files changed, 140 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 2fe2e14..07b8817 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -880,6 +880,104 @@ int v4l2_async_register_subdev_sensor_common(struct v4l2_subdev *sd)
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
+	unsigned int subdev_port;
+	bool is_port;
+	int ret;
+
+	if (WARN_ON(!dev))
+		return -ENODEV;
+
+	fwnode = dev_fwnode(dev);
+	if (!fwnode_device_is_available(fwnode))
+		return -ENODEV;
+
+	is_port = (is_of_node(fwnode) &&
+		   of_node_cmp(to_of_node(fwnode)->name, "port") == 0);
+
+	/*
+	 * If the sub-device is a port, only parse fwnode endpoints from
+	 * this sub-device's single port id.
+	 */
+	if (is_port) {
+		/* verify the caller did not provide a ports array */
+		if (ports)
+			return -EINVAL;
+
+		ret = fwnode_property_read_u32(fwnode, "reg", &subdev_port);
+		if (ret < 0)
+			return ret;
+
+		/*
+		 * the device given to the fwnode endpoint parsing
+		 * must be the port sub-device's parent.
+		 */
+		dev = get_device(sd->dev->parent);
+
+		if (WARN_ON(!dev))
+			return -ENODEV;
+
+		ports = &subdev_port;
+		num_ports = 1;
+	}
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
+	if (is_port)
+		put_device(dev);
+
+	return 0;
+
+out_unregister:
+	v4l2_async_notifier_unregister(notifier);
+out_cleanup:
+	if (is_port)
+		put_device(dev);
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
index 9a4b3f8..764bb70 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -360,4 +360,46 @@ int v4l2_async_notifier_parse_fwnode_endpoints_by_port(
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
+ * This function is just like v4l2_async_register_subdev() with the exception
+ * that calling it will also parse the sub-device's firmware node endpoints
+ * using v4l2_async_notifier_parse_fwnode_endpoints() or
+ * v4l2_async_notifier_parse_fwnode_endpoints_by_port(), and registers the
+ * async sub-devices. The sub-device is similarly unregistered by calling
+ * v4l2_async_unregister_subdev().
+ *
+ * This function will work as expected if the sub-device fwnode is
+ * itself a port. The endpoints of this single port are parsed using
+ * v4l2_async_notifier_parse_fwnode_endpoints_by_port(), passing the
+ * parent of the sub-device as the port's owner. The caller must not
+ * provide a @ports array, since the sub-device owns only this port.
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
