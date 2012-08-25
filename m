Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63962 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab2HYDJJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 23:09:09 -0400
Received: by yhmm54 with SMTP id m54so582622yhm.19
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2012 20:09:08 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/9] s5p: Don't check vb2_queue_init() return value
Date: Sat, 25 Aug 2012 00:08:58 -0300
Message-Id: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now vb2_queue_init() returns always 0
and it will be changed to return void.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/platform/s5p-fimc/fimc-m2m.c  |    7 +++----
 drivers/media/platform/s5p-g2d/g2d.c        |    7 +++----
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    7 +++----
 drivers/media/platform/s5p-mfc/s5p_mfc.c    |   14 ++++----------
 drivers/media/platform/s5p-tv/mixer_video.c |    9 +--------
 5 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-m2m.c b/drivers/media/platform/s5p-fimc/fimc-m2m.c
index ab4c15a..52a2ae6 100644
--- a/drivers/media/platform/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/platform/s5p-fimc/fimc-m2m.c
@@ -627,9 +627,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 
-	ret = vb2_queue_init(src_vq);
-	if (ret)
-		return ret;
+	vb2_queue_init(src_vq);
 
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
 	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
@@ -638,7 +636,8 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 
-	return vb2_queue_init(dst_vq);
+	vb2_queue_init(dst_vq);
+	return 0;
 }
 
 static int fimc_m2m_open(struct file *file)
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 30195ef..a77bfae 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -158,9 +158,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 
-	ret = vb2_queue_init(src_vq);
-	if (ret)
-		return ret;
+	vb2_queue_init(src_vq);
 
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
@@ -169,7 +167,8 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 
-	return vb2_queue_init(dst_vq);
+	vb2_queue_init(dst_vq);
+	return 0;
 }
 
 static int g2d_s_ctrl(struct v4l2_ctrl *ctrl)
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 90459cef..fe8cd53 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1230,9 +1230,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->ops = &s5p_jpeg_qops;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 
-	ret = vb2_queue_init(src_vq);
-	if (ret)
-		return ret;
+	vb2_queue_init(src_vq);
 
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
@@ -1241,7 +1239,8 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->ops = &s5p_jpeg_qops;
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 
-	return vb2_queue_init(dst_vq);
+	vb2_queue_init(dst_vq);
+	return 0;
 }
 
 /*
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index e3e616d..6f785bc 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -740,11 +740,8 @@ static int s5p_mfc_open(struct file *file)
 		goto err_queue_init;
 	}
 	q->mem_ops = (struct vb2_mem_ops *)&vb2_dma_contig_memops;
-	ret = vb2_queue_init(q);
-	if (ret) {
-		mfc_err("Failed to initialize videobuf2 queue(capture)\n");
-		goto err_queue_init;
-	}
+	vb2_queue_init(q);
+
 	/* Init videobuf2 queue for OUTPUT */
 	q = &ctx->vq_src;
 	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
@@ -761,11 +758,8 @@ static int s5p_mfc_open(struct file *file)
 		goto err_queue_init;
 	}
 	q->mem_ops = (struct vb2_mem_ops *)&vb2_dma_contig_memops;
-	ret = vb2_queue_init(q);
-	if (ret) {
-		mfc_err("Failed to initialize videobuf2 queue(output)\n");
-		goto err_queue_init;
-	}
+	vb2_queue_init(q);
+
 	init_waitqueue_head(&ctx->queue);
 	mutex_unlock(&dev->mfc_mutex);
 	mfc_debug_leave();
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index a9c6be3..c77b73f 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -774,11 +774,7 @@ static int mxr_video_open(struct file *file)
 		goto fail_fh_open;
 	}
 
-	ret = vb2_queue_init(&layer->vb_queue);
-	if (ret != 0) {
-		mxr_err(mdev, "failed to initialize vb2 queue\n");
-		goto fail_power;
-	}
+	vb2_queue_init(&layer->vb_queue);
 	/* set default format, first on the list */
 	layer->fmt = layer->fmt_array[0];
 	/* setup default geometry */
@@ -787,9 +783,6 @@ static int mxr_video_open(struct file *file)
 
 	return 0;
 
-fail_power:
-	mxr_power_put(mdev);
-
 fail_fh_open:
 	v4l2_fh_release(file);
 
-- 
1.7.8.6

