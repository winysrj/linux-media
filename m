Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:33859 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab2JDHZB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 03:25:01 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBC00CTLXVK9PN0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:54 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBC006I9XWMLU10@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:54 +0900 (KST)
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, inki.dae@samsung.com,
	kyungmin.park@samsung.com, joshi@samsung.com
Subject: [PATCH v1 11/14] drm: exynos: hdmi: add support for exynos5 mixer
Date: Thu, 04 Oct 2012 21:12:49 +0530
Message-id: <1349365372-21417-12-git-send-email-rahul.sharma@samsung.com>
In-reply-to: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
References: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for exynos5 mixer with device tree enabled.

Signed-off-by: Rahul Sharma <rahul.sharma@samsung.com>
Signed-off-by: Fahad Kunnathadi <fahad.k@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_mixer.c |   49 +++++++++++++++++++++++++++++++--
 drivers/gpu/drm/exynos/regs-mixer.h   |    3 ++
 2 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_mixer.c b/drivers/gpu/drm/exynos/exynos_mixer.c
index 1677345..39d2b95 100644
--- a/drivers/gpu/drm/exynos/exynos_mixer.c
+++ b/drivers/gpu/drm/exynos/exynos_mixer.c
@@ -481,6 +481,18 @@ static void vp_video_buffer(struct mixer_context *ctx, int win)
 	vp_regs_dump(ctx);
 }
 
+static void mixer_layer_update(struct mixer_context *ctx)
+{
+	struct mixer_resources *res = &ctx->mixer_res;
+	u32 val;
+
+	val = mixer_reg_read(res, MXR_CFG);
+
+	/* allow one update per vsync only */
+	if (!(val & MXR_CFG_LAYER_UPDATE_COUNT_MASK))
+		mixer_reg_writemask(res, MXR_CFG, ~0, MXR_CFG_LAYER_UPDATE);
+}
+
 static void mixer_graph_buffer(struct mixer_context *ctx, int win)
 {
 	struct mixer_resources *res = &ctx->mixer_res;
@@ -561,6 +573,11 @@ static void mixer_graph_buffer(struct mixer_context *ctx, int win)
 	mixer_cfg_scan(ctx, win_data->mode_height);
 	mixer_cfg_rgb_fmt(ctx, win_data->mode_height);
 	mixer_cfg_layer(ctx, win, true);
+
+	/* layer update mandatory for mixer 16.0.33.0 */
+	if (ctx->mxr_ver == MXR_VER_16_0_33_0)
+		mixer_layer_update(ctx);
+
 	mixer_run(ctx);
 
 	mixer_vsync_set_update(ctx, true);
@@ -1065,6 +1082,11 @@ fail:
 	return ret;
 }
 
+static struct mixer_drv_data exynos5_mxr_drv_data = {
+	.version = MXR_VER_16_0_33_0,
+	.is_vp_enabled = 0,
+};
+
 static struct mixer_drv_data exynos4_mxr_drv_data = {
 	.version = MXR_VER_0_0_0_16,
 	.is_vp_enabled = 1,
@@ -1075,6 +1097,18 @@ static struct platform_device_id mixer_driver_types[] = {
 		.name		= "s5p-mixer",
 		.driver_data	= (unsigned long)&exynos4_mxr_drv_data,
 	}, {
+		.name		= "exynos5-mixer",
+		.driver_data	= (unsigned long)&exynos5_mxr_drv_data,
+	}, {
+		/* end node */
+	}
+};
+
+static struct of_device_id mixer_match_types[] = {
+	{
+		.compatible = "samsung,exynos5-mixer",
+		.data	= &exynos5_mxr_drv_data,
+	}, {
 		/* end node */
 	}
 };
@@ -1104,8 +1138,16 @@ static int __devinit mixer_probe(struct platform_device *pdev)
 
 	mutex_init(&ctx->mixer_mutex);
 
-	drv = (struct mixer_drv_data *)platform_get_device_id(
-			pdev)->driver_data;
+	if (dev->of_node) {
+		const struct of_device_id *match;
+		match = of_match_node(of_match_ptr(mixer_match_types),
+							  pdev->dev.of_node);
+		drv = match->data;
+	} else {
+		drv = (struct mixer_drv_data *)
+			platform_get_device_id(pdev)->driver_data;
+	}
+
 	ctx->dev = &pdev->dev;
 	drm_hdmi_ctx->ctx = (void *)ctx;
 	ctx->vp_enabled = drv->is_vp_enabled;
@@ -1167,9 +1209,10 @@ static SIMPLE_DEV_PM_OPS(mixer_pm_ops, mixer_suspend, NULL);
 
 struct platform_driver mixer_driver = {
 	.driver = {
-		.name = "s5p-mixer",
+		.name = "exynos-mixer",
 		.owner = THIS_MODULE,
 		.pm = &mixer_pm_ops,
+		.of_match_table = mixer_match_types,
 	},
 	.probe = mixer_probe,
 	.remove = __devexit_p(mixer_remove),
diff --git a/drivers/gpu/drm/exynos/regs-mixer.h b/drivers/gpu/drm/exynos/regs-mixer.h
index fd2f4d1..5d8dbc0 100644
--- a/drivers/gpu/drm/exynos/regs-mixer.h
+++ b/drivers/gpu/drm/exynos/regs-mixer.h
@@ -69,6 +69,7 @@
 	(((val) << (low_bit)) & MXR_MASK(high_bit, low_bit))
 
 /* bits for MXR_STATUS */
+#define MXR_STATUS_SOFT_RESET		(1 << 8)
 #define MXR_STATUS_16_BURST		(1 << 7)
 #define MXR_STATUS_BURST_MASK		(1 << 7)
 #define MXR_STATUS_BIG_ENDIAN		(1 << 3)
@@ -77,6 +78,8 @@
 #define MXR_STATUS_REG_RUN		(1 << 0)
 
 /* bits for MXR_CFG */
+#define MXR_CFG_LAYER_UPDATE		(1 << 31)
+#define MXR_CFG_LAYER_UPDATE_COUNT_MASK (3 << 29)
 #define MXR_CFG_RGB601_0_255		(0 << 9)
 #define MXR_CFG_RGB601_16_235		(1 << 9)
 #define MXR_CFG_RGB709_0_255		(2 << 9)
-- 
1.7.0.4

