Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38480 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbbGPMy7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 08:54:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Tony Lindgren <tony@atomide.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 2/2] v4l: omap3isp: Drop platform data support
Date: Thu, 16 Jul 2015 15:55:19 +0300
Message-Id: <1437051319-9904-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1437051319-9904-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1437051319-9904-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Platforms using the OMAP3 ISP have all switched to DT, drop platform
data support.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/Kconfig              |   2 +-
 drivers/media/platform/omap3isp/isp.c       | 133 ++++-------------------
 drivers/media/platform/omap3isp/isp.h       |   7 +-
 drivers/media/platform/omap3isp/ispcsiphy.h |   2 +-
 drivers/media/platform/omap3isp/ispvideo.c  |   9 +-
 drivers/media/platform/omap3isp/omap3isp.h  | 132 +++++++++++++++++++++++
 include/media/omap3isp.h                    | 158 ----------------------------
 7 files changed, 158 insertions(+), 285 deletions(-)
 create mode 100644 drivers/media/platform/omap3isp/omap3isp.h
 delete mode 100644 include/media/omap3isp.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index f6bed197130c..ea07c6f793cb 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -86,7 +86,7 @@ config VIDEO_M32R_AR_M64278
 config VIDEO_OMAP3
 	tristate "OMAP 3 Camera support"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
-	depends on HAS_DMA
+	depends on HAS_DMA && OF
 	depends on OMAP_IOMMU
 	select ARM_DMA_USE_IOMMU
 	select VIDEOBUF2_DMA_CONTIG
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 12be830d704f..56e683b19a73 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -101,7 +101,6 @@ static const struct isp_res_mapping isp_res_maps[] = {
 			0x0000, /* csi2a, len 0x0170 */
 			0x0170, /* csiphy2, len 0x000c */
 		},
-		.syscon_offset = 0xdc,
 		.phy_type = ISP_PHY_TYPE_3430,
 	},
 	{
@@ -124,7 +123,6 @@ static const struct isp_res_mapping isp_res_maps[] = {
 			0x0570, /* csiphy1, len 0x000c */
 			0x05c0, /* csi2c, len 0x0040 (2nd area) */
 		},
-		.syscon_offset = 0x2f0,
 		.phy_type = ISP_PHY_TYPE_3630,
 	},
 };
@@ -1796,47 +1794,6 @@ static void isp_unregister_entities(struct isp_device *isp)
 	media_device_unregister(&isp->media_dev);
 }
 
-/*
- * isp_register_subdev - Register a sub-device
- * @isp: OMAP3 ISP device
- * @isp_subdev: platform data related to a sub-device
- *
- * Register an I2C sub-device which has not been registered by other
- * means (such as the Device Tree).
- *
- * Return a pointer to the sub-device if it has been successfully
- * registered, or NULL otherwise.
- */
-static struct v4l2_subdev *
-isp_register_subdev(struct isp_device *isp,
-		    struct isp_platform_subdev *isp_subdev)
-{
-	struct i2c_adapter *adapter;
-	struct v4l2_subdev *sd;
-
-	if (isp_subdev->board_info == NULL)
-		return NULL;
-
-	adapter = i2c_get_adapter(isp_subdev->i2c_adapter_id);
-	if (adapter == NULL) {
-		dev_err(isp->dev,
-			"%s: Unable to get I2C adapter %d for device %s\n",
-			__func__, isp_subdev->i2c_adapter_id,
-			isp_subdev->board_info->type);
-		return NULL;
-	}
-
-	sd = v4l2_i2c_new_subdev_board(&isp->v4l2_dev, adapter,
-				       isp_subdev->board_info, NULL);
-	if (sd == NULL) {
-		dev_err(isp->dev, "%s: Unable to register subdev %s\n",
-			__func__, isp_subdev->board_info->type);
-		return NULL;
-	}
-
-	return sd;
-}
-
 static int isp_link_entity(
 	struct isp_device *isp, struct media_entity *entity,
 	enum isp_interface_type interface)
