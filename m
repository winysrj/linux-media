Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:51000 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbcBPMwy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2016 07:52:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 05/12] staging/media: convert drivers to use the new vb2_queue dev field
Date: Tue, 16 Feb 2016 13:43:00 +0100
Message-Id: <1455626587-8051-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1455626587-8051-1-git-send-email-hverkuil@xs4all.nl>
References: <1455626587-8051-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Stop using alloc_ctx and just fill in the device pointer.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/davinci_vpfe/vpfe_video.c | 10 +---------
 drivers/staging/media/davinci_vpfe/vpfe_video.h |  2 --
 drivers/staging/media/omap4iss/iss_video.c      | 10 +---------
 drivers/staging/media/omap4iss/iss_video.h      |  1 -
 4 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index db49af9..1c4774b 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -540,7 +540,6 @@ static int vpfe_release(struct file *file)
 		video->io_usrs = 0;
 		/* Free buffers allocated */
 		vb2_queue_release(&video->buffer_queue);
-		vb2_dma_contig_cleanup_ctx(video->alloc_ctx);
 	}
 	/* Decrement device users counter */
 	video->usrs--;
@@ -1111,7 +1110,6 @@ vpfe_buffer_queue_setup(struct vb2_queue *vq,
 
 	*nplanes = 1;
 	sizes[0] = size;
-	alloc_ctxs[0] = video->alloc_ctx;
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
 		 "nbuffers=%d, size=%lu\n", *nbuffers, size);
 	return 0;
@@ -1346,12 +1344,6 @@ static int vpfe_reqbufs(struct file *file, void *priv,
 	video->memory = req_buf->memory;
 
 	/* Initialize videobuf2 queue as per the buffer type */
-	video->alloc_ctx = vb2_dma_contig_init_ctx(vpfe_dev->pdev);
-	if (IS_ERR(video->alloc_ctx)) {
-		v4l2_err(&vpfe_dev->v4l2_dev, "Failed to get the context\n");
-		return PTR_ERR(video->alloc_ctx);
-	}
-
 	q = &video->buffer_queue;
 	q->type = req_buf->type;
 	q->io_modes = VB2_MMAP | VB2_USERPTR;
@@ -1361,11 +1353,11 @@ static int vpfe_reqbufs(struct file *file, void *priv,
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->buf_struct_size = sizeof(struct vpfe_cap_buffer);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->dev = vpfe_dev->pdev;
 
 	ret = vb2_queue_init(q);
 	if (ret) {
 		v4l2_err(&vpfe_dev->v4l2_dev, "vb2_queue_init() failed\n");
-		vb2_dma_contig_cleanup_ctx(vpfe_dev->pdev);
 		return ret;
 	}
 
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.h b/drivers/staging/media/davinci_vpfe/vpfe_video.h
index 653334d..aaec440 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.h
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.h
@@ -123,8 +123,6 @@ struct vpfe_video_device {
 	/* Used to store pixel format */
 	struct v4l2_format			fmt;
 	struct vb2_queue			buffer_queue;
-	/* allocator-specific contexts for each plane */
-	struct vb2_alloc_ctx *alloc_ctx;
 	/* Queue of filled frames */
 	struct list_head			dma_queue;
 	spinlock_t				irqlock;
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 058233a..2ac10d8 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -308,8 +308,6 @@ static int iss_video_queue_setup(struct vb2_queue *vq,
 	if (sizes[0] == 0)
 		return -EINVAL;
 
-	alloc_ctxs[0] = video->alloc_ctx;
-
 	*count = min(*count, video->capture_mem / PAGE_ALIGN(sizes[0]));
 
 	return 0;
@@ -1021,13 +1019,6 @@ static int iss_video_open(struct file *file)
 		goto done;
 	}
 
-	video->alloc_ctx = vb2_dma_contig_init_ctx(video->iss->dev);
-	if (IS_ERR(video->alloc_ctx)) {
-		ret = PTR_ERR(video->alloc_ctx);
-		omap4iss_put(video->iss);
-		goto done;
-	}
-
 	q = &handle->queue;
 
 	q->type = video->type;
@@ -1037,6 +1028,7 @@ static int iss_video_open(struct file *file)
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->buf_struct_size = sizeof(struct iss_buffer);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->dev = video->iss->dev;
 
 	ret = vb2_queue_init(q);
 	if (ret) {
diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
index 34588b7..e204497 100644
--- a/drivers/staging/media/omap4iss/iss_video.h
+++ b/drivers/staging/media/omap4iss/iss_video.h
@@ -170,7 +170,6 @@ struct iss_video {
 	spinlock_t qlock;		/* protects dmaqueue and error */
 	struct list_head dmaqueue;
 	enum iss_video_dmaqueue_flags dmaqueue_flags;
-	struct vb2_alloc_ctx *alloc_ctx;
 
 	const struct iss_video_operations *ops;
 };
-- 
2.7.0

