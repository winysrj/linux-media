Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51745 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab2KPFB2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 00:01:28 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so1672366pbc.19
        for <linux-media@vger.kernel.org>; Thu, 15 Nov 2012 21:01:27 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, sachin.kamat@linaro.org,
	patches@linaro.org, sylvester.nawrocki@gmail.com,
	s.nawrocki@samsung.com
Subject: [PATCH 1/1] [media] s5p-tv: Use devm_gpio_request in sii9234_drv.c
Date: Fri, 16 Nov 2012 10:25:28 +0530
Message-Id: <1353041728-11032-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_gpio_request is a device managed function and will make
error handling and cleanup a bit simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-tv/sii9234_drv.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/sii9234_drv.c b/drivers/media/platform/s5p-tv/sii9234_drv.c
index 716d484..4597342 100644
--- a/drivers/media/platform/s5p-tv/sii9234_drv.c
+++ b/drivers/media/platform/s5p-tv/sii9234_drv.c
@@ -338,7 +338,7 @@ static int __devinit sii9234_probe(struct i2c_client *client,
 	}
 
 	ctx->gpio_n_reset = pdata->gpio_n_reset;
-	ret = gpio_request(ctx->gpio_n_reset, "MHL_RST");
+	ret = devm_gpio_request(dev, ctx->gpio_n_reset, "MHL_RST");
 	if (ret) {
 		dev_err(dev, "failed to acquire MHL_RST gpio\n");
 		return ret;
@@ -370,7 +370,6 @@ fail_pm_get:
 
 fail_pm:
 	pm_runtime_disable(dev);
-	gpio_free(ctx->gpio_n_reset);
 
 fail:
 	dev_err(dev, "probe failed\n");
@@ -381,11 +380,8 @@ fail:
 static int __devexit sii9234_remove(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
-	struct v4l2_subdev *sd = i2c_get_clientdata(client);
-	struct sii9234_context *ctx = sd_to_context(sd);
 
 	pm_runtime_disable(dev);
-	gpio_free(ctx->gpio_n_reset);
 
 	dev_info(dev, "remove successful\n");
 
-- 
1.7.4.1

