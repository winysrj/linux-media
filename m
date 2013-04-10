Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:9961 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab3DJKoD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 06:44:03 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
	shaik.samsung@gmail.com, arun.kk@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 4/7] exynos4-is: Improve the ISP chain parameter count
 calculation
Date: Wed, 10 Apr 2013 12:42:39 +0200
Message-id: <1365590562-5747-5-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1365590562-5747-1-git-send-email-s.nawrocki@samsung.com>
References: <1365590562-5747-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of incrementing p_region_num field each time we set a bit
in the parameter mask calculate the number of bits set only when
this information is needed.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is-param.c |   86 +++++++--------------
 drivers/media/platform/exynos4-is/fimc-is-param.h |    4 +-
 drivers/media/platform/exynos4-is/fimc-is-regs.c  |    3 +-
 drivers/media/platform/exynos4-is/fimc-is.c       |    2 -
 drivers/media/platform/exynos4-is/fimc-is.h       |    1 -
 drivers/media/platform/exynos4-is/fimc-isp.c      |    7 +-
 6 files changed, 34 insertions(+), 69 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is-param.c b/drivers/media/platform/exynos4-is/fimc-is-param.c
index 37fd5fe..58123e3 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-param.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-param.c
@@ -12,14 +12,15 @@
  */
 #define pr_fmt(fmt) "%s:%d " fmt, __func__, __LINE__
 
+#include <linux/bitops.h>
 #include <linux/bug.h>
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/types.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/types.h>
 #include <linux/videodev2.h>
 
 #include <media/v4l2-device.h>
@@ -160,6 +161,20 @@ int __fimc_is_hw_update_param(struct fimc_is *is, u32 offset)
 	return 0;
 }
 
+unsigned int __get_pending_param_count(struct fimc_is *is)
+{
+	struct is_config_param *config = &is->cfg_param[is->scenario_id];
+	unsigned long flags;
+	unsigned int count;
+
+	spin_lock_irqsave(&is->slock, flags);
+	count = hweight32(config->p_region_index1);
+	count += hweight32(config->p_region_index2);
+	spin_unlock_irqrestore(&is->slock, flags);
+
+	return count;
+}
+
 int __is_hw_update_params(struct fimc_is *is)
 {
 	unsigned long *p_index1, *p_index2;
@@ -234,15 +249,10 @@ void __is_set_frame_size(struct fimc_is *is, struct v4l2_mbus_framefmt *mf)
 
 	/* Update field */
 	fimc_is_set_param_bit(is, PARAM_ISP_OTF_INPUT);
-	fimc_is_inc_param_num(is);
 	fimc_is_set_param_bit(is, PARAM_ISP_OTF_OUTPUT);
-	fimc_is_inc_param_num(is);
 	fimc_is_set_param_bit(is, PARAM_DRC_OTF_INPUT);
-	fimc_is_inc_param_num(is);
 	fimc_is_set_param_bit(is, PARAM_DRC_OTF_OUTPUT);
-	fimc_is_inc_param_num(is);
 	fimc_is_set_param_bit(is, PARAM_FD_OTF_INPUT);
-	fimc_is_inc_param_num(is);
 }
 
 int fimc_is_hw_get_sensor_max_framerate(struct fimc_is *is)
@@ -277,14 +287,11 @@ void __is_set_sensor(struct fimc_is *is, int fps)
 		isp->otf_input.frametime_max = (u32)1000000 / fps;
 	}
 
-	if (!test_bit(PARAM_SENSOR_FRAME_RATE, p_index)) {
+	if (!test_bit(PARAM_SENSOR_FRAME_RATE, p_index))
 		fimc_is_set_param_bit(is, PARAM_SENSOR_FRAME_RATE);
-		fimc_is_inc_param_num(is);
-	}
-	if (!test_bit(PARAM_ISP_OTF_INPUT, p_index)) {
+
+	if (!test_bit(PARAM_ISP_OTF_INPUT, p_index))
 		fimc_is_set_param_bit(is, PARAM_ISP_OTF_INPUT);
-		fimc_is_inc_param_num(is);
-	}
 }
 
 void __is_set_init_isp_aa(struct fimc_is *is)
@@ -306,7 +313,6 @@ void __is_set_init_isp_aa(struct fimc_is *is)
 	isp->aa.err = ISP_AF_ERROR_NONE;
 
 	fimc_is_set_param_bit(is, PARAM_ISP_AA);
