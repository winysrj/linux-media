Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:18924 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677Ab2BBXzD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Feb 2012 18:55:03 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v2 27/31] omap3isp: Configure CSI-2 phy based on platform data
Date: Fri,  3 Feb 2012 01:54:47 +0200
Message-Id: <1328226891-8968-27-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120202235231.GC841@valkosipuli.localdomain>
References: <20120202235231.GC841@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Configure CSI-2 phy based on platform data in the ISP driver. For that, the
new V4L2_CID_IMAGE_SOURCE_PIXEL_RATE control is used. Previously the same
was configured from the board code.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/ispcsi2.c   |   10 +++-
 drivers/media/video/omap3isp/ispcsiphy.c |   78 ++++++++++++++++++++++++++----
 drivers/media/video/omap3isp/ispcsiphy.h |    2 +
 3 files changed, 78 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispcsi2.c b/drivers/media/video/omap3isp/ispcsi2.c
index 9313f7c..e2e3d63 100644
--- a/drivers/media/video/omap3isp/ispcsi2.c
+++ b/drivers/media/video/omap3isp/ispcsi2.c
@@ -1068,7 +1068,13 @@ static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
 	struct isp_video *video_out = &csi2->video_out;
 
 	switch (enable) {
-	case ISP_PIPELINE_STREAM_CONTINUOUS:
+	case ISP_PIPELINE_STREAM_CONTINUOUS: {
+		int ret;
+
+		ret = omap3isp_csiphy_config(isp, sd);
+		if (ret < 0)
+			return ret;
+
 		if (omap3isp_csiphy_acquire(csi2->phy) < 0)
 			return -ENODEV;
 		csi2->use_fs_irq = pipe->do_propagation;
@@ -1092,7 +1098,7 @@ static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
 		csi2_if_enable(isp, csi2, 1);
 		isp_video_dmaqueue_flags_clr(video_out);
 		break;
-
+	}
 	case ISP_PIPELINE_STREAM_STOPPED:
 		if (csi2->state == ISP_PIPELINE_STREAM_STOPPED)
 			return 0;
diff --git a/drivers/media/video/omap3isp/ispcsiphy.c b/drivers/media/video/omap3isp/ispcsiphy.c
index 5be37ce..5d7a6ab 100644
--- a/drivers/media/video/omap3isp/ispcsiphy.c
+++ b/drivers/media/video/omap3isp/ispcsiphy.c
@@ -28,6 +28,8 @@
 #include <linux/device.h>
 #include <linux/regulator/consumer.h>
 
+#include "../../../../arch/arm/mach-omap2/control.h"
+
 #include "isp.h"
 #include "ispreg.h"
 #include "ispcsiphy.h"
@@ -138,15 +140,73 @@ static void csiphy_dphy_config(struct isp_csiphy *phy)
 	isp_reg_writel(phy->isp, reg, phy->phy_regs, ISPCSIPHY_REG1);
 }
 
