Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:32817 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726941AbeHWLB3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 07:01:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 6/7] vicodec: rename and use proper fwht prefix for codec
Date: Thu, 23 Aug 2018 09:33:04 +0200
Message-Id: <20180823073305.6518-7-hverkuil@xs4all.nl>
In-Reply-To: <20180823073305.6518-1-hverkuil@xs4all.nl>
References: <20180823073305.6518-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The codec source is generic and not vicodec specific. It can be used
by other drivers or userspace as well. So rename the source and header
to something more generic (codec-fwht.c/h) and prefix the defines, types
and functions with fwht_.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../media/uapi/v4l/pixfmt-compressed.rst      |  2 +-
 drivers/media/platform/vicodec/Makefile       |  2 +-
 .../vicodec/{vicodec-codec.c => codec-fwht.c} | 62 ++++++++-----
 .../vicodec/{vicodec-codec.h => codec-fwht.h} | 77 +++++++---------
 drivers/media/platform/vicodec/vicodec-core.c | 89 ++++++++++---------
 5 files changed, 118 insertions(+), 114 deletions(-)
 rename drivers/media/platform/vicodec/{vicodec-codec.c => codec-fwht.c} (93%)
 rename drivers/media/platform/vicodec/{vicodec-codec.h => codec-fwht.h} (63%)

diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
index d382e7a5c38e..d04b18adac33 100644
--- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
@@ -101,4 +101,4 @@ Compressed Formats
       - 'FWHT'
       - Video elementary stream using a codec based on the Fast Walsh Hadamard
         Transform. This codec is implemented by the vicodec ('Virtual Codec')
-	driver. See the vicodec-codec.h header for more details.
+	driver. See the codec-fwht.h header for more details.
diff --git a/drivers/media/platform/vicodec/Makefile b/drivers/media/platform/vicodec/Makefile
index 197229428953..a27242ff14ad 100644
--- a/drivers/media/platform/vicodec/Makefile
+++ b/drivers/media/platform/vicodec/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-vicodec-objs := vicodec-core.o vicodec-codec.o
+vicodec-objs := vicodec-core.o codec-fwht.o
 
 obj-$(CONFIG_VIDEO_VICODEC) += vicodec.o
diff --git a/drivers/media/platform/vicodec/vicodec-codec.c b/drivers/media/platform/vicodec/codec-fwht.c
similarity index 93%
rename from drivers/media/platform/vicodec/vicodec-codec.c
rename to drivers/media/platform/vicodec/codec-fwht.c
index 3547129c1163..f91f90f7e5fc 100644
--- a/drivers/media/platform/vicodec/vicodec-codec.c
+++ b/drivers/media/platform/vicodec/codec-fwht.c
@@ -10,7 +10,18 @@
  */
 
 #include <linux/string.h>
-#include "vicodec-codec.h"
+#include "codec-fwht.h"
+
+/*
+ * Note: bit 0 of the header must always be 0. Otherwise it cannot
+ * be guaranteed that the magic 8 byte sequence (see below) can
+ * never occur in the rlc output.
+ */
+#define PFRAME_BIT BIT(15)
+#define DUPS_MASK 0x1ffe
+
+#define PBLOCK 0
+#define IBLOCK 1
 
 #define ALL_ZEROS 15
 
@@ -642,7 +653,7 @@ static void add_deltas(s16 *deltas, const u8 *ref, int stride)
 }
 
 static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
-			struct cframe *cf, u32 height, u32 width,
+			struct fwht_cframe *cf, u32 height, u32 width,
 			unsigned int input_step,
 			bool is_intra, bool next_is_intra)
 {
@@ -669,7 +680,7 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
 					       cf->i_frame_qp);
 			} else {
 				/* inter code */
-				encoding |= FRAME_PCODED;
+				encoding |= FWHT_FRAME_PCODED;
 				fwht16(deltablock, cf->coeffs, 8, 0);
 				quantize_inter(cf->coeffs, cf->de_coeffs,
 					       cf->p_frame_qp);
@@ -700,7 +711,7 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
 				*rlco += size;
 			}
 			if (*rlco >= rlco_max) {
-				encoding |= FRAME_UNENCODED;
+				encoding |= FWHT_FRAME_UNENCODED;
 				goto exit_loop;
 			}
 			last_size = size;
