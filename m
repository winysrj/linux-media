Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60036 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751942AbdGRTEH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 15:04:07 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        niklas.soderlund@ragnatech.se, hverkuil@xs4all.nl
Subject: [RFC 07/19] v4l: fwnode: Support generic parsing of graph endpoints in V4L2
Date: Tue, 18 Jul 2017 22:03:49 +0300
Message-Id: <20170718190401.14797-8-sakari.ailus@linux.intel.com>
In-Reply-To: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current practice is that drivers iterate over their endpoints and
parse each endpoint separately. This is very similar in a number of
drivers, implement a generic function for the job. Driver specific matters
can be taken into account in the driver specific callback.

Convert the omap3isp as an example.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/isp.c | 88 +++++++++-----------------------
 drivers/media/platform/omap3isp/isp.h |  3 --
 drivers/media/v4l2-core/v4l2-fwnode.c | 94 +++++++++++++++++++++++++++++++++++
 include/media/v4l2-async.h            |  4 +-
 include/media/v4l2-fwnode.h           |  9 ++++
 5 files changed, 129 insertions(+), 69 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 9df64c189883..92245a457d18 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2008,43 +2008,40 @@ enum isp_of_phy {
 	ISP_OF_PHY_CSIPHY2,
 };
 
-static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
-			    struct isp_async_subdev *isd)
+static int isp_fwnode_parse(struct device *dev,
+			    struct v4l2_fwnode_endpoint *vep,
+			    struct v4l2_async_subdev *asd)
 {
+	struct isp_async_subdev *isd =
+		container_of(asd, struct isp_async_subdev, asd);
 	struct isp_bus_cfg *buscfg = &isd->bus;
-	struct v4l2_fwnode_endpoint vep;
 	unsigned int i;
-	int ret;
-
-	ret = v4l2_fwnode_endpoint_parse(fwnode, &vep);
-	if (ret)
-		return ret;
 
 	dev_dbg(dev, "parsing endpoint %s, interface %u\n",
-		to_of_node(fwnode)->full_name, vep.base.port);
+		to_of_node(vep->base.local_fwnode)->full_name, vep->base.port);
 