@@ -1910,8 +1867,6 @@ static int isp_link_entity(
 
 static int isp_register_entities(struct isp_device *isp)
 {
-	struct isp_platform_data *pdata = isp->pdata;
-	struct isp_platform_subdev *isp_subdev;
 	int ret;
 
 	isp->media_dev.dev = isp->dev;
@@ -1968,37 +1923,6 @@ static int isp_register_entities(struct isp_device *isp)
 	if (ret < 0)
 		goto done;
 
-	/*
-	 * Device Tree --- the external sub-devices will be registered
-	 * later. The same goes for the sub-device node registration.
-	 */
-	if (isp->dev->of_node)
-		return 0;
-
-	/* Register external entities */
-	for (isp_subdev = pdata ? pdata->subdevs : NULL;
-	     isp_subdev && isp_subdev->board_info; isp_subdev++) {
-		struct v4l2_subdev *sd;
-
-		sd = isp_register_subdev(isp, isp_subdev);
-
-		/*
-		 * No bus information --- this is either a flash or a
-		 * lens subdev.
-		 */
-		if (!sd || !isp_subdev->bus)
-			continue;
-
-		sd->host_priv = isp_subdev->bus;
-
-		ret = isp_link_entity(isp, &sd->entity,
-				      isp_subdev->bus->interface);
-		if (ret < 0)
-			goto done;
-	}
-
-	ret = v4l2_device_register_subdev_nodes(&isp->v4l2_dev);
-
 done:
 	if (ret < 0)
 		isp_unregister_entities(isp);
@@ -2402,33 +2326,24 @@ static int isp_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node) {
-		ret = of_property_read_u32(pdev->dev.of_node, "ti,phy-type",
-					   &isp->phy_type);
-		if (ret)
-			return ret;
+	ret = of_property_read_u32(pdev->dev.of_node, "ti,phy-type",
+				   &isp->phy_type);
+	if (ret)
+		return ret;
 
-		isp->syscon = syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
-							      "syscon");
-		if (IS_ERR(isp->syscon))
-			return PTR_ERR(isp->syscon);
+	isp->syscon = syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
+						      "syscon");
+	if (IS_ERR(isp->syscon))
+		return PTR_ERR(isp->syscon);
 
-		ret = of_property_read_u32_index(pdev->dev.of_node, "syscon", 1,
-						 &isp->syscon_offset);
-		if (ret)
-			return ret;
+	ret = of_property_read_u32_index(pdev->dev.of_node, "syscon", 1,
+					 &isp->syscon_offset);
+	if (ret)
+		return ret;
 
-		ret = isp_of_parse_nodes(&pdev->dev, &isp->notifier);
-		if (ret < 0)
-			return ret;
-	} else {
-		isp->pdata = pdev->dev.platform_data;
-		isp->syscon = syscon_regmap_lookup_by_pdevname("syscon.0");
-		if (IS_ERR(isp->syscon))
-			return PTR_ERR(isp->syscon);
-		dev_warn(&pdev->dev,
-			 "Platform data support is deprecated! Please move to DT now!\n");
-	}
+	ret = isp_of_parse_nodes(&pdev->dev, &isp->notifier);
+	if (ret < 0)
+		return ret;
 
 	isp->autoidle = autoidle;
 
@@ -2507,11 +2422,6 @@ static int isp_probe(struct platform_device *pdev)
 		goto error_isp;
 	}
 
-	if (!IS_ENABLED(CONFIG_OF) || !pdev->dev.of_node) {
-		isp->syscon_offset = isp_res_maps[m].syscon_offset;
-		isp->phy_type = isp_res_maps[m].phy_type;
-	}
-
 	for (i = 1; i < OMAP3_ISP_IOMEM_CSI2A_REGS1; i++)
 		isp->mmio_base[i] =
 			isp->mmio_base[0] + isp_res_maps[m].offset[i];
@@ -2555,15 +2465,12 @@ static int isp_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error_modules;
 
-	if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node) {
-		isp->notifier.bound = isp_subdev_notifier_bound;
-		isp->notifier.complete = isp_subdev_notifier_complete;
+	isp->notifier.bound = isp_subdev_notifier_bound;
+	isp->notifier.complete = isp_subdev_notifier_complete;
 
-		ret = v4l2_async_notifier_register(&isp->v4l2_dev,
-						   &isp->notifier);
-		if (ret)
-			goto error_register_entities;
-	}
+	ret = v4l2_async_notifier_register(&isp->v4l2_dev, &isp->notifier);
+	if (ret)
+		goto error_register_entities;
 
 	isp_core_init(isp, 1);
 	omap3isp_put(isp);
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index e579943175c4..5acc2e6511a5 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -17,7 +17,6 @@
 #ifndef OMAP3_ISP_CORE_H
 #define OMAP3_ISP_CORE_H
 
-#include <media/omap3isp.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
 #include <linux/clk-provider.h>
@@ -27,6 +26,7 @@
 #include <linux/platform_device.h>
 #include <linux/wait.h>
 
+#include "omap3isp.h"
 #include "ispstat.h"
 #include "ispccdc.h"
 #include "ispreg.h"