@@ -709,7 +720,7 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
 	}
 
 exit_loop:
-	if (encoding & FRAME_UNENCODED) {
+	if (encoding & FWHT_FRAME_UNENCODED) {
 		u8 *out = (u8 *)rlco_start;
 
 		input = input_start;
@@ -722,13 +733,15 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
 		for (i = 0; i < height * width; i++, input += input_step)
 			*out++ = (*input == 0xff) ? 0xfe : *input;
 		*rlco = (__be16 *)out;
-		encoding &= ~FRAME_PCODED;
+		encoding &= ~FWHT_FRAME_PCODED;
 	}
 	return encoding;
 }
 
-u32 encode_frame(struct raw_frame *frm, struct raw_frame *ref_frm,
-		 struct cframe *cf, bool is_intra, bool next_is_intra)
+u32 fwht_encode_frame(struct fwht_raw_frame *frm,
+		      struct fwht_raw_frame *ref_frm,
+		      struct fwht_cframe *cf,
+		      bool is_intra, bool next_is_intra)
 {
 	unsigned int size = frm->height * frm->width;
 	__be16 *rlco = cf->rlc_data;
@@ -742,28 +755,28 @@ u32 encode_frame(struct raw_frame *frm, struct raw_frame *ref_frm,
 	encoding = encode_plane(frm->luma, ref_frm->luma, &rlco, rlco_max, cf,
 				frm->height, frm->width,
 				frm->luma_step, is_intra, next_is_intra);
-	if (encoding & FRAME_UNENCODED)
-		encoding |= LUMA_UNENCODED;
-	encoding &= ~FRAME_UNENCODED;
+	if (encoding & FWHT_FRAME_UNENCODED)
+		encoding |= FWHT_LUMA_UNENCODED;
+	encoding &= ~FWHT_FRAME_UNENCODED;
 	rlco_max = rlco + chroma_size / 2 - 256;
 	encoding |= encode_plane(frm->cb, ref_frm->cb, &rlco, rlco_max, cf,
 				 chroma_h, chroma_w,
 				 frm->chroma_step, is_intra, next_is_intra);
-	if (encoding & FRAME_UNENCODED)
-		encoding |= CB_UNENCODED;
-	encoding &= ~FRAME_UNENCODED;
+	if (encoding & FWHT_FRAME_UNENCODED)
+		encoding |= FWHT_CB_UNENCODED;
+	encoding &= ~FWHT_FRAME_UNENCODED;
 	rlco_max = rlco + chroma_size / 2 - 256;
 	encoding |= encode_plane(frm->cr, ref_frm->cr, &rlco, rlco_max, cf,
 				 chroma_h, chroma_w,
 				 frm->chroma_step, is_intra, next_is_intra);
-	if (encoding & FRAME_UNENCODED)
-		encoding |= CR_UNENCODED;
-	encoding &= ~FRAME_UNENCODED;
+	if (encoding & FWHT_FRAME_UNENCODED)
+		encoding |= FWHT_CR_UNENCODED;
+	encoding &= ~FWHT_FRAME_UNENCODED;
 	cf->size = (rlco - cf->rlc_data) * sizeof(*rlco);
 	return encoding;
 }
 
-static void decode_plane(struct cframe *cf, const __be16 **rlco, u8 *ref,
+static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
 			 u32 height, u32 width, bool uncompressed)
 {
 	unsigned int copies = 0;
@@ -816,20 +829,21 @@ static void decode_plane(struct cframe *cf, const __be16 **rlco, u8 *ref,
 	}
 }
 
-void decode_frame(struct cframe *cf, struct raw_frame *ref, u32 hdr_flags)
+void fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
+		       u32 hdr_flags)
 {
 	const __be16 *rlco = cf->rlc_data;
 	u32 h = cf->height / 2;
 	u32 w = cf->width / 2;
 
-	if (hdr_flags & VICODEC_FL_CHROMA_FULL_HEIGHT)
+	if (hdr_flags & FWHT_FL_CHROMA_FULL_HEIGHT)
 		h *= 2;
-	if (hdr_flags & VICODEC_FL_CHROMA_FULL_WIDTH)
+	if (hdr_flags & FWHT_FL_CHROMA_FULL_WIDTH)
 		w *= 2;
 	decode_plane(cf, &rlco, ref->luma, cf->height, cf->width,
-		     hdr_flags & VICODEC_FL_LUMA_IS_UNCOMPRESSED);
+		     hdr_flags & FWHT_FL_LUMA_IS_UNCOMPRESSED);
 	decode_plane(cf, &rlco, ref->cb, h, w,
-		     hdr_flags & VICODEC_FL_CB_IS_UNCOMPRESSED);
+		     hdr_flags & FWHT_FL_CB_IS_UNCOMPRESSED);
 	decode_plane(cf, &rlco, ref->cr, h, w,
-		     hdr_flags & VICODEC_FL_CR_IS_UNCOMPRESSED);
+		     hdr_flags & FWHT_FL_CR_IS_UNCOMPRESSED);
 }
