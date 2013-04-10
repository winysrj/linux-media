Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:23261 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936557Ab3DJKo3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 06:44:29 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
	shaik.samsung@gmail.com, arun.kk@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 6/7] exynos4-is: Remove meaningless test before bit setting
Date: Wed, 10 Apr 2013 12:42:41 +0200
Message-id: <1365590562-5747-7-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1365590562-5747-1-git-send-email-s.nawrocki@samsung.com>
References: <1365590562-5747-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to check same bit before setting it, since we
always end up with a bit set. Remove some of the tests and make
set unconditional, in every place where all that needs to be done
is just setting a bit.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is-param.c |   40 +++++----------------
 1 file changed, 9 insertions(+), 31 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is-param.c b/drivers/media/platform/exynos4-is/fimc-is-param.c
index 254740f..53fe2a2 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-param.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-param.c
@@ -269,9 +269,7 @@ void __is_set_sensor(struct fimc_is *is, int fps)
 	unsigned int index = is->config_index;
 	struct sensor_param *sensor;
 	struct isp_param *isp;
-	unsigned long *p_index;
 
-	p_index = &is->config[index].p_region_index1;
 	sensor = &is->config[index].sensor;
 	isp = &is->config[index].isp;
 
@@ -286,11 +284,8 @@ void __is_set_sensor(struct fimc_is *is, int fps)
 		isp->otf_input.frametime_max = (u32)1000000 / fps;
 	}
 
-	if (!test_bit(PARAM_SENSOR_FRAME_RATE, p_index))
-		fimc_is_set_param_bit(is, PARAM_SENSOR_FRAME_RATE);
-
-	if (!test_bit(PARAM_ISP_OTF_INPUT, p_index))
-		fimc_is_set_param_bit(is, PARAM_ISP_OTF_INPUT);
+	fimc_is_set_param_bit(is, PARAM_SENSOR_FRAME_RATE);
+	fimc_is_set_param_bit(is, PARAM_ISP_OTF_INPUT);
 }
 
 void __is_set_init_isp_aa(struct fimc_is *is)
@@ -317,65 +312,54 @@ void __is_set_init_isp_aa(struct fimc_is *is)
 void __is_set_isp_flash(struct fimc_is *is, u32 cmd, u32 redeye)
 {
 	unsigned int index = is->config_index;
-	struct chain_config *cfg = &is->config[index];
-	struct isp_param *isp = &cfg->isp;
+	struct isp_param *isp = &is->config[index].isp;
 
 	isp->flash.cmd = cmd;
 	isp->flash.redeye = redeye;
 	isp->flash.err = ISP_FLASH_ERROR_NONE;
 
-	if (!test_bit(PARAM_ISP_FLASH, &cfg->p_region_index1))
-		fimc_is_set_param_bit(is, PARAM_ISP_FLASH);
+	fimc_is_set_param_bit(is, PARAM_ISP_FLASH);
 }
 
 void __is_set_isp_awb(struct fimc_is *is, u32 cmd, u32 val)
 {
 	unsigned int index = is->config_index;
 	struct isp_param *isp;
-	unsigned long *p_index;
 
-	p_index = &is->config[index].p_region_index1;
 	isp = &is->config[index].isp;
 
 	isp->awb.cmd = cmd;
 	isp->awb.illumination = val;
 	isp->awb.err = ISP_AWB_ERROR_NONE;
 
-	if (!test_bit(PARAM_ISP_AWB, p_index))
-		fimc_is_set_param_bit(is, PARAM_ISP_AWB);
+	fimc_is_set_param_bit(is, PARAM_ISP_AWB);
 }
 
 void __is_set_isp_effect(struct fimc_is *is, u32 cmd)
 {
 	unsigned int index = is->config_index;
 	struct isp_param *isp;
-	unsigned long *p_index;
 
-	p_index = &is->config[index].p_region_index1;
 	isp = &is->config[index].isp;
 
 	isp->effect.cmd = cmd;
 	isp->effect.err = ISP_IMAGE_EFFECT_ERROR_NONE;
 
-	if (!test_bit(PARAM_ISP_IMAGE_EFFECT, p_index))
-		fimc_is_set_param_bit(is, PARAM_ISP_IMAGE_EFFECT);
+	fimc_is_set_param_bit(is, PARAM_ISP_IMAGE_EFFECT);
 }
 
 void __is_set_isp_iso(struct fimc_is *is, u32 cmd, u32 val)
 {
 	unsigned int index = is->config_index;
 	struct isp_param *isp;
-	unsigned long *p_index;
 
-	p_index = &is->config[index].p_region_index1;
 	isp = &is->config[index].isp;
 
 	isp->iso.cmd = cmd;
 	isp->iso.value = val;
 	isp->iso.err = ISP_ISO_ERROR_NONE;
 
-	if (!test_bit(PARAM_ISP_ISO, p_index))
-		fimc_is_set_param_bit(is, PARAM_ISP_ISO);
+	fimc_is_set_param_bit(is, PARAM_ISP_ISO);
 }
 
 void __is_set_isp_adjust(struct fimc_is *is, u32 cmd, u32 val)
@@ -464,32 +448,26 @@ void __is_set_isp_afc(struct fimc_is *is, u32 cmd, u32 val)
 {
 	unsigned int index = is->config_index;
 	struct isp_param *isp;
-	unsigned long *p_index;
 
-	p_index = &is->config[index].p_region_index1;
 	isp = &is->config[index].isp;
 
 	isp->afc.cmd = cmd;
 	isp->afc.manual = val;
 	isp->afc.err = ISP_AFC_ERROR_NONE;
 
-	if (!test_bit(PARAM_ISP_AFC, p_index))
-		fimc_is_set_param_bit(is, PARAM_ISP_AFC);
+	fimc_is_set_param_bit(is, PARAM_ISP_AFC);
 }
 
 void __is_set_drc_control(struct fimc_is *is, u32 val)
 {
 	unsigned int index = is->config_index;
 	struct drc_param *drc;
-	unsigned long *p_index;
 
-	p_index = &is->config[index].p_region_index1;
 	drc = &is->config[index].drc;
 
 	drc->control.bypass = val;
 
-	if (!test_bit(PARAM_DRC_CONTROL, p_index))
-		fimc_is_set_param_bit(is, PARAM_DRC_CONTROL);
+	fimc_is_set_param_bit(is, PARAM_DRC_CONTROL);
 }
 
 void __is_set_fd_control(struct fimc_is *is, u32 val)
-- 
1.7.9.5

