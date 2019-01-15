Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2602CC43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 09:31:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C81682085A
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 09:31:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wh7SaU2r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbfAOJbP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 04:31:15 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41095 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfAOJbO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 04:31:14 -0500
Received: by mail-wr1-f65.google.com with SMTP id x10so2076121wrs.8
        for <linux-media@vger.kernel.org>; Tue, 15 Jan 2019 01:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=g+3LsIGOs27ub+raNALcDSOmiXbf6c9RXNbhthRrwAA=;
        b=Wh7SaU2rbLPPv5vHTRmdSfDW8zpmwU4kIk2n+m9dlXtpn6f9r+p6k0VT6edBS5zE3s
         fLvWEp6wlNbrwHmZ8KTS4qIPRoov70uC/XZV26bPRR+lL1nMObuhJRRFwZrrqI8Voef4
         PIYTxuqoiQlWeSFnJGTsVDvcoAYNI6TM8s9mgtYp0fj/N0+9eQLcFatKT9wxo6k349a6
         jb+M/f27CZvvtHvlpen76cgEEltN5mknNC7ceCU5ZNaL6us082wGV9WrTmAQqe+DyZeE
         Zumq7j7aNVE2KI5vZqmzhzvLqxrtkmT3NIUaY+4WA2rtwHV8bgTCtnVp5Q8Me8HYatDE
         cNRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=g+3LsIGOs27ub+raNALcDSOmiXbf6c9RXNbhthRrwAA=;
        b=JB32wcQzYCDH1Eu69nY+rwH5XaxE0xNAsEEtHCxdYQHQaD+rsuQzOAsfYSdxTCYTZ1
         xyjNVzlWlSXM9vLE95OA67SwI63WTqc7Y8aZKIszBJJUTGiJbodQ+Q2fhl/G7p/gb3Jy
         3aRwzjG50JnHeDmD8ypX3mRkVU+fhUeXQ55v/ddQeAHyUepgmsXuVFLM7AsACiBKAyLl
         0tXxH98LsJf1praRCWQcuDcC8Xv48q7/gGDFa9kk0LZZEioaGzTIDWnVlas3YPem5OtZ
         ioaBinO3Q/se57KlyXMJn8k24UO84namXDQSVnUSbyvAbP9Te22QgEXLEtPoqEK0fWne
         W2Lg==
X-Gm-Message-State: AJcUukfNXPfmaMLTggVrX9KcSox80c62y/UFxWuhHHriGK2M+RLwhtcF
        SxeBbKwhfqG1w664TCEScnfsvgW/3Uc=
X-Google-Smtp-Source: ALg8bN55pz7oEPPex4VPdHzMUVMjnMheaEihu82501KQR6WN1RgUH5qKPSMZ+HPg1dtkLCHL53pbIA==
X-Received: by 2002:adf:9ec8:: with SMTP id b8mr2366621wrf.164.1547544670242;
        Tue, 15 Jan 2019 01:31:10 -0800 (PST)
Received: from localhost.localdomain ([87.71.12.187])
        by smtp.gmail.com with ESMTPSA id m193sm32998098wmb.26.2019.01.15.01.31.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jan 2019 01:31:09 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH 3/4] media: vicodec: add support for CROP and COMPOSE selection
Date:   Tue, 15 Jan 2019 01:30:38 -0800
Message-Id: <20190115093039.70584-3-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190115093039.70584-1-dafna3@gmail.com>
References: <20190115093039.70584-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add support for the selection api for the crop and compose targets.
The driver rounds up the coded width and height such that
all planes dimensions are multiple of 8.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/codec-fwht.c   |  80 +++--
 drivers/media/platform/vicodec/codec-fwht.h   |  17 +-
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 290 ++++++++++++------
 .../media/platform/vicodec/codec-v4l2-fwht.h  |   7 +-
 drivers/media/platform/vicodec/vicodec-core.c | 150 +++++++--
 5 files changed, 382 insertions(+), 162 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
index a6fd0477633b..229d0478ce6c 100644
--- a/drivers/media/platform/vicodec/codec-fwht.c
+++ b/drivers/media/platform/vicodec/codec-fwht.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/string.h>
+#include <linux/kernel.h>
 #include "codec-fwht.h"
 
 /*
@@ -237,8 +238,6 @@ static void fwht(const u8 *block, s16 *output_block, unsigned int stride,
 	unsigned int i;
 
 	/* stage 1 */
