Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f41.google.com ([209.85.210.41]:32776 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761742Ab3DCFM0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Apr 2013 01:12:26 -0400
Received: by mail-da0-f41.google.com with SMTP id w4so507902dam.28
        for <linux-media@vger.kernel.org>; Tue, 02 Apr 2013 22:12:26 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sachin.kamat@linaro.org
Subject: [PATCH 2/7] soc_camera/mx2_camera: Fix warnings related to spacing
Date: Wed,  3 Apr 2013 10:30:36 +0530
Message-Id: <1364965241-28225-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1364965241-28225-1-git-send-email-sachin.kamat@linaro.org>
References: <1364965241-28225-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following checkpatch warnings:
WARNING: unnecessary whitespace before a quoted newline
WARNING: please, no space before tabs

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/soc_camera/mx2_camera.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 048c26a..3a0ffbb 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -1454,7 +1454,7 @@ static int mx27_camera_emma_init(struct platform_device *pdev)
 	err = devm_request_irq(pcdev->dev, irq_emma, mx27_camera_emma_irq, 0,
 			       MX2_CAM_DRV_NAME, pcdev);
 	if (err) {
-		dev_err(pcdev->dev, "Camera EMMA interrupt register failed \n");
+		dev_err(pcdev->dev, "Camera EMMA interrupt register failed\n");
 		goto out;
 	}
 
@@ -1615,7 +1615,7 @@ static int mx2_camera_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver mx2_camera_driver = {
-	.driver 	= {
+	.driver		= {
 		.name	= MX2_CAM_DRV_NAME,
 	},
 	.id_table	= mx2_camera_devtype,
-- 
1.7.9.5

