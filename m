Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:36381 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063Ab2BPHlM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 02:41:12 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: [PATCH v2.1 1/1] omap3isp: Configure CSI-2 phy based on platform data
Date: Thu, 16 Feb 2012 09:40:44 +0200
Message-Id: <1329378044-24265-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <CAKnK67Srr3LFF6d12nmvqn=at-Pa+PMD=60r8jv06uDRERQAzA@mail.gmail.com>
References: <CAKnK67Srr3LFF6d12nmvqn=at-Pa+PMD=60r8jv06uDRERQAzA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

Configure CSI-2 phy based on platform data in the ISP driver. For that, the
new V4L2_CID_IMAGE_SOURCE_PIXEL_RATE control is used. Previously the same
was configured from the board code.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/isp.h       |    3 -
 drivers/media/video/omap3isp/ispcsiphy.c |  168 +++++++++++++++++-------------
 drivers/media/video/omap3isp/ispcsiphy.h |   10 --
 3 files changed, 97 insertions(+), 84 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
index 8b0bc2d..43a1b16 100644
--- a/drivers/media/video/omap3isp/isp.h
+++ b/drivers/media/video/omap3isp/isp.h
@@ -126,9 +126,6 @@ struct isp_reg {
 
 struct isp_platform_callback {
 	u32 (*set_xclk)(struct isp_device *isp, u32 xclk, u8 xclksel);
-	int (*csiphy_config)(struct isp_csiphy *phy,
-			     struct isp_csiphy_dphy_cfg *dphy,
-			     struct isp_csiphy_lanes_cfg *lanes);
 	void (*set_pixel_clock)(struct isp_device *isp, unsigned int pixelclk);
 };
 
diff --git a/drivers/media/video/omap3isp/ispcsiphy.c b/drivers/media/video/omap3isp/ispcsiphy.c
index 5be37ce..902477d 100644
--- a/drivers/media/video/omap3isp/ispcsiphy.c
+++ b/drivers/media/video/omap3isp/ispcsiphy.c
@@ -28,41 +28,13 @@
 #include <linux/device.h>
 #include <linux/regulator/consumer.h>
 
+#include "../../../../arch/arm/mach-omap2/control.h"
+
 #include "isp.h"
 #include "ispreg.h"
 #include "ispcsiphy.h"
 
 /*
- * csiphy_lanes_config - Configuration of CSIPHY lanes.
- *
- * Updates HW configuration.
- * Called with phy->mutex taken.
- */
-static void csiphy_lanes_config(struct isp_csiphy *phy)
-{
-	unsigned int i;
-	u32 reg;
-
-	reg = isp_reg_readl(phy->isp, phy->cfg_regs, ISPCSI2_PHY_CFG);
-
-	for (i = 0; i < phy->num_data_lanes; i++) {
-		reg &= ~(ISPCSI2_PHY_CFG_DATA_POL_MASK(i + 1) |
-			 ISPCSI2_PHY_CFG_DATA_POSITION_MASK(i + 1));
-		reg |= (phy->lanes.data[i].pol <<
-			ISPCSI2_PHY_CFG_DATA_POL_SHIFT(i + 1));
-		reg |= (phy->lanes.data[i].pos <<
-			ISPCSI2_PHY_CFG_DATA_POSITION_SHIFT(i + 1));
-	}
-
-	reg &= ~(ISPCSI2_PHY_CFG_CLOCK_POL_MASK |
-		 ISPCSI2_PHY_CFG_CLOCK_POSITION_MASK);
-	reg |= phy->lanes.clk.pol << ISPCSI2_PHY_CFG_CLOCK_POL_SHIFT;
-	reg |= phy->lanes.clk.pos << ISPCSI2_PHY_CFG_CLOCK_POSITION_SHIFT;
-
-	isp_reg_writel(phy->isp, reg, phy->cfg_regs, ISPCSI2_PHY_CFG);
-}
-
-/*
  * csiphy_power_autoswitch_enable
  * @enable: Sets or clears the autoswitch function enable flag.
  */
@@ -107,46 +79,31 @@ static int csiphy_set_power(struct isp_csiphy *phy, u32 power)
 }
 
 /*
- * csiphy_dphy_config - Configure CSI2 D-PHY parameters.
- *
- * Called with phy->mutex taken.
+ * TCLK values are OK at their reset values
  */
