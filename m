Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:36677 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbaCUIh3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Mar 2014 04:37:29 -0400
Received: by mail-pd0-f171.google.com with SMTP id r10so2066066pdi.30
        for <linux-media@vger.kernel.org>; Fri, 21 Mar 2014 01:37:28 -0700 (PDT)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, posciak@chromium.org,
	arunkk.samsung@gmail.com
Subject: [PATCH 1/3] [media] s5p-mfc: Fixes for decode REQBUFS.
Date: Fri, 21 Mar 2014 14:07:13 +0530
Message-Id: <1395391035-27349-2-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1395391035-27349-1-git-send-email-arun.kk@samsung.com>
References: <1395391035-27349-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <posciak@chromium.org>

- Honor return values from vb2_reqbufs on REQBUFS(0).

- Do not set the number of allocated buffers to 0 if userspace tries
  to request buffers again without freeing them.

- There is no need to verify correct instance state on reqbufs, as we will
  verify this in queue_setup().

- There is also no need to verify that vb2_reqbufs() was able to allocate enough
  buffers (pb_count) and call buf_init on that many buffers (i.e. dst_buf_count
  is at least pb_count), because this will be verified by second queue_setup()
  call as well and vb2_reqbufs() will fail otherwise.

- Only verify state is MFCINST_INIT when allocating, not when freeing.

- Refactor and simplify code.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c |  178 ++++++++++++++------------
 1 file changed, 99 insertions(+), 79 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 8faf969..1ff82f2 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -462,104 +462,124 @@ out:
 	return ret;
 }
 
