Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:45819 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285AbcDONEO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 09:04:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCHv2 05/12] staging/media: convert drivers to use the new vb2_queue dev field
Date: Fri, 15 Apr 2016 15:03:49 +0200
Message-Id: <1460725436-20045-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1460725436-20045-1-git-send-email-hverkuil@xs4all.nl>
References: <1460725436-20045-1-git-send-email-hverkuil@xs4all.nl>
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
index ea3ddec..77e66e7 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -542,7 +542,6 @@ static int vpfe_release(struct file *file)
 		video->io_usrs = 0;
 		/* Free buffers allocated */
 		vb2_queue_release(&video->buffer_queue);
-		vb2_dma_contig_cleanup_ctx(video->alloc_ctx);
 	}
 	/* Decrement device users counter */
 	video->usrs--;
@@ -1115,7 +1114,6 @@ vpfe_buffer_queue_setup(struct vb2_queue *vq,
 
 	*nplanes = 1;
 	sizes[0] = size;
-	alloc_ctxs[0] = video->alloc_ctx;
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
 		 "nbuffers=%d, size=%lu\n", *nbuffers, size);
 	return 0;
@@ -1350,12 +1348,6 @@ static int vpfe_reqbufs(struct file *file, void *priv,
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
@@ -1365,11 +1357,11 @@ static int vpfe_reqbufs(struct file *file, void *priv,
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
index cf8da23..3c077e3 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -310,8 +310,6 @@ static int iss_video_queue_setup(struct vb2_queue *vq,
 	if (sizes[0] == 0)
 		return -EINVAL;
 
-	alloc_ctxs[0] = video->alloc_ctx;
-
 	*count = min(*count, video->capture_mem / PAGE_ALIGN(sizes[0]));
 
 	return 0;
@@ -1017,13 +1015,6 @@ static int iss_video_open(struct file *file)
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
@@ -1033,6 +1024,7 @@ static int iss_video_open(struct file *file)
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->buf_struct_size = sizeof(struct iss_buffer);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->dev = video->iss->dev;
 
 	ret = vb2_queue_init(q);
 	if (ret) {
diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
index c8bd295..d7e05d0 100644
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
2.8.0.rc3

