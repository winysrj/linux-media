Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 336EAC282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 09:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6E292085A
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 09:51:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O2U6wAEk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfAXJvV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 04:51:21 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41669 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbfAXJvV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 04:51:21 -0500
Received: by mail-wr1-f67.google.com with SMTP id x10so5710016wrs.8
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 01:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Zjk147PwEpjD8wAstSUXSp23mTBb3JcPkd70pWoApI8=;
        b=O2U6wAEkGL37gUZ1oFce5P4ho7bviHup65V7yLUgURJbyzN2Pfgf5xK1CiT8TTP6Mx
         KChD3FykfJLajiuKXz9iaCb62Uv5ZxG4a2PbJkm0c3TtEfprF62kjYOR0gaQcf0a2+T/
         JAiXuV6v6biR2HzcB9j9f42341c1y2DG5F3nlCM/qUfURYtlu8v/rEEYDZOt5vXR6ivg
         RXG5FMijG1HZdRZtZ3e+nQKDLQh/e2Hvv6Rij7KOx9UmEarvps5/AA9PPCAXjLa1khuq
         qOl7xnAHgSqEisEEBmIAOXmD7OlU/DBYMEQ3imKzeT4TihXLD5OJH+cmL7JaeJl4Wcpe
         UMnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Zjk147PwEpjD8wAstSUXSp23mTBb3JcPkd70pWoApI8=;
        b=ORgCKuPNeypZTj2Bqs5nXrB2akmR1e5btGLFCluO6R2tTaYR02UbcMJ4kxMhhbuI3Q
         9Z71OFvMyIThe8V2vwdV+yFeyxDtrwESpQ2oLnwWxvBFn7veFwthjkq/7JXYl2tldSLB
         2MpyZ+1RsIISxPXNwdGv/MJPnKRtRQDF4rWli6xOPOcyhsNXMvVVFuwo7PS9nfVEdfjp
         wtnomt517dp6UC2R7ZCbR+Y7aBBB+KsHyKQsUIrTXkLZalf53JkR00cx8GKux8fIFhtY
         yCc1oX2krDVR+7utqTqg/uDOy4ed6THjBN0QB6wbJf4J5wGISakkFzLXWGdQm+kNCMlU
         DbKw==
X-Gm-Message-State: AJcUukebVHGQ1zgXvkTEYrm0PV0sHIdgGtX7iJNeHKc9LNiGTx/sM6Fh
        DCydjHs6Y6w2qo59X2+J6n5KM64VIeA=
X-Google-Smtp-Source: ALg8bN7fzA/11TqK71hhSywdgOfUNxkpjJd0+i4P/N13RDQhHA7XZkEp9by6winpX+400xsWSgEzMg==
X-Received: by 2002:adf:f848:: with SMTP id d8mr6790794wrq.178.1548323478284;
        Thu, 24 Jan 2019 01:51:18 -0800 (PST)
Received: from localhost.localdomain (62-90-76-19.barak.net.il. [62.90.76.19])
        by smtp.gmail.com with ESMTPSA id o8sm99954280wrx.15.2019.01.24.01.51.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 01:51:16 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v2] media: vicodec: ensure comp frame pointer kept in range
Date:   Thu, 24 Jan 2019 01:51:08 -0800
Message-Id: <20190124095108.97562-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Make sure that the pointer to the compressed frame does not
get out of the buffer.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
Changes from v1:
set OVERFLOW_BIT in derlc return val to indicate overflow.
fix return value type from s16 to u16

 drivers/media/platform/vicodec/codec-fwht.c   | 71 +++++++++++++------
 drivers/media/platform/vicodec/codec-fwht.h   |  2 +-
 .../media/platform/vicodec/codec-v4l2-fwht.c  |  8 ++-
 drivers/media/platform/vicodec/vicodec-core.c |  4 ++
 4 files changed, 60 insertions(+), 25 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
index e5e0a80c2f73..d1d6085da9f1 100644
--- a/drivers/media/platform/vicodec/codec-fwht.c
+++ b/drivers/media/platform/vicodec/codec-fwht.c
@@ -13,6 +13,8 @@
 #include <linux/kernel.h>
 #include "codec-fwht.h"
 