diff --git a/drivers/media/platform/vicodec/vicodec-codec.h b/drivers/media/platform/vicodec/codec-fwht.h
similarity index 63%
rename from drivers/media/platform/vicodec/vicodec-codec.h
rename to drivers/media/platform/vicodec/codec-fwht.h
index ff69d9297ef4..1f9e47331197 100644
--- a/drivers/media/platform/vicodec/vicodec-codec.h
+++ b/drivers/media/platform/vicodec/codec-fwht.h
@@ -4,15 +4,15 @@
  * Copyright 2018 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
  */
 
-#ifndef VICODEC_RLC_H
-#define VICODEC_RLC_H
+#ifndef CODEC_FWHT_H
+#define CODEC_FWHT_H
 
 #include <linux/types.h>
 #include <linux/bitops.h>
 #include <asm/byteorder.h>
 
 /*
- * The compressed format consists of a cframe_hdr struct followed by the
+ * The compressed format consists of a fwht_cframe_hdr struct followed by the
  * compressed frame data. The header contains the size of that data.
  * Each Y, Cb and Cr plane is compressed separately. If the compressed
  * size of each plane becomes larger than the uncompressed size, then
@@ -35,7 +35,7 @@
  *
  * All 16 and 32 bit values are stored in big-endian (network) order.
  *
- * Each cframe_hdr starts with an 8 byte magic header that is
+ * Each fwht_cframe_hdr starts with an 8 byte magic header that is
  * guaranteed not to occur in the compressed frame data. This header
  * can be used to sync to the next frame.
  *
@@ -46,51 +46,37 @@
  * https://hverkuil.home.xs4all.nl/fwht.pdf
  */
 
-/*
- * Note: bit 0 of the header must always be 0. Otherwise it cannot
- * be guaranteed that the magic 8 byte sequence (see below) can
- * never occur in the rlc output.
- */
-#define PFRAME_BIT (1 << 15)
-#define DUPS_MASK 0x1ffe
-
 /*
  * This is a sequence of 8 bytes with the low 4 bits set to 0xf.
  *
  * This sequence cannot occur in the encoded data
+ *
+ * Note that these two magic values are symmetrical so endian issues here.
  */
-#define VICODEC_MAGIC1 0x4f4f4f4f
-#define VICODEC_MAGIC2 0xffffffff
-
-#define VICODEC_VERSION 1
-
-#define VICODEC_MAX_WIDTH 3840
-#define VICODEC_MAX_HEIGHT 2160
-#define VICODEC_MIN_WIDTH 640
-#define VICODEC_MIN_HEIGHT 480
+#define FWHT_MAGIC1 0x4f4f4f4f
+#define FWHT_MAGIC2 0xffffffff
 
