Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42343 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022Ab2JQLQl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 07:16:41 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so6997024pad.19
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2012 04:16:41 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org,
	patches@linaro.org, Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 4/8] [media] s5p-tv: Use clk_prepare_enable and clk_disable_unprepare
Date: Wed, 17 Oct 2012 16:41:47 +0530
Message-Id: <1350472311-9748-4-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1350472311-9748-1-git-send-email-sachin.kamat@linaro.org>
References: <1350472311-9748-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace clk_enable/clk_disable with clk_prepare_enable/clk_disable_unprepare
as required by the common clock framework.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/media/platform/s5p-tv/hdmi_drv.c  |   20 ++++++++++----------
 drivers/media/platform/s5p-tv/mixer_drv.c |   12 ++++++------
 drivers/media/platform/s5p-tv/sdo_drv.c   |   12 ++++++------
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 8a9cf43..497e8ab 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -542,9 +542,9 @@ static int hdmi_streamon(struct hdmi_device *hdev)
 	}
 
 	/* hdmiphy clock is used for HDMI in streaming mode */
-	clk_disable(res->sclk_hdmi);
+	clk_disable_unprepare(res->sclk_hdmi);
 	clk_set_parent(res->sclk_hdmi, res->sclk_hdmiphy);
-	clk_enable(res->sclk_hdmi);
+	clk_prepare_enable(res->sclk_hdmi);
 
 	/* enable HDMI and timing generator */
 	hdmi_write_mask(hdev, HDMI_CON_0, ~0, HDMI_EN);
@@ -564,9 +564,9 @@ static int hdmi_streamoff(struct hdmi_device *hdev)
 	hdmi_write_mask(hdev, HDMI_TG_CMD, 0, HDMI_TG_EN);
 
 	/* pixel(vpll) clock is used for HDMI in config mode */
-	clk_disable(res->sclk_hdmi);
+	clk_disable_unprepare(res->sclk_hdmi);
 	clk_set_parent(res->sclk_hdmi, res->sclk_pixel);
-	clk_enable(res->sclk_hdmi);
+	clk_prepare_enable(res->sclk_hdmi);
 
 	v4l2_subdev_call(hdev->mhl_sd, video, s_stream, 0);
 	v4l2_subdev_call(hdev->phy_sd, video, s_stream, 0);
@@ -591,19 +591,19 @@ static void hdmi_resource_poweron(struct hdmi_resources *res)
 	/* turn HDMI power on */
 	regulator_bulk_enable(res->regul_count, res->regul_bulk);
 	/* power-on hdmi physical interface */
-	clk_enable(res->hdmiphy);
+	clk_prepare_enable(res->hdmiphy);
 	/* use VPP as parent clock; HDMIPHY is not working yet */
 	clk_set_parent(res->sclk_hdmi, res->sclk_pixel);
 	/* turn clocks on */
-	clk_enable(res->sclk_hdmi);
+	clk_prepare_enable(res->sclk_hdmi);
 }
 
 static void hdmi_resource_poweroff(struct hdmi_resources *res)
 {
 	/* turn clocks off */
-	clk_disable(res->sclk_hdmi);
+	clk_disable_unprepare(res->sclk_hdmi);
 	/* power-off hdmiphy */
-	clk_disable(res->hdmiphy);
+	clk_disable_unprepare(res->hdmiphy);
 	/* turn HDMI power off */
 	regulator_bulk_disable(res->regul_count, res->regul_bulk);
 }
@@ -947,7 +947,7 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 		}
 	}
 
-	clk_enable(hdmi_dev->res.hdmi);
+	clk_prepare_enable(hdmi_dev->res.hdmi);
 
 	pm_runtime_enable(dev);
 
@@ -986,7 +986,7 @@ static int __devexit hdmi_remove(struct platform_device *pdev)
 	struct hdmi_device *hdmi_dev = sd_to_hdmi_dev(sd);
 
 	pm_runtime_disable(dev);
-	clk_disable(hdmi_dev->res.hdmi);
+	clk_disable_unprepare(hdmi_dev->res.hdmi);
 	v4l2_device_unregister(&hdmi_dev->v4l2_dev);
 	disable_irq(hdmi_dev->irq);
 	hdmi_resources_cleanup(hdmi_dev);
diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
index ca0f297..dea0520 100644
--- a/drivers/media/platform/s5p-tv/mixer_drv.c
+++ b/drivers/media/platform/s5p-tv/mixer_drv.c
@@ -339,9 +339,9 @@ static int mxr_runtime_resume(struct device *dev)
 	mxr_dbg(mdev, "resume - start\n");
 	mutex_lock(&mdev->mutex);
 	/* turn clocks on */
-	clk_enable(res->mixer);
-	clk_enable(res->vp);
-	clk_enable(res->sclk_mixer);
+	clk_prepare_enable(res->mixer);
+	clk_prepare_enable(res->vp);
+	clk_prepare_enable(res->sclk_mixer);
 	/* apply default configuration */
 	mxr_reg_reset(mdev);
 	mxr_dbg(mdev, "resume - finished\n");
@@ -357,9 +357,9 @@ static int mxr_runtime_suspend(struct device *dev)
 	mxr_dbg(mdev, "suspend - start\n");
 	mutex_lock(&mdev->mutex);
 	/* turn clocks off */
-	clk_disable(res->sclk_mixer);
-	clk_disable(res->vp);
-	clk_disable(res->mixer);
+	clk_disable_unprepare(res->sclk_mixer);
+	clk_disable_unprepare(res->vp);
+	clk_disable_unprepare(res->mixer);
 	mutex_unlock(&mdev->mutex);
 	mxr_dbg(mdev, "suspend - finished\n");
 	return 0;
diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
index ad68bbe..21d213a 100644
--- a/drivers/media/platform/s5p-tv/sdo_drv.c
+++ b/drivers/media/platform/s5p-tv/sdo_drv.c
@@ -199,7 +199,7 @@ static int sdo_streamon(struct sdo_device *sdev)
 	clk_get_rate(sdev->fout_vpll));
 	/* enable clock in SDO */
 	sdo_write_mask(sdev, SDO_CLKCON, ~0, SDO_TVOUT_CLOCK_ON);
-	clk_enable(sdev->dacphy);
+	clk_prepare_enable(sdev->dacphy);
 	/* enable DAC */
 	sdo_write_mask(sdev, SDO_DAC, ~0, SDO_POWER_ON_DAC);
 	sdo_reg_debug(sdev);
@@ -211,7 +211,7 @@ static int sdo_streamoff(struct sdo_device *sdev)
 	int tries;
 
 	sdo_write_mask(sdev, SDO_DAC, 0, SDO_POWER_ON_DAC);
-	clk_disable(sdev->dacphy);
+	clk_disable_unprepare(sdev->dacphy);
 	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_CLOCK_ON);
 	for (tries = 100; tries; --tries) {
 		if (sdo_read(sdev, SDO_CLKCON) & SDO_TVOUT_CLOCK_READY)
@@ -254,7 +254,7 @@ static int sdo_runtime_suspend(struct device *dev)
 	dev_info(dev, "suspend\n");
 	regulator_disable(sdev->vdet);
 	regulator_disable(sdev->vdac);
-	clk_disable(sdev->sclk_dac);
+	clk_disable_unprepare(sdev->sclk_dac);
 	return 0;
 }
 
@@ -264,7 +264,7 @@ static int sdo_runtime_resume(struct device *dev)
 	struct sdo_device *sdev = sd_to_sdev(sd);
 
 	dev_info(dev, "resume\n");
-	clk_enable(sdev->sclk_dac);
+	clk_prepare_enable(sdev->sclk_dac);
 	regulator_enable(sdev->vdac);
 	regulator_enable(sdev->vdet);
 
@@ -386,7 +386,7 @@ static int __devinit sdo_probe(struct platform_device *pdev)
 	}
 
 	/* enable gate for dac clock, because mixer uses it */
-	clk_enable(sdev->dac);
+	clk_prepare_enable(sdev->dac);
 
 	/* configure power management */
 	pm_runtime_enable(dev);
@@ -425,7 +425,7 @@ static int __devexit sdo_remove(struct platform_device *pdev)
 	struct sdo_device *sdev = sd_to_sdev(sd);
 
 	pm_runtime_disable(&pdev->dev);
-	clk_disable(sdev->dac);
+	clk_disable_unprepare(sdev->dac);
 	clk_put(sdev->fout_vpll);
 	clk_put(sdev->dacphy);
 	clk_put(sdev->dac);
-- 
1.7.4.1

