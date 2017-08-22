Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47260 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932866AbdHVMa0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 08:30:26 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org
Subject: [PATCH v4 2/3] v4l: fwnode: Support generic parsing of graph endpoints in a device
Date: Tue, 22 Aug 2017 15:30:22 +0300
Message-Id: <20170822123023.6149-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20170822123023.6149-1-sakari.ailus@linux.intel.com>
References: <20170822123023.6149-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current practice is that drivers iterate over their endpoints and
parse each endpoint separately. This is very similar in a number of
drivers, implement a generic function for the job. Driver specific matters
can be taken into account in the driver specific callback.

Convert the omap3isp as an example.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/isp.c | 115 ++++++++++---------------------
 drivers/media/v4l2-core/v4l2-fwnode.c | 125 ++++++++++++++++++++++++++++++++++
 include/media/v4l2-async.h            |   4 +-
 include/media/v4l2-fwnode.h           |   9 +++
 4 files changed, 172 insertions(+), 81 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 83aea08b832d..93fc3d93e602 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2011,44 +2011,41 @@ enum isp_of_phy {
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
-	unsigned int i;
-	int ret;
 	bool csi1 = false;
-
-	ret = v4l2_fwnode_endpoint_parse(fwnode, &vep);
-	if (ret)
-		return ret;
+	unsigned int i;
 
 	dev_dbg(dev, "parsing endpoint %pOF, interface %u\n",
-		to_of_node(fwnode), vep.base.port);
+		to_of_node(vep->base.local_fwnode), vep->base.port);
 
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
-		buscfg->bus.parallel.bt656 = vep.bus_type == V4L2_MBUS_BT656;
+			!!(vep->bus.parallel.flags & V4L2_MBUS_DATA_ACTIVE_LOW);
+		buscfg->bus.parallel.bt656 = vep->bus_type == V4L2_MBUS_BT656;
 		break;
 
 	case ISP_OF_PHY_CSIPHY1:
 	case ISP_OF_PHY_CSIPHY2:
-		switch (vep.bus_type) {
+		switch (vep->bus_type) {
 		case V4L2_MBUS_CCP2:
 		case V4L2_MBUS_CSI1:
 			dev_dbg(dev, "CSI-1/CCP-2 configuration\n");
@@ -2060,11 +2057,11 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
 			break;
 		default:
 			dev_err(dev, "unsupported bus type %u\n",
-				vep.bus_type);
+				vep->bus_type);
 			return -EINVAL;
 		}
 
