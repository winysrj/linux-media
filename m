Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47672 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752442AbdGMQTH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 12:19:07 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz
Subject: [PATCH 1/2] omap3isp: Explicitly set the number of CSI-2 lanes used in lane cfg
Date: Thu, 13 Jul 2017 19:19:02 +0300
Message-Id: <20170713161903.9974-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20170713161903.9974-1-sakari.ailus@linux.intel.com>
References: <20170713161903.9974-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The omap3isp driver extracts the CSI-2 lane configuration from the V4L2
fwnode endpoint but misses the number of lanes itself. Get this information
and use it in PHY configuration.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/isp.c       |  5 ++++-
 drivers/media/platform/omap3isp/ispcsiphy.c | 16 +++++++++++-----
 drivers/media/platform/omap3isp/omap3isp.h  |  3 +++
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 088dc8b1b78a..db2cccb57ceb 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2061,7 +2061,10 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
 			buscfg->bus.csi2.lanecfg.clk.pol,
 			buscfg->bus.csi2.lanecfg.clk.pos);
 
-		for (i = 0; i < ISP_CSIPHY2_NUM_DATA_LANES; i++) {
+		buscfg->bus.csi2.num_data_lanes =
+			vep.bus.mipi_csi2.num_data_lanes;
+
+		for (i = 0; i < buscfg->bus.csi2.num_data_lanes; i++) {
 			buscfg->bus.csi2.lanecfg.data[i].pos =
 				vep.bus.mipi_csi2.data_lanes[i];
 			buscfg->bus.csi2.lanecfg.data[i].pol =
diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/platform/omap3isp/ispcsiphy.c
index 83940e9d8291..3efa71396aae 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.c
+++ b/drivers/media/platform/omap3isp/ispcsiphy.c
@@ -169,7 +169,7 @@ static int omap3isp_csiphy_config(struct isp_csiphy *phy)
 	struct isp_bus_cfg *buscfg = pipe->external->host_priv;
 	struct isp_csiphy_lanes_cfg *lanes;
 	int csi2_ddrclk_khz;
-	unsigned int used_lanes = 0;
+	unsigned int num_data_lanes, used_lanes = 0;
 	unsigned int i;
 	u32 reg;
 
@@ -181,13 +181,19 @@ static int omap3isp_csiphy_config(struct isp_csiphy *phy)
 	}
 
 	if (buscfg->interface == ISP_INTERFACE_CCP2B_PHY1
-	    || buscfg->interface == ISP_INTERFACE_CCP2B_PHY2)
+	    || buscfg->interface == ISP_INTERFACE_CCP2B_PHY2) {
 		lanes = &buscfg->bus.ccp2.lanecfg;
-	else
+		num_data_lanes = 1;
+	} else {
 		lanes = &buscfg->bus.csi2.lanecfg;
+		num_data_lanes = buscfg->bus.csi2.num_data_lanes;
+	}
+
+	if (num_data_lanes > phy->num_data_lanes)
+		return -EINVAL;
 
 	/* Clock and data lanes verification */
-	for (i = 0; i < phy->num_data_lanes; i++) {
+	for (i = 0; i < num_data_lanes; i++) {
 		if (lanes->data[i].pol > 1 || lanes->data[i].pos > 3)
 			return -EINVAL;
 
@@ -243,7 +249,7 @@ static int omap3isp_csiphy_config(struct isp_csiphy *phy)
 	/* DPHY lane configuration */
 	reg = isp_reg_readl(csi2->isp, phy->cfg_regs, ISPCSI2_PHY_CFG);
 
-	for (i = 0; i < phy->num_data_lanes; i++) {
+	for (i = 0; i < num_data_lanes; i++) {
 		reg &= ~(ISPCSI2_PHY_CFG_DATA_POL_MASK(i + 1) |
 			 ISPCSI2_PHY_CFG_DATA_POSITION_MASK(i + 1));
 		reg |= (lanes->data[i].pol <<
diff --git a/drivers/media/platform/omap3isp/omap3isp.h b/drivers/media/platform/omap3isp/omap3isp.h
index 443e8f7673e2..3c26f9a3f508 100644
--- a/drivers/media/platform/omap3isp/omap3isp.h
+++ b/drivers/media/platform/omap3isp/omap3isp.h
@@ -114,10 +114,13 @@ struct isp_ccp2_cfg {
 /**
  * struct isp_csi2_cfg - CSI2 interface configuration
  * @crc: Enable the cyclic redundancy check
+ * @lanecfg: CSI-2 lane configuration
+ * @num_data_lanes: The number of data lanes in use
  */
 struct isp_csi2_cfg {
 	unsigned crc:1;
 	struct isp_csiphy_lanes_cfg lanecfg;
+	u8 num_data_lanes;
 };
 
 struct isp_bus_cfg {
-- 
2.11.0
