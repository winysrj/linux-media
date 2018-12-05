Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	URIBL_RHS_DOB,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B280EC04EBF
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79AEA206B7
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:20:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 79AEA206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbeLEKUx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 05:20:53 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:48335 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727862AbeLEKUw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 05:20:52 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id UUIKgznz1aOW5UUIUgJeks; Wed, 05 Dec 2018 11:20:51 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        sakari.ailus@linux.intel.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv4 10/10] cedrus: add tag support
Date:   Wed,  5 Dec 2018 11:20:40 +0100
Message-Id: <20181205102040.11741-11-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181205102040.11741-1-hverkuil-cisco@xs4all.nl>
References: <20181205102040.11741-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfH8jM9pT3fCWGO8wK9NWRLQyIEuujk+wbi9vOuhxCbJBCWDzSF8MnEUdMBUqg2NW8Sa4wWoX+MJrkw/4oEIAbx/0GseXBDIdfIjm1LNCDfRs63z2t9mX
 6SLcCvGKOutVW/IgOq3uZUO37T2P1vfI7KqGkg9Jh94zwkRbSvwhIg2vGBToYo4HRBPw50xGlS/P//d0k+aF7ARtYnvPfJ5HE5pPSDLNAOvYDb6gDt293RTj
 Gj8y4wcZrDq0mkWKh/3uioa8COFOILdikx7jh5zOaKr92RvQNbJOH4LZmfGyD6i8wlY0+uTk/YEt5SNmPreWUpZsg2h8PNq6C+vnEVwAT8DQoMZCpugQITrx
 XEnszpV+TdLqgoGdSYl1N53C7FaY/4ffYKYBwbUAwknEybKsa70Yp49XtQzK30XSayVqnW+AaHDjdcLKKGPq1JbVJKquEQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Replace old reference frame indices by new tag method.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c          |  9 --------
 drivers/staging/media/sunxi/cedrus/cedrus.h   |  9 +++++---
 .../staging/media/sunxi/cedrus/cedrus_dec.c   |  2 ++
 .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 21 ++++++++-----------
 .../staging/media/sunxi/cedrus/cedrus_video.c |  2 ++
 include/uapi/linux/v4l2-controls.h            | 14 +++++--------
 6 files changed, 24 insertions(+), 33 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 129a986fa7e1..e859496e4e95 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1661,15 +1661,6 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
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
index 3f61248c57ac..781676b55a1b 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.h
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.h
@@ -142,11 +142,14 @@ static inline dma_addr_t cedrus_buf_addr(struct vb2_buffer *buf,
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
+
+	buf = ctx->dst_bufs[index];
 	return buf ? cedrus_buf_addr(buf, &ctx->dst_fmt, plane) : 0;
 }
 
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
index e40180a33951..0cfd6036d0cd 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
@@ -53,6 +53,8 @@ void cedrus_device_run(void *priv)
 		break;
 	}
 
+	v4l2_m2m_buf_copy_data(run.src, run.dst, true);
+
 	dev->dec_ops[ctx->current_codec]->setup(ctx, &run);
 
 	spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
index 9abd39cae38c..fdde9a099153 100644
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
 
@@ -156,23 +159,17 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
 	cedrus_write(dev, VE_DEC_MPEG_PICBOUNDSIZE, reg);
 
 	/* Forward and backward prediction reference buffers. */
+	forward_idx = vb2_find_tag(cap_q, slice_params->forward_ref_tag, 0);
 
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
+	backward_idx = vb2_find_tag(cap_q, slice_params->backward_ref_tag, 0);
+	bwd_luma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 0);
+	bwd_chroma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 1);
 
 	cedrus_write(dev, VE_DEC_MPEG_BWD_REF_LUMA_ADDR, bwd_luma_addr);
 	cedrus_write(dev, VE_DEC_MPEG_BWD_REF_CHROMA_ADDR, bwd_chroma_addr);
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
index 5c5fce678b93..293df48326cc 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
@@ -522,6 +522,7 @@ int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->lock = &ctx->dev->dev_mutex;
 	src_vq->dev = ctx->dev->dev;
 	src_vq->supports_requests = true;
+	src_vq->supports_tags = true;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -537,6 +538,7 @@ int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	dst_vq->lock = &ctx->dev->dev_mutex;
 	dst_vq->dev = ctx->dev->dev;
+	dst_vq->supports_tags = true;
 
 	return vb2_queue_init(dst_vq);
 }
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 998983a6e6b7..45a55bb27e5a 100644
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
+	__u32	backward_ref_tag;
+	__u32	forward_ref_tag;
 
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

