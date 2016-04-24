Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33250 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbcDXVKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:10:35 -0400
Received: by mail-wm0-f65.google.com with SMTP id r12so17689153wme.0
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 14:10:34 -0700 (PDT)
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org
Subject: [RFC PATCH 21/24] omap3isp: dt: Add support for CSI1/CCP2 busses
Date: Mon, 25 Apr 2016 00:08:21 +0300
Message-Id: <1461532104-24032-22-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

Obtain the CSI1/CCP2 bus parameters from the OF node.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/platform/omap3isp/isp.c | 110 ++++++++++++++++++++++++----------
 1 file changed, 77 insertions(+), 33 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 5d54e2c..e51a1f9 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2020,12 +2020,84 @@ enum isp_of_phy {
 	ISP_OF_PHY_CSIPHY2,
 };
 
+static void isp_of_parse_node_csi1(struct device *dev,
+				   struct isp_bus_cfg *buscfg,
+				   struct v4l2_of_endpoint *vep)
+{
+	if (vep->base.port == ISP_OF_PHY_CSIPHY1)
+		buscfg->interface = ISP_INTERFACE_CCP2B_PHY1;
+	else
+		buscfg->interface = ISP_INTERFACE_CCP2B_PHY2;
+	buscfg->bus.ccp2.lanecfg.clk.pos = vep->bus.mipi_csi1.clock_lane;
+	buscfg->bus.ccp2.lanecfg.clk.pol =
+		vep->bus.mipi_csi1.lane_polarity[0];
+	dev_dbg(dev, "clock lane polarity %u, pos %u\n",
+		buscfg->bus.ccp2.lanecfg.clk.pol,
+		buscfg->bus.ccp2.lanecfg.clk.pos);
+
+	buscfg->bus.ccp2.lanecfg.data[0].pos = vep->bus.mipi_csi2.data_lanes[0];
+	buscfg->bus.ccp2.lanecfg.data[0].pol =
+		vep->bus.mipi_csi2.lane_polarities[1];
+	dev_dbg(dev, "data lane polarity %u, pos %u\n",
+		buscfg->bus.ccp2.lanecfg.data[0].pol,
+		buscfg->bus.ccp2.lanecfg.data[0].pos);
+
+	buscfg->bus.ccp2.strobe_clk_pol = vep->bus.mipi_csi1.clock_inv;
+	buscfg->bus.ccp2.phy_layer = vep->bus.mipi_csi1.strobe;
+	buscfg->bus.ccp2.ccp2_mode = vep->bus_type == V4L2_MBUS_CCP2;
+
+	dev_dbg(dev, "clock_inv %u strobe %u ccp2 %u\n",
+		buscfg->bus.ccp2.strobe_clk_pol,
+		buscfg->bus.ccp2.phy_layer,
+		buscfg->bus.ccp2.ccp2_mode);
+	/*
+	 * FIXME: now we assume the CRC is always there.
+	 * Implement a way to obtain this information from the
+	 * sensor. Frame descriptors, perhaps?
+	 */
+	buscfg->bus.ccp2.crc = 1;
+}
+
+static void isp_of_parse_node_csi2(struct device *dev,
+				   struct isp_bus_cfg *buscfg,
+				   struct v4l2_of_endpoint *vep)
+{
+	unsigned int i;
+
+	if (vep->base.port == ISP_OF_PHY_CSIPHY1)
+		buscfg->interface = ISP_INTERFACE_CSI2C_PHY1;
+	else
+		buscfg->interface = ISP_INTERFACE_CSI2A_PHY2;
+	buscfg->bus.csi2.lanecfg.clk.pos = vep->bus.mipi_csi2.clock_lane;
+	buscfg->bus.csi2.lanecfg.clk.pol =
+			vep->bus.mipi_csi2.lane_polarities[0];
+	dev_dbg(dev, "clock lane polarity %u, pos %u\n",
+		buscfg->bus.csi2.lanecfg.clk.pol,
+		buscfg->bus.csi2.lanecfg.clk.pos);
+
+	for (i = 0; i < ISP_CSIPHY2_NUM_DATA_LANES; i++) {
+		buscfg->bus.csi2.lanecfg.data[i].pos =
+			vep->bus.mipi_csi2.data_lanes[i];
+		buscfg->bus.csi2.lanecfg.data[i].pol =
+			vep->bus.mipi_csi2.lane_polarities[i + 1];
+		dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
+			buscfg->bus.csi2.lanecfg.data[i].pol,
+				buscfg->bus.csi2.lanecfg.data[i].pos);
+	}
+
+	/*
+	 * FIXME: now we assume the CRC is always there.
+	 * Implement a way to obtain this information from the
+	 * sensor. Frame descriptors, perhaps?
+	 */
+	buscfg->bus.csi2.crc = 1;
+}
+
 static int isp_of_parse_node(struct device *dev, struct device_node *node,
 			     struct isp_async_subdev *isd)
 {
 	struct isp_bus_cfg *buscfg = &isd->bus;
 	struct v4l2_of_endpoint vep;
-	unsigned int i;
 	int ret;
 
 	ret = v4l2_of_parse_endpoint(node, &vep);
@@ -2055,38 +2127,10 @@ static int isp_of_parse_node(struct device *dev, struct device_node *node,
 
 	case ISP_OF_PHY_CSIPHY1:
 	case ISP_OF_PHY_CSIPHY2:
-		/* FIXME: always assume CSI-2 for now. */
-		switch (vep.base.port) {
-		case ISP_OF_PHY_CSIPHY1:
-			buscfg->interface = ISP_INTERFACE_CSI2C_PHY1;
-			break;
-		case ISP_OF_PHY_CSIPHY2:
-			buscfg->interface = ISP_INTERFACE_CSI2A_PHY2;
-			break;
-		}
-		buscfg->bus.csi2.lanecfg.clk.pos = vep.bus.mipi_csi2.clock_lane;
-		buscfg->bus.csi2.lanecfg.clk.pol =
-			vep.bus.mipi_csi2.lane_polarities[0];
-		dev_dbg(dev, "clock lane polarity %u, pos %u\n",
-			buscfg->bus.csi2.lanecfg.clk.pol,
-			buscfg->bus.csi2.lanecfg.clk.pos);
-
-		for (i = 0; i < ISP_CSIPHY2_NUM_DATA_LANES; i++) {
-			buscfg->bus.csi2.lanecfg.data[i].pos =
-				vep.bus.mipi_csi2.data_lanes[i];
-			buscfg->bus.csi2.lanecfg.data[i].pol =
-				vep.bus.mipi_csi2.lane_polarities[i + 1];
-			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
-				buscfg->bus.csi2.lanecfg.data[i].pol,
-				buscfg->bus.csi2.lanecfg.data[i].pos);
-		}
-
-		/*
-		 * FIXME: now we assume the CRC is always there.
-		 * Implement a way to obtain this information from the
-		 * sensor. Frame descriptors, perhaps?
-		 */
-		buscfg->bus.csi2.crc = 1;
+		if (vep.bus_type == V4L2_MBUS_CSI2)
+			isp_of_parse_node_csi2(dev, buscfg, &vep);
+		else
+			isp_of_parse_node_csi1(dev, buscfg, &vep);
 		break;
 
 	default:
-- 
1.9.1

