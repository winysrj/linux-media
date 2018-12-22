Return-Path: <SRS0=mDsK=O7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EFB3C43387
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 21:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC6F22195D
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 21:02:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vEykSyUr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732220AbeLVVCK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 22 Dec 2018 16:02:10 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36998 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729645AbeLVVCJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Dec 2018 16:02:09 -0500
Received: by mail-wm1-f66.google.com with SMTP id g67so8816878wmd.2
        for <linux-media@vger.kernel.org>; Sat, 22 Dec 2018 13:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=x+ilDOTfRWxlIQHhlJooIzI3rGpXyj+wc602uM+N9nM=;
        b=vEykSyUr7isYG0xaE2HIgf2hKYgZyJF9KaixQWwOLjluC/aBl6QFp57hYfASCik/6q
         1N8QD7Y4/XZ4L4DPEsVcWFT4/qebQ2sK4ATbbTNJP5AaJE0Etsi+1xmEyLgm2Uos/pDD
         CD7YDLbOfR+9BH7QndtKWlpO7+utBOt1gWle8pzq22lND411xmwyw2D/Kq55kelme2Lo
         gmjYEVcveVLruSZAR9HdlFl003BlOCXdbXeU+d0jVU2qJ1K4IinDUVuDhUlBfs0ih2M1
         5J2vQnqAdX02bk0LZ6iWDdH55t2p/8esXXZTTbXwQHiH6aTBwmBmL/ev0B/FpqEaZMY8
         0JzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=x+ilDOTfRWxlIQHhlJooIzI3rGpXyj+wc602uM+N9nM=;
        b=VnyOG73wXNhaZmSP7lWsoxLeBbNFzuqWR/JYtl969ib7ZxvJ1W0FZqCUeuwMnV0NIy
         K+2C+VC4dMQ8Divw3HKse/Hl0IFvKJ/4bWt5db5oKNsKyti5ON8xdJfXlEfUE0kzG9ZA
         APlIZgLJr52pZvoFNiFjzWXpHGAJaO27sRTIb7gx9oC1VRB6hlMijiyHfBuvoTomkatF
         e/h7m5TAwNmKwRJMjbjikKoHEfcLyMvFHzztir+wflmk0w0CtZSbAflsHdK2iz3pBDiT
         K/VSnN1uGPUadass/VPjB3JtdBFq8WDVZY371ifw//pCvs1qQnL2OfJOshCfQp7dMa39
         LOSQ==
X-Gm-Message-State: AJcUukdVgTDh7DNSXRcUXctfEtEUe077EAsA0Zzg3uGKKodWr5TD6HOq
        aqL/RKFSgh0j+MD+hnTczx35Hg0dRfw=
X-Google-Smtp-Source: ALg8bN6m/jlWl02AJqSVgQ+82DDdNjyzRe59oOjj3Nv0nWj7oItDEGoatK02TeTm8JeTiGJySfHSsw==
X-Received: by 2002:a1c:b70a:: with SMTP id h10mr7125748wmf.125.1545512523720;
        Sat, 22 Dec 2018 13:02:03 -0800 (PST)
Received: from localhost.localdomain ([87.70.26.163])
        by smtp.gmail.com with ESMTPSA id t63sm12493435wmt.8.2018.12.22.13.02.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Dec 2018 13:02:02 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v3] media: vicodec: add support for CROP and COMPOSE selection
Date:   Sat, 22 Dec 2018 13:01:12 -0800
Message-Id: <20181222210112.63318-1-dafna3@gmail.com>
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
Main Changes from v2:
Add support for compose selection.
Rename the width/height fields of q_data to coded_width/height
    they contain the rounded w/h calculated with vic_round_up macro.
Rename 'stride' field/variable to 'coded_width' since this is what is actually contain.
visible_width/height are the values given from either crop or compose.

 drivers/media/platform/vicodec/codec-fwht.c   |  92 ++++++-----
 drivers/media/platform/vicodec/codec-fwht.h   |  15 +-
 .../media/platform/vicodec/codec-v4l2-fwht.c  |  36 ++---
 .../media/platform/vicodec/codec-v4l2-fwht.h  |   6 +-
 drivers/media/platform/vicodec/vicodec-core.c | 146 ++++++++++++++----
 5 files changed, 200 insertions(+), 95 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
