Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:49392 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757273Ab3DCFMj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Apr 2013 01:12:39 -0400
Received: by mail-pa0-f44.google.com with SMTP id bi5so692853pad.31
        for <linux-media@vger.kernel.org>; Tue, 02 Apr 2013 22:12:38 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sachin.kamat@linaro.org
Subject: [PATCH 7/7] soc_camera/soc_camera_platform: Fix warning related to spacing
Date: Wed,  3 Apr 2013 10:30:41 +0530
Message-Id: <1364965241-28225-7-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1364965241-28225-1-git-send-email-sachin.kamat@linaro.org>
References: <1364965241-28225-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following checkpatch warning:
WARNING: please, no space before tabs

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 .../platform/soc_camera/soc_camera_platform.c      |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c b/drivers/media/platform/soc_camera/soc_camera_platform.c
index ce3b1d6..1b7a88c 100644
--- a/drivers/media/platform/soc_camera/soc_camera_platform.c
+++ b/drivers/media/platform/soc_camera/soc_camera_platform.c
@@ -188,7 +188,7 @@ static int soc_camera_platform_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver soc_camera_platform_driver = {
-	.driver 	= {
+	.driver		= {
 		.name	= "soc_camera_platform",
 		.owner	= THIS_MODULE,
 	},
-- 
1.7.9.5