-	fimc_is_inc_param_num(is);
 }
 
 void __is_set_isp_flash(struct fimc_is *is, u32 cmd, u32 redeye)
@@ -319,10 +325,8 @@ void __is_set_isp_flash(struct fimc_is *is, u32 cmd, u32 redeye)
 	isp->flash.redeye = redeye;
 	isp->flash.err = ISP_FLASH_ERROR_NONE;
 
-	if (!test_bit(PARAM_ISP_FLASH, &cfg->p_region_index1)) {
+	if (!test_bit(PARAM_ISP_FLASH, &cfg->p_region_index1))
 		fimc_is_set_param_bit(is, PARAM_ISP_FLASH);
-		fimc_is_inc_param_num(is);
-	}
 }
 
 void __is_set_isp_awb(struct fimc_is *is, u32 cmd, u32 val)
@@ -338,10 +342,8 @@ void __is_set_isp_awb(struct fimc_is *is, u32 cmd, u32 val)
 	isp->awb.illumination = val;
 	isp->awb.err = ISP_AWB_ERROR_NONE;
 
-	if (!test_bit(PARAM_ISP_AWB, p_index)) {
+	if (!test_bit(PARAM_ISP_AWB, p_index))
 		fimc_is_set_param_bit(is, PARAM_ISP_AWB);
-		fimc_is_inc_param_num(is);
-	}
 }
 
 void __is_set_isp_effect(struct fimc_is *is, u32 cmd)
@@ -356,10 +358,8 @@ void __is_set_isp_effect(struct fimc_is *is, u32 cmd)
 	isp->effect.cmd = cmd;
 	isp->effect.err = ISP_IMAGE_EFFECT_ERROR_NONE;
 
-	if (!test_bit(PARAM_ISP_IMAGE_EFFECT, p_index)) {
+	if (!test_bit(PARAM_ISP_IMAGE_EFFECT, p_index))
 		fimc_is_set_param_bit(is, PARAM_ISP_IMAGE_EFFECT);
-		fimc_is_inc_param_num(is);
-	}
 }
 
 void __is_set_isp_iso(struct fimc_is *is, u32 cmd, u32 val)
@@ -375,10 +375,8 @@ void __is_set_isp_iso(struct fimc_is *is, u32 cmd, u32 val)
 	isp->iso.value = val;
 	isp->iso.err = ISP_ISO_ERROR_NONE;
 
-	if (!test_bit(PARAM_ISP_ISO, p_index)) {
+	if (!test_bit(PARAM_ISP_ISO, p_index))
 		fimc_is_set_param_bit(is, PARAM_ISP_ISO);
-		fimc_is_inc_param_num(is);
-	}
 }
 
 void __is_set_isp_adjust(struct fimc_is *is, u32 cmd, u32 val)
@@ -423,7 +421,6 @@ void __is_set_isp_adjust(struct fimc_is *is, u32 cmd, u32 val)
 		isp->adjust.cmd = cmd;
 		isp->adjust.err = ISP_ADJUST_ERROR_NONE;
 		fimc_is_set_param_bit(is, PARAM_ISP_ADJUST);
-		fimc_is_inc_param_num(is);
 	} else {
 		isp->adjust.cmd |= cmd;
 	}
@@ -461,7 +458,6 @@ void __is_set_isp_metering(struct fimc_is *is, u32 id, u32 val)
 	if (!test_bit(PARAM_ISP_METERING, p_index)) {
 		isp->metering.err = ISP_METERING_ERROR_NONE;
 		fimc_is_set_param_bit(is, PARAM_ISP_METERING);
-		fimc_is_inc_param_num(is);
 	}
 }
 
@@ -478,10 +474,8 @@ void __is_set_isp_afc(struct fimc_is *is, u32 cmd, u32 val)
 	isp->afc.manual = val;
 	isp->afc.err = ISP_AFC_ERROR_NONE;
 
-	if (!test_bit(PARAM_ISP_AFC, p_index)) {
+	if (!test_bit(PARAM_ISP_AFC, p_index))
 		fimc_is_set_param_bit(is, PARAM_ISP_AFC);
-		fimc_is_inc_param_num(is);
-	}
 }
 
 void __is_set_drc_control(struct fimc_is *is, u32 val)
