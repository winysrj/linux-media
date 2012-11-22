Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:57391 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab2KVSfH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 13:35:07 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	stable@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 1/2] s5p-fimc: Don't use mutex_lock_interruptible() in
 device release()
Date: Thu, 22 Nov 2012 15:24:48 +0100
Message-id: <1353594289-7381-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use uninterruptible mutex_lock in the release() file op to make
sure all resources are properly freed when a process is being
terminated. Returning -ERESTARTSYS has no effect for a terminating
process and this caused driver resources not to be released. Not
releasing the buffer queue also prevented other drivers to free
memory, e.g. in MMAP -> USERPTR scenario.

This patch is required for stable kernels v3.6+.

Cc: stable@vger.kernel.org
Reported-by: Kamil Debski <k.debski@samsung.com>
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v1:
 - previous patch split in t make it applicable to relevant
  stable kernels

 drivers/media/platform/s5p-fimc/fimc-capture.c |    3 +--
 drivers/media/platform/s5p-fimc/fimc-m2m.c     |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 3fc896b..891ee87 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -556,8 +556,7 @@ static int fimc_capture_close(struct file *file)

 	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);

-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
+	mutex_lock(&fimc->lock);

 	if (--fimc->vid_cap.refcnt == 0) {
 		clear_bit(ST_CAPT_BUSY, &fimc->state);
diff --git a/drivers/media/platform/s5p-fimc/fimc-m2m.c b/drivers/media/platform/s5p-fimc/fimc-m2m.c
index 4500e44..62afed3 100644
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

