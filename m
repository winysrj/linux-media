Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60696 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab2KZEzz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 23:55:55 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so7718128pbc.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 20:55:54 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 7/9] [media] s5p-tv: Use devm_clk_get APIs in sdo_drv.c
Date: Mon, 26 Nov 2012 10:19:06 +0530
Message-Id: <1353905348-15475-8-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
References: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_clk_get() is device managed function and makes error handling
and exit code a bit simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-tv/sdo_drv.c |   39 +++++++++---------------------
 1 files changed, 12 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
index 91e2de3..9e78adf 100644
--- a/drivers/media/platform/s5p-tv/sdo_drv.c
+++ b/drivers/media/platform/s5p-tv/sdo_drv.c
@@ -340,36 +340,33 @@ static int __devinit sdo_probe(struct platform_device *pdev)
 	sdev->irq = res->start;
 
 	/* acquire clocks */
-	sdev->sclk_dac = clk_get(dev, "sclk_dac");
+	sdev->sclk_dac = devm_clk_get(dev, "sclk_dac");
 	if (IS_ERR_OR_NULL(sdev->sclk_dac)) {
 		dev_err(dev, "failed to get clock 'sclk_dac'\n");
 		ret = -ENXIO;
 		goto fail;
 	}
-	sdev->dac = clk_get(dev, "dac");
+	sdev->dac = devm_clk_get(dev, "dac");
 	if (IS_ERR_OR_NULL(sdev->dac)) {
 		dev_err(dev, "failed to get clock 'dac'\n");
-		ret = -ENXIO;
-		goto fail_sclk_dac;
+		return -ENXIO;
 	}
-	sdev->dacphy = clk_get(dev, "dacphy");
+	sdev->dacphy = devm_clk_get(dev, "dacphy");
 	if (IS_ERR_OR_NULL(sdev->dacphy)) {
 		dev_err(dev, "failed to get clock 'dacphy'\n");
-		ret = -ENXIO;
-		goto fail_dac;
+		return -ENXIO;
 	}
-	sclk_vpll = clk_get(dev, "sclk_vpll");
+	sclk_vpll = devm_clk_get(dev, "sclk_vpll");
 	if (IS_ERR_OR_NULL(sclk_vpll)) {
 		dev_err(dev, "failed to get clock 'sclk_vpll'\n");
-		ret = -ENXIO;
-		goto fail_dacphy;
+		return -ENXIO;
 	}
 	clk_set_parent(sdev->sclk_dac, sclk_vpll);
-	clk_put(sclk_vpll);
-	sdev->fout_vpll = clk_get(dev, "fout_vpll");
+	devm_clk_put(dev, sclk_vpll);
+	sdev->fout_vpll = devm_clk_get(dev, "fout_vpll");
 	if (IS_ERR_OR_NULL(sdev->fout_vpll)) {
 		dev_err(dev, "failed to get clock 'fout_vpll'\n");
-		goto fail_dacphy;
+		return -ENXIO;
 	}
 	dev_info(dev, "fout_vpll.rate = %lu\n", clk_get_rate(sclk_vpll));
 
@@ -377,12 +374,12 @@ static int __devinit sdo_probe(struct platform_device *pdev)
 	sdev->vdac = devm_regulator_get(dev, "vdd33a_dac");
 	if (IS_ERR_OR_NULL(sdev->vdac)) {
 		dev_err(dev, "failed to get regulator 'vdac'\n");
-		goto fail_fout_vpll;
+		goto fail;
 	}
 	sdev->vdet = devm_regulator_get(dev, "vdet");
 	if (IS_ERR_OR_NULL(sdev->vdet)) {
 		dev_err(dev, "failed to get regulator 'vdet'\n");
-		goto fail_fout_vpll;
+		goto fail;
 	}
 
 	/* enable gate for dac clock, because mixer uses it */
@@ -406,14 +403,6 @@ static int __devinit sdo_probe(struct platform_device *pdev)
 	dev_info(dev, "probe succeeded\n");
 	return 0;
 
-fail_fout_vpll:
-	clk_put(sdev->fout_vpll);
-fail_dacphy:
-	clk_put(sdev->dacphy);
-fail_dac:
-	clk_put(sdev->dac);
-fail_sclk_dac:
-	clk_put(sdev->sclk_dac);
 fail:
 	dev_info(dev, "probe failed\n");
 	return ret;
@@ -426,10 +415,6 @@ static int __devexit sdo_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(&pdev->dev);
 	clk_disable(sdev->dac);
-	clk_put(sdev->fout_vpll);
-	clk_put(sdev->dacphy);
-	clk_put(sdev->dac);
-	clk_put(sdev->sclk_dac);
 
 	dev_info(&pdev->dev, "remove successful\n");
 	return 0;
-- 
1.7.4.1

