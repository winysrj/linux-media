Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:58664 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab3DCFMe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Apr 2013 01:12:34 -0400
Received: by mail-pb0-f54.google.com with SMTP id xa7so642518pbc.13
        for <linux-media@vger.kernel.org>; Tue, 02 Apr 2013 22:12:33 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sachin.kamat@linaro.org
Subject: [PATCH 5/7] soc_camera/pxa_camera: Constify struct dev_pm_ops
Date: Wed,  3 Apr 2013 10:30:39 +0530
Message-Id: <1364965241-28225-5-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1364965241-28225-1-git-send-email-sachin.kamat@linaro.org>
References: <1364965241-28225-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

struct dev_pm_ops should be const.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/soc_camera/pxa_camera.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index b0e6f3b..d665242 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -1796,7 +1796,7 @@ static int pxa_camera_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct dev_pm_ops pxa_camera_pm = {
+static const struct dev_pm_ops pxa_camera_pm = {
 	.suspend	= pxa_camera_suspend,
 	.resume		= pxa_camera_resume,
 };
-- 
1.7.9.5