@@ -495,10 +489,8 @@ void __is_set_drc_control(struct fimc_is *is, u32 val)
 
 	drc->control.bypass = val;
 
-	if (!test_bit(PARAM_DRC_CONTROL, p_index)) {
+	if (!test_bit(PARAM_DRC_CONTROL, p_index))
 		fimc_is_set_param_bit(is, PARAM_DRC_CONTROL);
-		fimc_is_inc_param_num(is);
-	}
 }
 
 void __is_set_fd_control(struct fimc_is *is, u32 val)
@@ -512,10 +504,8 @@ void __is_set_fd_control(struct fimc_is *is, u32 val)
 
 	fd->control.cmd = val;
 
-	if (!test_bit((PARAM_FD_CONFIG - 32), p_index)) {
+	if (!test_bit((PARAM_FD_CONFIG - 32), p_index))
 		fimc_is_set_param_bit(is, PARAM_FD_CONTROL);
-		fimc_is_inc_param_num(is);
-	}
 }
 
 void __is_set_fd_config_maxface(struct fimc_is *is, u32 val)
@@ -533,7 +523,6 @@ void __is_set_fd_config_maxface(struct fimc_is *is, u32 val)
 		fd->config.cmd = FD_CONFIG_COMMAND_MAXIMUM_NUMBER;
 		fd->config.err = ERROR_FD_NONE;
 		fimc_is_set_param_bit(is, PARAM_FD_CONFIG);
-		fimc_is_inc_param_num(is);
 	} else {
 		fd->config.cmd |= FD_CONFIG_COMMAND_MAXIMUM_NUMBER;
 	}
@@ -554,7 +543,6 @@ void __is_set_fd_config_rollangle(struct fimc_is *is, u32 val)
 		fd->config.cmd = FD_CONFIG_COMMAND_ROLL_ANGLE;
 		fd->config.err = ERROR_FD_NONE;
 		fimc_is_set_param_bit(is, PARAM_FD_CONFIG);
-		fimc_is_inc_param_num(is);
 	} else {
 		fd->config.cmd |= FD_CONFIG_COMMAND_ROLL_ANGLE;
 	}
@@ -575,7 +563,6 @@ void __is_set_fd_config_yawangle(struct fimc_is *is, u32 val)
 		fd->config.cmd = FD_CONFIG_COMMAND_YAW_ANGLE;
 		fd->config.err = ERROR_FD_NONE;
 		fimc_is_set_param_bit(is, PARAM_FD_CONFIG);
-		fimc_is_inc_param_num(is);
 	} else {
 		fd->config.cmd |= FD_CONFIG_COMMAND_YAW_ANGLE;
 	}
@@ -596,7 +583,6 @@ void __is_set_fd_config_smilemode(struct fimc_is *is, u32 val)
 		fd->config.cmd = FD_CONFIG_COMMAND_SMILE_MODE;
 		fd->config.err = ERROR_FD_NONE;
 		fimc_is_set_param_bit(is, PARAM_FD_CONFIG);
-		fimc_is_inc_param_num(is);
 	} else {
 		fd->config.cmd |= FD_CONFIG_COMMAND_SMILE_MODE;
 	}
@@ -617,7 +603,6 @@ void __is_set_fd_config_blinkmode(struct fimc_is *is, u32 val)
 		fd->config.cmd = FD_CONFIG_COMMAND_BLINK_MODE;
 		fd->config.err = ERROR_FD_NONE;
 		fimc_is_set_param_bit(is, PARAM_FD_CONFIG);
-		fimc_is_inc_param_num(is);
 	} else {
 		fd->config.cmd |= FD_CONFIG_COMMAND_BLINK_MODE;
 	}
@@ -638,7 +623,6 @@ void __is_set_fd_config_eyedetect(struct fimc_is *is, u32 val)
 		fd->config.cmd = FD_CONFIG_COMMAND_EYES_DETECT;
 		fd->config.err = ERROR_FD_NONE;
 		fimc_is_set_param_bit(is, PARAM_FD_CONFIG);
-		fimc_is_inc_param_num(is);
 	} else {
 		fd->config.cmd |= FD_CONFIG_COMMAND_EYES_DETECT;
 	}
@@ -659,7 +643,6 @@ void __is_set_fd_config_mouthdetect(struct fimc_is *is, u32 val)
 		fd->config.cmd = FD_CONFIG_COMMAND_MOUTH_DETECT;
 		fd->config.err = ERROR_FD_NONE;
 		fimc_is_set_param_bit(is, PARAM_FD_CONFIG);
