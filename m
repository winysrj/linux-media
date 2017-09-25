Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49372 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754227AbdIYWZt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 18:25:49 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v14 06/28] omap3isp: Use generic parser for parsing fwnode endpoints
Date: Tue, 26 Sep 2017 01:25:17 +0300
Message-Id: <20170925222540.371-7-sakari.ailus@linux.intel.com>
In-Reply-To: <20170925222540.371-1-sakari.ailus@linux.intel.com>
References: <20170925222540.371-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using a custom driver implementation, use
v4l2_async_notifier_parse_fwnode_endpoints() to parse the fwnode endpoints
of the device.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c | 121 +++++++++++-----------------------
 drivers/media/platform/omap3isp/isp.h |   5 +-
 2 files changed, 40 insertions(+), 86 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 1a428fe9f070..97a5206b6ddc 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2001,6 +2001,7 @@ static int isp_remove(struct platform_device *pdev)
 	__omap3isp_put(isp, false);
 
 	media_entity_enum_cleanup(&isp->crashed);
+	v4l2_async_notifier_cleanup(&isp->notifier);
 
 	return 0;
 }
@@ -2011,44 +2012,41 @@ enum isp_of_phy {
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
@@ -2060,11 +2058,11 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
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
@@ -2080,47 +2078,47 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
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
 
 			dev_dbg(dev, "data lane polarity %u, pos %u\n",
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
@@ -2137,57 +2135,13 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
 
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
@@ -2256,15 +2210,17 @@ static int isp_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = isp_fwnodes_parse(&pdev->dev, &isp->notifier);
-	if (ret < 0)
-		return ret;
-
 	isp->autoidle = autoidle;
 
 	mutex_init(&isp->isp_mutex);
 	spin_lock_init(&isp->stat_lock);
 
+	ret = v4l2_async_notifier_parse_fwnode_endpoints(
+		&pdev->dev, &isp->notifier, sizeof(struct isp_async_subdev),
+		isp_fwnode_parse);
+	if (ret < 0)
+		goto error;
+
 	isp->dev = &pdev->dev;
 	isp->ref_count = 0;
 
@@ -2406,6 +2362,7 @@ static int isp_probe(struct platform_device *pdev)
 	isp_xclk_cleanup(isp);
 	__omap3isp_put(isp, false);
 error:
+	v4l2_async_notifier_cleanup(&isp->notifier);
 	mutex_destroy(&isp->isp_mutex);
 
 	return ret;
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index e528df6efc09..8b9043db94b3 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -220,14 +220,11 @@ struct isp_device {
 
 	unsigned int sbl_resources;
 	unsigned int subclk_resources;
-
-#define ISP_MAX_SUBDEVS		8
-	struct v4l2_subdev *subdevs[ISP_MAX_SUBDEVS];
 };
 
 struct isp_async_subdev {
-	struct isp_bus_cfg bus;
 	struct v4l2_async_subdev asd;
+	struct isp_bus_cfg bus;
 };
 
 #define v4l2_subdev_to_bus_cfg(sd) \
-- 
2.11.0