index a6fd0477633b..927d7b417a2d 100644
--- a/drivers/media/platform/vicodec/codec-fwht.c
+++ b/drivers/media/platform/vicodec/codec-fwht.c
@@ -11,6 +11,7 @@
 
 #include <linux/string.h>
 #include "codec-fwht.h"
+#include <linux/kernel.h>
 
 /*
  * Note: bit 0 of the header must always be 0. Otherwise it cannot
@@ -226,7 +227,7 @@ static void dequantize_inter(s16 *coeff)
 			*coeff <<= *quant;
 }
 
-static void fwht(const u8 *block, s16 *output_block, unsigned int stride,
+static void fwht(const u8 *block, s16 *output_block, unsigned int coded_width,
 		 unsigned int input_step, bool intra)
 {
 	/* we'll need more than 8 bits for the transformed coefficients */
@@ -237,9 +238,9 @@ static void fwht(const u8 *block, s16 *output_block, unsigned int stride,
 	unsigned int i;
 
 	/* stage 1 */
-	stride *= input_step;
+	coded_width *= input_step;
 
-	for (i = 0; i < 8; i++, tmp += stride, out += 8) {
+	for (i = 0; i < 8; i++, tmp += coded_width, out += 8) {
 		switch (input_step) {
 		case 1:
 			workspace1[0]  = tmp[0] + tmp[1] - add;
@@ -361,7 +362,7 @@ static void fwht(const u8 *block, s16 *output_block, unsigned int stride,
  * Furthermore values can be negative... This is just a version that
  * works with 16 signed data
  */
-static void fwht16(const s16 *block, s16 *output_block, int stride, int intra)
+static void fwht16(const s16 *block, s16 *output_block, int coded_width, int intra)
 {
 	/* we'll need more than 8 bits for the transformed coefficients */
 	s32 workspace1[8], workspace2[8];
@@ -369,7 +370,7 @@ static void fwht16(const s16 *block, s16 *output_block, int stride, int intra)
 	s16 *out = output_block;
 	int i;
 
-	for (i = 0; i < 8; i++, tmp += stride, out += 8) {
+	for (i = 0; i < 8; i++, tmp += coded_width, out += 8) {
 		/* stage 1 */
 		workspace1[0]  = tmp[0] + tmp[1];
 		workspace1[1]  = tmp[0] - tmp[1];
@@ -555,14 +556,14 @@ static void ifwht(const s16 *block, s16 *output_block, int intra)
 }
 
 static void fill_encoder_block(const u8 *input, s16 *dst,
-			       unsigned int stride, unsigned int input_step)
+			       unsigned int coded_width, unsigned int input_step)
 {
 	int i, j;
 
 	for (i = 0; i < 8; i++) {
 		for (j = 0; j < 8; j++, input += input_step)
 			*dst++ = *input;
-		input += (stride - 8) * input_step;
+		input += (coded_width - 8) * input_step;
 	}
 }
 
@@ -593,7 +594,7 @@ static int var_inter(const s16 *old, const s16 *new)
 }
 
 static int decide_blocktype(const u8 *cur, const u8 *reference,
-			    s16 *deltablock, unsigned int stride,
+			    s16 *deltablock, unsigned int coded_width,
 			    unsigned int input_step)
 {
 	s16 tmp[64];
@@ -603,7 +604,7 @@ static int decide_blocktype(const u8 *cur, const u8 *reference,
 	int vari;
 	int vard;
 
-	fill_encoder_block(cur, tmp, stride, input_step);
+	fill_encoder_block(cur, tmp, coded_width, input_step);
 	fill_encoder_block(reference, old, 8, 1);
 	vari = var_intra(tmp);
 
@@ -620,7 +621,7 @@ static int decide_blocktype(const u8 *cur, const u8 *reference,
 	return vari <= vard ? IBLOCK : PBLOCK;
 }
 
-static void fill_decoder_block(u8 *dst, const s16 *input, int stride)
+static void fill_decoder_block(u8 *dst, const s16 *input, int coded_width)
 {
 	int i, j;
 
@@ -633,11 +634,11 @@ static void fill_decoder_block(u8 *dst, const s16 *input, int stride)
 			else
 				*dst = *input;
 		}
-		dst += stride - 8;
+		dst += coded_width - 8;
 	}
 }
 
-static void add_deltas(s16 *deltas, const u8 *ref, int stride)
+static void add_deltas(s16 *deltas, const u8 *ref, int coded_width)
 {
 	int k, l;
 
@@ -654,12 +655,12 @@ static void add_deltas(s16 *deltas, const u8 *ref, int stride)
 				*deltas = 255;
 			deltas++;
 		}
-		ref += stride - 8;
+		ref += coded_width - 8;
 	}
 }
 
 static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
-			struct fwht_cframe *cf, u32 height, u32 width,
+			struct fwht_cframe *cf, u32 height, u32 width, u32 coded_width,
 			unsigned int input_step,
 			bool is_intra, bool next_is_intra)
 {
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
@@ -747,29 +751,31 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
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
-					 cf, chroma_h, chroma_w,
+					 cf, chroma_h, chroma_w, chroma_coded_width,
 					 frm->chroma_step,
 					 is_intra, next_is_intra);
 		if (encoding & FWHT_FRAME_UNENCODED)
@@ -777,7 +783,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 		encoding &= ~FWHT_FRAME_UNENCODED;
 		rlco_max = rlco + chroma_size / 2 - 256;
 		encoding |= encode_plane(frm->cr, ref_frm->cr, &rlco, rlco_max,
-					 cf, chroma_h, chroma_w,
+					 cf, chroma_h, chroma_w, chroma_coded_width,
 					 frm->chroma_step,
 					 is_intra, next_is_intra);
 		if (encoding & FWHT_FRAME_UNENCODED)
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
@@ -847,35 +855,39 @@ static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
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
+		       unsigned int width, unsigned int height, unsigned int coded_width)
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
index 90ff8962fca7..8163014c368c 100644
--- a/drivers/media/platform/vicodec/codec-fwht.h
+++ b/drivers/media/platform/vicodec/codec-fwht.h
@@ -81,6 +81,12 @@
 #define FWHT_FL_COMPONENTS_NUM_MSK	GENMASK(17, 16)
 #define FWHT_FL_COMPONENTS_NUM_OFFSET	16
 
+/* A macro to calculate the needed padding in order to make sure
+ * both luma and chroma components resolutions are rounded up to
+ * closest multiple of 8
+ */
+#define vic_round_dim(dim, div) (round_up((dim) / (div), 8) * (div))
+
 struct fwht_cframe_hdr {
 	u32 magic1;
 	u32 magic2;
@@ -95,7 +101,6 @@ struct fwht_cframe_hdr {
 };
 
 struct fwht_cframe {
-	unsigned int width, height;
 	u16 i_frame_qp;
 	u16 p_frame_qp;
 	__be16 *rlc_data;
@@ -106,12 +111,12 @@ struct fwht_cframe {
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
 
@@ -125,8 +130,10 @@ struct fwht_raw_frame {
 u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 		      struct fwht_raw_frame *ref_frm,
 		      struct fwht_cframe *cf,
-		      bool is_intra, bool next_is_intra);
+		      bool is_intra, bool next_is_intra,
+		      unsigned int width, unsigned int height);
 void fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
-		       u32 hdr_flags, unsigned int components_num);
+		       u32 hdr_flags, unsigned int components_num,
+		       unsigned int width, unsigned int height, unsigned int coded_width);
 
 #endif
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index 8cb0212df67f..652296bdd250 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -56,7 +56,7 @@ const struct v4l2_fwht_pixfmt_info *v4l2_fwht_get_pixfmt(u32 idx)
 
 int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 {
-	unsigned int size = state->width * state->height;
+	unsigned int size;
 	const struct v4l2_fwht_pixfmt_info *info = state->info;
 	struct fwht_cframe_hdr *p_hdr;
 	struct fwht_cframe cf;
@@ -66,8 +66,9 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 
 	if (!info)
 		return -EINVAL;
-	rf.width = state->width;
-	rf.height = state->height;
+
+	size = state->coded_width * state->coded_height;
+	rf.coded_width = state->coded_width;
 	rf.luma = p_in;
 	rf.width_div = info->width_div;
 	rf.height_div = info->height_div;
@@ -163,15 +164,14 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
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
@@ -181,8 +181,8 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
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
@@ -202,15 +202,13 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
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
@@ -218,13 +216,15 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
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
@@ -234,12 +234,11 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	}
 
 	if (p_hdr->magic1 != FWHT_MAGIC1 ||
-	    p_hdr->magic2 != FWHT_MAGIC2 ||
-	    (cf.width & 7) || (cf.height & 7))
+	    p_hdr->magic2 != FWHT_MAGIC2)
 		return -EINVAL;
 
 	/* TODO: support resolution changes */
