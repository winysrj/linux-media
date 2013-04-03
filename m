Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:38834 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761737Ab3DCFMX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Apr 2013 01:12:23 -0400
Received: by mail-pa0-f47.google.com with SMTP id bj3so695853pad.20
        for <linux-media@vger.kernel.org>; Tue, 02 Apr 2013 22:12:23 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sachin.kamat@linaro.org
Subject: [PATCH 1/7] soc_camera/mx1_camera: Fix warnings related to spacing
Date: Wed,  3 Apr 2013 10:30:35 +0530
Message-Id: <1364965241-28225-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following checkpatch warnings:
WARNING: unnecessary whitespace before a quoted newline
WARNING: please, no space before tabs

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/soc_camera/mx1_camera.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx1_camera.c b/drivers/media/platform/soc_camera/mx1_camera.c
index 4389f43..a3fd8d6 100644
--- a/drivers/media/platform/soc_camera/mx1_camera.c
+++ b/drivers/media/platform/soc_camera/mx1_camera.c
@@ -776,7 +776,7 @@ static int __init mx1_camera_probe(struct platform_device *pdev)
 	/* request irq */
 	err = claim_fiq(&fh);
 	if (err) {
-		dev_err(&pdev->dev, "Camera interrupt register failed \n");
+		dev_err(&pdev->dev, "Camera interrupt register failed\n");
 		goto exit_free_dma;
 	}
 
@@ -853,7 +853,7 @@ static int __exit mx1_camera_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver mx1_camera_driver = {
-	.driver 	= {
+	.driver		= {
 		.name	= DRIVER_NAME,
 	},
 	.remove		= __exit_p(mx1_camera_remove),
-- 
1.7.9.5

