Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49000 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751882AbdHPMvw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 08:51:52 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz, laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 1/5] omap3isp: Parse CSI1 configuration from the device tree
Date: Wed, 16 Aug 2017 15:51:46 +0300
Message-Id: <20170816125150.27199-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20170816125150.27199-1-sakari.ailus@linux.intel.com>
References: <20170816125150.27199-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pavel Machek <pavel@ucw.cz>

Add support for parsing CSI1 configuration.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com> # on Beagleboard-xM + MPT9P031
---
 drivers/media/platform/omap3isp/isp.c      | 105 +++++++++++++++++++++--------
 drivers/media/platform/omap3isp/omap3isp.h |   1 +
 2 files changed, 79 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 79aff6b989a1..6cb1f0495804 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2018,6 +2018,7 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
 	struct v4l2_fwnode_endpoint vep;
 	unsigned int i;
 	int ret;
+	bool csi1 = false;
 
 	ret = v4l2_fwnode_endpoint_parse(fwnode, &vep);
 	if (ret)
@@ -2047,41 +2048,91 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
 
 	case ISP_OF_PHY_CSIPHY1:
 	case ISP_OF_PHY_CSIPHY2:
-		/* FIXME: always assume CSI-2 for now. */
+		switch (vep.bus_type) {
+		case V4L2_MBUS_CCP2:
+		case V4L2_MBUS_CSI1:
+			dev_dbg(dev, "CSI-1/CCP-2 configuration\n");
+			csi1 = true;
+			break;
+		case V4L2_MBUS_CSI2:
+			dev_dbg(dev, "CSI-2 configuration\n");
+			csi1 = false;
+			break;
+		default:
+			dev_err(dev, "unsupported bus type %u\n",
+				vep.bus_type);
+			return -EINVAL;
+		}
+
 		switch (vep.base.port) {
 		case ISP_OF_PHY_CSIPHY1:
-			buscfg->interface = ISP_INTERFACE_CSI2C_PHY1;
+			if (csi1)
+				buscfg->interface = ISP_INTERFACE_CCP2B_PHY1;
+			else
+				buscfg->interface = ISP_INTERFACE_CSI2C_PHY1;
 			break;
 		case ISP_OF_PHY_CSIPHY2:
-			buscfg->interface = ISP_INTERFACE_CSI2A_PHY2;
+			if (csi1)
+				buscfg->interface = ISP_INTERFACE_CCP2B_PHY2;
+			else
+				buscfg->interface = ISP_INTERFACE_CSI2A_PHY2;
 			break;
 		}
-		buscfg->bus.csi2.lanecfg.clk.pos = vep.bus.mipi_csi2.clock_lane;
-		buscfg->bus.csi2.lanecfg.clk.pol =
-			vep.bus.mipi_csi2.lane_polarities[0];
-		dev_dbg(dev, "clock lane polarity %u, pos %u\n",
-			buscfg->bus.csi2.lanecfg.clk.pol,
-			buscfg->bus.csi2.lanecfg.clk.pos);
-
-		buscfg->bus.csi2.num_data_lanes =
-			vep.bus.mipi_csi2.num_data_lanes;
-
-		for (i = 0; i < buscfg->bus.csi2.num_data_lanes; i++) {
-			buscfg->bus.csi2.lanecfg.data[i].pos =
-				vep.bus.mipi_csi2.data_lanes[i];
-			buscfg->bus.csi2.lanecfg.data[i].pol =
-				vep.bus.mipi_csi2.lane_polarities[i + 1];
+		if (csi1) {
+			buscfg->bus.ccp2.lanecfg.clk.pos =
+				vep.bus.mipi_csi1.clock_lane;
+			buscfg->bus.ccp2.lanecfg.clk.pol =
+				vep.bus.mipi_csi1.lane_polarity[0];
+			dev_dbg(dev, "clock lane polarity %u, pos %u\n",
+				buscfg->bus.ccp2.lanecfg.clk.pol,
+				buscfg->bus.ccp2.lanecfg.clk.pos);
+
+			buscfg->bus.ccp2.lanecfg.data[0].pos =
+				vep.bus.mipi_csi1.data_lane;
+			buscfg->bus.ccp2.lanecfg.data[0].pol =
+				vep.bus.mipi_csi1.lane_polarity[1];
+
 			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
-				buscfg->bus.csi2.lanecfg.data[i].pol,
-				buscfg->bus.csi2.lanecfg.data[i].pos);
+				buscfg->bus.ccp2.lanecfg.data[0].pol,
+				buscfg->bus.ccp2.lanecfg.data[0].pos);
+
+			buscfg->bus.ccp2.strobe_clk_pol =
+				vep.bus.mipi_csi1.clock_inv;
+			buscfg->bus.ccp2.phy_layer = vep.bus.mipi_csi1.strobe;
+			buscfg->bus.ccp2.ccp2_mode =
+				vep.bus_type == V4L2_MBUS_CCP2;
+			buscfg->bus.ccp2.vp_clk_pol = 1;
+
+			buscfg->bus.ccp2.crc = 1;
+		} else {
+			buscfg->bus.csi2.lanecfg.clk.pos =
+				vep.bus.mipi_csi2.clock_lane;
+			buscfg->bus.csi2.lanecfg.clk.pol =
+				vep.bus.mipi_csi2.lane_polarities[0];
+			dev_dbg(dev, "clock lane polarity %u, pos %u\n",
+				buscfg->bus.csi2.lanecfg.clk.pol,
+				buscfg->bus.csi2.lanecfg.clk.pos);
+
+			buscfg->bus.csi2.num_data_lanes =
+				vep.bus.mipi_csi2.num_data_lanes;
+
+			for (i = 0; i < buscfg->bus.csi2.num_data_lanes; i++) {
+				buscfg->bus.csi2.lanecfg.data[i].pos =
+					vep.bus.mipi_csi2.data_lanes[i];
+				buscfg->bus.csi2.lanecfg.data[i].pol =
+					vep.bus.mipi_csi2.lane_polarities[i + 1];
+				dev_dbg(dev,
+					"data lane %u polarity %u, pos %u\n", i,
+					buscfg->bus.csi2.lanecfg.data[i].pol,
+					buscfg->bus.csi2.lanecfg.data[i].pos);
+			}
+			/*
+			 * FIXME: now we assume the CRC is always there.
+			 * Implement a way to obtain this information from the
+			 * sensor. Frame descriptors, perhaps?
+			 */
+			buscfg->bus.csi2.crc = 1;
 		}
-
-		/*
-		 * FIXME: now we assume the CRC is always there.
-		 * Implement a way to obtain this information from the
-		 * sensor. Frame descriptors, perhaps?
-		 */
-		buscfg->bus.csi2.crc = 1;
 		break;
 
 	default:
diff --git a/drivers/media/platform/omap3isp/omap3isp.h b/drivers/media/platform/omap3isp/omap3isp.h
index dfd3cbe26ccd..9fb4d5bce004 100644
--- a/drivers/media/platform/omap3isp/omap3isp.h
+++ b/drivers/media/platform/omap3isp/omap3isp.h
@@ -110,6 +110,7 @@ struct isp_ccp2_cfg {
 	unsigned int ccp2_mode:1;
 	unsigned int phy_layer:1;
 	unsigned int vpclk_div:2;
+	unsigned int vp_clk_pol:1;
 	struct isp_csiphy_lanes_cfg lanecfg;
 };
 
-- 
2.11.0