@@ -101,15 +101,11 @@ struct regmap;
  * struct isp_res_mapping - Map ISP io resources to ISP revision.
  * @isp_rev: ISP_REVISION_x_x
  * @offset: register offsets of various ISP sub-blocks
- * @syscon_offset: offset of the syscon register for 343x / 3630
- *	    (CONTROL_CSIRXFE / CONTROL_CAMERA_PHY_CTRL, respectively)
- *	    from the syscon base address
  * @phy_type: ISP_PHY_TYPE_{3430,3630}
  */
 struct isp_res_mapping {
 	u32 isp_rev;
 	u32 offset[OMAP3_ISP_IOMEM_LAST];
-	u32 syscon_offset;
 	u32 phy_type;
 };
 
@@ -184,7 +180,6 @@ struct isp_device {
 	u32 revision;
 
 	/* platform HW resources */
-	struct isp_platform_data *pdata;
 	unsigned int irq_num;
 
 	void __iomem *mmio_base[OMAP3_ISP_IOMEM_LAST];
diff --git a/drivers/media/platform/omap3isp/ispcsiphy.h b/drivers/media/platform/omap3isp/ispcsiphy.h
index e17c88beab92..28b63b28f9f7 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.h
+++ b/drivers/media/platform/omap3isp/ispcsiphy.h
@@ -17,7 +17,7 @@
 #ifndef OMAP3_ISP_CSI_PHY_H
 #define OMAP3_ISP_CSI_PHY_H
 
-#include <media/omap3isp.h>
+#include "omap3isp.h"
 
 struct isp_csi2_device;
 struct regulator;
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index d285af18df7f..41bb8df91f72 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -1018,8 +1018,7 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 
 	pipe->entities = 0;
 
-	if (video->isp->pdata && video->isp->pdata->set_constraints)
-		video->isp->pdata->set_constraints(video->isp, true);
+	/* TODO: Implement PM QoS */
 	pipe->l3_ick = clk_get_rate(video->isp->clock[ISP_CLK_L3_ICK]);
 	pipe->max_rate = pipe->l3_ick;
 
@@ -1100,8 +1099,7 @@ err_set_stream:
 err_check_format:
 	media_entity_pipeline_stop(&video->video.entity);
 err_pipeline_start:
-	if (video->isp->pdata && video->isp->pdata->set_constraints)
-		video->isp->pdata->set_constraints(video->isp, false);
+	/* TODO: Implement PM QoS */
 	/* The DMA queue must be emptied here, otherwise CCDC interrupts that
 	 * will get triggered the next time the CCDC is powered up will try to
 	 * access buffers that might have been freed but still present in the
@@ -1161,8 +1159,7 @@ isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 	video->queue = NULL;
 	video->error = false;
 
-	if (video->isp->pdata && video->isp->pdata->set_constraints)
-		video->isp->pdata->set_constraints(video->isp, false);
+	/* TODO: Implement PM QoS */
 	media_entity_pipeline_stop(&video->video.entity);
 
 done:
diff --git a/drivers/media/platform/omap3isp/omap3isp.h b/drivers/media/platform/omap3isp/omap3isp.h
new file mode 100644
index 000000000000..190e259a6a2d
--- /dev/null
+++ b/drivers/media/platform/omap3isp/omap3isp.h
@@ -0,0 +1,132 @@
+/*
+ * omap3isp.h
+ *
+ * TI OMAP3 ISP - Bus Configuration
+ *
+ * Copyright (C) 2011 Nokia Corporation
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __OMAP3ISP_H__
+#define __OMAP3ISP_H__
+
+enum isp_interface_type {
+	ISP_INTERFACE_PARALLEL,
+	ISP_INTERFACE_CSI2A_PHY2,
+	ISP_INTERFACE_CCP2B_PHY1,
+	ISP_INTERFACE_CCP2B_PHY2,
+	ISP_INTERFACE_CSI2C_PHY1,
+};
+
+/**
+ * struct isp_parallel_cfg - Parallel interface configuration
+ * @data_lane_shift: Data lane shifter
+ *		0 - CAMEXT[13:0] -> CAM[13:0]
+ *		1 - CAMEXT[13:2] -> CAM[11:0]
+ *		2 - CAMEXT[13:4] -> CAM[9:0]
+ *		3 - CAMEXT[13:6] -> CAM[7:0]
+ * @clk_pol: Pixel clock polarity
+ *		0 - Sample on rising edge, 1 - Sample on falling edge
+ * @hs_pol: Horizontal synchronization polarity
+ *		0 - Active high, 1 - Active low
+ * @vs_pol: Vertical synchronization polarity
+ *		0 - Active high, 1 - Active low
+ * @fld_pol: Field signal polarity
+ *		0 - Positive, 1 - Negative
+ * @data_pol: Data polarity
+ *		0 - Normal, 1 - One's complement
+ */
+struct isp_parallel_cfg {
+	unsigned int data_lane_shift:2;
+	unsigned int clk_pol:1;
+	unsigned int hs_pol:1;
+	unsigned int vs_pol:1;
+	unsigned int fld_pol:1;
+	unsigned int data_pol:1;
+};
+
+enum {
+	ISP_CCP2_PHY_DATA_CLOCK = 0,
+	ISP_CCP2_PHY_DATA_STROBE = 1,
+};
+
+enum {
+	ISP_CCP2_MODE_MIPI = 0,
+	ISP_CCP2_MODE_CCP2 = 1,
+};
+
+/**
+ * struct isp_csiphy_lane: CCP2/CSI2 lane position and polarity
+ * @pos: position of the lane
+ * @pol: polarity of the lane
+ */
+struct isp_csiphy_lane {
+	u8 pos;
+	u8 pol;
+};
+
+#define ISP_CSIPHY1_NUM_DATA_LANES	1
+#define ISP_CSIPHY2_NUM_DATA_LANES	2
+
+/**
+ * struct isp_csiphy_lanes_cfg - CCP2/CSI2 lane configuration
+ * @data: Configuration of one or two data lanes
+ * @clk: Clock lane configuration
+ */
+struct isp_csiphy_lanes_cfg {
+	struct isp_csiphy_lane data[ISP_CSIPHY2_NUM_DATA_LANES];
+	struct isp_csiphy_lane clk;
+};
+
+/**
+ * struct isp_ccp2_cfg - CCP2 interface configuration
+ * @strobe_clk_pol: Strobe/clock polarity
+ *		0 - Non Inverted, 1 - Inverted
+ * @crc: Enable the cyclic redundancy check
+ * @ccp2_mode: Enable CCP2 compatibility mode
+ *		ISP_CCP2_MODE_MIPI - MIPI-CSI1 mode
+ *		ISP_CCP2_MODE_CCP2 - CCP2 mode
+ * @phy_layer: Physical layer selection
+ *		ISP_CCP2_PHY_DATA_CLOCK - Data/clock physical layer
+ *		ISP_CCP2_PHY_DATA_STROBE - Data/strobe physical layer
+ * @vpclk_div: Video port output clock control
+ */
+struct isp_ccp2_cfg {
+	unsigned int strobe_clk_pol:1;
+	unsigned int crc:1;
+	unsigned int ccp2_mode:1;
+	unsigned int phy_layer:1;
+	unsigned int vpclk_div:2;
+	struct isp_csiphy_lanes_cfg lanecfg;
+};
+
+/**
+ * struct isp_csi2_cfg - CSI2 interface configuration
+ * @crc: Enable the cyclic redundancy check
+ */
+struct isp_csi2_cfg {
+	unsigned crc:1;
+	struct isp_csiphy_lanes_cfg lanecfg;
+};
+
+struct isp_bus_cfg {
+	enum isp_interface_type interface;
+	union {
+		struct isp_parallel_cfg parallel;
+		struct isp_ccp2_cfg ccp2;
+		struct isp_csi2_cfg csi2;
+	} bus; /* gcc < 4.6.0 chokes on anonymous union initializers */
+};
+
+#endif	/* __OMAP3ISP_H__ */
diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
deleted file mode 100644
index 048f8f9117ef..000000000000
--- a/include/media/omap3isp.h
+++ /dev/null
@@ -1,158 +0,0 @@
-/*
- * omap3isp.h
- *
- * TI OMAP3 ISP - Platform data
- *
- * Copyright (C) 2011 Nokia Corporation
- *
- * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
- *	     Sakari Ailus <sakari.ailus@iki.fi>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- */
-
-#ifndef __MEDIA_OMAP3ISP_H__
-#define __MEDIA_OMAP3ISP_H__
-
-struct i2c_board_info;
-struct isp_device;
-
-enum isp_interface_type {
-	ISP_INTERFACE_PARALLEL,
-	ISP_INTERFACE_CSI2A_PHY2,
-	ISP_INTERFACE_CCP2B_PHY1,
-	ISP_INTERFACE_CCP2B_PHY2,
-	ISP_INTERFACE_CSI2C_PHY1,
-};
-
-enum {
-	ISP_LANE_SHIFT_0 = 0,
-	ISP_LANE_SHIFT_2 = 1,
-	ISP_LANE_SHIFT_4 = 2,
-	ISP_LANE_SHIFT_6 = 3,
-};
-
-/**
- * struct isp_parallel_cfg - Parallel interface configuration
- * @data_lane_shift: Data lane shifter
- *		ISP_LANE_SHIFT_0 - CAMEXT[13:0] -> CAM[13:0]
- *		ISP_LANE_SHIFT_2 - CAMEXT[13:2] -> CAM[11:0]
- *		ISP_LANE_SHIFT_4 - CAMEXT[13:4] -> CAM[9:0]
- *		ISP_LANE_SHIFT_6 - CAMEXT[13:6] -> CAM[7:0]
- * @clk_pol: Pixel clock polarity
- *		0 - Sample on rising edge, 1 - Sample on falling edge
- * @hs_pol: Horizontal synchronization polarity
- *		0 - Active high, 1 - Active low
- * @vs_pol: Vertical synchronization polarity
- *		0 - Active high, 1 - Active low
- * @fld_pol: Field signal polarity
- *		0 - Positive, 1 - Negative
- * @data_pol: Data polarity
- *		0 - Normal, 1 - One's complement
- */
-struct isp_parallel_cfg {
-	unsigned int data_lane_shift:2;
-	unsigned int clk_pol:1;
-	unsigned int hs_pol:1;
-	unsigned int vs_pol:1;
-	unsigned int fld_pol:1;
-	unsigned int data_pol:1;
-};
-
-enum {
-	ISP_CCP2_PHY_DATA_CLOCK = 0,
-	ISP_CCP2_PHY_DATA_STROBE = 1,
-};
-
-enum {
-	ISP_CCP2_MODE_MIPI = 0,
-	ISP_CCP2_MODE_CCP2 = 1,
-};
-
-/**
- * struct isp_csiphy_lane: CCP2/CSI2 lane position and polarity
- * @pos: position of the lane
- * @pol: polarity of the lane
- */
-struct isp_csiphy_lane {
-	u8 pos;
-	u8 pol;
-};
-
-#define ISP_CSIPHY1_NUM_DATA_LANES	1
-#define ISP_CSIPHY2_NUM_DATA_LANES	2
-
-/**
- * struct isp_csiphy_lanes_cfg - CCP2/CSI2 lane configuration
- * @data: Configuration of one or two data lanes
- * @clk: Clock lane configuration
- */
-struct isp_csiphy_lanes_cfg {
-	struct isp_csiphy_lane data[ISP_CSIPHY2_NUM_DATA_LANES];
-	struct isp_csiphy_lane clk;
-};
-
-/**
- * struct isp_ccp2_cfg - CCP2 interface configuration
- * @strobe_clk_pol: Strobe/clock polarity
- *		0 - Non Inverted, 1 - Inverted
- * @crc: Enable the cyclic redundancy check
- * @ccp2_mode: Enable CCP2 compatibility mode
- *		ISP_CCP2_MODE_MIPI - MIPI-CSI1 mode
- *		ISP_CCP2_MODE_CCP2 - CCP2 mode
- * @phy_layer: Physical layer selection
- *		ISP_CCP2_PHY_DATA_CLOCK - Data/clock physical layer
- *		ISP_CCP2_PHY_DATA_STROBE - Data/strobe physical layer
- * @vpclk_div: Video port output clock control
- */
-struct isp_ccp2_cfg {
-	unsigned int strobe_clk_pol:1;
-	unsigned int crc:1;
-	unsigned int ccp2_mode:1;
-	unsigned int phy_layer:1;
-	unsigned int vpclk_div:2;
-	struct isp_csiphy_lanes_cfg lanecfg;
-};
-
-/**
- * struct isp_csi2_cfg - CSI2 interface configuration
- * @crc: Enable the cyclic redundancy check
- */
-struct isp_csi2_cfg {
-	unsigned crc:1;
-	struct isp_csiphy_lanes_cfg lanecfg;
-};
-
-struct isp_bus_cfg {
-	enum isp_interface_type interface;
-	union {
-		struct isp_parallel_cfg parallel;
-		struct isp_ccp2_cfg ccp2;
-		struct isp_csi2_cfg csi2;
-	} bus; /* gcc < 4.6.0 chokes on anonymous union initializers */
-};
-
-struct isp_platform_subdev {
-	struct i2c_board_info *board_info;
-	int i2c_adapter_id;
-	struct isp_bus_cfg *bus;
-};
-
-struct isp_platform_data {
-	struct isp_platform_subdev *subdevs;
-	void (*set_constraints)(struct isp_device *isp, bool enable);
-};
-
-#endif	/* __MEDIA_OMAP3ISP_H__ */
-- 
2.3.6

