Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51167 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbeKOVcP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 16:32:15 -0500
Received: by mail-wm1-f68.google.com with SMTP id 124-v6so18582626wmw.0
        for <linux-media@vger.kernel.org>; Thu, 15 Nov 2018 03:24:47 -0800 (PST)
From: Dafna Hirschfeld <dafna3@gmail.com>
To: helen.koike@collabora.com, hverkuil@xs4all.nl, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, Dafna Hirschfeld <dafna3@gmail.com>,
        outreachy-kernel@googlegroups.com
Subject: [PATCH vicodec v4 2/3] media: vicodec: Add support of greyscale format
Date: Thu, 15 Nov 2018 13:23:31 +0200
Message-Id: <e7f42f1167e4461f9141bf2a2aa056fd76a14540.1541451484.git.dafna3@gmail.com>
In-Reply-To: <cover.1541451484.git.dafna3@gmail.com>
References: <cover.1541451484.git.dafna3@gmail.com>
In-Reply-To: <cover.1541451484.git.dafna3@gmail.com>
References: <cover.1541451484.git.dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for single plane greyscale format V4L2_PIX_FMT_GREY.
Also change the header of the encoded file to include the number
of components.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/codec-fwht.c   | 56 +++++++++++--------
 drivers/media/platform/vicodec/codec-fwht.h   |  8 ++-
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 44 ++++++++++++---
 drivers/media/platform/vicodec/vicodec-core.c | 25 +++++++--
 4 files changed, 93 insertions(+), 40 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
index 4ee6d7e0fbe2..1af9af84163e 100644
--- a/drivers/media/platform/vicodec/codec-fwht.c
+++ b/drivers/media/platform/vicodec/codec-fwht.c
@@ -753,9 +753,6 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 	__be16 *rlco = cf->rlc_data;
 	__be16 *rlco_max;
 	u32 encoding;
-	u32 chroma_h = frm->height / frm->height_div;
-	u32 chroma_w = frm->width / frm->width_div;
-	unsigned int chroma_size = chroma_h * chroma_w;
 
 	rlco_max = rlco + size / 2 - 256;
 	encoding = encode_plane(frm->luma, ref_frm->luma, &rlco, rlco_max, cf,
@@ -764,20 +761,27 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 	if (encoding & FWHT_FRAME_UNENCODED)
 		encoding |= FWHT_LUMA_UNENCODED;
 	encoding &= ~FWHT_FRAME_UNENCODED;
-	rlco_max = rlco + chroma_size / 2 - 256;
-	encoding |= encode_plane(frm->cb, ref_frm->cb, &rlco, rlco_max, cf,
+
+	if (frm->components_num >= 3) {
+		u32 chroma_h = frm->height / frm->height_div;
+		u32 chroma_w = frm->width / frm->width_div;
+		unsigned int chroma_size = chroma_h * chroma_w;
+
+		rlco_max = rlco + chroma_size / 2 - 256;
+		encoding |= encode_plane(frm->cb, ref_frm->cb, &rlco, rlco_max, cf,
 				 chroma_h, chroma_w,
 				 frm->chroma_step, is_intra, next_is_intra);
-	if (encoding & FWHT_FRAME_UNENCODED)
-		encoding |= FWHT_CB_UNENCODED;
-	encoding &= ~FWHT_FRAME_UNENCODED;
-	rlco_max = rlco + chroma_size / 2 - 256;
-	encoding |= encode_plane(frm->cr, ref_frm->cr, &rlco, rlco_max, cf,
+		if (encoding & FWHT_FRAME_UNENCODED)
+			encoding |= FWHT_CB_UNENCODED;
+		encoding &= ~FWHT_FRAME_UNENCODED;
+		rlco_max = rlco + chroma_size / 2 - 256;
+		encoding |= encode_plane(frm->cr, ref_frm->cr, &rlco, rlco_max, cf,
 				 chroma_h, chroma_w,
 				 frm->chroma_step, is_intra, next_is_intra);
-	if (encoding & FWHT_FRAME_UNENCODED)
-		encoding |= FWHT_CR_UNENCODED;
-	encoding &= ~FWHT_FRAME_UNENCODED;
+		if (encoding & FWHT_FRAME_UNENCODED)
+			encoding |= FWHT_CR_UNENCODED;
+		encoding &= ~FWHT_FRAME_UNENCODED;
+	}
 	cf->size = (rlco - cf->rlc_data) * sizeof(*rlco);
 	return encoding;
 }
@@ -836,20 +840,24 @@ static void decode_plane(struct fwht_cframe *cf, const __be16 **rlco, u8 *ref,
 }
 
 void fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
-		       u32 hdr_flags)
+		       u32 hdr_flags, unsigned int components_num)
 {
 	const __be16 *rlco = cf->rlc_data;
-	u32 h = cf->height / 2;
-	u32 w = cf->width / 2;
 
-	if (hdr_flags & FWHT_FL_CHROMA_FULL_HEIGHT)
-		h *= 2;
-	if (hdr_flags & FWHT_FL_CHROMA_FULL_WIDTH)
-		w *= 2;
 	decode_plane(cf, &rlco, ref->luma, cf->height, cf->width,
 		     hdr_flags & FWHT_FL_LUMA_IS_UNCOMPRESSED);
-	decode_plane(cf, &rlco, ref->cb, h, w,
-		     hdr_flags & FWHT_FL_CB_IS_UNCOMPRESSED);
-	decode_plane(cf, &rlco, ref->cr, h, w,
-		     hdr_flags & FWHT_FL_CR_IS_UNCOMPRESSED);
+
+	if (components_num >= 3) {
+		u32 h = cf->height;
+		u32 w = cf->width;
+
+		if (!(hdr_flags & FWHT_FL_CHROMA_FULL_HEIGHT))
+			h /= 2;
+		if (!(hdr_flags & FWHT_FL_CHROMA_FULL_WIDTH))
+			w /= 2;
+		decode_plane(cf, &rlco, ref->cb, h, w,
+			hdr_flags & FWHT_FL_CB_IS_UNCOMPRESSED);
+		decode_plane(cf, &rlco, ref->cr, h, w,
+			hdr_flags & FWHT_FL_CR_IS_UNCOMPRESSED);
+	}
 }
diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
index 743d78e112f8..bde11fb93f26 100644
--- a/drivers/media/platform/vicodec/codec-fwht.h
+++ b/drivers/media/platform/vicodec/codec-fwht.h
@@ -56,7 +56,7 @@
 #define FWHT_MAGIC1 0x4f4f4f4f
 #define FWHT_MAGIC2 0xffffffff
 
-#define FWHT_VERSION 1
+#define FWHT_VERSION 2
 
 /* Set if this is an interlaced format */
 #define FWHT_FL_IS_INTERLACED		BIT(0)
@@ -76,6 +76,10 @@
 #define FWHT_FL_CHROMA_FULL_HEIGHT	BIT(7)
 #define FWHT_FL_CHROMA_FULL_WIDTH	BIT(8)
 
+/* A 4-values flag - the number of components - 1 */
+#define FWHT_FL_COMPONENTS_NUM_MSK	GENMASK(17, 16)
+#define FWHT_FL_COMPONENTS_NUM_OFFSET	16
+
 struct fwht_cframe_hdr {
 	u32 magic1;
 	u32 magic2;
@@ -121,6 +125,6 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 		      struct fwht_cframe *cf,
 		      bool is_intra, bool next_is_intra);
 void fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
-		       u32 hdr_flags);
+		       u32 hdr_flags, unsigned int components_num);
 
 #endif
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index b842636e71a9..7dc3918a017e 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -11,6 +11,7 @@
 #include "codec-v4l2-fwht.h"
 
 static const struct v4l2_fwht_pixfmt_info v4l2_fwht_pixfmts[] = {
+	{ V4L2_PIX_FMT_GREY,    1, 1, 1, 1, 0, 1, 1, 1},
 	{ V4L2_PIX_FMT_YUV420,  1, 3, 2, 1, 1, 2, 2, 3},
 	{ V4L2_PIX_FMT_YVU420,  1, 3, 2, 1, 1, 2, 2, 3},
 	{ V4L2_PIX_FMT_YUV422P, 1, 2, 1, 1, 1, 2, 1, 3},
@@ -75,6 +76,10 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	rf.components_num = info->components_num;
 
 	switch (info->id) {
+	case V4L2_PIX_FMT_GREY:
+		rf.cb = NULL;
+		rf.cr = NULL;
+		break;
 	case V4L2_PIX_FMT_YUV420:
 		rf.cb = rf.luma + size;
 		rf.cr = rf.cb + size / 4;
@@ -165,6 +170,7 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	p_hdr->version = htonl(FWHT_VERSION);
 	p_hdr->width = htonl(cf.width);
 	p_hdr->height = htonl(cf.height);
+	flags |= (info->components_num - 1) << FWHT_FL_COMPONENTS_NUM_OFFSET;
 	if (encoding & FWHT_LUMA_UNENCODED)
 		flags |= FWHT_FL_LUMA_IS_UNCOMPRESSED;
 	if (encoding & FWHT_CB_UNENCODED)
@@ -195,6 +201,8 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	struct fwht_cframe_hdr *p_hdr;
 	struct fwht_cframe cf;
 	u8 *p;
+	unsigned int components_num = 3;
+	unsigned int version;
 
 	if (!state->info)
 		return -EINVAL;
@@ -202,16 +210,16 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	p_hdr = (struct fwht_cframe_hdr *)p_in;
 	cf.width = ntohl(p_hdr->width);
 	cf.height = ntohl(p_hdr->height);
-	flags = ntohl(p_hdr->flags);
-	state->colorspace = ntohl(p_hdr->colorspace);
-	state->xfer_func = ntohl(p_hdr->xfer_func);
-	state->ycbcr_enc = ntohl(p_hdr->ycbcr_enc);
-	state->quantization = ntohl(p_hdr->quantization);
-	cf.rlc_data = (__be16 *)(p_in + sizeof(*p_hdr));
+
+	version = ntohl(p_hdr->version);
+	if (!version || version > FWHT_VERSION) {
+		pr_err("version %d is not supported, current version is %d\n",
+				version, FWHT_VERSION);
+		return -EINVAL;
+	}
 
 	if (p_hdr->magic1 != FWHT_MAGIC1 ||
 	    p_hdr->magic2 != FWHT_MAGIC2 ||
-	    ntohl(p_hdr->version) != FWHT_VERSION ||
 	    (cf.width & 7) || (cf.height & 7))
 		return -EINVAL;
 
@@ -219,14 +227,34 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	if (cf.width != state->width || cf.height != state->height)
 		return -EINVAL;
 
+	flags = ntohl(p_hdr->flags);
+
+	if (version == FWHT_VERSION) {
+		components_num = 1 + ((flags & FWHT_FL_COMPONENTS_NUM_MSK) >>
+			FWHT_FL_COMPONENTS_NUM_OFFSET);
+	}
+
+	state->colorspace = ntohl(p_hdr->colorspace);
+	state->xfer_func = ntohl(p_hdr->xfer_func);
+	state->ycbcr_enc = ntohl(p_hdr->ycbcr_enc);
+	state->quantization = ntohl(p_hdr->quantization);
+	cf.rlc_data = (__be16 *)(p_in + sizeof(*p_hdr));
+
 	if (!(flags & FWHT_FL_CHROMA_FULL_WIDTH))
 		chroma_size /= 2;
 	if (!(flags & FWHT_FL_CHROMA_FULL_HEIGHT))
 		chroma_size /= 2;
 
-	fwht_decode_frame(&cf, &state->ref_frame, flags);
+	fwht_decode_frame(&cf, &state->ref_frame, flags, components_num);
 
+	/*
+	 * TODO - handle the case where the compressed stream encodes a different
+	 * format than the requested decoded format.
+	 */
 	switch (state->info->id) {
+	case V4L2_PIX_FMT_GREY:
+		memcpy(p_out, state->ref_frame.luma, size);
+		break;
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YUV422P:
 		memcpy(p_out, state->ref_frame.luma, size);
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index fb6d5e9a06ab..92bc68694a21 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -993,6 +993,16 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	unsigned int size = q_data->width * q_data->height;
 	const struct v4l2_fwht_pixfmt_info *info = q_data->info;
 	unsigned int chroma_div = info->width_div * info->height_div;
+	unsigned int total_planes_size;
+
+	/*
+	 * we don't know ahead how many components are in the encoding type
+	 * V4L2_PIX_FMT_FWHT, so we will allocate space for 3 planes.
+	 */
+	if (info->id == V4L2_PIX_FMT_FWHT || info->components_num >= 3)
+		total_planes_size = size + 2 * (size / chroma_div);
+	else
+		total_planes_size = size;
 
 	q_data->sequence = 0;
 
@@ -1002,10 +1012,8 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	state->width = q_data->width;
 	state->height = q_data->height;
 	state->ref_frame.width = state->ref_frame.height = 0;
-	state->ref_frame.luma = kvmalloc(size + 2 * size / chroma_div,
-					 GFP_KERNEL);
-	ctx->comp_max_size = size + 2 * size / chroma_div +
-			     sizeof(struct fwht_cframe_hdr);
+	state->ref_frame.luma = kvmalloc(total_planes_size, GFP_KERNEL);
+	ctx->comp_max_size = total_planes_size + sizeof(struct fwht_cframe_hdr);
 	state->compressed_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
 	if (!state->ref_frame.luma || !state->compressed_frame) {
 		kvfree(state->ref_frame.luma);
@@ -1013,8 +1021,13 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 		vicodec_return_bufs(q, VB2_BUF_STATE_QUEUED);
 		return -ENOMEM;
 	}
-	state->ref_frame.cb = state->ref_frame.luma + size;
-	state->ref_frame.cr = state->ref_frame.cb + size / chroma_div;
+	if (info->id == V4L2_PIX_FMT_FWHT || info->components_num >= 3) {
+		state->ref_frame.cb = state->ref_frame.luma + size;
+		state->ref_frame.cr = state->ref_frame.cb + size / chroma_div;
+	} else {
+		state->ref_frame.cb = NULL;
+		state->ref_frame.cr = NULL;
+	}
 	ctx->last_src_buf = NULL;
 	ctx->last_dst_buf = NULL;
 	state->gop_cnt = 0;
-- 
2.17.1
