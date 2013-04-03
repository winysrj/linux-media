Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:47090 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761766Ab3DCFMb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Apr 2013 01:12:31 -0400
Received: by mail-pb0-f49.google.com with SMTP id um15so633767pbc.8
        for <linux-media@vger.kernel.org>; Tue, 02 Apr 2013 22:12:30 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sachin.kamat@linaro.org
Subject: [PATCH 4/7] soc_camera/pxa_camera: Fix warning related to spacing
Date: Wed,  3 Apr 2013 10:30:38 +0530
Message-Id: <1364965241-28225-4-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1364965241-28225-1-git-send-email-sachin.kamat@linaro.org>
References: <1364965241-28225-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following checkpatch warning:
WARNING: please, no space before tabs

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/soc_camera/pxa_camera.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 42abbce..b0e6f3b 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -1802,7 +1802,7 @@ static struct dev_pm_ops pxa_camera_pm = {
 };
 
 static struct platform_driver pxa_camera_driver = {
-	.driver 	= {
+	.driver		= {
 		.name	= PXA_CAM_DRV_NAME,
 		.pm	= &pxa_camera_pm,
 	},
-- 
1.7.9.5

