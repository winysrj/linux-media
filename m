Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:30759 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab2KVSf0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 13:35:26 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	stable@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 2/2] fimc-lite: Don't use mutex_lock_interruptible() in
 device release()
Date: Thu, 22 Nov 2012 15:24:49 +0100
Message-id: <1353594289-7381-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1353594289-7381-1-git-send-email-s.nawrocki@samsung.com>
References: <1353594289-7381-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use uninterruptible mutex_lock in the release() file op to make
sure all resources are properly freed when a process is being
terminated. Returning -ERESTARTSYS has no effect for a terminating
process and this may cause driver resources not to be released.

This patch is required for stable kernels v3.5+.

Cc: stable@vger.kernel.org
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-lite.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index 23f203e..1b309a7 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -491,8 +491,7 @@ static int fimc_lite_close(struct file *file)
 	struct fimc_lite *fimc = video_drvdata(file);
 	int ret;
 
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
+	mutex_lock(&fimc->lock);
 
 	if (--fimc->ref_count == 0 && fimc->out_path == FIMC_IO_DMA) {
 		clear_bit(ST_FLITE_IN_USE, &fimc->state);
-- 
1.7.9.5

