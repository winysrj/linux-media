Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:56541 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750736AbdCBJww (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Mar 2017 04:52:52 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: implement encoder stop command
Date: Thu,  2 Mar 2017 10:51:44 +0100
Message-Id: <20170302095144.32090-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to call v4l2_m2m_try_schedule to kick off draining the
bitstream buffer for the encoder, but we have to wake up the destination
queue in case there are no new OUTPUT buffers to be encoded and userspace
is already polling for new CAPTURE buffers.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 47 +++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index e1a2e8c70db01..085bbdb0d361b 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -881,6 +881,47 @@ static int coda_g_selection(struct file *file, void *fh,
 	return 0;
 }
 
+static int coda_try_encoder_cmd(struct file *file, void *fh,
+				struct v4l2_encoder_cmd *ec)
+{
+	if (ec->cmd != V4L2_ENC_CMD_STOP)
+		return -EINVAL;
+
+	if (ec->flags & V4L2_ENC_CMD_STOP_AT_GOP_END)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int coda_encoder_cmd(struct file *file, void *fh,
+			    struct v4l2_encoder_cmd *ec)
+{
+	struct coda_ctx *ctx = fh_to_ctx(fh);
+	struct vb2_queue *dst_vq;
+	int ret;
+
+	ret = coda_try_encoder_cmd(file, fh, ec);
+	if (ret < 0)
+		return ret;
+
+	/* Ignore encoder stop command silently in decoder context */
+	if (ctx->inst_type != CODA_INST_ENCODER)
+		return 0;
+
+	/* Set the stream-end flag on this context */
+	ctx->bit_stream_param |= CODA_BIT_STREAM_END_FLAG;
+
+	/* If there is no buffer in flight, wake up */
+	if (ctx->qsequence == ctx->osequence) {
+		dst_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
+					 V4L2_BUF_TYPE_VIDEO_CAPTURE);
+		dst_vq->last_buffer_dequeued = true;
+		wake_up(&dst_vq->done_wq);
+	}
+
+	return 0;
+}
+
 static int coda_try_decoder_cmd(struct file *file, void *fh,
 				struct v4l2_decoder_cmd *dc)
 {
@@ -1054,6 +1095,8 @@ static const struct v4l2_ioctl_ops coda_ioctl_ops = {
 
 	.vidioc_g_selection	= coda_g_selection,
 
+	.vidioc_try_encoder_cmd	= coda_try_encoder_cmd,
+	.vidioc_encoder_cmd	= coda_encoder_cmd,
 	.vidioc_try_decoder_cmd	= coda_try_decoder_cmd,
 	.vidioc_decoder_cmd	= coda_decoder_cmd,
 
@@ -1330,9 +1373,13 @@ static void coda_buf_queue(struct vb2_buffer *vb)
 		mutex_lock(&ctx->bitstream_mutex);
 		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 		if (vb2_is_streaming(vb->vb2_queue))
+			/* This set buf->sequence = ctx->qsequence++ */
 			coda_fill_bitstream(ctx, true);
 		mutex_unlock(&ctx->bitstream_mutex);
 	} else {
+		if (ctx->inst_type == CODA_INST_ENCODER &&
+		    vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+			vbuf->sequence = ctx->qsequence++;
 		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 	}
 }
-- 
2.11.0
