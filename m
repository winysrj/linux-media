Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2511C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E497206DD
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BbVS8/B9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfCFVO0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:14:26 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34969 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfCFVO0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:14:26 -0500
Received: by mail-wr1-f67.google.com with SMTP id t18so15050104wrx.2
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Mdiw33VQVsyIp0tyh2/dE0nHUFM8oGXwije4Jw5HgM4=;
        b=BbVS8/B9H5PZjVSFgbSpQvbKWhW9iNAgSGg9u0La5kB82cHqKyYCKnkzdJxhONXE9U
         VlTp7YphRV1XG4ZuA78Y6kx0OMN9G2QJsCGUxU8sLQfIfAoxZkYJI//5fIppEaSNq44E
         HJucxNrN+6Cp4niya6znkSk8rmZhAtqzqE8Ujk5HYBiY3ve8V6tzEXcwA/+9pXmBrSJn
         p9QgR0Yu1luO+xquXaCX7FV1LXbNJTjQZWbsJ1FSht+2FmKIAkBlUTxqJFsDQJnjiP+G
         SQxtJCDIBotPNVtsxjXdTZMSvX33ex/WpvpVUrimXQVl49X4V0FYgbN0v0nUCESOvX3u
         H3Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Mdiw33VQVsyIp0tyh2/dE0nHUFM8oGXwije4Jw5HgM4=;
        b=gyByoC0WDDzcriYf5HWbxXRHVUqao50vlMGiYk0M89fbooITAVolioW48CJJu1z3mh
         BzOGlxBJzu+u898F5U5VuGNWOLo6Q5IeWhrWLryGEdB+bkcXBsHbIUCwrtbO/Tu6Yjvj
         R7tMprHQOJ7YiCtTfuAHhFQxnCtMmmzQNz8M/3SgA8v8E0jAn3E7xyFXkNomMUw0BGDw
         hAH6q297rT1nJvYSJYdqgMsTIBOcYBAtfR2H8/C9iaznOWnBGl8/v8TO/6QNLRavC2TA
         oZxgqqE1qxIVwILHLDh3IatXG4NTeq04pXsC4EHSrVDwj7K8XIRSTDhFgxIDIIp4zREx
         9U6A==
X-Gm-Message-State: APjAAAUG1tPG8IUfhkkMFb4qI42aNHDt0LDKWKd904Ew2kzR6tAclhR2
        ZWFmqjQIC4fz5vsXxMMKB7DKAp0TqBE=
X-Google-Smtp-Source: APXvYqxEmdgKH7OIT0B6bB6I0B/EPbUjDNGevYGACLcmCjaMKCOtzVdCm3txIFC9Y4EwC2bSSo0bsA==
X-Received: by 2002:a5d:4843:: with SMTP id n3mr4152288wrs.209.1551906862565;
        Wed, 06 Mar 2019 13:14:22 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id a9sm1882126wmm.10.2019.03.06.13.14.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:14:21 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 12/23] media: vicodec: keep the ref frame according to the format in decoder
Date:   Wed,  6 Mar 2019 13:13:32 -0800
Message-Id: <20190306211343.15302-13-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211343.15302-1-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In the decoder, save the inner reference frame in the same
format as the capture buffer.
The decoder writes directly to the capture buffer and then
the capture buffer is copied to the reference buffer.
This will simplify the stateless decoder.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/codec-fwht.c   |  83 +++---
 drivers/media/platform/vicodec/codec-fwht.h   |  11 +-
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 255 ++----------------
 .../media/platform/vicodec/codec-v4l2-fwht.h  |   1 +
 drivers/media/platform/vicodec/vicodec-core.c |  40 +++
 5 files changed, 122 insertions(+), 268 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
index d1d6085da9f1..9a0dc739c58c 100644
--- a/drivers/media/platform/vicodec/codec-fwht.c
+++ b/drivers/media/platform/vicodec/codec-fwht.c
@@ -632,12 +632,13 @@ static int decide_blocktype(const u8 *cur, const u8 *reference,
 	return vari <= vard ? IBLOCK : PBLOCK;
 }
 