-		fimc_is_inc_param_num(is);
 	} else {
 		fd->config.cmd |= FD_CONFIG_COMMAND_MOUTH_DETECT;
 	}
@@ -680,7 +663,6 @@ void __is_set_fd_config_orientation(struct fimc_is *is, u32 val)
 		fd->config.cmd = FD_CONFIG_COMMAND_ORIENTATION;
 		fd->config.err = ERROR_FD_NONE;
 		fimc_is_set_param_bit(is, PARAM_FD_CONFIG);
-		fimc_is_inc_param_num(is);
 	} else {
 		fd->config.cmd |= FD_CONFIG_COMMAND_ORIENTATION;
 	}
@@ -701,7 +683,6 @@ void __is_set_fd_config_orientation_val(struct fimc_is *is, u32 val)
 		fd->config.cmd = FD_CONFIG_COMMAND_ORIENTATION_VALUE;
 		fd->config.err = ERROR_FD_NONE;
 		fimc_is_set_param_bit(is, PARAM_FD_CONFIG);
-		fimc_is_inc_param_num(is);
 	} else {
 		fd->config.cmd |= FD_CONFIG_COMMAND_ORIENTATION_VALUE;
 	}
@@ -729,21 +710,18 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 	/* Global */
 	global->shotmode.cmd = 1;
 	fimc_is_set_param_bit(is, PARAM_GLOBAL_SHOTMODE);
-	fimc_is_inc_param_num(is);
 
 	/* ISP */
 	isp->control.cmd = CONTROL_COMMAND_START;
 	isp->control.bypass = CONTROL_BYPASS_DISABLE;
 	isp->control.err = CONTROL_ERROR_NONE;
 	fimc_is_set_param_bit(is, PARAM_ISP_CONTROL);
-	fimc_is_inc_param_num(is);
 
 	isp->otf_input.cmd = OTF_INPUT_COMMAND_ENABLE;
 	if (!test_bit(PARAM_ISP_OTF_INPUT, p_index1)) {
 		isp->otf_input.width = DEFAULT_PREVIEW_STILL_WIDTH;
 		isp->otf_input.height = DEFAULT_PREVIEW_STILL_HEIGHT;
 		fimc_is_set_param_bit(is, PARAM_ISP_OTF_INPUT);
-		fimc_is_inc_param_num(is);
 	}
 	if (is->sensor->test_pattern)
 		isp->otf_input.format = OTF_INPUT_FORMAT_STRGEN_COLORBAR_BAYER;
@@ -766,7 +744,6 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 	isp->dma1_input.width = 0;
 	isp->dma1_input.err = DMA_INPUT_ERROR_NONE;
 	fimc_is_set_param_bit(is, PARAM_ISP_DMA1_INPUT);
-	fimc_is_inc_param_num(is);
 
 	isp->dma2_input.cmd = DMA_INPUT_COMMAND_DISABLE;
 	isp->dma2_input.width = 0;
@@ -779,12 +756,10 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 	isp->dma2_input.width = 0;
 	isp->dma2_input.err = DMA_INPUT_ERROR_NONE;
 	fimc_is_set_param_bit(is, PARAM_ISP_DMA2_INPUT);
-	fimc_is_inc_param_num(is);
 
 	isp->aa.cmd = ISP_AA_COMMAND_START;
 	isp->aa.target = ISP_AA_TARGET_AE | ISP_AA_TARGET_AWB;
 	fimc_is_set_param_bit(is, PARAM_ISP_AA);
-	fimc_is_inc_param_num(is);
 
 	if (!test_bit(PARAM_ISP_FLASH, p_index1))
 		__is_set_isp_flash(is, ISP_FLASH_COMMAND_DISABLE,
@@ -826,7 +801,6 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 		isp->otf_output.width = DEFAULT_PREVIEW_STILL_WIDTH;
 		isp->otf_output.height = DEFAULT_PREVIEW_STILL_HEIGHT;
 		fimc_is_set_param_bit(is, PARAM_ISP_OTF_OUTPUT);
-		fimc_is_inc_param_num(is);
 	}
 	isp->otf_output.format = OTF_OUTPUT_FORMAT_YUV444;
 	isp->otf_output.bitwidth = 12;
