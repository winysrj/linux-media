Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49018 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751944AbdHPMvx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 08:51:53 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz, laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 4/5] omap3isp: csiphy: Don't assume the CSI receiver is a CSI2 module
Date: Wed, 16 Aug 2017 15:51:49 +0300
Message-Id: <20170816125150.27199-5-sakari.ailus@linux.intel.com>
In-Reply-To: <20170816125150.27199-1-sakari.ailus@linux.intel.com>
References: <20170816125150.27199-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CSI PHY is associated with a CSI receiver. The code assumes this
receiver is a CSI2 module and relies on the CSI2 module object heavily to
access the ISP or pipeline objects. However, the receiver could also be a
CSI1/CCP2 module.

Pass a new CSI receiver entity pointer to the CSI PHY acquire function, and
replace all hardcoded usage of the CSI2 module with that CSI receiver
entity.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com> # on Beagleboard-xM + MPT9P031
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/media/platform/omap3isp/ispccp2.c   |  2 +-
 drivers/media/platform/omap3isp/ispcsi2.c   |  4 +--
 drivers/media/platform/omap3isp/ispcsiphy.c | 45 +++++++++++++----------------
 drivers/media/platform/omap3isp/ispcsiphy.h |  6 ++--
 4 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index 47210b102bcb..3db8df09cd9a 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -841,7 +841,7 @@ static int ccp2_s_stream(struct v4l2_subdev *sd, int enable)
 	switch (enable) {
 	case ISP_PIPELINE_STREAM_CONTINUOUS:
 		if (ccp2->phy) {
-			ret = omap3isp_csiphy_acquire(ccp2->phy);
+			ret = omap3isp_csiphy_acquire(ccp2->phy, &sd->entity);
 			if (ret < 0)
 				return ret;
 		}
diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index 7dae2fe0d42d..3ec37fed710b 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -490,7 +490,7 @@ int omap3isp_csi2_reset(struct isp_csi2_device *csi2)
 	if (!csi2->available)
 		return -ENODEV;
 
-	if (csi2->phy->phy_in_use)
+	if (csi2->phy->entity)
 		return -EBUSY;
 
 	isp_reg_set(isp, csi2->regs1, ISPCSI2_SYSCONFIG,
@@ -1053,7 +1053,7 @@ static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
 
 	switch (enable) {
 	case ISP_PIPELINE_STREAM_CONTINUOUS:
-		if (omap3isp_csiphy_acquire(csi2->phy) < 0)
+		if (omap3isp_csiphy_acquire(csi2->phy, &sd->entity) < 0)
 			return -ENODEV;
 		if (csi2->output & CSI2_OUTPUT_MEMORY)
 			omap3isp_sbl_enable(isp, OMAP3_ISP_SBL_CSI2A_WRITE);
diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/platform/omap3isp/ispcsiphy.c
index 2028bb519108..ed1eb9907ae0 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.c
+++ b/drivers/media/platform/omap3isp/ispcsiphy.c
@@ -164,22 +164,17 @@ static int csiphy_set_power(struct isp_csiphy *phy, u32 power)
 
 static int omap3isp_csiphy_config(struct isp_csiphy *phy)
 {
-	struct isp_csi2_device *csi2 = phy->csi2;
-	struct isp_pipeline *pipe = to_isp_pipeline(&csi2->subdev.entity);
-	struct isp_bus_cfg *buscfg = pipe->external->host_priv;
+	struct isp_pipeline *pipe = to_isp_pipeline(phy->entity);
+	struct isp_async_subdev *isd =
+		container_of(pipe->external->asd, struct isp_async_subdev, asd);
+	struct isp_bus_cfg *buscfg = pipe->external->host_priv ?
+		pipe->external->host_priv : &isd->bus;
 	struct isp_csiphy_lanes_cfg *lanes;
 	int csi2_ddrclk_khz;
 	unsigned int num_data_lanes, used_lanes = 0;
 	unsigned int i;
 	u32 reg;
 
-	if (!buscfg) {
-		struct isp_async_subdev *isd =
-			container_of(pipe->external->asd,
-				     struct isp_async_subdev, asd);
-		buscfg = &isd->bus;
-	}
-
 	if (buscfg->interface == ISP_INTERFACE_CCP2B_PHY1
 	    || buscfg->interface == ISP_INTERFACE_CCP2B_PHY2) {
 		lanes = &buscfg->bus.ccp2.lanecfg;
@@ -222,7 +217,7 @@ static int omap3isp_csiphy_config(struct isp_csiphy *phy)
 	csi2_ddrclk_khz = pipe->external_rate / 1000
 		/ (2 * hweight32(used_lanes)) * pipe->external_width;
 
-	reg = isp_reg_readl(csi2->isp, phy->phy_regs, ISPCSIPHY_REG0);
+	reg = isp_reg_readl(phy->isp, phy->phy_regs, ISPCSIPHY_REG0);
 
 	reg &= ~(ISPCSIPHY_REG0_THS_TERM_MASK |
 		 ISPCSIPHY_REG0_THS_SETTLE_MASK);
@@ -233,9 +228,9 @@ static int omap3isp_csiphy_config(struct isp_csiphy *phy)
 	reg |= (DIV_ROUND_UP(90 * csi2_ddrclk_khz, 1000000) + 3)
 		<< ISPCSIPHY_REG0_THS_SETTLE_SHIFT;
 
-	isp_reg_writel(csi2->isp, reg, phy->phy_regs, ISPCSIPHY_REG0);
+	isp_reg_writel(phy->isp, reg, phy->phy_regs, ISPCSIPHY_REG0);
 
-	reg = isp_reg_readl(csi2->isp, phy->phy_regs, ISPCSIPHY_REG1);
+	reg = isp_reg_readl(phy->isp, phy->phy_regs, ISPCSIPHY_REG1);
 
 	reg &= ~(ISPCSIPHY_REG1_TCLK_TERM_MASK |
 		 ISPCSIPHY_REG1_TCLK_MISS_MASK |
@@ -244,10 +239,10 @@ static int omap3isp_csiphy_config(struct isp_csiphy *phy)
 	reg |= TCLK_MISS << ISPCSIPHY_REG1_TCLK_MISS_SHIFT;
 	reg |= TCLK_SETTLE << ISPCSIPHY_REG1_TCLK_SETTLE_SHIFT;
 
-	isp_reg_writel(csi2->isp, reg, phy->phy_regs, ISPCSIPHY_REG1);
+	isp_reg_writel(phy->isp, reg, phy->phy_regs, ISPCSIPHY_REG1);
 
 	/* DPHY lane configuration */
-	reg = isp_reg_readl(csi2->isp, phy->cfg_regs, ISPCSI2_PHY_CFG);
+	reg = isp_reg_readl(phy->isp, phy->cfg_regs, ISPCSI2_PHY_CFG);
 
 	for (i = 0; i < num_data_lanes; i++) {
 		reg &= ~(ISPCSI2_PHY_CFG_DATA_POL_MASK(i + 1) |
@@ -263,12 +258,12 @@ static int omap3isp_csiphy_config(struct isp_csiphy *phy)
 	reg |= lanes->clk.pol << ISPCSI2_PHY_CFG_CLOCK_POL_SHIFT;
 	reg |= lanes->clk.pos << ISPCSI2_PHY_CFG_CLOCK_POSITION_SHIFT;
 
-	isp_reg_writel(csi2->isp, reg, phy->cfg_regs, ISPCSI2_PHY_CFG);
+	isp_reg_writel(phy->isp, reg, phy->cfg_regs, ISPCSI2_PHY_CFG);
 
 	return 0;
 }
 
-int omap3isp_csiphy_acquire(struct isp_csiphy *phy)
+int omap3isp_csiphy_acquire(struct isp_csiphy *phy, struct media_entity *entity)
 {
 	int rval;
 
@@ -288,6 +283,8 @@ int omap3isp_csiphy_acquire(struct isp_csiphy *phy)
 	if (rval < 0)
 		goto done;
 
+	phy->entity = entity;
+
 	rval = omap3isp_csiphy_config(phy);
 	if (rval < 0)
 		goto done;
@@ -301,10 +298,10 @@ int omap3isp_csiphy_acquire(struct isp_csiphy *phy)
 
 		csiphy_power_autoswitch_enable(phy, true);
 	}
-
-	phy->phy_in_use = 1;
-
 done:
+	if (rval < 0)
+		phy->entity = NULL;
+
 	mutex_unlock(&phy->mutex);
 	return rval;
 }
@@ -312,10 +309,8 @@ int omap3isp_csiphy_acquire(struct isp_csiphy *phy)
 void omap3isp_csiphy_release(struct isp_csiphy *phy)
 {
 	mutex_lock(&phy->mutex);
-	if (phy->phy_in_use) {
-		struct isp_csi2_device *csi2 = phy->csi2;
-		struct isp_pipeline *pipe =
-			to_isp_pipeline(&csi2->subdev.entity);
+	if (phy->entity) {
+		struct isp_pipeline *pipe = to_isp_pipeline(phy->entity);
 		struct isp_bus_cfg *buscfg = pipe->external->host_priv;
 
 		csiphy_routing_cfg(phy, buscfg->interface, false,
@@ -325,7 +320,7 @@ void omap3isp_csiphy_release(struct isp_csiphy *phy)
 			csiphy_set_power(phy, ISPCSI2_PHY_CFG_PWR_CMD_OFF);
 		}
 		regulator_disable(phy->vdd);
-		phy->phy_in_use = 0;
+		phy->entity = NULL;
 	}
 	mutex_unlock(&phy->mutex);
 }
diff --git a/drivers/media/platform/omap3isp/ispcsiphy.h b/drivers/media/platform/omap3isp/ispcsiphy.h
index 978ca5c80a6c..91543a09b28a 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.h
+++ b/drivers/media/platform/omap3isp/ispcsiphy.h
@@ -25,9 +25,10 @@ struct regulator;
 struct isp_csiphy {
 	struct isp_device *isp;
 	struct mutex mutex;	/* serialize csiphy configuration */
-	u8 phy_in_use;
 	struct isp_csi2_device *csi2;
 	struct regulator *vdd;
+	/* the entity that acquired the phy */
+	struct media_entity *entity;
 
 	/* mem resources - enums as defined in enum isp_mem_resources */
 	unsigned int cfg_regs;
@@ -36,7 +37,8 @@ struct isp_csiphy {
 	u8 num_data_lanes;	/* number of CSI2 Data Lanes supported */
 };
 
-int omap3isp_csiphy_acquire(struct isp_csiphy *phy);
+int omap3isp_csiphy_acquire(struct isp_csiphy *phy,
+			    struct media_entity *entity);
 void omap3isp_csiphy_release(struct isp_csiphy *phy);
 int omap3isp_csiphy_init(struct isp_device *isp);
 void omap3isp_csiphy_cleanup(struct isp_device *isp);
-- 
2.11.0