-static void csiphy_dphy_config(struct isp_csiphy *phy)
-{
-	u32 reg;
-
-	/* Set up ISPCSIPHY_REG0 */
-	reg = isp_reg_readl(phy->isp, phy->phy_regs, ISPCSIPHY_REG0);
-
-	reg &= ~(ISPCSIPHY_REG0_THS_TERM_MASK |
-		 ISPCSIPHY_REG0_THS_SETTLE_MASK);
-	reg |= phy->dphy.ths_term << ISPCSIPHY_REG0_THS_TERM_SHIFT;
-	reg |= phy->dphy.ths_settle << ISPCSIPHY_REG0_THS_SETTLE_SHIFT;
-
-	isp_reg_writel(phy->isp, reg, phy->phy_regs, ISPCSIPHY_REG0);
-
-	/* Set up ISPCSIPHY_REG1 */
-	reg = isp_reg_readl(phy->isp, phy->phy_regs, ISPCSIPHY_REG1);
-
-	reg &= ~(ISPCSIPHY_REG1_TCLK_TERM_MASK |
-		 ISPCSIPHY_REG1_TCLK_MISS_MASK |
-		 ISPCSIPHY_REG1_TCLK_SETTLE_MASK);
-	reg |= phy->dphy.tclk_term << ISPCSIPHY_REG1_TCLK_TERM_SHIFT;
-	reg |= phy->dphy.tclk_miss << ISPCSIPHY_REG1_TCLK_MISS_SHIFT;
-	reg |= phy->dphy.tclk_settle << ISPCSIPHY_REG1_TCLK_SETTLE_SHIFT;
+#define TCLK_TERM	0
+#define TCLK_MISS	1
+#define TCLK_SETTLE	14
 
-	isp_reg_writel(phy->isp, reg, phy->phy_regs, ISPCSIPHY_REG1);
-}
-
-static int csiphy_config(struct isp_csiphy *phy,
-			 struct isp_csiphy_dphy_cfg *dphy,
-			 struct isp_csiphy_lanes_cfg *lanes)
+static int omap3isp_csiphy_config(struct isp_csiphy *phy)
 {
+	struct isp_csi2_device *csi2 = phy->csi2;
+	struct isp_pipeline *pipe = to_isp_pipeline(&csi2->subdev.entity);
+	struct isp_v4l2_subdevs_group *subdevs = pipe->external->host_priv;
+	struct isp_csiphy_lanes_cfg *lanes;
+	int csi2_ddrclk_khz;
 	unsigned int used_lanes = 0;
 	unsigned int i;
+	u32 reg;
+
+	if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY1
+	    || subdevs->interface == ISP_INTERFACE_CCP2B_PHY2)
+		lanes = &subdevs->bus.ccp2.lanecfg;
+	else
+		lanes = &subdevs->bus.csi2.lanecfg;
 
 	/* Clock and data lanes verification */
-	for (i = 0; i < phy->num_data_lanes; i++) {
+	for (i = 0; i < csi2->phy->num_data_lanes; i++) {
 		if (lanes->data[i].pol > 1 || lanes->data[i].pos > 3)
 			return -EINVAL;
 
@@ -162,10 +119,80 @@ static int csiphy_config(struct isp_csiphy *phy,
 	if (lanes->clk.pos == 0 || used_lanes & (1 << lanes->clk.pos))
 		return -EINVAL;
 
-	mutex_lock(&phy->mutex);
-	phy->dphy = *dphy;
-	phy->lanes = *lanes;
-	mutex_unlock(&phy->mutex);
+	/* FIXME: Do 34xx / 35xx require something here? */
+	if (cpu_is_omap3630()) {
+		u32 cam_phy_ctrl =
+			omap_readl(OMAP343X_CTRL_BASE
+				   + OMAP3630_CONTROL_CAMERA_PHY_CTRL);
+
+		/*
+		 * SCM.CONTROL_CAMERA_PHY_CTRL
+		 * - bit[4]    : CSIPHY1 data sent to CSIB
+		 * - bit [3:2] : CSIPHY1 config: 00 d-phy, 01/10 ccp2
+		 * - bit [1:0] : CSIPHY2 config: 00 d-phy, 01/10 ccp2
+		 */
+		if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY1)
+			cam_phy_ctrl |= 1 << 2;
+		else if (subdevs->interface == ISP_INTERFACE_CSI2C_PHY1)
+			cam_phy_ctrl &= ~(1 << 2);
+
+		if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY2)
+			cam_phy_ctrl |= 1;
+		else if (subdevs->interface == ISP_INTERFACE_CSI2A_PHY2)
+			cam_phy_ctrl &= ~1;
+
+		omap_writel(cam_phy_ctrl,
+			    OMAP343X_CTRL_BASE
+			    + OMAP3630_CONTROL_CAMERA_PHY_CTRL);
+	}
+
+	/* DPHY timing configuration */
+	/* CSI-2 is DDR and we only count used lanes. */
+	csi2_ddrclk_khz = pipe->external_rate / 1000
+		/ (2 * hweight32(used_lanes)) * pipe->external_bpp;
+
+	reg = isp_reg_readl(csi2->isp, csi2->phy->phy_regs, ISPCSIPHY_REG0);
+
+	reg &= ~(ISPCSIPHY_REG0_THS_TERM_MASK |
+		 ISPCSIPHY_REG0_THS_SETTLE_MASK);
+	/* THS_TERM: Programmed value = ceil(12.5 ns/DDRClk period) - 1. */
+	reg |= (DIV_ROUND_UP(25 * csi2_ddrclk_khz, 2000000) - 1)
+		<< ISPCSIPHY_REG0_THS_TERM_SHIFT;
+	/* THS_SETTLE: Programmed value = ceil(90 ns/DDRClk period) + 3. */
+	reg |= (DIV_ROUND_UP(90 * csi2_ddrclk_khz, 1000000) + 3)
+		<< ISPCSIPHY_REG0_THS_SETTLE_SHIFT;
+
+	isp_reg_writel(csi2->isp, reg, csi2->phy->phy_regs, ISPCSIPHY_REG0);
+
+	reg = isp_reg_readl(csi2->isp, csi2->phy->phy_regs, ISPCSIPHY_REG1);
+
+	reg &= ~(ISPCSIPHY_REG1_TCLK_TERM_MASK |
+		 ISPCSIPHY_REG1_TCLK_MISS_MASK |
+		 ISPCSIPHY_REG1_TCLK_SETTLE_MASK);
+	reg |= TCLK_TERM << ISPCSIPHY_REG1_TCLK_TERM_SHIFT;
+	reg |= TCLK_MISS << ISPCSIPHY_REG1_TCLK_MISS_SHIFT;
+	reg |= TCLK_SETTLE << ISPCSIPHY_REG1_TCLK_SETTLE_SHIFT;
+
+	isp_reg_writel(csi2->isp, reg, csi2->phy->phy_regs, ISPCSIPHY_REG1);
+
+	/* DPHY lane configuration */
+	reg = isp_reg_readl(csi2->isp, csi2->phy->cfg_regs, ISPCSI2_PHY_CFG);
+
+	for (i = 0; i < csi2->phy->num_data_lanes; i++) {
+		reg &= ~(ISPCSI2_PHY_CFG_DATA_POL_MASK(i + 1) |
+			 ISPCSI2_PHY_CFG_DATA_POSITION_MASK(i + 1));
+		reg |= (lanes->data[i].pol <<
+			ISPCSI2_PHY_CFG_DATA_POL_SHIFT(i + 1));
+		reg |= (lanes->data[i].pos <<
+			ISPCSI2_PHY_CFG_DATA_POSITION_SHIFT(i + 1));
+	}
+
+	reg &= ~(ISPCSI2_PHY_CFG_CLOCK_POL_MASK |
+		 ISPCSI2_PHY_CFG_CLOCK_POSITION_MASK);
+	reg |= lanes->clk.pol << ISPCSI2_PHY_CFG_CLOCK_POL_SHIFT;
+	reg |= lanes->clk.pos << ISPCSI2_PHY_CFG_CLOCK_POSITION_SHIFT;
+
+	isp_reg_writel(csi2->isp, reg, csi2->phy->cfg_regs, ISPCSI2_PHY_CFG);
 
 	return 0;
 }
