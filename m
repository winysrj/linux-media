Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f49.google.com ([209.85.210.49]:37279 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3EMJck (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 05:32:40 -0400
Received: by mail-da0-f49.google.com with SMTP id p5so764717dak.8
        for <linux-media@vger.kernel.org>; Mon, 13 May 2013 02:32:40 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sachin.kamat@linaro.org
Subject: [PATCH 1/2] [media] soc_camera/sh_mobile_csi2: Remove redundant platform_set_drvdata()
Date: Mon, 13 May 2013 14:49:20 +0530
Message-Id: <1368436761-12183-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 0998d06310 (device-core: Ensure drvdata = NULL when no
driver is bound) removes the need to set driver data field to
NULL.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/media/platform/soc_camera/sh_mobile_csi2.c b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
index 09cb4fc..13a1f8f 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_csi2.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
@@ -340,18 +340,13 @@ static int sh_csi2_probe(struct platform_device *pdev)
 	ret = v4l2_device_register_subdev(pdata->v4l2_dev, &priv->subdev);
 	dev_dbg(&pdev->dev, "%s(%p): ret(register_subdev) = %d\n", __func__, priv, ret);
 	if (ret < 0)
-		goto esdreg;
+		return ret;
 
 	pm_runtime_enable(&pdev->dev);
 
 	dev_dbg(&pdev->dev, "CSI2 probed.\n");
 
 	return 0;
-
-esdreg:
-	platform_set_drvdata(pdev, NULL);
-
-	return ret;
 }
 
 static int sh_csi2_remove(struct platform_device *pdev)
@@ -360,7 +355,6 @@ static int sh_csi2_remove(struct platform_device *pdev)
 
 	v4l2_device_unregister_subdev(&priv->subdev);
 	pm_runtime_disable(&pdev->dev);
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
-- 
1.7.9.5

