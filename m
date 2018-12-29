Return-Path: <SRS0=xT8T=PG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E3DC43387
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 15:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2EF32087F
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 15:21:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DDlVzhBt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbeL2PVE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 29 Dec 2018 10:21:04 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38629 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbeL2PVE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Dec 2018 10:21:04 -0500
Received: by mail-wr1-f66.google.com with SMTP id v13so23269460wrw.5
        for <linux-media@vger.kernel.org>; Sat, 29 Dec 2018 07:21:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uqRj6yDTiabbdjWzX4u8okzG4WND5wKPYHLyJrdI9Pk=;
        b=DDlVzhBtWJCvr7kzoRjG94EnBjG++5uE2IjpKZakTtv/38FbAeH1V9rcSHbbgZ1psW
         Amjo97YOkzRBtbdsRZLpuzsTrHuSoPF1X67rL+v22RlEkIYStgv1GDndg9b/IHTN65By
         s4cQiqBf9ZbpC1UxuK/CiW9zUaxPwYx4TtF45lru1yMUogyFWe74gVmP7q1uussUIlBL
         W/AW3xQGgm55aS1jao6kokBpZqZeJ/KvTgp0RACCzVTg78rfWQ/GvxElJL8M/n5UHR+Y
         pkvEFdBm3wx4SgN2yxho9Q5l5IMWqwC4k87EU9rmSvve9fTS1uydz9fcU2kwTRp37EQP
         48OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uqRj6yDTiabbdjWzX4u8okzG4WND5wKPYHLyJrdI9Pk=;
        b=nceKnqCcceCLR7NI0bnxycDV5WBwaVtFQO3Am0FVCNLO5JbOYMBhgNp+2XgUAyFYNT
         wk5EZm8bYjrTidw9Y4JYHk2m5Nt00p+bK/Ik36GeuwZOXnZSoOp807ASahwRauPXpADI
         MjmvBXiDGLGlyWGC5okpg49AsWUDW7XdGdzx3o1cn4GBkwDiY9KnkoEehgNhV3JjpgAP
         MLKDghJfD5untPCw4311VVQ8ein0YrEtGogRGEm1LvZiSeVs7s0mQmGTFrwa0fgmIdOv
         cqLkDl9PbpMgsLUczI2sv/dB000Ex4ib08NbU/myyTKlQ0QhUw5Qgq04nCAWN3iXWSyS
         6ulw==
X-Gm-Message-State: AJcUukfMmKH8BNnKk5aRNDzHIliHUu5F2wykzObWVwXwTp7e7fYMAYEd
        yMr1ieD5R9n4gqzEfUqFU+pTpUPzc3Y=
X-Google-Smtp-Source: ALg8bN6As5r9ULqeOtNxVMxGNKPzJ/yav/ELGM4TbUuVT4DOgHnMK5vUPOU0GgJvsDBqUQgIrCPfwQ==
X-Received: by 2002:a5d:46cd:: with SMTP id g13mr29202041wrs.49.1546096860218;
        Sat, 29 Dec 2018 07:21:00 -0800 (PST)
Received: from localhost.localdomain ([87.71.118.243])
        by smtp.gmail.com with ESMTPSA id 14sm65226258wmv.36.2018.12.29.07.20.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Dec 2018 07:20:58 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5] media: vicodec: add support for CROP and COMPOSE selection
Date:   Sat, 29 Dec 2018 07:20:09 -0800
Message-Id: <20181229152009.130656-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add support for the selection api for the crop and compose targets.
The driver rounds up the coded width and height such that
all planes dimensions are multiple of 8.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
Main changes from v4:
In s/g_selection, check buffer type according to 'multiplanar' variable.
Spliting some lines longer than 80 chars.

 drivers/media/platform/vicodec/codec-fwht.c   |  67 +++++---
 drivers/media/platform/vicodec/codec-fwht.h   |  17 +-
 .../media/platform/vicodec/codec-v4l2-fwht.c  |  36 ++--
 .../media/platform/vicodec/codec-v4l2-fwht.h  |   6 +-
 drivers/media/platform/vicodec/vicodec-core.c | 161 ++++++++++++++----
 5 files changed, 205 insertions(+), 82 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
