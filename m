Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52228 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbbEDKvO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 06:51:14 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Pawel Osciak <pawel@osciak.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v6 4/5] [media] coda: Set last buffer flag and fix EOS event
Date: Mon,  4 May 2015 12:51:07 +0200
Message-Id: <1430736668-28582-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1430736668-28582-1-git-send-email-p.zabel@pengutronix.de>
References: <1430736668-28582-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Setting the last buffer flag causes the videobuf2 core to return -EPIPE from
DQBUF calls on the capture queue after the last buffer is dequeued.
This patch also fixes the EOS event to conform to the specification. It now is
sent right after the last buffer has been decoded instead of when the last
buffer is dequeued.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    |  4 ++--
 drivers/media/platform/coda/coda-common.c | 27 +++++++++++----------------
 drivers/media/platform/coda/coda.h        |  3 +++
 3 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index d043007..109797b 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1305,7 +1305,7 @@ static void coda_finish_encode(struct coda_ctx *ctx)
 	v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
 
 	dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
-	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
+	coda_m2m_buf_done(ctx, dst_buf, VB2_BUF_STATE_DONE);
 
 	ctx->gopcounter--;
 	if (ctx->gopcounter < 0)
@@ -1975,7 +1975,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		}
 		vb2_set_plane_payload(dst_buf, 0, payload);
 
-		v4l2_m2m_buf_done(dst_buf, ctx->frame_errors[display_idx] ?
+		coda_m2m_buf_done(ctx, dst_buf, ctx->frame_errors[display_idx] ?
 				  VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 
 		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 8e6fe02..6d6e0ca 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -724,35 +724,30 @@ static int coda_qbuf(struct file *file, void *priv,
 }
 
 static bool coda_buf_is_end_of_stream(struct coda_ctx *ctx,
-				      struct v4l2_buffer *buf)
+				      struct vb2_buffer *buf)
 {
 	struct vb2_queue *src_vq;
 
 	src_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 
 	return ((ctx->bit_stream_param & CODA_BIT_STREAM_END_FLAG) &&
-		(buf->sequence == (ctx->qsequence - 1)));
+		(buf->v4l2_buf.sequence == (ctx->qsequence - 1)));
 }
 
-static int coda_dqbuf(struct file *file, void *priv,
-		      struct v4l2_buffer *buf)
+void coda_m2m_buf_done(struct coda_ctx *ctx, struct vb2_buffer *buf,
+		       enum vb2_buffer_state state)
 {
-	struct coda_ctx *ctx = fh_to_ctx(priv);
-	int ret;
+	const struct v4l2_event eos_event = {
+		.type = V4L2_EVENT_EOS
+	};
 
-	ret = v4l2_m2m_dqbuf(file, ctx->fh.m2m_ctx, buf);
-
-	/* If this is the last capture buffer, emit an end-of-stream event */
-	if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
-	    coda_buf_is_end_of_stream(ctx, buf)) {
-		const struct v4l2_event eos_event = {
-			.type = V4L2_EVENT_EOS
-		};
+	if (coda_buf_is_end_of_stream(ctx, buf)) {
+		buf->v4l2_buf.flags |= V4L2_BUF_FLAG_LAST;
 
 		v4l2_event_queue_fh(&ctx->fh, &eos_event);
 	}
 
-	return ret;
+	v4l2_m2m_buf_done(buf, state);
 }
 
 static int coda_g_selection(struct file *file, void *fh,
@@ -865,7 +860,7 @@ static const struct v4l2_ioctl_ops coda_ioctl_ops = {
 
 	.vidioc_qbuf		= coda_qbuf,
 	.vidioc_expbuf		= v4l2_m2m_ioctl_expbuf,
-	.vidioc_dqbuf		= coda_dqbuf,
+	.vidioc_dqbuf		= v4l2_m2m_ioctl_dqbuf,
 	.vidioc_create_bufs	= v4l2_m2m_ioctl_create_bufs,
 
 	.vidioc_streamon	= v4l2_m2m_ioctl_streamon,
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 6a5c8f6..8e0af22 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -287,6 +287,9 @@ static inline unsigned int coda_get_bitstream_payload(struct coda_ctx *ctx)
 
 void coda_bit_stream_end_flag(struct coda_ctx *ctx);
 
+void coda_m2m_buf_done(struct coda_ctx *ctx, struct vb2_buffer *buf,
+		       enum vb2_buffer_state state);
+
 int coda_h264_padding(int size, char *p);
 
 bool coda_jpeg_check_buffer(struct coda_ctx *ctx, struct vb2_buffer *vb);
-- 
2.1.4

