Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60042 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751929AbdGRTEG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 15:04:06 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        niklas.soderlund@ragnatech.se, hverkuil@xs4all.nl
Subject: [RFC 10/19] v4l2-fwnode: Add convenience function for parsing common external refs
Date: Tue, 18 Jul 2017 22:03:52 +0300
Message-Id: <20170718190401.14797-11-sakari.ailus@linux.intel.com>
In-Reply-To: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add v4l2_fwnode_parse_reference_sensor_common for parsing common
sensor properties that refer to adjacent devices such as flash or lens
driver chips.

As this is an association only, there's little a regular driver needs to
know about these devices as such.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 27 +++++++++++++++++++++++++++
 include/media/v4l2-fwnode.h           |  3 +++
 2 files changed, 30 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index bfc9e38766f3..8671262eb22c 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -486,6 +486,33 @@ int v4l2_fwnode_reference_parse(
 }
 EXPORT_SYMBOL_GPL(v4l2_fwnode_reference_parse);
 
+int v4l2_fwnode_reference_parse_sensor_common(
+	struct device *dev, struct v4l2_async_notifier *notifier)
+{
+	static const struct {
+		char *name;
+		char *cells;
+		unsigned int nr_cells;
+	} props[] = {
+		{ "flash", NULL, 0 },
+		{ "lens-focus", NULL, 0 },
+	};
+	unsigned int i;
+	int rval;
+
+	for (i = 0; i < ARRAY_SIZE(props); i++) {
+		rval = v4l2_fwnode_reference_parse(
+			dev, notifier, props[i].name, props[i].cells,
+			props[i].nr_cells, sizeof(struct v4l2_async_subdev),
+			NULL);
+		if (rval < 0 && rval != -ENOENT)
+			return rval;
+	}
+
+	return rval;
+}
+EXPORT_SYMBOL_GPL(v4l2_fwnode_reference_parse_sensor_common);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
 MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index e27526bd744d..8cd4f8a75c3d 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -118,4 +118,7 @@ int v4l2_fwnode_reference_parse(
 			    struct fwnode_reference_args *args,
 			    struct v4l2_async_subdev *asd));
 
+int v4l2_fwnode_reference_parse_sensor_common(
+	struct device *dev, struct v4l2_async_notifier *notifier);
+
 #endif /* _V4L2_FWNODE_H */
-- 
2.11.0