@@ -188,8 +215,9 @@ int omap3isp_csiphy_acquire(struct isp_csiphy *phy)
 
 	omap3isp_csi2_reset(phy->csi2);
 
-	csiphy_dphy_config(phy);
-	csiphy_lanes_config(phy);
+	rval = omap3isp_csiphy_config(phy);
+	if (rval < 0)
+		goto done;
 
 	rval = csiphy_set_power(phy, ISPCSI2_PHY_CFG_PWR_CMD_ON);
 	if (rval) {
@@ -225,8 +253,6 @@ int omap3isp_csiphy_init(struct isp_device *isp)
 	struct isp_csiphy *phy1 = &isp->isp_csiphy1;
 	struct isp_csiphy *phy2 = &isp->isp_csiphy2;
 
-	isp->platform_cb.csiphy_config = csiphy_config;
-
 	phy2->isp = isp;
 	phy2->csi2 = &isp->isp_csi2a;
 	phy2->num_data_lanes = ISP_CSIPHY2_NUM_DATA_LANES;
diff --git a/drivers/media/video/omap3isp/ispcsiphy.h b/drivers/media/video/omap3isp/ispcsiphy.h
index e93a661..14551fd 100644
--- a/drivers/media/video/omap3isp/ispcsiphy.h
+++ b/drivers/media/video/omap3isp/ispcsiphy.h
@@ -32,14 +32,6 @@
 struct isp_csi2_device;
 struct regulator;
 
-struct isp_csiphy_dphy_cfg {
-	u8 ths_term;
-	u8 ths_settle;
-	u8 tclk_term;
-	unsigned tclk_miss:1;
-	u8 tclk_settle;
-};
-
 struct isp_csiphy {
 	struct isp_device *isp;
 	struct mutex mutex;	/* serialize csiphy configuration */
@@ -52,8 +44,6 @@ struct isp_csiphy {
 	unsigned int phy_regs;
 
 	u8 num_data_lanes;	/* number of CSI2 Data Lanes supported */
-	struct isp_csiphy_lanes_cfg lanes;
-	struct isp_csiphy_dphy_cfg dphy;
 };
 
 int omap3isp_csiphy_acquire(struct isp_csiphy *phy);
-- 
1.7.2.5

