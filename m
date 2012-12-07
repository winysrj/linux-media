Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:42739 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab2LGMGh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2012 07:06:37 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MEN00AP6TMZJ6Z0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 07 Dec 2012 21:06:35 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MEN0020ATLU04A0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 07 Dec 2012 21:06:35 +0900 (KST)
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com
Subject: [PATCH] [media] exynos-gsc: Support dmabuf export buffer
Date: Fri, 07 Dec 2012 17:58:55 +0530
Message-id: <1354883335-27961-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the dmabuf export buffer feature to the
Exynos G-Scaler driver.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-m2m.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index c267c57..d0c3e42 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -367,6 +367,13 @@ static int gsc_m2m_reqbufs(struct file *file, void *fh,
 	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
 }
 
+static int gsc_m2m_expbuf(struct file *file, void *fh,
+				struct v4l2_exportbuffer *eb)
+{
+	struct gsc_ctx *ctx = fh_to_ctx(fh);
+	return v4l2_m2m_expbuf(file, ctx->m2m_ctx, eb);
+}
+
 static int gsc_m2m_querybuf(struct file *file, void *fh,
 					struct v4l2_buffer *buf)
 {
@@ -548,6 +555,7 @@ static const struct v4l2_ioctl_ops gsc_m2m_ioctl_ops = {
 	.vidioc_s_fmt_vid_cap_mplane	= gsc_m2m_s_fmt_mplane,
 	.vidioc_s_fmt_vid_out_mplane	= gsc_m2m_s_fmt_mplane,
 	.vidioc_reqbufs			= gsc_m2m_reqbufs,
+	.vidioc_expbuf                  = gsc_m2m_expbuf,
 	.vidioc_querybuf		= gsc_m2m_querybuf,
 	.vidioc_qbuf			= gsc_m2m_qbuf,
 	.vidioc_dqbuf			= gsc_m2m_dqbuf,
@@ -565,7 +573,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 
 	memset(src_vq, 0, sizeof(*src_vq));
 	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
-	src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
+	src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	src_vq->drv_priv = ctx;
 	src_vq->ops = &gsc_m2m_qops;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
@@ -577,7 +585,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 
 	memset(dst_vq, 0, sizeof(*dst_vq));
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
-	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
+	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	dst_vq->drv_priv = ctx;
 	dst_vq->ops = &gsc_m2m_qops;
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
-- 
1.7.0.4