@@ -847,7 +821,6 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 		isp->dma1_output.dma_out_mask = 0;
 		isp->dma1_output.err = DMA_OUTPUT_ERROR_NONE;
 		fimc_is_set_param_bit(is, PARAM_ISP_DMA1_OUTPUT);
-		fimc_is_inc_param_num(is);
 	}
 
 	if (!test_bit(PARAM_ISP_DMA2_OUTPUT, p_index1)) {
@@ -864,7 +837,6 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 		isp->dma2_output.dma_out_mask = 0;
 		isp->dma2_output.err = DMA_OUTPUT_ERROR_NONE;
 		fimc_is_set_param_bit(is, PARAM_ISP_DMA2_OUTPUT);
-		fimc_is_inc_param_num(is);
 	}
 
 	/* Sensor */
@@ -882,7 +854,6 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 		drc->otf_input.width = DEFAULT_PREVIEW_STILL_WIDTH;
 		drc->otf_input.height = DEFAULT_PREVIEW_STILL_HEIGHT;
 		fimc_is_set_param_bit(is, PARAM_DRC_OTF_INPUT);
-		fimc_is_inc_param_num(is);
 	}
 	drc->otf_input.format = OTF_INPUT_FORMAT_YUV444;
 	drc->otf_input.bitwidth = 12;
@@ -900,14 +871,12 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 	drc->dma_input.width = 0;
 	drc->dma_input.err = DMA_INPUT_ERROR_NONE;
 	fimc_is_set_param_bit(is, PARAM_DRC_DMA_INPUT);
-	fimc_is_inc_param_num(is);
 
 	drc->otf_output.cmd = OTF_OUTPUT_COMMAND_ENABLE;
 	if (!test_bit(PARAM_DRC_OTF_OUTPUT, p_index1)) {
 		drc->otf_output.width = DEFAULT_PREVIEW_STILL_WIDTH;
 		drc->otf_output.height = DEFAULT_PREVIEW_STILL_HEIGHT;
 		fimc_is_set_param_bit(is, PARAM_DRC_OTF_OUTPUT);
-		fimc_is_inc_param_num(is);
 	}
 	drc->otf_output.format = OTF_OUTPUT_FORMAT_YUV444;
 	drc->otf_output.bitwidth = 8;
@@ -923,8 +892,8 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 		fd->otf_input.width = DEFAULT_PREVIEW_STILL_WIDTH;
 		fd->otf_input.height = DEFAULT_PREVIEW_STILL_HEIGHT;
 		fimc_is_set_param_bit(is, PARAM_FD_OTF_INPUT);
-		fimc_is_inc_param_num(is);
 	}
+
 	fd->otf_input.format = OTF_INPUT_FORMAT_YUV444;
 	fd->otf_input.bitwidth = 8;
 	fd->otf_input.order = 0;
@@ -941,7 +910,6 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 	fd->dma_input.width = 0;
 	fd->dma_input.err = DMA_INPUT_ERROR_NONE;
 	fimc_is_set_param_bit(is, PARAM_FD_DMA_INPUT);
-	fimc_is_inc_param_num(is);
 
 	__is_set_fd_config_maxface(is, 5);
 	__is_set_fd_config_rollangle(is, FD_CONFIG_ROLL_ANGLE_FULL);
diff --git a/drivers/media/platform/exynos4-is/fimc-is-param.h b/drivers/media/platform/exynos4-is/fimc-is-param.h
index 71464a5..f9358c2 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-param.h
+++ b/drivers/media/platform/exynos4-is/fimc-is-param.h
@@ -985,13 +985,11 @@ struct sensor_open_extended {
 	u32 i2c_sclk;
 };
 
-#define fimc_is_inc_param_num(is) \
-	atomic_inc(&(is)->cfg_param[(is)->scenario_id].p_region_num)
-
 struct fimc_is;
 
 int fimc_is_hw_get_sensor_max_framerate(struct fimc_is *is);
 void fimc_is_set_initial_params(struct fimc_is *is);
+unsigned int __get_pending_param_count(struct fimc_is *is);
 
 int  __is_hw_update_params(struct fimc_is *is);
 void __is_get_frame_size(struct fimc_is *is, struct v4l2_mbus_framefmt *mf);
