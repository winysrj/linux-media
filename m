Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:11460 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3EaQrt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 12:47:49 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNO0025G9BOB9O0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 01 Jun 2013 01:47:48 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hj210.choi@samsung.com, yhwan.joo@samsung.com, arun.kk@samsung.com,
	shaik.ameer@samsung.com, kyungmin.park@samsung.com,
	Phil Carmody <phil.carmody@partner.samsung.com>
Subject: [REVIEW PATCH 2/7] exynos4-is: Simplify bitmask usage
Date: Fri, 31 May 2013 18:47:00 +0200
Message-id: <1370018825-13088-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1370018825-13088-1-git-send-email-s.nawrocki@samsung.com>
References: <1370018825-13088-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Phil Carmody <phil.carmody@partner.samsung.com>

Merge the two sets of flags into one array to simplify accessing
arbitrary bits from them.

Signed-off-by: Phil Carmody <phil.carmody@partner.samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is-param.c |   80 ++++++++++-----------
 drivers/media/platform/exynos4-is/fimc-is-regs.c  |    4 +-
 drivers/media/platform/exynos4-is/fimc-is.c       |    8 +--
 drivers/media/platform/exynos4-is/fimc-is.h       |    8 +--
 drivers/media/platform/exynos4-is/fimc-isp.c      |    4 +-
 5 files changed, 49 insertions(+), 55 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is-param.c b/drivers/media/platform/exynos4-is/fimc-is-param.c
index 53fe2a2..17a637e 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-param.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-param.c
@@ -168,8 +168,8 @@ unsigned int __get_pending_param_count(struct fimc_is *is)
 	unsigned int count;
 
 	spin_lock_irqsave(&is->slock, flags);
-	count = hweight32(config->p_region_index1);
-	count += hweight32(config->p_region_index2);
+	count = hweight32(config->p_region_index[0]);
+	count += hweight32(config->p_region_index[1]);
 	spin_unlock_irqrestore(&is->slock, flags);
 
 	return count;
@@ -177,31 +177,30 @@ unsigned int __get_pending_param_count(struct fimc_is *is)
 
 int __is_hw_update_params(struct fimc_is *is)
 {
-	unsigned long *p_index1, *p_index2;
+	unsigned long *p_index;
 	int i, id, ret = 0;
 
 	id = is->config_index;
-	p_index1 = &is->config[id].p_region_index1;
-	p_index2 = &is->config[id].p_region_index2;
+	p_index = &is->config[id].p_region_index[0];
 
-	if (test_bit(PARAM_GLOBAL_SHOTMODE, p_index1))
+	if (test_bit(PARAM_GLOBAL_SHOTMODE, p_index))
 		__fimc_is_hw_update_param_global_shotmode(is);
 
-	if (test_bit(PARAM_SENSOR_FRAME_RATE, p_index1))
+	if (test_bit(PARAM_SENSOR_FRAME_RATE, p_index))
 		__fimc_is_hw_update_param_sensor_framerate(is);
 
 	for (i = PARAM_ISP_CONTROL; i < PARAM_DRC_CONTROL; i++) {
-		if (test_bit(i, p_index1))
+		if (test_bit(i, p_index))
 			ret = __fimc_is_hw_update_param(is, i);
 	}
 
 	for (i = PARAM_DRC_CONTROL; i < PARAM_SCALERC_CONTROL; i++) {
-		if (test_bit(i, p_index1))
+		if (test_bit(i, p_index))
 			ret = __fimc_is_hw_update_param(is, i);
 	}
 
 	for (i = PARAM_FD_CONTROL; i <= PARAM_FD_CONFIG; i++) {
-		if (test_bit((i - 32), p_index2))
+		if (test_bit(i, p_index))
 			ret = __fimc_is_hw_update_param(is, i);
 	}
 
@@ -243,7 +242,7 @@ void __is_set_frame_size(struct fimc_is *is, struct v4l2_mbus_framefmt *mf)
 	fd->otf_input.height = mf->height;
 
 	if (test_bit(PARAM_ISP_OTF_INPUT,
-		      &is->config[index].p_region_index1))
+		      &is->config[index].p_region_index[0]))
 		return;
 
 	/* Update field */