-static int csiphy_config(struct isp_csiphy *phy,
-			 struct isp_csiphy_dphy_cfg *dphy,
-			 struct isp_csiphy_lanes_cfg *lanes)
+/*
+ * TCLK values are OK at their reset values
+ */
+#define TCLK_TERM	0
+#define TCLK_MISS	1
+#define TCLK_SETTLE	14
+
+int omap3isp_csiphy_config(struct isp_device *isp,
+			   struct v4l2_subdev *csi2_subdev)
 {
+	struct isp_csi2_device *csi2 = v4l2_get_subdevdata(csi2_subdev);
+	struct isp_pipeline *pipe = to_isp_pipeline(&csi2_subdev->entity);
+	struct isp_v4l2_subdevs_group *subdevs = pipe->external->host_priv;
+	struct isp_csiphy_dphy_cfg csi2phy;
+	int csi2_ddrclk_khz;
+	struct isp_csiphy_lanes_cfg *lanes;
 	unsigned int used_lanes = 0;
 	unsigned int i;
 
+	if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY1
+	    || subdevs->interface == ISP_INTERFACE_CCP2B_PHY2)
+		lanes = &subdevs->bus.ccp2.lanecfg;
+	else
+		lanes = &subdevs->bus.csi2.lanecfg;
+
+	/* FIXME: Do 34xx / 35xx require something here? */
+	if (cpu_is_omap3630()) {
+		u32 cam_phy_ctrl = omap_readl(
+			OMAP343X_CTRL_BASE + OMAP3630_CONTROL_CAMERA_PHY_CTRL);
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
+			cam_phy_ctrl &= 1 << 2;
+
+		if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY2)
+			cam_phy_ctrl |= 1;
+		else if (subdevs->interface == ISP_INTERFACE_CSI2A_PHY2)
+			cam_phy_ctrl &= 1;
+
+		omap_writel(cam_phy_ctrl,
+			    OMAP343X_CTRL_BASE
+			    + OMAP3630_CONTROL_CAMERA_PHY_CTRL);
+	}
+
+	csi2_ddrclk_khz = pipe->external_rate / 1000
+		/ (2 * csi2->phy->num_data_lanes)
+		* pipe->external_bpp;
+
+	/*
+	 * THS_TERM: Programmed value = ceil(12.5 ns/DDRClk period) - 1.
+	 * THS_SETTLE: Programmed value = ceil(90 ns/DDRClk period) + 3.
+	 */
+	csi2phy.ths_term = DIV_ROUND_UP(25 * csi2_ddrclk_khz, 2000000) - 1;
+	csi2phy.ths_settle = DIV_ROUND_UP(90 * csi2_ddrclk_khz, 1000000) + 3;
+	csi2phy.tclk_term = TCLK_TERM;
+	csi2phy.tclk_miss = TCLK_MISS;
+	csi2phy.tclk_settle = TCLK_SETTLE;
+
 	/* Clock and data lanes verification */
-	for (i = 0; i < phy->num_data_lanes; i++) {
+	for (i = 0; i < csi2->phy->num_data_lanes; i++) {
 		if (lanes->data[i].pol > 1 || lanes->data[i].pos > 3)
 			return -EINVAL;
 
@@ -162,10 +222,10 @@ static int csiphy_config(struct isp_csiphy *phy,
 	if (lanes->clk.pos == 0 || used_lanes & (1 << lanes->clk.pos))
 		return -EINVAL;
 
-	mutex_lock(&phy->mutex);
-	phy->dphy = *dphy;
-	phy->lanes = *lanes;
-	mutex_unlock(&phy->mutex);
+	mutex_lock(&csi2->phy->mutex);
+	csi2->phy->dphy = csi2phy;
+	csi2->phy->lanes = *lanes;
+	mutex_unlock(&csi2->phy->mutex);
 
 	return 0;
 }
@@ -225,8 +285,6 @@ int omap3isp_csiphy_init(struct isp_device *isp)
 	struct isp_csiphy *phy1 = &isp->isp_csiphy1;
 	struct isp_csiphy *phy2 = &isp->isp_csiphy2;
 
-	isp->platform_cb.csiphy_config = csiphy_config;
-
 	phy2->isp = isp;
 	phy2->csi2 = &isp->isp_csi2a;
 	phy2->num_data_lanes = ISP_CSIPHY2_NUM_DATA_LANES;
diff --git a/drivers/media/video/omap3isp/ispcsiphy.h b/drivers/media/video/omap3isp/ispcsiphy.h
index e93a661..a404b10 100644
--- a/drivers/media/video/omap3isp/ispcsiphy.h
+++ b/drivers/media/video/omap3isp/ispcsiphy.h
@@ -56,6 +56,8 @@ struct isp_csiphy {
 	struct isp_csiphy_dphy_cfg dphy;
 };
 
+int omap3isp_csiphy_config(struct isp_device *isp,
+			   struct v4l2_subdev *csi2_subdev);
 int omap3isp_csiphy_acquire(struct isp_csiphy *phy);
 void omap3isp_csiphy_release(struct isp_csiphy *phy);
 int omap3isp_csiphy_init(struct isp_device *isp);
-- 
1.7.2.5

