Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38428 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab2HJLzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 07:55:22 -0400
Received: by pbbrr13 with SMTP id rr13so2611852pbb.19
        for <linux-media@vger.kernel.org>; Fri, 10 Aug 2012 04:55:21 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, mchehab@infradead.org,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/2] [media] s5p-tv: Use devm_regulator_get() in sdo_drv.c file
Date: Fri, 10 Aug 2012 17:23:45 +0530
Message-Id: <1344599626-21881-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_regulator_get() is a device managed function and makes the exit code
a bit simpler and cleaner.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-tv/sdo_drv.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/s5p-tv/sdo_drv.c b/drivers/media/video/s5p-tv/sdo_drv.c
index f6bca2c..ad68bbe 100644
--- a/drivers/media/video/s5p-tv/sdo_drv.c
+++ b/drivers/media/video/s5p-tv/sdo_drv.c
@@ -374,15 +374,15 @@ static int __devinit sdo_probe(struct platform_device *pdev)
 	dev_info(dev, "fout_vpll.rate = %lu\n", clk_get_rate(sclk_vpll));
 
 	/* acquire regulator */
-	sdev->vdac = regulator_get(dev, "vdd33a_dac");
+	sdev->vdac = devm_regulator_get(dev, "vdd33a_dac");
 	if (IS_ERR_OR_NULL(sdev->vdac)) {
 		dev_err(dev, "failed to get regulator 'vdac'\n");
 		goto fail_fout_vpll;
 	}
-	sdev->vdet = regulator_get(dev, "vdet");
+	sdev->vdet = devm_regulator_get(dev, "vdet");
 	if (IS_ERR_OR_NULL(sdev->vdet)) {
 		dev_err(dev, "failed to get regulator 'vdet'\n");
-		goto fail_vdac;
+		goto fail_fout_vpll;
 	}
 
 	/* enable gate for dac clock, because mixer uses it */
@@ -406,8 +406,6 @@ static int __devinit sdo_probe(struct platform_device *pdev)
 	dev_info(dev, "probe succeeded\n");
 	return 0;
 
-fail_vdac:
-	regulator_put(sdev->vdac);
 fail_fout_vpll:
 	clk_put(sdev->fout_vpll);
 fail_dacphy:
@@ -428,8 +426,6 @@ static int __devexit sdo_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(&pdev->dev);
 	clk_disable(sdev->dac);
-	regulator_put(sdev->vdet);
-	regulator_put(sdev->vdac);
 	clk_put(sdev->fout_vpll);
 	clk_put(sdev->dacphy);
 	clk_put(sdev->dac);
-- 
1.7.4.1

