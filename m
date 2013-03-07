Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:61818 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3CGNrp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 08:47:45 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MJA00HZQMBG2D90@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 07 Mar 2013 22:47:44 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] s5p-fimc: Copy timestamps from M2M OUTPUT to CAPTURE buffer
 queue
Date: Thu, 07 Mar 2013 14:47:26 +0100
Message-id: <1362664046-15246-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add copying of buffer timestamps and set the timestamp_type to
V4L2_BUF_FLAG_TIMESTAMP_COPY to avoid warnings about UNDEFINED
timestamp type like:

WARNING: at drivers/media/v4l2-core/videobuf2-core.c:2042 vb2_queue_init+0xe0/0x18c()
Modules linked in:
[<c0016ef0>] (unwind_backtrace+0x0/0x13c) from [<c0029b3c>] (warn_slowpath_common+0x54/0x64)
[<c0029b3c>] (warn_slowpath_common+0x54/0x64) from [<c0029b68>] (warn_slowpath_null+0x1c/0x24)
[<c0029b68>] (warn_slowpath_null+0x1c/0x24) from [<c03b7018>] (vb2_queue_init+0xe0/0x18c)
[<c03b7018>] (vb2_queue_init+0xe0/0x18c) from [<c03b4e08>] (v4l2_m2m_ctx_init+0xa0/0xc4)
[<c03b4e08>] (v4l2_m2m_ctx_init+0xa0/0xc4) from [<c03ca6c4>] (fimc_m2m_open+0x130/0x1f8)
[<c03ca6c4>] (fimc_m2m_open+0x130/0x1f8) from [<c03a5dd4>] (v4l2_open+0xac/0xe8)
[<c03a5dd4>] (v4l2_open+0xac/0xe8) from [<c0113920>] (chrdev_open+0x9c/0x158)
[<c0113920>] (chrdev_open+0x9c/0x158) from [<c010e488>] (do_dentry_open+0x1f8/0x280)
[<c010e488>] (do_dentry_open+0x1f8/0x280) from [<c010e600>] (finish_open+0x34/0x50)
[<c010e600>] (finish_open+0x34/0x50) from [<c011cc58>] (do_last+0x5bc/0xc00)
[<c011cc58>] (do_last+0x5bc/0xc00) from [<c011d34c>] (path_openat+0xb0/0x484)
[<c011d34c>] (path_openat+0xb0/0x484) from [<c011d824>] (do_filp_open+0x30/0x84)
[<c011d824>] (do_filp_open+0x30/0x84) from [<c010e0f8>] (do_sys_open+0xe8/0x170)
[<c010e0f8>] (do_sys_open+0xe8/0x170) from [<c000f040>] (ret_fast_syscall+0x0/0x30)

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-m2m.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-m2m.c b/drivers/media/platform/s5p-fimc/fimc-m2m.c
index f3d535c..2de56d3 100644
--- a/drivers/media/platform/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/platform/s5p-fimc/fimc-m2m.c
@@ -100,7 +100,7 @@ static int stop_streaming(struct vb2_queue *q)
 
 static void fimc_device_run(void *priv)
 {
-	struct vb2_buffer *vb = NULL;
+	struct vb2_buffer *src_vb, *dst_vb;
 	struct fimc_ctx *ctx = priv;
 	struct fimc_frame *sf, *df;
 	struct fimc_dev *fimc;
@@ -123,16 +123,18 @@ static void fimc_device_run(void *priv)
 		fimc_prepare_dma_offset(ctx, df);
 	}
 
-	vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
-	ret = fimc_prepare_addr(ctx, vb, sf, &sf->paddr);
+	src_vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	ret = fimc_prepare_addr(ctx, src_vb, sf, &sf->paddr);
 	if (ret)
 		goto dma_unlock;
 
-	vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
-	ret = fimc_prepare_addr(ctx, vb, df, &df->paddr);
+	dst_vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	ret = fimc_prepare_addr(ctx, dst_vb, df, &df->paddr);
 	if (ret)
 		goto dma_unlock;
 
+	dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
+
 	/* Reconfigure hardware if the context has changed. */
 	if (fimc->m2m.ctx != ctx) {
 		ctx->state |= FIMC_PARAMS;
@@ -623,6 +625,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->ops = &fimc_qops;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -634,6 +637,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->ops = &fimc_qops;
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 
 	return vb2_queue_init(dst_vq);
 }
-- 
1.7.9.5