index a6fd0477633b..db2c62c4d9bd 100644
--- a/drivers/media/platform/vicodec/codec-fwht.c
+++ b/drivers/media/platform/vicodec/codec-fwht.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/string.h>
+#include <linux/kernel.h>
 #include "codec-fwht.h"
 
 /*
@@ -660,7 +661,7 @@ static void add_deltas(s16 *deltas, const u8 *ref, int stride)
 
 static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
 			struct fwht_cframe *cf, u32 height, u32 width,
-			unsigned int input_step,
+			u32 coded_width, unsigned int input_step,
 			bool is_intra, bool next_is_intra)
 {
 	u8 *input_start = input;
@@ -671,7 +672,11 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
 	unsigned int last_size = 0;
 	unsigned int i, j;
 
+	width = round_up(width, 8);
+	height = round_up(height, 8);
+
 	for (j = 0; j < height / 8; j++) {
+		input = input_start + j * 8 * coded_width * input_step;
 		for (i = 0; i < width / 8; i++) {
 			/* intra code, first frame is always intra coded. */
 			int blocktype = IBLOCK;
@@ -679,9 +684,9 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
 
 			if (!is_intra)
 				blocktype = decide_blocktype(input, refp,
-					deltablock, width, input_step);
+					deltablock, coded_width, input_step);
 			if (blocktype == IBLOCK) {
-				fwht(input, cf->coeffs, width, input_step, 1);
+				fwht(input, cf->coeffs, coded_width, input_step, 1);
 				quantize_intra(cf->coeffs, cf->de_coeffs,
 					       cf->i_frame_qp);
 			} else {
@@ -722,7 +727,6 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
 			}
 			last_size = size;
 		}
-		input += width * 7 * input_step;
 	}
 
 exit_loop:
@@ -747,30 +751,32 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
 u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 		      struct fwht_raw_frame *ref_frm,
 		      struct fwht_cframe *cf,
-		      bool is_intra, bool next_is_intra)
+		      bool is_intra, bool next_is_intra,
+		      unsigned int width, unsigned int height)
 {
-	unsigned int size = frm->height * frm->width;
+	unsigned int size = height * width;
 	__be16 *rlco = cf->rlc_data;
 	__be16 *rlco_max;
 	u32 encoding;
 
 	rlco_max = rlco + size / 2 - 256;
 	encoding = encode_plane(frm->luma, ref_frm->luma, &rlco, rlco_max, cf,
-				frm->height, frm->width,
+				height, width, frm->coded_width,
 				frm->luma_alpha_step, is_intra, next_is_intra);
 	if (encoding & FWHT_FRAME_UNENCODED)
 		encoding |= FWHT_LUMA_UNENCODED;
 	encoding &= ~FWHT_FRAME_UNENCODED;
 
 	if (frm->components_num >= 3) {
-		u32 chroma_h = frm->height / frm->height_div;
-		u32 chroma_w = frm->width / frm->width_div;
+		u32 chroma_h = height / frm->height_div;
+		u32 chroma_w = width / frm->width_div;
+		u32 chroma_coded_width = frm->coded_width / frm->width_div;
 		unsigned int chroma_size = chroma_h * chroma_w;
 
 		rlco_max = rlco + chroma_size / 2 - 256;
 		encoding |= encode_plane(frm->cb, ref_frm->cb, &rlco, rlco_max,
 					 cf, chroma_h, chroma_w,
-					 frm->chroma_step,
+					 chroma_coded_width, frm->chroma_step,
 					 is_intra, next_is_intra);
 		if (encoding & FWHT_FRAME_UNENCODED)
 			encoding |= FWHT_CB_UNENCODED;
@@ -778,7 +784,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 		rlco_max = rlco + chroma_size / 2 - 256;
 		encoding |= encode_plane(frm->cr, ref_frm->cr, &rlco, rlco_max,
 					 cf, chroma_h, chroma_w,
-					 frm->chroma_step,
+					 chroma_coded_width, frm->chroma_step,
 					 is_intra, next_is_intra);
 		if (encoding & FWHT_FRAME_UNENCODED)
 			encoding |= FWHT_CR_UNENCODED;
@@ -788,8 +794,8 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 	if (frm->components_num == 4) {
 		rlco_max = rlco + size / 2 - 256;
 		encoding |= encode_plane(frm->alpha, ref_frm->alpha, &rlco,
-					 rlco_max, cf, frm->height, frm->width,
-					 frm->luma_alpha_step,
+					 rlco_max, cf, height, width,
+					 frm->coded_width, frm->luma_alpha_step,
 					 is_intra, next_is_intra);
 		if (encoding & FWHT_FRAME_UNENCODED)
 			encoding |= FWHT_ALPHA_UNENCODED;
@@ -801,7 +807,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 }
 
 static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
-			 u32 height, u32 width, bool uncompressed)
+			 u32 height, u32 width, u32 coded_width, bool uncompressed)
 {
 	unsigned int copies = 0;
 	s16 copy[8 * 8];
@@ -813,6 +819,8 @@ static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
 		*rlco += width * height / 2;
 		return;
 	}