-static void fill_decoder_block(u8 *dst, const s16 *input, int stride)
+static void fill_decoder_block(u8 *dst, const s16 *input, int stride,
+			       unsigned int dst_step)
 {
 	int i, j;
 
 	for (i = 0; i < 8; i++) {
-		for (j = 0; j < 8; j++, input++, dst++) {
+		for (j = 0; j < 8; j++, input++, dst += dst_step) {
 			if (*input < 0)
 				*dst = 0;
 			else if (*input > 255)
@@ -645,17 +646,19 @@ static void fill_decoder_block(u8 *dst, const s16 *input, int stride)
 			else
 				*dst = *input;
 		}
-		dst += stride - 8;
+		dst += stride - (8 * dst_step);
 	}
 }
 
-static void add_deltas(s16 *deltas, const u8 *ref, int stride)
+static void add_deltas(s16 *deltas, const u8 *ref, int stride,
+		       unsigned int ref_step)
 {
 	int k, l;
 
 	for (k = 0; k < 8; k++) {
 		for (l = 0; l < 8; l++) {
-			*deltas += *ref++;
+			*deltas += *ref;
+			ref += ref_step;
 			/*
 			 * Due to quantizing, it might possible that the
 			 * decoded coefficients are slightly out of range
@@ -666,7 +669,7 @@ static void add_deltas(s16 *deltas, const u8 *ref, int stride)
 				*deltas = 255;
 			deltas++;
 		}
-		ref += stride - 8;
+		ref += stride - (8 * ref_step);
 	}
 }
 
@@ -711,8 +714,8 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
 				ifwht(cf->de_coeffs, cf->de_fwht, blocktype);
 
 				if (blocktype == PBLOCK)
-					add_deltas(cf->de_fwht, refp, 8);
-				fill_decoder_block(refp, cf->de_fwht, 8);
+					add_deltas(cf->de_fwht, refp, 8, 1);
+				fill_decoder_block(refp, cf->de_fwht, 8, 1);
 			}
 
 			input += 8 * input_step;
@@ -821,8 +824,10 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 	return encoding;
 }
 
-static bool decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
-			 u32 height, u32 width, u32 coded_width,
+static bool decode_plane(struct fwht_cframe *cf, const __be16 **rlco,
+			 u32 height, u32 width, const u8 *ref, u32 ref_stride,
+			 unsigned int ref_step, u8 *dst,
+			 unsigned int dst_stride, unsigned int dst_step,
 			 bool uncompressed, const __be16 *end_of_rlco_buf)
 {
 	unsigned int copies = 0;
@@ -834,10 +839,15 @@ static bool decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
 	height = round_up(height, 8);
 
 	if (uncompressed) {
+		int i;
+
 		if (end_of_rlco_buf + 1 < *rlco + width * height / 2)
 			return false;
-		memcpy(ref, *rlco, width * height);
-		*rlco += width * height / 2;
+		for (i = 0; i < height; i++) {
+			memcpy(dst, *rlco, width);
+			dst += dst_stride;
+			*rlco += width / 2;
+		}
 		return true;
 	}
 
@@ -849,15 +859,17 @@ static bool decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
 	 */
 	for (j = 0; j < height / 8; j++) {
 		for (i = 0; i < width / 8; i++) {
-			u8 *refp = ref + j * 8 * coded_width + i * 8;
+			const u8 *refp = ref + j * 8 * ref_stride +
+				i * 8 * ref_step;
+			u8 *dstp = dst + j * 8 * dst_stride + i * 8 * dst_step;
 
 			if (copies) {
 				memcpy(cf->de_fwht, copy, sizeof(copy));
 				if (stat & PFRAME_BIT)
 					add_deltas(cf->de_fwht, refp,
-						   coded_width);
-				fill_decoder_block(refp, cf->de_fwht,
-						   coded_width);
+						   ref_stride, ref_step);
+				fill_decoder_block(dstp, cf->de_fwht,
+						   dst_stride, dst_step);
 				copies--;
 				continue;
 			}
@@ -877,23 +889,29 @@ static bool decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
 			if (copies)
 				memcpy(copy, cf->de_fwht, sizeof(copy));
 			if (stat & PFRAME_BIT)
-				add_deltas(cf->de_fwht, refp, coded_width);
-			fill_decoder_block(refp, cf->de_fwht, coded_width);
+				add_deltas(cf->de_fwht, refp,
+					   ref_stride, ref_step);
+			fill_decoder_block(dstp, cf->de_fwht, dst_stride,
+					   dst_step);
 		}
 	}
 	return true;
 }
 
-bool fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
-		       u32 hdr_flags, unsigned int components_num,
-		       unsigned int width, unsigned int height,
-		       unsigned int coded_width)
+bool fwht_decode_frame(struct fwht_cframe *cf, u32 hdr_flags,
+		       unsigned int components_num, unsigned int width,
+		       unsigned int height, const struct fwht_raw_frame *ref,
+		       unsigned int ref_stride, unsigned int ref_chroma_stride,
+		       struct fwht_raw_frame *dst, unsigned int dst_stride,
+		       unsigned int dst_chroma_stride)
 {
 	const __be16 *rlco = cf->rlc_data;
 	const __be16 *end_of_rlco_buf = cf->rlc_data +
 			(cf->size / sizeof(*rlco)) - 1;
 
-	if (!decode_plane(cf, &rlco, ref->luma, height, width, coded_width,
+	if (!decode_plane(cf, &rlco, height, width, ref->luma, ref_stride,
+			  ref->luma_alpha_step, dst->luma, dst_stride,
+			  dst->luma_alpha_step,
 			  hdr_flags & FWHT_FL_LUMA_IS_UNCOMPRESSED,
 			  end_of_rlco_buf))
 		return false;
@@ -901,27 +919,30 @@ bool fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
 	if (components_num >= 3) {
 		u32 h = height;
 		u32 w = width;
-		u32 c = coded_width;
 
 		if (!(hdr_flags & FWHT_FL_CHROMA_FULL_HEIGHT))
 			h /= 2;
-		if (!(hdr_flags & FWHT_FL_CHROMA_FULL_WIDTH)) {
+		if (!(hdr_flags & FWHT_FL_CHROMA_FULL_WIDTH))
 			w /= 2;
-			c /= 2;
-		}
-		if (!decode_plane(cf, &rlco, ref->cb, h, w, c,
+
+		if (!decode_plane(cf, &rlco, h, w, ref->cb, ref_chroma_stride,
+				  ref->chroma_step, dst->cb, dst_chroma_stride,
+				  dst->chroma_step,
 				  hdr_flags & FWHT_FL_CB_IS_UNCOMPRESSED,
 				  end_of_rlco_buf))
 			return false;
-		if (!decode_plane(cf, &rlco, ref->cr, h, w, c,
+		if (!decode_plane(cf, &rlco, h, w, ref->cr, ref_chroma_stride,
+				  ref->chroma_step, dst->cr, dst_chroma_stride,
+				  dst->chroma_step,
 				  hdr_flags & FWHT_FL_CR_IS_UNCOMPRESSED,
 				  end_of_rlco_buf))
 			return false;
 	}
 
 	if (components_num == 4)
-		if (!decode_plane(cf, &rlco, ref->alpha, height, width,
-				  coded_width,
+		if (!decode_plane(cf, &rlco, height, width, ref->alpha, ref_stride,
+				  ref->luma_alpha_step, dst->alpha, dst_stride,
+				  dst->luma_alpha_step,
 				  hdr_flags & FWHT_FL_ALPHA_IS_UNCOMPRESSED,
 				  end_of_rlco_buf))
 			return false;
diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
index 8f0b790839f8..b6fec2b1cbca 100644
--- a/drivers/media/platform/vicodec/codec-fwht.h
+++ b/drivers/media/platform/vicodec/codec-fwht.h
@@ -141,9 +141,10 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 		      bool is_intra, bool next_is_intra,
 		      unsigned int width, unsigned int height,
 		      unsigned int stride, unsigned int chroma_stride);
-bool fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
-		       u32 hdr_flags, unsigned int components_num,
-		       unsigned int width, unsigned int height,
-		       unsigned int coded_width);
-
+bool fwht_decode_frame(struct fwht_cframe *cf, u32 hdr_flags,
+		unsigned int components_num, unsigned int width,
+		unsigned int height, const struct fwht_raw_frame *ref,
+		unsigned int ref_stride, unsigned int ref_chroma_stride,
+		struct fwht_raw_frame *dst, unsigned int dst_stride,
+		unsigned int dst_chroma_stride);
 #endif
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index 515b3115b3c6..f15d76fae45c 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -248,14 +248,17 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 
 int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 {
-	unsigned int i, j, k;
 	u32 flags;
 	struct fwht_cframe cf;
-	u8 *p, *ref_p;
 	unsigned int components_num = 3;
 	unsigned int version;
 	const struct v4l2_fwht_pixfmt_info *info;
 	unsigned int hdr_width_div, hdr_height_div;
+	struct fwht_raw_frame dst_rf;
+	unsigned int dst_chroma_stride = state->stride;
+	unsigned int ref_chroma_stride = state->ref_stride;
+	unsigned int dst_size = state->stride * state->coded_height;
+	unsigned int ref_size;
 
 	if (!state->info)
 		return -EINVAL;
@@ -303,241 +306,29 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	    hdr_height_div != info->height_div)
 		return -EINVAL;
 
-	if (!fwht_decode_frame(&cf, &state->ref_frame, flags, components_num,
-			       state->visible_width, state->visible_height,
-			       state->coded_width))
+	if (prepare_raw_frame(&dst_rf, info, p_out, dst_size))
 		return -EINVAL;
+	if (info->planes_num == 3) {
+		dst_chroma_stride /= 2;
+		ref_chroma_stride /= 2;
+	}
+	if (info->id == V4L2_PIX_FMT_NV24 ||
+	    info->id == V4L2_PIX_FMT_NV42) {
+		dst_chroma_stride *= 2;
+		ref_chroma_stride *= 2;
+	}
 
-	/*
-	 * TODO - handle the case where the compressed stream encodes a
-	 * different format than the requested decoded format.
-	 */
-	switch (state->info->id) {
-	case V4L2_PIX_FMT_GREY:
-		ref_p = state->ref_frame.luma;
-		for (i = 0; i < state->coded_height; i++)  {
-			memcpy(p_out, ref_p, state->visible_width);
-			p_out += state->stride;
-			ref_p += state->coded_width;
-		}
-		break;
-	case V4L2_PIX_FMT_YUV420:
-	case V4L2_PIX_FMT_YUV422P:
-		ref_p = state->ref_frame.luma;
-		for (i = 0; i < state->coded_height; i++)  {
-			memcpy(p_out, ref_p, state->visible_width);
-			p_out += state->stride;
-			ref_p += state->coded_width;
-		}
-
-		ref_p = state->ref_frame.cb;
-		for (i = 0; i < state->coded_height / 2; i++)  {
-			memcpy(p_out, ref_p, state->visible_width / 2);
-			p_out += state->stride / 2;
-			ref_p += state->coded_width / 2;
-		}
-		ref_p = state->ref_frame.cr;
-		for (i = 0; i < state->coded_height / 2; i++)  {
-			memcpy(p_out, ref_p, state->visible_width / 2);
-			p_out += state->stride / 2;
-			ref_p += state->coded_width / 2;
-		}
-		break;
-	case V4L2_PIX_FMT_YVU420:
-		ref_p = state->ref_frame.luma;
-		for (i = 0; i < state->coded_height; i++)  {
-			memcpy(p_out, ref_p, state->visible_width);
-			p_out += state->stride;
-			ref_p += state->coded_width;
-		}
 
-		ref_p = state->ref_frame.cr;
-		for (i = 0; i < state->coded_height / 2; i++)  {
-			memcpy(p_out, ref_p, state->visible_width / 2);
-			p_out += state->stride / 2;
-			ref_p += state->coded_width / 2;
-		}
-		ref_p = state->ref_frame.cb;
-		for (i = 0; i < state->coded_height / 2; i++)  {
-			memcpy(p_out, ref_p, state->visible_width / 2);
-			p_out += state->stride / 2;
-			ref_p += state->coded_width / 2;
-		}
-		break;
-	case V4L2_PIX_FMT_NV12:
-	case V4L2_PIX_FMT_NV16:
-	case V4L2_PIX_FMT_NV24:
-		ref_p = state->ref_frame.luma;
-		for (i = 0; i < state->coded_height; i++)  {
-			memcpy(p_out, ref_p, state->visible_width);
-			p_out += state->stride;
-			ref_p += state->coded_width;
-		}
+	ref_size = state->ref_stride * state->coded_height;
 
-		k = 0;
-		for (i = 0; i < state->coded_height / 2; i++) {
-			for (j = 0, p = p_out; j < state->coded_width / 2; j++) {
-				*p++ = state->ref_frame.cb[k];
-				*p++ = state->ref_frame.cr[k];
-				k++;
-			}
-			p_out += state->stride;
-		}
-		break;
-	case V4L2_PIX_FMT_NV21:
-	case V4L2_PIX_FMT_NV61:
-	case V4L2_PIX_FMT_NV42:
-		ref_p = state->ref_frame.luma;
-		for (i = 0; i < state->coded_height; i++)  {
-			memcpy(p_out, ref_p, state->visible_width);
-			p_out += state->stride;
-			ref_p += state->coded_width;
-		}
+	if (prepare_raw_frame(&state->ref_frame, info, state->ref_frame.buf,
+			      ref_size))
+		return -EINVAL;
 
-		k = 0;
-		for (i = 0; i < state->coded_height / 2; i++) {
-			for (j = 0, p = p_out; j < state->coded_width / 2; j++) {
-				*p++ = state->ref_frame.cr[k];
-				*p++ = state->ref_frame.cb[k];
-				k++;
-			}
-			p_out += state->stride;
-		}
-		break;
-	case V4L2_PIX_FMT_YUYV:
-		k = 0;
-		for (i = 0; i < state->coded_height; i++) {
-			for (j = 0, p = p_out; j < state->coded_width / 2; j++) {
-				*p++ = state->ref_frame.luma[k];
-				*p++ = state->ref_frame.cb[k / 2];
-				*p++ = state->ref_frame.luma[k + 1];
-				*p++ = state->ref_frame.cr[k / 2];
-				k += 2;
-			}
-			p_out += state->stride;
-		}
-		break;
-	case V4L2_PIX_FMT_YVYU:
-		k = 0;
-		for (i = 0; i < state->coded_height; i++) {
-			for (j = 0, p = p_out; j < state->coded_width / 2; j++) {
-				*p++ = state->ref_frame.luma[k];
-				*p++ = state->ref_frame.cr[k / 2];
-				*p++ = state->ref_frame.luma[k + 1];
-				*p++ = state->ref_frame.cb[k / 2];
-				k += 2;
-			}
-			p_out += state->stride;
-		}
-		break;
-	case V4L2_PIX_FMT_UYVY:
-		k = 0;
-		for (i = 0; i < state->coded_height; i++) {
-			for (j = 0, p = p_out; j < state->coded_width / 2; j++) {
-				*p++ = state->ref_frame.cb[k / 2];
-				*p++ = state->ref_frame.luma[k];
-				*p++ = state->ref_frame.cr[k / 2];
-				*p++ = state->ref_frame.luma[k + 1];
-				k += 2;
-			}
-			p_out += state->stride;
-		}
-		break;
-	case V4L2_PIX_FMT_VYUY:
-		k = 0;
-		for (i = 0; i < state->coded_height; i++) {
-			for (j = 0, p = p_out; j < state->coded_width / 2; j++) {
-				*p++ = state->ref_frame.cr[k / 2];
-				*p++ = state->ref_frame.luma[k];
-				*p++ = state->ref_frame.cb[k / 2];
-				*p++ = state->ref_frame.luma[k + 1];
-				k += 2;
-			}
-			p_out += state->stride;
-		}
-		break;
-	case V4L2_PIX_FMT_RGB24:
-	case V4L2_PIX_FMT_HSV24:
-		k = 0;
-		for (i = 0; i < state->coded_height; i++) {
-			for (j = 0, p = p_out; j < state->coded_width; j++) {
-				*p++ = state->ref_frame.cr[k];
-				*p++ = state->ref_frame.luma[k];
-				*p++ = state->ref_frame.cb[k];
-				k++;
-			}
-			p_out += state->stride;
-		}
-		break;
-	case V4L2_PIX_FMT_BGR24:
-		k = 0;
-		for (i = 0; i < state->coded_height; i++) {
-			for (j = 0, p = p_out; j < state->coded_width; j++) {
-				*p++ = state->ref_frame.cb[k];
-				*p++ = state->ref_frame.luma[k];
-				*p++ = state->ref_frame.cr[k];
-				k++;
-			}
-			p_out += state->stride;
-		}
-		break;
-	case V4L2_PIX_FMT_RGB32:
-	case V4L2_PIX_FMT_XRGB32:
-	case V4L2_PIX_FMT_HSV32:
-		k = 0;
-		for (i = 0; i < state->coded_height; i++) {
-			for (j = 0, p = p_out; j < state->coded_width; j++) {
-				*p++ = 0;
-				*p++ = state->ref_frame.cr[k];
-				*p++ = state->ref_frame.luma[k];
-				*p++ = state->ref_frame.cb[k];
-				k++;
-			}
-			p_out += state->stride;
-		}
-		break;
-	case V4L2_PIX_FMT_BGR32:
-	case V4L2_PIX_FMT_XBGR32:
-		k = 0;
-		for (i = 0; i < state->coded_height; i++) {
-			for (j = 0, p = p_out; j < state->coded_width; j++) {
-				*p++ = state->ref_frame.cb[k];
-				*p++ = state->ref_frame.luma[k];
-				*p++ = state->ref_frame.cr[k];
-				*p++ = 0;
-				k++;
-			}
-			p_out += state->stride;
-		}
-		break;
-	case V4L2_PIX_FMT_ARGB32:
-		k = 0;
-		for (i = 0; i < state->coded_height; i++) {
-			for (j = 0, p = p_out; j < state->coded_width; j++) {
-				*p++ = state->ref_frame.alpha[k];
-				*p++ = state->ref_frame.cr[k];
-				*p++ = state->ref_frame.luma[k];
-				*p++ = state->ref_frame.cb[k];
-				k++;
-			}
-			p_out += state->stride;
-		}
-		break;
-	case V4L2_PIX_FMT_ABGR32:
-		k = 0;
-		for (i = 0; i < state->coded_height; i++) {
-			for (j = 0, p = p_out; j < state->coded_width; j++) {
-				*p++ = state->ref_frame.cb[k];
-				*p++ = state->ref_frame.luma[k];
-				*p++ = state->ref_frame.cr[k];
-				*p++ = state->ref_frame.alpha[k];
-				k++;
-			}
-			p_out += state->stride;
-		}
-		break;
-	default:
+	if (!fwht_decode_frame(&cf, flags, components_num,
+			state->visible_width, state->visible_height,
+			&state->ref_frame, state->ref_stride, ref_chroma_stride,
+			&dst_rf, state->stride, dst_chroma_stride))
 		return -EINVAL;
-	}
 	return 0;
 }
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.h b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
index aa6fa90a48be..53eba97ebc83 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.h
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
@@ -30,6 +30,7 @@ struct v4l2_fwht_state {
 	unsigned int coded_width;
 	unsigned int coded_height;
 	unsigned int stride;
+	unsigned int ref_stride;
 	unsigned int gop_size;
 	unsigned int gop_cnt;
 	u16 i_frame_qp;
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 42af0e922249..4b97ba30fec3 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -154,6 +154,43 @@ static struct vicodec_q_data *get_q_data(struct vicodec_ctx *ctx,
 	return NULL;
 }
 
+static void copy_cap_to_ref(const u8 *cap, const struct v4l2_fwht_pixfmt_info *info,
+		struct v4l2_fwht_state *state)
+{
+	int plane_idx;
+	u8 *p_ref = state->ref_frame.buf;
+	unsigned int cap_stride = state->stride;
+	unsigned int ref_stride = state->ref_stride;
+
+	for (plane_idx = 0; plane_idx < info->planes_num; plane_idx++) {
+		int i;
+		unsigned int h_div = (plane_idx == 1 || plane_idx == 2) ?
+			info->height_div : 1;
+		const u8 *row_cap = cap;
+		u8 *row_ref = p_ref;
+
+		if (info->planes_num == 3 && plane_idx == 1) {
+			cap_stride /= 2;
+			ref_stride /= 2;
+		}
+
+		if (plane_idx == 1 &&
+		    (info->id == V4L2_PIX_FMT_NV24 ||
+		     info->id == V4L2_PIX_FMT_NV42)) {
+			cap_stride *= 2;
+			ref_stride *= 2;
+		}
+
+		for (i = 0; i < state->visible_height / h_div; i++) {
+			memcpy(row_ref, row_cap, ref_stride);
+			row_ref += ref_stride;
+			row_cap += cap_stride;
+		}
+		cap += cap_stride * (state->coded_height / h_div);
+		p_ref += ref_stride * (state->coded_height / h_div);
+	}
+}
+
 static int device_process(struct vicodec_ctx *ctx,
 			  struct vb2_v4l2_buffer *src_vb,
 			  struct vb2_v4l2_buffer *dst_vb)
@@ -195,6 +232,8 @@ static int device_process(struct vicodec_ctx *ctx,
 		ret = v4l2_fwht_decode(state, p_src, p_dst);
 		if (ret < 0)
 			return ret;
+		copy_cap_to_ref(p_dst, ctx->state.info, &ctx->state);
+
 		vb2_set_plane_payload(&dst_vb->vb2_buf, 0, q_dst->sizeimage);
 	}
 	return 0;
@@ -1352,6 +1391,7 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	state->stride = q_data->coded_width *
 				info->bytesperline_mult;
 
+	state->ref_stride = q_data->coded_width * info->luma_alpha_step;
 	state->ref_frame.buf = kvmalloc(total_planes_size, GFP_KERNEL);
 	state->ref_frame.luma = state->ref_frame.buf;
 	ctx->comp_max_size = total_planes_size;
-- 
2.17.1

