Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:56612 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726668AbeHUKu0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 06:50:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/6] vicodec: add support for more pixel formats
Date: Tue, 21 Aug 2018 09:31:15 +0200
Message-Id: <20180821073119.3662-3-hverkuil@xs4all.nl>
In-Reply-To: <20180821073119.3662-1-hverkuil@xs4all.nl>
References: <20180821073119.3662-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for 4:2:2, 4:4:4 and RGB 24/32 bits formats.

This makes it a lot more useful, esp. as a simple video compression
codec for use with v4l2-ctl/qvidcap.

Note that it does not do any conversion between e.g. 4:2:2 and 4:2:0
or RGB and YUV: it still just compresses planes be they Y/U/V or R/G/B.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../media/platform/vicodec/vicodec-codec.c    |  62 ++-
 .../media/platform/vicodec/vicodec-codec.h    |   5 +
 drivers/media/platform/vicodec/vicodec-core.c | 357 +++++++++++++-----
 3 files changed, 324 insertions(+), 100 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-codec.c b/drivers/media/platform/vicodec/vicodec-codec.c
index 7163f11b7ee8..7bd11a974db0 100644
--- a/drivers/media/platform/vicodec/vicodec-codec.c
+++ b/drivers/media/platform/vicodec/vicodec-codec.c
@@ -229,7 +229,8 @@ static void fwht(const u8 *block, s16 *output_block, unsigned int stride,
 	stride *= input_step;
 
 	for (i = 0; i < 8; i++, tmp += stride, out += 8) {
-		if (input_step == 1) {
+		switch (input_step) {
+		case 1:
 			workspace1[0]  = tmp[0] + tmp[1] - add;
 			workspace1[1]  = tmp[0] - tmp[1];
 
@@ -241,7 +242,8 @@ static void fwht(const u8 *block, s16 *output_block, unsigned int stride,
 
 			workspace1[6]  = tmp[6] + tmp[7] - add;
 			workspace1[7]  = tmp[6] - tmp[7];
-		} else {
+			break;
+		case 2:
 			workspace1[0]  = tmp[0] + tmp[2] - add;
 			workspace1[1]  = tmp[0] - tmp[2];
 
@@ -253,6 +255,33 @@ static void fwht(const u8 *block, s16 *output_block, unsigned int stride,
 
 			workspace1[6]  = tmp[12] + tmp[14] - add;
 			workspace1[7]  = tmp[12] - tmp[14];
+			break;
+		case 3:
+			workspace1[0]  = tmp[0] + tmp[3] - add;
+			workspace1[1]  = tmp[0] - tmp[3];
+
+			workspace1[2]  = tmp[6] + tmp[9] - add;
+			workspace1[3]  = tmp[6] - tmp[9];
+
+			workspace1[4]  = tmp[12] + tmp[15] - add;
+			workspace1[5]  = tmp[12] - tmp[15];
+
+			workspace1[6]  = tmp[18] + tmp[21] - add;
+			workspace1[7]  = tmp[18] - tmp[21];
+			break;
+		default:
+			workspace1[0]  = tmp[0] + tmp[4] - add;
+			workspace1[1]  = tmp[0] - tmp[4];
+
+			workspace1[2]  = tmp[8] + tmp[12] - add;
+			workspace1[3]  = tmp[8] - tmp[12];
+
+			workspace1[4]  = tmp[16] + tmp[20] - add;
+			workspace1[5]  = tmp[16] - tmp[20];
+
+			workspace1[6]  = tmp[24] + tmp[28] - add;
+			workspace1[7]  = tmp[24] - tmp[28];
+			break;
 		}
 
 		/* stage 2 */
@@ -704,25 +733,28 @@ u32 encode_frame(struct raw_frame *frm, struct raw_frame *ref_frm,
 	__be16 *rlco = cf->rlc_data;
 	__be16 *rlco_max;
 	u32 encoding;
+	u32 chroma_h = frm->height / frm->height_div;
+	u32 chroma_w = frm->width / frm->width_div;
+	unsigned int chroma_size = chroma_h * chroma_w;
 
 	rlco_max = rlco + size / 2 - 256;
 	encoding = encode_plane(frm->luma, ref_frm->luma, &rlco, rlco_max, cf,
-				  frm->height, frm->width,
-				  1, is_intra, next_is_intra);
+				frm->height, frm->width,
+				frm->luma_step, is_intra, next_is_intra);
 	if (encoding & FRAME_UNENCODED)
 		encoding |= LUMA_UNENCODED;
 	encoding &= ~FRAME_UNENCODED;
-	rlco_max = rlco + size / 8 - 256;
+	rlco_max = rlco + chroma_size / 2 - 256;
 	encoding |= encode_plane(frm->cb, ref_frm->cb, &rlco, rlco_max, cf,
-				   frm->height / 2, frm->width / 2,
-				   frm->chroma_step, is_intra, next_is_intra);
+				 chroma_h, chroma_w,
+				 frm->chroma_step, is_intra, next_is_intra);
 	if (encoding & FRAME_UNENCODED)
 		encoding |= CB_UNENCODED;
 	encoding &= ~FRAME_UNENCODED;
-	rlco_max = rlco + size / 8 - 256;
+	rlco_max = rlco + chroma_size / 2 - 256;
 	encoding |= encode_plane(frm->cr, ref_frm->cr, &rlco, rlco_max, cf,
-				   frm->height / 2, frm->width / 2,
-				   frm->chroma_step, is_intra, next_is_intra);
+				 chroma_h, chroma_w,
+				 frm->chroma_step, is_intra, next_is_intra);
 	if (encoding & FRAME_UNENCODED)
 		encoding |= CR_UNENCODED;
 	encoding &= ~FRAME_UNENCODED;
@@ -786,11 +818,17 @@ static void decode_plane(struct cframe *cf, const __be16 **rlco, u8 *ref,
 void decode_frame(struct cframe *cf, struct raw_frame *ref, u32 hdr_flags)
 {
 	const __be16 *rlco = cf->rlc_data;
+	u32 h = cf->height / 2;
+	u32 w = cf->width / 2;
 
+	if (hdr_flags & VICODEC_FL_CHROMA_FULL_HEIGHT)
+		h *= 2;
+	if (hdr_flags & VICODEC_FL_CHROMA_FULL_WIDTH)
+		w *= 2;
 	decode_plane(cf, &rlco, ref->luma, cf->height, cf->width,
 		     hdr_flags & VICODEC_FL_LUMA_IS_UNCOMPRESSED);
-	decode_plane(cf, &rlco, ref->cb, cf->height / 2, cf->width / 2,
+	decode_plane(cf, &rlco, ref->cb, h, w,
 		     hdr_flags & VICODEC_FL_CB_IS_UNCOMPRESSED);
-	decode_plane(cf, &rlco, ref->cr, cf->height / 2, cf->width / 2,
+	decode_plane(cf, &rlco, ref->cr, h, w,
 		     hdr_flags & VICODEC_FL_CR_IS_UNCOMPRESSED);
 }
diff --git a/drivers/media/platform/vicodec/vicodec-codec.h b/drivers/media/platform/vicodec/vicodec-codec.h
index cabe7b98623b..ff69d9297ef4 100644
--- a/drivers/media/platform/vicodec/vicodec-codec.h
+++ b/drivers/media/platform/vicodec/vicodec-codec.h
@@ -87,6 +87,8 @@
 #define VICODEC_FL_LUMA_IS_UNCOMPRESSED	BIT(4)
 #define VICODEC_FL_CB_IS_UNCOMPRESSED	BIT(5)
 #define VICODEC_FL_CR_IS_UNCOMPRESSED	BIT(6)
+#define VICODEC_FL_CHROMA_FULL_HEIGHT	BIT(7)
+#define VICODEC_FL_CHROMA_FULL_WIDTH	BIT(8)
 
 struct cframe_hdr {
 	u32 magic1;
@@ -114,6 +116,9 @@ struct cframe {
 
 struct raw_frame {
 	unsigned int width, height;
+	unsigned int width_div;
+	unsigned int height_div;
+	unsigned int luma_step;
 	unsigned int chroma_step;
 	u8 *luma, *cb, *cr;
 };
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 702fc6546d7a..806121805f8f 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -48,6 +48,46 @@ MODULE_PARM_DESC(debug, " activates debug info");
 	v4l2_dbg(1, debug, &dev->v4l2_dev, "%s: " fmt, __func__, ## arg)
 
 
+struct pixfmt_info {
+	u32 id;
+	unsigned int bytesperline_mult;
+	unsigned int sizeimage_mult;
+	unsigned int sizeimage_div;
+	unsigned int luma_step;
+	unsigned int chroma_step;
+	/* Chroma plane subsampling */
+	unsigned int width_div;
+	unsigned int height_div;
+};
+
+static const struct pixfmt_info pixfmts[] = {
+	{ V4L2_PIX_FMT_YUV420,  1, 3, 2, 1, 1, 2, 2 },
+	{ V4L2_PIX_FMT_YVU420,  1, 3, 2, 1, 1, 2, 2 },
+	{ V4L2_PIX_FMT_YUV422P, 1, 2, 1, 1, 1, 2, 1 },
+	{ V4L2_PIX_FMT_NV12,    1, 3, 2, 1, 2, 2, 2 },
+	{ V4L2_PIX_FMT_NV21,    1, 3, 2, 1, 2, 2, 2 },
+	{ V4L2_PIX_FMT_NV16,    1, 2, 1, 1, 2, 2, 1 },
+	{ V4L2_PIX_FMT_NV61,    1, 2, 1, 1, 2, 2, 1 },
+	{ V4L2_PIX_FMT_NV24,    1, 3, 1, 1, 2, 1, 1 },
+	{ V4L2_PIX_FMT_NV42,    1, 3, 1, 1, 2, 1, 1 },
+	{ V4L2_PIX_FMT_YUYV,    2, 2, 1, 2, 4, 2, 1 },
+	{ V4L2_PIX_FMT_YVYU,    2, 2, 1, 2, 4, 2, 1 },
+	{ V4L2_PIX_FMT_UYVY,    2, 2, 1, 2, 4, 2, 1 },
+	{ V4L2_PIX_FMT_VYUY,    2, 2, 1, 2, 4, 2, 1 },
+	{ V4L2_PIX_FMT_BGR24,   3, 3, 1, 3, 3, 1, 1 },
+	{ V4L2_PIX_FMT_RGB24,   3, 3, 1, 3, 3, 1, 1 },
+	{ V4L2_PIX_FMT_HSV24,   3, 3, 1, 3, 3, 1, 1 },
+	{ V4L2_PIX_FMT_BGR32,   4, 4, 1, 4, 4, 1, 1 },
+	{ V4L2_PIX_FMT_XBGR32,  4, 4, 1, 4, 4, 1, 1 },
+	{ V4L2_PIX_FMT_RGB32,   4, 4, 1, 4, 4, 1, 1 },
+	{ V4L2_PIX_FMT_XRGB32,  4, 4, 1, 4, 4, 1, 1 },
+	{ V4L2_PIX_FMT_HSV32,   4, 4, 1, 4, 4, 1, 1 },
+};
+
+static const struct pixfmt_info pixfmt_fwht = {
+	V4L2_PIX_FMT_FWHT, 0, 3, 1, 1, 1, 1, 1
+};
+
 static void vicodec_dev_release(struct device *dev)
 {
 }
@@ -64,7 +104,7 @@ struct vicodec_q_data {
 	unsigned int		flags;
 	unsigned int		sizeimage;
 	unsigned int		sequence;
-	u32			fourcc;
+	const struct pixfmt_info *info;
 };
 
 enum {
@@ -127,13 +167,6 @@ struct vicodec_ctx {
 	bool			comp_has_next_frame;
 };
 
-static const u32 pixfmts_yuv[] = {
-	V4L2_PIX_FMT_YUV420,
-	V4L2_PIX_FMT_YVU420,
-	V4L2_PIX_FMT_NV12,
-	V4L2_PIX_FMT_NV21,
-};
-
 static inline struct vicodec_ctx *file2ctx(struct file *file)
 {
 	return container_of(file->private_data, struct vicodec_ctx, fh);
@@ -161,6 +194,7 @@ static void encode(struct vicodec_ctx *ctx,
 		   u8 *p_in, u8 *p_out)
 {
 	unsigned int size = q_data->width * q_data->height;
+	const struct pixfmt_info *info = q_data->info;
 	struct cframe_hdr *p_hdr;
 	struct cframe cf;
 	struct raw_frame rf;
@@ -169,27 +203,77 @@ static void encode(struct vicodec_ctx *ctx,
 	rf.width = q_data->width;
 	rf.height = q_data->height;
 	rf.luma = p_in;
+	rf.width_div = info->width_div;
+	rf.height_div = info->height_div;
+	rf.luma_step = info->luma_step;
+	rf.chroma_step = info->chroma_step;
 
-	switch (q_data->fourcc) {
+	switch (info->id) {
 	case V4L2_PIX_FMT_YUV420:
 		rf.cb = rf.luma + size;
 		rf.cr = rf.cb + size / 4;
-		rf.chroma_step = 1;
 		break;
 	case V4L2_PIX_FMT_YVU420:
 		rf.cr = rf.luma + size;
 		rf.cb = rf.cr + size / 4;
-		rf.chroma_step = 1;
+		break;
+	case V4L2_PIX_FMT_YUV422P:
+		rf.cb = rf.luma + size;
+		rf.cr = rf.cb + size / 2;
 		break;
 	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV24:
 		rf.cb = rf.luma + size;
 		rf.cr = rf.cb + 1;
-		rf.chroma_step = 2;
 		break;
 	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_NV61:
+	case V4L2_PIX_FMT_NV42:
 		rf.cr = rf.luma + size;
 		rf.cb = rf.cr + 1;
-		rf.chroma_step = 2;
+		break;
+	case V4L2_PIX_FMT_YUYV:
+		rf.cb = rf.luma + 1;
+		rf.cr = rf.cb + 2;
+		break;
+	case V4L2_PIX_FMT_YVYU:
+		rf.cr = rf.luma + 1;
+		rf.cb = rf.cr + 2;
+		break;
+	case V4L2_PIX_FMT_UYVY:
+		rf.cb = rf.luma;
+		rf.cr = rf.cb + 2;
+		rf.luma++;
+		break;
+	case V4L2_PIX_FMT_VYUY:
+		rf.cr = rf.luma;
+		rf.cb = rf.cr + 2;
+		rf.luma++;
+		break;
+	case V4L2_PIX_FMT_RGB24:
+	case V4L2_PIX_FMT_HSV24:
+		rf.cr = rf.luma;
+		rf.cb = rf.cr + 2;
+		rf.luma++;
+		break;
+	case V4L2_PIX_FMT_BGR24:
+		rf.cb = rf.luma;
+		rf.cr = rf.cb + 2;
+		rf.luma++;
+		break;
+	case V4L2_PIX_FMT_RGB32:
+	case V4L2_PIX_FMT_XRGB32:
+	case V4L2_PIX_FMT_HSV32:
+		rf.cr = rf.luma + 1;
+		rf.cb = rf.cr + 2;
+		rf.luma += 2;
+		break;
+	case V4L2_PIX_FMT_BGR32:
+	case V4L2_PIX_FMT_XBGR32:
+		rf.cb = rf.luma;
+		rf.cr = rf.cb + 2;
+		rf.luma++;
 		break;
 	}
 
@@ -219,6 +303,10 @@ static void encode(struct vicodec_ctx *ctx,
 		p_hdr->flags |= htonl(VICODEC_FL_CB_IS_UNCOMPRESSED);
 	if (encoding & CR_UNENCODED)
 		p_hdr->flags |= htonl(VICODEC_FL_CR_IS_UNCOMPRESSED);
+	if (rf.height_div == 1)
+		p_hdr->flags |= htonl(VICODEC_FL_CHROMA_FULL_HEIGHT);
+	if (rf.width_div == 1)
+		p_hdr->flags |= htonl(VICODEC_FL_CHROMA_FULL_WIDTH);
 	p_hdr->colorspace = htonl(ctx->colorspace);
 	p_hdr->xfer_func = htonl(ctx->xfer_func);
 	p_hdr->ycbcr_enc = htonl(ctx->ycbcr_enc);
@@ -233,6 +321,7 @@ static int decode(struct vicodec_ctx *ctx,
 		  u8 *p_in, u8 *p_out)
 {
 	unsigned int size = q_data->width * q_data->height;
+	unsigned int chroma_size = size;
 	unsigned int i;
 	struct cframe_hdr *p_hdr;
 	struct cframe cf;
@@ -262,32 +351,114 @@ static int decode(struct vicodec_ctx *ctx,
 	if (cf.width != q_data->width || cf.height != q_data->height)
 		return -EINVAL;
 
+	if (!(q_data->flags & VICODEC_FL_CHROMA_FULL_WIDTH))
+		chroma_size /= 2;
+	if (!(q_data->flags & VICODEC_FL_CHROMA_FULL_HEIGHT))
+		chroma_size /= 2;
+
 	decode_frame(&cf, &ctx->ref_frame, q_data->flags);
-	memcpy(p_out, ctx->ref_frame.luma, size);
-	p_out += size;
 
-	switch (q_data->fourcc) {
+	switch (q_data->info->id) {
 	case V4L2_PIX_FMT_YUV420:
-		memcpy(p_out, ctx->ref_frame.cb, size / 4);
-		p_out += size / 4;
-		memcpy(p_out, ctx->ref_frame.cr, size / 4);
+	case V4L2_PIX_FMT_YUV422P:
+		memcpy(p_out, ctx->ref_frame.luma, size);
+		p_out += size;
+		memcpy(p_out, ctx->ref_frame.cb, chroma_size);
+		p_out += chroma_size;
+		memcpy(p_out, ctx->ref_frame.cr, chroma_size);
 		break;
 	case V4L2_PIX_FMT_YVU420:
-		memcpy(p_out, ctx->ref_frame.cr, size / 4);
-		p_out += size / 4;
-		memcpy(p_out, ctx->ref_frame.cb, size / 4);
+		memcpy(p_out, ctx->ref_frame.luma, size);
+		p_out += size;
+		memcpy(p_out, ctx->ref_frame.cr, chroma_size);
+		p_out += chroma_size;
+		memcpy(p_out, ctx->ref_frame.cb, chroma_size);
 		break;
 	case V4L2_PIX_FMT_NV12:
-		for (i = 0, p = p_out; i < size / 4; i++, p += 2)
-			*p = ctx->ref_frame.cb[i];
-		for (i = 0, p = p_out + 1; i < size / 4; i++, p += 2)
-			*p = ctx->ref_frame.cr[i];
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV24:
+		memcpy(p_out, ctx->ref_frame.luma, size);
+		p_out += size;
+		for (i = 0, p = p_out; i < chroma_size; i++) {
+			*p++ = ctx->ref_frame.cb[i];
+			*p++ = ctx->ref_frame.cr[i];
+		}
 		break;
 	case V4L2_PIX_FMT_NV21:
-		for (i = 0, p = p_out; i < size / 4; i++, p += 2)
-			*p = ctx->ref_frame.cr[i];
-		for (i = 0, p = p_out + 1; i < size / 4; i++, p += 2)
-			*p = ctx->ref_frame.cb[i];
+	case V4L2_PIX_FMT_NV61:
+	case V4L2_PIX_FMT_NV42:
+		memcpy(p_out, ctx->ref_frame.luma, size);
+		p_out += size;
+		for (i = 0, p = p_out; i < chroma_size; i++) {
+			*p++ = ctx->ref_frame.cr[i];
+			*p++ = ctx->ref_frame.cb[i];
+		}
+		break;
+	case V4L2_PIX_FMT_YUYV:
+		for (i = 0, p = p_out; i < size; i += 2) {
+			*p++ = ctx->ref_frame.luma[i];
+			*p++ = ctx->ref_frame.cb[i / 2];
+			*p++ = ctx->ref_frame.luma[i + 1];
+			*p++ = ctx->ref_frame.cr[i / 2];
+		}
+		break;
+	case V4L2_PIX_FMT_YVYU:
+		for (i = 0, p = p_out; i < size; i += 2) {
+			*p++ = ctx->ref_frame.luma[i];
+			*p++ = ctx->ref_frame.cr[i / 2];
+			*p++ = ctx->ref_frame.luma[i + 1];
+			*p++ = ctx->ref_frame.cb[i / 2];
+		}
+		break;
+	case V4L2_PIX_FMT_UYVY:
+		for (i = 0, p = p_out; i < size; i += 2) {
+			*p++ = ctx->ref_frame.cb[i / 2];
+			*p++ = ctx->ref_frame.luma[i];
+			*p++ = ctx->ref_frame.cr[i / 2];
+			*p++ = ctx->ref_frame.luma[i + 1];
+		}
+		break;
+	case V4L2_PIX_FMT_VYUY:
+		for (i = 0, p = p_out; i < size; i += 2) {
+			*p++ = ctx->ref_frame.cr[i / 2];
+			*p++ = ctx->ref_frame.luma[i];
+			*p++ = ctx->ref_frame.cb[i / 2];
+			*p++ = ctx->ref_frame.luma[i + 1];
+		}
+		break;
+	case V4L2_PIX_FMT_RGB24:
+	case V4L2_PIX_FMT_HSV24:
+		for (i = 0, p = p_out; i < size; i++) {
+			*p++ = ctx->ref_frame.cr[i];
+			*p++ = ctx->ref_frame.luma[i];
+			*p++ = ctx->ref_frame.cb[i];
+		}
+		break;
+	case V4L2_PIX_FMT_BGR24:
+		for (i = 0, p = p_out; i < size; i++) {
+			*p++ = ctx->ref_frame.cb[i];
+			*p++ = ctx->ref_frame.luma[i];
+			*p++ = ctx->ref_frame.cr[i];
+		}
+		break;
+	case V4L2_PIX_FMT_RGB32:
+	case V4L2_PIX_FMT_XRGB32:
+	case V4L2_PIX_FMT_HSV32:
+		for (i = 0, p = p_out; i < size; i++) {
+			*p++ = 0;
+			*p++ = ctx->ref_frame.cr[i];
+			*p++ = ctx->ref_frame.luma[i];
+			*p++ = ctx->ref_frame.cb[i];
+		}
+		break;
+	case V4L2_PIX_FMT_BGR32:
+	case V4L2_PIX_FMT_XBGR32:
+		for (i = 0, p = p_out; i < size; i++) {
+			*p++ = ctx->ref_frame.cb[i];
+			*p++ = ctx->ref_frame.luma[i];
+			*p++ = ctx->ref_frame.cr[i];
+			*p++ = 0;
+		}
 		break;
 	}
 	return 0;
@@ -325,8 +496,7 @@ static int device_process(struct vicodec_ctx *ctx,
 		ret = decode(ctx, q_cap, p_in, p_out);
 		if (ret)
 			return ret;
-		vb2_set_plane_payload(&out_vb->vb2_buf, 0,
-				      q_cap->width * q_cap->height * 3 / 2);
+		vb2_set_plane_payload(&out_vb->vb2_buf, 0, q_cap->sizeimage);
 	}
 
 	out_vb->sequence = q_cap->sequence++;
@@ -526,14 +696,14 @@ static void job_abort(void *priv)
  * video ioctls
  */
 
-static u32 find_fmt(u32 fmt)
+static const struct pixfmt_info *find_fmt(u32 fmt)
 {
 	unsigned int i;
 
-	for (i = 0; i < ARRAY_SIZE(pixfmts_yuv); i++)
-		if (pixfmts_yuv[i] == fmt)
-			return fmt;
-	return pixfmts_yuv[0];
+	for (i = 0; i < ARRAY_SIZE(pixfmts); i++)
+		if (pixfmts[i].id == fmt)
+			return &pixfmts[i];
+	return &pixfmts[0];
 }
 
 static int vidioc_querycap(struct file *file, void *priv,
@@ -553,17 +723,17 @@ static int vidioc_querycap(struct file *file, void *priv,
 
 static int enum_fmt(struct v4l2_fmtdesc *f, bool is_enc, bool is_out)
 {
-	bool is_yuv = (is_enc && is_out) || (!is_enc && !is_out);
+	bool is_uncomp = (is_enc && is_out) || (!is_enc && !is_out);
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(f->type) && !multiplanar)
 		return -EINVAL;
 	if (!V4L2_TYPE_IS_MULTIPLANAR(f->type) && multiplanar)
 		return -EINVAL;
-	if (f->index >= (is_yuv ? ARRAY_SIZE(pixfmts_yuv) : 1))
+	if (f->index >= (is_uncomp ? ARRAY_SIZE(pixfmts) : 1))
 		return -EINVAL;
 
-	if (is_yuv)
-		f->pixelformat = pixfmts_yuv[f->index];
+	if (is_uncomp)
+		f->pixelformat = pixfmts[f->index].id;
 	else
 		f->pixelformat = V4L2_PIX_FMT_FWHT;
 	return 0;
@@ -591,12 +761,14 @@ static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 	struct vicodec_q_data *q_data;
 	struct v4l2_pix_format_mplane *pix_mp;
 	struct v4l2_pix_format *pix;
+	const struct pixfmt_info *info;
 
 	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
 	if (!vq)
 		return -EINVAL;
 
 	q_data = get_q_data(ctx, f->type);
+	info = q_data->info;
 
 	switch (f->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
@@ -607,11 +779,8 @@ static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		pix->width = q_data->width;
 		pix->height = q_data->height;
 		pix->field = V4L2_FIELD_NONE;
-		pix->pixelformat = q_data->fourcc;
-		if (q_data->fourcc == V4L2_PIX_FMT_FWHT)
-			pix->bytesperline = 0;
-		else
-			pix->bytesperline = q_data->width;
+		pix->pixelformat = info->id;
+		pix->bytesperline = q_data->width * info->bytesperline_mult;
 		pix->sizeimage = q_data->sizeimage;
 		pix->colorspace = ctx->colorspace;
 		pix->xfer_func = ctx->xfer_func;
@@ -627,12 +796,10 @@ static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		pix_mp->width = q_data->width;
 		pix_mp->height = q_data->height;
 		pix_mp->field = V4L2_FIELD_NONE;
-		pix_mp->pixelformat = q_data->fourcc;
+		pix_mp->pixelformat = info->id;
 		pix_mp->num_planes = 1;
-		if (q_data->fourcc == V4L2_PIX_FMT_FWHT)
-			pix_mp->plane_fmt[0].bytesperline = 0;
-		else
-			pix_mp->plane_fmt[0].bytesperline = q_data->width;
+		pix_mp->plane_fmt[0].bytesperline =
+				q_data->width * info->bytesperline_mult;
 		pix_mp->plane_fmt[0].sizeimage = q_data->sizeimage;
 		pix_mp->colorspace = ctx->colorspace;
 		pix_mp->xfer_func = ctx->xfer_func;
@@ -664,40 +831,44 @@ static int vidioc_try_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 {
 	struct v4l2_pix_format_mplane *pix_mp;
 	struct v4l2_pix_format *pix;
+	struct v4l2_plane_pix_format *plane;
+	const struct pixfmt_info *info = &pixfmt_fwht;
 
 	switch (f->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 		pix = &f->fmt.pix;
+		if (pix->pixelformat != V4L2_PIX_FMT_FWHT)
+			info = find_fmt(pix->pixelformat);
 		pix->width = clamp(pix->width, MIN_WIDTH, MAX_WIDTH) & ~7;
 		pix->height = clamp(pix->height, MIN_HEIGHT, MAX_HEIGHT) & ~7;
-		pix->bytesperline = pix->width;
-		pix->sizeimage = pix->width * pix->height * 3 / 2;
 		pix->field = V4L2_FIELD_NONE;
-		if (pix->pixelformat == V4L2_PIX_FMT_FWHT) {
-			pix->bytesperline = 0;
+		pix->bytesperline =
+			pix->width * info->bytesperline_mult;
+		pix->sizeimage = pix->width * pix->height *
+			info->sizeimage_mult / info->sizeimage_div;
+		if (pix->pixelformat == V4L2_PIX_FMT_FWHT)
 			pix->sizeimage += sizeof(struct cframe_hdr);
-		}
 		break;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
 		pix_mp = &f->fmt.pix_mp;
+		plane = pix_mp->plane_fmt;
+		if (pix_mp->pixelformat != V4L2_PIX_FMT_FWHT)
+			info = find_fmt(pix_mp->pixelformat);
+		pix_mp->num_planes = 1;
 		pix_mp->width = clamp(pix_mp->width, MIN_WIDTH, MAX_WIDTH) & ~7;
 		pix_mp->height =
 			clamp(pix_mp->height, MIN_HEIGHT, MAX_HEIGHT) & ~7;
-		pix_mp->plane_fmt[0].bytesperline = pix_mp->width;
-		pix_mp->plane_fmt[0].sizeimage =
-			pix_mp->width * pix_mp->height * 3 / 2;
 		pix_mp->field = V4L2_FIELD_NONE;
-		pix_mp->num_planes = 1;
-		if (pix_mp->pixelformat == V4L2_PIX_FMT_FWHT) {
-			pix_mp->plane_fmt[0].bytesperline = 0;
-			pix_mp->plane_fmt[0].sizeimage +=
-					sizeof(struct cframe_hdr);
-		}
+		plane->bytesperline =
+			pix_mp->width * info->bytesperline_mult;
+		plane->sizeimage = pix_mp->width * pix_mp->height *
+			info->sizeimage_mult / info->sizeimage_div;
+		if (pix_mp->pixelformat == V4L2_PIX_FMT_FWHT)
+			plane->sizeimage += sizeof(struct cframe_hdr);
 		memset(pix_mp->reserved, 0, sizeof(pix_mp->reserved));
-		memset(pix_mp->plane_fmt[0].reserved, 0,
-		       sizeof(pix_mp->plane_fmt[0].reserved));
+		memset(plane->reserved, 0, sizeof(plane->reserved));
 		break;
 	default:
 		return -EINVAL;
@@ -719,7 +890,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 			return -EINVAL;
 		pix = &f->fmt.pix;
 		pix->pixelformat = ctx->is_enc ? V4L2_PIX_FMT_FWHT :
-				   find_fmt(f->fmt.pix.pixelformat);
+				   find_fmt(f->fmt.pix.pixelformat)->id;
 		pix->colorspace = ctx->colorspace;
 		pix->xfer_func = ctx->xfer_func;
 		pix->ycbcr_enc = ctx->ycbcr_enc;
@@ -730,14 +901,11 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 			return -EINVAL;
 		pix_mp = &f->fmt.pix_mp;
 		pix_mp->pixelformat = ctx->is_enc ? V4L2_PIX_FMT_FWHT :
-				      find_fmt(pix_mp->pixelformat);
+				      find_fmt(pix_mp->pixelformat)->id;
 		pix_mp->colorspace = ctx->colorspace;
 		pix_mp->xfer_func = ctx->xfer_func;
 		pix_mp->ycbcr_enc = ctx->ycbcr_enc;
 		pix_mp->quantization = ctx->quantization;
-		memset(pix_mp->reserved, 0, sizeof(pix_mp->reserved));
-		memset(pix_mp->plane_fmt[0].reserved, 0,
-		       sizeof(pix_mp->plane_fmt[0].reserved));
 		break;
 	default:
 		return -EINVAL;
@@ -759,7 +927,7 @@ static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
 			return -EINVAL;
 		pix = &f->fmt.pix;
 		pix->pixelformat = !ctx->is_enc ? V4L2_PIX_FMT_FWHT :
-				   find_fmt(pix->pixelformat);
+				   find_fmt(pix->pixelformat)->id;
 		if (!pix->colorspace)
 			pix->colorspace = V4L2_COLORSPACE_REC709;
 		break;
@@ -768,7 +936,7 @@ static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
 			return -EINVAL;
 		pix_mp = &f->fmt.pix_mp;
 		pix_mp->pixelformat = !ctx->is_enc ? V4L2_PIX_FMT_FWHT :
-				      find_fmt(pix_mp->pixelformat);
+				      find_fmt(pix_mp->pixelformat)->id;
 		if (!pix_mp->colorspace)
 			pix_mp->colorspace = V4L2_COLORSPACE_REC709;
 		break;
@@ -801,14 +969,17 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		pix = &f->fmt.pix;
 		if (ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type))
 			fmt_changed =
-				q_data->fourcc != pix->pixelformat ||
+				q_data->info->id != pix->pixelformat ||
 				q_data->width != pix->width ||
 				q_data->height != pix->height;
 
 		if (vb2_is_busy(vq) && fmt_changed)
 			return -EBUSY;
 
-		q_data->fourcc = pix->pixelformat;
+		if (pix->pixelformat == V4L2_PIX_FMT_FWHT)
+			q_data->info = &pixfmt_fwht;
+		else
+			q_data->info = find_fmt(pix->pixelformat);
 		q_data->width = pix->width;
 		q_data->height = pix->height;
 		q_data->sizeimage = pix->sizeimage;
@@ -818,14 +989,17 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		pix_mp = &f->fmt.pix_mp;
 		if (ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type))
 			fmt_changed =
-				q_data->fourcc != pix_mp->pixelformat ||
+				q_data->info->id != pix_mp->pixelformat ||
 				q_data->width != pix_mp->width ||
 				q_data->height != pix_mp->height;
 
 		if (vb2_is_busy(vq) && fmt_changed)
 			return -EBUSY;
 
-		q_data->fourcc = pix_mp->pixelformat;
+		if (pix_mp->pixelformat == V4L2_PIX_FMT_FWHT)
+			q_data->info = &pixfmt_fwht;
+		else
+			q_data->info = find_fmt(pix_mp->pixelformat);
 		q_data->width = pix_mp->width;
 		q_data->height = pix_mp->height;
 		q_data->sizeimage = pix_mp->plane_fmt[0].sizeimage;
@@ -836,7 +1010,7 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 
 	dprintk(ctx->dev,
 		"Setting format for type %d, wxh: %dx%d, fourcc: %08x\n",
-		f->type, q_data->width, q_data->height, q_data->fourcc);
+		f->type, q_data->width, q_data->height, q_data->info->id);
 
 	return 0;
 }
@@ -968,7 +1142,7 @@ static int vicodec_enum_framesizes(struct file *file, void *fh,
 	case V4L2_PIX_FMT_FWHT:
 		break;
 	default:
-		if (find_fmt(fsize->pixel_format) == fsize->pixel_format)
+		if (find_fmt(fsize->pixel_format)->id == fsize->pixel_format)
 			break;
 		return -EINVAL;
 	}
@@ -1126,6 +1300,8 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	struct vicodec_ctx *ctx = vb2_get_drv_priv(q);
 	struct vicodec_q_data *q_data = get_q_data(ctx, q->type);
 	unsigned int size = q_data->width * q_data->height;
+	const struct pixfmt_info *info = q_data->info;
+	unsigned int chroma_div = info->width_div * info->height_div;
 
 	q_data->sequence = 0;
 
@@ -1133,8 +1309,9 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 		return 0;
 
 	ctx->ref_frame.width = ctx->ref_frame.height = 0;
-	ctx->ref_frame.luma = kvmalloc(size * 3 / 2, GFP_KERNEL);
-	ctx->comp_max_size = size * 3 / 2 + sizeof(struct cframe_hdr);
+	ctx->ref_frame.luma = kvmalloc(size + 2 * size / chroma_div, GFP_KERNEL);
+	ctx->comp_max_size = size + 2 * size / chroma_div +
+			     sizeof(struct cframe_hdr);
 	ctx->compressed_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
 	if (!ctx->ref_frame.luma || !ctx->compressed_frame) {
 		kvfree(ctx->ref_frame.luma);
@@ -1143,7 +1320,7 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 		return -ENOMEM;
 	}
 	ctx->ref_frame.cb = ctx->ref_frame.luma + size;
-	ctx->ref_frame.cr = ctx->ref_frame.cb + size / 4;
+	ctx->ref_frame.cr = ctx->ref_frame.cb + size / chroma_div;
 	ctx->last_src_buf = NULL;
 	ctx->last_dst_buf = NULL;
 	v4l2_ctrl_grab(ctx->ctrl_gop_size, true);
@@ -1289,15 +1466,19 @@ static int vicodec_open(struct file *file)
 	ctx->fh.ctrl_handler = hdl;
 	v4l2_ctrl_handler_setup(hdl);
 
-	ctx->q_data[V4L2_M2M_SRC].fourcc =
-		ctx->is_enc ? V4L2_PIX_FMT_YUV420 : V4L2_PIX_FMT_FWHT;
+	ctx->q_data[V4L2_M2M_SRC].info =
+		ctx->is_enc ? pixfmts : &pixfmt_fwht;
 	ctx->q_data[V4L2_M2M_SRC].width = 1280;
 	ctx->q_data[V4L2_M2M_SRC].height = 720;
-	size = 1280 * 720 * 3 / 2;
+	size = 1280 * 720 * ctx->q_data[V4L2_M2M_SRC].info->sizeimage_mult /
+		ctx->q_data[V4L2_M2M_SRC].info->sizeimage_div;
 	ctx->q_data[V4L2_M2M_SRC].sizeimage = size;
 	ctx->q_data[V4L2_M2M_DST] = ctx->q_data[V4L2_M2M_SRC];
-	ctx->q_data[V4L2_M2M_DST].fourcc =
-		ctx->is_enc ? V4L2_PIX_FMT_FWHT : V4L2_PIX_FMT_YUV420;
+	ctx->q_data[V4L2_M2M_DST].info =
+		ctx->is_enc ? &pixfmt_fwht : pixfmts;
+	size = 1280 * 720 * ctx->q_data[V4L2_M2M_DST].info->sizeimage_mult /
+		ctx->q_data[V4L2_M2M_DST].info->sizeimage_div;
+	ctx->q_data[V4L2_M2M_DST].sizeimage = size;
 	ctx->colorspace = V4L2_COLORSPACE_REC709;
 
 	size += sizeof(struct cframe_hdr);
-- 
2.18.0