+	width = round_up(width, 8);
+	height = round_up(height, 8);
 
 	/*
 	 * When decoding each macroblock the rlco pointer will be increased
@@ -822,13 +830,13 @@ static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
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
@@ -847,35 +855,40 @@ static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
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
index 90ff8962fca7..d7e0d9b87c96 100644
--- a/drivers/media/platform/vicodec/codec-fwht.h
+++ b/drivers/media/platform/vicodec/codec-fwht.h
@@ -81,6 +81,13 @@
 #define FWHT_FL_COMPONENTS_NUM_MSK	GENMASK(17, 16)
 #define FWHT_FL_COMPONENTS_NUM_OFFSET	16
 
+/*
+ * A macro to calculate the needed padding in order to make sure
+ * both luma and chroma components resolutions are rounded up to
+ * closest multiple of 8
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
@@ -106,12 +112,12 @@ struct fwht_cframe {
 };
 
 struct fwht_raw_frame {
-	unsigned int width, height;
 	unsigned int width_div;
 	unsigned int height_div;
 	unsigned int luma_alpha_step;
 	unsigned int chroma_step;
 	unsigned int components_num;
+	unsigned int coded_width;
 	u8 *luma, *cb, *cr, *alpha;
 };
 
@@ -125,8 +131,11 @@ struct fwht_raw_frame {
 u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 		      struct fwht_raw_frame *ref_frm,
 		      struct fwht_cframe *cf,
-		      bool is_intra, bool next_is_intra);
+		      bool is_intra, bool next_is_intra,
+		      unsigned int width, unsigned int height);
 void fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
-		       u32 hdr_flags, unsigned int components_num);
+		       u32 hdr_flags, unsigned int components_num,
+		       unsigned int width, unsigned int height,
+		       unsigned int coded_width);
 
 #endif
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index 8cb0212df67f..19f9d65fc0a9 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -56,7 +56,7 @@ const struct v4l2_fwht_pixfmt_info *v4l2_fwht_get_pixfmt(u32 idx)
 
 int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 {
-	unsigned int size = state->width * state->height;
+	unsigned int size = state->coded_width * state->coded_height;
 	const struct v4l2_fwht_pixfmt_info *info = state->info;
 	struct fwht_cframe_hdr *p_hdr;
 	struct fwht_cframe cf;
@@ -66,8 +66,8 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 
 	if (!info)
 		return -EINVAL;
-	rf.width = state->width;
-	rf.height = state->height;
+
+	rf.coded_width = state->coded_width;
 	rf.luma = p_in;
 	rf.width_div = info->width_div;
 	rf.height_div = info->height_div;
@@ -163,15 +163,14 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
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
+				     state->visible_width, state->visible_height);
 	if (!(encoding & FWHT_FRAME_PCODED))
 		state->gop_cnt = 0;
 	if (++state->gop_cnt >= state->gop_size)
@@ -181,8 +180,8 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
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
@@ -202,15 +201,13 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
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
+	unsigned int size;
+	unsigned int chroma_size;
 	unsigned int i;
 	u32 flags;
 	struct fwht_cframe_hdr *p_hdr;
@@ -218,13 +215,15 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	u8 *p;
 	unsigned int components_num = 3;
 	unsigned int version;
+	const struct v4l2_fwht_pixfmt_info *info;
 
 	if (!state->info)
 		return -EINVAL;
 
+	info = state->info;
+	size = state->coded_width * state->coded_height;
+	chroma_size = size;
 	p_hdr = (struct fwht_cframe_hdr *)p_in;
-	cf.width = ntohl(p_hdr->width);
-	cf.height = ntohl(p_hdr->height);
 
 	version = ntohl(p_hdr->version);
 	if (!version || version > FWHT_VERSION) {
@@ -234,12 +233,12 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
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
@@ -260,7 +259,8 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	if (!(flags & FWHT_FL_CHROMA_FULL_HEIGHT))
 		chroma_size /= 2;
 
-	fwht_decode_frame(&cf, &state->ref_frame, flags, components_num);
+	fwht_decode_frame(&cf, &state->ref_frame, flags, components_num,
+			  state->visible_width, state->visible_height, state->coded_width);
 
 	/*
 	 * TODO - handle the case where the compressed stream encodes a
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.h b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
index ed53e28d4f9c..2a09ad13ddd6 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.h
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
@@ -23,8 +23,10 @@ struct v4l2_fwht_pixfmt_info {
 
 struct v4l2_fwht_state {
 	const struct v4l2_fwht_pixfmt_info *info;
-	unsigned int width;
-	unsigned int height;
+	unsigned int visible_width;
+	unsigned int visible_height;
+	unsigned int coded_width;
+	unsigned int coded_height;
 	unsigned int gop_size;
 	unsigned int gop_cnt;
 	u16 i_frame_qp;
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 0d7876f5acf0..bbcce826c440 100644
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
@@ -464,11 +466,11 @@ static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
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
@@ -481,13 +483,13 @@ static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
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
@@ -528,8 +530,8 @@ static int vidioc_try_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
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
@@ -545,9 +547,8 @@ static int vidioc_try_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
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
@@ -658,8 +659,8 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		if (ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type))
 			fmt_changed =
 				q_data->info->id != pix->pixelformat ||
-				q_data->width != pix->width ||
-				q_data->height != pix->height;
+				q_data->coded_width != pix->width ||
+				q_data->coded_height != pix->height;
 
 		if (vb2_is_busy(vq) && fmt_changed)
 			return -EBUSY;
@@ -668,8 +669,8 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
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
@@ -678,8 +679,8 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		if (ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type))
 			fmt_changed =
 				q_data->info->id != pix_mp->pixelformat ||
-				q_data->width != pix_mp->width ||
-				q_data->height != pix_mp->height;
+				q_data->coded_width != pix_mp->width ||
+				q_data->coded_height != pix_mp->height;
 
 		if (vb2_is_busy(vq) && fmt_changed)
 			return -EBUSY;
@@ -688,17 +689,24 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
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
@@ -753,6 +761,89 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
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
+	bool is_out_crop_on_enc;
+	bool is_cap_compose_on_dec;
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
+
+	is_out_crop_on_enc = ctx->is_enc &&
+			     s->type == valid_out_type &&
+			     s->target == V4L2_SEL_TGT_CROP;
+
+	is_cap_compose_on_dec = !ctx->is_enc &&
+				s->type == valid_cap_type &&
+				s->target == V4L2_SEL_TGT_COMPOSE;
+
+	if (!is_out_crop_on_enc && !is_cap_compose_on_dec)
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
@@ -895,6 +986,9 @@ static const struct v4l2_ioctl_ops vicodec_ioctl_ops = {
 	.vidioc_streamon	= v4l2_m2m_ioctl_streamon,
 	.vidioc_streamoff	= v4l2_m2m_ioctl_streamoff,
 
+	.vidioc_g_selection	= vidioc_g_selection,
+	.vidioc_s_selection	= vidioc_s_selection,
+
 	.vidioc_try_encoder_cmd	= vicodec_try_encoder_cmd,
 	.vidioc_encoder_cmd	= vicodec_encoder_cmd,
 	.vidioc_try_decoder_cmd	= vicodec_try_decoder_cmd,
@@ -988,8 +1082,8 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	struct vicodec_ctx *ctx = vb2_get_drv_priv(q);
 	struct vicodec_q_data *q_data = get_q_data(ctx, q->type);
 	struct v4l2_fwht_state *state = &ctx->state;
-	unsigned int size = q_data->width * q_data->height;
 	const struct v4l2_fwht_pixfmt_info *info = q_data->info;
+	unsigned int size = q_data->coded_width * q_data->coded_height;
 	unsigned int chroma_div = info->width_div * info->height_div;
 	unsigned int total_planes_size;
 
@@ -1008,17 +1102,20 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 
 	if (!V4L2_TYPE_IS_OUTPUT(q->type)) {
 		if (!ctx->is_enc) {
-			state->width = q_data->width;
-			state->height = q_data->height;
+			state->visible_width = q_data->visible_width;
+			state->visible_height = q_data->visible_height;
+			state->coded_width = q_data->coded_width;
+			state->coded_height = q_data->coded_height;
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
 	}
-	state->ref_frame.width = state->ref_frame.height = 0;
 	state->ref_frame.luma = kvmalloc(total_planes_size, GFP_KERNEL);
 	ctx->comp_max_size = total_planes_size + sizeof(struct fwht_cframe_hdr);
 	state->compressed_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
@@ -1204,8 +1301,10 @@ static int vicodec_open(struct file *file)
 
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

