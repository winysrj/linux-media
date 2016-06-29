Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:52082 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbcF2Jby (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 05:31:54 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, k.debski@samsung.com,
	b.zolnierkie@samsung.com, m.szyprowski@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] exynos4-is: Fix buffer release issue on fimc m2m video nodes
Date: Wed, 29 Jun 2016 11:31:30 +0200
Message-id: <1467192690-6101-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes dropping ownership of buffers in the driver's stop_streaming
callback, so buffers on the memory-to-memory video nodes are properly
released, also in case when the driver has a buffer only on one of the
queues (OUTPUT, CAPTURE) before the video node close.
The issue was being reported by videobuf2 with a following warning while
checking q->owned_by_drv_count:

[ 2498.310766] WARNING: CPU: 0 PID: 9358 at drivers/media/v4l2-core/videobuf2-core.c:1818 __vb2_queue_cancel+0xe8/0x14c
[ 2498.320258] Modules linked in:
[ 2498.323212] CPU: 0 PID: 9358 Comm: v4l2_decode Not tainted 4.7.0-rc4-next-20160627 #1210
[ 2498.331284] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[ 2498.331327] [<c010d738>] (unwind_backtrace) from [<c010a4b0>] (show_stack+0x10/0x14)
[ 2498.331344] [<c010a4b0>] (show_stack) from [<c031a4ac>] (dump_stack+0x74/0x94)
[ 2498.331358] [<c031a4ac>] (dump_stack) from [<c011a52c>] (__warn+0xd4/0x100)
[ 2498.331369] [<c011a52c>] (__warn) from [<c011a578>] (warn_slowpath_null+0x20/0x28)
[ 2498.331381] [<c011a578>] (warn_slowpath_null) from [<c04ed420>] (__vb2_queue_cancel+0xe8/0x14c)
[ 2498.331395] [<c04ed420>] (__vb2_queue_cancel) from [<c04ee10c>] (vb2_core_queue_release+0x18/0x38)
[ 2498.331406] [<c04ee10c>] (vb2_core_queue_release) from [<c04eab50>] (v4l2_m2m_ctx_release+0x1c/0x28)
[ 2498.331420] [<c04eab50>] (v4l2_m2m_ctx_release) from [<c04fe184>] (fimc_m2m_release+0x24/0x78)
[ 2498.331437] [<c04fe184>] (fimc_m2m_release) from [<c04d76c8>] (v4l2_release+0x34/0x74)
[ 2498.331455] [<c04d76c8>] (v4l2_release) from [<c01dc8d4>] (__fput+0x80/0x1bc)
[ 2498.331469] [<c01dc8d4>] (__fput) from [<c0132edc>] (task_work_run+0xc0/0xe4)
[ 2498.331482] [<c0132edc>] (task_work_run) from [<c011d460>] (do_exit+0x304/0xa24)
[ 2498.331493] [<c011d460>] (do_exit) from [<c011dccc>] (do_group_exit+0x3c/0xbc)
[ 2498.331505] [<c011dccc>] (do_group_exit) from [<c0126cac>] (get_signal+0x200/0x65c)
[ 2498.331517] [<c0126cac>] (get_signal) from [<c010e928>] (do_signal+0x84/0x3c4)
[ 2498.331532] [<c010e928>] (do_signal) from [<c010a0ec>] (do_work_pending+0xa4/0xb4)
[ 2498.331545] [<c010a0ec>] (do_work_pending) from [<c0107954>] (slow_work_pending+0xc/0x20)

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-m2m.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index 55ec4c9..ec1c762 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -50,30 +50,28 @@ void fimc_m2m_job_finish(struct fimc_ctx *ctx, int vb_state)
 	src_vb = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 	dst_vb = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 
-	if (src_vb && dst_vb) {
+	if (src_vb)
 		v4l2_m2m_buf_done(src_vb, vb_state);
+	if (dst_vb)
 		v4l2_m2m_buf_done(dst_vb, vb_state);
+	if (src_vb && dst_vb)
 		v4l2_m2m_job_finish(ctx->fimc_dev->m2m.m2m_dev,
 				    ctx->fh.m2m_ctx);
-	}
 }
 
 /* Complete the transaction which has been scheduled for execution. */
-static int fimc_m2m_shutdown(struct fimc_ctx *ctx)
+static void fimc_m2m_shutdown(struct fimc_ctx *ctx)
 {
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	int ret;
 
 	if (!fimc_m2m_pending(fimc))
-		return 0;
+		return;
 
 	fimc_ctx_state_set(FIMC_CTX_SHUT, ctx);
 
-	ret = wait_event_timeout(fimc->irq_queue,
-			   !fimc_ctx_state_is_set(FIMC_CTX_SHUT, ctx),
-			   FIMC_SHUTDOWN_TIMEOUT);
-
-	return ret == 0 ? -ETIMEDOUT : ret;
+	wait_event_timeout(fimc->irq_queue,
+			!fimc_ctx_state_is_set(FIMC_CTX_SHUT, ctx),
+			FIMC_SHUTDOWN_TIMEOUT);
 }
 
 static int start_streaming(struct vb2_queue *q, unsigned int count)
@@ -88,12 +86,10 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
 static void stop_streaming(struct vb2_queue *q)
 {
 	struct fimc_ctx *ctx = q->drv_priv;
-	int ret;
 
-	ret = fimc_m2m_shutdown(ctx);
-	if (ret == -ETIMEDOUT)
-		fimc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
 
+	fimc_m2m_shutdown(ctx);
+	fimc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
 	pm_runtime_put(&ctx->fimc_dev->pdev->dev);
 }
 
-- 
1.9.1

