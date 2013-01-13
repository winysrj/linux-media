Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:25070 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab3AMMak (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jan 2013 07:30:40 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGK007KKDEY6Y20@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Sun, 13 Jan 2013 21:30:39 +0900 (KST)
Received: from chrome-ubuntu.sisodomain.com ([107.108.73.106])
 by mmp2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MGK00B86DEGTC60@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 13 Jan 2013 21:30:38 +0900 (KST)
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: tomi.valkeinen@ti.com, laurent.pinchart@ideasonboard.com,
	inki.dae@samsung.com, r.sh.open@gmail.com, joshi@samsung.com
Subject: [RFC PATCH 3/4] drm/exynos: moved drm hdmi driver to cdf framework
Date: Sun, 13 Jan 2013 07:52:13 -0500
Message-id: <1358081534-21372-4-git-send-email-rahul.sharma@samsung.com>
In-reply-to: <1358081534-21372-1-git-send-email-rahul.sharma@samsung.com>
References: <1358081534-21372-1-git-send-email-rahul.sharma@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch implements exynos_hdmi_cdf.c which is a glue component between
exynos DRM and hdmi cdf panel. It is a platform driver register through
exynos_drm_drv.c. Exynos_hdmi.c is modified to register hdmi as display panel.
exynos_hdmi_cdf.c registers for exynos hdmi display entity and if successful,
proceeds for mode setting.

Signed-off-by: Rahul Sharma <rahul.sharma@samsung.com>
---
 drivers/gpu/drm/exynos/Kconfig           |   6 +
 drivers/gpu/drm/exynos/Makefile          |   1 +
 drivers/gpu/drm/exynos/exynos_drm_drv.c  |  24 ++
 drivers/gpu/drm/exynos/exynos_drm_drv.h  |   1 +
 drivers/gpu/drm/exynos/exynos_hdmi.c     | 446 ++++++++++++++++---------------
 drivers/gpu/drm/exynos/exynos_hdmi_cdf.c | 370 +++++++++++++++++++++++++
 include/video/exynos_hdmi.h              |  25 ++
 7 files changed, 659 insertions(+), 214 deletions(-)
 create mode 100644 drivers/gpu/drm/exynos/exynos_hdmi_cdf.c
 create mode 100644 include/video/exynos_hdmi.h

diff --git a/drivers/gpu/drm/exynos/Kconfig b/drivers/gpu/drm/exynos/Kconfig
index 1d1f1e5..309e62a 100644
--- a/drivers/gpu/drm/exynos/Kconfig
+++ b/drivers/gpu/drm/exynos/Kconfig
@@ -34,6 +34,12 @@ config DRM_EXYNOS_HDMI
 	help
 	  Choose this option if you want to use Exynos HDMI for DRM.
 
+config DRM_EXYNOS_HDMI_CDF
+	bool "Exynos DRM HDMI using CDF"
+	depends on DRM_EXYNOS_HDMI && DRM_EXYNOS && !VIDEO_SAMSUNG_S5P_TV
+	help
+	  Choose this option if you want to use Exynos HDMI for DRM using CDF.
+
 config DRM_EXYNOS_VIDI
 	bool "Exynos DRM Virtual Display"
 	depends on DRM_EXYNOS
diff --git a/drivers/gpu/drm/exynos/Makefile b/drivers/gpu/drm/exynos/Makefile
index 639b49e..e946ed6 100644
--- a/drivers/gpu/drm/exynos/Makefile
+++ b/drivers/gpu/drm/exynos/Makefile
@@ -20,5 +20,6 @@ exynosdrm-$(CONFIG_DRM_EXYNOS_IPP)	+= exynos_drm_ipp.o
 exynosdrm-$(CONFIG_DRM_EXYNOS_FIMC)	+= exynos_drm_fimc.o
 exynosdrm-$(CONFIG_DRM_EXYNOS_ROTATOR)	+= exynos_drm_rotator.o
 exynosdrm-$(CONFIG_DRM_EXYNOS_GSC)	+= exynos_drm_gsc.o
+exynosdrm-$(CONFIG_DRM_EXYNOS_HDMI_CDF) += exynos_hdmi_cdf.o
 
 obj-$(CONFIG_DRM_EXYNOS)		+= exynosdrm.o
diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
index 56e9a412..423e09c 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
@@ -40,6 +40,9 @@
 /* platform device pointer for eynos drm device. */
 static struct platform_device *exynos_drm_pdev;
 
+/* platform device pointer for eynos hdmi cdf device. */
+static struct platform_device *exynos_hdmi_cdf_pdev;
+
 static int exynos_drm_load(struct drm_device *dev, unsigned long flags)
 {
 	struct exynos_drm_private *private;
@@ -331,6 +334,18 @@ static int __init exynos_drm_init(void)
 #endif
 
 #ifdef CONFIG_DRM_EXYNOS_HDMI
+
+	ret = platform_driver_register(&hdmi_cdf_driver);
+	if (ret < 0)
+		goto out_hdmi_cdf_driver;
+
+	exynos_hdmi_cdf_pdev = platform_device_register_simple(
+		"exynos-hdmi-cdf", -1, NULL, 0);
+	if (IS_ERR_OR_NULL(exynos_hdmi_cdf_pdev)) {
+		ret = PTR_ERR(exynos_hdmi_cdf_pdev);
+		goto out_hdmi_cdf_device;
+	}
+
 	ret = platform_driver_register(&hdmi_driver);
 	if (ret < 0)
 		goto out_hdmi;
@@ -438,6 +453,13 @@ out_common_hdmi:
 out_mixer:
 	platform_driver_unregister(&hdmi_driver);
 out_hdmi:
+
+out_hdmi_cdf_device:
+	platform_device_unregister(exynos_hdmi_cdf_pdev);
+
+out_hdmi_cdf_driver:
+	platform_driver_unregister(&hdmi_cdf_driver);
+
 #endif
 
 #ifdef CONFIG_DRM_EXYNOS_FIMD
@@ -480,6 +502,8 @@ static void __exit exynos_drm_exit(void)
 	platform_driver_unregister(&exynos_drm_common_hdmi_driver);
 	platform_driver_unregister(&mixer_driver);
 	platform_driver_unregister(&hdmi_driver);
+	platform_driver_unregister(&hdmi_cdf_driver);
+	platform_device_unregister(exynos_hdmi_cdf_pdev);
 #endif
 
 #ifdef CONFIG_DRM_EXYNOS_VIDI
diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.h b/drivers/gpu/drm/exynos/exynos_drm_drv.h
index b9e51bc..961fe14 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.h
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.h
@@ -332,6 +332,7 @@ void exynos_platform_device_hdmi_unregister(void);
 extern struct platform_driver fimd_driver;
 extern struct platform_driver hdmi_driver;
 extern struct platform_driver mixer_driver;
+extern struct platform_driver hdmi_cdf_driver;
 extern struct platform_driver exynos_drm_common_hdmi_driver;
 extern struct platform_driver vidi_driver;
 extern struct platform_driver g2d_driver;
diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index f5eb986..ce22e69 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -34,13 +34,12 @@
 #include <linux/regulator/consumer.h>
 #include <linux/io.h>
 #include <linux/of_gpio.h>
+#include <video/display.h>
+#include "video/exynos_hdmi.h"
 #include <plat/gpio-cfg.h>
 
 #include <drm/exynos_drm.h>
 
-#include "exynos_drm_drv.h"
-#include "exynos_drm_hdmi.h"
-
 #include "exynos_hdmi.h"
 
 #include <linux/gpio.h>
@@ -157,14 +156,12 @@ struct hdmi_v14_conf {
 
 struct hdmi_context {
 	struct device			*dev;
-	struct drm_device		*drm_dev;
 	bool				hpd;
 	bool				powered;
 	bool				dvi_mode;
 	struct mutex			hdmi_mutex;
 
 	void __iomem			*regs;
-	void				*parent_ctx;
 	int				external_irq;
 	int				internal_irq;
 
@@ -180,6 +177,7 @@ struct hdmi_context {
 	int				hpd_gpio;
 
 	enum hdmi_type			type;
+	struct display_entity		entity;
 };
 
 /* HDMI Version 1.3 */
@@ -973,39 +971,8 @@ static void hdmi_reg_infoframe(struct hdmi_context *hdata,
 	}
 }
 
-static bool hdmi_is_connected(void *ctx)
-{
-	struct hdmi_context *hdata = ctx;
-
-	return hdata->hpd;
-}
-
-static int hdmi_get_edid(void *ctx, struct drm_connector *connector,
-				u8 *edid, int len)
-{
-	struct edid *raw_edid;
-	struct hdmi_context *hdata = ctx;
-
-	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
-
-	if (!hdata->ddc_port)
-		return -ENODEV;
-
-	raw_edid = drm_get_edid(connector, hdata->ddc_port->adapter);
-	if (raw_edid) {
-		hdata->dvi_mode = !drm_detect_hdmi_monitor(raw_edid);
-		memcpy(edid, raw_edid, min((1 + raw_edid->extensions)
-					* EDID_LENGTH, len));
-		DRM_DEBUG_KMS("%s : width[%d] x height[%d]\n",
-			(hdata->dvi_mode ? "dvi monitor" : "hdmi monitor"),
-			raw_edid->width_cm, raw_edid->height_cm);
-		kfree(raw_edid);
-	} else {
-		return -ENODEV;
-	}
-
-	return 0;
-}
+extern int generic_drm_get_edid(struct i2c_adapter *adapter,
+				struct display_entity_edid *edid);
 
 static int hdmi_v13_check_timing(struct fb_videomode *check_timing)
 {
@@ -1061,22 +1028,6 @@ static int hdmi_v14_check_timing(struct fb_videomode *check_timing)
 	return -EINVAL;
 }
 
-static int hdmi_check_timing(void *ctx, struct fb_videomode *timing)
-{
-	struct hdmi_context *hdata = ctx;
-
-	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
-
-	DRM_DEBUG_KMS("[%d]x[%d] [%d]Hz [%x]\n", timing->xres,
-			timing->yres, timing->refresh,
-			timing->vmode);
-
-	if (hdata->type == HDMI_TYPE13)
-		return hdmi_v13_check_timing(timing);
-	else
-		return hdmi_v14_check_timing(timing);
-}
-
 static void hdmi_set_acr(u32 freq, u8 *acr)
 {
 	u32 n, cts;
@@ -1143,15 +1094,22 @@ static void hdmi_reg_acr(struct hdmi_context *hdata, u8 *acr)
 		hdmi_reg_writeb(hdata, HDMI_ACR_CON, 4);
 }
 
-static void hdmi_audio_init(struct hdmi_context *hdata)
+static void hdmi_spdif_audio_init(struct hdmi_context *hdata,
+		const struct display_entity_audio_params *params)
+{
+		DRM_ERROR("SPDIF AUDIO NOT IMPLEMENTED YET");
+}
+
+static void hdmi_i2s_audio_init(struct hdmi_context *hdata,
+		const struct display_entity_audio_params *params)
 {
 	u32 sample_rate, bits_per_sample, frame_size_code;
 	u32 data_num, bit_ch, sample_frq;
 	u32 val;
 	u8 acr[7];
 
-	sample_rate = 44100;
-	bits_per_sample = 16;
+	sample_rate = params->sf;
+	bits_per_sample = params->bits_per_sample;
 	frame_size_code = 0;
 
 	switch (bits_per_sample) {
@@ -1685,8 +1643,6 @@ static void hdmi_conf_apply(struct hdmi_context *hdata)
 	hdmi_conf_init(hdata);
 	mutex_unlock(&hdata->hdmi_mutex);
 
-	hdmi_audio_init(hdata);
-
 	/* setting core registers */
 	hdmi_timing_apply(hdata);
 	hdmi_audio_control(hdata, true);
@@ -1694,58 +1650,6 @@ static void hdmi_conf_apply(struct hdmi_context *hdata)
 	hdmi_regs_dump(hdata, "start");
 }
 
-static void hdmi_mode_fixup(void *ctx, struct drm_connector *connector,
-				const struct drm_display_mode *mode,
-				struct drm_display_mode *adjusted_mode)
-{
-	struct drm_display_mode *m;
-	struct hdmi_context *hdata = ctx;
-	int index;
-
-	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
-
-	drm_mode_set_crtcinfo(adjusted_mode, 0);
-
-	if (hdata->type == HDMI_TYPE13)
-		index = hdmi_v13_conf_index(adjusted_mode);
-	else
-		index = hdmi_v14_find_phy_conf(adjusted_mode->clock * 1000);
-
-	/* just return if user desired mode exists. */
-	if (index >= 0)
-		return;
-
-	/*
-	 * otherwise, find the most suitable mode among modes and change it
-	 * to adjusted_mode.
-	 */
-	list_for_each_entry(m, &connector->modes, head) {
-		if (hdata->type == HDMI_TYPE13)
-			index = hdmi_v13_conf_index(m);
-		else
-			index = hdmi_v14_find_phy_conf(m->clock * 1000);
-
-		if (index >= 0) {
-			struct drm_mode_object base;
-			struct list_head head;
-
-			DRM_INFO("desired mode doesn't exist so\n");
-			DRM_INFO("use the most suitable mode among modes.\n");
-
-			DRM_DEBUG_KMS("Adjusted Mode: [%d]x[%d] [%d]Hz\n",
-				m->hdisplay, m->vdisplay, m->vrefresh);
-
-			/* preserve display mode header while copying. */
-			head = adjusted_mode->head;
-			base = adjusted_mode->base;
-			memcpy(adjusted_mode, m, sizeof(*m));
-			adjusted_mode->head = head;
-			adjusted_mode->base = base;
-			break;
-		}
-	}
-}
-
 static void hdmi_set_reg(u8 *reg_pair, int num_bytes, u32 value)
 {
 	int i;
@@ -1862,42 +1766,6 @@ static void hdmi_v14_mode_set(struct hdmi_context *hdata,
 
 }
 
-static void hdmi_mode_set(void *ctx, void *mode)
-{
-	struct hdmi_context *hdata = ctx;
-	int conf_idx;
-
-	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
-
-	if (hdata->type == HDMI_TYPE13) {
-		conf_idx = hdmi_v13_conf_index(mode);
-		if (conf_idx >= 0)
-			hdata->cur_conf = conf_idx;
-		else
-			DRM_DEBUG_KMS("not supported mode\n");
-	} else {
-		hdmi_v14_mode_set(hdata, mode);
-	}
-}
-
-static void hdmi_get_max_resol(void *ctx, unsigned int *width,
-					unsigned int *height)
-{
-	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
-
-	*width = MAX_WIDTH;
-	*height = MAX_HEIGHT;
-}
-
-static void hdmi_commit(void *ctx)
-{
-	struct hdmi_context *hdata = ctx;
-
-	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
-
-	hdmi_conf_apply(hdata);
-}
-
 static void hdmi_poweron(struct hdmi_context *hdata)
 {
 	struct hdmi_resources *res = &hdata->res;
@@ -1953,62 +1821,215 @@ out:
 	mutex_unlock(&hdata->hdmi_mutex);
 }
 
-static void hdmi_dpms(void *ctx, int mode)
+int hdmi_get_size(struct display_entity *ent,
+		  unsigned int *width, unsigned int *height)
 {
-	struct hdmi_context *hdata = ctx;
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
 
-	DRM_DEBUG_KMS("[%d] %s mode %d\n", __LINE__, __func__, mode);
+	*width = MAX_WIDTH;
+	*height = MAX_HEIGHT;
 
-	switch (mode) {
-	case DRM_MODE_DPMS_ON:
-		if (pm_runtime_suspended(hdata->dev))
-			pm_runtime_get_sync(hdata->dev);
-		break;
-	case DRM_MODE_DPMS_STANDBY:
-	case DRM_MODE_DPMS_SUSPEND:
-	case DRM_MODE_DPMS_OFF:
+	return 0;
+}
+
+void hdmi_send_hpdevent(struct display_entity *entity, int hpd)
+{
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	display_entity_notify_event_subscriber(entity,
+		DISPLAY_ENTITY_HDMI_HOTPLUG, hpd);
+}
+
+int hdmi_get_hpdstate(struct display_entity *entity, unsigned int *hpd_state)
+{
+	struct hdmi_context *hdata =
+		container_of(entity, struct hdmi_context, entity);
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	if (hpd_state) {
+		*hpd_state = hdata->hpd;
+		return 0;
+	}
+	return -1;
+}
+
+int hdmi_get_edid(struct display_entity *entity,
+	struct display_entity_edid *edid)
+{
+	struct hdmi_context *hdata =
+		container_of(entity, struct hdmi_context, entity);
+	struct edid *raw_edid;
+	int ret;
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	if (!hdata->ddc_port)
+		return -ENODEV;
+
+	ret = generic_drm_get_edid(hdata->ddc_port->adapter, edid);
+	if (ret) {
+		DRM_ERROR("[%d]%s, Edid Read Fail!!! ret = %d\n",
+			__LINE__, __func__, ret);
+		return -EINVAL;
+	}
+
+	raw_edid = (struct edid *)edid->edid;
+
+	if (raw_edid)
+		hdata->dvi_mode = !drm_detect_hdmi_monitor(raw_edid);
+	else
+		return -ENODEV;
+
+	return 0;
+}
+
+int hdmi_check_mode(struct display_entity *entity,
+		   const struct videomode *mode)
+{
+	struct hdmi_context *hdata =
+		container_of(entity, struct hdmi_context, entity);
+	struct fb_videomode *timing = (struct fb_videomode *)mode;
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	DRM_DEBUG_KMS("[%d]x[%d] [%d]Hz [%x]\n", timing->xres,
+			timing->yres, timing->refresh,
+			timing->vmode);
+
+	if (hdata->type == HDMI_TYPE13)
+		return hdmi_v13_check_timing(timing);
+	else
+		return hdmi_v14_check_timing(timing);
+}
+
+int hdmi_set_mode(struct display_entity *entity,
+		   const struct videomode *mode)
+{
+	struct hdmi_context *hdata =
+		container_of(entity, struct hdmi_context, entity);
+	struct drm_display_mode *m = (struct drm_display_mode *)mode;
+	int conf_idx;
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	if (hdata->type == HDMI_TYPE13) {
+		conf_idx = hdmi_v13_conf_index(m);
+		if (conf_idx >= 0)
+			hdata->cur_conf = conf_idx;
+		else
+			DRM_DEBUG_KMS("not supported mode\n");
+	} else {
+		hdmi_v14_mode_set(hdata, m);
+	}
+
+	return 0;
+}
+
+int hdmi_update(struct display_entity *entity)
+{
+	struct hdmi_context *hdata =
+		container_of(entity, struct hdmi_context, entity);
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	hdmi_conf_apply(hdata);
+	return 0;
+}
+
+int hdmi_set_state(struct display_entity *entity,
+		   enum display_entity_state state)
+{
+	struct hdmi_context *hdata =
+		container_of(entity, struct hdmi_context, entity);
+
+	DRM_DEBUG_KMS("[%d] %s %d\n", __LINE__, __func__, state);
+
+	switch (state) {
+	case DISPLAY_ENTITY_STATE_OFF:
+	case DISPLAY_ENTITY_STATE_STANDBY:
 		if (!pm_runtime_suspended(hdata->dev))
 			pm_runtime_put_sync(hdata->dev);
 		break;
-	default:
-		DRM_DEBUG_KMS("unknown dpms mode: %d\n", mode);
+
+	case DISPLAY_ENTITY_STATE_ON:
+		if (pm_runtime_suspended(hdata->dev))
+			pm_runtime_get_sync(hdata->dev);
 		break;
+	default:
+		return -EINVAL;
 	}
+	return 0;
 }
 
-static struct exynos_hdmi_ops hdmi_ops = {
-	/* display */
-	.is_connected	= hdmi_is_connected,
-	.get_edid	= hdmi_get_edid,
-	.check_timing	= hdmi_check_timing,
-
-	/* manager */
-	.mode_fixup	= hdmi_mode_fixup,
-	.mode_set	= hdmi_mode_set,
-	.get_max_resol	= hdmi_get_max_resol,
-	.commit		= hdmi_commit,
-	.dpms		= hdmi_dpms,
+int hdmi_init_audio(struct display_entity *entity,
+		const struct display_entity_audio_params *params)
+{
+	struct hdmi_context *hdata =
+		container_of(entity, struct hdmi_context, entity);
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	if (params->type == DISPLAY_ENTITY_AUDIO_I2S)
+		hdmi_i2s_audio_init(hdata, params);
+	else if (params->type == DISPLAY_ENTITY_AUDIO_SPDIF)
+		hdmi_spdif_audio_init(hdata, params);
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+
+int hdmi_set_audiostate(struct display_entity *entity,
+		enum display_entity_audiostate state)
+{
+	struct hdmi_context *hdata =
+		container_of(entity, struct hdmi_context, entity);
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	if (state == DISPLAY_ENTITY_AUDIOSTATE_ON)
+		hdmi_audio_control(hdata, true);
+	else
+		hdmi_audio_control(hdata, false);
+
+	return 0;
+}
+
+struct display_entity_control_ops entity_ctrl_ops = {
+	.get_size		= hdmi_get_size,
+	.update		= hdmi_update,
+	.set_state	= hdmi_set_state,
+	.set_mode		= hdmi_set_mode,
+};
+
+struct display_entity_hdmi_control_ops hdmi_ctrl_ops = {
+	.get_edid		= hdmi_get_edid,
+	.check_mode	= hdmi_check_mode,
+	.init_audio	= hdmi_init_audio,
+	.set_audiostate	= hdmi_set_audiostate,
+};
+
+struct exynos_hdmi_control_ops exynos_hdmi_ctrl_ops = {
+	.get_hpdstate	= hdmi_get_hpdstate,
 };
 
 static irqreturn_t hdmi_external_irq_thread(int irq, void *arg)
 {
-	struct exynos_drm_hdmi_context *ctx = arg;
-	struct hdmi_context *hdata = ctx->ctx;
+	struct hdmi_context *hdata = arg;
 
 	mutex_lock(&hdata->hdmi_mutex);
 	hdata->hpd = gpio_get_value(hdata->hpd_gpio);
 	mutex_unlock(&hdata->hdmi_mutex);
 
-	if (ctx->drm_dev)
-		drm_helper_hpd_irq_event(ctx->drm_dev);
+	hdmi_send_hpdevent(&hdata->entity, hdata->hpd);
 
 	return IRQ_HANDLED;
 }
 
 static irqreturn_t hdmi_internal_irq_thread(int irq, void *arg)
 {
-	struct exynos_drm_hdmi_context *ctx = arg;
-	struct hdmi_context *hdata = ctx->ctx;
+	struct hdmi_context *hdata = arg;
 	u32 intc_flag;
 
 	intc_flag = hdmi_reg_read(hdata, HDMI_INTC_FLAG);
@@ -2017,16 +2038,17 @@ static irqreturn_t hdmi_internal_irq_thread(int irq, void *arg)
 		DRM_DEBUG_KMS("unplugged\n");
 		hdmi_reg_writemask(hdata, HDMI_INTC_FLAG, ~0,
 			HDMI_INTC_FLAG_HPD_UNPLUG);
+		hdata->hpd = 0;
+		hdmi_send_hpdevent(&hdata->entity, hdata->hpd);
 	}
 	if (intc_flag & HDMI_INTC_FLAG_HPD_PLUG) {
 		DRM_DEBUG_KMS("plugged\n");
 		hdmi_reg_writemask(hdata, HDMI_INTC_FLAG, ~0,
 			HDMI_INTC_FLAG_HPD_PLUG);
+		hdata->hpd = 1;
+		hdmi_send_hpdevent(&hdata->entity, hdata->hpd);
 	}
 
-	if (ctx->drm_dev)
-		drm_helper_hpd_irq_event(ctx->drm_dev);
-
 	return IRQ_HANDLED;
 }
 
@@ -2176,16 +2198,21 @@ static struct of_device_id hdmi_match_types[] = {
 };
 #endif
 
+
+static void hdmi_release(struct display_entity *entity)
+{
+	DRM_DEBUG_KMS("[%d][%s]\n", __LINE__, __func__);
+}
+
 static int __devinit hdmi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct exynos_drm_hdmi_context *drm_hdmi_ctx;
 	struct hdmi_context *hdata;
 	struct s5p_hdmi_platform_data *pdata;
 	struct resource *res;
 	int ret;
 
-	DRM_DEBUG_KMS("[%d]\n", __LINE__);
+	DRM_DEBUG_KMS("[%d][%s]\n", __LINE__, __func__);
 
 	if (pdev->dev.of_node) {
 		pdata = drm_hdmi_dt_parse_pdata(dev);
@@ -2202,13 +2229,6 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	drm_hdmi_ctx = devm_kzalloc(&pdev->dev, sizeof(*drm_hdmi_ctx),
-								GFP_KERNEL);
-	if (!drm_hdmi_ctx) {
-		DRM_ERROR("failed to allocate common hdmi context.\n");
-		return -ENOMEM;
-	}
-
 	hdata = devm_kzalloc(&pdev->dev, sizeof(struct hdmi_context),
 								GFP_KERNEL);
 	if (!hdata) {
@@ -2218,10 +2238,7 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 
 	mutex_init(&hdata->hdmi_mutex);
 
-	drm_hdmi_ctx->ctx = (void *)hdata;
-	hdata->parent_ctx = (void *)drm_hdmi_ctx;
-
-	platform_set_drvdata(pdev, drm_hdmi_ctx);
+	platform_set_drvdata(pdev, hdata);
 
 	if (dev->of_node) {
 		const struct of_device_id *match;
@@ -2299,7 +2316,7 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 	ret = request_threaded_irq(hdata->external_irq, NULL,
 			hdmi_external_irq_thread, IRQF_TRIGGER_RISING |
 			IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-			"hdmi_external", drm_hdmi_ctx);
+			"hdmi_external", hdata);
 	if (ret) {
 		DRM_ERROR("failed to register hdmi external interrupt\n");
 		goto err_hdmiphy;
@@ -2307,24 +2324,31 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 
 	ret = request_threaded_irq(hdata->internal_irq, NULL,
 			hdmi_internal_irq_thread, IRQF_ONESHOT,
-			"hdmi_internal", drm_hdmi_ctx);
+			"hdmi_internal", hdata);
 	if (ret) {
 		DRM_ERROR("failed to register hdmi internal interrupt\n");
 		goto err_free_irq;
 	}
 
-	/* Attach HDMI Driver to common hdmi. */
-	exynos_hdmi_drv_attach(drm_hdmi_ctx);
+	pm_runtime_enable(dev);
 
-	/* register specific callbacks to common hdmi. */
-	exynos_hdmi_ops_register(&hdmi_ops);
+	hdata->entity.dev = &pdev->dev;
+	hdata->entity.release = hdmi_release;
+	hdata->entity.ops.ctrl = &entity_ctrl_ops;
+	hdata->entity.opt_ctrl.hdmi = &hdmi_ctrl_ops;
 
-	pm_runtime_enable(dev);
+	hdata->entity.private = &exynos_hdmi_ctrl_ops;
+
+	ret = display_entity_register(&hdata->entity);
+	if (ret < 0) {
+		DRM_ERROR("[%d][%s]\n", __LINE__, __func__);
+		return ret;
+	}
 
 	return 0;
 
 err_free_irq:
-	free_irq(hdata->external_irq, drm_hdmi_ctx);
+	free_irq(hdata->external_irq, hdata);
 err_hdmiphy:
 	i2c_del_driver(&hdmiphy_driver);
 err_ddc:
@@ -2335,8 +2359,7 @@ err_ddc:
 static int __devexit hdmi_remove(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct exynos_drm_hdmi_context *ctx = platform_get_drvdata(pdev);
-	struct hdmi_context *hdata = ctx->ctx;
+	struct hdmi_context *hdata = platform_get_drvdata(pdev);
 
 	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
 
@@ -2357,8 +2380,7 @@ static int __devexit hdmi_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM_SLEEP
 static int hdmi_suspend(struct device *dev)
 {
-	struct exynos_drm_hdmi_context *ctx = get_hdmi_context(dev);
-	struct hdmi_context *hdata = ctx->ctx;
+	struct hdmi_context *hdata = get_hdmi_context(dev);
 
 	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
 
@@ -2366,8 +2388,7 @@ static int hdmi_suspend(struct device *dev)
 	disable_irq(hdata->external_irq);
 
 	hdata->hpd = false;
-	if (ctx->drm_dev)
-		drm_helper_hpd_irq_event(ctx->drm_dev);
+	hdmi_send_hpdevent(&hdata->entity, hdata->hpd);
 
 	if (pm_runtime_suspended(dev)) {
 		DRM_DEBUG_KMS("%s : Already suspended\n", __func__);
@@ -2381,8 +2402,7 @@ static int hdmi_suspend(struct device *dev)
 
 static int hdmi_resume(struct device *dev)
 {
-	struct exynos_drm_hdmi_context *ctx = get_hdmi_context(dev);
-	struct hdmi_context *hdata = ctx->ctx;
+	struct hdmi_context *hdata = get_hdmi_context(dev);
 
 	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
 
@@ -2405,8 +2425,7 @@ static int hdmi_resume(struct device *dev)
 #ifdef CONFIG_PM_RUNTIME
 static int hdmi_runtime_suspend(struct device *dev)
 {
-	struct exynos_drm_hdmi_context *ctx = get_hdmi_context(dev);
-	struct hdmi_context *hdata = ctx->ctx;
+	struct hdmi_context *hdata = get_hdmi_context(dev);
 	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
 
 	hdmi_poweroff(hdata);
@@ -2416,8 +2435,7 @@ static int hdmi_runtime_suspend(struct device *dev)
 
 static int hdmi_runtime_resume(struct device *dev)
 {
-	struct exynos_drm_hdmi_context *ctx = get_hdmi_context(dev);
-	struct hdmi_context *hdata = ctx->ctx;
+	struct hdmi_context *hdata = get_hdmi_context(dev);
 	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
 
 	hdmi_poweron(hdata);
diff --git a/drivers/gpu/drm/exynos/exynos_hdmi_cdf.c b/drivers/gpu/drm/exynos/exynos_hdmi_cdf.c
new file mode 100644
index 0000000..f61cf7e
--- /dev/null
+++ b/drivers/gpu/drm/exynos/exynos_hdmi_cdf.c
@@ -0,0 +1,370 @@
+/*
+ * Copyright (C) 2011 Samsung Electronics Co.Ltd
+ * Authors:
+ * Seung-Woo Kim <sw0312.kim@samsung.com>
+ *	Inki Dae <inki.dae@samsung.com>
+ *	Joonyoung Shim <jy0922.shim@samsung.com>
+ *
+ * Based on drivers/media/video/s5p-tv/hdmi_drv.c
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm_edid.h>
+#include <drm/drm_crtc_helper.h>
+
+#include "regs-hdmi.h"
+
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <video/display.h>
+#include "video/exynos_hdmi.h"
+
+#include <drm/exynos_drm.h>
+#include "exynos_drm_drv.h"
+#include "exynos_drm_hdmi.h"
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+
+#include "exynos_hdmi.h"
+
+#define get_hdmi_context(dev)	platform_get_drvdata(to_platform_device(dev))
+
+struct hdmi_cdf_context {
+	struct device			*dev;
+	struct drm_device			*drm_dev;
+	unsigned int			hpd;
+	struct display_entity		*entity;
+	struct display_entity_notifier	notf;
+	struct display_event_subscriber	subscriber;
+	void				*parent_ctx;
+};
+
+extern bool hdmi_cdf_is_connected(void *ctx)
+{
+	struct hdmi_cdf_context *hdata = (struct hdmi_cdf_context *)ctx;
+
+	DRM_DEBUG_KMS("[%d] %s hpd %d\n", __LINE__, __func__, hdata->hpd);
+	return (bool)hdata->hpd;
+}
+
+extern int hdmi_cdf_get_edid(void *ctx, struct drm_connector *connector,
+	u8 *edid, int len)
+{
+	struct hdmi_cdf_context *hdata = (struct hdmi_cdf_context *)ctx;
+	struct display_entity_edid edid_st;
+	struct edid *raw_edid;
+	int ret;
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	ret = display_entity_hdmi_get_edid(hdata->entity, &edid_st);
+	if (ret) {
+		DRM_ERROR("[%d]%s, Edid Read Fail!!! ret = %d\n",
+			__LINE__, __func__, ret);
+		return -EINVAL;
+	}
+
+	raw_edid = (struct edid *)edid_st.edid;
+
+	if (raw_edid) {
+		memcpy(edid, raw_edid, min(edid_st.len, len));
+		kfree(raw_edid);
+	} else {
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+extern int hdmi_cdf_check_timing(void *ctx, struct fb_videomode *timing)
+{
+	struct hdmi_cdf_context *hdata = (struct hdmi_cdf_context *)ctx;
+	int ret;
+
+	ret = display_entity_hdmi_check_mode(hdata->entity,
+			(struct videomode *)timing);
+	if (ret) {
+		DRM_DEBUG_KMS("[%d]%s, Mode NOT Supported! %dx%d@%d%s\n",
+			__LINE__, __func__, timing->xres, timing->yres,
+			timing->refresh, timing->flag
+			& FB_VMODE_INTERLACED ? "I" : "P");
+		return -EINVAL;
+	}
+
+	DRM_DEBUG_KMS("[%d]%s, Mode Supported! %dx%d@%d%s\n", __LINE__,
+		__func__, timing->xres, timing->yres, timing->refresh,
+		timing->flag & FB_VMODE_INTERLACED ? "I" : "P");
+
+	return 0;
+}
+
+extern int hdmi_cdf_power_on(void *ctx, int mode)
+{
+	return 0;
+}
+
+extern void hdmi_cdf_mode_fixup(void *ctx, struct drm_connector *connector,
+			const struct drm_display_mode *mode,
+			struct drm_display_mode *adjusted_mode)
+{
+	struct hdmi_cdf_context *hdata = (struct hdmi_cdf_context *)ctx;
+	struct drm_display_mode *m;
+	struct fb_videomode timing;
+	int index;
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	drm_mode_set_crtcinfo(adjusted_mode, 0);
+
+	timing.xres = adjusted_mode->hdisplay;
+	timing.yres = adjusted_mode->vdisplay;
+	timing.refresh = adjusted_mode->vrefresh;
+	timing.pixclock = adjusted_mode->clock * 1000;
+	timing.flag = ((adjusted_mode->flags & DRM_MODE_FLAG_INTERLACE) ?
+				 FB_VMODE_INTERLACED : 0);
+
+	index = display_entity_hdmi_check_mode(hdata->entity,
+		(struct videomode *)&timing);
+
+	/* just return if user desired mode exists. */
+	if (index == 0)
+		return;
+
+	/*
+	 * otherwise, find the most suitable mode among modes and change it
+	 * to adjusted_mode.
+	 */
+	list_for_each_entry(m, &connector->modes, head) {
+
+		timing.xres = m->hdisplay;
+		timing.yres = m->vdisplay;
+		timing.refresh = m->vrefresh;
+		timing.pixclock = m->clock * 1000;
+		timing.flag = ((m->flags & DRM_MODE_FLAG_INTERLACE) ?
+					 FB_VMODE_INTERLACED : 0);
+
+		index = display_entity_hdmi_check_mode(hdata->entity,
+			(struct videomode *)&timing);
+
+		if (index == 0) {
+			struct drm_mode_object base;
+			struct list_head head;
+
+			DRM_INFO("desired mode doesn't exist so\n");
+			DRM_INFO("use most suitable mode.\n");
+
+			DRM_DEBUG_KMS("Adjusted Mode: [%d]x[%d][%d]Hz\n",
+				m->hdisplay, m->vdisplay, m->vrefresh);
+
+			/* preserve display mode header while copying. */
+			head = adjusted_mode->head;
+			base = adjusted_mode->base;
+			memcpy(adjusted_mode, m, sizeof(*m));
+			adjusted_mode->head = head;
+			adjusted_mode->base = base;
+			break;
+		}
+	}
+}
+
+extern void hdmi_cdf_mode_set(void *ctx, void *mode)
+{
+	struct hdmi_cdf_context *hdata = (struct hdmi_cdf_context *)ctx;
+	struct drm_display_mode *m = mode;
+	int ret;
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	ret = display_entity_set_mode(hdata->entity, (struct videomode *)m);
+	if (ret) {
+		DRM_DEBUG_KMS("[%d]%s, Mode NOT Set! %dx%d@%d%s\n",
+			__LINE__, __func__, m->hdisplay, m->vdisplay,
+			m->vrefresh, (m->flags & DRM_MODE_FLAG_INTERLACE)
+			? "I" : "P");
+	}
+}
+
+extern void hdmi_cdf_get_max_resol(void *ctx, unsigned int *width,
+	unsigned int *height)
+{
+	struct hdmi_cdf_context *hdata = (struct hdmi_cdf_context *)ctx;
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	display_entity_get_size(hdata->entity, width, height);
+}
+
+extern void hdmi_cdf_commit(void *ctx)
+{
+	struct hdmi_cdf_context *hdata = (struct hdmi_cdf_context *)ctx;
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	display_entity_update(hdata->entity);
+}
+
+extern void hdmi_cdf_dpms(void *ctx, int mode)
+{
+	struct hdmi_cdf_context *hdata = (struct hdmi_cdf_context *)ctx;
+	enum display_entity_state state;
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	switch (mode) {
+	case DRM_MODE_DPMS_ON:
+		state = DISPLAY_ENTITY_STATE_ON;
+		break;
+	case DRM_MODE_DPMS_STANDBY:
+		state = DISPLAY_ENTITY_STATE_STANDBY;
+		break;
+	case DRM_MODE_DPMS_SUSPEND:
+	case DRM_MODE_DPMS_OFF:
+		state = DISPLAY_ENTITY_STATE_STANDBY;
+		break;
+	default:
+		DRM_DEBUG_KMS("unknown dpms mode: %d\n", mode);
+		return;
+	}
+
+	display_entity_set_state(hdata->entity, state);
+}
+
+void event_notify(struct display_entity *entity,
+	enum display_entity_event_type type, unsigned int value,
+	void *context)
+{
+	struct hdmi_cdf_context *hdata = (struct hdmi_cdf_context *)context;
+	struct exynos_drm_hdmi_context *ctx = get_hdmi_context(hdata->dev);
+
+	if (type == DISPLAY_ENTITY_HDMI_HOTPLUG) {
+		DRM_DEBUG_KMS("[%d][%s] hpd(%d)\n",
+			__LINE__, __func__, value);
+		hdata->hpd = value;
+
+		if (ctx->drm_dev)
+			drm_helper_hpd_irq_event(ctx->drm_dev);
+	}
+}
+
+int display_entity_notification(struct display_entity_notifier *notf,
+	struct display_entity *entity, int status)
+{
+	struct hdmi_cdf_context *hdata = container_of(notf,
+		struct hdmi_cdf_context, notf);
+	struct exynos_hdmi_control_ops *exynos_ops =
+		(struct exynos_hdmi_control_ops *)entity->private;
+
+	if (status != DISPLAY_ENTITY_NOTIFIER_CONNECT && entity)
+		return -EINVAL;
+
+	DRM_DEBUG_KMS("[%d][%s] NOTIFIER_CONNECT\n", __LINE__, __func__);
+
+	hdata->entity = entity;
+
+	hdata->subscriber.context = hdata;
+	hdata->subscriber.notify = event_notify;
+	display_entity_subscribe_event(entity, &hdata->subscriber);
+
+	exynos_ops->get_hpdstate(entity, &hdata->hpd);
+	return 0;
+}
+
+static struct exynos_hdmi_ops hdmi_ops = {
+	/* display */
+	.is_connected	= hdmi_cdf_is_connected,
+	.get_edid		= hdmi_cdf_get_edid,
+	.check_timing	= hdmi_cdf_check_timing,
+
+	/* manager */
+	.mode_fixup	= hdmi_cdf_mode_fixup,
+	.mode_set		= hdmi_cdf_mode_set,
+	.get_max_resol	= hdmi_cdf_get_max_resol,
+	.commit		= hdmi_cdf_commit,
+	.dpms		= hdmi_cdf_dpms,
+};
+
+static int __devinit hdmi_cdf_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *dev_node;
+	struct platform_device *disp_pdev;
+	struct exynos_drm_hdmi_context *drm_hdmi_ctx;
+	struct hdmi_cdf_context *hdata;
+	int ret;
+
+	DRM_DEBUG_KMS("[%d][%s]\n", __LINE__, __func__);
+
+	dev_node = of_find_compatible_node(NULL, NULL,
+			"samsung,exynos5-hdmi");
+	if (!dev_node) {
+		DRM_DEBUG_KMS("[ERROR][%d][%s] dt node not found.\n",
+			__LINE__, __func__);
+		return -EINVAL;
+	}
+
+	disp_pdev = of_find_device_by_node(dev_node);
+	if (!disp_pdev) {
+		DRM_DEBUG_KMS("[ERROR][%d][%s] No pdev\n",
+			__LINE__, __func__);
+		return -EINVAL;
+	}
+
+	drm_hdmi_ctx = devm_kzalloc(&pdev->dev, sizeof(*drm_hdmi_ctx),
+		GFP_KERNEL);
+	if (!drm_hdmi_ctx) {
+		DRM_ERROR("failed to allocate common hdmi context.\n");
+		return -ENOMEM;
+	}
+
+	hdata = devm_kzalloc(&pdev->dev, sizeof(struct hdmi_cdf_context),
+		GFP_KERNEL);
+	if (!hdata) {
+		DRM_ERROR("out of memory\n");
+		return -ENOMEM;
+	}
+
+	drm_hdmi_ctx->ctx = (void *)hdata;
+	hdata->parent_ctx = (void *)drm_hdmi_ctx;
+
+	platform_set_drvdata(pdev, drm_hdmi_ctx);
+
+	/* Attach HDMI Driver to common hdmi. */
+	exynos_hdmi_drv_attach(drm_hdmi_ctx);
+
+	/* register specific callbacks to common hdmi. */
+	exynos_hdmi_ops_register(&hdmi_ops);
+
+	hdata->dev = dev;
+	hdata->notf.dev = &disp_pdev->dev;
+	hdata->notf.notify = display_entity_notification;
+
+	ret = display_entity_register_notifier(&hdata->notf);
+	if (ret) {
+		DRM_DEBUG_KMS("[ERROR][%d][%s] entity registe failed.\n",
+			__LINE__, __func__);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __devexit hdmi_cdf_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+struct platform_driver hdmi_cdf_driver = {
+	.probe		= hdmi_cdf_probe,
+	.remove		= __devexit_p(hdmi_cdf_remove),
+	.driver		= {
+		.name	= "exynos-hdmi-cdf",
+		.owner	= THIS_MODULE,
+	},
+};
+
diff --git a/include/video/exynos_hdmi.h b/include/video/exynos_hdmi.h
new file mode 100644
index 0000000..cc8d613
--- /dev/null
+++ b/include/video/exynos_hdmi.h
@@ -0,0 +1,25 @@
+/*
+ * Display Core
+ *
+ * Copyright (C) 2012 Renesas Solutions Corp.
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __EXYNOS_HDMI_H__
+#define __EXYNOS_HDMI_H__
+
+#include <linux/kref.h>
+#include <linux/list.h>
+#include <linux/module.h>
+
+struct exynos_hdmi_control_ops {
+	int (*get_hpdstate)(struct display_entity *entity,
+		unsigned int *hpd_state);
+};
+
+#endif /* __EXYNOS_HDMI_H__ */
-- 
1.8.0

