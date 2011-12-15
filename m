Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:37407 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758738Ab1LOJuj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 04:50:39 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [RFC 3/4] omap3isp: Configure CSI-2 phy based on platform data
Date: Thu, 15 Dec 2011 11:50:34 +0200
Message-Id: <1323942635-13058-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20111215095015.GC3677@valkosipuli.localdomain>
References: <20111215095015.GC3677@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Configure CSI-2 phy based on platform data in the ISP driver rather than in
platform code.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/isp.h       |    3 -
 drivers/media/video/omap3isp/ispcsiphy.c |   95 ++++++++++++++++++++++++++---
 drivers/media/video/omap3isp/ispcsiphy.h |    4 +
 drivers/media/video/omap3isp/ispvideo.c  |   19 ++++++
 4 files changed, 108 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
index 705946e..c5935ae 100644
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
index 5be37ce..52af308 100644
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
@@ -138,15 +140,90 @@ static void csiphy_dphy_config(struct isp_csiphy *phy)
 	isp_reg_writel(phy->isp, reg, phy->phy_regs, ISPCSIPHY_REG1);
 }
 
-static int csiphy_config(struct isp_csiphy *phy,
-			 struct isp_csiphy_dphy_cfg *dphy,
-			 struct isp_csiphy_lanes_cfg *lanes)
+/*
+ * THS_TERM: Programmed value = ceil(12.5 ns/DDRClk period) - 1.
+ * THS_SETTLE: Programmed value = ceil(90 ns/DDRClk period) + 3.
+ */
+#define THS_TERM_D 2000000
+#define THS_TERM(ddrclk_khz)					\
+(								\
+	((25 * (ddrclk_khz)) % THS_TERM_D) ?			\
+		((25 * (ddrclk_khz)) / THS_TERM_D) :		\
+		((25 * (ddrclk_khz)) / THS_TERM_D) - 1		\
+)
+
+#define THS_SETTLE_D 1000000
+#define THS_SETTLE(ddrclk_khz)					\
+(								\
+	((90 * (ddrclk_khz)) % THS_SETTLE_D) ?			\
+		((90 * (ddrclk_khz)) / THS_SETTLE_D) + 4 :	\
+		((90 * (ddrclk_khz)) / THS_SETTLE_D) + 3	\
+)
+
+/*
+ * TCLK values are OK at their reset values
+ */
+#define TCLK_TERM	0
+#define TCLK_MISS	1
+#define TCLK_SETTLE	14
+
+int omap3isp_csiphy_config(struct isp_device *isp,
+			   struct v4l2_subdev *csi2_subdev,
+			   struct v4l2_subdev *sensor,
+			   struct v4l2_mbus_framefmt *sensor_fmt)
 {
+	struct isp_v4l2_subdevs_group *subdevs = sensor->host_priv;
+	struct isp_csi2_device *csi2 = v4l2_get_subdevdata(csi2_subdev);
+	struct isp_csiphy_dphy_cfg csi2phy;
+	int csi2_ddrclk_khz;
+	struct isp_csiphy_lanes_cfg *lanes;
 	unsigned int used_lanes = 0;
 	unsigned int i;
+	u32 cam_phy_ctrl;
+
+	if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY1
+	    || subdevs->interface == ISP_INTERFACE_CCP2B_PHY2)
+		lanes = subdevs->bus.ccp2.lanecfg;
+	else
+		lanes = subdevs->bus.csi2.lanecfg;
+
+	if (!lanes) {
+		dev_err(isp->dev, "no lane configuration\n");
+		return -EINVAL;
+	}
+
+	cam_phy_ctrl = omap_readl(
+		OMAP343X_CTRL_BASE + OMAP3630_CONTROL_CAMERA_PHY_CTRL);
+	/*
+	 * SCM.CONTROL_CAMERA_PHY_CTRL
+	 * - bit[4]    : CSIPHY1 data sent to CSIB
+	 * - bit [3:2] : CSIPHY1 config: 00 d-phy, 01/10 ccp2
+	 * - bit [1:0] : CSIPHY2 config: 00 d-phy, 01/10 ccp2
+	 */
+	if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY1)
+		cam_phy_ctrl |= 1 << 2;
+	else if (subdevs->interface == ISP_INTERFACE_CSI2C_PHY1)
+		cam_phy_ctrl &= 1 << 2;
+
+	if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY2)
+		cam_phy_ctrl |= 1;
+	else if (subdevs->interface == ISP_INTERFACE_CSI2A_PHY2)
+		cam_phy_ctrl &= 1;
+
+	omap_writel(cam_phy_ctrl,
+		    OMAP343X_CTRL_BASE + OMAP3630_CONTROL_CAMERA_PHY_CTRL);
+
+	csi2_ddrclk_khz = sensor_fmt->pixel_clock
+		/ (2 * csi2->phy->num_data_lanes)
+		* omap3isp_video_format_info(sensor_fmt->code)->bpp;
+	csi2phy.ths_term = THS_TERM(csi2_ddrclk_khz);
+	csi2phy.ths_settle = THS_SETTLE(csi2_ddrclk_khz);
+	csi2phy.tclk_term = TCLK_TERM;
+	csi2phy.tclk_miss = TCLK_MISS;
+	csi2phy.tclk_settle = TCLK_SETTLE;
 
 	/* Clock and data lanes verification */
