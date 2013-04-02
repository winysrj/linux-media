Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:34776 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab3DBQGc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 12:06:32 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: yhwan.joo@samsung.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4 3/7] exynos4-is: Add FIMC-IS parameter region definitions
Date: Tue, 02 Apr 2013 18:03:35 +0200
Message-id: <1364918619-9118-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364918619-9118-1-git-send-email-s.nawrocki@samsung.com>
References: <1364918619-9118-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds ISP processing parameters interface files.

Signed-off-by: Younghwan Joo <yhwan.joo@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

Changes since v3:
 - dropped unused headers,
 - removed get_is_cfg() macro which was temporary only.
---
 drivers/media/platform/exynos4-is/fimc-is-param.c |  955 +++++++++++++++++++
 drivers/media/platform/exynos4-is/fimc-is-param.h | 1022 +++++++++++++++++++++
 2 files changed, 1977 insertions(+)
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-param.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-param.h

diff --git a/drivers/media/platform/exynos4-is/fimc-is-param.c b/drivers/media/platform/exynos4-is/fimc-is-param.c
new file mode 100644
index 0000000..37fd5fe
--- /dev/null
+++ b/drivers/media/platform/exynos4-is/fimc-is-param.c
@@ -0,0 +1,955 @@
+/*
+ * Samsung EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ *
+ * Authors: Younghwan Joo <yhwan.joo@samsung.com>
+ *          Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#define pr_fmt(fmt) "%s:%d " fmt, __func__, __LINE__
+
+#include <linux/bug.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+
+#include "fimc-is.h"
+#include "fimc-is-command.h"
+#include "fimc-is-errno.h"
+#include "fimc-is-param.h"
+#include "fimc-is-regs.h"
+#include "fimc-is-sensor.h"
+
+static void __hw_param_copy(void *dst, void *src)
+{
+	memcpy(dst, src, FIMC_IS_PARAM_MAX_SIZE);
+}
+
+void __fimc_is_hw_update_param_global_shotmode(struct fimc_is *is)
+{
+	struct param_global_shotmode *dst, *src;
+
+	dst = &is->is_p_region->parameter.global.shotmode;
+	src = &is->cfg_param[is->scenario_id].global.shotmode;
+	__hw_param_copy(dst, src);
+}
+
+void __fimc_is_hw_update_param_sensor_framerate(struct fimc_is *is)
+{
+	struct param_sensor_framerate *dst, *src;
+
+	dst = &is->is_p_region->parameter.sensor.frame_rate;
+	src = &is->cfg_param[is->scenario_id].sensor.frame_rate;
+	__hw_param_copy(dst, src);
+}
+
+int __fimc_is_hw_update_param(struct fimc_is *is, u32 offset)
+{
+	struct is_param_region *par = &is->is_p_region->parameter;
+	struct is_config_param *cfg = &is->cfg_param[is->scenario_id];
+
+	switch (offset) {
+	case PARAM_ISP_CONTROL:
+		__hw_param_copy(&par->isp.control, &cfg->isp.control);
+		break;
+
+	case PARAM_ISP_OTF_INPUT:
+		__hw_param_copy(&par->isp.otf_input, &cfg->isp.otf_input);
+		break;
+
+	case PARAM_ISP_DMA1_INPUT:
+		__hw_param_copy(&par->isp.dma1_input, &cfg->isp.dma1_input);
+		break;
+
+	case PARAM_ISP_DMA2_INPUT:
+		__hw_param_copy(&par->isp.dma2_input, &cfg->isp.dma2_input);
+		break;
+
+	case PARAM_ISP_AA:
+		__hw_param_copy(&par->isp.aa, &cfg->isp.aa);
+		break;
+
+	case PARAM_ISP_FLASH:
+		__hw_param_copy(&par->isp.flash, &cfg->isp.flash);
+		break;
+
+	case PARAM_ISP_AWB:
+		__hw_param_copy(&par->isp.awb, &cfg->isp.awb);
+		break;
+
+	case PARAM_ISP_IMAGE_EFFECT:
+		__hw_param_copy(&par->isp.effect, &cfg->isp.effect);
+		break;
+
+	case PARAM_ISP_ISO:
+		__hw_param_copy(&par->isp.iso, &cfg->isp.iso);
+		break;
+
+	case PARAM_ISP_ADJUST:
+		__hw_param_copy(&par->isp.adjust, &cfg->isp.adjust);
+		break;
+
+	case PARAM_ISP_METERING:
+		__hw_param_copy(&par->isp.metering, &cfg->isp.metering);
+		break;
+
+	case PARAM_ISP_AFC:
+		__hw_param_copy(&par->isp.afc, &cfg->isp.afc);
+		break;
+
+	case PARAM_ISP_OTF_OUTPUT:
+		__hw_param_copy(&par->isp.otf_output, &cfg->isp.otf_output);
+		break;
+
+	case PARAM_ISP_DMA1_OUTPUT:
+		__hw_param_copy(&par->isp.dma1_output, &cfg->isp.dma1_output);
+		break;
+
+	case PARAM_ISP_DMA2_OUTPUT:
+		__hw_param_copy(&par->isp.dma2_output, &cfg->isp.dma2_output);
+		break;
+
+	case PARAM_DRC_CONTROL:
+		__hw_param_copy(&par->drc.control, &cfg->drc.control);
+		break;
+
+	case PARAM_DRC_OTF_INPUT:
+		__hw_param_copy(&par->drc.otf_input, &cfg->drc.otf_input);
+		break;
+
+	case PARAM_DRC_DMA_INPUT:
+		__hw_param_copy(&par->drc.dma_input, &cfg->drc.dma_input);
+		break;
+
+	case PARAM_DRC_OTF_OUTPUT:
+		__hw_param_copy(&par->drc.otf_output, &cfg->drc.otf_output);
+		break;
+
+	case PARAM_FD_CONTROL:
+		__hw_param_copy(&par->fd.control, &cfg->fd.control);
+		break;
+
+	case PARAM_FD_OTF_INPUT:
+		__hw_param_copy(&par->fd.otf_input, &cfg->fd.otf_input);
+		break;
+
+	case PARAM_FD_DMA_INPUT:
+		__hw_param_copy(&par->fd.dma_input, &cfg->fd.dma_input);
+		break;
+
+	case PARAM_FD_CONFIG:
+		__hw_param_copy(&par->fd.config, &cfg->fd.config);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int __is_hw_update_params(struct fimc_is *is)
+{
+	unsigned long *p_index1, *p_index2;
+	int i, id, ret = 0;
+
+	id = is->scenario_id;
+	p_index1 = &is->cfg_param[id].p_region_index1;
+	p_index2 = &is->cfg_param[id].p_region_index2;
+
+	if (test_bit(PARAM_GLOBAL_SHOTMODE, p_index1))
+		__fimc_is_hw_update_param_global_shotmode(is);
+
+	if (test_bit(PARAM_SENSOR_FRAME_RATE, p_index1))
+		__fimc_is_hw_update_param_sensor_framerate(is);
+
+	for (i = PARAM_ISP_CONTROL; i < PARAM_DRC_CONTROL; i++) {
+		if (test_bit(i, p_index1))
+			ret = __fimc_is_hw_update_param(is, i);
+	}
+
+	for (i = PARAM_DRC_CONTROL; i < PARAM_SCALERC_CONTROL; i++) {
+		if (test_bit(i, p_index1))
+			ret = __fimc_is_hw_update_param(is, i);
+	}
+
+	for (i = PARAM_FD_CONTROL; i <= PARAM_FD_CONFIG; i++) {
+		if (test_bit((i - 32), p_index2))
+			ret = __fimc_is_hw_update_param(is, i);
+	}
+
+	return ret;
+}
+
+void __is_get_frame_size(struct fimc_is *is, struct v4l2_mbus_framefmt *mf)
+{
+	struct isp_param *isp;
+
+	isp = &is->cfg_param[is->scenario_id].isp;
+	mf->width = isp->otf_input.width;
+	mf->height = isp->otf_input.height;
+}
+
+void __is_set_frame_size(struct fimc_is *is, struct v4l2_mbus_framefmt *mf)
+{
+	struct isp_param *isp;
+	struct drc_param *drc;
+	struct fd_param *fd;
+	unsigned int mode;
+
+	mode = is->scenario_id;
+	isp = &is->cfg_param[mode].isp;
+	drc = &is->cfg_param[mode].drc;
+	fd = &is->cfg_param[mode].fd;
+
+	/* Update isp size info (OTF only) */
+	isp->otf_input.width = mf->width;
+	isp->otf_input.height = mf->height;
+	isp->otf_output.width = mf->width;
+	isp->otf_output.height = mf->height;
+	/* Update drc size info (OTF only) */
+	drc->otf_input.width = mf->width;
+	drc->otf_input.height = mf->height;
+	drc->otf_output.width = mf->width;
+	drc->otf_output.height = mf->height;
+	/* Update fd size info (OTF only) */
+	fd->otf_input.width = mf->width;
+	fd->otf_input.height = mf->height;
+
+	if (test_bit(PARAM_ISP_OTF_INPUT,
+		      &is->cfg_param[mode].p_region_index1))
+		return;
+
+	/* Update field */
+	fimc_is_set_param_bit(is, PARAM_ISP_OTF_INPUT);
+	fimc_is_inc_param_num(is);
+	fimc_is_set_param_bit(is, PARAM_ISP_OTF_OUTPUT);
+	fimc_is_inc_param_num(is);
+	fimc_is_set_param_bit(is, PARAM_DRC_OTF_INPUT);
+	fimc_is_inc_param_num(is);
+	fimc_is_set_param_bit(is, PARAM_DRC_OTF_OUTPUT);
+	fimc_is_inc_param_num(is);
+	fimc_is_set_param_bit(is, PARAM_FD_OTF_INPUT);
+	fimc_is_inc_param_num(is);
+}
+
+int fimc_is_hw_get_sensor_max_framerate(struct fimc_is *is)
+{
+	switch (is->sensor->drvdata->id) {
+	case FIMC_IS_SENSOR_ID_S5K6A3:
+		return 30;
+	default:
+		return 15;
+	}
+}
+
+void __is_set_sensor(struct fimc_is *is, int fps)
+{
+	struct sensor_param *sensor;
+	struct isp_param *isp;
+	unsigned long *p_index, mode;
+
+	mode = is->scenario_id;
+	p_index = &is->cfg_param[mode].p_region_index1;
+	sensor = &is->cfg_param[mode].sensor;
+	isp = &is->cfg_param[mode].isp;
+
+	if (fps == 0) {
+		sensor->frame_rate.frame_rate =
+				fimc_is_hw_get_sensor_max_framerate(is);
+		isp->otf_input.frametime_min = 0;
+		isp->otf_input.frametime_max = 66666;
+	} else {
+		sensor->frame_rate.frame_rate = fps;
+		isp->otf_input.frametime_min = 0;
+		isp->otf_input.frametime_max = (u32)1000000 / fps;
+	}
+
+	if (!test_bit(PARAM_SENSOR_FRAME_RATE, p_index)) {
+		fimc_is_set_param_bit(is, PARAM_SENSOR_FRAME_RATE);
+		fimc_is_inc_param_num(is);
+	}
+	if (!test_bit(PARAM_ISP_OTF_INPUT, p_index)) {
+		fimc_is_set_param_bit(is, PARAM_ISP_OTF_INPUT);
+		fimc_is_inc_param_num(is);
+	}
+}
+
+void __is_set_init_isp_aa(struct fimc_is *is)
+{
+	struct isp_param *isp;
+
+	isp = &is->cfg_param[is->scenario_id].isp;
+
+	isp->aa.cmd = ISP_AA_COMMAND_START;
+	isp->aa.target = ISP_AA_TARGET_AF | ISP_AA_TARGET_AE |
+			 ISP_AA_TARGET_AWB;
+	isp->aa.mode = 0;
+	isp->aa.scene = 0;
+	isp->aa.sleep = 0;
+	isp->aa.face = 0;
+	isp->aa.touch_x = 0;
+	isp->aa.touch_y = 0;
+	isp->aa.manual_af_setting = 0;
+	isp->aa.err = ISP_AF_ERROR_NONE;
+
+	fimc_is_set_param_bit(is, PARAM_ISP_AA);
+	fimc_is_inc_param_num(is);
+}
+
+void __is_set_isp_flash(struct fimc_is *is, u32 cmd, u32 redeye)
+{
+	unsigned int mode = is->scenario_id;
+	struct is_config_param *cfg = &is->cfg_param[mode];
+	struct isp_param *isp = &cfg->isp;
+
+	isp->flash.cmd = cmd;
+	isp->flash.redeye = redeye;
+	isp->flash.err = ISP_FLASH_ERROR_NONE;
+
+	if (!test_bit(PARAM_ISP_FLASH, &cfg->p_region_index1)) {
+		fimc_is_set_param_bit(is, PARAM_ISP_FLASH);
+		fimc_is_inc_param_num(is);
+	}
+}
+
+void __is_set_isp_awb(struct fimc_is *is, u32 cmd, u32 val)
+{
+	unsigned int mode = is->scenario_id;
+	struct isp_param *isp;
+	unsigned long *p_index;
+
+	p_index = &is->cfg_param[mode].p_region_index1;
+	isp = &is->cfg_param[mode].isp;
+
+	isp->awb.cmd = cmd;
+	isp->awb.illumination = val;
+	isp->awb.err = ISP_AWB_ERROR_NONE;
+
+	if (!test_bit(PARAM_ISP_AWB, p_index)) {
+		fimc_is_set_param_bit(is, PARAM_ISP_AWB);
+		fimc_is_inc_param_num(is);
+	}
+}
+
+void __is_set_isp_effect(struct fimc_is *is, u32 cmd)
+{
+	unsigned int mode = is->scenario_id;
+	struct isp_param *isp;
+	unsigned long *p_index;
+
+	p_index = &is->cfg_param[mode].p_region_index1;
+	isp = &is->cfg_param[mode].isp;
+
+	isp->effect.cmd = cmd;
+	isp->effect.err = ISP_IMAGE_EFFECT_ERROR_NONE;
+
+	if (!test_bit(PARAM_ISP_IMAGE_EFFECT, p_index)) {
+		fimc_is_set_param_bit(is, PARAM_ISP_IMAGE_EFFECT);
+		fimc_is_inc_param_num(is);
+	}
+}
+
+void __is_set_isp_iso(struct fimc_is *is, u32 cmd, u32 val)
+{
+	unsigned int mode = is->scenario_id;
+	struct isp_param *isp;
+	unsigned long *p_index;
+
+	p_index = &is->cfg_param[mode].p_region_index1;
+	isp = &is->cfg_param[mode].isp;
+
+	isp->iso.cmd = cmd;
+	isp->iso.value = val;
+	isp->iso.err = ISP_ISO_ERROR_NONE;
+
+	if (!test_bit(PARAM_ISP_ISO, p_index)) {
+		fimc_is_set_param_bit(is, PARAM_ISP_ISO);
+		fimc_is_inc_param_num(is);
+	}
+}
+
+void __is_set_isp_adjust(struct fimc_is *is, u32 cmd, u32 val)
+{
+	unsigned int mode = is->scenario_id;
+	unsigned long *p_index;
+	struct isp_param *isp;
+
+	p_index = &is->cfg_param[mode].p_region_index1;
+	isp = &is->cfg_param[mode].isp;
+
+	switch (cmd) {
+	case ISP_ADJUST_COMMAND_MANUAL_CONTRAST:
+		isp->adjust.contrast = val;
+		break;
+	case ISP_ADJUST_COMMAND_MANUAL_SATURATION:
+		isp->adjust.saturation = val;
+		break;
+	case ISP_ADJUST_COMMAND_MANUAL_SHARPNESS:
+		isp->adjust.sharpness = val;
+		break;
+	case ISP_ADJUST_COMMAND_MANUAL_EXPOSURE:
+		isp->adjust.exposure = val;
+		break;
+	case ISP_ADJUST_COMMAND_MANUAL_BRIGHTNESS:
+		isp->adjust.brightness = val;
+		break;
+	case ISP_ADJUST_COMMAND_MANUAL_HUE:
+		isp->adjust.hue = val;
+		break;
+	case ISP_ADJUST_COMMAND_AUTO:
+		isp->adjust.contrast = 0;
+		isp->adjust.saturation = 0;
+		isp->adjust.sharpness = 0;
+		isp->adjust.exposure = 0;
+		isp->adjust.brightness = 0;
+		isp->adjust.hue = 0;
+		break;
+	}
+
+	if (!test_bit(PARAM_ISP_ADJUST, p_index)) {
+		isp->adjust.cmd = cmd;
+		isp->adjust.err = ISP_ADJUST_ERROR_NONE;
+		fimc_is_set_param_bit(is, PARAM_ISP_ADJUST);
+		fimc_is_inc_param_num(is);
+	} else {
+		isp->adjust.cmd |= cmd;
+	}
+}
+
+void __is_set_isp_metering(struct fimc_is *is, u32 id, u32 val)
+{
+	struct isp_param *isp;
+	unsigned long *p_index, mode;
+
+	mode = is->scenario_id;
+	p_index = &is->cfg_param[mode].p_region_index1;
+	isp = &is->cfg_param[mode].isp;
+
+	switch (id) {
+	case IS_METERING_CONFIG_CMD:
+		isp->metering.cmd = val;
+		break;
+	case IS_METERING_CONFIG_WIN_POS_X:
+		isp->metering.win_pos_x = val;
+		break;
+	case IS_METERING_CONFIG_WIN_POS_Y:
+		isp->metering.win_pos_y = val;
+		break;
+	case IS_METERING_CONFIG_WIN_WIDTH:
+		isp->metering.win_width = val;
+		break;
+	case IS_METERING_CONFIG_WIN_HEIGHT:
+		isp->metering.win_height = val;
+		break;
+	default:
+		return;
+	}
+
+	if (!test_bit(PARAM_ISP_METERING, p_index)) {
+		isp->metering.err = ISP_METERING_ERROR_NONE;
+		fimc_is_set_param_bit(is, PARAM_ISP_METERING);
+		fimc_is_inc_param_num(is);
+	}
+}
+
+void __is_set_isp_afc(struct fimc_is *is, u32 cmd, u32 val)
+{
+	struct isp_param *isp;
+	unsigned long *p_index, mode;
+
+	mode = is->scenario_id;
+	p_index = &is->cfg_param[mode].p_region_index1;
+	isp = &is->cfg_param[mode].isp;
+
+	isp->afc.cmd = cmd;
+	isp->afc.manual = val;
+	isp->afc.err = ISP_AFC_ERROR_NONE;
+
+	if (!test_bit(PARAM_ISP_AFC, p_index)) {
+		fimc_is_set_param_bit(is, PARAM_ISP_AFC);
+		fimc_is_inc_param_num(is);
+	}
+}
+
+void __is_set_drc_control(struct fimc_is *is, u32 val)
+{
+	struct drc_param *drc;
+	unsigned long *p_index, mode;
+
+	mode = is->scenario_id;
+	p_index = &is->cfg_param[mode].p_region_index1;
+	drc = &is->cfg_param[mode].drc;
+
+	drc->control.bypass = val;
+
+	if (!test_bit(PARAM_DRC_CONTROL, p_index)) {
+		fimc_is_set_param_bit(is, PARAM_DRC_CONTROL);
+		fimc_is_inc_param_num(is);
+	}
+}
+
+void __is_set_fd_control(struct fimc_is *is, u32 val)
+{
+	struct fd_param *fd;
+	unsigned long *p_index, mode;
+
+	mode = is->scenario_id;
+	p_index = &is->cfg_param[mode].p_region_index2;
+	fd = &is->cfg_param[mode].fd;
+
+	fd->control.cmd = val;
+
+	if (!test_bit((PARAM_FD_CONFIG - 32), p_index)) {
+		fimc_is_set_param_bit(is, PARAM_FD_CONTROL);
+		fimc_is_inc_param_num(is);
+	}
+}
+
+void __is_set_fd_config_maxface(struct fimc_is *is, u32 val)
+{
+	struct fd_param *fd;
+	unsigned long *p_index, mode;
+
+	mode = is->scenario_id;
+	p_index = &is->cfg_param[mode].p_region_index2;
+	fd = &is->cfg_param[mode].fd;
+
+	fd->config.max_number = val;
+
+	if (!test_bit((PARAM_FD_CONFIG - 32), p_index)) {
+		fd->config.cmd = FD_CONFIG_COMMAND_MAXIMUM_NUMBER;
+		fd->config.err = ERROR_FD_NONE;
+		fimc_is_set_param_bit(is, PARAM_FD_CONFIG);
+		fimc_is_inc_param_num(is);
+	} else {
+		fd->config.cmd |= FD_CONFIG_COMMAND_MAXIMUM_NUMBER;
+	}
+}
+
+void __is_set_fd_config_rollangle(struct fimc_is *is, u32 val)
+{
+	struct fd_param *fd;
+	unsigned long *p_index, mode;
+
+	mode = is->scenario_id;
+	p_index = &is->cfg_param[mode].p_region_index2;
+	fd = &is->cfg_param[mode].fd;
+
+	fd->config.roll_angle = val;
+
+	if (!test_bit((PARAM_FD_CONFIG - 32), p_index)) {
+		fd->config.cmd = FD_CONFIG_COMMAND_ROLL_ANGLE;
+		fd->config.err = ERROR_FD_NONE;
+		fimc_is_set_param_bit(is, PARAM_FD_CONFIG);
+		fimc_is_inc_param_num(is);
+	} else {
+		fd->config.cmd |= FD_CONFIG_COMMAND_ROLL_ANGLE;
+	}
+}
+
+void __is_set_fd_config_yawangle(struct fimc_is *is, u32 val)
+{
+	struct fd_param *fd;
+	unsigned long *p_index, mode;
+
+	mode = is->scenario_id;
+	p_index = &is->cfg_param[mode].p_region_index2;
+	fd = &is->cfg_param[mode].fd;
+
+	fd->config.yaw_angle = val;
+
+	if (!test_bit((PARAM_FD_CONFIG - 32), p_index)) {
+		fd->config.cmd = FD_CONFIG_COMMAND_YAW_ANGLE;
+		fd->config.err = ERROR_FD_NONE;
+		fimc_is_set_param_bit(is, PARAM_FD_CONFIG);
+		fimc_is_inc_param_num(is);
+	} else {
+		fd->config.cmd |= FD_CONFIG_COMMAND_YAW_ANGLE;
+	}
+}
+
+void __is_set_fd_config_smilemode(struct fimc_is *is, u32 val)
+{
+	struct fd_param *fd;
+	unsigned long *p_index, mode;
+
+	mode = is->scenario_id;
+	p_index = &is->cfg_param[mode].p_region_index2;
+	fd = &is->cfg_param[mode].fd;
+
+	fd->config.smile_mode = val;
+
+	if (!test_bit((PARAM_FD_CONFIG - 32), p_index)) {
+		fd->config.cmd = FD_CONFIG_COMMAND_SMILE_MODE;
+		fd->config.err = ERROR_FD_NONE;
+		fimc_is_set_param_bit(is, PARAM_FD_CONFIG);
+		fimc_is_inc_param_num(is);
+	} else {
+		fd->config.cmd |= FD_CONFIG_COMMAND_SMILE_MODE;
+	}
+}
+
+void __is_set_fd_config_blinkmode(struct fimc_is *is, u32 val)
+{
+	struct fd_param *fd;
+	unsigned long *p_index, mode;
+
+	mode = is->scenario_id;
+	p_index = &is->cfg_param[mode].p_region_index2;
+	fd = &is->cfg_param[mode].fd;
+
+	fd->config.blink_mode = val;
+
+	if (!test_bit((PARAM_FD_CONFIG - 32), p_index)) {
+		fd->config.cmd = FD_CONFIG_COMMAND_BLINK_MODE;
+		fd->config.err = ERROR_FD_NONE;
+		fimc_is_set_param_bit(is, PARAM_FD_CONFIG);
+		fimc_is_inc_param_num(is);
+	} else {
+		fd->config.cmd |= FD_CONFIG_COMMAND_BLINK_MODE;
+	}
+}
+
+void __is_set_fd_config_eyedetect(struct fimc_is *is, u32 val)
+{
+	struct fd_param *fd;
+	unsigned long *p_index, mode;
+
+	mode = is->scenario_id;
+	p_index = &is->cfg_param[mode].p_region_index2;
+	fd = &is->cfg_param[mode].fd;
+
+	fd->config.eye_detect = val;
+
+	if (!test_bit((PARAM_FD_CONFIG - 32), p_index)) {
+		fd->config.cmd = FD_CONFIG_COMMAND_EYES_DETECT;
+		fd->config.err = ERROR_FD_NONE;
+		fimc_is_set_param_bit(is, PARAM_FD_CONFIG);
+		fimc_is_inc_param_num(is);
+	} else {
+		fd->config.cmd |= FD_CONFIG_COMMAND_EYES_DETECT;
+	}
+}
+
+void __is_set_fd_config_mouthdetect(struct fimc_is *is, u32 val)
+{
+	struct fd_param *fd;
+	unsigned long *p_index, mode;
+
+	mode = is->scenario_id;
+	p_index = &is->cfg_param[mode].p_region_index2;
+	fd = &is->cfg_param[mode].fd;
+
+	fd->config.mouth_detect = val;
+
+	if (!test_bit((PARAM_FD_CONFIG - 32), p_index)) {
+		fd->config.cmd = FD_CONFIG_COMMAND_MOUTH_DETECT;
+		fd->config.err = ERROR_FD_NONE;
+		fimc_is_set_param_bit(is, PARAM_FD_CONFIG);
+		fimc_is_inc_param_num(is);
+	} else {
+		fd->config.cmd |= FD_CONFIG_COMMAND_MOUTH_DETECT;
+	}
+}
+
+void __is_set_fd_config_orientation(struct fimc_is *is, u32 val)
+{
+	struct fd_param *fd;
+	unsigned long *p_index, mode;
+
+	mode = is->scenario_id;
+	p_index = &is->cfg_param[mode].p_region_index2;
+	fd = &is->cfg_param[mode].fd;
+
+	fd->config.orientation = val;
+
+	if (!test_bit((PARAM_FD_CONFIG - 32), p_index)) {
+		fd->config.cmd = FD_CONFIG_COMMAND_ORIENTATION;
+		fd->config.err = ERROR_FD_NONE;
+		fimc_is_set_param_bit(is, PARAM_FD_CONFIG);
+		fimc_is_inc_param_num(is);
+	} else {
+		fd->config.cmd |= FD_CONFIG_COMMAND_ORIENTATION;
+	}
+}
+
+void __is_set_fd_config_orientation_val(struct fimc_is *is, u32 val)
+{
+	struct fd_param *fd;
+	unsigned long *p_index, mode;
+
+	mode = is->scenario_id;
+	p_index = &is->cfg_param[mode].p_region_index2;
+	fd = &is->cfg_param[mode].fd;
+
+	fd->config.orientation_value = val;
+
+	if (!test_bit((PARAM_FD_CONFIG - 32), p_index)) {
+		fd->config.cmd = FD_CONFIG_COMMAND_ORIENTATION_VALUE;
+		fd->config.err = ERROR_FD_NONE;
+		fimc_is_set_param_bit(is, PARAM_FD_CONFIG);
+		fimc_is_inc_param_num(is);
+	} else {
+		fd->config.cmd |= FD_CONFIG_COMMAND_ORIENTATION_VALUE;
+	}
+}
+
+void fimc_is_set_initial_params(struct fimc_is *is)
+{
+	struct global_param *global;
+	struct sensor_param *sensor;
+	struct isp_param *isp;
+	struct drc_param *drc;
+	struct fd_param *fd;
+	unsigned long *p_index1, *p_index2;
+	unsigned int mode;
+
+	mode = is->scenario_id;
+	global = &is->cfg_param[mode].global;
+	sensor = &is->cfg_param[mode].sensor;
+	isp = &is->cfg_param[mode].isp;
+	drc = &is->cfg_param[mode].drc;
+	fd = &is->cfg_param[mode].fd;
+	p_index1 = &is->cfg_param[mode].p_region_index1;
+	p_index2 = &is->cfg_param[mode].p_region_index2;
+
+	/* Global */
+	global->shotmode.cmd = 1;
+	fimc_is_set_param_bit(is, PARAM_GLOBAL_SHOTMODE);
+	fimc_is_inc_param_num(is);
+
+	/* ISP */
+	isp->control.cmd = CONTROL_COMMAND_START;
+	isp->control.bypass = CONTROL_BYPASS_DISABLE;
+	isp->control.err = CONTROL_ERROR_NONE;
+	fimc_is_set_param_bit(is, PARAM_ISP_CONTROL);
+	fimc_is_inc_param_num(is);
+
+	isp->otf_input.cmd = OTF_INPUT_COMMAND_ENABLE;
+	if (!test_bit(PARAM_ISP_OTF_INPUT, p_index1)) {
+		isp->otf_input.width = DEFAULT_PREVIEW_STILL_WIDTH;
+		isp->otf_input.height = DEFAULT_PREVIEW_STILL_HEIGHT;
+		fimc_is_set_param_bit(is, PARAM_ISP_OTF_INPUT);
+		fimc_is_inc_param_num(is);
+	}
+	if (is->sensor->test_pattern)
+		isp->otf_input.format = OTF_INPUT_FORMAT_STRGEN_COLORBAR_BAYER;
+	else
+		isp->otf_input.format = OTF_INPUT_FORMAT_BAYER;
+	isp->otf_input.bitwidth = 10;
+	isp->otf_input.order = OTF_INPUT_ORDER_BAYER_GR_BG;
+	isp->otf_input.crop_offset_x = 0;
+	isp->otf_input.crop_offset_y = 0;
+	isp->otf_input.err = OTF_INPUT_ERROR_NONE;
+
+	isp->dma1_input.cmd = DMA_INPUT_COMMAND_DISABLE;
+	isp->dma1_input.width = 0;
+	isp->dma1_input.height = 0;
+	isp->dma1_input.format = 0;
+	isp->dma1_input.bitwidth = 0;
+	isp->dma1_input.plane = 0;
+	isp->dma1_input.order = 0;
+	isp->dma1_input.buffer_number = 0;
+	isp->dma1_input.width = 0;
+	isp->dma1_input.err = DMA_INPUT_ERROR_NONE;
+	fimc_is_set_param_bit(is, PARAM_ISP_DMA1_INPUT);
+	fimc_is_inc_param_num(is);
+
+	isp->dma2_input.cmd = DMA_INPUT_COMMAND_DISABLE;
+	isp->dma2_input.width = 0;
+	isp->dma2_input.height = 0;
+	isp->dma2_input.format = 0;
+	isp->dma2_input.bitwidth = 0;
+	isp->dma2_input.plane = 0;
+	isp->dma2_input.order = 0;
+	isp->dma2_input.buffer_number = 0;
+	isp->dma2_input.width = 0;
+	isp->dma2_input.err = DMA_INPUT_ERROR_NONE;
+	fimc_is_set_param_bit(is, PARAM_ISP_DMA2_INPUT);
+	fimc_is_inc_param_num(is);
+
+	isp->aa.cmd = ISP_AA_COMMAND_START;
+	isp->aa.target = ISP_AA_TARGET_AE | ISP_AA_TARGET_AWB;
+	fimc_is_set_param_bit(is, PARAM_ISP_AA);
+	fimc_is_inc_param_num(is);
+
+	if (!test_bit(PARAM_ISP_FLASH, p_index1))
+		__is_set_isp_flash(is, ISP_FLASH_COMMAND_DISABLE,
+						ISP_FLASH_REDEYE_DISABLE);
+
+	if (!test_bit(PARAM_ISP_AWB, p_index1))
+		__is_set_isp_awb(is, ISP_AWB_COMMAND_AUTO, 0);
+
+	if (!test_bit(PARAM_ISP_IMAGE_EFFECT, p_index1))
+		__is_set_isp_effect(is, ISP_IMAGE_EFFECT_DISABLE);
+
+	if (!test_bit(PARAM_ISP_ISO, p_index1))
+		__is_set_isp_iso(is, ISP_ISO_COMMAND_AUTO, 0);
+
+	if (!test_bit(PARAM_ISP_ADJUST, p_index1)) {
+		__is_set_isp_adjust(is, ISP_ADJUST_COMMAND_MANUAL_CONTRAST, 0);
+		__is_set_isp_adjust(is,
+				ISP_ADJUST_COMMAND_MANUAL_SATURATION, 0);
+		__is_set_isp_adjust(is, ISP_ADJUST_COMMAND_MANUAL_SHARPNESS, 0);
+		__is_set_isp_adjust(is, ISP_ADJUST_COMMAND_MANUAL_EXPOSURE, 0);
+		__is_set_isp_adjust(is,
+				ISP_ADJUST_COMMAND_MANUAL_BRIGHTNESS, 0);
+		__is_set_isp_adjust(is, ISP_ADJUST_COMMAND_MANUAL_HUE, 0);
+	}
+
+	if (!test_bit(PARAM_ISP_METERING, p_index1)) {
+		__is_set_isp_metering(is, 0, ISP_METERING_COMMAND_CENTER);
+		__is_set_isp_metering(is, 1, 0);
+		__is_set_isp_metering(is, 2, 0);
+		__is_set_isp_metering(is, 3, 0);
+		__is_set_isp_metering(is, 4, 0);
+	}
+
+	if (!test_bit(PARAM_ISP_AFC, p_index1))
+		__is_set_isp_afc(is, ISP_AFC_COMMAND_AUTO, 0);
+
+	isp->otf_output.cmd = OTF_OUTPUT_COMMAND_ENABLE;
+	if (!test_bit(PARAM_ISP_OTF_OUTPUT, p_index1)) {
+		isp->otf_output.width = DEFAULT_PREVIEW_STILL_WIDTH;
+		isp->otf_output.height = DEFAULT_PREVIEW_STILL_HEIGHT;
+		fimc_is_set_param_bit(is, PARAM_ISP_OTF_OUTPUT);
+		fimc_is_inc_param_num(is);
+	}
+	isp->otf_output.format = OTF_OUTPUT_FORMAT_YUV444;
+	isp->otf_output.bitwidth = 12;
+	isp->otf_output.order = 0;
+	isp->otf_output.err = OTF_OUTPUT_ERROR_NONE;
+
+	if (!test_bit(PARAM_ISP_DMA1_OUTPUT, p_index1)) {
+		isp->dma1_output.cmd = DMA_OUTPUT_COMMAND_DISABLE;
+		isp->dma1_output.width = 0;
+		isp->dma1_output.height = 0;
+		isp->dma1_output.format = 0;
+		isp->dma1_output.bitwidth = 0;
+		isp->dma1_output.plane = 0;
+		isp->dma1_output.order = 0;
+		isp->dma1_output.buffer_number = 0;
+		isp->dma1_output.buffer_address = 0;
+		isp->dma1_output.notify_dma_done = 0;
+		isp->dma1_output.dma_out_mask = 0;
+		isp->dma1_output.err = DMA_OUTPUT_ERROR_NONE;
+		fimc_is_set_param_bit(is, PARAM_ISP_DMA1_OUTPUT);
+		fimc_is_inc_param_num(is);
+	}
+
+	if (!test_bit(PARAM_ISP_DMA2_OUTPUT, p_index1)) {
+		isp->dma2_output.cmd = DMA_OUTPUT_COMMAND_DISABLE;
+		isp->dma2_output.width = 0;
+		isp->dma2_output.height = 0;
+		isp->dma2_output.format = 0;
+		isp->dma2_output.bitwidth = 0;
+		isp->dma2_output.plane = 0;
+		isp->dma2_output.order = 0;
+		isp->dma2_output.buffer_number = 0;
+		isp->dma2_output.buffer_address = 0;
+		isp->dma2_output.notify_dma_done = 0;
+		isp->dma2_output.dma_out_mask = 0;
+		isp->dma2_output.err = DMA_OUTPUT_ERROR_NONE;
+		fimc_is_set_param_bit(is, PARAM_ISP_DMA2_OUTPUT);
+		fimc_is_inc_param_num(is);
+	}
+
+	/* Sensor */
+	if (!test_bit(PARAM_SENSOR_FRAME_RATE, p_index1)) {
+		if (!mode)
+			__is_set_sensor(is, 0);
+	}
+
+	/* DRC */
+	drc->control.cmd = CONTROL_COMMAND_START;
+	__is_set_drc_control(is, CONTROL_BYPASS_ENABLE);
+
+	drc->otf_input.cmd = OTF_INPUT_COMMAND_ENABLE;
+	if (!test_bit(PARAM_DRC_OTF_INPUT, p_index1)) {
+		drc->otf_input.width = DEFAULT_PREVIEW_STILL_WIDTH;
+		drc->otf_input.height = DEFAULT_PREVIEW_STILL_HEIGHT;
+		fimc_is_set_param_bit(is, PARAM_DRC_OTF_INPUT);
+		fimc_is_inc_param_num(is);
+	}
+	drc->otf_input.format = OTF_INPUT_FORMAT_YUV444;
+	drc->otf_input.bitwidth = 12;
+	drc->otf_input.order = 0;
+	drc->otf_input.err = OTF_INPUT_ERROR_NONE;
+
+	drc->dma_input.cmd = DMA_INPUT_COMMAND_DISABLE;
+	drc->dma_input.width = 0;
+	drc->dma_input.height = 0;
+	drc->dma_input.format = 0;
+	drc->dma_input.bitwidth = 0;
+	drc->dma_input.plane = 0;
+	drc->dma_input.order = 0;
+	drc->dma_input.buffer_number = 0;
+	drc->dma_input.width = 0;
+	drc->dma_input.err = DMA_INPUT_ERROR_NONE;
+	fimc_is_set_param_bit(is, PARAM_DRC_DMA_INPUT);
+	fimc_is_inc_param_num(is);
+
+	drc->otf_output.cmd = OTF_OUTPUT_COMMAND_ENABLE;
+	if (!test_bit(PARAM_DRC_OTF_OUTPUT, p_index1)) {
+		drc->otf_output.width = DEFAULT_PREVIEW_STILL_WIDTH;
+		drc->otf_output.height = DEFAULT_PREVIEW_STILL_HEIGHT;
+		fimc_is_set_param_bit(is, PARAM_DRC_OTF_OUTPUT);
+		fimc_is_inc_param_num(is);
+	}
+	drc->otf_output.format = OTF_OUTPUT_FORMAT_YUV444;
+	drc->otf_output.bitwidth = 8;
+	drc->otf_output.order = 0;
+	drc->otf_output.err = OTF_OUTPUT_ERROR_NONE;
+
+	/* FD */
+	__is_set_fd_control(is, CONTROL_COMMAND_STOP);
+	fd->control.bypass = CONTROL_BYPASS_DISABLE;
+
+	fd->otf_input.cmd = OTF_INPUT_COMMAND_ENABLE;
+	if (!test_bit((PARAM_FD_OTF_INPUT - 32), p_index2)) {
+		fd->otf_input.width = DEFAULT_PREVIEW_STILL_WIDTH;
+		fd->otf_input.height = DEFAULT_PREVIEW_STILL_HEIGHT;
+		fimc_is_set_param_bit(is, PARAM_FD_OTF_INPUT);
+		fimc_is_inc_param_num(is);
+	}
+	fd->otf_input.format = OTF_INPUT_FORMAT_YUV444;
+	fd->otf_input.bitwidth = 8;
+	fd->otf_input.order = 0;
+	fd->otf_input.err = OTF_INPUT_ERROR_NONE;
+
+	fd->dma_input.cmd = DMA_INPUT_COMMAND_DISABLE;
+	fd->dma_input.width = 0;
+	fd->dma_input.height = 0;
+	fd->dma_input.format = 0;
+	fd->dma_input.bitwidth = 0;
+	fd->dma_input.plane = 0;
+	fd->dma_input.order = 0;
+	fd->dma_input.buffer_number = 0;
+	fd->dma_input.width = 0;
+	fd->dma_input.err = DMA_INPUT_ERROR_NONE;
+	fimc_is_set_param_bit(is, PARAM_FD_DMA_INPUT);
+	fimc_is_inc_param_num(is);
+
+	__is_set_fd_config_maxface(is, 5);
+	__is_set_fd_config_rollangle(is, FD_CONFIG_ROLL_ANGLE_FULL);
+	__is_set_fd_config_yawangle(is, FD_CONFIG_YAW_ANGLE_45_90);
+	__is_set_fd_config_smilemode(is, FD_CONFIG_SMILE_MODE_DISABLE);
+	__is_set_fd_config_blinkmode(is, FD_CONFIG_BLINK_MODE_DISABLE);
+	__is_set_fd_config_eyedetect(is, FD_CONFIG_EYES_DETECT_ENABLE);
+	__is_set_fd_config_mouthdetect(is, FD_CONFIG_MOUTH_DETECT_DISABLE);
+	__is_set_fd_config_orientation(is, FD_CONFIG_ORIENTATION_DISABLE);
+	__is_set_fd_config_orientation_val(is, 0);
+}
diff --git a/drivers/media/platform/exynos4-is/fimc-is-param.h b/drivers/media/platform/exynos4-is/fimc-is-param.h
new file mode 100644
index 0000000..71464a5
--- /dev/null
+++ b/drivers/media/platform/exynos4-is/fimc-is-param.h
@@ -0,0 +1,1022 @@
+/*
+ * Samsung EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2011 - 2013 Samsung Electronics Co., Ltd.
+ *
+ * Authors: Younghwan Joo <yhwan.joo@samsung.com>
+ *	    Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef FIMC_IS_PARAM_H_
+#define FIMC_IS_PARAM_H_
+
+#include <linux/compiler.h>
+
+#define FIMC_IS_CONFIG_TIMEOUT		3000 /* ms */
+#define IS_DEFAULT_WIDTH		1280
+#define IS_DEFAULT_HEIGHT		720
+
+#define DEFAULT_PREVIEW_STILL_WIDTH	IS_DEFAULT_WIDTH
+#define DEFAULT_PREVIEW_STILL_HEIGHT	IS_DEFAULT_HEIGHT
+#define DEFAULT_CAPTURE_STILL_WIDTH	IS_DEFAULT_WIDTH
+#define DEFAULT_CAPTURE_STILL_HEIGHT	IS_DEFAULT_HEIGHT
+#define DEFAULT_PREVIEW_VIDEO_WIDTH	IS_DEFAULT_WIDTH
+#define DEFAULT_PREVIEW_VIDEO_HEIGHT	IS_DEFAULT_HEIGHT
+#define DEFAULT_CAPTURE_VIDEO_WIDTH	IS_DEFAULT_WIDTH
+#define DEFAULT_CAPTURE_VIDEO_HEIGHT	IS_DEFAULT_HEIGHT
+
+#define DEFAULT_PREVIEW_STILL_FRAMERATE	30
+#define DEFAULT_CAPTURE_STILL_FRAMERATE	15
+#define DEFAULT_PREVIEW_VIDEO_FRAMERATE	30
+#define DEFAULT_CAPTURE_VIDEO_FRAMERATE	30
+
+#define FIMC_IS_REGION_VER		124 /* IS REGION VERSION 1.24 */
+#define FIMC_IS_PARAM_SIZE		(FIMC_IS_REGION_SIZE + 1)
+#define FIMC_IS_MAGIC_NUMBER		0x01020304
+#define FIMC_IS_PARAM_MAX_SIZE		64 /* in bytes */
+#define FIMC_IS_PARAM_MAX_ENTRIES	(FIMC_IS_PARAM_MAX_SIZE / 4)
+
+/* The parameter bitmask bit definitions. */
+enum is_param_bit {
+	PARAM_GLOBAL_SHOTMODE,
+	PARAM_SENSOR_CONTROL,
+	PARAM_SENSOR_OTF_OUTPUT,
+	PARAM_SENSOR_FRAME_RATE,
+	PARAM_BUFFER_CONTROL,
+	PARAM_BUFFER_OTF_INPUT,
+	PARAM_BUFFER_OTF_OUTPUT,
+	PARAM_ISP_CONTROL,
+	PARAM_ISP_OTF_INPUT,
+	PARAM_ISP_DMA1_INPUT,
+	/* 10 */
+	PARAM_ISP_DMA2_INPUT,
+	PARAM_ISP_AA,
+	PARAM_ISP_FLASH,
+	PARAM_ISP_AWB,
+	PARAM_ISP_IMAGE_EFFECT,
+	PARAM_ISP_ISO,
+	PARAM_ISP_ADJUST,
+	PARAM_ISP_METERING,
+	PARAM_ISP_AFC,
+	PARAM_ISP_OTF_OUTPUT,
+	/* 20 */
+	PARAM_ISP_DMA1_OUTPUT,
+	PARAM_ISP_DMA2_OUTPUT,
+	PARAM_DRC_CONTROL,
+	PARAM_DRC_OTF_INPUT,
+	PARAM_DRC_DMA_INPUT,
+	PARAM_DRC_OTF_OUTPUT,
+	PARAM_SCALERC_CONTROL,
+	PARAM_SCALERC_OTF_INPUT,
+	PARAM_SCALERC_IMAGE_EFFECT,
+	PARAM_SCALERC_INPUT_CROP,
+	/* 30 */
+	PARAM_SCALERC_OUTPUT_CROP,
+	PARAM_SCALERC_OTF_OUTPUT,
+	PARAM_SCALERC_DMA_OUTPUT,
+	PARAM_ODC_CONTROL,
+	PARAM_ODC_OTF_INPUT,
+	PARAM_ODC_OTF_OUTPUT,
+	PARAM_DIS_CONTROL,
+	PARAM_DIS_OTF_INPUT,
+	PARAM_DIS_OTF_OUTPUT,
+	PARAM_TDNR_CONTROL,
+	/* 40 */
+	PARAM_TDNR_OTF_INPUT,
+	PARAM_TDNR_1ST_FRAME,
+	PARAM_TDNR_OTF_OUTPUT,
+	PARAM_TDNR_DMA_OUTPUT,
+	PARAM_SCALERP_CONTROL,
+	PARAM_SCALERP_OTF_INPUT,
+	PARAM_SCALERP_IMAGE_EFFECT,
+	PARAM_SCALERP_INPUT_CROP,
+	PARAM_SCALERP_OUTPUT_CROP,
+	PARAM_SCALERP_ROTATION,
+	/* 50 */
+	PARAM_SCALERP_FLIP,
+	PARAM_SCALERP_OTF_OUTPUT,
+	PARAM_SCALERP_DMA_OUTPUT,
+	PARAM_FD_CONTROL,
+	PARAM_FD_OTF_INPUT,
+	PARAM_FD_DMA_INPUT,
+	PARAM_FD_CONFIG,
+};
+
+/* Interrupt map */
+#define	FIMC_IS_INT_GENERAL			0
+#define	FIMC_IS_INT_FRAME_DONE_ISP		1
+
+/* Input */
+
+#define CONTROL_COMMAND_STOP			0
+#define CONTROL_COMMAND_START			1
+
+#define CONTROL_BYPASS_DISABLE			0
+#define CONTROL_BYPASS_ENABLE			1
+
+#define CONTROL_ERROR_NONE			0
+
+/* OTF (On-The-Fly) input interface commands */
+#define OTF_INPUT_COMMAND_DISABLE		0
+#define OTF_INPUT_COMMAND_ENABLE		1
+
+/* OTF input interface color formats */
+enum oft_input_fmt {
+	OTF_INPUT_FORMAT_BAYER			= 0, /* 1 channel */
+	OTF_INPUT_FORMAT_YUV444			= 1, /* 3 channels */
+	OTF_INPUT_FORMAT_YUV422			= 2, /* 3 channels */
+	OTF_INPUT_FORMAT_YUV420			= 3, /* 3 channels */
+	OTF_INPUT_FORMAT_STRGEN_COLORBAR_BAYER	= 10,
+	OTF_INPUT_FORMAT_BAYER_DMA		= 11,
+};
+
+#define OTF_INPUT_ORDER_BAYER_GR_BG		0
+
+/* OTF input error codes */
+#define OTF_INPUT_ERROR_NONE			0 /* Input setting is done */
+
+/* DMA input commands */
+#define DMA_INPUT_COMMAND_DISABLE		0
+#define DMA_INPUT_COMMAND_ENABLE		1
+
+/* DMA input color formats */
+enum dma_input_fmt {
+	DMA_INPUT_FORMAT_BAYER			= 0,
+	DMA_INPUT_FORMAT_YUV444			= 1,
+	DMA_INPUT_FORMAT_YUV422			= 2,
+	DMA_INPUT_FORMAT_YUV420			= 3,
+};
+
+enum dma_input_order {
+	/* (for DMA_INPUT_PLANE_3) */
+	DMA_INPUT_ORDER_NO	= 0,
+	/* (only valid at DMA_INPUT_PLANE_2) */
+	DMA_INPUT_ORDER_CBCR	= 1,
+	/* (only valid at DMA_INPUT_PLANE_2) */
+	DMA_INPUT_ORDER_CRCB	= 2,
+	/* (only valid at DMA_INPUT_PLANE_1 & DMA_INPUT_FORMAT_YUV444) */
+	DMA_INPUT_ORDER_YCBCR	= 3,
+	/* (only valid at DMA_INPUT_FORMAT_YUV422 & DMA_INPUT_PLANE_1) */
+	DMA_INPUT_ORDER_YYCBCR	= 4,
+	/* (only valid at DMA_INPUT_FORMAT_YUV422 & DMA_INPUT_PLANE_1) */
+	DMA_INPUT_ORDER_YCBYCR	= 5,
+	/* (only valid at DMA_INPUT_FORMAT_YUV422 & DMA_INPUT_PLANE_1) */
+	DMA_INPUT_ORDER_YCRYCB	= 6,
+	/* (only valid at DMA_INPUT_FORMAT_YUV422 & DMA_INPUT_PLANE_1) */
+	DMA_INPUT_ORDER_CBYCRY	= 7,
+	/* (only valid at DMA_INPUT_FORMAT_YUV422 & DMA_INPUT_PLANE_1) */
+	DMA_INPUT_ORDER_CRYCBY	= 8,
+	/* (only valid at DMA_INPUT_FORMAT_BAYER) */
+	DMA_INPUT_ORDER_GR_BG	= 9
+};
+
+#define DMA_INPUT_ERROR_NONE			0 /* DMA input setting
+						     is done */
+/*
+ * Data output parameter definitions
+ */
+#define OTF_OUTPUT_CROP_DISABLE			0
+#define OTF_OUTPUT_CROP_ENABLE			1
+
+#define OTF_OUTPUT_COMMAND_DISABLE		0
+#define OTF_OUTPUT_COMMAND_ENABLE		1
+
+enum otf_output_fmt {
+	OTF_OUTPUT_FORMAT_YUV444		= 1,
+	OTF_OUTPUT_FORMAT_YUV422		= 2,
+	OTF_OUTPUT_FORMAT_YUV420		= 3,
+	OTF_OUTPUT_FORMAT_RGB			= 4,
+};
+
+#define OTF_OUTPUT_ORDER_BAYER_GR_BG		0
+
+#define OTF_OUTPUT_ERROR_NONE			0 /* Output Setting is done */
+
+#define DMA_OUTPUT_COMMAND_DISABLE		0
+#define DMA_OUTPUT_COMMAND_ENABLE		1
+
+enum dma_output_fmt {
+	DMA_OUTPUT_FORMAT_BAYER			= 0,
+	DMA_OUTPUT_FORMAT_YUV444		= 1,
+	DMA_OUTPUT_FORMAT_YUV422		= 2,
+	DMA_OUTPUT_FORMAT_YUV420		= 3,
+	DMA_OUTPUT_FORMAT_RGB			= 4,
+};
+
+enum dma_output_order {
+	DMA_OUTPUT_ORDER_NO		= 0,
+	/* for DMA_OUTPUT_PLANE_3 */
+	DMA_OUTPUT_ORDER_CBCR		= 1,
+	/* only valid at DMA_INPUT_PLANE_2) */
+	DMA_OUTPUT_ORDER_CRCB		= 2,
+	/* only valid at DMA_OUTPUT_PLANE_2) */
+	DMA_OUTPUT_ORDER_YYCBCR		= 3,
+	/* only valid at DMA_OUTPUT_FORMAT_YUV422 & DMA_OUTPUT_PLANE_1 */
+	DMA_OUTPUT_ORDER_YCBYCR		= 4,
+	/* only valid at DMA_OUTPUT_FORMAT_YUV422 & DMA_OUTPUT_PLANE_1 */
+	DMA_OUTPUT_ORDER_YCRYCB		= 5,
+	/* only valid at DMA_OUTPUT_FORMAT_YUV422 & DMA_OUTPUT_PLANE_1 */
+	DMA_OUTPUT_ORDER_CBYCRY		= 6,
+	/* only valid at DMA_OUTPUT_FORMAT_YUV422 & DMA_OUTPUT_PLANE_1 */
+	DMA_OUTPUT_ORDER_CRYCBY		= 7,
+	/* only valid at DMA_OUTPUT_FORMAT_YUV422 & DMA_OUTPUT_PLANE_1 */
+	DMA_OUTPUT_ORDER_YCBCR		= 8,
+	/* only valid at DMA_OUTPUT_FORMAT_YUV444 & DMA_OUPUT_PLANE_1 */
+	DMA_OUTPUT_ORDER_CRYCB		= 9,
+	/* only valid at DMA_OUTPUT_FORMAT_YUV444 & DMA_OUPUT_PLANE_1 */
+	DMA_OUTPUT_ORDER_CRCBY		= 10,
+	/* only valid at DMA_OUTPUT_FORMAT_YUV444 & DMA_OUPUT_PLANE_1 */
+	DMA_OUTPUT_ORDER_CBYCR		= 11,
+	/* only valid at DMA_OUTPUT_FORMAT_YUV444 & DMA_OUPUT_PLANE_1 */
+	DMA_OUTPUT_ORDER_YCRCB		= 12,
+	/* only valid at DMA_OUTPUT_FORMAT_YUV444 & DMA_OUPUT_PLANE_1 */
+	DMA_OUTPUT_ORDER_CBCRY		= 13,
+	/* only valid at DMA_OUTPUT_FORMAT_YUV444 & DMA_OUPUT_PLANE_1 */
+	DMA_OUTPUT_ORDER_BGR		= 14,
+	/* only valid at DMA_OUTPUT_FORMAT_RGB */
+	DMA_OUTPUT_ORDER_GB_BG		= 15
+	/* only valid at DMA_OUTPUT_FORMAT_BAYER */
+};
+
+/* enum dma_output_notify_dma_done */
+#define DMA_OUTPUT_NOTIFY_DMA_DONE_DISABLE	0
+#define DMA_OUTPUT_NOTIFY_DMA_DONE_ENABLE	1
+
+/* DMA output error codes */
+#define DMA_OUTPUT_ERROR_NONE			0 /* DMA output setting
+						     is done */
+
+/* ----------------------  Global  ----------------------------------- */
+#define GLOBAL_SHOTMODE_ERROR_NONE		0 /* shot-mode setting
+						     is done */
+/* 3A lock commands */
+#define ISP_AA_COMMAND_START			0
+#define ISP_AA_COMMAND_STOP			1
+
+/* 3A lock target */
+#define ISP_AA_TARGET_AF			1
+#define ISP_AA_TARGET_AE			2
+#define ISP_AA_TARGET_AWB			4
+
+enum isp_af_mode {
+	ISP_AF_MODE_MANUAL			= 0,
+	ISP_AF_MODE_SINGLE			= 1,
+	ISP_AF_MODE_CONTINUOUS			= 2,
+	ISP_AF_MODE_TOUCH			= 3,
+	ISP_AF_MODE_SLEEP			= 4,
+	ISP_AF_MODE_INIT			= 5,
+	ISP_AF_MODE_SET_CENTER_WINDOW		= 6,
+	ISP_AF_MODE_SET_TOUCH_WINDOW		= 7
+};
+
+/* Face AF commands */
+#define ISP_AF_FACE_DISABLE			0
+#define ISP_AF_FACE_ENABLE			1
+
+/* AF range */
+#define ISP_AF_RANGE_NORMAL			0
+#define ISP_AF_RANGE_MACRO			1
+
+/* AF sleep */
+#define ISP_AF_SLEEP_OFF			0
+#define ISP_AF_SLEEP_ON				1
+
+/* Continuous AF commands */
+#define ISP_AF_CONTINUOUS_DISABLE		0
+#define ISP_AF_CONTINUOUS_ENABLE		1
+
+/* ISP AF error codes */
+#define ISP_AF_ERROR_NONE			0 /* AF mode change is done */
+#define ISP_AF_ERROR_NONE_LOCK_DONE		1 /* AF lock is done */
+
+/* Flash commands */
+#define ISP_FLASH_COMMAND_DISABLE		0
+#define ISP_FLASH_COMMAND_MANUAL_ON		1 /* (forced flash) */
+#define ISP_FLASH_COMMAND_AUTO			2
+#define ISP_FLASH_COMMAND_TORCH			3 /* 3 sec */
+
+/* Flash red-eye commads */
+#define ISP_FLASH_REDEYE_DISABLE		0
+#define ISP_FLASH_REDEYE_ENABLE			1
+
+/* Flash error codes */
+#define ISP_FLASH_ERROR_NONE			0 /* Flash setting is done */
+
+/* --------------------------  AWB  ------------------------------------ */
+enum isp_awb_command {
+	ISP_AWB_COMMAND_AUTO			= 0,
+	ISP_AWB_COMMAND_ILLUMINATION		= 1,
+	ISP_AWB_COMMAND_MANUAL			= 2
+};
+
+enum isp_awb_illumination {
+	ISP_AWB_ILLUMINATION_DAYLIGHT		= 0,
+	ISP_AWB_ILLUMINATION_CLOUDY		= 1,
+	ISP_AWB_ILLUMINATION_TUNGSTEN		= 2,
+	ISP_AWB_ILLUMINATION_FLUORESCENT	= 3
+};
+
+/* ISP AWN error codes */
+#define ISP_AWB_ERROR_NONE			0 /* AWB setting is done */
+
+/* --------------------------  Effect  ----------------------------------- */
+enum isp_imageeffect_command {
+	ISP_IMAGE_EFFECT_DISABLE		= 0,
+	ISP_IMAGE_EFFECT_MONOCHROME		= 1,
+	ISP_IMAGE_EFFECT_NEGATIVE_MONO		= 2,
+	ISP_IMAGE_EFFECT_NEGATIVE_COLOR		= 3,
+	ISP_IMAGE_EFFECT_SEPIA			= 4
+};
+
+/* Image effect error codes */
+#define ISP_IMAGE_EFFECT_ERROR_NONE		0 /* Image effect setting
+						     is done */
+/* ISO commands */
+#define ISP_ISO_COMMAND_AUTO			0
+#define ISP_ISO_COMMAND_MANUAL			1
+
+/* ISO error codes */
+#define ISP_ISO_ERROR_NONE			0 /* ISO setting is done */
+
+/* ISP adjust commands */
+#define ISP_ADJUST_COMMAND_AUTO			(0 << 0)
+#define ISP_ADJUST_COMMAND_MANUAL_CONTRAST	(1 << 0)
+#define ISP_ADJUST_COMMAND_MANUAL_SATURATION	(1 << 1)
+#define ISP_ADJUST_COMMAND_MANUAL_SHARPNESS	(1 << 2)
+#define ISP_ADJUST_COMMAND_MANUAL_EXPOSURE	(1 << 3)
+#define ISP_ADJUST_COMMAND_MANUAL_BRIGHTNESS	(1 << 4)
+#define ISP_ADJUST_COMMAND_MANUAL_HUE		(1 << 5)
+#define ISP_ADJUST_COMMAND_MANUAL_ALL		0x7f
+
+/* ISP adjustment error codes */
+#define ISP_ADJUST_ERROR_NONE			0 /* Adjust setting is done */
+
+/*
+ *  Exposure metering
+ */
+enum isp_metering_command {
+	ISP_METERING_COMMAND_AVERAGE	= 0,
+	ISP_METERING_COMMAND_SPOT	= 1,
+	ISP_METERING_COMMAND_MATRIX	= 2,
+	ISP_METERING_COMMAND_CENTER	= 3
+};
+
+/* ISP metering error codes */
+#define ISP_METERING_ERROR_NONE		0 /* Metering setting is done */
+
+/*
+ * AFC
+ */
+enum isp_afc_command {
+	ISP_AFC_COMMAND_DISABLE		= 0,
+	ISP_AFC_COMMAND_AUTO		= 1,
+	ISP_AFC_COMMAND_MANUAL		= 2,
+};
+
+#define ISP_AFC_MANUAL_50HZ		50
+#define ISP_AFC_MANUAL_60HZ		60
+
+/* ------------------------  SCENE MODE--------------------------------- */
+enum isp_scene_mode {
+	ISP_SCENE_NONE			= 0,
+	ISP_SCENE_PORTRAIT		= 1,
+	ISP_SCENE_LANDSCAPE		= 2,
+	ISP_SCENE_SPORTS		= 3,
+	ISP_SCENE_PARTYINDOOR		= 4,
+	ISP_SCENE_BEACHSNOW		= 5,
+	ISP_SCENE_SUNSET		= 6,
+	ISP_SCENE_DAWN			= 7,
+	ISP_SCENE_FALL			= 8,
+	ISP_SCENE_NIGHT			= 9,
+	ISP_SCENE_AGAINSTLIGHTWLIGHT	= 10,
+	ISP_SCENE_AGAINSTLIGHTWOLIGHT	= 11,
+	ISP_SCENE_FIRE			= 12,
+	ISP_SCENE_TEXT			= 13,
+	ISP_SCENE_CANDLE		= 14
+};
+
+/* AFC error codes */
+#define ISP_AFC_ERROR_NONE		0 /* AFC setting is done */
+
+/* ----------------------------  FD  ------------------------------------- */
+enum fd_config_command {
+	FD_CONFIG_COMMAND_MAXIMUM_NUMBER	= 0x1,
+	FD_CONFIG_COMMAND_ROLL_ANGLE		= 0x2,
+	FD_CONFIG_COMMAND_YAW_ANGLE		= 0x4,
+	FD_CONFIG_COMMAND_SMILE_MODE		= 0x8,
+	FD_CONFIG_COMMAND_BLINK_MODE		= 0x10,
+	FD_CONFIG_COMMAND_EYES_DETECT		= 0x20,
+	FD_CONFIG_COMMAND_MOUTH_DETECT		= 0x40,
+	FD_CONFIG_COMMAND_ORIENTATION		= 0x80,
+	FD_CONFIG_COMMAND_ORIENTATION_VALUE	= 0x100
+};
+
+enum fd_config_roll_angle {
+	FD_CONFIG_ROLL_ANGLE_BASIC		= 0,
+	FD_CONFIG_ROLL_ANGLE_PRECISE_BASIC	= 1,
+	FD_CONFIG_ROLL_ANGLE_SIDES		= 2,
+	FD_CONFIG_ROLL_ANGLE_PRECISE_SIDES	= 3,
+	FD_CONFIG_ROLL_ANGLE_FULL		= 4,
+	FD_CONFIG_ROLL_ANGLE_PRECISE_FULL	= 5,
+};
+
+enum fd_config_yaw_angle {
+	FD_CONFIG_YAW_ANGLE_0			= 0,
+	FD_CONFIG_YAW_ANGLE_45			= 1,
+	FD_CONFIG_YAW_ANGLE_90			= 2,
+	FD_CONFIG_YAW_ANGLE_45_90		= 3,
+};
+
+/* Smile mode configuration */
+#define FD_CONFIG_SMILE_MODE_DISABLE		0
+#define FD_CONFIG_SMILE_MODE_ENABLE		1
+
+/* Blink mode configuration */
+#define FD_CONFIG_BLINK_MODE_DISABLE		0
+#define FD_CONFIG_BLINK_MODE_ENABLE		1
+
+/* Eyes detection configuration */
+#define FD_CONFIG_EYES_DETECT_DISABLE		0
+#define FD_CONFIG_EYES_DETECT_ENABLE		1
+
+/* Mouth detection configuration */
+#define FD_CONFIG_MOUTH_DETECT_DISABLE		0
+#define FD_CONFIG_MOUTH_DETECT_ENABLE		1
+
+#define FD_CONFIG_ORIENTATION_DISABLE		0
+#define FD_CONFIG_ORIENTATION_ENABLE		1
+
+struct param_control {
+	u32 cmd;
+	u32 bypass;
+	u32 buffer_address;
+	u32 buffer_size;
+	u32 skip_frames; /* only valid at ISP */
+	u32 reserved[FIMC_IS_PARAM_MAX_ENTRIES - 6];
+	u32 err;
+};
+
+struct param_otf_input {
+	u32 cmd;
+	u32 width;
+	u32 height;
+	u32 format;
+	u32 bitwidth;
+	u32 order;
+	u32 crop_offset_x;
+	u32 crop_offset_y;
+	u32 crop_width;
+	u32 crop_height;
+	u32 frametime_min;
+	u32 frametime_max;
+	u32 reserved[FIMC_IS_PARAM_MAX_ENTRIES - 13];
+	u32 err;
+};
+
+struct param_dma_input {
+	u32 cmd;
+	u32 width;
+	u32 height;
+	u32 format;
+	u32 bitwidth;
+	u32 plane;
+	u32 order;
+	u32 buffer_number;
+	u32 buffer_address;
+	u32 reserved[FIMC_IS_PARAM_MAX_ENTRIES - 10];
+	u32 err;
+};
+
+struct param_otf_output {
+	u32 cmd;
+	u32 width;
+	u32 height;
+	u32 format;
+	u32 bitwidth;
+	u32 order;
+	u32 reserved[FIMC_IS_PARAM_MAX_ENTRIES - 7];
+	u32 err;
+};
+
+struct param_dma_output {
+	u32 cmd;
+	u32 width;
+	u32 height;
+	u32 format;
+	u32 bitwidth;
+	u32 plane;
+	u32 order;
+	u32 buffer_number;
+	u32 buffer_address;
+	u32 notify_dma_done;
+	u32 dma_out_mask;
+	u32 reserved[FIMC_IS_PARAM_MAX_ENTRIES - 12];
+	u32 err;
+};
+
+struct param_global_shotmode {
+	u32 cmd;
+	u32 skip_frames;
+	u32 reserved[FIMC_IS_PARAM_MAX_ENTRIES - 3];
+	u32 err;
+};
+
+struct param_sensor_framerate {
+	u32 frame_rate;
+	u32 reserved[FIMC_IS_PARAM_MAX_ENTRIES - 2];
+	u32 err;
+};
+
+struct param_isp_aa {
+	u32 cmd;
+	u32 target;
+	u32 mode;
+	u32 scene;
+	u32 sleep;
+	u32 face;
+	u32 touch_x;
+	u32 touch_y;
+	u32 manual_af_setting;
+	u32 reserved[FIMC_IS_PARAM_MAX_ENTRIES - 10];
+	u32 err;
+};
+
+struct param_isp_flash {
+	u32 cmd;
+	u32 redeye;
+	u32 reserved[FIMC_IS_PARAM_MAX_ENTRIES - 3];
+	u32 err;
+};
+
+struct param_isp_awb {
+	u32 cmd;
+	u32 illumination;
+	u32 reserved[FIMC_IS_PARAM_MAX_ENTRIES - 3];
+	u32 err;
+};
+
+struct param_isp_imageeffect {
+	u32 cmd;
+	u32 reserved[FIMC_IS_PARAM_MAX_ENTRIES - 2];
+	u32 err;
+};
+
+struct param_isp_iso {
+	u32 cmd;
+	u32 value;
+	u32 reserved[FIMC_IS_PARAM_MAX_ENTRIES - 3];
+	u32 err;
+};
+
+struct param_isp_adjust {
+	u32 cmd;
+	s32 contrast;
+	s32 saturation;
+	s32 sharpness;
+	s32 exposure;
+	s32 brightness;
+	s32 hue;
+	u32 reserved[FIMC_IS_PARAM_MAX_ENTRIES - 8];
+	u32 err;
+};
+
+struct param_isp_metering {
+	u32 cmd;
+	u32 win_pos_x;
+	u32 win_pos_y;
+	u32 win_width;
+	u32 win_height;
+	u32 reserved[FIMC_IS_PARAM_MAX_ENTRIES - 6];
+	u32 err;
+};
+
+struct param_isp_afc {
+	u32 cmd;
+	u32 manual;
+	u32 reserved[FIMC_IS_PARAM_MAX_ENTRIES - 3];
+	u32 err;
+};
+
+struct param_scaler_imageeffect {
+	u32 cmd;
+	u32 arbitrary_cb;
+	u32 arbitrary_cr;
+	u32 reserved[FIMC_IS_PARAM_MAX_ENTRIES - 4];
+	u32 err;
+};
+
+struct param_scaler_input_crop {
+	u32 cmd;
+	u32 crop_offset_x;
+	u32 crop_offset_y;
+	u32 crop_width;
+	u32 crop_height;
+	u32 in_width;
+	u32 in_height;
+	u32 out_width;
+	u32 out_height;
+	u32 reserved[FIMC_IS_PARAM_MAX_ENTRIES - 10];
+	u32 err;
+};
+
+struct param_scaler_output_crop {
+	u32 cmd;
+	u32 crop_offset_x;
+	u32 crop_offset_y;
+	u32 crop_width;
+	u32 crop_height;
+	u32 out_format;
+	u32 reserved[FIMC_IS_PARAM_MAX_ENTRIES - 7];
+	u32 err;
+};
+
+struct param_scaler_rotation {
+	u32 cmd;
+	u32 reserved[FIMC_IS_PARAM_MAX_ENTRIES - 2];
+	u32 err;
+};
+
+struct param_scaler_flip {
+	u32 cmd;
+	u32 reserved[FIMC_IS_PARAM_MAX_ENTRIES - 2];
+	u32 err;
+};
+
+struct param_3dnr_1stframe {
+	u32 cmd;
+	u32 reserved[FIMC_IS_PARAM_MAX_ENTRIES - 2];
+	u32 err;
+};
+
+struct param_fd_config {
+	u32 cmd;
+	u32 max_number;
+	u32 roll_angle;
+	u32 yaw_angle;
+	u32 smile_mode;
+	u32 blink_mode;
+	u32 eye_detect;
+	u32 mouth_detect;
+	u32 orientation;
+	u32 orientation_value;
+	u32 reserved[FIMC_IS_PARAM_MAX_ENTRIES - 11];
+	u32 err;
+};
+
+struct global_param {
+	struct param_global_shotmode	shotmode;
+};
+
+struct sensor_param {
+	struct param_control		control;
+	struct param_otf_output		otf_output;
+	struct param_sensor_framerate	frame_rate;
+} __packed;
+
+struct buffer_param {
+	struct param_control		control;
+	struct param_otf_input		otf_input;
+	struct param_otf_output		otf_output;
+} __packed;
+
+struct isp_param {
+	struct param_control		control;
+	struct param_otf_input		otf_input;
+	struct param_dma_input		dma1_input;
+	struct param_dma_input		dma2_input;
+	struct param_isp_aa		aa;
+	struct param_isp_flash		flash;
+	struct param_isp_awb		awb;
+	struct param_isp_imageeffect	effect;
+	struct param_isp_iso		iso;
+	struct param_isp_adjust		adjust;
+	struct param_isp_metering	metering;
+	struct param_isp_afc		afc;
+	struct param_otf_output		otf_output;
+	struct param_dma_output		dma1_output;
+	struct param_dma_output		dma2_output;
+} __packed;
+
+struct drc_param {
+	struct param_control		control;
+	struct param_otf_input		otf_input;
+	struct param_dma_input		dma_input;
+	struct param_otf_output		otf_output;
+} __packed;
+
+struct scalerc_param {
+	struct param_control		control;
+	struct param_otf_input		otf_input;
+	struct param_scaler_imageeffect	effect;
+	struct param_scaler_input_crop	input_crop;
+	struct param_scaler_output_crop	output_crop;
+	struct param_otf_output		otf_output;
+	struct param_dma_output		dma_output;
+} __packed;
+
+struct odc_param {
+	struct param_control		control;
+	struct param_otf_input		otf_input;
+	struct param_otf_output		otf_output;
+} __packed;
+
+struct dis_param {
+	struct param_control		control;
+	struct param_otf_output		otf_input;
+	struct param_otf_output		otf_output;
+} __packed;
+
+struct tdnr_param {
+	struct param_control		control;
+	struct param_otf_input		otf_input;
+	struct param_3dnr_1stframe	frame;
+	struct param_otf_output		otf_output;
+	struct param_dma_output		dma_output;
+} __packed;
+
+struct scalerp_param {
+	struct param_control		control;
+	struct param_otf_input		otf_input;
+	struct param_scaler_imageeffect	effect;
+	struct param_scaler_input_crop	input_crop;
+	struct param_scaler_output_crop	output_crop;
+	struct param_scaler_rotation	rotation;
+	struct param_scaler_flip	flip;
+	struct param_otf_output		otf_output;
+	struct param_dma_output		dma_output;
+} __packed;
+
+struct fd_param {
+	struct param_control		control;
+	struct param_otf_input		otf_input;
+	struct param_dma_input		dma_input;
+	struct param_fd_config		config;
+} __packed;
+
+struct is_param_region {
+	struct global_param		global;
+	struct sensor_param		sensor;
+	struct buffer_param		buf;
+	struct isp_param		isp;
+	struct drc_param		drc;
+	struct scalerc_param		scalerc;
+	struct odc_param		odc;
+	struct dis_param		dis;
+	struct tdnr_param		tdnr;
+	struct scalerp_param		scalerp;
+	struct fd_param			fd;
+} __packed;
+
+#define NUMBER_OF_GAMMA_CURVE_POINTS	32
+
+struct is_tune_sensor {
+	u32 exposure;
+	u32 analog_gain;
+	u32 frame_rate;
+	u32 actuator_position;
+};
+
+struct is_tune_gammacurve {
+	u32 num_pts_x[NUMBER_OF_GAMMA_CURVE_POINTS];
+	u32 num_pts_y_r[NUMBER_OF_GAMMA_CURVE_POINTS];
+	u32 num_pts_y_g[NUMBER_OF_GAMMA_CURVE_POINTS];
+	u32 num_pts_y_b[NUMBER_OF_GAMMA_CURVE_POINTS];
+};
+
+struct is_tune_isp {
+	/* Brightness level: range 0...100, default 7. */
+	u32 brightness_level;
+	/* Contrast level: range -127...127, default 0. */
+	s32 contrast_level;
+	/* Saturation level: range -127...127, default 0. */
+	s32 saturation_level;
+	s32 gamma_level;
+	struct is_tune_gammacurve gamma_curve[4];
+	/* Hue: range -127...127, default 0. */
+	s32 hue;
+	/* Sharpness blur: range -127...127, default 0. */
+	s32 sharpness_blur;
+	/* Despeckle : range -127~127, default : 0 */
+	s32 despeckle;
+	/* Edge color supression: range -127...127, default 0. */
+	s32 edge_color_supression;
+	/* Noise reduction: range -127...127, default 0. */
+	s32 noise_reduction;
+	/* (32 * 4 + 9) * 4 = 548 bytes */
+} __packed;
+
+struct is_tune_region {
+	struct is_tune_sensor sensor;
+	struct is_tune_isp isp;
+} __packed;
+
+struct rational {
+	u32 num;
+	u32 den;
+};
+
+struct srational {
+	s32 num;
+	s32 den;
+};
+
+#define FLASH_FIRED_SHIFT			0
+#define FLASH_NOT_FIRED				0
+#define FLASH_FIRED				1
+
+#define FLASH_STROBE_SHIFT			1
+#define FLASH_STROBE_NO_DETECTION		0
+#define FLASH_STROBE_RESERVED			1
+#define FLASH_STROBE_RETURN_LIGHT_NOT_DETECTED	2
+#define FLASH_STROBE_RETURN_LIGHT_DETECTED	3
+
+#define FLASH_MODE_SHIFT			3
+#define FLASH_MODE_UNKNOWN			0
+#define FLASH_MODE_COMPULSORY_FLASH_FIRING	1
+#define FLASH_MODE_COMPULSORY_FLASH_SUPPRESSION	2
+#define FLASH_MODE_AUTO_MODE			3
+
+#define FLASH_FUNCTION_SHIFT			5
+#define FLASH_FUNCTION_PRESENT			0
+#define FLASH_FUNCTION_NONE			1
+
+#define FLASH_RED_EYE_SHIFT			6
+#define FLASH_RED_EYE_DISABLED			0
+#define FLASH_RED_EYE_SUPPORTED			1
+
+enum apex_aperture_value {
+	F1_0	= 0,
+	F1_4	= 1,
+	F2_0	= 2,
+	F2_8	= 3,
+	F4_0	= 4,
+	F5_6	= 5,
+	F8_9	= 6,
+	F11_0	= 7,
+	F16_0	= 8,
+	F22_0	= 9,
+	F32_0	= 10,
+};
+
+struct exif_attribute {
+	struct rational exposure_time;
+	struct srational shutter_speed;
+	u32 iso_speed_rating;
+	u32 flash;
+	struct srational brightness;
+} __packed;
+
+struct is_frame_header {
+	u32 valid;
+	u32 bad_mark;
+	u32 captured;
+	u32 frame_number;
+	struct exif_attribute exif;
+} __packed;
+
+struct is_fd_rect {
+	u32 offset_x;
+	u32 offset_y;
+	u32 width;
+	u32 height;
+};
+
+struct is_face_marker {
+	u32 frame_number;
+	struct is_fd_rect face;
+	struct is_fd_rect left_eye;
+	struct is_fd_rect right_eye;
+	struct is_fd_rect mouth;
+	u32 roll_angle;
+	u32 yaw_angle;
+	u32 confidence;
+	s32 smile_level;
+	s32 blink_level;
+} __packed;
+
+#define MAX_FRAME_COUNT				8
+#define MAX_FRAME_COUNT_PREVIEW			4
+#define MAX_FRAME_COUNT_CAPTURE			1
+#define MAX_FACE_COUNT				16
+#define MAX_SHARED_COUNT			500
+
+struct is_region {
+	struct is_param_region parameter;
+	struct is_tune_region tune;
+	struct is_frame_header header[MAX_FRAME_COUNT];
+	struct is_face_marker face[MAX_FACE_COUNT];
+	u32 shared[MAX_SHARED_COUNT];
+} __packed;
+
+struct is_debug_frame_descriptor {
+	u32 sensor_frame_time;
+	u32 sensor_exposure_time;
+	s32 sensor_analog_gain;
+	/* monitor for AA */
+	u32 req_lei;
+
+	u32 next_next_lei_exp;
+	u32 next_next_lei_a_gain;
+	u32 next_next_lei_d_gain;
+	u32 next_next_lei_statlei;
+	u32 next_next_lei_lei;
+
+	u32 dummy0;
+};
+
+#define MAX_FRAMEDESCRIPTOR_CONTEXT_NUM	(30*20)	/* 600 frames */
+#define MAX_VERSION_DISPLAY_BUF	32
+
+struct is_share_region {
+	u32 frame_time;
+	u32 exposure_time;
+	s32 analog_gain;
+
+	u32 r_gain;
+	u32 g_gain;
+	u32 b_gain;
+
+	u32 af_position;
+	u32 af_status;
+	/* 0 : SIRC_ISP_CAMERA_AUTOFOCUSMESSAGE_NOMESSAGE */
+	/* 1 : SIRC_ISP_CAMERA_AUTOFOCUSMESSAGE_REACHED */
+	/* 2 : SIRC_ISP_CAMERA_AUTOFOCUSMESSAGE_UNABLETOREACH */
+	/* 3 : SIRC_ISP_CAMERA_AUTOFOCUSMESSAGE_LOST */
+	/* default : unknown */
+	u32 af_scene_type;
+
+	u32 frame_descp_onoff_control;
+	u32 frame_descp_update_done;
+	u32 frame_descp_idx;
+	u32 frame_descp_max_idx;
+	struct is_debug_frame_descriptor
+		dbg_frame_descp_ctx[MAX_FRAMEDESCRIPTOR_CONTEXT_NUM];
+
+	u32 chip_id;
+	u32 chip_rev_no;
+	u8 isp_fw_ver_no[MAX_VERSION_DISPLAY_BUF];
+	u8 isp_fw_ver_date[MAX_VERSION_DISPLAY_BUF];
+	u8 sirc_sdk_ver_no[MAX_VERSION_DISPLAY_BUF];
+	u8 sirc_sdk_rev_no[MAX_VERSION_DISPLAY_BUF];
+	u8 sirc_sdk_rev_date[MAX_VERSION_DISPLAY_BUF];
+} __packed;
+
+struct is_debug_control {
+	u32 write_point;	/* 0~ 500KB boundary */
+	u32 assert_flag;	/* 0: Not invoked, 1: Invoked */
+	u32 pabort_flag;	/* 0: Not invoked, 1: Invoked */
+	u32 dabort_flag;	/* 0: Not invoked, 1: Invoked */
+};
+
+struct sensor_open_extended {
+	u32 actuator_type;
+	u32 mclk;
+	u32 mipi_lane_num;
+	u32 mipi_speed;
+	/* Skip setfile loading when fast_open_sensor is not 0 */
+	u32 fast_open_sensor;
+	/* Activating sensor self calibration mode (6A3) */
+	u32 self_calibration_mode;
+	/* This field is to adjust I2c clock based on ACLK200 */
+	/* This value is varied in case of rev 0.2 */
+	u32 i2c_sclk;
+};
+
+#define fimc_is_inc_param_num(is) \
+	atomic_inc(&(is)->cfg_param[(is)->scenario_id].p_region_num)
+
+struct fimc_is;
+
+int fimc_is_hw_get_sensor_max_framerate(struct fimc_is *is);
+void fimc_is_set_initial_params(struct fimc_is *is);
+
+int  __is_hw_update_params(struct fimc_is *is);
+void __is_get_frame_size(struct fimc_is *is, struct v4l2_mbus_framefmt *mf);
+void __is_set_frame_size(struct fimc_is *is, struct v4l2_mbus_framefmt *mf);
+void __is_set_sensor(struct fimc_is *is, int fps);
+void __is_set_isp_aa_ae(struct fimc_is *is);
+void __is_set_isp_flash(struct fimc_is *is, u32 cmd, u32 redeye);
+void __is_set_isp_awb(struct fimc_is *is, u32 cmd, u32 val);
+void __is_set_isp_effect(struct fimc_is *is, u32 cmd);
+void __is_set_isp_iso(struct fimc_is *is, u32 cmd, u32 val);
+void __is_set_isp_adjust(struct fimc_is *is, u32 cmd, u32 val);
+void __is_set_isp_metering(struct fimc_is *is, u32 id, u32 val);
+void __is_set_isp_afc(struct fimc_is *is, u32 cmd, u32 val);
+void __is_set_drc_control(struct fimc_is *is, u32 val);
+void __is_set_fd_control(struct fimc_is *is, u32 val);
+void __is_set_fd_config_maxface(struct fimc_is *is, u32 val);
+void __is_set_fd_config_rollangle(struct fimc_is *is, u32 val);
+void __is_set_fd_config_yawangle(struct fimc_is *is, u32 val);
+void __is_set_fd_config_smilemode(struct fimc_is *is, u32 val);
+void __is_set_fd_config_blinkmode(struct fimc_is *is, u32 val);
+void __is_set_fd_config_eyedetect(struct fimc_is *is, u32 val);
+void __is_set_fd_config_mouthdetect(struct fimc_is *is, u32 val);
+void __is_set_fd_config_orientation(struct fimc_is *is, u32 val);
+void __is_set_fd_config_orientation_val(struct fimc_is *is, u32 val);
+void __is_set_isp_aa_af_mode(struct fimc_is *is, int cmd);
+void __is_set_isp_aa_af_start_stop(struct fimc_is *is, int cmd);
+
+#endif
-- 
1.7.9.5

