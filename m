Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:31434 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab2KUPdr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Nov 2012 10:33:47 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MDU007LOGK5H700@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Nov 2012 00:33:46 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MDU007TRGK1BY80@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Nov 2012 00:33:45 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] exynos-gsc: Don't use mutex_lock_interruptible() in device
 release()
Date: Wed, 21 Nov 2012 16:33:34 +0100
Message-id: <1353512015-15850-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use uninterruptible mutex_lock in the release() file op to make
sure all resources are properly freed when a process is being
terminated. Returning -ERESTARTSYS has no effect for a terminating
process and this may cause driver resources no to be released.

Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-m2m.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index 047f0f0..910ef76f 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -657,8 +657,7 @@ static int gsc_m2m_release(struct file *file)
 	pr_debug("pid: %d, state: 0x%lx, refcnt= %d",
 		task_pid_nr(current), gsc->state, gsc->m2m.refcnt);
 
-	if (mutex_lock_interruptible(&gsc->lock))
-		return -ERESTARTSYS;
+	mutex_lock(&gsc->lock);
 
 	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 	gsc_ctrls_delete(ctx);
-- 
1.7.9.5

