Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38428 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab2HJLzZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 07:55:25 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr13so2611852pbb.19
        for <linux-media@vger.kernel.org>; Fri, 10 Aug 2012 04:55:25 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, mchehab@infradead.org,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 2/2] [media] s5p-tv: Use devm_* functions in sii9234_drv.c file
Date: Fri, 10 Aug 2012 17:23:46 +0530
Message-Id: <1344599626-21881-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1344599626-21881-1-git-send-email-sachin.kamat@linaro.org>
References: <1344599626-21881-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_* functions are device managed functions and make error handling
and cleanup cleaner and simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-tv/sii9234_drv.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/s5p-tv/sii9234_drv.c b/drivers/media/video/s5p-tv/sii9234_drv.c
index 6d348f9..716d484 100644
--- a/drivers/media/video/s5p-tv/sii9234_drv.c
+++ b/drivers/media/video/s5p-tv/sii9234_drv.c
@@ -323,7 +323,7 @@ static int __devinit sii9234_probe(struct i2c_client *client,
 	struct sii9234_context *ctx;
 	int ret;
 
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	ctx = devm_kzalloc(&client->dev, sizeof(*ctx), GFP_KERNEL);
 	if (!ctx) {
 		dev_err(dev, "out of memory\n");
 		ret = -ENOMEM;
@@ -331,18 +331,17 @@ static int __devinit sii9234_probe(struct i2c_client *client,
 	}
 	ctx->client = client;
 
-	ctx->power = regulator_get(dev, "hdmi-en");
+	ctx->power = devm_regulator_get(dev, "hdmi-en");
 	if (IS_ERR(ctx->power)) {
 		dev_err(dev, "failed to acquire regulator hdmi-en\n");
-		ret = PTR_ERR(ctx->power);
-		goto fail_ctx;
+		return PTR_ERR(ctx->power);
 	}
 
 	ctx->gpio_n_reset = pdata->gpio_n_reset;
 	ret = gpio_request(ctx->gpio_n_reset, "MHL_RST");
 	if (ret) {
 		dev_err(dev, "failed to acquire MHL_RST gpio\n");
-		goto fail_power;
+		return ret;
 	}
 
 	v4l2_i2c_subdev_init(&ctx->sd, client, &sii9234_ops);
@@ -373,12 +372,6 @@ fail_pm:
 	pm_runtime_disable(dev);
 	gpio_free(ctx->gpio_n_reset);
 
-fail_power:
-	regulator_put(ctx->power);
-
-fail_ctx:
-	kfree(ctx);
-
 fail:
 	dev_err(dev, "probe failed\n");
 
@@ -393,8 +386,6 @@ static int __devexit sii9234_remove(struct i2c_client *client)
 
 	pm_runtime_disable(dev);
 	gpio_free(ctx->gpio_n_reset);
-	regulator_put(ctx->power);
-	kfree(ctx);
 
 	dev_info(dev, "remove successful\n");
 
-- 
1.7.4.1

