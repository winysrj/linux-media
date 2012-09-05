Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41315 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab2IEL2O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2012 07:28:14 -0400
Received: by dady13 with SMTP id y13so300122dad.19
        for <linux-media@vger.kernel.org>; Wed, 05 Sep 2012 04:28:14 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, g.liakhovetski@gmx.de
Subject: [PATCH 1/2] [media] soc_camera: Use devm_kzalloc function
Date: Wed,  5 Sep 2012 16:55:26 +0530
Message-Id: <1346844327-5524-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_kzalloc() has been used to simplify error handling.
While at it, the soc_camera_device_register function has been moved to
save a few lines of code and a variable.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/soc_camera/soc_camera.c |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 10b57f8..acf5289 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1529,12 +1529,11 @@ static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
 {
 	struct soc_camera_link *icl = pdev->dev.platform_data;
 	struct soc_camera_device *icd;
-	int ret;
 
 	if (!icl)
 		return -EINVAL;
 
-	icd = kzalloc(sizeof(*icd), GFP_KERNEL);
+	icd = devm_kzalloc(&pdev->dev, sizeof(*icd), GFP_KERNEL);
 	if (!icd)
 		return -ENOMEM;
 
@@ -1543,19 +1542,11 @@ static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
 	icd->pdev = &pdev->dev;
 	platform_set_drvdata(pdev, icd);
 
-	ret = soc_camera_device_register(icd);
-	if (ret < 0)
-		goto escdevreg;
 
 	icd->user_width		= DEFAULT_WIDTH;
 	icd->user_height	= DEFAULT_HEIGHT;
 
-	return 0;
-
-escdevreg:
-	kfree(icd);
-
-	return ret;
+	return soc_camera_device_register(icd);
 }
 
 /*
@@ -1572,8 +1563,6 @@ static int __devexit soc_camera_pdrv_remove(struct platform_device *pdev)
 
 	list_del(&icd->list);
 
-	kfree(icd);
-
 	return 0;
 }
 
-- 
1.7.4.1