-	stride *= input_step;
-
 	for (i = 0; i < 8; i++, tmp += stride, out += 8) {
 		switch (input_step) {
 		case 1:
@@ -562,7 +561,7 @@ static void fill_encoder_block(const u8 *input, s16 *dst,
 	for (i = 0; i < 8; i++) {
 		for (j = 0; j < 8; j++, input += input_step)
 			*dst++ = *input;
-		input += (stride - 8) * input_step;
+		input += stride - 8 * input_step;
 	}
 }
 
@@ -660,7 +659,7 @@ static void add_deltas(s16 *deltas, const u8 *ref, int stride)
 
 static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
 			struct fwht_cframe *cf, u32 height, u32 width,
-			unsigned int input_step,
+			u32 stride, unsigned int input_step,
 			bool is_intra, bool next_is_intra)
 {
 	u8 *input_start = input;
@@ -671,7 +670,11 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
 	unsigned int last_size = 0;
 	unsigned int i, j;
 
+	width = round_up(width, 8);
+	height = round_up(height, 8);
+
 	for (j = 0; j < height / 8; j++) {
+		input = input_start + j * 8 * stride;
 		for (i = 0; i < width / 8; i++) {
 			/* intra code, first frame is always intra coded. */
 			int blocktype = IBLOCK;
@@ -679,9 +682,9 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
 
 			if (!is_intra)
 				blocktype = decide_blocktype(input, refp,
-					deltablock, width, input_step);
+					deltablock, stride, input_step);
 			if (blocktype == IBLOCK) {
-				fwht(input, cf->coeffs, width, input_step, 1);
+				fwht(input, cf->coeffs, stride, input_step, 1);
 				quantize_intra(cf->coeffs, cf->de_coeffs,
 					       cf->i_frame_qp);
 			} else {
@@ -722,12 +725,12 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
 			}
 			last_size = size;
 		}
-		input += width * 7 * input_step;
 	}
 
 exit_loop:
 	if (encoding & FWHT_FRAME_UNENCODED) {
 		u8 *out = (u8 *)rlco_start;
+		u8 *p;
 
 		input = input_start;
 		/*
@@ -736,8 +739,11 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
 		 * by 0xfe. Since YUV is limited range such values
 		 * shouldn't appear anyway.
 		 */
-		for (i = 0; i < height * width; i++, input += input_step)
-			*out++ = (*input == 0xff) ? 0xfe : *input;
+		for (j = 0; j < height; j++) {
+			for (i = 0, p = input; i < width; i++, p += input_step)
+				*out++ = (*p == 0xff) ? 0xfe : *p;
+			input += stride;
+		}
 		*rlco = (__be16 *)out;
 		encoding &= ~FWHT_FRAME_PCODED;
 	}
@@ -747,30 +753,32 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
 u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 		      struct fwht_raw_frame *ref_frm,
 		      struct fwht_cframe *cf,
-		      bool is_intra, bool next_is_intra)
+		      bool is_intra, bool next_is_intra,
+		      unsigned int width, unsigned int height,
+		      unsigned int stride, unsigned int chroma_stride)
 {
-	unsigned int size = frm->height * frm->width;
+	unsigned int size = height * width;
 	__be16 *rlco = cf->rlc_data;
 	__be16 *rlco_max;
 	u32 encoding;
 
 	rlco_max = rlco + size / 2 - 256;
 	encoding = encode_plane(frm->luma, ref_frm->luma, &rlco, rlco_max, cf,
-				frm->height, frm->width,
+				height, width, stride,
 				frm->luma_alpha_step, is_intra, next_is_intra);
 	if (encoding & FWHT_FRAME_UNENCODED)
 		encoding |= FWHT_LUMA_UNENCODED;
 	encoding &= ~FWHT_FRAME_UNENCODED;
 
 	if (frm->components_num >= 3) {
-		u32 chroma_h = frm->height / frm->height_div;
-		u32 chroma_w = frm->width / frm->width_div;
+		u32 chroma_h = height / frm->height_div;
+		u32 chroma_w = width / frm->width_div;
 		unsigned int chroma_size = chroma_h * chroma_w;
 
 		rlco_max = rlco + chroma_size / 2 - 256;
 		encoding |= encode_plane(frm->cb, ref_frm->cb, &rlco, rlco_max,
 					 cf, chroma_h, chroma_w,
-					 frm->chroma_step,
+					 chroma_stride, frm->chroma_step,
 					 is_intra, next_is_intra);
 		if (encoding & FWHT_FRAME_UNENCODED)
 			encoding |= FWHT_CB_UNENCODED;
@@ -778,7 +786,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 		rlco_max = rlco + chroma_size / 2 - 256;
 		encoding |= encode_plane(frm->cr, ref_frm->cr, &rlco, rlco_max,
 					 cf, chroma_h, chroma_w,
-					 frm->chroma_step,
+					 chroma_stride, frm->chroma_step,
 					 is_intra, next_is_intra);
 		if (encoding & FWHT_FRAME_UNENCODED)
 			encoding |= FWHT_CR_UNENCODED;
@@ -788,8 +796,8 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 	if (frm->components_num == 4) {
 		rlco_max = rlco + size / 2 - 256;
 		encoding |= encode_plane(frm->alpha, ref_frm->alpha, &rlco,
-					 rlco_max, cf, frm->height, frm->width,
-					 frm->luma_alpha_step,
+					 rlco_max, cf, height, width,
+					 stride, frm->luma_alpha_step,
 					 is_intra, next_is_intra);
 		if (encoding & FWHT_FRAME_UNENCODED)
 			encoding |= FWHT_ALPHA_UNENCODED;
@@ -801,13 +809,16 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 }
 
 static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
-			 u32 height, u32 width, bool uncompressed)
+			 u32 height, u32 width, u32 coded_width, bool uncompressed)
 {
 	unsigned int copies = 0;
 	s16 copy[8 * 8];
 	s16 stat;
 	unsigned int i, j;
 
+	width = round_up(width, 8);
+	height = round_up(height, 8);
+
 	if (uncompressed) {
 		memcpy(ref, *rlco, width * height);
 		*rlco += width * height / 2;
@@ -822,13 +833,13 @@ static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
 	 */
 	for (j = 0; j < height / 8; j++) {
 		for (i = 0; i < width / 8; i++) {
-			u8 *refp = ref + j * 8 * width + i * 8;
+			u8 *refp = ref + j * 8 * coded_width + i * 8;
 
 			if (copies) {
 				memcpy(cf->de_fwht, copy, sizeof(copy));
 				if (stat & PFRAME_BIT)
-					add_deltas(cf->de_fwht, refp, width);
-				fill_decoder_block(refp, cf->de_fwht, width);
+					add_deltas(cf->de_fwht, refp, coded_width);
+				fill_decoder_block(refp, cf->de_fwht, coded_width);
 				copies--;
 				continue;
 			}
@@ -847,35 +858,40 @@ static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
 			if (copies)
 				memcpy(copy, cf->de_fwht, sizeof(copy));
 			if (stat & PFRAME_BIT)
-				add_deltas(cf->de_fwht, refp, width);
-			fill_decoder_block(refp, cf->de_fwht, width);
+				add_deltas(cf->de_fwht, refp, coded_width);
+			fill_decoder_block(refp, cf->de_fwht, coded_width);
 		}
 	}
 }
 
 void fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
-		       u32 hdr_flags, unsigned int components_num)
+		       u32 hdr_flags, unsigned int components_num,
+		       unsigned int width, unsigned int height,
+		       unsigned int coded_width)
 {
 	const __be16 *rlco = cf->rlc_data;
 
-	decode_plane(cf, &rlco, ref->luma, cf->height, cf->width,
+	decode_plane(cf, &rlco, ref->luma, height, width, coded_width,
 		     hdr_flags & FWHT_FL_LUMA_IS_UNCOMPRESSED);
 
 	if (components_num >= 3) {
-		u32 h = cf->height;
-		u32 w = cf->width;
+		u32 h = height;
+		u32 w = width;
+		u32 c = coded_width;
 
 		if (!(hdr_flags & FWHT_FL_CHROMA_FULL_HEIGHT))
 			h /= 2;
-		if (!(hdr_flags & FWHT_FL_CHROMA_FULL_WIDTH))
+		if (!(hdr_flags & FWHT_FL_CHROMA_FULL_WIDTH)) {
 			w /= 2;
-		decode_plane(cf, &rlco, ref->cb, h, w,
+			c /= 2;
+		}
+		decode_plane(cf, &rlco, ref->cb, h, w, c,
 			     hdr_flags & FWHT_FL_CB_IS_UNCOMPRESSED);
-		decode_plane(cf, &rlco, ref->cr, h, w,
+		decode_plane(cf, &rlco, ref->cr, h, w, c,
 			     hdr_flags & FWHT_FL_CR_IS_UNCOMPRESSED);
 	}
 
 	if (components_num == 4)
-		decode_plane(cf, &rlco, ref->alpha, cf->height, cf->width,
+		decode_plane(cf, &rlco, ref->alpha, height, width, coded_width,
 			     hdr_flags & FWHT_FL_ALPHA_IS_UNCOMPRESSED);
 }
diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
index 90ff8962fca7..6d230f5e9d60 100644
--- a/drivers/media/platform/vicodec/codec-fwht.h
+++ b/drivers/media/platform/vicodec/codec-fwht.h
@@ -81,6 +81,13 @@
 #define FWHT_FL_COMPONENTS_NUM_MSK	GENMASK(17, 16)
 #define FWHT_FL_COMPONENTS_NUM_OFFSET	16
 
+/*
+ * A macro to calculate the needed padding in order to make sure
+ * both luma and chroma components resolutions are rounded up to
+ * a multiple of 8
+ */
+#define vic_round_dim(dim, div) (round_up((dim) / (div), 8) * (div))
+
 struct fwht_cframe_hdr {
 	u32 magic1;
 	u32 magic2;
@@ -95,7 +102,6 @@ struct fwht_cframe_hdr {
 };
 
 struct fwht_cframe {
-	unsigned int width, height;
 	u16 i_frame_qp;
 	u16 p_frame_qp;
 	__be16 *rlc_data;
@@ -106,7 +112,6 @@ struct fwht_cframe {
 };
 
 struct fwht_raw_frame {
-	unsigned int width, height;
 	unsigned int width_div;
 	unsigned int height_div;
 	unsigned int luma_alpha_step;
@@ -125,8 +130,12 @@ struct fwht_raw_frame {
 u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 		      struct fwht_raw_frame *ref_frm,
 		      struct fwht_cframe *cf,
-		      bool is_intra, bool next_is_intra);
+		      bool is_intra, bool next_is_intra,
+		      unsigned int width, unsigned int height,
+		      unsigned int stride, unsigned int chroma_stride);
 void fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
-		       u32 hdr_flags, unsigned int components_num);
+		       u32 hdr_flags, unsigned int components_num,
+		       unsigned int width, unsigned int height,
+		       unsigned int coded_width);
 
 #endif
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index 5e9040f6c902..143af8c587b3 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -56,7 +56,8 @@ const struct v4l2_fwht_pixfmt_info *v4l2_fwht_get_pixfmt(u32 idx)
 
 int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 {
-	unsigned int size = state->width * state->height;
+	unsigned int size = state->stride * state->coded_height;
+	unsigned int chroma_stride = state->stride;
 	const struct v4l2_fwht_pixfmt_info *info = state->info;
 	struct fwht_cframe_hdr *p_hdr;
 	struct fwht_cframe cf;
@@ -66,8 +67,7 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 
 	if (!info)
 		return -EINVAL;
-	rf.width = state->width;
-	rf.height = state->height;
+
 	rf.luma = p_in;
 	rf.width_div = info->width_div;
 	rf.height_div = info->height_div;
@@ -84,14 +84,17 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	case V4L2_PIX_FMT_YUV420:
 		rf.cb = rf.luma + size;
 		rf.cr = rf.cb + size / 4;
+		chroma_stride /= 2;
 		break;
 	case V4L2_PIX_FMT_YVU420:
 		rf.cr = rf.luma + size;
 		rf.cb = rf.cr + size / 4;
+		chroma_stride /= 2;
 		break;
 	case V4L2_PIX_FMT_YUV422P:
 		rf.cb = rf.luma + size;
 		rf.cr = rf.cb + size / 2;
+		chroma_stride /= 2;
 		break;
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV16:
@@ -163,15 +166,15 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 		return -EINVAL;
 	}
 
-	cf.width = state->width;
-	cf.height = state->height;
 	cf.i_frame_qp = state->i_frame_qp;
 	cf.p_frame_qp = state->p_frame_qp;
 	cf.rlc_data = (__be16 *)(p_out + sizeof(*p_hdr));
 
 	encoding = fwht_encode_frame(&rf, &state->ref_frame, &cf,
 				     !state->gop_cnt,
-				     state->gop_cnt == state->gop_size - 1);
+				     state->gop_cnt == state->gop_size - 1,
+				     state->visible_width, state->visible_height,
+				     state->stride, chroma_stride);
 	if (!(encoding & FWHT_FRAME_PCODED))
 		state->gop_cnt = 0;
 	if (++state->gop_cnt >= state->gop_size)
@@ -181,8 +184,8 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	p_hdr->magic1 = FWHT_MAGIC1;
 	p_hdr->magic2 = FWHT_MAGIC2;
 	p_hdr->version = htonl(FWHT_VERSION);
-	p_hdr->width = htonl(cf.width);
-	p_hdr->height = htonl(cf.height);
+	p_hdr->width = htonl(state->visible_width);
+	p_hdr->height = htonl(state->visible_height);
 	flags |= (info->components_num - 1) << FWHT_FL_COMPONENTS_NUM_OFFSET;
 	if (encoding & FWHT_LUMA_UNENCODED)
 		flags |= FWHT_FL_LUMA_IS_UNCOMPRESSED;
@@ -202,29 +205,26 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	p_hdr->ycbcr_enc = htonl(state->ycbcr_enc);
 	p_hdr->quantization = htonl(state->quantization);
 	p_hdr->size = htonl(cf.size);
-	state->ref_frame.width = cf.width;
-	state->ref_frame.height = cf.height;
 	return cf.size + sizeof(*p_hdr);
 }
 
 int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 {
-	unsigned int size = state->width * state->height;
-	unsigned int chroma_size = size;
-	unsigned int i;
+	unsigned int i, j, k;
 	u32 flags;
 	struct fwht_cframe_hdr *p_hdr;
 	struct fwht_cframe cf;
-	u8 *p;
+	u8 *p, *ref_p;
 	unsigned int components_num = 3;
 	unsigned int version;
+	const struct v4l2_fwht_pixfmt_info *info;
+	unsigned int hdr_width_div, hdr_height_div;
 
 	if (!state->info)
 		return -EINVAL;
 
+	info = state->info;
 	p_hdr = (struct fwht_cframe_hdr *)p_in;
-	cf.width = ntohl(p_hdr->width);
-	cf.height = ntohl(p_hdr->height);
 
 	version = ntohl(p_hdr->version);
 	if (!version || version > FWHT_VERSION) {
@@ -234,12 +234,12 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	}
 
 	if (p_hdr->magic1 != FWHT_MAGIC1 ||
-	    p_hdr->magic2 != FWHT_MAGIC2 ||
-	    (cf.width & 7) || (cf.height & 7))
+	    p_hdr->magic2 != FWHT_MAGIC2)
 		return -EINVAL;
 
 	/* TODO: support resolution changes */
-	if (cf.width != state->width || cf.height != state->height)
+	if (ntohl(p_hdr->width)  != state->visible_width ||
+	    ntohl(p_hdr->height) != state->visible_height)
 		return -EINVAL;
 
 	flags = ntohl(p_hdr->flags);
@@ -255,12 +255,13 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	state->quantization = ntohl(p_hdr->quantization);
 	cf.rlc_data = (__be16 *)(p_in + sizeof(*p_hdr));
 
-	if (!(flags & FWHT_FL_CHROMA_FULL_WIDTH))
-		chroma_size /= 2;
-	if (!(flags & FWHT_FL_CHROMA_FULL_HEIGHT))
-		chroma_size /= 2;
+	hdr_width_div = (flags & FWHT_FL_CHROMA_FULL_WIDTH) ? 1 : 2;
+	hdr_height_div = (flags & FWHT_FL_CHROMA_FULL_HEIGHT) ? 1 : 2;
+	if (hdr_width_div != info->width_div || hdr_height_div != info->height_div)
+		return -EINVAL;
 
-	fwht_decode_frame(&cf, &state->ref_frame, flags, components_num);
+	fwht_decode_frame(&cf, &state->ref_frame, flags, components_num,
+			  state->visible_width, state->visible_height, state->coded_width);
 
 	/*
 	 * TODO - handle the case where the compressed stream encodes a
@@ -268,123 +269,226 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	 */
 	switch (state->info->id) {
 	case V4L2_PIX_FMT_GREY:
-		memcpy(p_out, state->ref_frame.luma, size);
+		ref_p = state->ref_frame.luma;
+		for (i = 0; i < state->coded_height; i++)  {
+			memcpy(p_out, ref_p, state->visible_width);
+			p_out += state->stride;
+			ref_p += state->coded_width;
+		}
 		break;
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YUV422P:
-		memcpy(p_out, state->ref_frame.luma, size);
-		p_out += size;
-		memcpy(p_out, state->ref_frame.cb, chroma_size);
-		p_out += chroma_size;
-		memcpy(p_out, state->ref_frame.cr, chroma_size);
+		ref_p = state->ref_frame.luma;
+		for (i = 0; i < state->coded_height; i++)  {
+			memcpy(p_out, ref_p, state->visible_width);
+			p_out += state->stride;
+			ref_p += state->coded_width;
+		}
+
+		ref_p = state->ref_frame.cb;
+		for (i = 0; i < state->coded_height / 2; i++)  {
+			memcpy(p_out, ref_p, state->visible_width / 2);
+			p_out += state->stride / 2;
+			ref_p += state->coded_width / 2;
+		}
+		ref_p = state->ref_frame.cr;
+		for (i = 0; i < state->coded_height / 2; i++)  {
+			memcpy(p_out, ref_p, state->visible_width / 2);
+			p_out += state->stride / 2;
+			ref_p += state->coded_width / 2;
+		}
 		break;
 	case V4L2_PIX_FMT_YVU420:
-		memcpy(p_out, state->ref_frame.luma, size);
-		p_out += size;
-		memcpy(p_out, state->ref_frame.cr, chroma_size);
-		p_out += chroma_size;
-		memcpy(p_out, state->ref_frame.cb, chroma_size);
+		ref_p = state->ref_frame.luma;
+		for (i = 0; i < state->coded_height; i++)  {
+			memcpy(p_out, ref_p, state->visible_width);
+			p_out += state->stride;
+			ref_p += state->coded_width;
+		}
+
+		ref_p = state->ref_frame.cr;
+		for (i = 0; i < state->coded_height / 2; i++)  {
+			memcpy(p_out, ref_p, state->visible_width / 2);
+			p_out += state->stride / 2;
+			ref_p += state->coded_width / 2;
+		}
+		ref_p = state->ref_frame.cb;
+		for (i = 0; i < state->coded_height / 2; i++)  {
+			memcpy(p_out, ref_p, state->visible_width / 2);
+			p_out += state->stride / 2;
+			ref_p += state->coded_width / 2;
+		}
 		break;
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV16:
 	case V4L2_PIX_FMT_NV24:
-		memcpy(p_out, state->ref_frame.luma, size);
-		p_out += size;
-		for (i = 0, p = p_out; i < chroma_size; i++) {
-			*p++ = state->ref_frame.cb[i];
-			*p++ = state->ref_frame.cr[i];
+		ref_p = state->ref_frame.luma;
+		for (i = 0; i < state->coded_height; i++)  {
+			memcpy(p_out, ref_p, state->visible_width);
+			p_out += state->stride;
+			ref_p += state->coded_width;
+		}
+
+		k = 0;
+		for (i = 0; i < state->coded_height / 2; i++) {
+			for (j = 0, p = p_out; j < state->coded_width / 2; j++) {
+				*p++ = state->ref_frame.cb[k];
+				*p++ = state->ref_frame.cr[k];
+				k++;
+			}
+			p_out += state->stride;
 		}
 		break;
 	case V4L2_PIX_FMT_NV21:
 	case V4L2_PIX_FMT_NV61:
 	case V4L2_PIX_FMT_NV42:
-		memcpy(p_out, state->ref_frame.luma, size);
-		p_out += size;
-		for (i = 0, p = p_out; i < chroma_size; i++) {
-			*p++ = state->ref_frame.cr[i];
-			*p++ = state->ref_frame.cb[i];
+		ref_p = state->ref_frame.luma;
+		for (i = 0; i < state->coded_height; i++)  {
+			memcpy(p_out, ref_p, state->visible_width);
+			p_out += state->stride;
+			ref_p += state->coded_width;
+		}
+
+		k = 0;
+		for (i = 0; i < state->coded_height / 2; i++) {
+			for (j = 0, p = p_out; j < state->coded_width / 2; j++) {
+				*p++ = state->ref_frame.cr[k];
+				*p++ = state->ref_frame.cb[k];
+				k++;
+			}
+			p_out += state->stride;
 		}
 		break;
 	case V4L2_PIX_FMT_YUYV:
-		for (i = 0, p = p_out; i < size; i += 2) {
-			*p++ = state->ref_frame.luma[i];
-			*p++ = state->ref_frame.cb[i / 2];
-			*p++ = state->ref_frame.luma[i + 1];
-			*p++ = state->ref_frame.cr[i / 2];
+		k = 0;
+		for (i = 0; i < state->coded_height; i++) {
+			for (j = 0, p = p_out; j < state->coded_width / 2; j++) {
+				*p++ = state->ref_frame.luma[k];
+				*p++ = state->ref_frame.cb[k / 2];
+				*p++ = state->ref_frame.luma[k + 1];
+				*p++ = state->ref_frame.cr[k / 2];
+				k += 2;
+			}
+			p_out += state->stride;
 		}
 		break;
 	case V4L2_PIX_FMT_YVYU:
-		for (i = 0, p = p_out; i < size; i += 2) {
-			*p++ = state->ref_frame.luma[i];
-			*p++ = state->ref_frame.cr[i / 2];
-			*p++ = state->ref_frame.luma[i + 1];
-			*p++ = state->ref_frame.cb[i / 2];
+		k = 0;
+		for (i = 0; i < state->coded_height; i++) {
+			for (j = 0, p = p_out; j < state->coded_width / 2; j++) {
+				*p++ = state->ref_frame.luma[k];
+				*p++ = state->ref_frame.cr[k / 2];
+				*p++ = state->ref_frame.luma[k + 1];
+				*p++ = state->ref_frame.cb[k / 2];
+				k += 2;
+			}
+			p_out += state->stride;
 		}
 		break;
 	case V4L2_PIX_FMT_UYVY:
-		for (i = 0, p = p_out; i < size; i += 2) {
-			*p++ = state->ref_frame.cb[i / 2];
-			*p++ = state->ref_frame.luma[i];
-			*p++ = state->ref_frame.cr[i / 2];
-			*p++ = state->ref_frame.luma[i + 1];
+		k = 0;
+		for (i = 0; i < state->coded_height; i++) {
+			for (j = 0, p = p_out; j < state->coded_width / 2; j++) {
+				*p++ = state->ref_frame.cb[k / 2];
+				*p++ = state->ref_frame.luma[k];
+				*p++ = state->ref_frame.cr[k / 2];
+				*p++ = state->ref_frame.luma[k + 1];
+				k += 2;
+			}
+			p_out += state->stride;
 		}
 		break;
 	case V4L2_PIX_FMT_VYUY:
-		for (i = 0, p = p_out; i < size; i += 2) {
-			*p++ = state->ref_frame.cr[i / 2];
-			*p++ = state->ref_frame.luma[i];
-			*p++ = state->ref_frame.cb[i / 2];
-			*p++ = state->ref_frame.luma[i + 1];
+		k = 0;
+		for (i = 0; i < state->coded_height; i++) {
+			for (j = 0, p = p_out; j < state->coded_width / 2; j++) {
+				*p++ = state->ref_frame.cr[k / 2];
+				*p++ = state->ref_frame.luma[k];
+				*p++ = state->ref_frame.cb[k / 2];
+				*p++ = state->ref_frame.luma[k + 1];
+				k += 2;
+			}
+			p_out += state->stride;
 		}
 		break;
 	case V4L2_PIX_FMT_RGB24:
 	case V4L2_PIX_FMT_HSV24:
-		for (i = 0, p = p_out; i < size; i++) {
-			*p++ = state->ref_frame.cr[i];
-			*p++ = state->ref_frame.luma[i];
-			*p++ = state->ref_frame.cb[i];
+		k = 0;
+		for (i = 0; i < state->coded_height; i++) {
+			for (j = 0, p = p_out; j < state->coded_width; j++) {
+				*p++ = state->ref_frame.cr[k];
+				*p++ = state->ref_frame.luma[k];
+				*p++ = state->ref_frame.cb[k];
+				k++;
+			}
+			p_out += state->stride;
 		}
 		break;
 	case V4L2_PIX_FMT_BGR24:
-		for (i = 0, p = p_out; i < size; i++) {
-			*p++ = state->ref_frame.cb[i];
-			*p++ = state->ref_frame.luma[i];
-			*p++ = state->ref_frame.cr[i];
+		k = 0;
+		for (i = 0; i < state->coded_height; i++) {
+			for (j = 0, p = p_out; j < state->coded_width; j++) {
+				*p++ = state->ref_frame.cb[k];
+				*p++ = state->ref_frame.luma[k];
+				*p++ = state->ref_frame.cr[k];
+				k++;
+			}
+			p_out += state->stride;
 		}
 		break;
 	case V4L2_PIX_FMT_RGB32:
 	case V4L2_PIX_FMT_XRGB32:
 	case V4L2_PIX_FMT_HSV32:
-		for (i = 0, p = p_out; i < size; i++) {
-			*p++ = 0;
-			*p++ = state->ref_frame.cr[i];
-			*p++ = state->ref_frame.luma[i];
-			*p++ = state->ref_frame.cb[i];
+		k = 0;
+		for (i = 0; i < state->coded_height; i++) {
+			for (j = 0, p = p_out; j < state->coded_width; j++) {
+				*p++ = 0;
+				*p++ = state->ref_frame.cr[k];
+				*p++ = state->ref_frame.luma[k];
+				*p++ = state->ref_frame.cb[k];
+				k++;
+			}
+			p_out += state->stride;
 		}
 		break;
 	case V4L2_PIX_FMT_BGR32:
 	case V4L2_PIX_FMT_XBGR32:
-		for (i = 0, p = p_out; i < size; i++) {
-			*p++ = state->ref_frame.cb[i];
-			*p++ = state->ref_frame.luma[i];
-			*p++ = state->ref_frame.cr[i];
-			*p++ = 0;
+		k = 0;
+		for (i = 0; i < state->coded_height; i++) {
+			for (j = 0, p = p_out; j < state->coded_width; j++) {
+				*p++ = state->ref_frame.cb[k];
+				*p++ = state->ref_frame.luma[k];
+				*p++ = state->ref_frame.cr[k];
+				*p++ = 0;
+				k++;
+			}
+			p_out += state->stride;
 		}
 		break;
 	case V4L2_PIX_FMT_ARGB32:
-		for (i = 0, p = p_out; i < size; i++) {
-			*p++ = state->ref_frame.alpha[i];
-			*p++ = state->ref_frame.cr[i];
-			*p++ = state->ref_frame.luma[i];
-			*p++ = state->ref_frame.cb[i];
+		k = 0;
+		for (i = 0; i < state->coded_height; i++) {
+			for (j = 0, p = p_out; j < state->coded_width; j++) {
+				*p++ = state->ref_frame.alpha[k];
+				*p++ = state->ref_frame.cr[k];
+				*p++ = state->ref_frame.luma[k];
+				*p++ = state->ref_frame.cb[k];
+				k++;
+			}
+			p_out += state->stride;
 		}
 		break;
 	case V4L2_PIX_FMT_ABGR32:
-		for (i = 0, p = p_out; i < size; i++) {
-			*p++ = state->ref_frame.cb[i];
-			*p++ = state->ref_frame.luma[i];
-			*p++ = state->ref_frame.cr[i];
-			*p++ = state->ref_frame.alpha[i];
+		k = 0;
+		for (i = 0; i < state->coded_height; i++) {
+			for (j = 0, p = p_out; j < state->coded_width; j++) {
+				*p++ = state->ref_frame.cb[k];
+				*p++ = state->ref_frame.luma[k];
+				*p++ = state->ref_frame.cr[k];
+				*p++ = state->ref_frame.alpha[k];
+				k++;
+			}
+			p_out += state->stride;
 		}
 		break;
 	default:
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.h b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
index 685b665590c1..203c45d98905 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.h
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
@@ -24,8 +24,11 @@ struct v4l2_fwht_pixfmt_info {
 
 struct v4l2_fwht_state {
 	const struct v4l2_fwht_pixfmt_info *info;
-	unsigned int width;
-	unsigned int height;
+	unsigned int visible_width;
+	unsigned int visible_height;
+	unsigned int coded_width;
+	unsigned int coded_height;
+	unsigned int stride;
 	unsigned int gop_size;
 	unsigned int gop_cnt;
 	u16 i_frame_qp;
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 6a7643bceb92..51053d5d630a 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -75,8 +75,10 @@ static struct platform_device vicodec_pdev = {
 
 /* Per-queue, driver-specific private data */
 struct vicodec_q_data {
-	unsigned int		width;
-	unsigned int		height;
+	unsigned int		coded_width;
+	unsigned int		coded_height;
+	unsigned int		visible_width;
+	unsigned int		visible_height;
 	unsigned int		sizeimage;
 	unsigned int		sequence;
 	const struct v4l2_fwht_pixfmt_info *info;
@@ -454,11 +456,11 @@ static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		if (multiplanar)
 			return -EINVAL;
 		pix = &f->fmt.pix;
-		pix->width = q_data->width;
-		pix->height = q_data->height;
+		pix->width = q_data->coded_width;
+		pix->height = q_data->coded_height;
 		pix->field = V4L2_FIELD_NONE;
 		pix->pixelformat = info->id;
-		pix->bytesperline = q_data->width * info->bytesperline_mult;
+		pix->bytesperline = q_data->coded_width * info->bytesperline_mult;
 		pix->sizeimage = q_data->sizeimage;
 		pix->colorspace = ctx->state.colorspace;
 		pix->xfer_func = ctx->state.xfer_func;
@@ -471,13 +473,13 @@ static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		if (!multiplanar)
 			return -EINVAL;
 		pix_mp = &f->fmt.pix_mp;
-		pix_mp->width = q_data->width;
-		pix_mp->height = q_data->height;
+		pix_mp->width = q_data->coded_width;
+		pix_mp->height = q_data->coded_height;
 		pix_mp->field = V4L2_FIELD_NONE;
 		pix_mp->pixelformat = info->id;
 		pix_mp->num_planes = 1;
 		pix_mp->plane_fmt[0].bytesperline =
-				q_data->width * info->bytesperline_mult;
+				q_data->coded_width * info->bytesperline_mult;
 		pix_mp->plane_fmt[0].sizeimage = q_data->sizeimage;
 		pix_mp->colorspace = ctx->state.colorspace;
 		pix_mp->xfer_func = ctx->state.xfer_func;
@@ -518,8 +520,8 @@ static int vidioc_try_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		pix = &f->fmt.pix;
 		if (pix->pixelformat != V4L2_PIX_FMT_FWHT)
 			info = find_fmt(pix->pixelformat);
-		pix->width = clamp(pix->width, MIN_WIDTH, MAX_WIDTH) & ~7;
-		pix->height = clamp(pix->height, MIN_HEIGHT, MAX_HEIGHT) & ~7;
+		pix->width = vic_round_dim(clamp(pix->width, MIN_WIDTH, MAX_WIDTH), info->width_div);
+		pix->height = vic_round_dim(clamp(pix->height, MIN_HEIGHT, MAX_HEIGHT), info->height_div);
 		pix->field = V4L2_FIELD_NONE;
 		pix->bytesperline =
 			pix->width * info->bytesperline_mult;
@@ -535,9 +537,8 @@ static int vidioc_try_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		if (pix_mp->pixelformat != V4L2_PIX_FMT_FWHT)
 			info = find_fmt(pix_mp->pixelformat);
 		pix_mp->num_planes = 1;
-		pix_mp->width = clamp(pix_mp->width, MIN_WIDTH, MAX_WIDTH) & ~7;
-		pix_mp->height =
-			clamp(pix_mp->height, MIN_HEIGHT, MAX_HEIGHT) & ~7;
+		pix_mp->width = vic_round_dim(clamp(pix_mp->width, MIN_WIDTH, MAX_WIDTH), info->width_div);
+		pix_mp->height = vic_round_dim(clamp(pix->height, MIN_HEIGHT, MAX_HEIGHT), info->height_div);
 		pix_mp->field = V4L2_FIELD_NONE;
 		plane->bytesperline =
 			pix_mp->width * info->bytesperline_mult;
@@ -648,8 +649,8 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		if (ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type))
 			fmt_changed =
 				q_data->info->id != pix->pixelformat ||
-				q_data->width != pix->width ||
-				q_data->height != pix->height;
+				q_data->coded_width != pix->width ||
+				q_data->coded_height != pix->height;
 
 		if (vb2_is_busy(vq) && fmt_changed)
 			return -EBUSY;
@@ -658,8 +659,8 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 			q_data->info = &pixfmt_fwht;
 		else
 			q_data->info = find_fmt(pix->pixelformat);
-		q_data->width = pix->width;
-		q_data->height = pix->height;
+		q_data->coded_width = pix->width;
+		q_data->coded_height = pix->height;
 		q_data->sizeimage = pix->sizeimage;
 		break;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
@@ -668,8 +669,8 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		if (ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type))
 			fmt_changed =
 				q_data->info->id != pix_mp->pixelformat ||
-				q_data->width != pix_mp->width ||
-				q_data->height != pix_mp->height;
+				q_data->coded_width != pix_mp->width ||
+				q_data->coded_height != pix_mp->height;
 
 		if (vb2_is_busy(vq) && fmt_changed)
 			return -EBUSY;
@@ -678,17 +679,24 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 			q_data->info = &pixfmt_fwht;
 		else
 			q_data->info = find_fmt(pix_mp->pixelformat);
-		q_data->width = pix_mp->width;
-		q_data->height = pix_mp->height;
+		q_data->coded_width = pix_mp->width;
+		q_data->coded_height = pix_mp->height;
 		q_data->sizeimage = pix_mp->plane_fmt[0].sizeimage;
 		break;
 	default:
 		return -EINVAL;
 	}
+	if (q_data->visible_width > q_data->coded_width)
+		q_data->visible_width = q_data->coded_width;
+	if (q_data->visible_height > q_data->coded_height)
+		q_data->visible_height = q_data->coded_height;
+
 
 	dprintk(ctx->dev,
-		"Setting format for type %d, wxh: %dx%d, fourcc: %08x\n",
-		f->type, q_data->width, q_data->height, q_data->info->id);
+		"Setting format for type %d, coded wxh: %dx%d, visible wxh: %dx%d, fourcc: %08x\n",
+		f->type, q_data->coded_width, q_data->coded_height,
+		q_data->visible_width, q_data->visible_height,
+		q_data->info->id);
 
 	return 0;
 }
@@ -743,6 +751,76 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
 	return ret;
 }
 
+static int vidioc_g_selection(struct file *file, void *priv,
+			      struct v4l2_selection *s)
+{
+	struct vicodec_ctx *ctx = file2ctx(file);
+	struct vicodec_q_data *q_data;
+	enum v4l2_buf_type valid_cap_type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	enum v4l2_buf_type valid_out_type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+
+	if (multiplanar) {
+		valid_cap_type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+		valid_out_type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	}
+
+	q_data = get_q_data(ctx, s->type);
+	if (!q_data)
+		return -EINVAL;
+	/*
+	 * encoder supports only cropping on the OUTPUT buffer
+	 * decoder supports only composing on the CAPTURE buffer
+	 */
+	if ((ctx->is_enc && s->type == valid_out_type) ||
+	    (!ctx->is_enc && s->type == valid_cap_type)) {
+		switch (s->target) {
+		case V4L2_SEL_TGT_COMPOSE:
+		case V4L2_SEL_TGT_CROP:
+			s->r.left = 0;
+			s->r.top = 0;
+			s->r.width = q_data->visible_width;
+			s->r.height = q_data->visible_height;
+			return 0;
+		case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+		case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+		case V4L2_SEL_TGT_CROP_DEFAULT:
+		case V4L2_SEL_TGT_CROP_BOUNDS:
+			s->r.left = 0;
+			s->r.top = 0;
+			s->r.width = q_data->coded_width;
+			s->r.height = q_data->coded_height;
+			return 0;
+		}
+	}
+	return -EINVAL;
+}
+
+static int vidioc_s_selection(struct file *file, void *priv,
+			      struct v4l2_selection *s)
+{
+	struct vicodec_ctx *ctx = file2ctx(file);
+	struct vicodec_q_data *q_data;
+	enum v4l2_buf_type out_type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+
+	if (multiplanar)
+		out_type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+
+	q_data = get_q_data(ctx, s->type);
+	if (!q_data)
+		return -EINVAL;
+
+	if (!ctx->is_enc || s->type != out_type || s->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
+
+	s->r.left = 0;
+	s->r.top = 0;
+	q_data->visible_width = clamp(s->r.width, MIN_WIDTH, q_data->coded_width);
+	s->r.width = q_data->visible_width;
+	q_data->visible_height = clamp(s->r.height, MIN_HEIGHT, q_data->coded_height);
+	s->r.height = q_data->visible_height;
+	return 0;
+}
+
 static void vicodec_mark_last_buf(struct vicodec_ctx *ctx)
 {
 	static const struct v4l2_event eos_event = {
@@ -885,6 +963,9 @@ static const struct v4l2_ioctl_ops vicodec_ioctl_ops = {
 	.vidioc_streamon	= v4l2_m2m_ioctl_streamon,
 	.vidioc_streamoff	= v4l2_m2m_ioctl_streamoff,
 
+	.vidioc_g_selection	= vidioc_g_selection,
+	.vidioc_s_selection	= vidioc_s_selection,
+
 	.vidioc_try_encoder_cmd	= vicodec_try_encoder_cmd,
 	.vidioc_encoder_cmd	= vicodec_encoder_cmd,
 	.vidioc_try_decoder_cmd	= vicodec_try_decoder_cmd,
@@ -978,8 +1059,8 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	struct vicodec_ctx *ctx = vb2_get_drv_priv(q);
 	struct vicodec_q_data *q_data = get_q_data(ctx, q->type);
 	struct v4l2_fwht_state *state = &ctx->state;
-	unsigned int size = q_data->width * q_data->height;
 	const struct v4l2_fwht_pixfmt_info *info = q_data->info;
+	unsigned int size = q_data->coded_width * q_data->coded_height;
 	unsigned int chroma_div = info->width_div * info->height_div;
 	unsigned int total_planes_size;
 
@@ -998,17 +1079,22 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 
 	if (!V4L2_TYPE_IS_OUTPUT(q->type)) {
 		if (!ctx->is_enc) {
-			state->width = q_data->width;
-			state->height = q_data->height;
+			state->visible_width = q_data->visible_width;
+			state->visible_height = q_data->visible_height;
+			state->coded_width = q_data->coded_width;
+			state->coded_height = q_data->coded_height;
+			state->stride = q_data->coded_width * info->bytesperline_mult;
 		}
 		return 0;
 	}
 
 	if (ctx->is_enc) {
-		state->width = q_data->width;
-		state->height = q_data->height;
+		state->visible_width = q_data->visible_width;
+		state->visible_height = q_data->visible_height;
+		state->coded_width = q_data->coded_width;
+		state->coded_height = q_data->coded_height;
+		state->stride = q_data->coded_width * info->bytesperline_mult;
 	}
-	state->ref_frame.width = state->ref_frame.height = 0;
 	state->ref_frame.luma = kvmalloc(total_planes_size, GFP_KERNEL);
 	ctx->comp_max_size = total_planes_size + sizeof(struct fwht_cframe_hdr);
 	state->compressed_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
@@ -1194,8 +1280,10 @@ static int vicodec_open(struct file *file)
 
 	ctx->q_data[V4L2_M2M_SRC].info =
 		ctx->is_enc ? v4l2_fwht_get_pixfmt(0) : &pixfmt_fwht;
-	ctx->q_data[V4L2_M2M_SRC].width = 1280;
-	ctx->q_data[V4L2_M2M_SRC].height = 720;
+	ctx->q_data[V4L2_M2M_SRC].coded_width = 1280;
+	ctx->q_data[V4L2_M2M_SRC].coded_height = 720;
+	ctx->q_data[V4L2_M2M_SRC].visible_width = 1280;
+	ctx->q_data[V4L2_M2M_SRC].visible_height = 720;
 	size = 1280 * 720 * ctx->q_data[V4L2_M2M_SRC].info->sizeimage_mult /
 		ctx->q_data[V4L2_M2M_SRC].info->sizeimage_div;
 	if (ctx->is_enc)
-- 
2.17.1