-	if (cf.width != state->width || cf.height != state->height)
+	if (ntohl(p_hdr->width) != state->visible_width || ntohl(p_hdr->height) != state->visible_height)
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
index 0d7876f5acf0..91e7e4c6fa49 100644
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
@@ -688,17 +689,23 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
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
+		q_data->visible_width, q_data->visible_height, q_data->info->id);
 
 	return 0;
 }
@@ -753,6 +760,75 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
 	return ret;
 }
 
+static int vidioc_g_selection(struct file *file, void *priv,
+			      struct v4l2_selection *s)
+{
+	struct vicodec_ctx *ctx = file2ctx(file);
+	struct vicodec_q_data *q_data;
+
+	q_data = get_q_data(ctx, s->type);
+	if (!q_data)
+		return -EINVAL;
+	/*
+	 * encoder supports only cropping on the OUTPUT buffer
+	 * decoder supports only composing on the CAPTURE buffer
+	 */
+	if ((ctx->is_enc && s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) ||
+	    (!ctx->is_enc && s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
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
+
+	q_data = get_q_data(ctx, s->type);
+	if (!q_data)
+		return -EINVAL;
+
+	is_out_crop_on_enc = ctx->is_enc &&
+			     s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
+			     s->target == V4L2_SEL_TGT_CROP;
+
+	is_cap_compose_on_dec = !ctx->is_enc &&
+				s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+				s->target == V4L2_SEL_TGT_COMPOSE;
+
+	if (is_out_crop_on_enc || is_cap_compose_on_dec) {
+		s->r.left = 0;
+		s->r.top = 0;
+		q_data->visible_width = clamp(s->r.width, MIN_WIDTH, q_data->coded_width);
+		s->r.width = q_data->visible_width;
+		q_data->visible_height = clamp(s->r.height, MIN_HEIGHT, q_data->coded_height);
+		s->r.height = q_data->visible_height;
+		return 0;
+	}
+	return -EINVAL;
+}
+
 static void vicodec_mark_last_buf(struct vicodec_ctx *ctx)
 {
 	static const struct v4l2_event eos_event = {
@@ -895,6 +971,9 @@ static const struct v4l2_ioctl_ops vicodec_ioctl_ops = {
 	.vidioc_streamon	= v4l2_m2m_ioctl_streamon,
 	.vidioc_streamoff	= v4l2_m2m_ioctl_streamoff,
 
+	.vidioc_g_selection	= vidioc_g_selection,
+	.vidioc_s_selection	= vidioc_s_selection,
+
 	.vidioc_try_encoder_cmd	= vicodec_try_encoder_cmd,
 	.vidioc_encoder_cmd	= vicodec_encoder_cmd,
 	.vidioc_try_decoder_cmd	= vicodec_try_decoder_cmd,
@@ -988,8 +1067,8 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	struct vicodec_ctx *ctx = vb2_get_drv_priv(q);
 	struct vicodec_q_data *q_data = get_q_data(ctx, q->type);
 	struct v4l2_fwht_state *state = &ctx->state;
-	unsigned int size = q_data->width * q_data->height;
 	const struct v4l2_fwht_pixfmt_info *info = q_data->info;
+	unsigned int size = q_data->coded_width * q_data->coded_height;
 	unsigned int chroma_div = info->width_div * info->height_div;
 	unsigned int total_planes_size;
 
@@ -1008,17 +1087,20 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 
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
@@ -1204,8 +1286,10 @@ static int vicodec_open(struct file *file)
 
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