@@ -368,7 +367,7 @@ void __is_set_isp_adjust(struct fimc_is *is, u32 cmd, u32 val)
 	unsigned long *p_index;
 	struct isp_param *isp;
 
-	p_index = &is->config[index].p_region_index1;
+	p_index = &is->config[index].p_region_index[0];
 	isp = &is->config[index].isp;
 
 	switch (cmd) {
@@ -415,7 +414,7 @@ void __is_set_isp_metering(struct fimc_is *is, u32 id, u32 val)
 	struct isp_param *isp;
 	unsigned long *p_index;
 
-	p_index = &is->config[index].p_region_index1;
+	p_index = &is->config[index].p_region_index[0];
 	isp = &is->config[index].isp;
 
 	switch (id) {
@@ -476,7 +475,7 @@ void __is_set_fd_control(struct fimc_is *is, u32 val)
 	struct fd_param *fd;
 	unsigned long *p_index;
 
-	p_index = &is->config[index].p_region_index2;
+	p_index = &is->config[index].p_region_index[1];
 	fd = &is->config[index].fd;
 
 	fd->control.cmd = val;
@@ -491,7 +490,7 @@ void __is_set_fd_config_maxface(struct fimc_is *is, u32 val)
 	struct fd_param *fd;
 	unsigned long *p_index;
 
-	p_index = &is->config[index].p_region_index2;
+	p_index = &is->config[index].p_region_index[1];
 	fd = &is->config[index].fd;
 
 	fd->config.max_number = val;
@@ -511,7 +510,7 @@ void __is_set_fd_config_rollangle(struct fimc_is *is, u32 val)
 	struct fd_param *fd;
 	unsigned long *p_index;
 
-	p_index = &is->config[index].p_region_index2;
+	p_index = &is->config[index].p_region_index[1];
 	fd = &is->config[index].fd;
 
 	fd->config.roll_angle = val;
@@ -531,7 +530,7 @@ void __is_set_fd_config_yawangle(struct fimc_is *is, u32 val)
 	struct fd_param *fd;
 	unsigned long *p_index;
 
-	p_index = &is->config[index].p_region_index2;
+	p_index = &is->config[index].p_region_index[1];
 	fd = &is->config[index].fd;
 
 	fd->config.yaw_angle = val;
@@ -551,7 +550,7 @@ void __is_set_fd_config_smilemode(struct fimc_is *is, u32 val)
 	struct fd_param *fd;
 	unsigned long *p_index;
 
-	p_index = &is->config[index].p_region_index2;
+	p_index = &is->config[index].p_region_index[1];
 	fd = &is->config[index].fd;
 
 	fd->config.smile_mode = val;
@@ -571,7 +570,7 @@ void __is_set_fd_config_blinkmode(struct fimc_is *is, u32 val)
 	struct fd_param *fd;
 	unsigned long *p_index;
 
-	p_index = &is->config[index].p_region_index2;
+	p_index = &is->config[index].p_region_index[1];
 	fd = &is->config[index].fd;
 
 	fd->config.blink_mode = val;
@@ -591,7 +590,7 @@ void __is_set_fd_config_eyedetect(struct fimc_is *is, u32 val)
 	struct fd_param *fd;
 	unsigned long *p_index;
 
-	p_index = &is->config[index].p_region_index2;
+	p_index = &is->config[index].p_region_index[1];
 	fd = &is->config[index].fd;
 
 	fd->config.eye_detect = val;
@@ -611,7 +610,7 @@ void __is_set_fd_config_mouthdetect(struct fimc_is *is, u32 val)
 	struct fd_param *fd;
 	unsigned long *p_index;
 
-	p_index = &is->config[index].p_region_index2;
+	p_index = &is->config[index].p_region_index[1];
 	fd = &is->config[index].fd;
 
 	fd->config.mouth_detect = val;
@@ -631,7 +630,7 @@ void __is_set_fd_config_orientation(struct fimc_is *is, u32 val)
 	struct fd_param *fd;
 	unsigned long *p_index;
 
-	p_index = &is->config[index].p_region_index2;
+	p_index = &is->config[index].p_region_index[1];
 	fd = &is->config[index].fd;
 
 	fd->config.orientation = val;
@@ -651,7 +650,7 @@ void __is_set_fd_config_orientation_val(struct fimc_is *is, u32 val)
 	struct fd_param *fd;
 	unsigned long *p_index;
 
-	p_index = &is->config[index].p_region_index2;
+	p_index = &is->config[index].p_region_index[1];
 	fd = &is->config[index].fd;
 
 	fd->config.orientation_value = val;
@@ -672,7 +671,7 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 	struct isp_param *isp;
 	struct drc_param *drc;
 	struct fd_param *fd;
-	unsigned long *p_index1, *p_index2;
+	unsigned long *p_index;
 	unsigned int index;
 
 	index = is->config_index;
@@ -681,8 +680,7 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 	isp = &is->config[index].isp;
 	drc = &is->config[index].drc;
 	fd = &is->config[index].fd;
-	p_index1 = &is->config[index].p_region_index1;
-	p_index2 = &is->config[index].p_region_index2;
+	p_index = &is->config[index].p_region_index[0];
 
 	/* Global */
 	global->shotmode.cmd = 1;
@@ -695,7 +693,7 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 	fimc_is_set_param_bit(is, PARAM_ISP_CONTROL);
 
 	isp->otf_input.cmd = OTF_INPUT_COMMAND_ENABLE;
-	if (!test_bit(PARAM_ISP_OTF_INPUT, p_index1)) {
+	if (!test_bit(PARAM_ISP_OTF_INPUT, p_index)) {
 		isp->otf_input.width = DEFAULT_PREVIEW_STILL_WIDTH;
 		isp->otf_input.height = DEFAULT_PREVIEW_STILL_HEIGHT;
 		fimc_is_set_param_bit(is, PARAM_ISP_OTF_INPUT);
@@ -738,20 +736,20 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 	isp->aa.target = ISP_AA_TARGET_AE | ISP_AA_TARGET_AWB;
 	fimc_is_set_param_bit(is, PARAM_ISP_AA);
 
-	if (!test_bit(PARAM_ISP_FLASH, p_index1))
+	if (!test_bit(PARAM_ISP_FLASH, p_index))
 		__is_set_isp_flash(is, ISP_FLASH_COMMAND_DISABLE,
 						ISP_FLASH_REDEYE_DISABLE);
 
-	if (!test_bit(PARAM_ISP_AWB, p_index1))
+	if (!test_bit(PARAM_ISP_AWB, p_index))
 		__is_set_isp_awb(is, ISP_AWB_COMMAND_AUTO, 0);
 
-	if (!test_bit(PARAM_ISP_IMAGE_EFFECT, p_index1))
+	if (!test_bit(PARAM_ISP_IMAGE_EFFECT, p_index))
 		__is_set_isp_effect(is, ISP_IMAGE_EFFECT_DISABLE);
 
-	if (!test_bit(PARAM_ISP_ISO, p_index1))
+	if (!test_bit(PARAM_ISP_ISO, p_index))
 		__is_set_isp_iso(is, ISP_ISO_COMMAND_AUTO, 0);
 
-	if (!test_bit(PARAM_ISP_ADJUST, p_index1)) {
+	if (!test_bit(PARAM_ISP_ADJUST, p_index)) {
 		__is_set_isp_adjust(is, ISP_ADJUST_COMMAND_MANUAL_CONTRAST, 0);
 		__is_set_isp_adjust(is,
 				ISP_ADJUST_COMMAND_MANUAL_SATURATION, 0);
@@ -762,7 +760,7 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 		__is_set_isp_adjust(is, ISP_ADJUST_COMMAND_MANUAL_HUE, 0);
 	}
 
-	if (!test_bit(PARAM_ISP_METERING, p_index1)) {
+	if (!test_bit(PARAM_ISP_METERING, p_index)) {
 		__is_set_isp_metering(is, 0, ISP_METERING_COMMAND_CENTER);
 		__is_set_isp_metering(is, 1, 0);
 		__is_set_isp_metering(is, 2, 0);
@@ -770,11 +768,11 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 		__is_set_isp_metering(is, 4, 0);
 	}
 
-	if (!test_bit(PARAM_ISP_AFC, p_index1))
+	if (!test_bit(PARAM_ISP_AFC, p_index))
 		__is_set_isp_afc(is, ISP_AFC_COMMAND_AUTO, 0);
 
 	isp->otf_output.cmd = OTF_OUTPUT_COMMAND_ENABLE;
-	if (!test_bit(PARAM_ISP_OTF_OUTPUT, p_index1)) {
+	if (!test_bit(PARAM_ISP_OTF_OUTPUT, p_index)) {
 		isp->otf_output.width = DEFAULT_PREVIEW_STILL_WIDTH;
 		isp->otf_output.height = DEFAULT_PREVIEW_STILL_HEIGHT;
 		fimc_is_set_param_bit(is, PARAM_ISP_OTF_OUTPUT);
@@ -784,7 +782,7 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 	isp->otf_output.order = 0;
 	isp->otf_output.err = OTF_OUTPUT_ERROR_NONE;
 
-	if (!test_bit(PARAM_ISP_DMA1_OUTPUT, p_index1)) {
+	if (!test_bit(PARAM_ISP_DMA1_OUTPUT, p_index)) {
 		isp->dma1_output.cmd = DMA_OUTPUT_COMMAND_DISABLE;
 		isp->dma1_output.width = 0;
 		isp->dma1_output.height = 0;
@@ -800,7 +798,7 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 		fimc_is_set_param_bit(is, PARAM_ISP_DMA1_OUTPUT);
 	}
 
-	if (!test_bit(PARAM_ISP_DMA2_OUTPUT, p_index1)) {
+	if (!test_bit(PARAM_ISP_DMA2_OUTPUT, p_index)) {
 		isp->dma2_output.cmd = DMA_OUTPUT_COMMAND_DISABLE;
 		isp->dma2_output.width = 0;
 		isp->dma2_output.height = 0;
@@ -817,7 +815,7 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 	}
 
 	/* Sensor */
-	if (!test_bit(PARAM_SENSOR_FRAME_RATE, p_index1)) {
+	if (!test_bit(PARAM_SENSOR_FRAME_RATE, p_index)) {
 		if (is->config_index == 0)
 			__is_set_sensor(is, 0);
 	}
@@ -827,7 +825,7 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 	__is_set_drc_control(is, CONTROL_BYPASS_ENABLE);
 
 	drc->otf_input.cmd = OTF_INPUT_COMMAND_ENABLE;
-	if (!test_bit(PARAM_DRC_OTF_INPUT, p_index1)) {
+	if (!test_bit(PARAM_DRC_OTF_INPUT, p_index)) {
 		drc->otf_input.width = DEFAULT_PREVIEW_STILL_WIDTH;
 		drc->otf_input.height = DEFAULT_PREVIEW_STILL_HEIGHT;
 		fimc_is_set_param_bit(is, PARAM_DRC_OTF_INPUT);
@@ -850,7 +848,7 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 	fimc_is_set_param_bit(is, PARAM_DRC_DMA_INPUT);
 
 	drc->otf_output.cmd = OTF_OUTPUT_COMMAND_ENABLE;
-	if (!test_bit(PARAM_DRC_OTF_OUTPUT, p_index1)) {
+	if (!test_bit(PARAM_DRC_OTF_OUTPUT, p_index)) {
 		drc->otf_output.width = DEFAULT_PREVIEW_STILL_WIDTH;
 		drc->otf_output.height = DEFAULT_PREVIEW_STILL_HEIGHT;
 		fimc_is_set_param_bit(is, PARAM_DRC_OTF_OUTPUT);
@@ -865,7 +863,7 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 	fd->control.bypass = CONTROL_BYPASS_DISABLE;
 
 	fd->otf_input.cmd = OTF_INPUT_COMMAND_ENABLE;
-	if (!test_bit((PARAM_FD_OTF_INPUT - 32), p_index2)) {
+	if (!test_bit(PARAM_FD_OTF_INPUT, p_index)) {
 		fd->otf_input.width = DEFAULT_PREVIEW_STILL_WIDTH;
 		fd->otf_input.height = DEFAULT_PREVIEW_STILL_HEIGHT;
 		fimc_is_set_param_bit(is, PARAM_FD_OTF_INPUT);
diff --git a/drivers/media/platform/exynos4-is/fimc-is-regs.c b/drivers/media/platform/exynos4-is/fimc-is-regs.c
index b0ff67b..11b7b0a 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-regs.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-regs.c
@@ -89,8 +89,8 @@ int fimc_is_hw_set_param(struct fimc_is *is)
 	mcuctl_write(is->config_index, is, MCUCTL_REG_ISSR(2));
 
 	mcuctl_write(param_count, is, MCUCTL_REG_ISSR(3));
-	mcuctl_write(config->p_region_index1, is, MCUCTL_REG_ISSR(4));
-	mcuctl_write(config->p_region_index2, is, MCUCTL_REG_ISSR(5));
+	mcuctl_write(config->p_region_index[0], is, MCUCTL_REG_ISSR(4));
+	mcuctl_write(config->p_region_index[1], is, MCUCTL_REG_ISSR(5));
 
 	fimc_is_hw_set_intgr0_gd0(is);
 	return 0;
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 520e439..e0870e2 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -527,8 +527,8 @@ static void fimc_is_general_irq_handler(struct fimc_is *is)
 			break;
 
 		case HIC_SET_PARAMETER:
-			is->config[is->config_index].p_region_index1 = 0;
-			is->config[is->config_index].p_region_index2 = 0;
+			is->config[is->config_index].p_region_index[0] = 0;
+			is->config[is->config_index].p_region_index[1] = 0;
 			set_bit(IS_ST_BLOCK_CMD_CLEARED, &is->state);
 			pr_debug("HIC_SET_PARAMETER\n");
 			break;
@@ -587,8 +587,8 @@ static void fimc_is_general_irq_handler(struct fimc_is *is)
 
 		switch (is->i2h_cmd.args[0]) {
 		case HIC_SET_PARAMETER:
-			is->config[is->config_index].p_region_index1 = 0;
-			is->config[is->config_index].p_region_index2 = 0;
+			is->config[is->config_index].p_region_index[0] = 0;
+			is->config[is->config_index].p_region_index[1] = 0;
 			set_bit(IS_ST_BLOCK_CMD_CLEARED, &is->state);
 			break;
 		}
diff --git a/drivers/media/platform/exynos4-is/fimc-is.h b/drivers/media/platform/exynos4-is/fimc-is.h
index 606a7c9..4b0eccb 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.h
+++ b/drivers/media/platform/exynos4-is/fimc-is.h
@@ -225,8 +225,7 @@ struct chain_config {
 	struct drc_param	drc;
 	struct fd_param		fd;
 
-	unsigned long		p_region_index1;
-	unsigned long		p_region_index2;
+	unsigned long		p_region_index[2];
 };
 
 /**
@@ -303,10 +302,7 @@ static inline void fimc_is_set_param_bit(struct fimc_is *is, int num)
 {
 	struct chain_config *cfg = &is->config[is->config_index];
 
-	if (num >= 32)
-		set_bit(num - 32, &cfg->p_region_index2);
-	else
-		set_bit(num, &cfg->p_region_index1);
+	set_bit(num, &cfg->p_region_index[0]);
 }
 
 static inline void fimc_is_set_param_ctrl_cmd(struct fimc_is *is, int cmd)
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c
index 7ede30b..3a29e41 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp.c
@@ -317,8 +317,8 @@ static int fimc_isp_subdev_s_power(struct v4l2_subdev *sd, int on)
 		clear_bit(IS_ST_PWR_ON, &is->state);
 		clear_bit(IS_ST_INIT_DONE, &is->state);
 		is->state = 0;
-		is->config[is->config_index].p_region_index1 = 0;
-		is->config[is->config_index].p_region_index2 = 0;
+		is->config[is->config_index].p_region_index[0] = 0;
+		is->config[is->config_index].p_region_index[1] = 0;
 		set_bit(IS_ST_IDLE, &is->state);
 		wmb();
 	}
-- 
1.7.9.5

