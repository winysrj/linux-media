Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:37083 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3EMJcn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 05:32:43 -0400
Received: by mail-pd0-f173.google.com with SMTP id v10so4290252pde.4
        for <linux-media@vger.kernel.org>; Mon, 13 May 2013 02:32:43 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sachin.kamat@linaro.org
Subject: [PATCH 2/2] [media] soc_camera_platform: Remove redundant platform_set_drvdata()
Date: Mon, 13 May 2013 14:49:21 +0530
Message-Id: <1368436761-12183-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1368436761-12183-1-git-send-email-sachin.kamat@linaro.org>
References: <1368436761-12183-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 0998d06310 (device-core: Ensure drvdata = NULL when no
driver is bound) removes the need to set driver data field to
NULL.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 .../platform/soc_camera/soc_camera_platform.c      |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c b/drivers/media/platform/soc_camera/soc_camera_platform.c
index 1b7a88c..bf0bdd0 100644
--- a/drivers/media/platform/soc_camera/soc_camera_platform.c
+++ b/drivers/media/platform/soc_camera/soc_camera_platform.c
@@ -166,14 +166,8 @@ static int soc_camera_platform_probe(struct platform_device *pdev)
 	strncpy(priv->subdev.name, dev_name(&pdev->dev), V4L2_SUBDEV_NAME_SIZE);
 
 	ret = v4l2_device_register_subdev(&ici->v4l2_dev, &priv->subdev);
-	if (ret)
-		goto evdrs;
 
 	return ret;
-
-evdrs:
-	platform_set_drvdata(pdev, NULL);
-	return ret;
 }
 
 static int soc_camera_platform_remove(struct platform_device *pdev)
@@ -183,7 +177,6 @@ static int soc_camera_platform_remove(struct platform_device *pdev)
 
 	p->icd->control = NULL;
 	v4l2_device_unregister_subdev(&priv->subdev);
-	platform_set_drvdata(pdev, NULL);
 	return 0;
 }
 
-- 
1.7.9.5