-		switch (vep.base.port) {
+		switch (vep->base.port) {
 		case ISP_OF_PHY_CSIPHY1:
 			if (csi1)
 				buscfg->interface = ISP_INTERFACE_CCP2B_PHY1;
@@ -2080,47 +2077,47 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
 		}
 		if (csi1) {
 			buscfg->bus.ccp2.lanecfg.clk.pos =
-				vep.bus.mipi_csi1.clock_lane;
+				vep->bus.mipi_csi1.clock_lane;
 			buscfg->bus.ccp2.lanecfg.clk.pol =
-				vep.bus.mipi_csi1.lane_polarity[0];
+				vep->bus.mipi_csi1.lane_polarity[0];
 			dev_dbg(dev, "clock lane polarity %u, pos %u\n",
 				buscfg->bus.ccp2.lanecfg.clk.pol,
 				buscfg->bus.ccp2.lanecfg.clk.pos);
 
 			buscfg->bus.ccp2.lanecfg.data[0].pos =
-				vep.bus.mipi_csi1.data_lane;
+				vep->bus.mipi_csi1.data_lane;
 			buscfg->bus.ccp2.lanecfg.data[0].pol =
-				vep.bus.mipi_csi1.lane_polarity[1];
+				vep->bus.mipi_csi1.lane_polarity[1];
 
-			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
+			dev_dbg(dev, "data lane polarity %u, pos %u\n",
 				buscfg->bus.ccp2.lanecfg.data[0].pol,
 				buscfg->bus.ccp2.lanecfg.data[0].pos);
 
 			buscfg->bus.ccp2.strobe_clk_pol =
-				vep.bus.mipi_csi1.clock_inv;
-			buscfg->bus.ccp2.phy_layer = vep.bus.mipi_csi1.strobe;
+				vep->bus.mipi_csi1.clock_inv;
+			buscfg->bus.ccp2.phy_layer = vep->bus.mipi_csi1.strobe;
 			buscfg->bus.ccp2.ccp2_mode =
-				vep.bus_type == V4L2_MBUS_CCP2;
+				vep->bus_type == V4L2_MBUS_CCP2;
 			buscfg->bus.ccp2.vp_clk_pol = 1;
 
 			buscfg->bus.ccp2.crc = 1;
 		} else {
 			buscfg->bus.csi2.lanecfg.clk.pos =
-				vep.bus.mipi_csi2.clock_lane;
+				vep->bus.mipi_csi2.clock_lane;
 			buscfg->bus.csi2.lanecfg.clk.pol =
-				vep.bus.mipi_csi2.lane_polarities[0];
+				vep->bus.mipi_csi2.lane_polarities[0];
 			dev_dbg(dev, "clock lane polarity %u, pos %u\n",
 				buscfg->bus.csi2.lanecfg.clk.pol,
 				buscfg->bus.csi2.lanecfg.clk.pos);
 
 			buscfg->bus.csi2.num_data_lanes =
-				vep.bus.mipi_csi2.num_data_lanes;
+				vep->bus.mipi_csi2.num_data_lanes;
 
 			for (i = 0; i < buscfg->bus.csi2.num_data_lanes; i++) {
 				buscfg->bus.csi2.lanecfg.data[i].pos =
-					vep.bus.mipi_csi2.data_lanes[i];
+					vep->bus.mipi_csi2.data_lanes[i];
 				buscfg->bus.csi2.lanecfg.data[i].pol =
-					vep.bus.mipi_csi2.lane_polarities[i + 1];
+					vep->bus.mipi_csi2.lane_polarities[i + 1];
 				dev_dbg(dev,
 					"data lane %u polarity %u, pos %u\n", i,
 					buscfg->bus.csi2.lanecfg.data[i].pol,
@@ -2137,57 +2134,13 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
 
 	default:
 		dev_warn(dev, "%pOF: invalid interface %u\n",
-			 to_of_node(fwnode), vep.base.port);
+			 to_of_node(vep->base.local_fwnode), vep->base.port);
 		return -EINVAL;
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
-		if (isp_fwnode_parse(dev, fwnode, isd)) {
-			devm_kfree(dev, isd);
-			continue;
-		}
-
-		notifier->subdevs[notifier->num_subdevs] = &isd->asd;
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
 static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
 {
 	struct isp_device *isp = container_of(async, struct isp_device,
@@ -2256,7 +2209,9 @@ static int isp_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = isp_fwnodes_parse(&pdev->dev, &isp->notifier);
+	ret = v4l2_fwnode_endpoints_parse(
+		&pdev->dev, &isp->notifier, sizeof(struct isp_async_subdev),
+		isp_fwnode_parse);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 5cd2687310fe..cb0fc4b4e3bf 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -26,6 +26,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 
+#include <media/v4l2-async.h>
 #include <media/v4l2-fwnode.h>
 
 enum v4l2_fwnode_bus_type {
@@ -383,6 +384,130 @@ void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link)
 }
 EXPORT_SYMBOL_GPL(v4l2_fwnode_put_link);
 
+static int notifier_realloc(struct device *dev,
+			    struct v4l2_async_notifier *notifier,
+			    unsigned int max_subdevs)
+{
+	struct v4l2_async_subdev **subdevs;
+	unsigned int i;
+
+	if (max_subdevs + notifier->num_subdevs <= notifier->max_subdevs)
+		return 0;
+
+	subdevs = devm_kcalloc(
+		dev, max_subdevs + notifier->num_subdevs,
+		sizeof(*notifier->subdevs), GFP_KERNEL);
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
+	notifier->max_subdevs = max_subdevs + notifier->num_subdevs;
+
+	return 0;
+}
+
+static int __v4l2_fwnode_endpoint_parse(
+	struct device *dev, struct v4l2_async_notifier *notifier,
+	struct fwnode_handle *endpoint, struct v4l2_async_subdev *asd,
+	int (*parse_single)(struct device *dev,
+			    struct v4l2_fwnode_endpoint *vep,
+			    struct v4l2_async_subdev *asd))
+{
+	struct v4l2_fwnode_endpoint *vep;
+	int ret;
+
+	/* Ignore endpoints the parsing of which failed. */
+	vep = v4l2_fwnode_endpoint_alloc_parse(endpoint);
+	if (IS_ERR(vep))
+		return 0;
+
+	notifier->subdevs[notifier->num_subdevs] = asd;
+
+	ret = parse_single(dev, vep, asd);
+	v4l2_fwnode_endpoint_free(vep);
+	if (ret)
+		return ret;
+
+	asd->match.fwnode.fwnode =
+		fwnode_graph_get_remote_port_parent(endpoint);
+	if (!asd->match.fwnode.fwnode) {
+		dev_warn(dev, "bad remote port parent\n");
+		return -EINVAL;
+	}
+
+	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
+	notifier->num_subdevs++;
+
+	return 0;
+}
+
+/**
+ * v4l2_fwnode_endpoint_parse - Parse V4L2 fwnode endpoints in a device node
+ * @dev: local struct device
+ * @notifier: async notifier related to @dev
+ * @asd_struct_size: size of the driver's async sub-device struct, including
+ *		     sizeof(struct v4l2_async_subdev)
+ * @parse_single: driver's callback function called on each V4L2 fwnode endpoint
+ *
+ * Parse all V4L2 fwnode endpoints related to the device.
+ *
+ * Note that this function is intended for drivers to replace the existing
+ * implementation that loops over all ports and endpoints. It is NOT INTENDED TO
+ * BE USED BY NEW DRIVERS.
+ */
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
+		struct v4l2_async_subdev *asd;
+
+		asd = devm_kzalloc(dev, asd_struct_size, GFP_KERNEL);
+		if (!asd) {
+			ret = -ENOMEM;
+			goto error;
+		}
+
+		ret = __v4l2_fwnode_endpoint_parse(dev, notifier, fwnode, asd,
+						   parse_single);
+		if (ret < 0)
+			goto error;
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
index c69d8c8a66d0..067f3687774b 100644
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
index cb34dcb0bb65..c75a768d4ef7 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -25,6 +25,8 @@
 #include <media/v4l2-mediabus.h>
 
 struct fwnode_handle;
+struct v4l2_async_notifier;
+struct v4l2_async_subdev;
 
 #define MAX_DATA_LANES	4
 
@@ -122,4 +124,11 @@ int v4l2_fwnode_parse_link(struct fwnode_handle *fwnode,
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
