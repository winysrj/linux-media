Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:59283 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872Ab3CHOnA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 09:43:00 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org
Cc: s.nawrocki@samsung.com, kgene.kim@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: [RFC 09/12] exynos-fimc-is: Adds the hardware pipeline control
Date: Fri, 08 Mar 2013 09:59:22 -0500
Message-id: <1362754765-2651-10-git-send-email-arun.kk@samsung.com>
In-reply-to: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the crucial hardware pipeline control for the
fimc-is driver. All the subdev nodes will call this pipeline
interfaces to reach the hardware. Responsibilities of this module
involves configuring and maintaining the hardware pipeline involving
multiple sub-ips like ISP, DRC, Scalers, ODC, 3DNR, FD etc.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
---
 .../media/platform/exynos5-is/fimc-is-pipeline.c   | 1961 ++++++++++++++++++++
 .../media/platform/exynos5-is/fimc-is-pipeline.h   |  129 ++
 2 files changed, 2090 insertions(+)
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-pipeline.c
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-pipeline.h

diff --git a/drivers/media/platform/exynos5-is/fimc-is-pipeline.c b/drivers/media/platform/exynos5-is/fimc-is-pipeline.c
new file mode 100644
index 0000000..66f0c50
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is-pipeline.c
@@ -0,0 +1,1961 @@
+/*
+ * Samsung EXYNOS5 FIMC-IS (Imaging Subsystem) driver
+*
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Arun Kumar K <arun.kk@samsung.com>
+ * Kil-yeon Lim <kilyeon.im@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "fimc-is.h"
+#include "fimc-is-pipeline.h"
+#include "fimc-is-metadata.h"
+#include "fimc-is-regs.h"
+#include "fimc-is-cmd.h"
+#include <media/videobuf2-dma-contig.h>
+#include <linux/delay.h>
+
+/* Default setting values */
+#define DEFAULT_PREVIEW_STILL_WIDTH		(1280) /* sensor margin : 16 */
+#define DEFAULT_PREVIEW_STILL_HEIGHT		(720) /* sensor margin : 12 */
+#define DEFAULT_CAPTURE_VIDEO_WIDTH		(1920)
+#define DEFAULT_CAPTURE_VIDEO_HEIGHT		(1080)
+#define DEFAULT_CAPTURE_STILL_WIDTH		(2560)
+#define DEFAULT_CAPTURE_STILL_HEIGHT		(1920)
+#define DEFAULT_CAPTURE_STILL_CROP_WIDTH	(2560)
+#define DEFAULT_CAPTURE_STILL_CROP_HEIGHT	(1440)
+#define DEFAULT_PREVIEW_VIDEO_WIDTH		(640)
+#define DEFAULT_PREVIEW_VIDEO_HEIGHT		(480)
+
+static void *fw_cookie;
+static void *shot_cookie;
+
+/* Init params for pipeline devices */
+static const struct sensor_param init_sensor_param = {
+	.frame_rate = {
+		.frame_rate = 30,
+	},
+};
+
+static const struct isp_param init_isp_param = {
+	.control = {
+		.cmd = CONTROL_COMMAND_START,
+		.bypass = CONTROL_BYPASS_DISABLE,
+		.err = CONTROL_ERROR_NO,
+	},
+	.otf_input = {
+		.cmd = OTF_INPUT_COMMAND_DISABLE,
+		.width = DEFAULT_CAPTURE_STILL_WIDTH,
+		.height = DEFAULT_CAPTURE_STILL_HEIGHT,
+		.format = OTF_INPUT_FORMAT_BAYER,
+		.bitwidth = OTF_INPUT_BIT_WIDTH_10BIT,
+		.order = OTF_INPUT_ORDER_BAYER_GR_BG,
+		.crop_offset_x = 0,
+		.crop_offset_y = 0,
+		.crop_width = 0,
+		.crop_height = 0,
+		.frametime_min = 0,
+		.frametime_max = 33333,
+		.err = OTF_INPUT_ERROR_NO,
+	},
+	.dma1_input = {
+		.cmd = DMA_INPUT_COMMAND_DISABLE,
+		.width = 0,
+		.height = 0,
+		.format = 0,
+		.bitwidth = 0,
+		.plane = 0,
+		.order = 0,
+		.buffer_number = 0,
+		.buffer_address = 0,
+		.err = 0,
+	},
+	.dma2_input = {
+		.cmd = DMA_INPUT_COMMAND_DISABLE,
+		.width = 0, .height = 0,
+		.format = 0, .bitwidth = 0, .plane = 0,
+		.order = 0, .buffer_number = 0, .buffer_address = 0,
+		.err = 0,
+	},
+	.aa = {
+		.cmd = ISP_AA_COMMAND_START,
+		.target = ISP_AA_TARGET_AF | ISP_AA_TARGET_AE |
+						ISP_AA_TARGET_AWB,
+		.mode = ISP_AF_CONTINUOUS,
+		.scene = 0,
+		.sleep = 0,
+		.uiafface = 0,
+		.touch_x = 0, .touch_y = 0,
+		.manual_af_setting = 0,
+		.err = ISP_AF_ERROR_NO,
+	},
+	.flash = {
+		.cmd = ISP_FLASH_COMMAND_DISABLE,
+		.redeye = ISP_FLASH_REDEYE_DISABLE,
+		.err = ISP_FLASH_ERROR_NO,
+	},
+	.awb = {
+		.cmd = ISP_AWB_COMMAND_AUTO,
+		.illumination = 0,
+		.err = ISP_AWB_ERROR_NO,
+	},
+	.effect = {
+		.cmd = ISP_IMAGE_EFFECT_DISABLE,
+		.err = ISP_IMAGE_EFFECT_ERROR_NO,
+	},
+	.iso = {
+		.cmd = ISP_ISO_COMMAND_AUTO,
+		.value = 0,
+		.err = ISP_ISO_ERROR_NO,
+	},
+	.adjust = {
+		.cmd = ISP_ADJUST_COMMAND_AUTO,
+		.contrast = 0,
+		.saturation = 0,
+		.sharpness = 0,
+		.exposure = 0,
+		.brightness = 0,
+		.hue = 0,
+		.err = ISP_ADJUST_ERROR_NO,
+	},
+	.metering = {
+		.cmd = ISP_METERING_COMMAND_CENTER,
+		.win_pos_x = 0, .win_pos_y = 0,
+		.win_width = DEFAULT_CAPTURE_STILL_WIDTH,
+		.win_height = DEFAULT_CAPTURE_STILL_HEIGHT,
+		.err = ISP_METERING_ERROR_NO,
+	},
+	.afc = {
+		.cmd = ISP_AFC_COMMAND_AUTO,
+		.manual = 0, .err = ISP_AFC_ERROR_NO,
+	},
+	.otf_output = {
+		.cmd = OTF_OUTPUT_COMMAND_ENABLE,
+		.width = DEFAULT_CAPTURE_STILL_WIDTH,
+		.height = DEFAULT_CAPTURE_STILL_HEIGHT,
+		.format = OTF_OUTPUT_FORMAT_YUV444,
+		.bitwidth = OTF_OUTPUT_BIT_WIDTH_12BIT,
+		.order = OTF_OUTPUT_ORDER_BAYER_GR_BG,
+		.uicropoffsetx = 0,
+		.uicropoffsety = 0,
+		.err = OTF_OUTPUT_ERROR_NO,
+	},
+	.dma1_output = {
+		.cmd = DMA_OUTPUT_COMMAND_DISABLE,
+		.dma_out_mask = 0,
+		.width = DEFAULT_CAPTURE_STILL_WIDTH,
+		.height = DEFAULT_CAPTURE_STILL_HEIGHT,
+		.format = DMA_INPUT_FORMAT_YUV444,
+		.bitwidth = DMA_INPUT_BIT_WIDTH_8BIT,
+		.plane = DMA_INPUT_PLANE_1,
+		.order = DMA_INPUT_ORDER_YCBCR,
+		.buffer_number = 0,
+		.buffer_address = 0,
+		.err = DMA_OUTPUT_ERROR_NO,
+	},
+	.dma2_output = {
+		.cmd = DMA_OUTPUT_COMMAND_DISABLE,
+		.width = DEFAULT_CAPTURE_STILL_WIDTH,
+		.height = DEFAULT_CAPTURE_STILL_HEIGHT,
+		.format = DMA_OUTPUT_FORMAT_BAYER,
+		.bitwidth = DMA_OUTPUT_BIT_WIDTH_12BIT,
+		.plane = DMA_OUTPUT_PLANE_1,
+		.order = DMA_OUTPUT_ORDER_GB_BG,
+		.buffer_number = 0,
+		.buffer_address = 0,
+		.dma_out_mask = 0xFFFFFFFF,
+		.err = DMA_OUTPUT_ERROR_NO,
+	},
+};
+
+static const struct drc_param init_drc_param = {
+	.control = {
+		.cmd = CONTROL_COMMAND_START,
+		.bypass = CONTROL_BYPASS_ENABLE,
+		.err = CONTROL_ERROR_NO,
+	},
+	.otf_input = {
+		.cmd = OTF_INPUT_COMMAND_ENABLE,
+		.width = DEFAULT_CAPTURE_STILL_WIDTH,
+		.height = DEFAULT_CAPTURE_STILL_HEIGHT,
+		.format = OTF_INPUT_FORMAT_YUV444,
+		.bitwidth = OTF_INPUT_BIT_WIDTH_12BIT,
+		.order = OTF_INPUT_ORDER_BAYER_GR_BG,
+		.err = OTF_INPUT_ERROR_NO,
+	},
+	.dma_input = {
+		.cmd = DMA_INPUT_COMMAND_DISABLE,
+		.width = DEFAULT_CAPTURE_STILL_WIDTH,
+		.height = DEFAULT_CAPTURE_STILL_HEIGHT,
+		.format = DMA_INPUT_FORMAT_YUV444,
+		.bitwidth = DMA_INPUT_BIT_WIDTH_8BIT,
+		.plane = DMA_INPUT_PLANE_1,
+		.order = DMA_INPUT_ORDER_YCBCR,
+		.buffer_number = 0,
+		.buffer_address = 0,
+		.err = 0,
+	},
+	.otf_output = {
+		.cmd = OTF_OUTPUT_COMMAND_ENABLE,
+		.width = DEFAULT_CAPTURE_STILL_WIDTH,
+		.height = DEFAULT_CAPTURE_STILL_HEIGHT,
+		.format = OTF_OUTPUT_FORMAT_YUV444,
+		.bitwidth = OTF_INPUT_BIT_WIDTH_8BIT,
+		.order = OTF_OUTPUT_ORDER_BAYER_GR_BG,
+		.uicropoffsetx = 0,
+		.uicropoffsety = 0,
+		.err = OTF_OUTPUT_ERROR_NO,
+	},
+};
+
+static const struct scalerc_param init_scalerc_param = {
+	.control = {
+		.cmd = CONTROL_COMMAND_START,
+		.bypass = CONTROL_BYPASS_ENABLE,
+		.err = CONTROL_ERROR_NO,
+	},
+	.otf_input = {
+		.cmd = OTF_INPUT_COMMAND_ENABLE,
+		.width = DEFAULT_CAPTURE_STILL_WIDTH,
+		.height = DEFAULT_CAPTURE_STILL_HEIGHT,
+		.format = OTF_INPUT_FORMAT_YUV444,
+		.bitwidth = OTF_INPUT_BIT_WIDTH_12BIT,
+		.order = OTF_INPUT_ORDER_BAYER_GR_BG,
+		.crop_offset_x = 0,
+		.crop_offset_y = 0,
+		.crop_width = 0,
+		.crop_height = 0,
+		.err = OTF_INPUT_ERROR_NO,
+	},
+	.effect = {
+		.cmd = 0,
+		.err = 0,
+	},
+	.input_crop = {
+		.cmd = OTF_INPUT_COMMAND_ENABLE,
+		.pos_x = 0,
+		.pos_y = 0,
+		.crop_width = DEFAULT_CAPTURE_STILL_CROP_WIDTH,
+		.crop_height = DEFAULT_CAPTURE_STILL_CROP_HEIGHT,
+		.in_width = DEFAULT_CAPTURE_STILL_WIDTH,
+		.in_height = DEFAULT_CAPTURE_STILL_HEIGHT,
+		.out_width = DEFAULT_CAPTURE_VIDEO_WIDTH,
+		.out_height = DEFAULT_CAPTURE_VIDEO_HEIGHT,
+		.err = 0,
+	},
+	.output_crop = {
+		.cmd = SCALER_CROP_COMMAND_DISABLE,
+		.pos_x = 0,
+		.pos_y = 0,
+		.crop_width = DEFAULT_CAPTURE_STILL_WIDTH,
+		.crop_height = DEFAULT_CAPTURE_STILL_HEIGHT,
+		.format = DMA_OUTPUT_FORMAT_YUV420,
+		.err = 0,
+	},
+	.otf_output = {
+		.cmd = OTF_OUTPUT_COMMAND_ENABLE,
+		.width = DEFAULT_CAPTURE_VIDEO_WIDTH,
+		.height = DEFAULT_CAPTURE_VIDEO_HEIGHT,
+		.format = OTF_OUTPUT_FORMAT_YUV444,
+		.bitwidth = OTF_OUTPUT_BIT_WIDTH_8BIT,
+		.order = OTF_OUTPUT_ORDER_BAYER_GR_BG,
+		.uicropoffsetx = 0,
+		.uicropoffsety = 0,
+		.err = OTF_OUTPUT_ERROR_NO,
+	},
+	.dma_output = {
+		.cmd = DMA_OUTPUT_COMMAND_DISABLE,
+		.width = DEFAULT_CAPTURE_STILL_WIDTH,
+		.height = DEFAULT_CAPTURE_STILL_HEIGHT,
+		.format = DMA_OUTPUT_FORMAT_YUV420,
+		.bitwidth = DMA_OUTPUT_BIT_WIDTH_8BIT,
+		.plane = DMA_OUTPUT_PLANE_3,
+		.order = DMA_OUTPUT_ORDER_NO,
+		.buffer_number = 0,
+		.buffer_address = 0,
+		.dma_out_mask = 0xffff,
+		.err = DMA_OUTPUT_ERROR_NO,
+	},
+};
+
+static const struct odc_param init_odc_param = {
+	.control = {
+		.cmd = CONTROL_COMMAND_START,
+		.bypass = CONTROL_BYPASS_ENABLE,
+		.err = CONTROL_ERROR_NO,
+	},
+	.otf_input = {
+		.cmd = OTF_INPUT_COMMAND_ENABLE,
+		.width = DEFAULT_CAPTURE_VIDEO_WIDTH,
+		.height = DEFAULT_CAPTURE_VIDEO_HEIGHT,
+		.format = OTF_INPUT_FORMAT_YUV444,
+		.bitwidth = OTF_INPUT_BIT_WIDTH_8BIT,
+		.order = OTF_INPUT_ORDER_BAYER_GR_BG,
+		.crop_offset_x = 0,
+		.crop_offset_y = 0,
+		.crop_width = 0,
+		.crop_height = 0,
+		.err = OTF_INPUT_ERROR_NO,
+	},
+	.otf_output = {
+		.cmd = OTF_OUTPUT_COMMAND_ENABLE,
+		.width = DEFAULT_CAPTURE_VIDEO_WIDTH,
+		.height = DEFAULT_CAPTURE_VIDEO_HEIGHT,
+		.format = OTF_OUTPUT_FORMAT_YUV422,
+		.bitwidth = OTF_OUTPUT_BIT_WIDTH_8BIT,
+		.order = OTF_OUTPUT_ORDER_BAYER_GR_BG,
+		.uicropoffsetx = 0,
+		.uicropoffsety = 0,
+		.err = OTF_OUTPUT_ERROR_NO,
+	},
+};
+
+static const struct dis_param init_dis_param = {
+	.control = {
+		.cmd = CONTROL_COMMAND_START,
+		.bypass = CONTROL_BYPASS_ENABLE,
+		.err = CONTROL_ERROR_NO,
+	},
+	.otf_input = {
+		.cmd = OTF_INPUT_COMMAND_ENABLE,
+		.width = DEFAULT_CAPTURE_VIDEO_WIDTH,
+		.height = DEFAULT_CAPTURE_VIDEO_HEIGHT,
+		.format = OTF_INPUT_FORMAT_YUV422,
+		.bitwidth = OTF_INPUT_BIT_WIDTH_8BIT,
+		.order = OTF_INPUT_ORDER_BAYER_GR_BG,
+		.crop_offset_x = 0,
+		.crop_offset_y = 0,
+		.crop_width = 0,
+		.crop_height = 0,
+		.err = OTF_INPUT_ERROR_NO,
+	},
+	.otf_output = {
+		.cmd = OTF_OUTPUT_COMMAND_ENABLE,
+		.width = DEFAULT_CAPTURE_VIDEO_WIDTH,
+		.height = DEFAULT_CAPTURE_VIDEO_HEIGHT,
+		.format = OTF_OUTPUT_FORMAT_YUV422,
+		.bitwidth = OTF_OUTPUT_BIT_WIDTH_8BIT,
+		.order = OTF_OUTPUT_ORDER_BAYER_GR_BG,
+		.uicropoffsetx = 0,
+		.uicropoffsety = 0,
+		.err = OTF_OUTPUT_ERROR_NO,
+	},
+};
+static const struct tdnr_param init_tdnr_param = {
+	.control = {
+		.cmd = CONTROL_COMMAND_START,
+		.bypass = CONTROL_BYPASS_ENABLE,
+		.err = CONTROL_ERROR_NO,
+	},
+	.otf_input = {
+		.cmd = OTF_INPUT_COMMAND_ENABLE,
+		.width = DEFAULT_CAPTURE_VIDEO_WIDTH,
+		.height = DEFAULT_CAPTURE_VIDEO_HEIGHT,
+		.format = OTF_INPUT_FORMAT_YUV422,
+		.bitwidth = OTF_INPUT_BIT_WIDTH_8BIT,
+		.order = OTF_INPUT_ORDER_BAYER_GR_BG,
+		.err = OTF_INPUT_ERROR_NO,
+	},
+	.frame = {
+		.cmd = 0,
+		.err = 0,
+	},
+	.otf_output = {
+		.cmd = OTF_OUTPUT_COMMAND_ENABLE,
+		.width = DEFAULT_CAPTURE_VIDEO_WIDTH,
+		.height = DEFAULT_CAPTURE_VIDEO_HEIGHT,
+		.format = OTF_OUTPUT_FORMAT_YUV444,
+		.bitwidth = OTF_INPUT_BIT_WIDTH_8BIT,
+		.order = OTF_OUTPUT_ORDER_BAYER_GR_BG,
+		.uicropoffsetx = 0,
+		.uicropoffsety = 0,
+		.err = OTF_OUTPUT_ERROR_NO,
+	},
+	.dma_output = {
+		.cmd = DMA_OUTPUT_COMMAND_DISABLE,
+		.width = DEFAULT_CAPTURE_VIDEO_WIDTH,
+		.height = DEFAULT_CAPTURE_VIDEO_HEIGHT,
+		.format = DMA_OUTPUT_FORMAT_YUV420,
+		.bitwidth = DMA_OUTPUT_BIT_WIDTH_8BIT,
+		.plane = DMA_OUTPUT_PLANE_2,
+		.order = DMA_OUTPUT_ORDER_CBCR,
+		.buffer_number = 0,
+		.buffer_address = 0,
+		.dma_out_mask = 0xffff,
+		.err = DMA_OUTPUT_ERROR_NO,
+	},
+};
+
+static const struct scalerp_param init_scalerp_param = {
+	.control = {
+		.cmd = CONTROL_COMMAND_START,
+		.bypass = CONTROL_BYPASS_ENABLE,
+		.err = CONTROL_ERROR_NO,
+	},
+	.otf_input = {
+		.cmd = OTF_INPUT_COMMAND_ENABLE,
+		.width = DEFAULT_CAPTURE_VIDEO_WIDTH,
+		.height = DEFAULT_CAPTURE_VIDEO_HEIGHT,
+		.format = OTF_INPUT_FORMAT_YUV444,
+		.bitwidth = OTF_INPUT_BIT_WIDTH_8BIT,
+		.order = OTF_INPUT_ORDER_BAYER_GR_BG,
+		.crop_offset_x = 0,
+		.crop_offset_y = 0,
+		.crop_width = 0,
+		.crop_height = 0,
+		.err = OTF_INPUT_ERROR_NO,
+	},
+	.effect = {
+		.cmd = 0,
+		.err = 0,
+	},
+	.input_crop = {
+		.cmd = OTF_INPUT_COMMAND_ENABLE,
+		.pos_x = 0,
+		.pos_y = 0,
+		.crop_width = DEFAULT_CAPTURE_VIDEO_WIDTH,
+		.crop_height = DEFAULT_CAPTURE_VIDEO_HEIGHT,
+		.in_width = DEFAULT_CAPTURE_VIDEO_WIDTH,
+		.in_height = DEFAULT_CAPTURE_VIDEO_HEIGHT,
+		.out_width = DEFAULT_PREVIEW_STILL_WIDTH,
+		.out_height = DEFAULT_PREVIEW_STILL_HEIGHT,
+		.err = 0,
+	},
+	.output_crop = {
+		.cmd = SCALER_CROP_COMMAND_DISABLE,
+		.pos_x = 0,
+		.pos_y = 0,
+		.crop_width = DEFAULT_PREVIEW_STILL_WIDTH,
+		.crop_height = DEFAULT_PREVIEW_STILL_HEIGHT,
+		.format = OTF_OUTPUT_FORMAT_YUV420,
+		.err = 0,
+	},
+	.rotation = {
+		.cmd = 0,
+		.err = 0,
+	},
+	.flip = {
+		.cmd = 0,
+		.err = 0,
+	},
+	.otf_output = {
+		.cmd = OTF_OUTPUT_COMMAND_ENABLE,
+		.width = DEFAULT_PREVIEW_STILL_WIDTH,
+		.height = DEFAULT_PREVIEW_STILL_HEIGHT,
+		.format = OTF_INPUT_FORMAT_YUV444,
+		.bitwidth = OTF_INPUT_BIT_WIDTH_8BIT,
+		.order = OTF_OUTPUT_ORDER_BAYER_GR_BG,
+		.uicropoffsetx = 0,
+		.uicropoffsety = 0,
+		.err = OTF_OUTPUT_ERROR_NO,
+	},
+	.dma_output = {
+		.cmd = DMA_OUTPUT_COMMAND_DISABLE,
+		.width = DEFAULT_PREVIEW_STILL_WIDTH,
+		.height = DEFAULT_PREVIEW_STILL_HEIGHT,
+		.format = OTF_OUTPUT_FORMAT_YUV420,
+		.bitwidth = DMA_OUTPUT_BIT_WIDTH_8BIT,
+		.plane = DMA_OUTPUT_PLANE_3,
+		.order = DMA_OUTPUT_ORDER_NO,
+		.buffer_number = 0,
+		.buffer_address = 0,
+		.dma_out_mask = 0xffff,
+		.err = DMA_OUTPUT_ERROR_NO,
+	},
+};
+
+static const struct fd_param init_fd_param = {
+	.control = {
+		.cmd = CONTROL_COMMAND_STOP,
+		.bypass = CONTROL_BYPASS_DISABLE,
+		.err = CONTROL_ERROR_NO,
+	},
+	.otf_input = {
+		.cmd = OTF_INPUT_COMMAND_ENABLE,
+		.width = DEFAULT_PREVIEW_STILL_WIDTH,
+		.height = DEFAULT_PREVIEW_STILL_HEIGHT,
+		.format = OTF_INPUT_FORMAT_YUV444,
+		.bitwidth = OTF_INPUT_BIT_WIDTH_8BIT,
+		.order = OTF_INPUT_ORDER_BAYER_GR_BG,
+		.err = OTF_INPUT_ERROR_NO,
+	},
+	.dma_input = {
+		.cmd = DMA_INPUT_COMMAND_DISABLE,
+		.width = 0, .height = 0,
+		.format = 0, .bitwidth = 0, .plane = 0,
+		.order = 0, .buffer_number = 0, .buffer_address = 0,
+		.err = 0,
+	},
+	.config = {
+		.cmd = FD_CONFIG_COMMAND_MAXIMUM_NUMBER |
+			FD_CONFIG_COMMAND_ROLL_ANGLE |
+			FD_CONFIG_COMMAND_YAW_ANGLE |
+			FD_CONFIG_COMMAND_SMILE_MODE |
+			FD_CONFIG_COMMAND_BLINK_MODE |
+			FD_CONFIG_COMMAND_EYES_DETECT |
+			FD_CONFIG_COMMAND_MOUTH_DETECT |
+			FD_CONFIG_COMMAND_ORIENTATION |
+			FD_CONFIG_COMMAND_ORIENTATION_VALUE,
+		.max_number = CAMERA2_MAX_FACES,
+		.roll_angle = FD_CONFIG_ROLL_ANGLE_FULL,
+		.yaw_angle = FD_CONFIG_YAW_ANGLE_45_90,
+		.smile_mode = FD_CONFIG_SMILE_MODE_DISABLE,
+		.blink_mode = FD_CONFIG_BLINK_MODE_DISABLE,
+		.eye_detect = FD_CONFIG_EYES_DETECT_ENABLE,
+		.mouth_detect = FD_CONFIG_MOUTH_DETECT_DISABLE,
+		.orientation = FD_CONFIG_ORIENTATION_DISABLE,
+		.orientation_value = 0,
+		.err = ERROR_FD_NO,
+	},
+};
+
+static int fimc_is_pipeline_create_subdevs(struct fimc_is_pipeline *pipeline)
+{
+	struct fimc_is *is = pipeline->is;
+	int ret;
+
+	/* ISP */
+	ret = fimc_is_isp_subdev_create(&pipeline->isp,
+			is->alloc_ctx, pipeline);
+	if (ret < 0)
+		return ret;
+
+	/* SCC scaler */
+	ret = fimc_is_scaler_subdev_create(&pipeline->scaler[SCALER_SCC],
+			SCALER_SCC, is->alloc_ctx, pipeline);
+	if (ret < 0)
+		return ret;
+
+	/* SCP scaler */
+	ret = fimc_is_scaler_subdev_create(&pipeline->scaler[SCALER_SCP],
+			SCALER_SCP, is->alloc_ctx, pipeline);
+	if (ret < 0)
+		return ret;
+
+	return ret;
+}
+
+static int fimc_is_pipeline_unregister_subdevs(struct fimc_is_pipeline *p)
+{
+	fimc_is_sensor_subdev_destroy(p->sensor);
+	fimc_is_isp_subdev_destroy(&p->isp);
+	fimc_is_scaler_subdev_destroy(&p->scaler[SCALER_SCC]);
+	fimc_is_scaler_subdev_destroy(&p->scaler[SCALER_SCP]);
+
+	return 0;
+}
+
+int fimc_is_pipeline_init(struct fimc_is_pipeline *pipeline,
+			unsigned int instance, void *is_ctx)
+{
+	struct fimc_is *is = is_ctx;
+	unsigned int i;
+	int ret;
+
+	if (test_bit(PIPELINE_INIT, &pipeline->state)) {
+		is_dbg(3, "Pipeline init already done.\n");
+		return -EINVAL;
+	}
+
+	/* Initialize context variables */
+	pipeline->instance = instance;
+	pipeline->is = is;
+	pipeline->minfo = &is->minfo;
+	pipeline->state = 0;
+	pipeline->force_down = false;
+	for (i = 0; i < FIMC_IS_NUM_COMPS; i++)
+		pipeline->comp_state[i] = 0;
+
+	spin_lock_init(&pipeline->slock_buf);
+	init_waitqueue_head(&pipeline->wait_q);
+	mutex_init(&pipeline->pipe_lock);
+	mutex_init(&pipeline->pipe_scl_lock);
+
+	ret = fimc_is_pipeline_create_subdevs(pipeline);
+	if (ret) {
+		is_err("Subdev creation failed\n");
+		return -EINVAL;
+	}
+
+	/* Setting default width & height for scc & scp */
+	pipeline->scaler_width[SCALER_SCC] = DEFAULT_CAPTURE_VIDEO_WIDTH;
+	pipeline->scaler_height[SCALER_SCC] = DEFAULT_CAPTURE_VIDEO_HEIGHT;
+	pipeline->scaler_width[SCALER_SCP] = DEFAULT_PREVIEW_VIDEO_WIDTH;
+	pipeline->scaler_height[SCALER_SCP] = DEFAULT_PREVIEW_VIDEO_HEIGHT;
+
+	set_bit(PIPELINE_INIT, &pipeline->state);
+	return 0;
+}
+
+int fimc_is_pipeline_destroy(struct fimc_is_pipeline *pipeline)
+{
+	if (!test_bit(PIPELINE_INIT, &pipeline->state)) {
+		is_dbg(3, "Pipeline not inited.\n");
+		return -EINVAL;
+	}
+	return fimc_is_pipeline_unregister_subdevs(pipeline);
+}
+
+static int fimc_is_pipeline_initmem(struct fimc_is_pipeline *pipeline,
+		struct vb2_alloc_ctx *alloc_ctx)
+{
+	struct fimc_is_meminfo *minfo = pipeline->minfo;
+	dma_addr_t *fw_phy_addr;
+	unsigned int offset;
+
+	/* Allocate memory */
+	is_dbg(3, "Allocating memory : %d\n",
+			FIMC_IS_A5_MEM_SIZE + FIMC_IS_A5_SEN_SIZE);
+	fw_cookie = vb2_dma_contig_memops.alloc(alloc_ctx,
+			FIMC_IS_A5_MEM_SIZE + FIMC_IS_A5_SEN_SIZE);
+
+	if (IS_ERR(fw_cookie)) {
+		is_err("Error in allocating FW memory.\n");
+		return -ENOMEM;
+	}
+
+	fw_phy_addr = vb2_dma_contig_memops.cookie(fw_cookie);
+	/* FW memory should be 64MB aligned */
+	if (*fw_phy_addr & FIMC_IS_FW_BASE_MASK) {
+		is_err("FW memory not 64MB aligned.\n");
+		vb2_dma_contig_memops.put(fw_cookie);
+		return -EIO;
+	}
+	minfo->fw_paddr = *fw_phy_addr;
+
+	minfo->fw_vaddr =
+		(unsigned int) vb2_dma_contig_memops.vaddr(fw_cookie);
+
+	is_dbg(3, "FW |Phy Addr : 0x%08x, Virt Addr : 0x%08x\n",
+			minfo->fw_paddr, minfo->fw_vaddr);
+
+	/* Assigning memory regions */
+	offset = FIMC_IS_A5_MEM_SIZE - FIMC_IS_REGION_SIZE;
+	minfo->region_paddr = minfo->fw_paddr + offset;
+	minfo->region_vaddr = minfo->fw_vaddr + offset;
+	pipeline->is_region = (struct is_region *)minfo->region_vaddr;
+
+	minfo->shared_paddr = minfo->fw_paddr +
+		((unsigned int)&pipeline->is_region->shared[0] -
+		 minfo->fw_vaddr);
+	minfo->shared_vaddr = minfo->fw_vaddr +
+		((unsigned int)&pipeline->is_region->shared[0] -
+		 minfo->fw_vaddr);
+
+	/* Allocate shot buffer */
+	shot_cookie = vb2_dma_contig_memops.alloc(alloc_ctx,
+			sizeof(struct camera2_shot));
+	if (IS_ERR(shot_cookie)) {
+		is_err("Error in allocating temp memory.\n");
+		return -ENOMEM;
+	}
+	fw_phy_addr = vb2_dma_contig_memops.cookie(shot_cookie);
+	pipeline->shot_paddr = *fw_phy_addr;
+	pipeline->shot_vaddr =
+		(unsigned int) vb2_dma_contig_memops.vaddr(shot_cookie);
+
+	return 0;
+}
+
+static void fimc_is_pipeline_freemem(struct fimc_is_pipeline *pipeline)
+{
+	if (fw_cookie)
+		vb2_dma_contig_memops.put(fw_cookie);
+	if (shot_cookie)
+		vb2_dma_contig_memops.put(shot_cookie);
+}
+
+static int fimc_is_pipeline_load_firmware(struct fimc_is_pipeline *pipeline)
+{
+	struct firmware *fw_blob;
+	struct fimc_is *is = pipeline->is;
+	int ret;
+
+	ret = request_firmware((const struct firmware **)&fw_blob,
+			"fimc-is-fw.bin", &is->pdev->dev);
+	if (ret != 0) {
+		is_err("Firmware file not found\n");
+		return -EINVAL;
+	}
+	is_dbg(3, "Firmware size : %d\n", fw_blob->size);
+	if (fw_blob->size > FIMC_IS_A5_MEM_SIZE + FIMC_IS_A5_SEN_SIZE) {
+		is_err("Firmware file too big.\n");
+		release_firmware(fw_blob);
+		return -ENOMEM;
+	}
+
+	memcpy((void *)pipeline->minfo->fw_vaddr, fw_blob->data, fw_blob->size);
+	wmb();
+	release_firmware(fw_blob);
+
+	return 0;
+}
+
+static void fimc_is_pipeline_forcedown(struct fimc_is_pipeline *pipeline,
+		bool on)
+{
+	if (on) {
+		is_dbg(3, "Set low poweroff mode\n");
+		writel(0x0, PMUREG_ISP_ARM_OPTION);
+		writel(0x1CF82000, PMUREG_ISP_LOW_POWER_OFF);
+		pipeline->force_down = true;
+	} else {
+		is_dbg(3, "Clear low poweroff mode\n");
+		writel(0xFFFFFFFF, PMUREG_ISP_ARM_OPTION);
+		writel(0x8, PMUREG_ISP_LOW_POWER_OFF);
+		pipeline->force_down = false;
+	}
+}
+
+static int fimc_is_pipeline_power(struct fimc_is_pipeline *pipeline, int on)
+{
+	int ret = 0;
+	u32 timeout;
+	struct fimc_is *is = pipeline->is;
+	struct device *dev = &is->pdev->dev;
+
+	if (on) {
+		/* force poweroff setting */
+		if (pipeline->force_down)
+			fimc_is_pipeline_forcedown(pipeline, false);
+
+		/* FIMC-IS local power enable */
+		ret = pm_runtime_get_sync(dev);
+
+		/* A5 start address setting */
+		writel(pipeline->minfo->fw_paddr, is->interface.regs + BBOAR);
+
+		/* A5 power on*/
+		writel(0x1, PMUREG_ISP_ARM_CONFIGURATION);
+
+		/* enable A5 */
+		writel(0x00018000, PMUREG_ISP_ARM_OPTION);
+		timeout = 1000;
+		while ((__raw_readl(PMUREG_ISP_ARM_STATUS) & 0x1) != 0x1) {
+			if (timeout == 0)
+				is_err("A5 power on failed\n");
+			timeout--;
+			udelay(1);
+		}
+	} else {
+		/* disable A5 */
+		writel(0x10000, PMUREG_ISP_ARM_OPTION);
+		/* A5 power off*/
+		writel(0x0, PMUREG_ISP_ARM_CONFIGURATION);
+
+		/* Check A5 power off status register */
+		timeout = 1000;
+		while (__raw_readl(PMUREG_ISP_ARM_STATUS) & 0x1) {
+			if (timeout == 0) {
+				is_err("A5 power off failed\n");
+				fimc_is_pipeline_forcedown(pipeline, true);
+			}
+			timeout--;
+			udelay(1);
+		}
+
+		writel(0x0, PMUREG_CMU_RESET_ISP_SYS_PWR_REG);
+
+		/* FIMC-IS local power down */
+		pm_runtime_put_sync(dev);
+	}
+
+	return ret;
+}
+
+static int fimc_is_pipeline_load_setfile(struct fimc_is_pipeline *pipeline,
+		unsigned int setfile_addr,
+		unsigned char *setfile_name)
+{
+	struct fimc_is *is = pipeline->is;
+	struct firmware *fw_blob;
+	int ret;
+
+	ret = request_firmware((const struct firmware **)&fw_blob,
+			setfile_name, &is->pdev->dev);
+	if (ret != 0) {
+		is_err("Setfile %s not found\n", setfile_name);
+		return -EINVAL;
+	}
+
+	memcpy((void *)pipeline->minfo->fw_vaddr + setfile_addr,
+			fw_blob->data, fw_blob->size);
+	wmb();
+	release_firmware(fw_blob);
+
+	return 0;
+}
+
+static int fimc_is_pipeline_setfile(struct fimc_is_pipeline *pipeline)
+{
+	struct fimc_is *is = pipeline->is;
+	struct fimc_is_sensor *sensor = pipeline->sensor;
+	int ret;
+	unsigned int setfile_addr;
+
+	/* Get setfile addr from HW */
+	ret = fimc_is_itf_get_setfile_addr(&is->interface,
+			pipeline->instance, &setfile_addr);
+	if (ret < 0) {
+		is_err("Get setfile addr failed.\n");
+		return ret;
+	}
+
+	/* Load setfile */
+	ret = fimc_is_pipeline_load_setfile(pipeline, setfile_addr,
+			sensor->sensor_info->setfile_name);
+	if (ret < 0) {
+		is_err("Load setfile failed.\n");
+		return ret;
+	}
+
+	/* Send HW command */
+	ret = fimc_is_itf_load_setfile(&is->interface, pipeline->instance);
+	if (ret < 0) {
+		is_err("HW Load setfile failed.\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int fimc_is_pipeline_isp_setparams(struct fimc_is_pipeline *pipeline,
+		unsigned int enable)
+{
+	struct isp_param *isp_param = &pipeline->is_region->parameter.isp;
+	struct fimc_is *is = pipeline->is;
+	unsigned int indexes, lindex, hindex;
+	unsigned int sensor_width, sensor_height, scc_width, scc_height;
+	unsigned int crop_x, crop_y, isp_width, isp_height;
+	unsigned int sensor_ratio, output_ratio;
+	int ret;
+
+	/* Crop calculation */
+	sensor_width = pipeline->sensor_width;
+	sensor_height = pipeline->sensor_height;
+	scc_width = pipeline->scaler_width[SCALER_SCC];
+	scc_height = pipeline->scaler_height[SCALER_SCC];
+	isp_width = sensor_width;
+	isp_height = sensor_height;
+	crop_x = crop_y = 0;
+
+	sensor_ratio = sensor_width * 1000 / sensor_height;
+	output_ratio = scc_width * 1000 / scc_height;
+
+	if (sensor_ratio == output_ratio) {
+		isp_width = sensor_width;
+		isp_height = sensor_height;
+	} else if (sensor_ratio < output_ratio) {
+		isp_height = (sensor_width * scc_height) / scc_width;
+		isp_height = ALIGN(isp_height, 2);
+		crop_y = ((sensor_height - isp_height) >> 1) & 0xFFFFFFFE;
+	} else {
+		isp_width = (sensor_height * scc_width) / scc_height;
+		isp_width = ALIGN(isp_width, 4);
+		crop_x =  ((sensor_width - isp_width) >> 1) & 0xFFFFFFFE;
+	}
+	pipeline->isp_width = isp_width;
+	pipeline->isp_height = isp_height;
+
+	indexes = hindex = lindex = 0;
+
+	isp_param->otf_output.cmd = OTF_OUTPUT_COMMAND_ENABLE;
+	isp_param->otf_output.width = pipeline->sensor_width;
+	isp_param->otf_output.height = pipeline->sensor_height;
+	isp_param->otf_output.format = OTF_OUTPUT_FORMAT_YUV444;
+	isp_param->otf_output.bitwidth = OTF_OUTPUT_BIT_WIDTH_12BIT;
+	isp_param->otf_output.order = OTF_INPUT_ORDER_BAYER_GR_BG;
+	lindex |= LOWBIT_OF(PARAM_ISP_OTF_OUTPUT);
+	hindex |= HIGHBIT_OF(PARAM_ISP_OTF_OUTPUT);
+	indexes++;
+
+	isp_param->dma1_output.cmd = DMA_OUTPUT_COMMAND_DISABLE;
+	lindex |= LOWBIT_OF(PARAM_ISP_DMA1_OUTPUT);
+	hindex |= HIGHBIT_OF(PARAM_ISP_DMA1_OUTPUT);
+	indexes++;
+
+	isp_param->dma2_output.cmd = DMA_OUTPUT_COMMAND_DISABLE;
+	lindex |= LOWBIT_OF(PARAM_ISP_DMA2_OUTPUT);
+	hindex |= HIGHBIT_OF(PARAM_ISP_DMA2_OUTPUT);
+	indexes++;
+
+	if (enable)
+		isp_param->control.bypass = CONTROL_BYPASS_DISABLE;
+	else
+		isp_param->control.bypass = CONTROL_BYPASS_ENABLE;
+	isp_param->control.cmd = CONTROL_COMMAND_START;
+	isp_param->control.run_mode = 1;
+	lindex |= LOWBIT_OF(PARAM_ISP_CONTROL);
+	hindex |= HIGHBIT_OF(PARAM_ISP_CONTROL);
+	indexes++;
+
+	isp_param->dma1_input.cmd = DMA_INPUT_COMMAND_BUF_MNGR;
+	isp_param->dma1_input.width = sensor_width;
+	isp_param->dma1_input.height = sensor_height;
+	isp_param->dma1_input.uidmacropoffsetx = crop_x;
+	isp_param->dma1_input.uidmacropoffsety = crop_y;
+	isp_param->dma1_input.uidmacropwidth = isp_width;
+	isp_param->dma1_input.uidmacropheight = isp_height;
+	isp_param->dma1_input.uibayercropoffsetx = 0;
+	isp_param->dma1_input.uibayercropoffsety = 0;
+	isp_param->dma1_input.uibayercropwidth = 0;
+	isp_param->dma1_input.uibayercropheight = 0;
+	isp_param->dma1_input.uiuserminframetime = 0;
+	isp_param->dma1_input.uiusermaxframetime = 66666;
+	isp_param->dma1_input.uiwideframegap = 1;
+	isp_param->dma1_input.uiframegap = 4096;
+	isp_param->dma1_input.uilinegap = 45;
+	isp_param->dma1_input.order = DMA_INPUT_ORDER_GR_BG;
+	isp_param->dma1_input.plane = 1;
+	isp_param->dma1_input.buffer_number = 1;
+	isp_param->dma1_input.buffer_address = 0;
+	isp_param->dma1_input.uireserved[1] = 0;
+	isp_param->dma1_input.uireserved[2] = 0;
+	if (pipeline->isp.fmt->fourcc == V4L2_PIX_FMT_SGRBG8)
+		isp_param->dma1_input.bitwidth = DMA_INPUT_BIT_WIDTH_8BIT;
+	else if (pipeline->isp.fmt->fourcc == V4L2_PIX_FMT_SGRBG10)
+		isp_param->dma1_input.bitwidth = DMA_INPUT_BIT_WIDTH_10BIT;
+	else
+		isp_param->dma1_input.bitwidth = DMA_INPUT_BIT_WIDTH_12BIT;
+	lindex |= LOWBIT_OF(PARAM_ISP_DMA1_INPUT);
+	hindex |= HIGHBIT_OF(PARAM_ISP_DMA1_INPUT);
+	indexes++;
+
+	lindex = 0xFFFFFFFF;
+	hindex = 0xFFFFFFFF;
+
+	wmb();
+	ret = fimc_is_itf_set_param(&is->interface, pipeline->instance,
+			indexes, lindex, hindex);
+	if (ret) {
+		is_err("fimc_is_itf_set_param failed\n");
+		return -EINVAL;
+	}
+
+	set_bit(COMP_ENABLE, &pipeline->comp_state[IS_ISP]);
+
+	return 0;
+}
+
+static int fimc_is_pipeline_drc_setparams(struct fimc_is_pipeline *pipeline,
+		unsigned int enable)
+{
+	struct drc_param *drc_param = &pipeline->is_region->parameter.drc;
+	struct fimc_is *is = pipeline->is;
+	int ret;
+	unsigned int indexes, lindex, hindex;
+
+	indexes = hindex = lindex = 0;
+	if (enable)
+		drc_param->control.bypass = CONTROL_BYPASS_DISABLE;
+	else
+		drc_param->control.bypass = CONTROL_BYPASS_ENABLE;
+	lindex |= LOWBIT_OF(PARAM_DRC_CONTROL);
+	hindex |= HIGHBIT_OF(PARAM_DRC_CONTROL);
+	indexes++;
+
+	drc_param->otf_input.cmd = OTF_INPUT_COMMAND_ENABLE;
+	drc_param->otf_input.width = pipeline->isp_width;
+	drc_param->otf_input.height = pipeline->isp_height;
+	lindex |= LOWBIT_OF(PARAM_DRC_OTF_INPUT);
+	hindex |= HIGHBIT_OF(PARAM_DRC_OTF_INPUT);
+	indexes++;
+
+	drc_param->otf_output.cmd = OTF_OUTPUT_COMMAND_ENABLE;
+	drc_param->otf_output.width = pipeline->isp_width;
+	drc_param->otf_output.height = pipeline->isp_height;
+	lindex |= LOWBIT_OF(PARAM_DRC_OTF_OUTPUT);
+	hindex |= HIGHBIT_OF(PARAM_DRC_OTF_OUTPUT);
+	indexes++;
+
+	wmb();
+	ret = fimc_is_itf_set_param(&is->interface, pipeline->instance,
+			indexes, lindex, hindex);
+	if (ret) {
+		is_err("fimc_is_itf_set_param failed\n");
+		return -EINVAL;
+	}
+	if (enable)
+		set_bit(COMP_ENABLE, &pipeline->comp_state[IS_DRC]);
+	else
+		clear_bit(COMP_ENABLE, &pipeline->comp_state[IS_DRC]);
+
+	return 0;
+}
+
+static int fimc_is_pipeline_scc_setparams(struct fimc_is_pipeline *pipeline,
+		unsigned int enable)
+{
+	struct scalerc_param *scc_param =
+		&pipeline->is_region->parameter.scalerc;
+	struct fimc_is *is = pipeline->is;
+	int ret;
+	unsigned int indexes, lindex, hindex;
+	unsigned int scc_width, scc_height;
+
+	scc_width = pipeline->scaler_width[SCALER_SCC];
+	scc_height = pipeline->scaler_height[SCALER_SCC];
+
+	indexes = hindex = lindex = 0;
+	if (enable)
+		scc_param->control.bypass = CONTROL_BYPASS_DISABLE;
+	else
+		scc_param->control.bypass = CONTROL_BYPASS_ENABLE;
+	lindex |= LOWBIT_OF(PARAM_SCALERC_CONTROL);
+	hindex |= HIGHBIT_OF(PARAM_SCALERC_CONTROL);
+	indexes++;
+
+	scc_param->otf_input.cmd = OTF_INPUT_COMMAND_ENABLE;
+	scc_param->otf_input.width = pipeline->isp_width;
+	scc_param->otf_input.height = pipeline->isp_height;
+	lindex |= LOWBIT_OF(PARAM_SCALERC_OTF_INPUT);
+	hindex |= HIGHBIT_OF(PARAM_SCALERC_OTF_INPUT);
+	indexes++;
+
+	/* SCC OUTPUT */
+	scc_param->input_crop.cmd = SCALER_CROP_COMMAND_ENABLE;
+	scc_param->input_crop.pos_x = 0;
+	scc_param->input_crop.pos_y = 0;
+	scc_param->input_crop.crop_width = pipeline->isp_width;
+	scc_param->input_crop.crop_height = pipeline->isp_height;
+	scc_param->input_crop.in_width = pipeline->isp_width;
+	scc_param->input_crop.in_height = pipeline->isp_height;
+	scc_param->input_crop.out_width = scc_width;
+	scc_param->input_crop.out_height = scc_height;
+	lindex |= LOWBIT_OF(PARAM_SCALERC_INPUT_CROP);
+	hindex |= HIGHBIT_OF(PARAM_SCALERC_INPUT_CROP);
+	indexes++;
+
+	scc_param->output_crop.cmd = SCALER_CROP_COMMAND_DISABLE;
+	scc_param->output_crop.pos_x = 0;
+	scc_param->output_crop.pos_y = 0;
+	scc_param->output_crop.crop_width = scc_width;
+	scc_param->output_crop.crop_height = scc_height;
+	lindex |= LOWBIT_OF(PARAM_SCALERC_OUTPUT_CROP);
+	hindex |= HIGHBIT_OF(PARAM_SCALERC_OUTPUT_CROP);
+	indexes++;
+
+	scc_param->otf_output.cmd = OTF_OUTPUT_COMMAND_ENABLE;
+	scc_param->otf_output.width = scc_width;
+	scc_param->otf_output.height = scc_height;
+	lindex |= LOWBIT_OF(PARAM_SCALERC_OTF_OUTPUT);
+	hindex |= HIGHBIT_OF(PARAM_SCALERC_OTF_OUTPUT);
+	indexes++;
+
+	scc_param->dma_output.width = scc_width;
+	scc_param->dma_output.height = scc_height;
+	lindex |= LOWBIT_OF(PARAM_SCALERC_DMA_OUTPUT);
+	hindex |= HIGHBIT_OF(PARAM_SCALERC_DMA_OUTPUT);
+	indexes++;
+
+	wmb();
+	ret = fimc_is_itf_set_param(&is->interface, pipeline->instance,
+			indexes, lindex, hindex);
+	if (ret) {
+		is_err("fimc_is_itf_set_param failed\n");
+		return -EINVAL;
+	}
+	set_bit(COMP_ENABLE, &pipeline->comp_state[IS_SCC]);
+	return 0;
+}
+
+static int fimc_is_pipeline_odc_setparams(struct fimc_is_pipeline *pipeline,
+		unsigned int enable)
+{
+	struct odc_param *odc_param = &pipeline->is_region->parameter.odc;
+	struct fimc_is *is = pipeline->is;
+	int ret;
+	unsigned int indexes, lindex, hindex;
+	unsigned int scc_width, scc_height;
+
+	scc_width = pipeline->scaler_width[SCALER_SCC];
+	scc_height = pipeline->scaler_height[SCALER_SCC];
+
+	indexes = hindex = lindex = 0;
+	if (enable)
+		odc_param->control.bypass = CONTROL_BYPASS_DISABLE;
+	else
+		odc_param->control.bypass = CONTROL_BYPASS_ENABLE;
+	lindex |= LOWBIT_OF(PARAM_ODC_CONTROL);
+	hindex |= HIGHBIT_OF(PARAM_ODC_CONTROL);
+	indexes++;
+
+	odc_param->otf_input.width = scc_width;
+	odc_param->otf_input.height = scc_height;
+	lindex |= LOWBIT_OF(PARAM_ODC_OTF_INPUT);
+	hindex |= HIGHBIT_OF(PARAM_ODC_OTF_INPUT);
+	indexes++;
+
+	odc_param->otf_output.width = scc_width;
+	odc_param->otf_output.height = scc_height;
+	lindex |= LOWBIT_OF(PARAM_ODC_OTF_OUTPUT);
+	hindex |= HIGHBIT_OF(PARAM_ODC_OTF_OUTPUT);
+	indexes++;
+
+	wmb();
+	ret = fimc_is_itf_set_param(&is->interface, pipeline->instance,
+			indexes, lindex, hindex);
+	if (ret) {
+		is_err("fimc_is_itf_set_param failed\n");
+		return -EINVAL;
+	}
+	if (enable)
+		set_bit(COMP_ENABLE, &pipeline->comp_state[IS_ODC]);
+	else
+		clear_bit(COMP_ENABLE, &pipeline->comp_state[IS_ODC]);
+
+	return 0;
+}
+
+static int fimc_is_pipeline_dis_setparams(struct fimc_is_pipeline *pipeline,
+		unsigned int enable)
+{
+	struct dis_param *dis_param = &pipeline->is_region->parameter.dis;
+	struct fimc_is *is = pipeline->is;
+	int ret;
+	unsigned int indexes, lindex, hindex;
+	unsigned int scc_width, scc_height;
+
+	scc_width = pipeline->scaler_width[SCALER_SCC];
+	scc_height = pipeline->scaler_height[SCALER_SCC];
+
+	indexes = hindex = lindex = 0;
+	if (enable)
+		dis_param->control.bypass = CONTROL_BYPASS_DISABLE;
+	else
+		dis_param->control.bypass = CONTROL_BYPASS_ENABLE;
+	lindex |= LOWBIT_OF(PARAM_DIS_CONTROL);
+	hindex |= HIGHBIT_OF(PARAM_DIS_CONTROL);
+	indexes++;
+
+	/* DIS INPUT */
+	dis_param->otf_input.width = scc_width;
+	dis_param->otf_input.height = scc_height;
+	lindex |= LOWBIT_OF(PARAM_DIS_OTF_INPUT);
+	hindex |= HIGHBIT_OF(PARAM_DIS_OTF_INPUT);
+	indexes++;
+
+	/* DIS OUTPUT */
+	dis_param->otf_output.width = scc_width;
+	dis_param->otf_output.height = scc_height;
+	lindex |= LOWBIT_OF(PARAM_DIS_OTF_OUTPUT);
+	hindex |= HIGHBIT_OF(PARAM_DIS_OTF_OUTPUT);
+	indexes++;
+
+	wmb();
+	ret = fimc_is_itf_set_param(&is->interface, pipeline->instance,
+			indexes, lindex, hindex);
+	if (ret) {
+		is_err("fimc_is_itf_set_param failed\n");
+		return -EINVAL;
+	}
+	if (enable)
+		set_bit(COMP_ENABLE, &pipeline->comp_state[IS_DIS]);
+	else
+		clear_bit(COMP_ENABLE, &pipeline->comp_state[IS_DIS]);
+
+	return 0;
+}
+
+static int fimc_is_pipeline_3dnr_setparams(struct fimc_is_pipeline *pipeline,
+		unsigned int enable)
+{
+	struct tdnr_param *tdnr_param = &pipeline->is_region->parameter.tdnr;
+	struct fimc_is *is = pipeline->is;
+	int ret;
+	unsigned int indexes, lindex, hindex;
+	unsigned int scc_width, scc_height;
+
+	scc_width = pipeline->scaler_width[SCALER_SCC];
+	scc_height = pipeline->scaler_height[SCALER_SCC];
+
+	indexes = hindex = lindex = 0;
+	if (enable)
+		tdnr_param->control.bypass = CONTROL_BYPASS_DISABLE;
+	else
+		tdnr_param->control.bypass = CONTROL_BYPASS_ENABLE;
+	lindex |= LOWBIT_OF(PARAM_TDNR_CONTROL);
+	hindex |= HIGHBIT_OF(PARAM_TDNR_CONTROL);
+	indexes++;
+
+	tdnr_param->otf_input.width = scc_width;
+	tdnr_param->otf_input.height = scc_height;
+	lindex |= LOWBIT_OF(PARAM_TDNR_OTF_INPUT);
+	hindex |= HIGHBIT_OF(PARAM_TDNR_OTF_INPUT);
+	indexes++;
+
+	tdnr_param->dma_output.width = scc_width;
+	tdnr_param->dma_output.height = scc_height;
+	lindex |= LOWBIT_OF(PARAM_TDNR_DMA_OUTPUT);
+	hindex |= HIGHBIT_OF(PARAM_TDNR_DMA_OUTPUT);
+	indexes++;
+
+	tdnr_param->otf_output.width = scc_width;
+	tdnr_param->otf_output.height = scc_height;
+	lindex |= LOWBIT_OF(PARAM_TDNR_OTF_OUTPUT);
+	hindex |= HIGHBIT_OF(PARAM_TDNR_OTF_OUTPUT);
+	indexes++;
+
+	wmb();
+	ret = fimc_is_itf_set_param(&is->interface, pipeline->instance,
+			indexes, lindex, hindex);
+	if (ret) {
+		is_err("fimc_is_itf_set_param failed\n");
+		return -EINVAL;
+	}
+	if (enable)
+		set_bit(COMP_ENABLE, &pipeline->comp_state[IS_TDNR]);
+	else
+		clear_bit(COMP_ENABLE, &pipeline->comp_state[IS_TDNR]);
+
+	return 0;
+}
+
+static int fimc_is_pipeline_scp_setparams(struct fimc_is_pipeline *pipeline,
+		unsigned int enable)
+{
+	struct scalerp_param *scp_param =
+		&pipeline->is_region->parameter.scalerp;
+	struct fimc_is *is = pipeline->is;
+	int ret;
+	unsigned int indexes, lindex, hindex;
+	unsigned int scc_width, scc_height;
+	unsigned int scp_width, scp_height;
+
+	scc_width = pipeline->scaler_width[SCALER_SCC];
+	scc_height = pipeline->scaler_height[SCALER_SCC];
+	scp_width = pipeline->scaler_width[SCALER_SCP];
+	scp_height = pipeline->scaler_height[SCALER_SCP];
+
+	indexes = hindex = lindex = 0;
+	if (enable)
+		scp_param->control.bypass = CONTROL_BYPASS_DISABLE;
+	else
+		scp_param->control.bypass = CONTROL_BYPASS_ENABLE;
+	lindex |= LOWBIT_OF(PARAM_SCALERP_CONTROL);
+	hindex |= HIGHBIT_OF(PARAM_SCALERP_CONTROL);
+	indexes++;
+
+	/* SCP Input */
+	scp_param->otf_input.width = scc_width;
+	scp_param->otf_input.height = scc_height;
+	lindex |= LOWBIT_OF(PARAM_SCALERP_OTF_INPUT);
+	hindex |= HIGHBIT_OF(PARAM_SCALERP_OTF_INPUT);
+	indexes++;
+
+	/* SCP Output */
+	scp_param->input_crop.cmd = SCALER_CROP_COMMAND_ENABLE;
+	scp_param->input_crop.pos_x = 0;
+	scp_param->input_crop.pos_y = 0;
+	scp_param->input_crop.crop_width = scc_width;
+	scp_param->input_crop.crop_height = scc_height;
+	scp_param->input_crop.in_width = scc_width;
+	scp_param->input_crop.in_height = scc_height;
+	scp_param->input_crop.out_width = scp_width;
+	scp_param->input_crop.out_height = scp_height;
+	lindex |= LOWBIT_OF(PARAM_SCALERP_INPUT_CROP);
+	hindex |= HIGHBIT_OF(PARAM_SCALERP_INPUT_CROP);
+	indexes++;
+
+	scp_param->output_crop.cmd = SCALER_CROP_COMMAND_DISABLE;
+	lindex |= LOWBIT_OF(PARAM_SCALERP_OUTPUT_CROP);
+	hindex |= HIGHBIT_OF(PARAM_SCALERP_OUTPUT_CROP);
+	indexes++;
+
+	scp_param->otf_output.width = scp_width;
+	scp_param->otf_output.height = scp_height;
+	lindex |= LOWBIT_OF(PARAM_SCALERP_OTF_OUTPUT);
+	hindex |= HIGHBIT_OF(PARAM_SCALERP_OTF_OUTPUT);
+	indexes++;
+
+	scp_param->dma_output.width = scp_width;
+	scp_param->dma_output.height = scp_height;
+	lindex |= LOWBIT_OF(PARAM_SCALERP_DMA_OUTPUT);
+	hindex |= HIGHBIT_OF(PARAM_SCALERP_DMA_OUTPUT);
+	indexes++;
+
+	wmb();
+	ret = fimc_is_itf_set_param(&is->interface, pipeline->instance,
+			indexes, lindex, hindex);
+	if (ret) {
+		is_err("fimc_is_itf_set_param failed\n");
+		return -EINVAL;
+	}
+	set_bit(COMP_ENABLE, &pipeline->comp_state[IS_SCP]);
+
+	return 0;
+}
+
+static int fimc_is_pipeline_fd_setparams(struct fimc_is_pipeline *pipeline,
+		unsigned int enable)
+{
+	struct fd_param *fd_param = &pipeline->is_region->parameter.fd;
+	struct fimc_is *is = pipeline->is;
+	int ret;
+	unsigned int indexes, lindex, hindex;
+
+	indexes = hindex = lindex = 0;
+	if (enable)
+		fd_param->control.bypass = CONTROL_BYPASS_DISABLE;
+	else
+		fd_param->control.bypass = CONTROL_BYPASS_ENABLE;
+	lindex |= LOWBIT_OF(PARAM_FD_CONTROL);
+	hindex |= HIGHBIT_OF(PARAM_FD_CONTROL);
+	indexes++;
+
+	fd_param->otf_input.width = pipeline->scaler_width[SCALER_SCP];
+	fd_param->otf_input.height = pipeline->scaler_height[SCALER_SCP];
+	lindex |= LOWBIT_OF(PARAM_FD_OTF_INPUT);
+	hindex |= HIGHBIT_OF(PARAM_FD_OTF_INPUT);
+	indexes++;
+
+	wmb();
+	ret = fimc_is_itf_set_param(&is->interface, pipeline->instance,
+			indexes, lindex, hindex);
+	if (ret) {
+		is_err("fimc_is_itf_set_param failed\n");
+		return -EINVAL;
+	}
+	if (enable)
+		set_bit(COMP_ENABLE, &pipeline->comp_state[IS_FD]);
+	else
+		clear_bit(COMP_ENABLE, &pipeline->comp_state[IS_FD]);
+
+	return 0;
+}
+
+void fimc_is_pipeline_buf_lock(struct fimc_is_pipeline *pipeline)
+{
+	spin_lock_irqsave(&pipeline->slock_buf, pipeline->slock_flags);
+}
+
+void fimc_is_pipeline_buf_unlock(struct fimc_is_pipeline *pipeline)
+{
+	spin_unlock_irqrestore(&pipeline->slock_buf, pipeline->slock_flags);
+}
+
+int fimc_is_pipeline_setparams(struct fimc_is_pipeline *pipeline)
+{
+	int ret;
+
+	/* Enabling basic components in pipeline */
+	ret = fimc_is_pipeline_isp_setparams(pipeline, true);
+	ret |= fimc_is_pipeline_drc_setparams(pipeline, false);
+	ret |= fimc_is_pipeline_scc_setparams(pipeline, true);
+	ret |= fimc_is_pipeline_odc_setparams(pipeline, false);
+	ret |= fimc_is_pipeline_dis_setparams(pipeline, false);
+	ret |= fimc_is_pipeline_3dnr_setparams(pipeline, false);
+	ret |= fimc_is_pipeline_scp_setparams(pipeline, true);
+	ret |= fimc_is_pipeline_fd_setparams(pipeline, false);
+	if (ret < 0)
+		is_err("Pipeline setparam failed.\n");
+
+	return ret;
+}
+
+int fimc_is_pipeline_scaler_start(struct fimc_is_pipeline *pipeline,
+		enum fimc_is_scaler_id scaler_id,
+		unsigned int **buf_paddr,
+		unsigned int num_bufs,
+		unsigned int num_planes)
+{
+	struct fimc_is *is = pipeline->is;
+	struct scalerp_param *scp_param =
+		&pipeline->is_region->parameter.scalerp;
+	struct scalerc_param *scc_param =
+		&pipeline->is_region->parameter.scalerc;
+	struct param_dma_output *dma_output;
+	struct fimc_is_fmt *fmt;
+	unsigned int region_index;
+	unsigned long *comp_state;
+	int ret;
+	unsigned int pipe_start_flag = 0;
+	unsigned int i, j, buf_index, buf_mask = 0;
+	unsigned int indexes, lindex, hindex;
+
+	if (!test_bit(PIPELINE_OPEN, &pipeline->state)) {
+		is_err("Pipeline not opened.\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&pipeline->pipe_scl_lock);
+
+	if (test_bit(PIPELINE_START, &pipeline->state)) {
+		/* Pipeline is started.
+		 * Stop it now to set params and start again */
+		ret = fimc_is_pipeline_stop(pipeline);
+		if (ret) {
+			is_err("Not able to stop pipeline\n");
+			goto exit;
+		}
+		pipe_start_flag = 1;
+	}
+
+	indexes = lindex = hindex = 0;
+
+	if (scaler_id == SCALER_SCC) {
+		dma_output = &scc_param->dma_output;
+		region_index = FIMC_IS_SCC_REGION_INDEX;
+		comp_state = &pipeline->comp_state[IS_SCC];
+		fmt = pipeline->scaler[SCALER_SCC].fmt;
+		lindex |= LOWBIT_OF(PARAM_SCALERC_DMA_OUTPUT);
+		hindex |= HIGHBIT_OF(PARAM_SCALERC_DMA_OUTPUT);
+	} else {
+		dma_output = &scp_param->dma_output;
+		comp_state = &pipeline->comp_state[IS_SCP];
+		fmt = pipeline->scaler[SCALER_SCC].fmt;
+		region_index = FIMC_IS_SCP_REGION_INDEX;
+		lindex |= LOWBIT_OF(PARAM_SCALERP_DMA_OUTPUT);
+		hindex |= HIGHBIT_OF(PARAM_SCALERP_DMA_OUTPUT);
+	}
+	indexes++;
+
+	for (i = 0; i < num_bufs; i++) {
+		for (j = 0; j < num_planes; j++) {
+			buf_index = i * num_planes + j;
+			pipeline->is_region->shared[region_index + buf_index] =
+				(unsigned int) &buf_paddr[i][j];
+		}
+		buf_mask |= (1 << i);
+	}
+
+	dma_output->cmd = DMA_OUTPUT_COMMAND_ENABLE;
+	dma_output->dma_out_mask = buf_mask;
+	dma_output->buffer_number = num_bufs;
+	dma_output->plane = num_planes;
+	if ((fmt->fourcc == V4L2_PIX_FMT_YUV420M) ||
+			(fmt->fourcc == V4L2_PIX_FMT_NV12M))
+		dma_output->format = DMA_OUTPUT_FORMAT_YUV420;
+	else if (fmt->fourcc == V4L2_PIX_FMT_NV16)
+		dma_output->format = DMA_OUTPUT_FORMAT_YUV422;
+
+	dma_output->buffer_address = pipeline->minfo->shared_paddr +
+				region_index * sizeof(unsigned int);
+
+	ret = fimc_is_itf_set_param(&is->interface, pipeline->instance,
+			indexes, lindex, hindex);
+	if (ret)
+		pr_err("fimc_is_itf_set_param is fail\n");
+	else
+		set_bit(COMP_START, comp_state);
+
+	if (pipe_start_flag) {
+		ret = fimc_is_pipeline_start(pipeline);
+		if (ret) {
+			is_err("Not able to start pipeline back\n");
+			goto exit;
+		}
+	}
+
+exit:
+	mutex_unlock(&pipeline->pipe_scl_lock);
+	return ret;
+}
+
+int fimc_is_pipeline_scaler_stop(struct fimc_is_pipeline *pipeline,
+		enum fimc_is_scaler_id scaler_id)
+{
+	struct fimc_is *is = pipeline->is;
+	struct scalerp_param *scp_param =
+		&pipeline->is_region->parameter.scalerp;
+	struct scalerc_param *scc_param =
+		&pipeline->is_region->parameter.scalerc;
+	struct param_dma_output *dma_output;
+	unsigned int pipe_start_flag = 0;
+	unsigned int indexes, lindex, hindex;
+	unsigned long *comp_state;
+	int ret;
+
+	if (!test_bit(PIPELINE_OPEN, &pipeline->state))
+		return -EINVAL;
+
+	mutex_lock(&pipeline->pipe_scl_lock);
+
+	if (test_bit(PIPELINE_START, &pipeline->state)) {
+		/* Pipeline is started.
+		 * Stop it now to set params and start again */
+		ret = fimc_is_pipeline_stop(pipeline);
+		if (ret) {
+			is_err("Not able to stop pipeline\n");
+			goto exit;
+		}
+		pipe_start_flag = 1;
+	}
+
+	comp_state = (scaler_id == SCALER_SCC) ?
+		&pipeline->comp_state[IS_SCC] : &pipeline->comp_state[IS_SCP];
+
+	if (!test_bit(COMP_START, comp_state)) {
+		is_dbg(1, "Scaler not started\n");
+		ret = 0;
+		goto exit;
+	}
+
+	if (!test_bit(PIPELINE_START, &pipeline->state)) {
+		is_err("Pipeline not started.\n");
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	indexes = lindex = hindex = 0;
+
+	if (scaler_id == SCALER_SCC) {
+		dma_output = &scc_param->dma_output;
+		lindex |= LOWBIT_OF(PARAM_SCALERC_DMA_OUTPUT);
+		hindex |= HIGHBIT_OF(PARAM_SCALERC_DMA_OUTPUT);
+	} else {
+		dma_output = &scp_param->dma_output;
+		lindex |= LOWBIT_OF(PARAM_SCALERP_DMA_OUTPUT);
+		hindex |= HIGHBIT_OF(PARAM_SCALERP_DMA_OUTPUT);
+	}
+	indexes++;
+	dma_output->cmd = DMA_OUTPUT_COMMAND_DISABLE;
+
+	ret = fimc_is_itf_set_param(&is->interface, pipeline->instance,
+			indexes, lindex, hindex);
+	if (ret < 0)
+		pr_err("fimc_is_itf_set_param is fail\n");
+	else
+		clear_bit(COMP_START, comp_state);
+
+	if (pipe_start_flag) {
+		ret = fimc_is_pipeline_start(pipeline);
+		if (ret) {
+			is_err("Not able to start pipeline back\n");
+			return -EINVAL;
+		}
+	}
+
+exit:
+	mutex_unlock(&pipeline->pipe_scl_lock);
+	return ret;
+}
+
+void fimc_is_pipeline_config_shot(struct fimc_is_pipeline *pipeline)
+{
+	struct camera2_shot *shot =
+		(struct camera2_shot *)pipeline->shot_vaddr;
+
+	shot->magicnumber = 0x23456789;
+
+	shot->ctl.aa.mode = AA_CONTROL_AUTO;
+	shot->ctl.aa.aemode = AA_AEMODE_ON;
+}
+
+int fimc_is_pipeline_shot(struct fimc_is_pipeline *pipeline)
+{
+	struct fimc_is *is = pipeline->is;
+	int ret;
+	unsigned int rcount;
+	struct camera2_shot *shot =
+		(struct camera2_shot *)pipeline->shot_vaddr;
+	struct fimc_is_buf *scc_buf, *scp_buf, *bayer_buf;
+
+	if (!test_bit(PIPELINE_START, &pipeline->state)) {
+		/* Pipeline not started yet */
+		is_err("\n");
+		return -EINVAL;
+	}
+
+	if (test_bit(PIPELINE_RUN, &pipeline->state)) {
+		/* Pipeline busy. Caller need to wait */
+		is_err("\n");
+		return -EBUSY;
+	}
+
+	fimc_is_pipeline_buf_lock(pipeline);
+
+	if (list_empty(&pipeline->isp.wait_queue)) {
+		/* No more bayer buffers */
+		wake_up(&pipeline->wait_q);
+		fimc_is_pipeline_buf_unlock(pipeline);
+		return 0;
+	}
+
+	/* Set the state as RUN */
+	set_bit(PIPELINE_RUN, &pipeline->state);
+
+	/* Get bayer input buffer */
+	bayer_buf = fimc_is_isp_wait_queue_get(&pipeline->isp);
+	if (!bayer_buf) {
+		fimc_is_pipeline_buf_unlock(pipeline);
+		goto err_exit;
+	}
+	fimc_is_isp_run_queue_add(&pipeline->isp, bayer_buf);
+
+	/* Get SCC buffer */
+	if (test_bit(COMP_START, &pipeline->comp_state[IS_SCC]) &&
+		!list_empty(&pipeline->scaler[SCALER_SCC].wait_queue)) {
+		scc_buf = fimc_is_scaler_wait_queue_get(
+				&pipeline->scaler[SCALER_SCC]);
+		if (scc_buf) {
+			fimc_is_scaler_run_queue_add(
+					&pipeline->scaler[SCALER_SCC],
+					scc_buf);
+			shot->uctl.scalerud.scctargetaddress[0] =
+							scc_buf->paddr[0];
+			shot->uctl.scalerud.scctargetaddress[1] =
+							scc_buf->paddr[1];
+			shot->uctl.scalerud.scctargetaddress[2] =
+							scc_buf->paddr[2];
+			set_bit(COMP_RUN, &pipeline->comp_state[IS_SCC]);
+		}
+	} else {
+		is_dbg(3, "No SCC buffer available\n");
+		shot->uctl.scalerud.scctargetaddress[0] = 0;
+		shot->uctl.scalerud.scctargetaddress[1] = 0;
+		shot->uctl.scalerud.scctargetaddress[2] = 0;
+	}
+
+	/* Get SCP buffer */
+	if (test_bit(COMP_START, &pipeline->comp_state[IS_SCP]) &&
+		!list_empty(&pipeline->scaler[SCALER_SCP].wait_queue)) {
+		scp_buf = fimc_is_scaler_wait_queue_get(
+				&pipeline->scaler[SCALER_SCP]);
+		if (scp_buf) {
+			fimc_is_scaler_run_queue_add(
+					&pipeline->scaler[SCALER_SCP],
+					scp_buf);
+			shot->uctl.scalerud.scptargetaddress[0] =
+							scp_buf->paddr[0];
+			shot->uctl.scalerud.scptargetaddress[1] =
+							scp_buf->paddr[1];
+			shot->uctl.scalerud.scptargetaddress[2] =
+							scp_buf->paddr[2];
+			set_bit(COMP_RUN, &pipeline->comp_state[IS_SCP]);
+		}
+	} else {
+		is_dbg(3, "No SCP buffer available\n");
+		shot->uctl.scalerud.scptargetaddress[0] = 0;
+		shot->uctl.scalerud.scptargetaddress[1] = 0;
+		shot->uctl.scalerud.scptargetaddress[2] = 0;
+	}
+	fimc_is_pipeline_buf_unlock(pipeline);
+
+	/* Send shot command */
+	pipeline->fcount++;
+	rcount = pipeline->fcount;
+	shot->ctl.request.framecount = pipeline->fcount;
+	is_dbg(3, "Shot command fcount : %d, Bayer addr : 0x%08x\n",
+			pipeline->fcount, bayer_buf->paddr[0]);
+	ret = fimc_is_itf_shot_nblk(&is->interface, pipeline->instance,
+			bayer_buf->paddr[0],
+			pipeline->shot_paddr,
+			pipeline->fcount,
+			rcount);
+	if (ret < 0) {
+		is_err("Shot command failed.\n");
+		goto err_exit;
+	}
+	return 0;
+
+err_exit:
+	clear_bit(PIPELINE_RUN, &pipeline->state);
+	clear_bit(COMP_RUN, &pipeline->comp_state[IS_SCC]);
+	clear_bit(COMP_RUN, &pipeline->comp_state[IS_SCP]);
+	return -EINVAL;
+}
+
+int fimc_is_pipeline_start(struct fimc_is_pipeline *pipeline)
+{
+	int ret;
+	struct fimc_is *is = pipeline->is;
+
+	/* Check if open or not */
+	if (!test_bit(PIPELINE_OPEN, &pipeline->state)) {
+		is_err("Pipeline not open.\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&pipeline->pipe_lock);
+
+	/* Check if already started */
+	if (test_bit(PIPELINE_START, &pipeline->state)) {
+		is_dbg(3, "Pipeline already started.\n");
+		mutex_unlock(&pipeline->pipe_lock);
+		return 0;
+	}
+
+	/* Set pipeline component params */
+	ret = fimc_is_pipeline_setparams(pipeline);
+	if (ret < 0) {
+		is_err("Set params failed\n");
+		goto err_exit;
+	}
+
+	/* Send preview still command */
+	ret = fimc_is_itf_preview_still(&is->interface, pipeline->instance);
+	if (ret) {
+		is_err("Preview still command failed\n");
+		goto err_exit;
+	}
+
+	/* Confiture shot memory to A5 */
+	ret = fimc_is_itf_cfg_mem(&is->interface, pipeline->instance,
+			pipeline->shot_paddr, sizeof(struct camera2_shot));
+	if (ret < 0) {
+		is_err("Config A5 mem failed.\n");
+		goto err_exit;
+	}
+
+	/* Set shot params */
+	fimc_is_pipeline_config_shot(pipeline);
+
+	/* Process ON command */
+	ret = fimc_is_itf_process_on(&is->interface, pipeline->instance);
+	if (ret) {
+		is_err("Process on failed\n");
+		goto err_exit;
+	}
+
+	/* Stream ON */
+	ret = fimc_is_itf_stream_on(&is->interface, pipeline->instance);
+	if (ret < 0) {
+		is_err("Stream On failed.\n");
+		goto err_exit;
+	}
+
+	/* Set state to START */
+	set_bit(PIPELINE_START, &pipeline->state);
+
+	mutex_unlock(&pipeline->pipe_lock);
+	return 0;
+
+err_exit:
+	mutex_unlock(&pipeline->pipe_lock);
+	return ret;
+}
+
+int fimc_is_pipeline_stop(struct fimc_is_pipeline *pipeline)
+{
+	int ret;
+	struct fimc_is *is = pipeline->is;
+
+	mutex_lock(&pipeline->pipe_lock);
+
+	/* Check if started */
+	if (!test_bit(PIPELINE_OPEN, &pipeline->state) ||
+		!test_bit(PIPELINE_START, &pipeline->state)) {
+		is_dbg(3, "Pipeline not open/started.\n");
+		ret = -EINVAL;
+		goto err_exit;
+	}
+
+	/* Wait if any operation is in progress */
+	ret = wait_event_timeout(pipeline->wait_q,
+			!test_bit(PIPELINE_RUN, &pipeline->state),
+			FIMC_IS_COMMAND_TIMEOUT);
+	if (!ret) {
+		is_err("Pipeline timeout");
+		ret = -EBUSY;
+		goto err_exit;
+	}
+
+	/* Wait for scaler operations if any to complete */
+	ret = wait_event_timeout(pipeline->scaler[SCALER_SCC].event_q,
+			!test_bit(COMP_RUN, &pipeline->comp_state[IS_SCC]),
+			FIMC_IS_COMMAND_TIMEOUT);
+	if (!ret) {
+		is_err("SCC timeout");
+		ret = -EBUSY;
+		goto err_exit;
+	}
+	ret = wait_event_timeout(pipeline->scaler[SCALER_SCP].event_q,
+			!test_bit(COMP_RUN, &pipeline->comp_state[IS_SCP]),
+			FIMC_IS_COMMAND_TIMEOUT);
+	if (!ret) {
+		is_err("SCP timeout");
+		ret = -EBUSY;
+		goto err_exit;
+	}
+
+
+	/* Process OFF */
+	ret = fimc_is_itf_process_off(&is->interface, pipeline->instance);
+	if (ret) {
+		is_err("Process off failed\n");
+		ret = -EINVAL;
+		goto err_exit;
+	}
+
+	/* Stream OFF */
+	ret = fimc_is_itf_stream_off(&is->interface, pipeline->instance);
+	if (ret < 0) {
+		is_err("Stream Off failed.\n");
+		ret = -EINVAL;
+		goto err_exit;
+	}
+
+	/* Clear state */
+	clear_bit(PIPELINE_START, &pipeline->state);
+
+	mutex_unlock(&pipeline->pipe_lock);
+	return 0;
+
+err_exit:
+	mutex_unlock(&pipeline->pipe_lock);
+	return ret;
+}
+
+int fimc_is_pipeline_open(struct fimc_is_pipeline *pipeline,
+		struct fimc_is_sensor *sensor)
+{
+	struct fimc_is *is = pipeline->is;
+	struct is_region *region;
+	int ret;
+
+	is_dbg(5, "Pipeline open, instance : %d\n", pipeline->instance);
+
+	mutex_lock(&pipeline->pipe_lock);
+
+	/* Check if already open */
+	if (test_bit(PIPELINE_OPEN, &pipeline->state)) {
+		is_err("Pipeline already open.\n");
+		ret = -EINVAL;
+		goto err_exit;
+	}
+
+	/* Init pipeline params */
+	pipeline->fcount = 0;
+	pipeline->sensor = sensor;
+	pipeline->sensor_width = sensor->sensor_info->active_width;
+	pipeline->sensor_height = sensor->sensor_info->active_height;
+
+	/* Init memory */
+	ret = fimc_is_pipeline_initmem(pipeline, is->alloc_ctx);
+	if (ret < 0) {
+		is_err("Pipeline memory init failed.\n");
+		goto err_exit;
+	}
+
+	/* Load firmware */
+	ret = fimc_is_pipeline_load_firmware(pipeline);
+	if (ret < 0) {
+		is_err("Firmware load failed.\n");
+		goto err_fw;
+	}
+
+	/* Power ON */
+	ret = fimc_is_pipeline_power(pipeline, 1);
+	if (ret < 0) {
+		is_err("A5 power on failed.\n");
+		goto err_fw;
+	}
+
+	/* Wait for FW Init to complete */
+	ret = fimc_is_itf_wait_init_state(&is->interface);
+	if (ret < 0) {
+		is_err("FW init failed.\n");
+		goto err_fw;
+	}
+
+	/* Open Sensor */
+	region = pipeline->is_region;
+	memcpy(&region->shared[0], &sensor->sensor_info->ext,
+			sizeof(struct fimc_is_sensor_ext));
+	ret = fimc_is_itf_open_sensor(&is->interface,
+			pipeline->instance,
+			sensor->sensor_info->sensor_id,
+			sensor->sensor_info->i2c_ch,
+			pipeline->minfo->shared_paddr);
+	if (ret < 0) {
+		is_err("Open sensor failed\n");
+		goto err_exit;
+	}
+
+	is_dbg(3, "Magic Number : %x\n",
+			pipeline->is_region->shared[MAX_SHARED_COUNT-1]);
+
+	/* Copy init params to FW region */
+	memset(&region->parameter, 0x0, sizeof(struct is_param_region));
+
+	memcpy(&region->parameter.sensor, &init_sensor_param,
+			sizeof(struct sensor_param));
+	memcpy(&region->parameter.isp, &init_isp_param,
+			sizeof(struct isp_param));
+	memcpy(&region->parameter.drc, &init_drc_param,
+			sizeof(struct drc_param));
+	memcpy(&region->parameter.scalerc, &init_scalerc_param,
+			sizeof(struct scalerc_param));
+	memcpy(&region->parameter.odc, &init_odc_param,
+			sizeof(struct odc_param));
+	memcpy(&region->parameter.dis, &init_dis_param,
+			sizeof(struct dis_param));
+	memcpy(&region->parameter.tdnr, &init_tdnr_param,
+			sizeof(struct tdnr_param));
+	memcpy(&region->parameter.scalerp, &init_scalerp_param,
+			sizeof(struct scalerp_param));
+	memcpy(&region->parameter.fd, &init_fd_param,
+			sizeof(struct fd_param));
+
+	/* Load setfile */
+	ret = fimc_is_pipeline_setfile(pipeline);
+	if (ret < 0)
+		goto err_exit;
+
+	/* Stream off */
+	ret = fimc_is_itf_stream_off(&is->interface, pipeline->instance);
+	if (ret < 0)
+		goto err_exit;
+
+	/* Process off */
+	ret = fimc_is_itf_process_off(&is->interface, pipeline->instance);
+	if (ret < 0)
+		goto err_exit;
+
+	/* Set state to OPEN */
+	set_bit(PIPELINE_OPEN, &pipeline->state);
+
+	mutex_unlock(&pipeline->pipe_lock);
+	return 0;
+
+err_fw:
+	fimc_is_pipeline_freemem(pipeline);
+err_exit:
+	mutex_unlock(&pipeline->pipe_lock);
+	return ret;
+}
+
+int fimc_is_pipeline_close(struct fimc_is_pipeline *pipeline)
+{
+	int ret;
+	struct fimc_is *is = pipeline->is;
+
+	mutex_lock(&pipeline->pipe_lock);
+
+	/* Check if opened */
+	if (!test_bit(PIPELINE_OPEN, &pipeline->state)) {
+		is_err("Pipeline not opened\n");
+		ret = -EINVAL;
+		goto err_exit;
+	}
+
+	/* Stop pipeline */
+	if (test_bit(PIPELINE_START, &pipeline->state)) {
+		is_err("Cannot close pipeline when its started\n");
+		ret = -EINVAL;
+		goto err_exit;
+	}
+
+	/* FW power off command */
+	ret = fimc_is_itf_power_down(&is->interface, pipeline->instance);
+	if (ret)
+		is_err("FW power down error\n");
+
+	/* Pipeline power off*/
+	fimc_is_pipeline_power(pipeline, 0);
+
+	/* Free memory */
+	fimc_is_pipeline_freemem(pipeline);
+
+	clear_bit(PIPELINE_OPEN, &pipeline->state);
+	mutex_unlock(&pipeline->pipe_lock);
+	return 0;
+
+err_exit:
+	mutex_unlock(&pipeline->pipe_lock);
+	return ret;
+}
diff --git a/drivers/media/platform/exynos5-is/fimc-is-pipeline.h b/drivers/media/platform/exynos5-is/fimc-is-pipeline.h
new file mode 100644
index 0000000..0b0682f
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is-pipeline.h
@@ -0,0 +1,129 @@
+/*
+ * Samsung EXYNOS5 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ *  Arun Kumar K <arun.kk@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef FIMC_IS_PIPELINE_H_
+#define FIMC_IS_PIPELINE_H_
+
+#include "fimc-is-core.h"
+#include "fimc-is-sensor.h"
+#include "fimc-is-isp.h"
+#include "fimc-is-scaler.h"
+
+#define FIMC_IS_A5_MEM_SIZE		(0x00A00000)
+#define FIMC_IS_A5_SEN_SIZE		(0x00100000)
+#define FIMC_IS_REGION_SIZE		(0x5000)
+#define FIMC_IS_SETFILE_SIZE		(0xc0d8)
+#define FIMC_IS_TDNR_MEM_SIZE		(1920*1080*4)
+#define FIMC_IS_DEBUG_REGION_ADDR	(0x00840000)
+#define FIMC_IS_SHARED_REGION_ADDR	(0x008C0000)
+
+#define FIMC_IS_SCP_REGION_INDEX	400
+#define FIMC_IS_SCC_REGION_INDEX	447
+
+#define MAX_ODC_INTERNAL_BUF_WIDTH	(2560)  /* 4808 in HW */
+#define MAX_ODC_INTERNAL_BUF_HEIGHT	(1920)  /* 3356 in HW */
+#define SIZE_ODC_INTERNAL_BUF \
+	(MAX_ODC_INTERNAL_BUF_WIDTH * MAX_ODC_INTERNAL_BUF_HEIGHT * 3)
+
+#define MAX_DIS_INTERNAL_BUF_WIDTH	(2400)
+#define MAX_DIS_INTERNAL_BUF_HEIGHT	(1360)
+#define SIZE_DIS_INTERNAL_BUF \
+	(MAX_DIS_INTERNAL_BUF_WIDTH * MAX_DIS_INTERNAL_BUF_HEIGHT * 2)
+
+#define MAX_3DNR_INTERNAL_BUF_WIDTH	(1920)
+#define MAX_3DNR_INTERNAL_BUF_HEIGHT	(1088)
+#define SIZE_DNR_INTERNAL_BUF \
+	(MAX_3DNR_INTERNAL_BUF_WIDTH * MAX_3DNR_INTERNAL_BUF_HEIGHT * 2)
+
+#define NUM_ODC_INTERNAL_BUF		(2)
+#define NUM_DIS_INTERNAL_BUF		(5)
+#define NUM_DNR_INTERNAL_BUF		(2)
+
+#define FIMC_IS_FW_BASE_MASK		((1 << 26) - 1)
+
+#define FIMC_IS_NUM_COMPS		8
+
+enum pipeline_state {
+	PIPELINE_INIT,
+	PIPELINE_OPEN,
+	PIPELINE_START,
+	PIPELINE_RUN,
+};
+
+enum is_components {
+	IS_ISP,
+	IS_DRC,
+	IS_SCC,
+	IS_ODC,
+	IS_DIS,
+	IS_TDNR,
+	IS_SCP,
+	IS_FD
+};
+
+enum component_state {
+	COMP_ENABLE,
+	COMP_START,
+	COMP_RUN
+};
+
+struct fimc_is_pipeline {
+	unsigned long		state;
+	unsigned long		comp_state[FIMC_IS_NUM_COMPS];
+	bool			force_down;
+	unsigned int		instance;
+	spinlock_t		slock_buf;
+	unsigned long		slock_flags;
+	wait_queue_head_t	wait_q;
+	struct mutex		pipe_lock;
+	struct mutex		pipe_scl_lock;
+
+	struct fimc_is_meminfo	*minfo;
+	struct is_region	*is_region;
+
+	void			*is;
+	struct fimc_is_sensor	*sensor;
+	struct fimc_is_isp	isp;
+	struct fimc_is_scaler	scaler[FIMC_IS_NUM_SCALERS];
+
+	unsigned int		fcount;
+	unsigned int		sensor_width;
+	unsigned int		sensor_height;
+	unsigned int		isp_width;
+	unsigned int		isp_height;
+	unsigned int		scaler_width[FIMC_IS_NUM_SCALERS];
+	unsigned int		scaler_height[FIMC_IS_NUM_SCALERS];
+
+	unsigned int		shot_paddr;
+	unsigned int		shot_vaddr;
+};
+
+void fimc_is_pipeline_buf_lock(struct fimc_is_pipeline *pipeline);
+void fimc_is_pipeline_buf_unlock(struct fimc_is_pipeline *pipeline);
+int fimc_is_pipeline_setparams(struct fimc_is_pipeline *pipeline);
+int fimc_is_pipeline_scaler_start(struct fimc_is_pipeline *pipeline,
+		enum fimc_is_scaler_id scaler_id,
+		unsigned int **buf_paddr,
+		unsigned int num_bufs,
+		unsigned int num_planes);
+int fimc_is_pipeline_scaler_stop(struct fimc_is_pipeline *pipeline,
+		enum fimc_is_scaler_id scaler_id);
+void fimc_is_pipeline_config_shot(struct fimc_is_pipeline *pipeline);
+int fimc_is_pipeline_shot(struct fimc_is_pipeline *pipeline);
+int fimc_is_pipeline_start(struct fimc_is_pipeline *pipeline);
+int fimc_is_pipeline_stop(struct fimc_is_pipeline *pipeline);
+int fimc_is_pipeline_init(struct fimc_is_pipeline *pipeline,
+			unsigned int instance, void *is_ctx);
+int fimc_is_pipeline_destroy(struct fimc_is_pipeline *pipeline);
+int fimc_is_pipeline_open(struct fimc_is_pipeline *pipeline,
+		struct fimc_is_sensor *sensor);
+int fimc_is_pipeline_close(struct fimc_is_pipeline *pipeline);
+
+#endif
-- 
1.7.9.5

