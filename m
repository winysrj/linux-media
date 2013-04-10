Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:58118 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936450Ab3DJKoP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 06:44:15 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
	shaik.samsung@gmail.com, arun.kk@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 5/7] exynos4-is: Rename the ISP chain configuration data
 structure
Date: Wed, 10 Apr 2013 12:42:40 +0200
Message-id: <1365590562-5747-6-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1365590562-5747-1-git-send-email-s.nawrocki@samsung.com>
References: <1365590562-5747-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

More appropriate names for the ISP chain data structure.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is-param.c |  191 ++++++++++-----------
 drivers/media/platform/exynos4-is/fimc-is-regs.c  |   14 +-
 drivers/media/platform/exynos4-is/fimc-is.c       |   22 +--
 drivers/media/platform/exynos4-is/fimc-is.h       |    9 +-
 drivers/media/platform/exynos4-is/fimc-isp.c      |    6 +-
 5 files changed, 121 insertions(+), 121 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is-param.c b/drivers/media/platform/exynos4-is/fimc-is-param.c
index 58123e3..254740f 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-param.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-param.c
@@ -43,7 +43,7 @@ void __fimc_is_hw_update_param_global_shotmode(struct fimc_is *is)
 	struct param_global_shotmode *dst, *src;
 
 	dst = &is->is_p_region->parameter.global.shotmode;
-	src = &is->cfg_param[is->scenario_id].global.shotmode;
+	src = &is->config[is->config_index].global.shotmode;
 	__hw_param_copy(dst, src);
 }
 
@@ -52,14 +52,14 @@ void __fimc_is_hw_update_param_sensor_framerate(struct fimc_is *is)
 	struct param_sensor_framerate *dst, *src;
 
 	dst = &is->is_p_region->parameter.sensor.frame_rate;
