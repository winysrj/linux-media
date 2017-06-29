Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33996 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751666AbdF2HaO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 03:30:14 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [PATCH 2/2] v4l: fwnode: Support generic parsing of graph endpoints in V4L2
Date: Thu, 29 Jun 2017 10:30:10 +0300
Message-Id: <1498721410-28199-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1498721410-28199-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1498721410-28199-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current practice is that drivers iterate over their endpoints and
parse each endpoint separately. This is very similar in a number of
drivers, implement a generic function for the job. Driver specific matters
can be taken into account in the driver specific callback.

Convert the omap3isp as an example.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/isp.c | 91 ++++++++++-----------------------
 drivers/media/platform/omap3isp/isp.h |  3 --
 drivers/media/v4l2-core/v4l2-fwnode.c | 94 +++++++++++++++++++++++++++++++++++
 include/media/v4l2-async.h            |  4 +-
 include/media/v4l2-fwnode.h           |  9 ++++
 5 files changed, 132 insertions(+), 69 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 9df64c1..9ccf883 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2008,43 +2008,42 @@ enum isp_of_phy {
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
+			!!(vep->bus.parallel.flags &
+			   V4L2_MBUS_VSYNC_ACTIVE_LOW);
 		buscfg->bus.parallel.vs_pol =
-			!!(vep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW);
+			!!(vep->bus.parallel.flags &
+			   V4L2_MBUS_HSYNC_ACTIVE_LOW);
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
@@ -2052,18 +2051,19 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
 			buscfg->interface = ISP_INTERFACE_CSI2A_PHY2;
 			break;
 		}
-		buscfg->bus.csi2.lanecfg.clk.pos = vep.bus.mipi_csi2.clock_lane;
+		buscfg->bus.csi2.lanecfg.clk.pos =
+			vep->bus.mipi_csi2.clock_lane;
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
@@ -2079,55 +2079,14 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
 
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
@@ -2210,7 +2169,9 @@ static int isp_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = isp_fwnodes_parse(&pdev->dev, &isp->notifier);
+	ret = v4l2_fwnode_endpoints_parse(
+		&pdev->dev, &isp->notifier, sizeof(struct isp_async_subdev),
+		isp_fwnode_parse);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index 2f2ae60..a852c11 100644
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
index 0ec6c14..b35d525 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -26,6 +26,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 
+#include <media/v4l2-async.h>
 #include <media/v4l2-fwnode.h>
 
 static int v4l2_fwnode_endpoint_parse_csi_bus(struct fwnode_handle *fwnode,
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
index c69d8c8..067f368 100644
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
index ecc1233..ff489f7 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -25,6 +25,8 @@
 #include <media/v4l2-mediabus.h>
 
 struct fwnode_handle;
+struct v4l2_async_notifier;
+struct v4l2_async_subdev;
 
 /**
  * struct v4l2_fwnode_bus_mipi_csi2 - MIPI CSI-2 bus data structure
@@ -101,4 +103,11 @@ int v4l2_fwnode_parse_link(struct fwnode_handle *fwnode,
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
2.1.4