-#define PBLOCK 0
-#define IBLOCK 1
+#define FWHT_VERSION 1
 
 /* Set if this is an interlaced format */
-#define VICODEC_FL_IS_INTERLACED	BIT(0)
+#define FWHT_FL_IS_INTERLACED		BIT(0)
 /* Set if this is a bottom-first (NTSC) interlaced format */
-#define VICODEC_FL_IS_BOTTOM_FIRST	BIT(1)
+#define FWHT_FL_IS_BOTTOM_FIRST		BIT(1)
 /* Set if each 'frame' contains just one field */
-#define VICODEC_FL_IS_ALTERNATE		BIT(2)
+#define FWHT_FL_IS_ALTERNATE		BIT(2)
 /*
- * If VICODEC_FL_IS_ALTERNATE was set, then this is set if this
+ * If FWHT_FL_IS_ALTERNATE was set, then this is set if this
  * 'frame' is the bottom field, else it is the top field.
  */
-#define VICODEC_FL_IS_BOTTOM_FIELD	BIT(3)
+#define FWHT_FL_IS_BOTTOM_FIELD		BIT(3)
 /* Set if this frame is uncompressed */
-#define VICODEC_FL_LUMA_IS_UNCOMPRESSED	BIT(4)
-#define VICODEC_FL_CB_IS_UNCOMPRESSED	BIT(5)
-#define VICODEC_FL_CR_IS_UNCOMPRESSED	BIT(6)
-#define VICODEC_FL_CHROMA_FULL_HEIGHT	BIT(7)
-#define VICODEC_FL_CHROMA_FULL_WIDTH	BIT(8)
+#define FWHT_FL_LUMA_IS_UNCOMPRESSED	BIT(4)
+#define FWHT_FL_CB_IS_UNCOMPRESSED	BIT(5)
+#define FWHT_FL_CR_IS_UNCOMPRESSED	BIT(6)
+#define FWHT_FL_CHROMA_FULL_HEIGHT	BIT(7)
+#define FWHT_FL_CHROMA_FULL_WIDTH	BIT(8)
 
