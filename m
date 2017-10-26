Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39328 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932348AbdJZHyw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 03:54:52 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v16 23/32] v4l: fwnode: Add a helper function for parsing generic references
Date: Thu, 26 Oct 2017 10:53:33 +0300
Message-Id: <20171026075342.5760-24-sakari.ailus@linux.intel.com>
In-Reply-To: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add function v4l2_fwnode_reference_parse() for parsing them as async
sub-devices. This can be done on e.g. flash or lens async sub-devices that
are not part of but are associated with a sensor.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 69 +++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 65bdcd59744a..edd2e8d983a1 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -509,6 +509,75 @@ int v4l2_async_notifier_parse_fwnode_endpoints_by_port(
 }
 EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_endpoints_by_port);
 
+/*
+ * v4l2_fwnode_reference_parse - parse references for async sub-devices
+ * @dev: the device node the properties of which are parsed for references
+ * @notifier: the async notifier where the async subdevs will be added
+ * @prop: the name of the property
+ *
+ * Return: 0 on success
+ *	   -ENOENT if no entries were found
+ *	   -ENOMEM if memory allocation failed
+ *	   -EINVAL if property parsing failed
+ */
+static int v4l2_fwnode_reference_parse(
+	struct device *dev, struct v4l2_async_notifier *notifier,
+	const char *prop)
+{
+	struct fwnode_reference_args args;
+	unsigned int index;
+	int ret;
+
+	for (index = 0;
+	     !(ret = fwnode_property_get_reference_args(
+		       dev_fwnode(dev), prop, NULL, 0, index, &args));
+	     index++)
+		fwnode_handle_put(args.fwnode);
+
+	if (!index)
+		return -ENOENT;
+
+	/*
+	 * Note that right now both -ENODATA and -ENOENT may signal
+	 * out-of-bounds access. Return the error in cases other than that.
+	 */
+	if (ret != -ENOENT && ret != -ENODATA)
+		return ret;
+
+	ret = v4l2_async_notifier_realloc(notifier,
+					  notifier->num_subdevs + index);
+	if (ret)
+		return ret;
+
+	for (index = 0; !fwnode_property_get_reference_args(
+		     dev_fwnode(dev), prop, NULL, 0, index, &args);
+	     index++) {
+		struct v4l2_async_subdev *asd;
+
+		if (WARN_ON(notifier->num_subdevs >= notifier->max_subdevs)) {
+			ret = -EINVAL;
+			goto error;
+		}
+
+		asd = kzalloc(sizeof(*asd), GFP_KERNEL);
+		if (!asd) {
+			ret = -ENOMEM;
+			goto error;
+		}
+
+		notifier->subdevs[notifier->num_subdevs] = asd;
+		asd->match.fwnode.fwnode = args.fwnode;
+		asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
+		notifier->num_subdevs++;
+	}
+
+	return 0;
+
+error:
+	fwnode_handle_put(args.fwnode);
+	return ret;
+}
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
 MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
-- 
2.11.0