-	switch (vep.base.port) {
+	switch (vep->base.port) {
 	case ISP_OF_PHY_PARALLEL:
 		buscfg->interface = ISP_INTERFACE_PARALLEL;
 		buscfg->bus.parallel.data_lane_shift =
-			vep.bus.parallel.data_shift;
+			vep->bus.parallel.data_shift;
 		buscfg->bus.parallel.clk_pol =
-			!!(vep.bus.parallel.flags
+			!!(vep->bus.parallel.flags
 			   & V4L2_MBUS_PCLK_SAMPLE_FALLING);
 		buscfg->bus.parallel.hs_pol =
-			!!(vep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW);
+			!!(vep->bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW);
 		buscfg->bus.parallel.vs_pol =
-			!!(vep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW);
+			!!(vep->bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW);
 		buscfg->bus.parallel.fld_pol =
-			!!(vep.bus.parallel.flags & V4L2_MBUS_FIELD_EVEN_LOW);
+			!!(vep->bus.parallel.flags & V4L2_MBUS_FIELD_EVEN_LOW);
 		buscfg->bus.parallel.data_pol =
-			!!(vep.bus.parallel.flags & V4L2_MBUS_DATA_ACTIVE_LOW);
+			!!(vep->bus.parallel.flags & V4L2_MBUS_DATA_ACTIVE_LOW);
 		break;
 
 	case ISP_OF_PHY_CSIPHY1:
 	case ISP_OF_PHY_CSIPHY2:
 		/* FIXME: always assume CSI-2 for now. */
-		switch (vep.base.port) {
+		switch (vep->base.port) {
 		case ISP_OF_PHY_CSIPHY1:
 			buscfg->interface = ISP_INTERFACE_CSI2C_PHY1;
 			break;
@@ -2052,18 +2049,18 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
 			buscfg->interface = ISP_INTERFACE_CSI2A_PHY2;
 			break;
 		}
-		buscfg->bus.csi2.lanecfg.clk.pos = vep.bus.mipi_csi2.clock_lane;
+		buscfg->bus.csi2.lanecfg.clk.pos = vep->bus.mipi_csi2.clock_lane;
 		buscfg->bus.csi2.lanecfg.clk.pol =
-			vep.bus.mipi_csi2.lane_polarities[0];
+			vep->bus.mipi_csi2.lane_polarities[0];
 		dev_dbg(dev, "clock lane polarity %u, pos %u\n",
 			buscfg->bus.csi2.lanecfg.clk.pol,
 			buscfg->bus.csi2.lanecfg.clk.pos);
 
 		for (i = 0; i < ISP_CSIPHY2_NUM_DATA_LANES; i++) {
 			buscfg->bus.csi2.lanecfg.data[i].pos =
-				vep.bus.mipi_csi2.data_lanes[i];
+				vep->bus.mipi_csi2.data_lanes[i];
 			buscfg->bus.csi2.lanecfg.data[i].pol =
-				vep.bus.mipi_csi2.lane_polarities[i + 1];
+				vep->bus.mipi_csi2.lane_polarities[i + 1];
 			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
 				buscfg->bus.csi2.lanecfg.data[i].pol,
 				buscfg->bus.csi2.lanecfg.data[i].pos);
@@ -2079,55 +2076,14 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
 
 	default:
 		dev_warn(dev, "%s: invalid interface %u\n",
-			 to_of_node(fwnode)->full_name, vep.base.port);
+			 to_of_node(vep->base.local_fwnode)->full_name,
+			 vep->base.port);
 		break;
 	}
 
 	return 0;
 }
 
-static int isp_fwnodes_parse(struct device *dev,
-			     struct v4l2_async_notifier *notifier)
-{
-	struct fwnode_handle *fwnode = NULL;
-
-	notifier->subdevs = devm_kcalloc(
-		dev, ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);
-	if (!notifier->subdevs)
-		return -ENOMEM;
-
-	while (notifier->num_subdevs < ISP_MAX_SUBDEVS &&
-	       (fwnode = fwnode_graph_get_next_endpoint(
-			of_fwnode_handle(dev->of_node), fwnode))) {
-		struct isp_async_subdev *isd;
-
-		isd = devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
-		if (!isd)
-			goto error;
-
-		notifier->subdevs[notifier->num_subdevs] = &isd->asd;
-
-		if (isp_fwnode_parse(dev, fwnode, isd))
-			goto error;
-
-		isd->asd.match.fwnode.fwnode =
-			fwnode_graph_get_remote_port_parent(fwnode);
-		if (!isd->asd.match.fwnode.fwnode) {
-			dev_warn(dev, "bad remote port parent\n");
-			goto error;
-		}
-
-		isd->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
-		notifier->num_subdevs++;
-	}
-
-	return notifier->num_subdevs;
-
-error:
-	fwnode_handle_put(fwnode);
-	return -EINVAL;
-}
-
 static int isp_subdev_notifier_bound(struct v4l2_async_notifier *async,
 				     struct v4l2_subdev *subdev,
 				     struct v4l2_async_subdev *asd)
@@ -2210,7 +2166,9 @@ static int isp_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = isp_fwnodes_parse(&pdev->dev, &isp->notifier);
+	ret = v4l2_fwnode_endpoints_parse(
+		&pdev->dev, &isp->notifier, sizeof(struct isp_async_subdev),
+		isp_fwnode_parse);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index 2f2ae609c548..a852c1168d20 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -220,9 +220,6 @@ struct isp_device {
 
 	unsigned int sbl_resources;
 	unsigned int subclk_resources;
-
-#define ISP_MAX_SUBDEVS		8
-	struct v4l2_subdev *subdevs[ISP_MAX_SUBDEVS];
 };
 
 struct isp_async_subdev {
diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index d4d7537011da..c3ad9e31e4cb 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -26,6 +26,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 
+#include <media/v4l2-async.h>
 #include <media/v4l2-fwnode.h>
 
 static int v4l2_fwnode_endpoint_parse_csi_bus(
@@ -339,6 +340,99 @@ void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link)
 }
 EXPORT_SYMBOL_GPL(v4l2_fwnode_put_link);
 
+static int notifier_realloc(struct device *dev,
+			    struct v4l2_async_notifier *notifier,
+			    unsigned int max_subdevs)
+{
+	struct v4l2_async_subdev **subdevs;
+	unsigned int i;
+
+	if (max_subdevs <= notifier->max_subdevs)
+		return 0;
+
+	subdevs = devm_kcalloc(
+		dev, max_subdevs, sizeof(*notifier->subdevs), GFP_KERNEL);
+	if (!subdevs)
+		return -ENOMEM;
+
+	if (notifier->subdevs) {
+		for (i = 0; i < notifier->num_subdevs; i++)
+			subdevs[i] = notifier->subdevs[i];
+
+		devm_kfree(dev, notifier->subdevs);
+	}
+
+	notifier->subdevs = subdevs;
+	notifier->max_subdevs = max_subdevs;
+
+	return 0;
+}
+
+int v4l2_fwnode_endpoints_parse(
+	struct device *dev, struct v4l2_async_notifier *notifier,
+	size_t asd_struct_size,
+	int (*parse_single)(struct device *dev,
+			    struct v4l2_fwnode_endpoint *vep,
+			    struct v4l2_async_subdev *asd))
+{
+	struct fwnode_handle *fwnode = NULL;
+	unsigned int max_subdevs = notifier->max_subdevs;
+	int ret;
+
+	if (asd_struct_size < sizeof(struct v4l2_async_subdev))
+		return -EINVAL;
+
+	while ((fwnode = fwnode_graph_get_next_endpoint(dev_fwnode(dev),
+							fwnode)))
+		max_subdevs++;
+
+	ret = notifier_realloc(dev, notifier, max_subdevs);
+	if (ret)
+		return ret;
+
+	for (fwnode = NULL; (fwnode = fwnode_graph_get_next_endpoint(
+				     dev_fwnode(dev), fwnode)) &&
+		     !WARN_ON(notifier->num_subdevs >= notifier->max_subdevs);
+		) {
+		struct v4l2_fwnode_endpoint *vep;
+		struct v4l2_async_subdev *asd;
+
+		asd = devm_kzalloc(dev, asd_struct_size, GFP_KERNEL);
+		if (!asd) {
+			ret = -ENOMEM;
+			goto error;
+		}
+
+		notifier->subdevs[notifier->num_subdevs] = asd;
+
+		/* Ignore endpoints the parsing of which failed. */
+		vep = v4l2_fwnode_endpoint_alloc_parse(fwnode);
+		if (IS_ERR(vep))
+			continue;
+
+		ret = parse_single(dev, vep, asd);
+		v4l2_fwnode_endpoint_free(vep);
+		if (ret)
+			goto error;
+
+		asd->match.fwnode.fwnode =
+			fwnode_graph_get_remote_port_parent(fwnode);
+		if (!asd->match.fwnode.fwnode) {
+			dev_warn(dev, "bad remote port parent\n");
+			ret = -EINVAL;
+			goto error;
+		}
+
+		asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
+		notifier->num_subdevs++;
+	}
+
+error:
+	fwnode_handle_put(fwnode);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_fwnode_endpoints_parse);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
 MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 8c7519fce5b9..54eecf9c9d2f 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -78,7 +78,8 @@ struct v4l2_async_subdev {
 /**
  * struct v4l2_async_notifier - v4l2_device notifier data
  *
- * @num_subdevs: number of subdevices
+ * @num_subdevs: number of subdevices used in subdevs array
+ * @max_subdevs: number of subdevices allocated in subdevs array
  * @subdevs:	array of pointers to subdevice descriptors
  * @v4l2_dev:	pointer to struct v4l2_device
  * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
@@ -90,6 +91,7 @@ struct v4l2_async_subdev {
  */
 struct v4l2_async_notifier {
 	unsigned int num_subdevs;
+	unsigned int max_subdevs;
 	struct v4l2_async_subdev **subdevs;
 	struct v4l2_device *v4l2_dev;
 	struct list_head waiting;
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index bdbd785c3d38..6ba1a0bbc328 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -25,6 +25,8 @@
 #include <media/v4l2-mediabus.h>
 
 struct fwnode_handle;
+struct v4l2_async_notifier;
+struct v4l2_async_subdev;
 
 /**
  * struct v4l2_fwnode_bus_mipi_csi2 - MIPI CSI-2 bus data structure
@@ -101,4 +103,11 @@ int v4l2_fwnode_parse_link(const struct fwnode_handle *fwnode,
 			   struct v4l2_fwnode_link *link);
 void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link);
 
+int v4l2_fwnode_endpoints_parse(
+	struct device *dev, struct v4l2_async_notifier *notifier,
+	size_t asd_struct_size,
+	int (*parse_single)(struct device *dev,
+			    struct v4l2_fwnode_endpoint *vep,
+			    struct v4l2_async_subdev *asd));
+
 #endif /* _V4L2_FWNODE_H */
-- 
2.11.0
