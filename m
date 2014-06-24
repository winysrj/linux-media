Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57733 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbaFXO4i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 10:56:38 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 01/29] [media] coda: fix decoder I/P/B frame detection
Date: Tue, 24 Jun 2014 16:55:43 +0200
Message-Id: <1403621771-11636-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
References: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently the rotator unit is used to copy decoded frames out into buffers
provided by videobuf2. Since the CODA reports the I/P/B frame type of the
last decoded frame, and this frame will be copied out in a later device_run,
depending on display order, we have to store the frame type until such time.
This patch also adds the B-frame type.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Also clear V4L2_BUF_FLAG_BFRAME
---
 drivers/media/platform/coda.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index b178379..a7c5ac5 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -209,6 +209,7 @@ struct coda_ctx {
 	struct coda_aux_buf		psbuf;
 	struct coda_aux_buf		slicebuf;
 	struct coda_aux_buf		internal_frames[CODA_MAX_FRAMEBUFFERS];
+	u32				frame_types[CODA_MAX_FRAMEBUFFERS];
 	struct coda_aux_buf		workbuf;
 	int				num_internal_frames;
 	int				idx;
@@ -2693,15 +2694,6 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 
 	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 
-	val = coda_read(dev, CODA_RET_DEC_PIC_TYPE);
-	if ((val & 0x7) == 0) {
-		dst_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
-		dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_PFRAME;
-	} else {
-		dst_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_PFRAME;
-		dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_KEYFRAME;
-	}
-
 	val = coda_read(dev, CODA_RET_DEC_PIC_ERR_MB);
 	if (val > 0)
 		v4l2_err(&dev->v4l2_dev,
@@ -2748,6 +2740,14 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 	} else if (decoded_idx < 0 || decoded_idx >= ctx->num_internal_frames) {
 		v4l2_err(&dev->v4l2_dev,
 			 "decoded frame index out of range: %d\n", decoded_idx);
+	} else {
+		val = coda_read(dev, CODA_RET_DEC_PIC_TYPE) & 0x7;
+		if (val == 0)
+			ctx->frame_types[decoded_idx] = V4L2_BUF_FLAG_KEYFRAME;
+		else if (val == 1)
+			ctx->frame_types[decoded_idx] = V4L2_BUF_FLAG_PFRAME;
+		else
+			ctx->frame_types[decoded_idx] = V4L2_BUF_FLAG_BFRAME;
 	}
 
 	if (display_idx == -1) {
@@ -2770,6 +2770,11 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
 		dst_buf->v4l2_buf.sequence = ctx->osequence++;
 
+		dst_buf->v4l2_buf.flags &= ~(V4L2_BUF_FLAG_KEYFRAME |
+					     V4L2_BUF_FLAG_PFRAME |
+					     V4L2_BUF_FLAG_BFRAME);
+		dst_buf->v4l2_buf.flags |= ctx->frame_types[ctx->display_idx];
+
 		vb2_set_plane_payload(dst_buf, 0, width * height * 3 / 2);
 
 		v4l2_m2m_buf_done(dst_buf, success ? VB2_BUF_STATE_DONE :
-- 
2.0.0

