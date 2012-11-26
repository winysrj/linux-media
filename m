Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53739 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab2KZEz6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 23:55:58 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so4742413pad.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 20:55:57 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 8/9] [media] s5p-tv: Use devm_* APIs in mixer_drv.c
Date: Mon, 26 Nov 2012 10:19:07 +0530
Message-Id: <1353905348-15475-9-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
References: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_* APIs are device managed and make error handling and
cleanup simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-tv/mixer_drv.c |   85 +++++++----------------------
 1 files changed, 20 insertions(+), 65 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
index a6dee4d..279e395 100644
--- a/drivers/media/platform/s5p-tv/mixer_drv.c
+++ b/drivers/media/platform/s5p-tv/mixer_drv.c
@@ -160,78 +160,44 @@ static int __devinit mxr_acquire_plat_resources(struct mxr_device *mdev,
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mxr");
 	if (res == NULL) {
 		mxr_err(mdev, "get memory resource failed.\n");
-		ret = -ENXIO;
-		goto fail;
+		return -ENXIO;
 	}
 
-	mdev->res.mxr_regs = ioremap(res->start, resource_size(res));
+	mdev->res.mxr_regs = devm_ioremap(&pdev->dev, res->start,
+					  resource_size(res));
 	if (mdev->res.mxr_regs == NULL) {
 		mxr_err(mdev, "register mapping failed.\n");
-		ret = -ENXIO;
-		goto fail;
+		return -ENXIO;
 	}
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vp");
 	if (res == NULL) {
 		mxr_err(mdev, "get memory resource failed.\n");
-		ret = -ENXIO;
-		goto fail_mxr_regs;
+		return -ENXIO;
 	}
 
-	mdev->res.vp_regs = ioremap(res->start, resource_size(res));
+	mdev->res.vp_regs = devm_ioremap(&pdev->dev, res->start,
+					 resource_size(res));
 	if (mdev->res.vp_regs == NULL) {
 		mxr_err(mdev, "register mapping failed.\n");
-		ret = -ENXIO;
-		goto fail_mxr_regs;
+		return -ENXIO;
 	}
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_IRQ, "irq");
 	if (res == NULL) {
 		mxr_err(mdev, "get interrupt resource failed.\n");
-		ret = -ENXIO;
-		goto fail_vp_regs;
+		return -ENXIO;
 	}
 
-	ret = request_irq(res->start, mxr_irq_handler, 0, "s5p-mixer", mdev);
+	ret = devm_request_irq(&pdev->dev, res->start, mxr_irq_handler, 0,
+				"s5p-mixer", mdev);
 	if (ret) {
 		mxr_err(mdev, "request interrupt failed.\n");
-		goto fail_vp_regs;
+		return ret;
 	}
 	mdev->res.irq = res->start;
 
 	return 0;
-
-fail_vp_regs:
-	iounmap(mdev->res.vp_regs);
-
-fail_mxr_regs:
-	iounmap(mdev->res.mxr_regs);
-
-fail:
-	return ret;
-}
-
-static void mxr_release_plat_resources(struct mxr_device *mdev)
-{
-	free_irq(mdev->res.irq, mdev);
-	iounmap(mdev->res.vp_regs);
-	iounmap(mdev->res.mxr_regs);
-}
-
-static void mxr_release_clocks(struct mxr_device *mdev)
-{
-	struct mxr_resources *res = &mdev->res;
-
-	if (!IS_ERR_OR_NULL(res->sclk_dac))
-		clk_put(res->sclk_dac);
-	if (!IS_ERR_OR_NULL(res->sclk_hdmi))
-		clk_put(res->sclk_hdmi);
-	if (!IS_ERR_OR_NULL(res->sclk_mixer))
-		clk_put(res->sclk_mixer);
-	if (!IS_ERR_OR_NULL(res->vp))
-		clk_put(res->vp);
-	if (!IS_ERR_OR_NULL(res->mixer))
-		clk_put(res->mixer);
 }
 
 static int mxr_acquire_clocks(struct mxr_device *mdev)
@@ -239,27 +205,27 @@ static int mxr_acquire_clocks(struct mxr_device *mdev)
 	struct mxr_resources *res = &mdev->res;
 	struct device *dev = mdev->dev;
 
