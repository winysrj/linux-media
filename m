Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:33064 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757273Ab3DCFMg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Apr 2013 01:12:36 -0400
Received: by mail-pb0-f41.google.com with SMTP id mc17so646016pbc.28
        for <linux-media@vger.kernel.org>; Tue, 02 Apr 2013 22:12:36 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sachin.kamat@linaro.org
Subject: [PATCH 6/7] soc_camera/sh_mobile_ceu_camera: Fix warning related to spacing
Date: Wed,  3 Apr 2013 10:30:40 +0530
Message-Id: <1364965241-28225-6-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1364965241-28225-1-git-send-email-sachin.kamat@linaro.org>
References: <1364965241-28225-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following checkpatch warning:
WARNING: please, no space before tabs

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index d7294ef..143d29fe 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -2288,7 +2288,7 @@ static const struct dev_pm_ops sh_mobile_ceu_dev_pm_ops = {
 };
 
 static struct platform_driver sh_mobile_ceu_driver = {
-	.driver 	= {
+	.driver		= {
 		.name	= "sh_mobile_ceu",
 		.pm	= &sh_mobile_ceu_dev_pm_ops,
 	},
-- 
1.7.9.5

