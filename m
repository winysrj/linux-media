Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:45511 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab2JDHZI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 03:25:08 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBC00LFOXWSZVQ0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:52 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBC006I9XWMLU10@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:52 +0900 (KST)
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, inki.dae@samsung.com,
	kyungmin.park@samsung.com, joshi@samsung.com
Subject: [PATCH v1 10/14] drm: exynos: hdmi: add support to disable video
 processor in mixer
Date: Thu, 04 Oct 2012 21:12:48 +0530
Message-id: <1349365372-21417-11-git-send-email-rahul.sharma@samsung.com>
In-reply-to: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
References: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for disabling the video processor code based
on the platform type. This is done based on a field in the mixer driver
data which changes with the platform variant.

Signed-off-by: Rahul Sharma <rahul.sharma@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_mixer.c |  151 +++++++++++++++++++++------------
 1 files changed, 98 insertions(+), 53 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_mixer.c b/drivers/gpu/drm/exynos/exynos_mixer.c
index e312fb1..1677345 100644
--- a/drivers/gpu/drm/exynos/exynos_mixer.c
+++ b/drivers/gpu/drm/exynos/exynos_mixer.c
@@ -83,6 +83,7 @@ struct mixer_context {
 	int			pipe;
 	bool			interlace;
 	bool			powered;
+	bool			vp_enabled;
 	u32			int_en;
 
 	struct mutex		mixer_mutex;
@@ -93,6 +94,7 @@ struct mixer_context {
 
 struct mixer_drv_data {
 	enum mixer_version_id	version;
+	bool					is_vp_enabled;
 };
 
 static const u8 filter_y_horiz_tap8[] = {
@@ -261,7 +263,8 @@ static void mixer_vsync_set_update(struct mixer_context *ctx, bool enable)
 	mixer_reg_writemask(res, MXR_STATUS, enable ?
 			MXR_STATUS_SYNC_ENABLE : 0, MXR_STATUS_SYNC_ENABLE);
 
-	vp_reg_write(res, VP_SHADOW_UPDATE, enable ?
+	if (ctx->vp_enabled)
+		vp_reg_write(res, VP_SHADOW_UPDATE, enable ?
 			VP_SHADOW_UPDATE_ENABLE : 0);
 }
 
@@ -343,8 +346,11 @@ static void mixer_cfg_layer(struct mixer_context *ctx, int win, bool enable)
 		mixer_reg_writemask(res, MXR_CFG, val, MXR_CFG_GRP1_ENABLE);
 		break;
 	case 2:
-		vp_reg_writemask(res, VP_ENABLE, val, VP_ENABLE_ON);
-		mixer_reg_writemask(res, MXR_CFG, val, MXR_CFG_VP_ENABLE);
+		if (ctx->vp_enabled) {
+			vp_reg_writemask(res, VP_ENABLE, val, VP_ENABLE_ON);
+			mixer_reg_writemask(res, MXR_CFG, val,
+				MXR_CFG_VP_ENABLE);
+		}
 		break;
 	}
 }
@@ -602,7 +608,8 @@ static void mixer_win_reset(struct mixer_context *ctx)
 	 */
 	val = MXR_LAYER_CFG_GRP1_VAL(3);
 	val |= MXR_LAYER_CFG_GRP0_VAL(2);
-	val |= MXR_LAYER_CFG_VP_VAL(1);
+	if (ctx->vp_enabled)
+		val |= MXR_LAYER_CFG_VP_VAL(1);
 	mixer_reg_write(res, MXR_LAYER_CFG, val);
 
 	/* setting background color */
@@ -625,14 +632,17 @@ static void mixer_win_reset(struct mixer_context *ctx)
 	val = MXR_GRP_CFG_ALPHA_VAL(0);
 	mixer_reg_write(res, MXR_VIDEO_CFG, val);
 
-	/* configuration of Video Processor Registers */
-	vp_win_reset(ctx);
-	vp_default_filter(res);
+	if (ctx->vp_enabled) {
+		/* configuration of Video Processor Registers */
+		vp_win_reset(ctx);
+		vp_default_filter(res);
+	}
 
 	/* disable all layers */
 	mixer_reg_writemask(res, MXR_CFG, 0, MXR_CFG_GRP0_ENABLE);
 	mixer_reg_writemask(res, MXR_CFG, 0, MXR_CFG_GRP1_ENABLE);
-	mixer_reg_writemask(res, MXR_CFG, 0, MXR_CFG_VP_ENABLE);
+	if (ctx->vp_enabled)
+		mixer_reg_writemask(res, MXR_CFG, 0, MXR_CFG_VP_ENABLE);
 
 	mixer_vsync_set_update(ctx, true);
 	spin_unlock_irqrestore(&res->reg_slock, flags);
@@ -655,8 +665,10 @@ static void mixer_poweron(struct mixer_context *ctx)
 	pm_runtime_get_sync(ctx->dev);
 
 	clk_enable(res->mixer);
-	clk_enable(res->vp);
-	clk_enable(res->sclk_mixer);
+	if (ctx->vp_enabled) {
+		clk_enable(res->vp);
+		clk_enable(res->sclk_mixer);
+	}
 
 	mixer_reg_write(res, MXR_INT_EN, ctx->int_en);
 	mixer_win_reset(ctx);
@@ -676,8 +688,10 @@ static void mixer_poweroff(struct mixer_context *ctx)
 	ctx->int_en = mixer_reg_read(res, MXR_INT_EN);
 
 	clk_disable(res->mixer);
-	clk_disable(res->vp);
-	clk_disable(res->sclk_mixer);
+	if (ctx->vp_enabled) {
+		clk_disable(res->vp);
+		clk_disable(res->sclk_mixer);
+	}
 
 	pm_runtime_put_sync(ctx->dev);
 
@@ -810,7 +824,7 @@ static void mixer_win_commit(void *ctx, int win)
 
 	DRM_DEBUG_KMS("[%d] %s, win: %d\n", __LINE__, __func__, win);
 
-	if (win > 1)
+	if (win > 1 && mixer_ctx->vp_enabled)
 		vp_video_buffer(mixer_ctx, win);
 	else
 		mixer_graph_buffer(mixer_ctx, win);
@@ -946,39 +960,20 @@ static int __devinit mixer_resources_init(struct exynos_drm_hdmi_context *ctx,
 		ret = -ENODEV;
 		goto fail;
 	}
-	mixer_res->vp = clk_get(dev, "vp");
-	if (IS_ERR_OR_NULL(mixer_res->vp)) {
-		dev_err(dev, "failed to get clock 'vp'\n");
-		ret = -ENODEV;
-		goto fail;
-	}
-	mixer_res->sclk_mixer = clk_get(dev, "sclk_mixer");
-	if (IS_ERR_OR_NULL(mixer_res->sclk_mixer)) {
-		dev_err(dev, "failed to get clock 'sclk_mixer'\n");
-		ret = -ENODEV;
-		goto fail;
-	}
+
 	mixer_res->sclk_hdmi = clk_get(dev, "sclk_hdmi");
 	if (IS_ERR_OR_NULL(mixer_res->sclk_hdmi)) {
 		dev_err(dev, "failed to get clock 'sclk_hdmi'\n");
 		ret = -ENODEV;
 		goto fail;
 	}
-	mixer_res->sclk_dac = clk_get(dev, "sclk_dac");
-	if (IS_ERR_OR_NULL(mixer_res->sclk_dac)) {
-		dev_err(dev, "failed to get clock 'sclk_dac'\n");
-		ret = -ENODEV;
-		goto fail;
-	}
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mxr");
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
 		dev_err(dev, "get memory resource failed.\n");
 		ret = -ENXIO;
 		goto fail;
 	}
 
