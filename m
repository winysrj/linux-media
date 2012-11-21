Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:31446 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab2KUPdy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Nov 2012 10:33:54 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MDU007LOGK5H700@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Nov 2012 00:33:53 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MDU007TRGK1BY80@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Nov 2012 00:33:53 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] s5p-fimc: Don't use mutex_lock_interruptible() in device
 release()
Date: Wed, 21 Nov 2012 16:33:35 +0100
Message-id: <1353512015-15850-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1353512015-15850-1-git-send-email-s.nawrocki@samsung.com>
References: <1353512015-15850-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use uninterruptible mutex_lock in the release() file op to make
sure all resources are properly freed when a process is being
terminated. Returning -ERESTARTSYS has no effect for a terminating
process and this caused driver resources no to be released.
Not releasing the buffer queue also prevented other drivers to free
memory, e.g. in MMAP -> USERPTR scenario.

Reported-by: Kamil Debski <k.debski@samsung.com>
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-capture.c |    3 +--
 drivers/media/platform/s5p-fimc/fimc-lite.c    |    3 +--
 drivers/media/platform/s5p-fimc/fimc-m2m.c     |    3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 3d39d97..e10d6b1 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -556,8 +556,7 @@ static int fimc_capture_close(struct file *file)
 
 	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
 
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
+	mutex_lock(&fimc->lock);
 
 	if (--fimc->vid_cap.refcnt == 0) {
 		clear_bit(ST_CAPT_BUSY, &fimc->state);
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index 9db246b..2f0a39b 100644
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
diff --git a/drivers/media/platform/s5p-fimc/fimc-m2m.c b/drivers/media/platform/s5p-fimc/fimc-m2m.c
index 4c4e901..dbb7385 100644
--- a/drivers/media/platform/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/platform/s5p-fimc/fimc-m2m.c
@@ -718,8 +718,7 @@ static int fimc_m2m_release(struct file *file)
 	dbg("pid: %d, state: 0x%lx, refcnt= %d",
 		task_pid_nr(current), fimc->state, fimc->m2m.refcnt);
 
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
+	mutex_lock(&fimc->lock);
 
 	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 	fimc_ctrls_delete(ctx);
-- 
1.7.9.5

