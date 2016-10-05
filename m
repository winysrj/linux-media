Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:9732 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751378AbcJEHXt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Oct 2016 03:23:49 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id DAAB320CD6
        for <linux-media@vger.kernel.org>; Wed,  5 Oct 2016 10:23:16 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [RFC 3/5] omap3isp: Switch to fwnode API
Date: Wed,  5 Oct 2016 10:21:47 +0300
Message-Id: <1475652109-22164-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1475652109-22164-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1475652109-22164-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/isp.c | 75 ++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 37 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 0321d84..f999629 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -55,6 +55,7 @@
 #include <linux/module.h>
 #include <linux/omap-iommu.h>
 #include <linux/platform_device.h>
+#include <linux/property.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
@@ -63,9 +64,9 @@
 #include <asm/dma-iommu.h>
 
 #include <media/v4l2-common.h>
+#include <media/v4l2-fwnode.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mc.h>
-#include <media/v4l2-of.h>
 
 #include "isp.h"
 #include "ispreg.h"
@@ -2024,43 +2025,42 @@ enum isp_of_phy {
 	ISP_OF_PHY_CSIPHY2,
 };
 
-static int isp_of_parse_node(struct device *dev, struct device_node *node,
-			     struct isp_async_subdev *isd)
+static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwn,
+			    struct isp_async_subdev *isd)
 {
 	struct isp_bus_cfg *buscfg = &isd->bus;
-	struct v4l2_of_endpoint vep;
+	struct v4l2_fwnode_endpoint vfwn;
 	unsigned int i;
 	int ret;
 
-	ret = v4l2_of_parse_endpoint(node, &vep);
+	ret = v4l2_fwnode_endpoint_parse(fwn, &vfwn);
 	if (ret)
 		return ret;
 
-	dev_dbg(dev, "parsing endpoint %s, interface %u\n", node->full_name,
-		vep.base.port);
+	dev_dbg(dev, "interface %u\n", vfwn.base.port);
 
-	switch (vep.base.port) {
+	switch (vfwn.base.port) {
 	case ISP_OF_PHY_PARALLEL:
 		buscfg->interface = ISP_INTERFACE_PARALLEL;
 		buscfg->bus.parallel.data_lane_shift =
-			vep.bus.parallel.data_shift;
+			vfwn.bus.parallel.data_shift;
 		buscfg->bus.parallel.clk_pol =
-			!!(vep.bus.parallel.flags
+			!!(vfwn.bus.parallel.flags
 			   & V4L2_MBUS_PCLK_SAMPLE_FALLING);
 		buscfg->bus.parallel.hs_pol =
-			!!(vep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW);
+			!!(vfwn.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW);
 		buscfg->bus.parallel.vs_pol =
-			!!(vep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW);
+			!!(vfwn.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW);
 		buscfg->bus.parallel.fld_pol =
-			!!(vep.bus.parallel.flags & V4L2_MBUS_FIELD_EVEN_LOW);
+			!!(vfwn.bus.parallel.flags & V4L2_MBUS_FIELD_EVEN_LOW);
 		buscfg->bus.parallel.data_pol =
-			!!(vep.bus.parallel.flags & V4L2_MBUS_DATA_ACTIVE_LOW);
+			!!(vfwn.bus.parallel.flags & V4L2_MBUS_DATA_ACTIVE_LOW);
 		break;
 
 	case ISP_OF_PHY_CSIPHY1:
 	case ISP_OF_PHY_CSIPHY2:
 		/* FIXME: always assume CSI-2 for now. */
-		switch (vep.base.port) {
+		switch (vfwn.base.port) {
 		case ISP_OF_PHY_CSIPHY1:
 			buscfg->interface = ISP_INTERFACE_CSI2C_PHY1;
 			break;
@@ -2068,18 +2068,18 @@ static int isp_of_parse_node(struct device *dev, struct device_node *node,
 			buscfg->interface = ISP_INTERFACE_CSI2A_PHY2;
 			break;
 		}
-		buscfg->bus.csi2.lanecfg.clk.pos = vep.bus.mipi_csi2.clock_lane;
+		buscfg->bus.csi2.lanecfg.clk.pos = vfwn.bus.mipi_csi2.clock_lane;
 		buscfg->bus.csi2.lanecfg.clk.pol =
-			vep.bus.mipi_csi2.lane_polarities[0];
+			vfwn.bus.mipi_csi2.lane_polarities[0];
 		dev_dbg(dev, "clock lane polarity %u, pos %u\n",
 			buscfg->bus.csi2.lanecfg.clk.pol,
 			buscfg->bus.csi2.lanecfg.clk.pos);
 
 		for (i = 0; i < ISP_CSIPHY2_NUM_DATA_LANES; i++) {
 			buscfg->bus.csi2.lanecfg.data[i].pos =
-				vep.bus.mipi_csi2.data_lanes[i];
+				vfwn.bus.mipi_csi2.data_lanes[i];
 			buscfg->bus.csi2.lanecfg.data[i].pol =
-				vep.bus.mipi_csi2.lane_polarities[i + 1];
+				vfwn.bus.mipi_csi2.lane_polarities[i + 1];
 			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
 				buscfg->bus.csi2.lanecfg.data[i].pol,
 				buscfg->bus.csi2.lanecfg.data[i].pos);
@@ -2094,18 +2094,17 @@ static int isp_of_parse_node(struct device *dev, struct device_node *node,
 		break;
 
 	default:
-		dev_warn(dev, "%s: invalid interface %u\n", node->full_name,
-			 vep.base.port);
+		dev_warn(dev, "invalid interface %u\n", vfwn.base.port);
 		break;
 	}
 
 	return 0;
 }
 
-static int isp_of_parse_nodes(struct device *dev,
-			      struct v4l2_async_notifier *notifier)
+static int isp_fwnodes_parse(struct device *dev,
+			     struct v4l2_async_notifier *notifier)
 {
-	struct device_node *node = NULL;
+	struct fwnode_handle *fwn = NULL;
 
 	notifier->subdevs = devm_kcalloc(
 		dev, ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);
@@ -2113,30 +2112,32 @@ static int isp_of_parse_nodes(struct device *dev,
 		return -ENOMEM;
 
 	while (notifier->num_subdevs < ISP_MAX_SUBDEVS &&
-	       (node = of_graph_get_next_endpoint(dev->of_node, node))) {
+	       (fwn = fwnode_graph_get_next_endpoint(device_fwnode_handle(dev),
+						     fwn))) {
 		struct isp_async_subdev *isd;
 
 		isd = devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
 		if (!isd) {
-			of_node_put(node);
+			fwnode_handle_put(fwn);
 			return -ENOMEM;
 		}
 
 		notifier->subdevs[notifier->num_subdevs] = &isd->asd;
 
-		if (isp_of_parse_node(dev, node, isd)) {
-			of_node_put(node);
+		if (isp_fwnode_parse(dev, fwn, isd)) {
+			fwnode_handle_put(fwn);
 			return -EINVAL;
 		}
 
-		isd->asd.match.of.node = of_graph_get_remote_port_parent(node);
-		of_node_put(node);
-		if (!isd->asd.match.of.node) {
+		isd->asd.match.fwnode.fwn =
+			fwnode_graph_get_remote_port_parent(fwn);
+		fwnode_handle_put(fwn);
+		if (!isd->asd.match.fwnode.fwn) {
 			dev_warn(dev, "bad remote port parent\n");
 			return -EINVAL;
 		}
 
-		isd->asd.match_type = V4L2_ASYNC_MATCH_OF;
+		isd->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
 		notifier->num_subdevs++;
 	}
 
@@ -2210,8 +2211,8 @@ static int isp_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	ret = of_property_read_u32(pdev->dev.of_node, "ti,phy-type",
-				   &isp->phy_type);
+	ret = fwnode_property_read_u32(device_fwnode_handle(&pdev->dev),
+				       "ti,phy-type", &isp->phy_type);
 	if (ret)
 		return ret;
 
@@ -2220,12 +2221,12 @@ static int isp_probe(struct platform_device *pdev)
 	if (IS_ERR(isp->syscon))
 		return PTR_ERR(isp->syscon);
 
-	ret = of_property_read_u32_index(pdev->dev.of_node, "syscon", 1,
-					 &isp->syscon_offset);
+	ret = of_property_read_u32_index(pdev->dev.of_node,
+					 "syscon", 1, &isp->syscon_offset);
 	if (ret)
 		return ret;
 
-	ret = isp_of_parse_nodes(&pdev->dev, &isp->notifier);
+	ret = isp_fwnodes_parse(&pdev->dev, &isp->notifier);
 	if (ret < 0)
 		return ret;
 
-- 
2.7.4

