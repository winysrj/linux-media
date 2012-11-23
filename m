Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:63829 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab2KWL5O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 06:57:14 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so2614834dak.19
        for <linux-media@vger.kernel.org>; Fri, 23 Nov 2012 03:57:14 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org,
	patches@linaro.org, Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: [PATCH 5/6] [media] s5p-jpeg: Use devm_clk_get APIs.
Date: Fri, 23 Nov 2012 17:20:42 +0530
Message-Id: <1353671443-2978-6-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353671443-2978-1-git-send-email-sachin.kamat@linaro.org>
References: <1353671443-2978-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_clk_get() is device managed function and makes error handling
and exit code a bit simpler.

Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 17983c4..fc63d27 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1346,7 +1346,7 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 	}
 
 	/* clocks */
-	jpeg->clk = clk_get(&pdev->dev, "jpeg");
+	jpeg->clk = devm_clk_get(&pdev->dev, "jpeg");
 	if (IS_ERR(jpeg->clk)) {
 		dev_err(&pdev->dev, "cannot get clock\n");
 		ret = PTR_ERR(jpeg->clk);
@@ -1461,7 +1461,6 @@ device_register_rollback:
 
 clk_get_rollback:
 	clk_disable_unprepare(jpeg->clk);
-	clk_put(jpeg->clk);
 
 	return ret;
 }
@@ -1481,7 +1480,6 @@ static int s5p_jpeg_remove(struct platform_device *pdev)
 	v4l2_device_unregister(&jpeg->v4l2_dev);
 
 	clk_disable_unprepare(jpeg->clk);
-	clk_put(jpeg->clk);
 
 	return 0;
 }
-- 
1.7.4.1