diff --git a/drivers/media/platform/exynos4-is/fimc-is-regs.c b/drivers/media/platform/exynos4-is/fimc-is-regs.c
index efb9da0..f59a289 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-regs.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-regs.c
@@ -80,6 +80,7 @@ int fimc_is_hw_wait_intmsr0_intmsd0(struct fimc_is *is)
 int fimc_is_hw_set_param(struct fimc_is *is)
 {
 	struct is_config_param *cfg = &is->cfg_param[is->scenario_id];
+	unsigned int param_count = __get_pending_param_count(is);
 
 	fimc_is_hw_wait_intmsr0_intmsd0(is);
 
@@ -87,7 +88,7 @@ int fimc_is_hw_set_param(struct fimc_is *is)
 	mcuctl_write(is->sensor_index, is, MCUCTL_REG_ISSR(1));
 	mcuctl_write(is->scenario_id, is, MCUCTL_REG_ISSR(2));
 
-	mcuctl_write(atomic_read(&cfg->p_region_num), is, MCUCTL_REG_ISSR(3));
+	mcuctl_write(param_count, is, MCUCTL_REG_ISSR(3));
 	mcuctl_write(cfg->p_region_index1, is, MCUCTL_REG_ISSR(4));
 	mcuctl_write(cfg->p_region_index2, is, MCUCTL_REG_ISSR(5));
 
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index c5e4c53..10ec173 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -532,7 +532,6 @@ static void fimc_is_general_irq_handler(struct fimc_is *is)
 		case HIC_SET_PARAMETER:
 			is->cfg_param[is->scenario_id].p_region_index1 = 0;
 			is->cfg_param[is->scenario_id].p_region_index2 = 0;
-			atomic_set(&is->cfg_param[is->scenario_id].p_region_num, 0);
 			set_bit(IS_ST_BLOCK_CMD_CLEARED, &is->state);
 			pr_debug("HIC_SET_PARAMETER\n");
 			break;
@@ -593,7 +592,6 @@ static void fimc_is_general_irq_handler(struct fimc_is *is)
 		case HIC_SET_PARAMETER:
 			is->cfg_param[is->scenario_id].p_region_index1 = 0;
 			is->cfg_param[is->scenario_id].p_region_index2 = 0;
-			atomic_set(&is->cfg_param[is->scenario_id].p_region_num, 0);
 			set_bit(IS_ST_BLOCK_CMD_CLEARED, &is->state);
 			break;
 		}
diff --git a/drivers/media/platform/exynos4-is/fimc-is.h b/drivers/media/platform/exynos4-is/fimc-is.h
index 936e2ca..9406894 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.h
+++ b/drivers/media/platform/exynos4-is/fimc-is.h
@@ -226,7 +226,6 @@ struct is_config_param {
 	struct drc_param	drc;
 	struct fd_param		fd;
 
-	atomic_t		p_region_num;
 	unsigned long		p_region_index1;
 	unsigned long		p_region_index2;
 };
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c
index 59502b1..b11c001 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp.c
@@ -229,8 +229,11 @@ static int fimc_isp_subdev_s_stream(struct v4l2_subdev *sd, int on)
 	fimc_is_mem_barrier();
 
 	if (on) {
-		if (atomic_read(&is->cfg_param[is->scenario_id].p_region_num))
+		if (__get_pending_param_count(is)) {
 			ret = fimc_is_itf_s_param(is, true);
+			if (ret < 0)
+				return ret;
+		}
 
 		v4l2_dbg(1, debug, sd, "changing mode to %d\n",
 						is->scenario_id);
@@ -414,7 +417,6 @@ static int __ctrl_set_aewb_lock(struct fimc_is *is,
 	isp->aa.cmd = cmd;
 	isp->aa.target = ISP_AA_TARGET_AE;
 	fimc_is_set_param_bit(is, PARAM_ISP_AA);
-	fimc_is_inc_param_num(is);
 	is->af.ae_lock_state = ae_lock;
 	wmb();
 
@@ -426,7 +428,6 @@ static int __ctrl_set_aewb_lock(struct fimc_is *is,
 	isp->aa.cmd = cmd;
 	isp->aa.target = ISP_AA_TARGET_AE;
 	fimc_is_set_param_bit(is, PARAM_ISP_AA);
-	fimc_is_inc_param_num(is);
 	is->af.awb_lock_state = awb_lock;
 	wmb();
 
-- 
1.7.9.5

