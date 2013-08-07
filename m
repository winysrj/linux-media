Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:46191 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932738Ab3HGMwz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Aug 2013 08:52:55 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, prathyush.k@samsung.com,
	arun.m@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH] [media] exynos-gsc: fix s2r functionality
Date: Wed,  7 Aug 2013 18:23:04 +0530
Message-Id: <1375879984-19052-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Prathyush K <prathyush.k@samsung.com>

When gsc is in runtime suspended state, there is no need to call
m2m_suspend during suspend and similarily, there is no need to call
m2m_resume during resume if already in runtime suspended state. This
patch adds the necessary conditions to achieve this.

Signed-off-by: Prathyush K <prathyush.k@samsung.com>
Signed-off-by: Arun Mankuzhi <arun.m@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 559fab2..fe69eae 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1210,12 +1210,12 @@ static int gsc_resume(struct device *dev)
 		spin_unlock_irqrestore(&gsc->slock, flags);
 		return 0;
 	}
-	gsc_hw_set_sw_reset(gsc);
-	gsc_wait_reset(gsc);
-
 	spin_unlock_irqrestore(&gsc->slock, flags);
 
-	return gsc_m2m_resume(gsc);
+	if (!pm_runtime_suspended(dev))
+		return gsc_runtime_resume(dev);
+
+	return 0;
 }
 
 static int gsc_suspend(struct device *dev)
@@ -1227,7 +1227,10 @@ static int gsc_suspend(struct device *dev)
 	if (test_and_set_bit(ST_SUSPEND, &gsc->state))
 		return 0;
 
-	return gsc_m2m_suspend(gsc);
+	if (!pm_runtime_suspended(dev))
+		return gsc_runtime_suspend(dev);
+
+	return 0;
 }
 
 static const struct dev_pm_ops gsc_pm_ops = {
-- 
1.7.9.5

