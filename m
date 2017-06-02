Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:57973 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751270AbdFBQDR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Jun 2017 12:03:17 -0400
From: Thierry Escande <thierry.escande@collabora.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] [media] s5p-jpeg: Add support for resolution change event
Date: Fri,  2 Jun 2017 18:02:53 +0200
Message-Id: <1496419376-17099-7-git-send-email-thierry.escande@collabora.com>
In-Reply-To: <1496419376-17099-1-git-send-email-thierry.escande@collabora.com>
References: <1496419376-17099-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Content-Transfert-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: henryhsu <henryhsu@chromium.org>

This patch adds support for resolution change event to notify clients so
they can prepare correct output buffer. When resolution change happened,
G_FMT for CAPTURE should return old resolution and format before CAPTURE
queues streamoff.

Signed-off-by: Henry-Ruey Hsu <henryhsu@chromium.org>
Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 121 ++++++++++++++++++++--------
 drivers/media/platform/s5p-jpeg/jpeg-core.h |   7 ++
 2 files changed, 95 insertions(+), 33 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 5569b99..7a7acbc 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-mem2mem.h>
 #include <media/v4l2-ioctl.h>
 #include <media/videobuf2-v4l2.h>
@@ -1416,8 +1417,17 @@ static int s5p_jpeg_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	q_data = get_q_data(ct, f->type);
 	BUG_ON(q_data == NULL);
 
-	pix->width = q_data->w;
-	pix->height = q_data->h;
+	if ((f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+	     ct->mode == S5P_JPEG_ENCODE) ||
+	    (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
+	     ct->mode == S5P_JPEG_DECODE)) {
+		pix->width = 0;
+		pix->height = 0;
+	} else {
+		pix->width = q_data->w;
+		pix->height = q_data->h;
+	}
+
 	pix->field = V4L2_FIELD_NONE;
 	pix->pixelformat = q_data->fmt->fourcc;
 	pix->bytesperline = 0;
@@ -1677,8 +1687,6 @@ static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx *ct, struct v4l2_format *f)
 			FMT_TYPE_OUTPUT : FMT_TYPE_CAPTURE;
 
 	q_data->fmt = s5p_jpeg_find_format(ct, pix->pixelformat, f_type);
