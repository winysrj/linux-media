Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47452 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756136AbdIHNSb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 09:18:31 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v9 20/24] v4l: fwnode: Add a helper function to obtain device / interger references
Date: Fri,  8 Sep 2017 16:18:18 +0300
Message-Id: <20170908131822.31020-16-sakari.ailus@linux.intel.com>
In-Reply-To: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
References: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_fwnode_reference_parse_int_prop() will find an fwnode such that under
the device's own fwnode, it will follow child fwnodes with the given
property -- value pair and return the resulting fwnode.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 93 +++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 4821c4989119..56eee5bbd3b5 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -496,6 +496,99 @@ static int v4l2_fwnode_reference_parse(
 	return ret;
 }
 
+static struct fwnode_handle *v4l2_fwnode_reference_get_int_prop(
+	struct fwnode_handle *fwnode, const char *prop, unsigned int index,
+	const char **props, unsigned int nprops)
+{
+	struct fwnode_reference_args fwnode_args;
+	unsigned int *args = fwnode_args.args;
+	struct fwnode_handle *child;
+	int ret;
+
+	ret = fwnode_property_get_reference_args(fwnode, prop, NULL, nprops,
+						 index, &fwnode_args);
+	if (ret)
+		return ERR_PTR(ret == -EINVAL ? -ENOENT : ret);
+
+	for (fwnode = fwnode_args.fwnode;
+	     nprops; nprops--, fwnode = child, props++, args++) {
+		u32 val;
+
+		fwnode_for_each_child_node(fwnode, child) {
+			if (fwnode_property_read_u32(child, *props, &val))
+				continue;
+
+			if (val == *args)
+				break;
+		}
+
+		fwnode_handle_put(fwnode);
+
+		if (!child) {
+			fwnode = ERR_PTR(-ENOENT);
+			break;
+		}
+	}
+
+	return fwnode;
+}
+
+static int v4l2_fwnode_reference_parse_int_props(
+	struct device *dev, struct v4l2_async_notifier *notifier,
+	const char *prop, const char **props, unsigned int nprops)
+{
+	struct fwnode_handle *fwnode;
+	unsigned int index = 0;
+	int ret;
+
+	while (!IS_ERR((fwnode = v4l2_fwnode_reference_get_int_prop(
+				dev_fwnode(dev), prop, index, props,
+				nprops)))) {
+		fwnode_handle_put(fwnode);
+		index++;
+	}
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
+					 nprops))); ) {
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
+
+		fwnode_handle_put(fwnode);
+
+		index++;
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
