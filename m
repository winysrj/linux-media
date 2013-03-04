Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:61883 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab3CDIZ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 03:25:56 -0500
Received: by mail-pa0-f48.google.com with SMTP id hz10so3004928pad.21
        for <linux-media@vger.kernel.org>; Mon, 04 Mar 2013 00:25:55 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sachin.kamat@linaro.org,
	thierry.reding@avionic-design.de
Subject: [PATCH 4/4] [media] soc_camera/sh_mobile_csi2: Convert to devm_ioremap_resource()
Date: Mon,  4 Mar 2013 13:45:21 +0530
Message-Id: <1362384921-7344-4-git-send-email-sachin.kamat@linaro.org>
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
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/soc_camera/sh_mobile_csi2.c b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
index 42c559e..09cb4fc 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_csi2.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/err.h>
 #include <linux/i2c.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
@@ -324,11 +325,9 @@ static int sh_csi2_probe(struct platform_device *pdev)
 
 	priv->irq = irq;
 
-	priv->base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!priv->base) {
-		dev_err(&pdev->dev, "Unable to ioremap CSI2 registers.\n");
-		return -ENXIO;
-	}
+	priv->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->base))
+		return PTR_ERR(priv->base);
 
 	priv->pdev = pdev;
 	platform_set_drvdata(pdev, priv);
-- 
1.7.4.1

