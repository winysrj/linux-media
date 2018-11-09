Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:58370 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728102AbeKITgK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Nov 2018 14:36:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC PATCH 5/5] cedrus: add cookie support
Date: Fri,  9 Nov 2018 10:56:13 +0100
Message-Id: <20181109095613.28272-6-hverkuil@xs4all.nl>
In-Reply-To: <20181109095613.28272-1-hverkuil@xs4all.nl>
References: <20181109095613.28272-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace old reference frame indices by new cookie method.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/v4l2-core/v4l2-ctrls.c          |  9 --------
 drivers/staging/media/sunxi/cedrus/cedrus.h   |  8 ++++---
 .../staging/media/sunxi/cedrus/cedrus_dec.c   | 10 ++++++++
 .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 23 +++++++++----------
 include/uapi/linux/v4l2-controls.h            | 14 ++++-------
 5 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 5f2b033a7a42..b854cceb19dc 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1660,15 +1660,6 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 			return -EINVAL;
 		}
 
-		if (p_mpeg2_slice_params->backward_ref_index >= VIDEO_MAX_FRAME ||
-		    p_mpeg2_slice_params->forward_ref_index >= VIDEO_MAX_FRAME)
-			return -EINVAL;
-
-		if (p_mpeg2_slice_params->pad ||
-		    p_mpeg2_slice_params->picture.pad ||
-		    p_mpeg2_slice_params->sequence.pad)
-			return -EINVAL;
-
 		return 0;
 
 	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.h b/drivers/staging/media/sunxi/cedrus/cedrus.h
index 3f61248c57ac..a4bc19ae6bcc 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.h
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.h
@@ -142,11 +142,13 @@ static inline dma_addr_t cedrus_buf_addr(struct vb2_buffer *buf,
 }
 
 static inline dma_addr_t cedrus_dst_buf_addr(struct cedrus_ctx *ctx,
-					     unsigned int index,
-					     unsigned int plane)
+					     int index, unsigned int plane)
 {
-	struct vb2_buffer *buf = ctx->dst_bufs[index];
+	struct vb2_buffer *buf;
 
+	if (index < 0)
+		return 0;
+	buf = ctx->dst_bufs[index];
 	return buf ? cedrus_buf_addr(buf, &ctx->dst_fmt, plane) : 0;
 }
 
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
index e40180a33951..b978c562f7df 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
@@ -53,6 +53,16 @@ void cedrus_device_run(void *priv)
 		break;
 	}
 
+	run.dst->vb2_buf.timestamp = run.src->vb2_buf.timestamp;
+	if (run.src->flags & V4L2_BUF_FLAG_TIMECODE)
+		run.dst->timecode = run.src->timecode;
+	else if (run.src->flags & V4L2_BUF_FLAG_COOKIE)
+		run.dst->cookie = run.src->cookie;
+	run.dst->flags = run.src->flags &
+		(V4L2_BUF_FLAG_TIMECODE |
+		 V4L2_BUF_FLAG_COOKIE |
+		 V4L2_BUF_FLAG_TSTAMP_SRC_MASK);
+
 	dev->dec_ops[ctx->current_codec]->setup(ctx, &run);
 
 	spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
index 9abd39cae38c..5634ef658904 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
@@ -82,7 +82,10 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
 	dma_addr_t fwd_luma_addr, fwd_chroma_addr;
 	dma_addr_t bwd_luma_addr, bwd_chroma_addr;
 	struct cedrus_dev *dev = ctx->dev;
+	struct vb2_queue *cap_q = &ctx->fh.m2m_ctx->cap_q_ctx.q;
 	const u8 *matrix;
+	int forward_idx;
+	int backward_idx;
 	unsigned int i;
 	u32 reg;
 
@@ -156,23 +159,19 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
 	cedrus_write(dev, VE_DEC_MPEG_PICBOUNDSIZE, reg);
 
 	/* Forward and backward prediction reference buffers. */
+	forward_idx = vb2_find_cookie(cap_q,
+				      slice_params->forward_ref_cookie, 0);
 
-	fwd_luma_addr = cedrus_dst_buf_addr(ctx,
-					    slice_params->forward_ref_index,
-					    0);
-	fwd_chroma_addr = cedrus_dst_buf_addr(ctx,
-					      slice_params->forward_ref_index,
-					      1);
+	fwd_luma_addr = cedrus_dst_buf_addr(ctx, forward_idx, 0);
+	fwd_chroma_addr = cedrus_dst_buf_addr(ctx, forward_idx, 1);
 
 	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_LUMA_ADDR, fwd_luma_addr);
 	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_CHROMA_ADDR, fwd_chroma_addr);
 
-	bwd_luma_addr = cedrus_dst_buf_addr(ctx,
-					    slice_params->backward_ref_index,
-					    0);
-	bwd_chroma_addr = cedrus_dst_buf_addr(ctx,
-					      slice_params->backward_ref_index,
-					      1);
+	backward_idx = vb2_find_cookie(cap_q,
+				       slice_params->backward_ref_cookie, 0);
+	bwd_luma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 0);
+	bwd_chroma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 1);
 
 	cedrus_write(dev, VE_DEC_MPEG_BWD_REF_LUMA_ADDR, bwd_luma_addr);
 	cedrus_write(dev, VE_DEC_MPEG_BWD_REF_CHROMA_ADDR, bwd_chroma_addr);
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 998983a6e6b7..e0d135015954 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -1109,10 +1109,9 @@ struct v4l2_mpeg2_sequence {
 	__u32	vbv_buffer_size;
 
 	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Sequence extension */
-	__u8	profile_and_level_indication;
+	__u16	profile_and_level_indication;
 	__u8	progressive_sequence;
 	__u8	chroma_format;
-	__u8	pad;
 };
 
 struct v4l2_mpeg2_picture {
@@ -1130,23 +1129,20 @@ struct v4l2_mpeg2_picture {
 	__u8	intra_vlc_format;
 	__u8	alternate_scan;
 	__u8	repeat_first_field;
-	__u8	progressive_frame;
-	__u8	pad;
+	__u16	progressive_frame;
 };
 
 struct v4l2_ctrl_mpeg2_slice_params {
 	__u32	bit_size;
 	__u32	data_bit_offset;
+	__u64	backward_ref_cookie;
+	__u64	forward_ref_cookie;
 
 	struct v4l2_mpeg2_sequence sequence;
 	struct v4l2_mpeg2_picture picture;
 
 	/* ISO/IEC 13818-2, ITU-T Rec. H.262: Slice */
-	__u8	quantiser_scale_code;
-
-	__u8	backward_ref_index;
-	__u8	forward_ref_index;
-	__u8	pad;
+	__u32	quantiser_scale_code;
 };
 
 struct v4l2_ctrl_mpeg2_quantization {
-- 
2.19.1
