Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:40750 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933984Ab2AKV1T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 16:27:19 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: [PATCH 14/23] omap3isp: Configure CSI-2 phy based on platform data
Date: Wed, 11 Jan 2012 23:26:51 +0200
Message-Id: <1326317220-15339-14-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4F0DFE92.80102@iki.fi>
References: <4F0DFE92.80102@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Configure CSI-2 phy based on platform data in the ISP driver. For that, the
new V4L2_CID_IMAGE_SOURCE_PIXEL_RATE control is used. Previously the same
was configured from the board code.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/isp.c       |   29 ++++++++++-
 drivers/media/video/omap3isp/isp.h       |    4 --
 drivers/media/video/omap3isp/ispcsi2.c   |   42 ++++++++++++++-
 drivers/media/video/omap3isp/ispcsiphy.c |   84 ++++++++++++++++++++++++++----
 drivers/media/video/omap3isp/ispcsiphy.h |    5 ++
 5 files changed, 148 insertions(+), 16 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index b818cac..d268d55 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -765,6 +765,34 @@ static int isp_pipeline_enable(struct isp_pipeline *pipe,
 		if (ret < 0 && ret != -ENOIOCTLCMD)
 			return ret;
 
+		/*
+		 * Configure CCDC pixel clock. host_priv != NULL so
+		 * this one is a sensor.
+		 */
+		if (subdev->host_priv) {
+			struct v4l2_ext_controls ctrls;
+			struct v4l2_ext_control ctrl;
+
+			memset(&ctrls, 0, sizeof(ctrls));
+			memset(&ctrl, 0, sizeof(ctrl));
+
+			ctrl.id = V4L2_CID_IMAGE_SOURCE_PIXEL_RATE;
+
+			ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(ctrl.id);
+			ctrls.count = 1;
+			ctrls.controls = &ctrl;
+
+			ret = v4l2_g_ext_ctrls(subdev->ctrl_handler, &ctrls);
+			if (ret < 0) {
+				dev_warn(isp->dev,
+					 "no pixel rate control in subdev %s\n",
+					 subdev->name);
+				return -EPIPE;
+			}
+
+			isp_set_pixel_clock(isp, ctrl.value64);
+		}
+
 		if (subdev == &isp->isp_ccdc.subdev) {
 			v4l2_subdev_call(&isp->isp_aewb.subdev, video,
 					s_stream, mode);
@@ -2072,7 +2100,6 @@ static int isp_probe(struct platform_device *pdev)
 
 	isp->autoidle = autoidle;
 	isp->platform_cb.set_xclk = isp_set_xclk;
-	isp->platform_cb.set_pixel_clock = isp_set_pixel_clock;
 
 	mutex_init(&isp->isp_mutex);
 	spin_lock_init(&isp->stat_lock);
diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
index ff1c422..dd1b61e 100644
--- a/drivers/media/video/omap3isp/isp.h
+++ b/drivers/media/video/omap3isp/isp.h
@@ -126,10 +126,6 @@ struct isp_reg {
 
 struct isp_platform_callback {
 	u32 (*set_xclk)(struct isp_device *isp, u32 xclk, u8 xclksel);
-	int (*csiphy_config)(struct isp_csiphy *phy,
-			     struct isp_csiphy_dphy_cfg *dphy,
-			     struct isp_csiphy_lanes_cfg *lanes);
-	void (*set_pixel_clock)(struct isp_device *isp, unsigned int pixelclk);
 };
 
 /*
diff --git a/drivers/media/video/omap3isp/ispcsi2.c b/drivers/media/video/omap3isp/ispcsi2.c
index 0c5f1cb..0b3e705 100644
--- a/drivers/media/video/omap3isp/ispcsi2.c
+++ b/drivers/media/video/omap3isp/ispcsi2.c
@@ -1055,7 +1055,45 @@ static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
 	struct isp_video *video_out = &csi2->video_out;
 
 	switch (enable) {
-	case ISP_PIPELINE_STREAM_CONTINUOUS:
+	case ISP_PIPELINE_STREAM_CONTINUOUS: {
+		struct media_pad *remote_pad =
+			media_entity_remote_source(&sd->entity.pads[0]);
+		struct v4l2_subdev *remote_subdev =
+			media_entity_to_v4l2_subdev(remote_pad->entity);
+		struct v4l2_subdev_format fmt;
+		struct v4l2_ext_controls ctrls;
+		struct v4l2_ext_control ctrl;
+		int ret;
+
+		fmt.pad = remote_pad->index;
+		fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+		ret = v4l2_subdev_call(
+			remote_subdev, pad, get_fmt, NULL, &fmt);
+		if (ret < 0)
+			return -EPIPE;
+
+		memset(&ctrls, 0, sizeof(ctrls));
+		memset(&ctrl, 0, sizeof(ctrl));
+
+		ctrl.id = V4L2_CID_IMAGE_SOURCE_PIXEL_RATE;
+
+		ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(ctrl.id);
+		ctrls.count = 1;
+		ctrls.controls = &ctrl;
+
+		ret = v4l2_g_ext_ctrls(remote_subdev->ctrl_handler, &ctrls);
+		if (ret < 0) {
+			dev_warn(isp->dev,
+				 "no pixel rate control in subdev %s\n",
+				 remote_subdev->name);
+			return -EPIPE;
+		}
+
+		ret = omap3isp_csiphy_config(
+			isp, sd, remote_subdev, &fmt.format, ctrl.value64);
+		if (ret < 0)
+			return -EPIPE;
+
 		if (omap3isp_csiphy_acquire(csi2->phy) < 0)
 			return -ENODEV;
 		csi2->use_fs_irq = pipe->do_propagation;
@@ -1080,6 +1118,8 @@ static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
 		isp_video_dmaqueue_flags_clr(video_out);
 		break;
 
+	}
+
 	case ISP_PIPELINE_STREAM_STOPPED:
 		if (csi2->state == ISP_PIPELINE_STREAM_STOPPED)
 			return 0;
diff --git a/drivers/media/video/omap3isp/ispcsiphy.c b/drivers/media/video/omap3isp/ispcsiphy.c
index 5be37ce..f286a01 100644
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
@@ -138,15 +140,79 @@ static void csiphy_dphy_config(struct isp_csiphy *phy)
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
+			   struct v4l2_subdev *csi2_subdev,
+			   struct v4l2_subdev *sensor,
+			   struct v4l2_mbus_framefmt *sensor_fmt,
+			   uint32_t pixel_rate)
 {
+	struct isp_v4l2_subdevs_group *subdevs = sensor->host_priv;
+	struct isp_csi2_device *csi2 = v4l2_get_subdevdata(csi2_subdev);
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
+	if (!lanes) {
+		dev_err(isp->dev, "no lane configuration\n");
+		return -EINVAL;
+	}
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
+	csi2_ddrclk_khz = pixel_rate / 1000 / (2 * csi2->phy->num_data_lanes)
+		* omap3isp_video_format_info(sensor_fmt->code)->bpp;
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
 
@@ -162,10 +228,10 @@ static int csiphy_config(struct isp_csiphy *phy,
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
@@ -225,8 +291,6 @@ int omap3isp_csiphy_init(struct isp_device *isp)
 	struct isp_csiphy *phy1 = &isp->isp_csiphy1;
 	struct isp_csiphy *phy2 = &isp->isp_csiphy2;
 
-	isp->platform_cb.csiphy_config = csiphy_config;
-
 	phy2->isp = isp;
 	phy2->csi2 = &isp->isp_csi2a;
 	phy2->num_data_lanes = ISP_CSIPHY2_NUM_DATA_LANES;
diff --git a/drivers/media/video/omap3isp/ispcsiphy.h b/drivers/media/video/omap3isp/ispcsiphy.h
index e93a661..fc7e821 100644
--- a/drivers/media/video/omap3isp/ispcsiphy.h
+++ b/drivers/media/video/omap3isp/ispcsiphy.h
@@ -56,6 +56,11 @@ struct isp_csiphy {
 	struct isp_csiphy_dphy_cfg dphy;
 };
 
+int omap3isp_csiphy_config(struct isp_device *isp,
+			   struct v4l2_subdev *csi2_subdev,
+			   struct v4l2_subdev *sensor,
+			   struct v4l2_mbus_framefmt *sensor_fmt,
+			   uint32_t pixel_rate);
 int omap3isp_csiphy_acquire(struct isp_csiphy *phy);
 void omap3isp_csiphy_release(struct isp_csiphy *phy);
 int omap3isp_csiphy_init(struct isp_device *isp);
-- 
1.7.2.5

