Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52337 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab0I2KYG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Sep 2010 06:24:06 -0400
Date: Wed, 29 Sep 2010 12:23:47 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 3/4] V4L/DVB: s5p-fimc: Do not lock both capture and output
 buffer queue in s_fmt
In-reply-to: <1285755828-7815-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-arm-kernel@lists.infraded.org,
	linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1285755828-7815-4-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1285755828-7815-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

It is not necessary to lock both capture and output buffer queue while
setting format for single queue.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |   69 +++++++++++++----------------
 1 files changed, 31 insertions(+), 38 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index fe46aea..a83977f 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -743,8 +743,9 @@ static int fimc_m2m_try_fmt(struct file *file, void *priv,
 static int fimc_m2m_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 {
 	struct fimc_ctx *ctx = priv;
-	struct v4l2_device *v4l2_dev = &ctx->fimc_dev->m2m.v4l2_dev;
-	struct videobuf_queue *src_vq, *dst_vq;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct v4l2_device *v4l2_dev = &fimc->m2m.v4l2_dev;
+	struct videobuf_queue *vq;
 	struct fimc_frame *frame;
 	struct v4l2_pix_format *pix;
 	unsigned long flags;
@@ -756,69 +757,61 @@ static int fimc_m2m_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	if (ret)
 		return ret;
 
-	mutex_lock(&ctx->fimc_dev->lock);
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
 
-	src_vq = v4l2_m2m_get_src_vq(ctx->m2m_ctx);
-	dst_vq = v4l2_m2m_get_dst_vq(ctx->m2m_ctx);
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	mutex_lock(&vq->vb_lock);
 
-	mutex_lock(&src_vq->vb_lock);
-	mutex_lock(&dst_vq->vb_lock);
+	if (videobuf_queue_is_busy(vq)) {
+		v4l2_err(v4l2_dev, "%s: queue (%d) busy\n", __func__, f->type);
+		ret = -EBUSY;
+		goto sf_out;
+	}
 
+	spin_lock_irqsave(&ctx->slock, flags);
 	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		if (videobuf_queue_is_busy(src_vq)) {
-			v4l2_err(v4l2_dev, "%s queue busy\n", __func__);
-			ret = -EBUSY;
-			goto s_fmt_out;
-		}
 		frame = &ctx->s_frame;
-		spin_lock_irqsave(&ctx->slock, flags);
 		ctx->state |= FIMC_SRC_FMT;
-		spin_unlock_irqrestore(&ctx->slock, flags);
-
 	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		if (videobuf_queue_is_busy(dst_vq)) {
-			v4l2_err(v4l2_dev, "%s queue busy\n", __func__);
-			ret = -EBUSY;
-			goto s_fmt_out;
-		}
 		frame = &ctx->d_frame;
-		spin_lock_irqsave(&ctx->slock, flags);
 		ctx->state |= FIMC_DST_FMT;
-		spin_unlock_irqrestore(&ctx->slock, flags);
 	} else {
+		spin_unlock_irqrestore(&ctx->slock, flags);
 		v4l2_err(&ctx->fimc_dev->m2m.v4l2_dev,
 			 "Wrong buffer/video queue type (%d)\n", f->type);
 		ret = -EINVAL;
-		goto s_fmt_out;
+		goto sf_out;
 	}
+	spin_unlock_irqrestore(&ctx->slock, flags);
 
 	pix = &f->fmt.pix;
 	frame->fmt = find_format(f);
 	if (!frame->fmt) {
 		ret = -EINVAL;
-		goto s_fmt_out;
+		goto sf_out;
 	}
 
-	frame->f_width = pix->bytesperline * 8 / frame->fmt->depth;
-	frame->f_height = pix->sizeimage/pix->bytesperline;
-	frame->width = pix->width;
-	frame->height = pix->height;
-	frame->o_width = pix->width;
+	frame->f_width	= pix->bytesperline * 8 / frame->fmt->depth;
+	frame->f_height	= pix->height;
+	frame->width	= pix->width;
+	frame->height	= pix->height;
+	frame->o_width	= pix->width;
 	frame->o_height = pix->height;
-	frame->offs_h = 0;
-	frame->offs_v = 0;
-	frame->size = (pix->width * pix->height * frame->fmt->depth) >> 3;
-	src_vq->field = dst_vq->field = pix->field;
+	frame->offs_h	= 0;
+	frame->offs_v	= 0;
+	frame->size	= (pix->width * pix->height * frame->fmt->depth) >> 3;
+	vq->field	= pix->field;
+
 	spin_lock_irqsave(&ctx->slock, flags);
 	ctx->state |= FIMC_PARAMS;
 	spin_unlock_irqrestore(&ctx->slock, flags);
 
-	dbg("f_width= %d, f_height= %d", frame->f_width, frame->f_height);
+	dbg("f_w: %d, f_h: %d", frame->f_width, frame->f_height);
 
-s_fmt_out:
-	mutex_unlock(&dst_vq->vb_lock);
-	mutex_unlock(&src_vq->vb_lock);
-	mutex_unlock(&ctx->fimc_dev->lock);
+sf_out:
+	mutex_unlock(&vq->vb_lock);
+	mutex_unlock(&fimc->lock);
 	return ret;
 }
 
-- 
1.7.3

