Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:35253 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab3H1QOx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Aug 2013 12:14:53 -0400
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kyungmin.park@samsung.com
Cc: t.stanislaws@samsung.com, m.chehab@samsung.com,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
	pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
	ian.campbell@citrix.com, rob@landley.net, mturquette@linaro.org,
	tomasz.figa@gmail.com, kgene.kim@samsung.com,
	thomas.abraham@linaro.org, s.nawrocki@samsung.com,
	devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
	linux@arm.linux.org.uk, ben-linux@fluff.org,
	linux-samsung-soc@vger.kernel.org,
	Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH v3 3/6] media: s5p-tv: Fix sdo driver to work with CCF
Date: Wed, 28 Aug 2013 18:13:01 +0200
Message-id: <1377706384-3697-4-git-send-email-m.krawczuk@partner.samsung.com>
In-reply-to: <1377706384-3697-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377706384-3697-1-git-send-email-m.krawczuk@partner.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace clk_enable by clock_enable_prepare and clk_disable with clk_disable_unprepare.
Clock prepare is required by Clock Common Framework, and old clock driver didn`t support it.
Without it Common Clock Framework prints a warning.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
---
 drivers/media/platform/s5p-tv/sdo_drv.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
index 9dbdfe6..a79e620 100644
--- a/drivers/media/platform/s5p-tv/sdo_drv.c
+++ b/drivers/media/platform/s5p-tv/sdo_drv.c
@@ -209,10 +209,10 @@ static int sdo_streamon(struct sdo_device *sdev)
 	clk_get_rate(sdev->fout_vpll));
 	/* enable clock in SDO */
 	sdo_write_mask(sdev, SDO_CLKCON, ~0, SDO_TVOUT_CLOCK_ON);
-	ret = clk_enable(sdev->dacphy);
+	ret = clk_prepare_enable(sdev->dacphy);
 	if (ret < 0) {
 		dev_err(sdev->dev,
-			"clk_enable(dacphy) failed !\n");
+			"clk_prepare_enable(dacphy) failed !\n");
 		goto fail;
 	}
 	/* enable DAC */
@@ -230,7 +230,7 @@ static int sdo_streamoff(struct sdo_device *sdev)
 	int tries;
 
 	sdo_write_mask(sdev, SDO_DAC, 0, SDO_POWER_ON_DAC);
-	clk_disable(sdev->dacphy);
+	clk_disable_unprepare(sdev->dacphy);
 	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_CLOCK_ON);
 	for (tries = 100; tries; --tries) {
 		if (sdo_read(sdev, SDO_CLKCON) & SDO_TVOUT_CLOCK_READY)
@@ -274,7 +274,7 @@ static int sdo_runtime_suspend(struct device *dev)
 	dev_info(dev, "suspend\n");
 	regulator_disable(sdev->vdet);
 	regulator_disable(sdev->vdac);
-	clk_disable(sdev->sclk_dac);
+	clk_disable_unprepare(sdev->sclk_dac);
 	return 0;
 }
 
@@ -286,7 +286,7 @@ static int sdo_runtime_resume(struct device *dev)
 
 	dev_info(dev, "resume\n");
 
-	ret = clk_enable(sdev->sclk_dac);
+	ret = clk_prepare_enable(sdev->sclk_dac);
 	if (ret < 0)
 		return ret;
 
@@ -319,7 +319,7 @@ static int sdo_runtime_resume(struct device *dev)
 vdac_r_dis:
 	regulator_disable(sdev->vdac);
 dac_clk_dis:
-	clk_disable(sdev->sclk_dac);
+	clk_disable_unprepare(sdev->sclk_dac);
 	return ret;
 }
 
@@ -333,7 +333,7 @@ static int sdo_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct sdo_device *sdev;
 	struct resource *res;
-	int ret = 0;
+	int ret;
 	struct clk *sclk_vpll;
 
 	dev_info(dev, "probe start\n");
@@ -425,8 +425,13 @@ static int sdo_probe(struct platform_device *pdev)
 	}
 
 	/* enable gate for dac clock, because mixer uses it */
-	clk_enable(sdev->dac);
-
+	ret = clk_prepare_enable(sdev->dac);
+	if (ret < 0) {
+		dev_err(dev,
+			"clk_prepare_enable_enable(dac) failed !\n");
+		ret = PTR_ERR(sdev->dac);
+		goto fail_fout_vpll;
+	}
 	/* configure power management */
 	pm_runtime_enable(dev);
 
@@ -464,7 +469,7 @@ static int sdo_remove(struct platform_device *pdev)
 	struct sdo_device *sdev = sd_to_sdev(sd);
 
 	pm_runtime_disable(&pdev->dev);
-	clk_disable(sdev->dac);
+	clk_disable_unprepare(sdev->dac);
 	clk_put(sdev->fout_vpll);
 	clk_put(sdev->dacphy);
 	clk_put(sdev->dac);
-- 
1.8.1.2

