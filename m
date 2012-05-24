Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64539 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab2EXPQD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 11:16:03 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M4J0065T9199O80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 May 2012 16:15:09 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4J00L4Y92L1H@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 May 2012 16:15:58 +0100 (BST)
Date: Thu, 24 May 2012 17:15:55 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 6/7] s5p-fimc: Fix fimc-lite system wide suspend procedure
In-reply-to: <1337872556-26406-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1337872556-26406-7-git-send-email-s.nawrocki@samsung.com>
References: <1337872556-26406-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Only suspend the video pipeline devices if they were active before
the pm.suspend() helper is called. This patch prevents following error:

/# echo mem > /sys/power/state
[   34.965000] PM: Syncing filesystems ... done.
[   35.035000] Freezing user space processes ... (elapsed 0.01 seconds) done.
...
[   35.105000] dpm_run_callback(): platform_pm_suspend+0x0/0x5c returns -22
[   35.105000] PM: Device exynos-fimc-lite.1 failed to suspend: error -22
[   35.105000] PM: Some devices failed to suspend

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-lite.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-lite.c b/drivers/media/video/s5p-fimc/fimc-lite.c
index bbe93e4..b0a8ce6 100644
--- a/drivers/media/video/s5p-fimc/fimc-lite.c
+++ b/drivers/media/video/s5p-fimc/fimc-lite.c
@@ -1510,7 +1510,7 @@ static int fimc_lite_suspend(struct device *dev)
 		return 0;
 
 	ret = fimc_lite_stop_capture(fimc, suspend);
-	if (ret)
+	if (ret < 0 || !fimc_lite_active(fimc))
 		return ret;
 
 	return fimc_pipeline_shutdown(&fimc->pipeline);
-- 
1.7.10