-	res->mixer = clk_get(dev, "mixer");
+	res->mixer = devm_clk_get(dev, "mixer");
 	if (IS_ERR_OR_NULL(res->mixer)) {
 		mxr_err(mdev, "failed to get clock 'mixer'\n");
 		goto fail;
 	}
-	res->vp = clk_get(dev, "vp");
+	res->vp = devm_clk_get(dev, "vp");
 	if (IS_ERR_OR_NULL(res->vp)) {
 		mxr_err(mdev, "failed to get clock 'vp'\n");
 		goto fail;
 	}
-	res->sclk_mixer = clk_get(dev, "sclk_mixer");
+	res->sclk_mixer = devm_clk_get(dev, "sclk_mixer");
 	if (IS_ERR_OR_NULL(res->sclk_mixer)) {
 		mxr_err(mdev, "failed to get clock 'sclk_mixer'\n");
 		goto fail;
 	}
-	res->sclk_hdmi = clk_get(dev, "sclk_hdmi");
+	res->sclk_hdmi = devm_clk_get(dev, "sclk_hdmi");
 	if (IS_ERR_OR_NULL(res->sclk_hdmi)) {
 		mxr_err(mdev, "failed to get clock 'sclk_hdmi'\n");
 		goto fail;
 	}
-	res->sclk_dac = clk_get(dev, "sclk_dac");
+	res->sclk_dac = devm_clk_get(dev, "sclk_dac");
 	if (IS_ERR_OR_NULL(res->sclk_dac)) {
 		mxr_err(mdev, "failed to get clock 'sclk_dac'\n");
 		goto fail;
@@ -267,7 +233,6 @@ static int mxr_acquire_clocks(struct mxr_device *mdev)
 
 	return 0;
 fail:
-	mxr_release_clocks(mdev);
 	return -ENODEV;
 }
 
@@ -276,19 +241,16 @@ static int __devinit mxr_acquire_resources(struct mxr_device *mdev,
 {
 	int ret;
 	ret = mxr_acquire_plat_resources(mdev, pdev);
-
 	if (ret)
 		goto fail;
 
 	ret = mxr_acquire_clocks(mdev);
 	if (ret)
-		goto fail_plat;
+		goto fail;
 
 	mxr_info(mdev, "resources acquired\n");
 	return 0;
 
-fail_plat:
-	mxr_release_plat_resources(mdev);
 fail:
 	mxr_err(mdev, "resources acquire failed\n");
 	return ret;
@@ -296,8 +258,6 @@ fail:
 
 static void mxr_release_resources(struct mxr_device *mdev)
 {
-	mxr_release_clocks(mdev);
-	mxr_release_plat_resources(mdev);
 	memset(&mdev->res, 0, sizeof(mdev->res));
 }
 
@@ -382,7 +342,7 @@ static int __devinit mxr_probe(struct platform_device *pdev)
 	/* mdev does not exist yet so no mxr_dbg is used */
 	dev_info(dev, "probe start\n");
 
-	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	mdev = devm_kzalloc(dev, sizeof(*mdev), GFP_KERNEL);
 	if (!mdev) {
 		dev_err(dev, "not enough memory.\n");
 		ret = -ENOMEM;
@@ -399,7 +359,7 @@ static int __devinit mxr_probe(struct platform_device *pdev)
 	/* acquire resources: regs, irqs, clocks, regulators */
 	ret = mxr_acquire_resources(mdev, pdev);
 	if (ret)
-		goto fail_mem;
+		goto fail;
 
 	/* configure resources for video output */
 	ret = mxr_acquire_video(mdev, mxr_output_conf,
@@ -423,9 +383,6 @@ fail_video:
 fail_resources:
 	mxr_release_resources(mdev);
 
-fail_mem:
-	kfree(mdev);
-
 fail:
 	dev_info(dev, "probe failed\n");
 	return ret;
@@ -442,8 +399,6 @@ static int __devexit mxr_remove(struct platform_device *pdev)
 	mxr_release_video(mdev);
 	mxr_release_resources(mdev);
 
-	kfree(mdev);
-
 	dev_info(dev, "remove successful\n");
 	return 0;
 }
-- 
1.7.4.1