-struct cframe_hdr {
+struct fwht_cframe_hdr {
 	u32 magic1;
 	u32 magic2;
 	__be32 version;
@@ -103,7 +89,7 @@ struct cframe_hdr {
 	__be32 size;
 };
 
-struct cframe {
+struct fwht_cframe {
 	unsigned int width, height;
 	u16 i_frame_qp;
 	u16 p_frame_qp;
@@ -114,7 +100,7 @@ struct cframe {
 	u32 size;
 };
 
-struct raw_frame {
+struct fwht_raw_frame {
 	unsigned int width, height;
 	unsigned int width_div;
 	unsigned int height_div;
@@ -123,14 +109,17 @@ struct raw_frame {
 	u8 *luma, *cb, *cr;
 };
 
-#define FRAME_PCODED	BIT(0)
-#define FRAME_UNENCODED	BIT(1)
-#define LUMA_UNENCODED	BIT(2)
-#define CB_UNENCODED	BIT(3)
-#define CR_UNENCODED	BIT(4)
+#define FWHT_FRAME_PCODED	BIT(0)
+#define FWHT_FRAME_UNENCODED	BIT(1)
+#define FWHT_LUMA_UNENCODED	BIT(2)
+#define FWHT_CB_UNENCODED	BIT(3)
+#define FWHT_CR_UNENCODED	BIT(4)
 
-u32 encode_frame(struct raw_frame *frm, struct raw_frame *ref_frm,
-		 struct cframe *cf, bool is_intra, bool next_is_intra);
-void decode_frame(struct cframe *cf, struct raw_frame *ref, u32 hdr_flags);
+u32 fwht_encode_frame(struct fwht_raw_frame *frm,
+		      struct fwht_raw_frame *ref_frm,
+		      struct fwht_cframe *cf,
+		      bool is_intra, bool next_is_intra);
+void fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
+		       u32 hdr_flags);
 
 #endif
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index caff521d94c6..4f2c35533e08 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -23,7 +23,7 @@
 #include <media/v4l2-event.h>
 #include <media/videobuf2-vmalloc.h>
 
-#include "vicodec-codec.h"
+#include "codec-fwht.h"
 
 MODULE_DESCRIPTION("Virtual codec device");
 MODULE_AUTHOR("Hans Verkuil <hans.verkuil@cisco.com>");
@@ -152,7 +152,7 @@ struct vicodec_ctx {
 
 	/* Source and destination queue data */
 	struct vicodec_q_data   q_data[2];
-	struct raw_frame	ref_frame;
+	struct fwht_raw_frame	ref_frame;
 	u8			*compressed_frame;
 	u32			cur_buf_offset;
 	u32			comp_max_size;
@@ -191,9 +191,9 @@ static void encode(struct vicodec_ctx *ctx,
 {
 	unsigned int size = q_data->width * q_data->height;
 	const struct pixfmt_info *info = q_data->info;
-	struct cframe_hdr *p_hdr;
-	struct cframe cf;
-	struct raw_frame rf;
+	struct fwht_cframe_hdr *p_hdr;
+	struct fwht_cframe cf;
+	struct fwht_raw_frame rf;
 	u32 encoding;
 
 	rf.width = q_data->width;
@@ -279,29 +279,29 @@ static void encode(struct vicodec_ctx *ctx,
 	cf.p_frame_qp = ctx->p_frame_qp;
 	cf.rlc_data = (__be16 *)(p_out + sizeof(*p_hdr));
 
-	encoding = encode_frame(&rf, &ctx->ref_frame, &cf, !ctx->gop_cnt,
-				ctx->gop_cnt == ctx->gop_size - 1);
-	if (!(encoding & FRAME_PCODED))
+	encoding = fwht_encode_frame(&rf, &ctx->ref_frame, &cf, !ctx->gop_cnt,
+				     ctx->gop_cnt == ctx->gop_size - 1);
+	if (!(encoding & FWHT_FRAME_PCODED))
 		ctx->gop_cnt = 0;
 	if (++ctx->gop_cnt >= ctx->gop_size)
 		ctx->gop_cnt = 0;
 
-	p_hdr = (struct cframe_hdr *)p_out;
-	p_hdr->magic1 = VICODEC_MAGIC1;
-	p_hdr->magic2 = VICODEC_MAGIC2;
-	p_hdr->version = htonl(VICODEC_VERSION);
+	p_hdr = (struct fwht_cframe_hdr *)p_out;
+	p_hdr->magic1 = FWHT_MAGIC1;
+	p_hdr->magic2 = FWHT_MAGIC2;
+	p_hdr->version = htonl(FWHT_VERSION);
 	p_hdr->width = htonl(cf.width);
 	p_hdr->height = htonl(cf.height);
-	if (encoding & LUMA_UNENCODED)
-		flags |= VICODEC_FL_LUMA_IS_UNCOMPRESSED;
-	if (encoding & CB_UNENCODED)
-		flags |= VICODEC_FL_CB_IS_UNCOMPRESSED;
-	if (encoding & CR_UNENCODED)
-		flags |= VICODEC_FL_CR_IS_UNCOMPRESSED;
+	if (encoding & FWHT_LUMA_UNENCODED)
+		flags |= FWHT_FL_LUMA_IS_UNCOMPRESSED;
+	if (encoding & FWHT_CB_UNENCODED)
+		flags |= FWHT_FL_CB_IS_UNCOMPRESSED;
+	if (encoding & FWHT_CR_UNENCODED)
+		flags |= FWHT_FL_CR_IS_UNCOMPRESSED;
 	if (rf.height_div == 1)
-		flags |= VICODEC_FL_CHROMA_FULL_HEIGHT;
+		flags |= FWHT_FL_CHROMA_FULL_HEIGHT;
 	if (rf.width_div == 1)
-		flags |= VICODEC_FL_CHROMA_FULL_WIDTH;
+		flags |= FWHT_FL_CHROMA_FULL_WIDTH;
 	p_hdr->flags = htonl(flags);
 	p_hdr->colorspace = htonl(ctx->colorspace);
 	p_hdr->xfer_func = htonl(ctx->xfer_func);
@@ -320,11 +320,11 @@ static int decode(struct vicodec_ctx *ctx,
 	unsigned int chroma_size = size;
 	unsigned int i;
 	u32 flags;
-	struct cframe_hdr *p_hdr;
-	struct cframe cf;
+	struct fwht_cframe_hdr *p_hdr;
+	struct fwht_cframe cf;
 	u8 *p;
 
-	p_hdr = (struct cframe_hdr *)p_in;
+	p_hdr = (struct fwht_cframe_hdr *)p_in;
 	cf.width = ntohl(p_hdr->width);
 	cf.height = ntohl(p_hdr->height);
 	flags = ntohl(p_hdr->flags);
@@ -334,13 +334,13 @@ static int decode(struct vicodec_ctx *ctx,
 	ctx->quantization = ntohl(p_hdr->quantization);
 	cf.rlc_data = (__be16 *)(p_in + sizeof(*p_hdr));
 
-	if (p_hdr->magic1 != VICODEC_MAGIC1 ||
-	    p_hdr->magic2 != VICODEC_MAGIC2 ||
-	    ntohl(p_hdr->version) != VICODEC_VERSION ||
-	    cf.width < VICODEC_MIN_WIDTH ||
-	    cf.width > VICODEC_MAX_WIDTH ||
-	    cf.height < VICODEC_MIN_HEIGHT ||
-	    cf.height > VICODEC_MAX_HEIGHT ||
+	if (p_hdr->magic1 != FWHT_MAGIC1 ||
+	    p_hdr->magic2 != FWHT_MAGIC2 ||
+	    ntohl(p_hdr->version) != FWHT_VERSION ||
+	    cf.width < MIN_WIDTH ||
+	    cf.width > MAX_WIDTH ||
+	    cf.height < MIN_HEIGHT ||
+	    cf.height > MAX_HEIGHT ||
 	    (cf.width & 7) || (cf.height & 7))
 		return -EINVAL;
 
@@ -348,12 +348,12 @@ static int decode(struct vicodec_ctx *ctx,
 	if (cf.width != q_data->width || cf.height != q_data->height)
 		return -EINVAL;
 
-	if (!(flags & VICODEC_FL_CHROMA_FULL_WIDTH))
+	if (!(flags & FWHT_FL_CHROMA_FULL_WIDTH))
 		chroma_size /= 2;
-	if (!(flags & VICODEC_FL_CHROMA_FULL_HEIGHT))
+	if (!(flags & FWHT_FL_CHROMA_FULL_HEIGHT))
 		chroma_size /= 2;
 
-	decode_frame(&cf, &ctx->ref_frame, flags);
+	fwht_decode_frame(&cf, &ctx->ref_frame, flags);
 
 	switch (q_data->info->id) {
 	case V4L2_PIX_FMT_YUV420:
@@ -484,7 +484,7 @@ static int device_process(struct vicodec_ctx *ctx,
 	}
 
 	if (ctx->is_enc) {
-		struct cframe_hdr *p_hdr = (struct cframe_hdr *)p_out;
+		struct fwht_cframe_hdr *p_hdr = (struct fwht_cframe_hdr *)p_out;
 
 		encode(ctx, q_out, p_in, p_out, 0);
 		vb2_set_plane_payload(&out_vb->vb2_buf, 0,
@@ -635,9 +635,10 @@ static int job_ready(void *priv)
 		}
 		ctx->comp_size = sizeof(magic);
 	}
-	if (ctx->comp_size < sizeof(struct cframe_hdr)) {
-		struct cframe_hdr *p_hdr = (struct cframe_hdr *)ctx->compressed_frame;
-		u32 copy = sizeof(struct cframe_hdr) - ctx->comp_size;
+	if (ctx->comp_size < sizeof(struct fwht_cframe_hdr)) {
+		struct fwht_cframe_hdr *p_hdr =
+			(struct fwht_cframe_hdr *)ctx->compressed_frame;
+		u32 copy = sizeof(struct fwht_cframe_hdr) - ctx->comp_size;
 
 		if (copy > p_out + sz - p)
 			copy = p_out + sz - p;
@@ -645,7 +646,7 @@ static int job_ready(void *priv)
 		       p, copy);
 		p += copy;
 		ctx->comp_size += copy;
-		if (ctx->comp_size < sizeof(struct cframe_hdr)) {
+		if (ctx->comp_size < sizeof(struct fwht_cframe_hdr)) {
 			job_remove_out_buf(ctx, state);
 			goto restart;
 		}
@@ -670,8 +671,8 @@ static int job_ready(void *priv)
 	ctx->cur_buf_offset = p - p_out;
 	ctx->comp_has_frame = true;
 	ctx->comp_has_next_frame = false;
-	if (sz - ctx->cur_buf_offset >= sizeof(struct cframe_hdr)) {
-		struct cframe_hdr *p_hdr = (struct cframe_hdr *)p;
+	if (sz - ctx->cur_buf_offset >= sizeof(struct fwht_cframe_hdr)) {
+		struct fwht_cframe_hdr *p_hdr = (struct fwht_cframe_hdr *)p;
 		u32 frame_size = ntohl(p_hdr->size);
 		u32 remaining = sz - ctx->cur_buf_offset - sizeof(*p_hdr);
 
@@ -845,7 +846,7 @@ static int vidioc_try_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		pix->sizeimage = pix->width * pix->height *
 			info->sizeimage_mult / info->sizeimage_div;
 		if (pix->pixelformat == V4L2_PIX_FMT_FWHT)
-			pix->sizeimage += sizeof(struct cframe_hdr);
+			pix->sizeimage += sizeof(struct fwht_cframe_hdr);
 		break;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
@@ -863,7 +864,7 @@ static int vidioc_try_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		plane->sizeimage = pix_mp->width * pix_mp->height *
 			info->sizeimage_mult / info->sizeimage_div;
 		if (pix_mp->pixelformat == V4L2_PIX_FMT_FWHT)
-			plane->sizeimage += sizeof(struct cframe_hdr);
+			plane->sizeimage += sizeof(struct fwht_cframe_hdr);
 		memset(pix_mp->reserved, 0, sizeof(pix_mp->reserved));
 		memset(plane->reserved, 0, sizeof(plane->reserved));
 		break;
@@ -1308,7 +1309,7 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	ctx->ref_frame.width = ctx->ref_frame.height = 0;
 	ctx->ref_frame.luma = kvmalloc(size + 2 * size / chroma_div, GFP_KERNEL);
 	ctx->comp_max_size = size + 2 * size / chroma_div +
-			     sizeof(struct cframe_hdr);
+			     sizeof(struct fwht_cframe_hdr);
 	ctx->compressed_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
 	if (!ctx->ref_frame.luma || !ctx->compressed_frame) {
 		kvfree(ctx->ref_frame.luma);
@@ -1493,7 +1494,7 @@ static int vicodec_open(struct file *file)
 	ctx->q_data[V4L2_M2M_DST].sizeimage = size;
 	ctx->colorspace = V4L2_COLORSPACE_REC709;
 
-	size += sizeof(struct cframe_hdr);
+	size += sizeof(struct fwht_cframe_hdr);
 	if (ctx->is_enc) {
 		ctx->q_data[V4L2_M2M_DST].sizeimage = size;
 		ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->enc_dev, ctx,
-- 
2.18.0
