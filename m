Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f52.google.com ([209.85.210.52]:45425 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab3CDIZx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 03:25:53 -0500
Received: by mail-da0-f52.google.com with SMTP id x33so2431050dad.25
        for <linux-media@vger.kernel.org>; Mon, 04 Mar 2013 00:25:53 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sachin.kamat@linaro.org,
	thierry.reding@avionic-design.de
Subject: [PATCH 3/4] [media] soc_camera/sh_mobile_ceu_camera: Convert to devm_ioremap_resource()
Date: Mon,  4 Mar 2013 13:45:20 +0530
Message-Id: <1362384921-7344-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1362384921-7344-1-git-send-email-sachin.kamat@linaro.org>
References: <1362384921-7344-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the newly introduced devm_ioremap_resource() instead of
devm_request_and_ioremap() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages; so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index bb08a46..be1af08 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -20,6 +20,7 @@
 #include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
+#include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/interrupt.h>
@@ -2110,11 +2111,9 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
 	pcdev->max_width = pcdev->pdata->max_width ? : 2560;
 	pcdev->max_height = pcdev->pdata->max_height ? : 1920;
 
-	base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!base) {
-		dev_err(&pdev->dev, "Unable to ioremap CEU registers.\n");
-		return -ENXIO;
-	}
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
 	pcdev->irq = irq;
 	pcdev->base = base;
-- 
1.7.4.1