-	q_data->w = pix->width;
-	q_data->h = pix->height;
 	if (q_data->fmt->fourcc != V4L2_PIX_FMT_JPEG) {
 		/*
 		 * During encoding Exynos4x12 SoCs access wider memory area
@@ -1686,6 +1694,8 @@ static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx *ct, struct v4l2_format *f)
 		 * the JPEG_IMAGE_SIZE register. In order to avoid sysmmu
 		 * page fault calculate proper buffer size in such a case.
 		 */
+		q_data->w = pix->width;
+		q_data->h = pix->height;
 		if (ct->jpeg->variant->hw_ex4_compat &&
 		    f_type == FMT_TYPE_OUTPUT && ct->mode == S5P_JPEG_ENCODE)
 			q_data->size = exynos4_jpeg_get_output_buffer_size(ct,
@@ -1761,6 +1771,15 @@ static int s5p_jpeg_s_fmt_vid_out(struct file *file, void *priv,
 	return s5p_jpeg_s_fmt(fh_to_ctx(priv), f);
 }
 
+static int s5p_jpeg_subscribe_event(struct v4l2_fh *fh,
+				    const struct v4l2_event_subscription *sub)
+{
+	if (sub->type == V4L2_EVENT_SOURCE_CHANGE)
+		return v4l2_src_change_event_subscribe(fh, sub);
+
+	return -EINVAL;
+}
+
 static int exynos3250_jpeg_try_downscale(struct s5p_jpeg_ctx *ctx,
 				   struct v4l2_rect *r)
 {
@@ -2086,6 +2105,9 @@ static const struct v4l2_ioctl_ops s5p_jpeg_ioctl_ops = {
 
 	.vidioc_g_selection		= s5p_jpeg_g_selection,
 	.vidioc_s_selection		= s5p_jpeg_s_selection,
+
+	.vidioc_subscribe_event		= s5p_jpeg_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
 /*
@@ -2478,8 +2500,17 @@ static int s5p_jpeg_job_ready(void *priv)
 {
 	struct s5p_jpeg_ctx *ctx = priv;
 
-	if (ctx->mode == S5P_JPEG_DECODE)
+	if (ctx->mode == S5P_JPEG_DECODE) {
+		/*
+		 * We have only one input buffer and one output buffer. If there
+		 * is a resolution change event, no need to continue decoding.
+		 */
+		if (ctx->state == JPEGCTX_RESOLUTION_CHANGE)
+			return 0;
+
 		return ctx->hdr_parsed;
+	}
+
 	return 1;
 }
 
@@ -2558,6 +2589,21 @@ static int s5p_jpeg_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
+static void s5p_jpeg_set_capture_queue_data(struct s5p_jpeg_ctx *ctx)
+{
+	struct s5p_jpeg_q_data *q_data = &ctx->cap_q;
+
+	q_data->w = ctx->out_q.w;
+	q_data->h = ctx->out_q.h;
+
+	jpeg_bound_align_image(ctx, &q_data->w, S5P_JPEG_MIN_WIDTH,
+			       S5P_JPEG_MAX_WIDTH, q_data->fmt->h_align,
+			       &q_data->h, S5P_JPEG_MIN_HEIGHT,
+			       S5P_JPEG_MAX_HEIGHT, q_data->fmt->v_align);
+
+	q_data->size = q_data->w * q_data->h * q_data->fmt->depth >> 3;
+}
+
 static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
@@ -2565,9 +2611,20 @@ static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
 
 	if (ctx->mode == S5P_JPEG_DECODE &&
 	    vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		struct s5p_jpeg_q_data tmp, *q_data;
-
-		ctx->hdr_parsed = s5p_jpeg_parse_hdr(&tmp,
+		static const struct v4l2_event ev_src_ch = {
+			.type = V4L2_EVENT_SOURCE_CHANGE,
+			.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
+		};
+		struct vb2_queue *dst_vq;
+		u32 ori_w;
+		u32 ori_h;
+
+		dst_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
+					 V4L2_BUF_TYPE_VIDEO_CAPTURE);
+		ori_w = ctx->out_q.w;
+		ori_h = ctx->out_q.h;
+
+		ctx->hdr_parsed = s5p_jpeg_parse_hdr(&ctx->out_q,
 		     (unsigned long)vb2_plane_vaddr(vb, 0),
 		     min((unsigned long)ctx->out_q.size,
 			 vb2_get_plane_payload(vb, 0)), ctx);
@@ -2576,31 +2633,18 @@ static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
 			return;
 		}
 
-		q_data = &ctx->out_q;
-		q_data->w = tmp.w;
-		q_data->h = tmp.h;
-		q_data->sos = tmp.sos;
-		memcpy(q_data->dht.marker, tmp.dht.marker,
-		       sizeof(tmp.dht.marker));
-		memcpy(q_data->dht.len, tmp.dht.len, sizeof(tmp.dht.len));
-		q_data->dht.n = tmp.dht.n;
-		memcpy(q_data->dqt.marker, tmp.dqt.marker,
-		       sizeof(tmp.dqt.marker));
-		memcpy(q_data->dqt.len, tmp.dqt.len, sizeof(tmp.dqt.len));
-		q_data->dqt.n = tmp.dqt.n;
-		q_data->sof = tmp.sof;
-		q_data->sof_len = tmp.sof_len;
-
-		q_data = &ctx->cap_q;
-		q_data->w = tmp.w;
-		q_data->h = tmp.h;
-
-		jpeg_bound_align_image(ctx, &q_data->w, S5P_JPEG_MIN_WIDTH,
-				       S5P_JPEG_MAX_WIDTH, q_data->fmt->h_align,
-				       &q_data->h, S5P_JPEG_MIN_HEIGHT,
-				       S5P_JPEG_MAX_HEIGHT, q_data->fmt->v_align
-				      );
-		q_data->size = q_data->w * q_data->h * q_data->fmt->depth >> 3;
+		/*
+		 * If there is a resolution change event, only update capture
+		 * queue when it is not streaming. Otherwise, update it in
+		 * STREAMOFF. See s5p_jpeg_stop_streaming for detail.
+		 */
+		if (ctx->out_q.w != ori_w || ctx->out_q.h != ori_h) {
+			v4l2_event_queue_fh(&ctx->fh, &ev_src_ch);
+			if (vb2_is_streaming(dst_vq))
+				ctx->state = JPEGCTX_RESOLUTION_CHANGE;
+			else
+				s5p_jpeg_set_capture_queue_data(ctx);
+		}
 	}
 
 	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
@@ -2620,6 +2664,17 @@ static void s5p_jpeg_stop_streaming(struct vb2_queue *q)
 {
 	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(q);
 
+	/*
+	 * STREAMOFF is an acknowledgment for resolution change event.
+	 * Before STREAMOFF, we still have to return the old resolution and
+	 * subsampling. Update capture queue when the stream is off.
+	 */
+	if (ctx->state == JPEGCTX_RESOLUTION_CHANGE &&
+	    q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		s5p_jpeg_set_capture_queue_data(ctx);
+		ctx->state = JPEGCTX_RUNNING;
+	}
+
 	pm_runtime_put(ctx->jpeg->dev);
 }
 
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.h b/drivers/media/platform/s5p-jpeg/jpeg-core.h
index 4492a35..9aa26bd 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.h
@@ -98,6 +98,11 @@ enum  exynos4_jpeg_img_quality_level {
 	QUALITY_LEVEL_4,	/* low */
 };
 
+enum s5p_jpeg_ctx_state {
+	JPEGCTX_RUNNING = 0,
+	JPEGCTX_RESOLUTION_CHANGE,
+};
+
 /**
  * struct s5p_jpeg - JPEG IP abstraction
  * @lock:		the mutex protecting this structure
@@ -220,6 +225,7 @@ struct s5p_jpeg_q_data {
  * @hdr_parsed:		set if header has been parsed during decompression
  * @crop_altered:	set if crop rectangle has been altered by the user space
  * @ctrl_handler:	controls handler
+ * @state:		state of the context
  */
 struct s5p_jpeg_ctx {
 	struct s5p_jpeg		*jpeg;
@@ -235,6 +241,7 @@ struct s5p_jpeg_ctx {
 	bool			hdr_parsed;
 	bool			crop_altered;
 	struct v4l2_ctrl_handler ctrl_handler;
+	enum s5p_jpeg_ctx_state	state;
 };
 
 /**
-- 
2.7.4
