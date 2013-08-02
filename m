Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:54296 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3HBGs5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 02:48:57 -0400
Received: by mail-pd0-f181.google.com with SMTP id g10so324442pdj.26
        for <linux-media@vger.kernel.org>; Thu, 01 Aug 2013 23:48:57 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 3/3] [media] exynos4-is: Fix potential NULL pointer dereference
Date: Fri,  2 Aug 2013 12:02:14 +0530
Message-Id: <1375425134-17080-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1375425134-17080-1-git-send-email-sachin.kamat@linaro.org>
References: <1375425134-17080-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dev->of_node could be NULL. Hence check for the same and return before
dereferencing it in the subsequent error message.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/exynos4-is/fimc-lite.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 08fbfed..214bde2 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1513,6 +1513,9 @@ static int fimc_lite_probe(struct platform_device *pdev)
 		if (of_id)
 			drv_data = (struct flite_drvdata *)of_id->data;
 		fimc->index = of_alias_get_id(dev->of_node, "fimc-lite");
+	} else {
+		dev_err(dev, "device node not found\n");
+		return -EINVAL;
 	}
 
 	if (!drv_data || fimc->index >= drv_data->num_instances ||
-- 
1.7.9.5