-	for (i = 0; i < phy->num_data_lanes; i++) {
+	for (i = 0; i < csi2->phy->num_data_lanes; i++) {
 		if (lanes->data[i].pol > 1 || lanes->data[i].pos > 3)
 			return -EINVAL;
 
@@ -162,10 +239,10 @@ static int csiphy_config(struct isp_csiphy *phy,
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
@@ -225,8 +302,6 @@ int omap3isp_csiphy_init(struct isp_device *isp)
 	struct isp_csiphy *phy1 = &isp->isp_csiphy1;
 	struct isp_csiphy *phy2 = &isp->isp_csiphy2;
 
-	isp->platform_cb.csiphy_config = csiphy_config;
-
 	phy2->isp = isp;
 	phy2->csi2 = &isp->isp_csi2a;
 	phy2->num_data_lanes = ISP_CSIPHY2_NUM_DATA_LANES;
diff --git a/drivers/media/video/omap3isp/ispcsiphy.h b/drivers/media/video/omap3isp/ispcsiphy.h
index e93a661..9f93222 100644
--- a/drivers/media/video/omap3isp/ispcsiphy.h
+++ b/drivers/media/video/omap3isp/ispcsiphy.h
@@ -56,6 +56,10 @@ struct isp_csiphy {
 	struct isp_csiphy_dphy_cfg dphy;
 };
 
+int omap3isp_csiphy_config(struct isp_device *isp,
+			   struct v4l2_subdev *csi2_subdev,
+			   struct v4l2_subdev *sensor,
+			   struct v4l2_mbus_framefmt *fmt);
 int omap3isp_csiphy_acquire(struct isp_csiphy *phy);
 void omap3isp_csiphy_release(struct isp_csiphy *phy);
 int omap3isp_csiphy_init(struct isp_device *isp);
diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index 17bc03c..cdcf1d0 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -299,6 +299,8 @@ static int isp_video_validate_pipeline(struct isp_pipeline *pipe)
 
 	while (1) {
 		unsigned int shifter_link;
+		struct v4l2_subdev *_subdev;
+
 		/* Retrieve the sink format */
 		pad = &subdev->entity.pads[0];
 		if (!(pad->flags & MEDIA_PAD_FL_SINK))
@@ -342,6 +344,7 @@ static int isp_video_validate_pipeline(struct isp_pipeline *pipe)
 		if (media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
 			break;
 
+		_subdev = subdev;
 		subdev = media_entity_to_v4l2_subdev(pad->entity);
 
 		fmt_source.pad = pad->index;
@@ -355,6 +358,22 @@ static int isp_video_validate_pipeline(struct isp_pipeline *pipe)
 		    fmt_source.format.height != fmt_sink.format.height)
 			return -EPIPE;
 
+		/* Configure CSI-2 receiver based on sensor format. */
+		if (_subdev == &isp->isp_csi2a.subdev
+		    || _subdev == &isp->isp_csi2c.subdev) {
+			if (cpu_is_omap3630()) {
+				/*
+				 * FIXME: CSI-2 is supported only on
+				 * the 3630!
+				 */
+				ret = omap3isp_csiphy_config(
+					isp, _subdev, subdev,
+					&fmt_source.format);
+				if (IS_ERR_VALUE(ret))
+					return -EPIPE;
+			}
+		}
+
 		if (subdev->host_priv) {
 			/*
 			 * host_priv != NULL: this is a sensor. Issue
-- 
1.7.2.5

