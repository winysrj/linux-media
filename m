Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35369 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761742Ab3DCFM2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Apr 2013 01:12:28 -0400
Received: by mail-pa0-f47.google.com with SMTP id bj3so695891pad.20
        for <linux-media@vger.kernel.org>; Tue, 02 Apr 2013 22:12:28 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sachin.kamat@linaro.org
Subject: [PATCH 3/7] soc_camera/mx3_camera: Fix warning related to spacing
Date: Wed,  3 Apr 2013 10:30:37 +0530
Message-Id: <1364965241-28225-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1364965241-28225-1-git-send-email-sachin.kamat@linaro.org>
References: <1364965241-28225-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Silences the following checkpatch warning:
WARNING: please, no space before tabs

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/soc_camera/mx3_camera.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 2c3bd69..5da3377 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -1276,7 +1276,7 @@ static int mx3_camera_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver mx3_camera_driver = {
-	.driver 	= {
+	.driver		= {
 		.name	= MX3_CAM_DRV_NAME,
 	},
 	.probe		= mx3_camera_probe,
-- 
1.7.9.5

