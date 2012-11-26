Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63121 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab2KZE4B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 23:56:01 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so7718146pbc.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 20:56:00 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 9/9] [media] s5p-tv: Use devm_clk_get APIs in hdmi_drv
Date: Mon, 26 Nov 2012 10:19:08 +0530
Message-Id: <1353905348-15475-10-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
References: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_clk_get() is device managed and makes error handling
and cleanup a bit simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-tv/hdmi_drv.c |   20 +++++---------------
 1 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index c48eadf..ae3bc28 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -750,16 +750,6 @@ static void hdmi_resources_cleanup(struct hdmi_device *hdev)
 		regulator_bulk_free(res->regul_count, res->regul_bulk);
 	/* kfree is NULL-safe */
 	kfree(res->regul_bulk);
-	if (!IS_ERR_OR_NULL(res->hdmiphy))
-		clk_put(res->hdmiphy);
-	if (!IS_ERR_OR_NULL(res->sclk_hdmiphy))
-		clk_put(res->sclk_hdmiphy);
-	if (!IS_ERR_OR_NULL(res->sclk_pixel))
-		clk_put(res->sclk_pixel);
-	if (!IS_ERR_OR_NULL(res->sclk_hdmi))
-		clk_put(res->sclk_hdmi);
-	if (!IS_ERR_OR_NULL(res->hdmi))
-		clk_put(res->hdmi);
 	memset(res, 0, sizeof(*res));
 }
 
@@ -780,27 +770,27 @@ static int hdmi_resources_init(struct hdmi_device *hdev)
 	memset(res, 0, sizeof(*res));
 	/* get clocks, power */
 
-	res->hdmi = clk_get(dev, "hdmi");
+	res->hdmi = devm_clk_get(dev, "hdmi");
 	if (IS_ERR_OR_NULL(res->hdmi)) {
 		dev_err(dev, "failed to get clock 'hdmi'\n");
 		goto fail;
 	}
-	res->sclk_hdmi = clk_get(dev, "sclk_hdmi");
+	res->sclk_hdmi = devm_clk_get(dev, "sclk_hdmi");
 	if (IS_ERR_OR_NULL(res->sclk_hdmi)) {
 		dev_err(dev, "failed to get clock 'sclk_hdmi'\n");
 		goto fail;
 	}
-	res->sclk_pixel = clk_get(dev, "sclk_pixel");
+	res->sclk_pixel = devm_clk_get(dev, "sclk_pixel");
 	if (IS_ERR_OR_NULL(res->sclk_pixel)) {
 		dev_err(dev, "failed to get clock 'sclk_pixel'\n");
 		goto fail;
 	}
-	res->sclk_hdmiphy = clk_get(dev, "sclk_hdmiphy");
+	res->sclk_hdmiphy = devm_clk_get(dev, "sclk_hdmiphy");
 	if (IS_ERR_OR_NULL(res->sclk_hdmiphy)) {
 		dev_err(dev, "failed to get clock 'sclk_hdmiphy'\n");
 		goto fail;
 	}
-	res->hdmiphy = clk_get(dev, "hdmiphy");
+	res->hdmiphy = devm_clk_get(dev, "hdmiphy");
 	if (IS_ERR_OR_NULL(res->hdmiphy)) {
 		dev_err(dev, "failed to get clock 'hdmiphy'\n");
 		goto fail;
-- 
1.7.4.1

