Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33466 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751514AbdILImt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 04:42:49 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v11 18/24] v4l: fwnode: Add a helper function to obtain device / interger references
Date: Tue, 12 Sep 2017 11:42:30 +0300
Message-Id: <20170912084236.1154-19-sakari.ailus@linux.intel.com>
In-Reply-To: <20170912084236.1154-1-sakari.ailus@linux.intel.com>
References: <20170912084236.1154-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_fwnode_reference_parse_int_prop() will find an fwnode such that under
the device's own fwnode, it will follow child fwnodes with the given
property -- value pair and return the resulting fwnode.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 145 ++++++++++++++++++++++++++++++++++
 1 file changed, 145 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index a61c16b337a0..93bd9c29fd43 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -518,6 +518,151 @@ static int v4l2_fwnode_reference_parse(
 	return ret;
 }
 
+/*
+ * v4l2_fwnode_reference_get_int_prop - parse a reference with integer
+ *					arguments
+ * @dev: struct device pointer
+ * @notifier: notifier for @dev
+ * @prop: the name of the property
+ * @props: the array of integer property names
+ * @nprops: the number of integer properties
+ *
+ * Find fwnodes referred to by a property @prop, then under that iteratively
+ * follow each child node which has a property the value matches the integer
+ * argument at an index.
+ *
+ * Return: 0 on success
+ *	   -ENOENT if no entries (or the property itself) were found
+ *	   -EINVAL if property parsing otherwisefailed
+ *	   -ENOMEM if memory allocation failed
+ */
+static struct fwnode_handle *v4l2_fwnode_reference_get_int_prop(
+	struct fwnode_handle *fwnode, const char *prop, unsigned int index,
+	const char **props, unsigned int nprops)
+{
+	struct fwnode_reference_args fwnode_args;
+	unsigned int *args = fwnode_args.args;
+	struct fwnode_handle *child;
+	int ret;
+
+	/*
+	 * Obtain remote fwnode as well as the integer arguments.
+	 *
+	 * To-do: handle -ENODATA when "device property: Align return
+	 * codes of acpi_fwnode_get_reference_with_args" is merged.
+	 */
+	ret = fwnode_property_get_reference_args(fwnode, prop, NULL, nprops,
+						 index, &fwnode_args);
+	if (ret)
+		return ERR_PTR(ret == -ENODATA ? -ENOENT : ret);
+
+	/*
+	 * Find a node in the tree under the referred fwnode corresponding the
+	 * integer arguments.
+	 */
+	fwnode = fwnode_args.fwnode;
+	while (nprops) {
+		u32 val;
+
+		/* Loop over all child nodes under fwnode. */
+		fwnode_for_each_child_node(fwnode, child) {
+			if (fwnode_property_read_u32(child, *props, &val))
+				continue;
+
+			/* Found property, see if its value matches. */
+			if (val == *args)
+				break;
+		}
+
+		fwnode_handle_put(fwnode);
+
+		/* No property found; return an error here. */
+		if (!child) {
+			fwnode = ERR_PTR(-ENOENT);
+			break;
+		}
+
+		props++;
+		args++;
+		fwnode = child;
+		nprops--;
+	}
+
+	return fwnode;
+}
+
+/*
+ * v4l2_fwnode_reference_parse_int_props - parse references for async sub-devices
+ * @dev: struct device pointer
+ * @notifier: notifier for @dev
+ * @prop: the name of the property
+ * @props: the array of integer property names
+ * @nprops: the number of integer properties
+ *
+ * Use v4l2_fwnode_reference_get_int_prop to find fwnodes through reference in
+ * property @prop with integer arguments with child nodes matching in properties
+ * @props. Then, set up V4L2 async sub-devices for those fwnodes in the notifier
+ * accordingly.
+ *
+ * While it is technically possible to use this function on DT, it is only
+ * meaningful on ACPI. On Device tree you can refer to any node in the tree but
+ * on ACPI the references are limited to devices.
+ *
+ * Return: 0 on success
+ *	   -ENOENT if no entries (or the property itself) were found
+ *	   -EINVAL if property parsing otherwisefailed
+ *	   -ENOMEM if memory allocation failed
+ */
+static int v4l2_fwnode_reference_parse_int_props(
+	struct device *dev, struct v4l2_async_notifier *notifier,
+	const char *prop, const char **props, unsigned int nprops)
+{
+	struct fwnode_handle *fwnode;
+	unsigned int index;
+	int ret;
+
+	for (index = 0; !IS_ERR((fwnode = v4l2_fwnode_reference_get_int_prop(
+					 dev_fwnode(dev), prop, index, props,
+					 nprops))); index++)
+		fwnode_handle_put(fwnode);
+
+	if (PTR_ERR(fwnode) != -ENOENT)
+		return PTR_ERR(fwnode);
+
+	ret = v4l2_async_notifier_realloc(notifier,
+					  notifier->num_subdevs + index);
+	if (ret)
+		return -ENOMEM;
+
+	for (index = 0; !IS_ERR((fwnode = v4l2_fwnode_reference_get_int_prop(
+					 dev_fwnode(dev), prop, index, props,
+					 nprops))); index++) {
+		struct v4l2_async_subdev *asd;
+
+		if (WARN_ON(notifier->num_subdevs >= notifier->max_subdevs)) {
+			ret = -EINVAL;
+			goto error;
+		}
+
+		asd = kzalloc(sizeof(struct v4l2_async_subdev), GFP_KERNEL);
+		if (!asd) {
+			ret = -ENOMEM;
+			goto error;
+		}
+
+		notifier->subdevs[notifier->num_subdevs] = asd;
+		asd->match.fwnode.fwnode = fwnode;
+		asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
+		notifier->num_subdevs++;
+	}
+
+	return PTR_ERR(fwnode) == -ENOENT ? 0 : PTR_ERR(fwnode);
+
+error:
+	fwnode_handle_put(fwnode);
+	return ret;
+}
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
 MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
-- 
2.11.0