-/* Reqeust buffers */
-static int vidioc_reqbufs(struct file *file, void *priv,
-					  struct v4l2_requestbuffers *reqbufs)
+static int reqbufs_output(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx,
+				struct v4l2_requestbuffers *reqbufs)
 {
-	struct s5p_mfc_dev *dev = video_drvdata(file);
-	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
 	int ret = 0;
 
-	if (reqbufs->memory != V4L2_MEMORY_MMAP) {
-		mfc_err("Only V4L2_MEMORY_MAP is supported\n");
-		return -EINVAL;
-	}
-	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		/* Can only request buffers after an instance has been opened.*/
-		if (ctx->state == MFCINST_INIT) {
-			ctx->src_bufs_cnt = 0;
-			if (reqbufs->count == 0) {
-				mfc_debug(2, "Freeing buffers\n");
-				s5p_mfc_clock_on();
-				ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
-				s5p_mfc_clock_off();
-				return ret;
-			}
-			/* Decoding */
-			if (ctx->output_state != QUEUE_FREE) {
-				mfc_err("Bufs have already been requested\n");
-				return -EINVAL;
-			}
-			s5p_mfc_clock_on();
-			ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
-			s5p_mfc_clock_off();
-			if (ret) {
-				mfc_err("vb2_reqbufs on output failed\n");
-				return ret;
-			}
-			mfc_debug(2, "vb2_reqbufs: %d\n", ret);
-			ctx->output_state = QUEUE_BUFS_REQUESTED;
+	s5p_mfc_clock_on();
+
+	if (reqbufs->count == 0) {
+		mfc_debug(2, "Freeing buffers\n");
+		ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
+		if (ret)
+			goto out;
+		ctx->src_bufs_cnt = 0;
+	} else if (ctx->output_state == QUEUE_FREE) {
+		/* Can only request buffers after the instance
+		 * has been opened.
+		 */
+		WARN_ON(ctx->src_bufs_cnt != 0);
+		if (ctx->state != MFCINST_INIT) {
+			mfc_err("Reqbufs called in an invalid state\n");
+			ret = -EINVAL;
+			goto out;
 		}
-	} else if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+
+		mfc_debug(2, "Allocating %d buffers for OUTPUT queue\n",
+				reqbufs->count);
+		ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
+		if (ret)
+			goto out;
+
+		ctx->output_state = QUEUE_BUFS_REQUESTED;
+	} else {
+		mfc_err("Buffers have already been requested\n");
+		ret = -EINVAL;
+	}
+out:
+	s5p_mfc_clock_off();
+	if (ret)
+		mfc_err("Failed allocating buffers for OUTPUT queue\n");
+	return ret;
+}
+
+static int reqbufs_capture(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx,
+				struct v4l2_requestbuffers *reqbufs)
+{
+	int ret = 0;
+
+	s5p_mfc_clock_on();
+
+	if (reqbufs->count == 0) {
+		mfc_debug(2, "Freeing buffers\n");
+		ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+		if (ret)
+			goto out;
+		s5p_mfc_hw_call(dev->mfc_ops, release_codec_buffers, ctx);
 		ctx->dst_bufs_cnt = 0;
-		if (reqbufs->count == 0) {
-			mfc_debug(2, "Freeing buffers\n");
-			s5p_mfc_clock_on();
-			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
-			s5p_mfc_clock_off();
-			return ret;
-		}
-		if (ctx->capture_state != QUEUE_FREE) {
-			mfc_err("Bufs have already been requested\n");
-			return -EINVAL;
-		}
-		ctx->capture_state = QUEUE_BUFS_REQUESTED;
-		s5p_mfc_clock_on();
+	} else if (ctx->capture_state == QUEUE_FREE) {
+		WARN_ON(ctx->dst_bufs_cnt != 0);
+		mfc_debug(2, "Allocating %d buffers for CAPTURE queue\n",
+				reqbufs->count);
 		ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
-		s5p_mfc_clock_off();
-		if (ret) {
-			mfc_err("vb2_reqbufs on capture failed\n");
-			return ret;
-		}
-		if (reqbufs->count < ctx->pb_count) {
-			mfc_err("Not enough buffers allocated\n");
-			reqbufs->count = 0;
-			s5p_mfc_clock_on();
-			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
-			s5p_mfc_clock_off();
-			return -ENOMEM;
-		}
+		if (ret)
+			goto out;
+
+		ctx->capture_state = QUEUE_BUFS_REQUESTED;
 		ctx->total_dpb_count = reqbufs->count;
+
 		ret = s5p_mfc_hw_call(dev->mfc_ops, alloc_codec_buffers, ctx);
 		if (ret) {
 			mfc_err("Failed to allocate decoding buffers\n");
 			reqbufs->count = 0;
-			s5p_mfc_clock_on();
-			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
-			s5p_mfc_clock_off();
-			return -ENOMEM;
-		}
-		if (ctx->dst_bufs_cnt == ctx->total_dpb_count) {
-			ctx->capture_state = QUEUE_BUFS_MMAPED;
-		} else {
-			mfc_err("Not all buffers passed to buf_init\n");
-			reqbufs->count = 0;
-			s5p_mfc_clock_on();
-			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
-			s5p_mfc_hw_call(dev->mfc_ops, release_codec_buffers,
-					ctx);
-			s5p_mfc_clock_off();
-			return -ENOMEM;
+			vb2_reqbufs(&ctx->vq_dst, reqbufs);
+			ret = -ENOMEM;
+			ctx->capture_state = QUEUE_FREE;
+			goto out;
 		}
+
+		WARN_ON(ctx->dst_bufs_cnt != ctx->total_dpb_count);
+		ctx->capture_state = QUEUE_BUFS_MMAPED;
+
 		if (s5p_mfc_ctx_ready(ctx))
 			set_work_bit_irqsave(ctx);
 		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
-		s5p_mfc_wait_for_done_ctx(ctx,
-					S5P_MFC_R2H_CMD_INIT_BUFFERS_RET, 0);
+		s5p_mfc_wait_for_done_ctx(ctx, S5P_MFC_R2H_CMD_INIT_BUFFERS_RET,
+					  0);
+	} else {
+		mfc_err("Buffers have already been requested\n");
+		ret = -EINVAL;
 	}
+out:
+	s5p_mfc_clock_off();
+	if (ret)
+		mfc_err("Failed allocating buffers for CAPTURE queue\n");
 	return ret;
 }
 
+/* Reqeust buffers */
+static int vidioc_reqbufs(struct file *file, void *priv,
+					  struct v4l2_requestbuffers *reqbufs)
+{
+	struct s5p_mfc_dev *dev = video_drvdata(file);
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+
+	if (reqbufs->memory != V4L2_MEMORY_MMAP) {
+		mfc_err("Only V4L2_MEMORY_MAP is supported\n");
+		return -EINVAL;
+	}
+
+	if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		return reqbufs_output(dev, ctx, reqbufs);
+	} else if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		return reqbufs_capture(dev, ctx, reqbufs);
+	} else {
+		mfc_err("Invalid type requested\n");
+		return -EINVAL;
+	}
+}
+
 /* Query buffer */
 static int vidioc_querybuf(struct file *file, void *priv,
 						   struct v4l2_buffer *buf)
-- 
1.7.9.5

