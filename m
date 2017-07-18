Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60040 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751962AbdGRTEH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 15:04:07 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        niklas.soderlund@ragnatech.se, hverkuil@xs4all.nl
Subject: [RFC 09/19] v4l2-fwnode: Add conveniences function for parsing generic references
Date: Tue, 18 Jul 2017 22:03:51 +0300
Message-Id: <20170718190401.14797-10-sakari.ailus@linux.intel.com>
In-Reply-To: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add function v4l2_fwnode_reference_count() for counting external
references and v4l2_fwnode_reference_parse() for parsing them as async
sub-devices.

This can be done on e.g. flash or lens async sub-devices that are not part
of but are associated with a sensor.

struct v4l2_async_notifier.max_subdevs field is added to contain the
maximum number of sub-devices in a notifier to reflect the memory
allocated for the subdevs array.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 53 +++++++++++++++++++++++++++++++++++
 include/media/v4l2-fwnode.h           |  8 ++++++
 2 files changed, 61 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index c3ad9e31e4cb..bfc9e38766f3 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -433,6 +433,59 @@ int v4l2_fwnode_endpoints_parse(
 }
 EXPORT_SYMBOL_GPL(v4l2_fwnode_endpoints_parse);
 
+int v4l2_fwnode_reference_parse(
+	struct device *dev, struct v4l2_async_notifier *notifier,
+	const char *prop, const char *nargs_prop, unsigned int nargs,
+	size_t asd_struct_size,
+	int (*parse_single)(struct device *dev,
+			    struct fwnode_reference_args *args,
+			    struct v4l2_async_subdev *asd))
+{
+	struct fwnode_reference_args args;
+	unsigned int max_subdevs = notifier->max_subdevs;
+	int ret;
+
+	if (asd_struct_size < sizeof(struct v4l2_async_subdev))
+		return -EINVAL;
+
+	while (!fwnode_property_get_reference_args(
+		       dev_fwnode(dev), prop, nargs_prop, nargs,
+		       max_subdevs - notifier->max_subdevs, NULL))
+		max_subdevs++;
+
+	ret = notifier_realloc(dev, notifier, max_subdevs);
+	if (ret)
+		return ret;
+
+	for (ret = -ENOENT; !fwnode_property_get_reference_args(
+				     dev_fwnode(dev), prop, nargs_prop, nargs,
+				     notifier->num_subdevs, &args) &&
+		     !WARN_ON(notifier->num_subdevs >= notifier->max_subdevs);
+	     notifier->num_subdevs++) {
+		struct v4l2_async_subdev *asd;
+
+		asd = devm_kzalloc(dev, asd_struct_size, GFP_KERNEL);
+		if (!asd) {
+			fwnode_handle_put(args.fwnode);
+			ret = -ENOMEM;
+			goto error;
+		}
+
+		ret = parse_single ? parse_single(dev, &args, asd) : 0;
+		fwnode_handle_put(args.fwnode);
+		if (ret)
+			goto error;
+
+		notifier->subdevs[notifier->num_subdevs] = asd;
+		asd->match.fwnode.fwnode = args.fwnode;
+		asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
+	}
+
+error:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_fwnode_reference_parse);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
 MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index 6ba1a0bbc328..e27526bd744d 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -110,4 +110,12 @@ int v4l2_fwnode_endpoints_parse(
 			    struct v4l2_fwnode_endpoint *vep,
 			    struct v4l2_async_subdev *asd));
 
+int v4l2_fwnode_reference_parse(
+	struct device *dev, struct v4l2_async_notifier *notifier,
+	const char *prop, const char *nargs_prop, unsigned int nargs,
+	size_t asd_struct_size,
+	int (*parse_single)(struct device *dev,
+			    struct fwnode_reference_args *args,
+			    struct v4l2_async_subdev *asd));
+
 #endif /* _V4L2_FWNODE_H */
-- 
2.11.0
