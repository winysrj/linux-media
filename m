Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB5BC65BAF
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 12:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AEB42086D
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 12:39:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8AEB42086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbeLLMjH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 07:39:07 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:39657 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727425AbeLLMjH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 07:39:07 -0500
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud8.xs4all.net with ESMTPA
        id X3n3gidc5uDWoX3n6gHoX9; Wed, 12 Dec 2018 13:39:04 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv5 7/8] cedrus: identify buffers by timestamp
Date:   Wed, 12 Dec 2018 13:39:00 +0100
Message-Id: <20181212123901.34109-8-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181212123901.34109-1-hverkuil-cisco@xs4all.nl>
References: <20181212123901.34109-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfDHd6ERTK7RM32mc/MX3BgW/wGw99H95hHfgKIRdh3CyUZZovlctbVhEYqH7W2vjqq7A32lp9ID7ZyLat76rU2FrjlMNCfqCnh+kJMKTiQeb1PVI7zxb
 zCjex5ZMBOIRzEk5cOr33huvyXZNtxNxQKETKmFhfYyypwSd6iHPPjr24HSEkeFh5ez2HHbifQuMLB8GBWouJ6nS0ID757dnDHN9G4rcsx9vAI8HahNMuXaM
 WAzGSqjB/qWw/P8pS4Re8djKKqKJkeajEqwU09haqaFijTb9/vqz1kg8nZMigom+hV1mEtfgjLZfYHp/HmkimZl1ED9XFbdzNAb14x5Zyf7A8XhtQjFby1CV
 JxmtVLaN5pTNu4NN0yzNGR1UouOM0TgvfA5OD4DcuFFk+A0mIDOXQAH4gnFo/oK/gUKvSUqQdlvP1jTjrN7MaNiara5XVZVTC1T3bjlwBiFHEZG49yc=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Use the new v4l2_m2m_buf_copy_data helper function and use
timestamps to refer to reference frames instead of using
buffer indices.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/v4l2-core/v4l2-ctrls.c          |  9 --------
 drivers/staging/media/sunxi/cedrus/cedrus.h   |  9 +++++---
 .../staging/media/sunxi/cedrus/cedrus_dec.c   |  2 ++
 .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 21 ++++++++-----------
 include/uapi/linux/v4l2-controls.h            | 14 +++++--------
 5 files changed, 22 insertions(+), 33 deletions(-)

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
index 3acfdcf83691..4aedd24a9848 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.h
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.h
@@ -140,11 +140,14 @@ static inline dma_addr_t cedrus_buf_addr(struct vb2_buffer *buf,
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
index 591d191d4286..443fb037e1cf 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
@@ -50,6 +50,8 @@ void cedrus_device_run(void *priv)
 		break;
 	}
 
+	v4l2_m2m_buf_copy_data(run.src, run.dst, true);
+
 	dev->dec_ops[ctx->current_codec]->setup(ctx, &run);
 
 	/* Complete request(s) controls if needed. */
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
index 9abd39cae38c..f05d859d525e 100644
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
+	forward_idx = vb2_find_timestamp(cap_q, slice_params->forward_ref_ts, 0);
 
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
+	backward_idx = vb2_find_timestamp(cap_q, slice_params->backward_ref_ts, 0);
+	bwd_luma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 0);
+	bwd_chroma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 1);
 
 	cedrus_write(dev, VE_DEC_MPEG_BWD_REF_LUMA_ADDR, bwd_luma_addr);
 	cedrus_write(dev, VE_DEC_MPEG_BWD_REF_CHROMA_ADDR, bwd_chroma_addr);
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 998983a6e6b7..6e5067f1aca4 100644
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
+	__u64	backward_ref_ts;
+	__u64	forward_ref_ts;
 
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
2.19.2