-	src = &is->cfg_param[is->scenario_id].sensor.frame_rate;
+	src = &is->config[is->config_index].sensor.frame_rate;
 	__hw_param_copy(dst, src);
 }
 
 int __fimc_is_hw_update_param(struct fimc_is *is, u32 offset)
 {
 	struct is_param_region *par = &is->is_p_region->parameter;
-	struct is_config_param *cfg = &is->cfg_param[is->scenario_id];
+	struct chain_config *cfg = &is->config[is->config_index];
 
 	switch (offset) {
 	case PARAM_ISP_CONTROL:
@@ -163,7 +163,7 @@ int __fimc_is_hw_update_param(struct fimc_is *is, u32 offset)
 
 unsigned int __get_pending_param_count(struct fimc_is *is)
 {
-	struct is_config_param *config = &is->cfg_param[is->scenario_id];
+	struct chain_config *config = &is->config[is->config_index];
 	unsigned long flags;
 	unsigned int count;
 
@@ -180,9 +180,9 @@ int __is_hw_update_params(struct fimc_is *is)
 	unsigned long *p_index1, *p_index2;
 	int i, id, ret = 0;
 
-	id = is->scenario_id;
-	p_index1 = &is->cfg_param[id].p_region_index1;
-	p_index2 = &is->cfg_param[id].p_region_index2;
+	id = is->config_index;
+	p_index1 = &is->config[id].p_region_index1;
+	p_index2 = &is->config[id].p_region_index2;
 
 	if (test_bit(PARAM_GLOBAL_SHOTMODE, p_index1))
 		__fimc_is_hw_update_param_global_shotmode(is);
@@ -212,22 +212,21 @@ void __is_get_frame_size(struct fimc_is *is, struct v4l2_mbus_framefmt *mf)
 {
 	struct isp_param *isp;
 
-	isp = &is->cfg_param[is->scenario_id].isp;
+	isp = &is->config[is->config_index].isp;
 	mf->width = isp->otf_input.width;
 	mf->height = isp->otf_input.height;
 }
 
 void __is_set_frame_size(struct fimc_is *is, struct v4l2_mbus_framefmt *mf)
 {
+	unsigned int index = is->config_index;
 	struct isp_param *isp;
 	struct drc_param *drc;
 	struct fd_param *fd;
-	unsigned int mode;
 
-	mode = is->scenario_id;
-	isp = &is->cfg_param[mode].isp;
-	drc = &is->cfg_param[mode].drc;
-	fd = &is->cfg_param[mode].fd;
+	isp = &is->config[index].isp;
+	drc = &is->config[index].drc;
+	fd = &is->config[index].fd;
 
 	/* Update isp size info (OTF only) */
 	isp->otf_input.width = mf->width;
@@ -244,7 +243,7 @@ void __is_set_frame_size(struct fimc_is *is, struct v4l2_mbus_framefmt *mf)
 	fd->otf_input.height = mf->height;
 
 	if (test_bit(PARAM_ISP_OTF_INPUT,
-		      &is->cfg_param[mode].p_region_index1))
+		      &is->config[index].p_region_index1))
 		return;
 
 	/* Update field */
@@ -267,14 +266,14 @@ int fimc_is_hw_get_sensor_max_framerate(struct fimc_is *is)
 
 void __is_set_sensor(struct fimc_is *is, int fps)
 {
+	unsigned int index = is->config_index;
 	struct sensor_param *sensor;
 	struct isp_param *isp;
-	unsigned long *p_index, mode;
+	unsigned long *p_index;
 
-	mode = is->scenario_id;
-	p_index = &is->cfg_param[mode].p_region_index1;
-	sensor = &is->cfg_param[mode].sensor;
-	isp = &is->cfg_param[mode].isp;
+	p_index = &is->config[index].p_region_index1;
+	sensor = &is->config[index].sensor;
+	isp = &is->config[index].isp;
 
 	if (fps == 0) {
 		sensor->frame_rate.frame_rate =
@@ -298,7 +297,7 @@ void __is_set_init_isp_aa(struct fimc_is *is)
 {
 	struct isp_param *isp;
 
-	isp = &is->cfg_param[is->scenario_id].isp;
+	isp = &is->config[is->config_index].isp;
 
 	isp->aa.cmd = ISP_AA_COMMAND_START;
 	isp->aa.target = ISP_AA_TARGET_AF | ISP_AA_TARGET_AE |
@@ -317,8 +316,8 @@ void __is_set_init_isp_aa(struct fimc_is *is)
 
 void __is_set_isp_flash(struct fimc_is *is, u32 cmd, u32 redeye)
 {
-	unsigned int mode = is->scenario_id;
-	struct is_config_param *cfg = &is->cfg_param[mode];
+	unsigned int index = is->config_index;
+	struct chain_config *cfg = &is->config[index];
 	struct isp_param *isp = &cfg->isp;
 
 	isp->flash.cmd = cmd;
@@ -331,12 +330,12 @@ void __is_set_isp_flash(struct fimc_is *is, u32 cmd, u32 redeye)
 
 void __is_set_isp_awb(struct fimc_is *is, u32 cmd, u32 val)
 {
-	unsigned int mode = is->scenario_id;
+	unsigned int index = is->config_index;
 	struct isp_param *isp;
 	unsigned long *p_index;
 
-	p_index = &is->cfg_param[mode].p_region_index1;
-	isp = &is->cfg_param[mode].isp;
+	p_index = &is->config[index].p_region_index1;
+	isp = &is->config[index].isp;
 
 	isp->awb.cmd = cmd;
 	isp->awb.illumination = val;
@@ -348,12 +347,12 @@ void __is_set_isp_awb(struct fimc_is *is, u32 cmd, u32 val)
 
 void __is_set_isp_effect(struct fimc_is *is, u32 cmd)
 {
-	unsigned int mode = is->scenario_id;
+	unsigned int index = is->config_index;
 	struct isp_param *isp;
 	unsigned long *p_index;
 
-	p_index = &is->cfg_param[mode].p_region_index1;
-	isp = &is->cfg_param[mode].isp;
+	p_index = &is->config[index].p_region_index1;
+	isp = &is->config[index].isp;
 
 	isp->effect.cmd = cmd;
 	isp->effect.err = ISP_IMAGE_EFFECT_ERROR_NONE;
@@ -364,12 +363,12 @@ void __is_set_isp_effect(struct fimc_is *is, u32 cmd)
 
 void __is_set_isp_iso(struct fimc_is *is, u32 cmd, u32 val)
 {
-	unsigned int mode = is->scenario_id;
+	unsigned int index = is->config_index;
 	struct isp_param *isp;
 	unsigned long *p_index;
 
-	p_index = &is->cfg_param[mode].p_region_index1;
-	isp = &is->cfg_param[mode].isp;
+	p_index = &is->config[index].p_region_index1;
+	isp = &is->config[index].isp;
 
 	isp->iso.cmd = cmd;
 	isp->iso.value = val;
@@ -381,12 +380,12 @@ void __is_set_isp_iso(struct fimc_is *is, u32 cmd, u32 val)
 
 void __is_set_isp_adjust(struct fimc_is *is, u32 cmd, u32 val)
 {
-	unsigned int mode = is->scenario_id;
+	unsigned int index = is->config_index;
 	unsigned long *p_index;
 	struct isp_param *isp;
 
-	p_index = &is->cfg_param[mode].p_region_index1;
-	isp = &is->cfg_param[mode].isp;
+	p_index = &is->config[index].p_region_index1;
+	isp = &is->config[index].isp;
 
 	switch (cmd) {
 	case ISP_ADJUST_COMMAND_MANUAL_CONTRAST:
@@ -428,12 +427,12 @@ void __is_set_isp_adjust(struct fimc_is *is, u32 cmd, u32 val)
 
 void __is_set_isp_metering(struct fimc_is *is, u32 id, u32 val)
 {
+	unsigned int index = is->config_index;
 	struct isp_param *isp;
-	unsigned long *p_index, mode;
+	unsigned long *p_index;
 
-	mode = is->scenario_id;
-	p_index = &is->cfg_param[mode].p_region_index1;
-	isp = &is->cfg_param[mode].isp;
+	p_index = &is->config[index].p_region_index1;
+	isp = &is->config[index].isp;
 
 	switch (id) {
 	case IS_METERING_CONFIG_CMD:
@@ -463,12 +462,12 @@ void __is_set_isp_metering(struct fimc_is *is, u32 id, u32 val)
 
 void __is_set_isp_afc(struct fimc_is *is, u32 cmd, u32 val)
 {
+	unsigned int index = is->config_index;
 	struct isp_param *isp;
-	unsigned long *p_index, mode;
+	unsigned long *p_index;
 
-	mode = is->scenario_id;
-	p_index = &is->cfg_param[mode].p_region_index1;
-	isp = &is->cfg_param[mode].isp;
+	p_index = &is->config[index].p_region_index1;
+	isp = &is->config[index].isp;
 
 	isp->afc.cmd = cmd;
 	isp->afc.manual = val;
@@ -480,12 +479,12 @@ void __is_set_isp_afc(struct fimc_is *is, u32 cmd, u32 val)
 
 void __is_set_drc_control(struct fimc_is *is, u32 val)
 {
+	unsigned int index = is->config_index;
 	struct drc_param *drc;
-	unsigned long *p_index, mode;
+	unsigned long *p_index;
 
-	mode = is->scenario_id;
-	p_index = &is->cfg_param[mode].p_region_index1;
-	drc = &is->cfg_param[mode].drc;
+	p_index = &is->config[index].p_region_index1;
+	drc = &is->config[index].drc;
 
 	drc->control.bypass = val;
 
@@ -495,12 +494,12 @@ void __is_set_drc_control(struct fimc_is *is, u32 val)
 
 void __is_set_fd_control(struct fimc_is *is, u32 val)
 {
+	unsigned int index = is->config_index;
 	struct fd_param *fd;
-	unsigned long *p_index, mode;
+	unsigned long *p_index;
 
-	mode = is->scenario_id;
-	p_index = &is->cfg_param[mode].p_region_index2;
-	fd = &is->cfg_param[mode].fd;
+	p_index = &is->config[index].p_region_index2;
+	fd = &is->config[index].fd;
 
 	fd->control.cmd = val;
 
@@ -510,12 +509,12 @@ void __is_set_fd_control(struct fimc_is *is, u32 val)
 
 void __is_set_fd_config_maxface(struct fimc_is *is, u32 val)
 {
+	unsigned int index = is->config_index;
 	struct fd_param *fd;
-	unsigned long *p_index, mode;
+	unsigned long *p_index;
 
-	mode = is->scenario_id;
-	p_index = &is->cfg_param[mode].p_region_index2;
-	fd = &is->cfg_param[mode].fd;
+	p_index = &is->config[index].p_region_index2;
+	fd = &is->config[index].fd;
 
 	fd->config.max_number = val;
 
@@ -530,12 +529,12 @@ void __is_set_fd_config_maxface(struct fimc_is *is, u32 val)
 
 void __is_set_fd_config_rollangle(struct fimc_is *is, u32 val)
 {
+	unsigned int index = is->config_index;
 	struct fd_param *fd;
-	unsigned long *p_index, mode;
+	unsigned long *p_index;
 
-	mode = is->scenario_id;
-	p_index = &is->cfg_param[mode].p_region_index2;
-	fd = &is->cfg_param[mode].fd;
+	p_index = &is->config[index].p_region_index2;
+	fd = &is->config[index].fd;
 
 	fd->config.roll_angle = val;
 
@@ -550,12 +549,12 @@ void __is_set_fd_config_rollangle(struct fimc_is *is, u32 val)
 
 void __is_set_fd_config_yawangle(struct fimc_is *is, u32 val)
 {
+	unsigned int index = is->config_index;
 	struct fd_param *fd;
-	unsigned long *p_index, mode;
+	unsigned long *p_index;
 
-	mode = is->scenario_id;
-	p_index = &is->cfg_param[mode].p_region_index2;
-	fd = &is->cfg_param[mode].fd;
+	p_index = &is->config[index].p_region_index2;
+	fd = &is->config[index].fd;
 
 	fd->config.yaw_angle = val;
 
@@ -570,12 +569,12 @@ void __is_set_fd_config_yawangle(struct fimc_is *is, u32 val)
 
 void __is_set_fd_config_smilemode(struct fimc_is *is, u32 val)
 {
+	unsigned int index = is->config_index;
 	struct fd_param *fd;
-	unsigned long *p_index, mode;
+	unsigned long *p_index;
 
-	mode = is->scenario_id;
-	p_index = &is->cfg_param[mode].p_region_index2;
-	fd = &is->cfg_param[mode].fd;
+	p_index = &is->config[index].p_region_index2;
+	fd = &is->config[index].fd;
 
 	fd->config.smile_mode = val;
 
@@ -590,12 +589,12 @@ void __is_set_fd_config_smilemode(struct fimc_is *is, u32 val)
 
 void __is_set_fd_config_blinkmode(struct fimc_is *is, u32 val)
 {
+	unsigned int index = is->config_index;
 	struct fd_param *fd;
-	unsigned long *p_index, mode;
+	unsigned long *p_index;
 
-	mode = is->scenario_id;
-	p_index = &is->cfg_param[mode].p_region_index2;
-	fd = &is->cfg_param[mode].fd;
+	p_index = &is->config[index].p_region_index2;
+	fd = &is->config[index].fd;
 
 	fd->config.blink_mode = val;
 
@@ -610,12 +609,12 @@ void __is_set_fd_config_blinkmode(struct fimc_is *is, u32 val)
 
 void __is_set_fd_config_eyedetect(struct fimc_is *is, u32 val)
 {
+	unsigned int index = is->config_index;
 	struct fd_param *fd;
-	unsigned long *p_index, mode;
+	unsigned long *p_index;
 
-	mode = is->scenario_id;
-	p_index = &is->cfg_param[mode].p_region_index2;
-	fd = &is->cfg_param[mode].fd;
+	p_index = &is->config[index].p_region_index2;
+	fd = &is->config[index].fd;
 
 	fd->config.eye_detect = val;
 
@@ -630,12 +629,12 @@ void __is_set_fd_config_eyedetect(struct fimc_is *is, u32 val)
 
 void __is_set_fd_config_mouthdetect(struct fimc_is *is, u32 val)
 {
+	unsigned int index = is->config_index;
 	struct fd_param *fd;
-	unsigned long *p_index, mode;
+	unsigned long *p_index;
 
-	mode = is->scenario_id;
-	p_index = &is->cfg_param[mode].p_region_index2;
-	fd = &is->cfg_param[mode].fd;
+	p_index = &is->config[index].p_region_index2;
+	fd = &is->config[index].fd;
 
 	fd->config.mouth_detect = val;
 
@@ -650,12 +649,12 @@ void __is_set_fd_config_mouthdetect(struct fimc_is *is, u32 val)
 
 void __is_set_fd_config_orientation(struct fimc_is *is, u32 val)
 {
+	unsigned int index = is->config_index;
 	struct fd_param *fd;
-	unsigned long *p_index, mode;
+	unsigned long *p_index;
 
-	mode = is->scenario_id;
-	p_index = &is->cfg_param[mode].p_region_index2;
-	fd = &is->cfg_param[mode].fd;
+	p_index = &is->config[index].p_region_index2;
+	fd = &is->config[index].fd;
 
 	fd->config.orientation = val;
 
@@ -670,12 +669,12 @@ void __is_set_fd_config_orientation(struct fimc_is *is, u32 val)
 
 void __is_set_fd_config_orientation_val(struct fimc_is *is, u32 val)
 {
+	unsigned int index = is->config_index;
 	struct fd_param *fd;
-	unsigned long *p_index, mode;
+	unsigned long *p_index;
 
-	mode = is->scenario_id;
-	p_index = &is->cfg_param[mode].p_region_index2;
-	fd = &is->cfg_param[mode].fd;
+	p_index = &is->config[index].p_region_index2;
+	fd = &is->config[index].fd;
 
 	fd->config.orientation_value = val;
 
@@ -696,16 +695,16 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 	struct drc_param *drc;
 	struct fd_param *fd;
 	unsigned long *p_index1, *p_index2;
-	unsigned int mode;
+	unsigned int index;
 
-	mode = is->scenario_id;
-	global = &is->cfg_param[mode].global;
-	sensor = &is->cfg_param[mode].sensor;
-	isp = &is->cfg_param[mode].isp;
-	drc = &is->cfg_param[mode].drc;
-	fd = &is->cfg_param[mode].fd;
-	p_index1 = &is->cfg_param[mode].p_region_index1;
-	p_index2 = &is->cfg_param[mode].p_region_index2;
+	index = is->config_index;
+	global = &is->config[index].global;
+	sensor = &is->config[index].sensor;
+	isp = &is->config[index].isp;
+	drc = &is->config[index].drc;
+	fd = &is->config[index].fd;
+	p_index1 = &is->config[index].p_region_index1;
+	p_index2 = &is->config[index].p_region_index2;
 
 	/* Global */
 	global->shotmode.cmd = 1;
@@ -841,7 +840,7 @@ void fimc_is_set_initial_params(struct fimc_is *is)
 
 	/* Sensor */
 	if (!test_bit(PARAM_SENSOR_FRAME_RATE, p_index1)) {
-		if (!mode)
+		if (is->config_index == 0)
 			__is_set_sensor(is, 0);
 	}
 
diff --git a/drivers/media/platform/exynos4-is/fimc-is-regs.c b/drivers/media/platform/exynos4-is/fimc-is-regs.c
index f59a289..b0ff67b 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-regs.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-regs.c
@@ -79,18 +79,18 @@ int fimc_is_hw_wait_intmsr0_intmsd0(struct fimc_is *is)
 
 int fimc_is_hw_set_param(struct fimc_is *is)
 {
-	struct is_config_param *cfg = &is->cfg_param[is->scenario_id];
+	struct chain_config *config = &is->config[is->config_index];
 	unsigned int param_count = __get_pending_param_count(is);
 
 	fimc_is_hw_wait_intmsr0_intmsd0(is);
 
 	mcuctl_write(HIC_SET_PARAMETER, is, MCUCTL_REG_ISSR(0));
 	mcuctl_write(is->sensor_index, is, MCUCTL_REG_ISSR(1));
-	mcuctl_write(is->scenario_id, is, MCUCTL_REG_ISSR(2));
+	mcuctl_write(is->config_index, is, MCUCTL_REG_ISSR(2));
 
 	mcuctl_write(param_count, is, MCUCTL_REG_ISSR(3));
-	mcuctl_write(cfg->p_region_index1, is, MCUCTL_REG_ISSR(4));
-	mcuctl_write(cfg->p_region_index2, is, MCUCTL_REG_ISSR(5));
+	mcuctl_write(config->p_region_index1, is, MCUCTL_REG_ISSR(4));
+	mcuctl_write(config->p_region_index2, is, MCUCTL_REG_ISSR(5));
 
 	fimc_is_hw_set_intgr0_gd0(is);
 	return 0;
@@ -174,10 +174,10 @@ int fimc_is_hw_change_mode(struct fimc_is *is)
 		HIC_CAPTURE_STILL, HIC_CAPTURE_VIDEO,
 	};
 
-	if (WARN_ON(is->scenario_id > ARRAY_SIZE(cmd)))
+	if (WARN_ON(is->config_index > ARRAY_SIZE(cmd)))
 		return -EINVAL;
 
-	mcuctl_write(cmd[is->scenario_id], is, MCUCTL_REG_ISSR(0));
+	mcuctl_write(cmd[is->config_index], is, MCUCTL_REG_ISSR(0));
 	mcuctl_write(is->sensor_index, is, MCUCTL_REG_ISSR(1));
 	mcuctl_write(is->setfile.sub_index, is, MCUCTL_REG_ISSR(2));
 	fimc_is_hw_set_intgr0_gd0(is);
@@ -238,6 +238,6 @@ int fimc_is_itf_mode_change(struct fimc_is *is)
 				FIMC_IS_CONFIG_TIMEOUT);
 	if (!ret < 0)
 		dev_err(&is->pdev->dev, "%s(): mode change (%d) timeout\n",
-			__func__, is->scenario_id);
+			__func__, is->config_index);
 	return ret;
 }
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 10ec173..3c81c88 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -530,8 +530,8 @@ static void fimc_is_general_irq_handler(struct fimc_is *is)
 			break;
 
 		case HIC_SET_PARAMETER:
-			is->cfg_param[is->scenario_id].p_region_index1 = 0;
-			is->cfg_param[is->scenario_id].p_region_index2 = 0;
+			is->config[is->config_index].p_region_index1 = 0;
+			is->config[is->config_index].p_region_index2 = 0;
 			set_bit(IS_ST_BLOCK_CMD_CLEARED, &is->state);
 			pr_debug("HIC_SET_PARAMETER\n");
 			break;
@@ -590,8 +590,8 @@ static void fimc_is_general_irq_handler(struct fimc_is *is)
 
 		switch (is->i2h_cmd.args[0]) {
 		case HIC_SET_PARAMETER:
-			is->cfg_param[is->scenario_id].p_region_index1 = 0;
-			is->cfg_param[is->scenario_id].p_region_index2 = 0;
+			is->config[is->config_index].p_region_index1 = 0;
+			is->config[is->config_index].p_region_index2 = 0;
 			set_bit(IS_ST_BLOCK_CMD_CLEARED, &is->state);
 			break;
 		}
@@ -656,7 +656,7 @@ static int fimc_is_hw_open_sensor(struct fimc_is *is,
 
 int fimc_is_hw_initialize(struct fimc_is *is)
 {
-	const int scenario_ids[] = {
+	const int config_ids[] = {
 		IS_SC_PREVIEW_STILL, IS_SC_PREVIEW_VIDEO,
 		IS_SC_CAPTURE_STILL, IS_SC_CAPTURE_VIDEO
 	};
@@ -718,23 +718,23 @@ int fimc_is_hw_initialize(struct fimc_is *is)
 	}
 
 	/* Preserve previous mode. */
-	prev_id = is->scenario_id;
+	prev_id = is->config_index;
 
 	/* Set initial parameter values. */
-	for (i = 0; i < ARRAY_SIZE(scenario_ids); i++) {
-		is->scenario_id = scenario_ids[i];
+	for (i = 0; i < ARRAY_SIZE(config_ids); i++) {
+		is->config_index = config_ids[i];
 		fimc_is_set_initial_params(is);
 		ret = fimc_is_itf_s_param(is, true);
 		if (ret < 0) {
-			is->scenario_id = prev_id;
+			is->config_index = prev_id;
 			return ret;
 		}
 	}
-	is->scenario_id = prev_id;
+	is->config_index = prev_id;
 
 	set_bit(IS_ST_INIT_DONE, &is->state);
 	dev_info(dev, "initialization sequence completed (%d)\n",
-						is->scenario_id);
+						is->config_index);
 	return 0;
 }
 
diff --git a/drivers/media/platform/exynos4-is/fimc-is.h b/drivers/media/platform/exynos4-is/fimc-is.h
index 9406894..f5275a5 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.h
+++ b/drivers/media/platform/exynos4-is/fimc-is.h
@@ -219,7 +219,7 @@ struct fimc_is_setfile {
 	u32 base;
 };
 
-struct is_config_param {
+struct chain_config {
 	struct global_param	global;
 	struct sensor_param	sensor;
 	struct isp_param	isp;
@@ -279,12 +279,13 @@ struct fimc_is {
 	struct h2i_cmd			h2i_cmd;
 	struct is_fd_result_header	fd_header;
 
-	struct is_config_param		cfg_param[IS_SC_MAX];
+	struct chain_config		config[IS_SC_MAX];
+	unsigned			config_index;
+
 	struct is_region		*is_p_region;
 	dma_addr_t			is_dma_p_region;
 	struct is_share_region		*is_shared_region;
 	struct is_af_info		af;
-	u32				scenario_id;
 
 	struct dentry			*debugfs_entry;
 };
@@ -301,7 +302,7 @@ static inline void fimc_is_mem_barrier(void)
 
 static inline void fimc_is_set_param_bit(struct fimc_is *is, int num)
 {
-	struct is_config_param *cfg = &is->cfg_param[is->scenario_id];
+	struct chain_config *cfg = &is->config[is->config_index];
 
 	if (num >= 32)
 		set_bit(num - 32, &cfg->p_region_index2);
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c
index b11c001..7b8fbab 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp.c
@@ -236,7 +236,7 @@ static int fimc_isp_subdev_s_stream(struct v4l2_subdev *sd, int on)
 		}
 
 		v4l2_dbg(1, debug, sd, "changing mode to %d\n",
-						is->scenario_id);
+						is->config_index);
 		ret = fimc_is_itf_mode_change(is);
 		if (ret)
 			return -EINVAL;
@@ -317,8 +317,8 @@ static int fimc_isp_subdev_s_power(struct v4l2_subdev *sd, int on)
 		clear_bit(IS_ST_PWR_ON, &is->state);
 		clear_bit(IS_ST_INIT_DONE, &is->state);
 		is->state = 0;
-		is->cfg_param[is->scenario_id].p_region_index1 = 0;
-		is->cfg_param[is->scenario_id].p_region_index2 = 0;
+		is->config[is->config_index].p_region_index1 = 0;
+		is->config[is->config_index].p_region_index2 = 0;
 		set_bit(IS_ST_IDLE, &is->state);
 		wmb();
 	}
-- 
1.7.9.5

