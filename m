Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:54477 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab3D3Jl6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Apr 2013 05:41:58 -0400
Received: by mail-pd0-f182.google.com with SMTP id 14so210455pdj.13
        for <linux-media@vger.kernel.org>; Tue, 30 Apr 2013 02:41:58 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/2] [media] soc_camera: Constify dev_pm_ops in mt9t031.c
Date: Tue, 30 Apr 2013 14:59:08 +0530
Message-Id: <1367314149-16448-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Silences the following warning:
WARNING: struct dev_pm_ops should normally be const

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/i2c/soc_camera/mt9t031.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index 26a15b8..191e3f1 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -595,7 +595,7 @@ static int mt9t031_runtime_resume(struct device *dev)
 	return 0;
 }
 
-static struct dev_pm_ops mt9t031_dev_pm_ops = {
+static const struct dev_pm_ops mt9t031_dev_pm_ops = {
 	.runtime_suspend	= mt9t031_runtime_suspend,
 	.runtime_resume		= mt9t031_runtime_resume,
 };
-- 
1.7.9.5