-	clk_set_parent(mixer_res->sclk_mixer, mixer_res->sclk_hdmi);
-
 	mixer_res->mixer_regs = devm_ioremap(&pdev->dev, res->start,
 							resource_size(res));
 	if (mixer_res->mixer_regs == NULL) {
@@ -987,54 +982,92 @@ static int __devinit mixer_resources_init(struct exynos_drm_hdmi_context *ctx,
 		goto fail;
 	}
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vp");
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (res == NULL) {
-		dev_err(dev, "get memory resource failed.\n");
+		dev_err(dev, "get interrupt resource failed.\n");
 		ret = -ENXIO;
 		goto fail;
 	}
 
-	mixer_res->vp_regs = devm_ioremap(&pdev->dev, res->start,
-							resource_size(res));
-	if (mixer_res->vp_regs == NULL) {
-		dev_err(dev, "register mapping failed.\n");
-		ret = -ENXIO;
+	ret = devm_request_irq(&pdev->dev, res->start, mixer_irq_handler,
+							0, "drm_mixer", ctx);
+	if (ret) {
+		dev_err(dev, "request interrupt failed.\n");
 		goto fail;
 	}
+	mixer_res->irq = res->start;
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_IRQ, "irq");
+	return 0;
+
+fail:
+	if (!IS_ERR_OR_NULL(mixer_res->sclk_hdmi))
+		clk_put(mixer_res->sclk_hdmi);
+	if (!IS_ERR_OR_NULL(mixer_res->mixer))
+		clk_put(mixer_res->mixer);
+	return ret;
+}
+
+static int __devinit vp_resources_init(struct exynos_drm_hdmi_context *ctx,
+				 struct platform_device *pdev)
+{
+	struct mixer_context *mixer_ctx = ctx->ctx;
+	struct device *dev = &pdev->dev;
+	struct mixer_resources *mixer_res = &mixer_ctx->mixer_res;
+	struct resource *res;
+	int ret;
+
+	mixer_res->vp = clk_get(dev, "vp");
+	if (IS_ERR_OR_NULL(mixer_res->vp)) {
+		dev_err(dev, "failed to get clock 'vp'\n");
+		ret = -ENODEV;
+		goto fail;
+	}
+	mixer_res->sclk_mixer = clk_get(dev, "sclk_mixer");
+	if (IS_ERR_OR_NULL(mixer_res->sclk_mixer)) {
+		dev_err(dev, "failed to get clock 'sclk_mixer'\n");
+		ret = -ENODEV;
+		goto fail;
+	}
+	mixer_res->sclk_dac = clk_get(dev, "sclk_dac");
+	if (IS_ERR_OR_NULL(mixer_res->sclk_dac)) {
+		dev_err(dev, "failed to get clock 'sclk_dac'\n");
+		ret = -ENODEV;
+		goto fail;
+	}
+
+	if (mixer_res->sclk_hdmi)
+		clk_set_parent(mixer_res->sclk_mixer, mixer_res->sclk_hdmi);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (res == NULL) {
-		dev_err(dev, "get interrupt resource failed.\n");
+		dev_err(dev, "get memory resource failed.\n");
 		ret = -ENXIO;
 		goto fail;
 	}
 
-	ret = devm_request_irq(&pdev->dev, res->start, mixer_irq_handler,
-							0, "drm_mixer", ctx);
-	if (ret) {
-		dev_err(dev, "request interrupt failed.\n");
+	mixer_res->vp_regs = devm_ioremap(&pdev->dev, res->start,
+							resource_size(res));
+	if (mixer_res->vp_regs == NULL) {
+		dev_err(dev, "register mapping failed.\n");
+		ret = -ENXIO;
 		goto fail;
 	}
-	mixer_res->irq = res->start;
 
 	return 0;
 
 fail:
 	if (!IS_ERR_OR_NULL(mixer_res->sclk_dac))
 		clk_put(mixer_res->sclk_dac);
-	if (!IS_ERR_OR_NULL(mixer_res->sclk_hdmi))
-		clk_put(mixer_res->sclk_hdmi);
 	if (!IS_ERR_OR_NULL(mixer_res->sclk_mixer))
 		clk_put(mixer_res->sclk_mixer);
 	if (!IS_ERR_OR_NULL(mixer_res->vp))
 		clk_put(mixer_res->vp);
-	if (!IS_ERR_OR_NULL(mixer_res->mixer))
-		clk_put(mixer_res->mixer);
 	return ret;
 }
 
 static struct mixer_drv_data exynos4_mxr_drv_data = {
 	.version = MXR_VER_0_0_0_16,
+	.is_vp_enabled = 1,
 };
 
 static struct platform_device_id mixer_driver_types[] = {
@@ -1075,14 +1108,26 @@ static int __devinit mixer_probe(struct platform_device *pdev)
 			pdev)->driver_data;
 	ctx->dev = &pdev->dev;
 	drm_hdmi_ctx->ctx = (void *)ctx;
+	ctx->vp_enabled = drv->is_vp_enabled;
 	ctx->mxr_ver = drv->version;
 
 	platform_set_drvdata(pdev, drm_hdmi_ctx);
 
 	/* acquire resources: regs, irqs, clocks */
 	ret = mixer_resources_init(drm_hdmi_ctx, pdev);
-	if (ret)
+	if (ret) {
+		DRM_ERROR("mixer_resources_init failed\n");
 		goto fail;
+	}
+
+	if (ctx->vp_enabled) {
+		/* acquire vp resources: regs, irqs, clocks */
+		ret = vp_resources_init(drm_hdmi_ctx, pdev);
+		if (ret) {
+			DRM_ERROR("vp_resources_init failed\n");
+			goto fail;
+		}
+	}
 
 	/* register specific callback point to common hdmi. */
 	exynos_mixer_ops_register(&mixer_ops);
-- 
1.7.0.4

