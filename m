Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44328 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab3CDIZu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 03:25:50 -0500
Received: by mail-pa0-f51.google.com with SMTP id hz1so3015079pad.24
        for <linux-media@vger.kernel.org>; Mon, 04 Mar 2013 00:25:50 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sachin.kamat@linaro.org,
	thierry.reding@avionic-design.de
Subject: [PATCH 2/4] [media] soc_camera/pxa_camera: Convert to devm_ioremap_resource()
Date: Mon,  4 Mar 2013 13:45:19 +0530
Message-Id: <1362384921-7344-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1362384921-7344-1-git-send-email-sachin.kamat@linaro.org>
References: <1362384921-7344-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the newly introduced devm_ioremap_resource() instead of
devm_request_and_ioremap() which provides more consistent error handling.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/soc_camera/pxa_camera.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 395e2e0..42abbce 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -15,6 +15,7 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
+#include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/interrupt.h>
@@ -1710,9 +1711,10 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	/*
 	 * Request the regions.
 	 */
-	base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!base)
-		return -ENOMEM;
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
 	pcdev->irq = irq;
 	pcdev->base = base;
 
-- 
1.7.4.1