+#define OVERFLOW_BIT BIT(14)
+
 /*
  * Note: bit 0 of the header must always be 0. Otherwise it cannot
  * be guaranteed that the magic 8 byte sequence (see below) can
@@ -104,16 +106,21 @@ static int rlc(const s16 *in, __be16 *output, int blocktype)
  * This function will worst-case increase rlc_in by 65*2 bytes:
  * one s16 value for the header and 8 * 8 coefficients of type s16.
  */
-static s16 derlc(const __be16 **rlc_in, s16 *dwht_out)
+static u16 derlc(const __be16 **rlc_in, s16 *dwht_out,
+		 const __be16 *end_of_input)
 {
 	/* header */
 	const __be16 *input = *rlc_in;
-	s16 ret = ntohs(*input++);
+	u16 stat;
 	int dec_count = 0;
 	s16 block[8 * 8 + 16];
 	s16 *wp = block;
 	int i;
 
+	if (input > end_of_input)
+		return OVERFLOW_BIT;
+	stat = ntohs(*input++);
+
 	/*
 	 * Now de-compress, it expands one byte to up to 15 bytes
 	 * (or fills the remainder of the 64 bytes with zeroes if it
@@ -123,9 +130,15 @@ static s16 derlc(const __be16 **rlc_in, s16 *dwht_out)
 	 * allow for overflow if the incoming data was malformed.
 	 */
 	while (dec_count < 8 * 8) {
-		s16 in = ntohs(*input++);
-		int length = in & 0xf;
-		int coeff = in >> 4;
+		s16 in;
+		int length;
+		int coeff;
+
+		if (input > end_of_input)
+			return OVERFLOW_BIT;
+		in = ntohs(*input++);
+		length = in & 0xf;
+		coeff = in >> 4;
 
 		/* fill remainder with zeros */
 		if (length == 15) {
@@ -150,7 +163,7 @@ static s16 derlc(const __be16 **rlc_in, s16 *dwht_out)
 		dwht_out[x + y * 8] = *wp++;
 	}
 	*rlc_in = input;
-	return ret;
+	return stat;
 }
 
 static const int quant_table[] = {
@@ -808,22 +821,24 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 	return encoding;
 }
 
-static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
+static bool decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
 			 u32 height, u32 width, u32 coded_width,
-			 bool uncompressed)
+			 bool uncompressed, const __be16 *end_of_rlco_buf)
 {
 	unsigned int copies = 0;
 	s16 copy[8 * 8];
-	s16 stat;
+	u16 stat;
 	unsigned int i, j;
 
 	width = round_up(width, 8);
 	height = round_up(height, 8);
 
 	if (uncompressed) {
+		if (end_of_rlco_buf + 1 < *rlco + width * height / 2)
+			return false;
 		memcpy(ref, *rlco, width * height);
 		*rlco += width * height / 2;
-		return;
+		return true;
 	}
 
 	/*
@@ -847,8 +862,9 @@ static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
 				continue;
 			}
 
-			stat = derlc(rlco, cf->coeffs);
-
+			stat = derlc(rlco, cf->coeffs, end_of_rlco_buf);
+			if (stat & OVERFLOW_BIT)
+				return false;
 			if (stat & PFRAME_BIT)
 				dequantize_inter(cf->coeffs);
 			else
@@ -865,17 +881,22 @@ static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
 			fill_decoder_block(refp, cf->de_fwht, coded_width);
 		}
 	}
+	return true;
 }
 
-void fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
+bool fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
 		       u32 hdr_flags, unsigned int components_num,
 		       unsigned int width, unsigned int height,
 		       unsigned int coded_width)
 {
 	const __be16 *rlco = cf->rlc_data;
+	const __be16 *end_of_rlco_buf = cf->rlc_data +
+			(cf->size / sizeof(*rlco)) - 1;
 
-	decode_plane(cf, &rlco, ref->luma, height, width, coded_width,
-		     hdr_flags & FWHT_FL_LUMA_IS_UNCOMPRESSED);
+	if (!decode_plane(cf, &rlco, ref->luma, height, width, coded_width,
+			  hdr_flags & FWHT_FL_LUMA_IS_UNCOMPRESSED,
+			  end_of_rlco_buf))
+		return false;
 
 	if (components_num >= 3) {
 		u32 h = height;
@@ -888,13 +909,21 @@ void fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
 			w /= 2;
 			c /= 2;
 		}
-		decode_plane(cf, &rlco, ref->cb, h, w, c,
-			     hdr_flags & FWHT_FL_CB_IS_UNCOMPRESSED);
-		decode_plane(cf, &rlco, ref->cr, h, w, c,
-			     hdr_flags & FWHT_FL_CR_IS_UNCOMPRESSED);
+		if (!decode_plane(cf, &rlco, ref->cb, h, w, c,
+				  hdr_flags & FWHT_FL_CB_IS_UNCOMPRESSED,
+				  end_of_rlco_buf))
+			return false;
+		if (!decode_plane(cf, &rlco, ref->cr, h, w, c,
+				  hdr_flags & FWHT_FL_CR_IS_UNCOMPRESSED,
+				  end_of_rlco_buf))
+			return false;
 	}
 
 	if (components_num == 4)
-		decode_plane(cf, &rlco, ref->alpha, height, width, coded_width,
-			     hdr_flags & FWHT_FL_ALPHA_IS_UNCOMPRESSED);
+		if (!decode_plane(cf, &rlco, ref->alpha, height, width,
+				  coded_width,
+				  hdr_flags & FWHT_FL_ALPHA_IS_UNCOMPRESSED,
+				  end_of_rlco_buf))
+			return false;
+	return true;
 }
diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
index ad8cfc60a152..60d71d9dacb3 100644
--- a/drivers/media/platform/vicodec/codec-fwht.h
+++ b/drivers/media/platform/vicodec/codec-fwht.h
@@ -139,7 +139,7 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 		      bool is_intra, bool next_is_intra,
 		      unsigned int width, unsigned int height,
 		      unsigned int stride, unsigned int chroma_stride);
-void fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
+bool fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
 		       u32 hdr_flags, unsigned int components_num,
 		       unsigned int width, unsigned int height,
 		       unsigned int coded_width);
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index ee6903b8896c..c15034849133 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -280,6 +280,7 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	state->ycbcr_enc = ntohl(state->header.ycbcr_enc);
 	state->quantization = ntohl(state->header.quantization);
 	cf.rlc_data = (__be16 *)p_in;
+	cf.size = ntohl(state->header.size);
 
 	hdr_width_div = (flags & FWHT_FL_CHROMA_FULL_WIDTH) ? 1 : 2;
 	hdr_height_div = (flags & FWHT_FL_CHROMA_FULL_HEIGHT) ? 1 : 2;
@@ -287,9 +288,10 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	    hdr_height_div != info->height_div)
 		return -EINVAL;
 
-	fwht_decode_frame(&cf, &state->ref_frame, flags, components_num,
-			  state->visible_width, state->visible_height,
-			  state->coded_width);
+	if (!fwht_decode_frame(&cf, &state->ref_frame, flags, components_num,
+			       state->visible_width, state->visible_height,
+			       state->coded_width))
+		return -EINVAL;
 
 	/*
 	 * TODO - handle the case where the compressed stream encodes a
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index b84dae343645..953b9c4816a5 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -186,6 +186,10 @@ static int device_process(struct vicodec_ctx *ctx,
 			return ret;
 		vb2_set_plane_payload(&dst_vb->vb2_buf, 0, ret);
 	} else {
+		unsigned int comp_frame_size = ntohl(ctx->state.header.size);
+
+		if (comp_frame_size > ctx->comp_max_size)
+			return -EINVAL;
 		state->info = q_dst->info;
 		ret = v4l2_fwht_decode(state, p_src, p_dst);
 		if (ret < 0)
-- 
2.17.1

