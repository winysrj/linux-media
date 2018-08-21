Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:45221 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726795AbeHUKu0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 06:50:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/6] vicodec: simplify flags handling
Date: Tue, 21 Aug 2018 09:31:16 +0200
Message-Id: <20180821073119.3662-4-hverkuil@xs4all.nl>
In-Reply-To: <20180821073119.3662-1-hverkuil@xs4all.nl>
References: <20180821073119.3662-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The flags field can be removed from struct vicodec_q_data.
This simplifies the flags handling elsewhere.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 26 +++++++++----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 806121805f8f..906a82508924 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -101,7 +101,6 @@ static struct platform_device vicodec_pdev = {
 struct vicodec_q_data {
 	unsigned int		width;
 	unsigned int		height;
-	unsigned int		flags;
 	unsigned int		sizeimage;
 	unsigned int		sequence;
 	const struct pixfmt_info *info;
@@ -191,7 +190,7 @@ static struct vicodec_q_data *get_q_data(struct vicodec_ctx *ctx,
 
 static void encode(struct vicodec_ctx *ctx,
 		   struct vicodec_q_data *q_data,
-		   u8 *p_in, u8 *p_out)
+		   u8 *p_in, u8 *p_out, u32 flags)
 {
 	unsigned int size = q_data->width * q_data->height;
 	const struct pixfmt_info *info = q_data->info;
@@ -296,17 +295,17 @@ static void encode(struct vicodec_ctx *ctx,
 	p_hdr->version = htonl(VICODEC_VERSION);
 	p_hdr->width = htonl(cf.width);
 	p_hdr->height = htonl(cf.height);
-	p_hdr->flags = htonl(q_data->flags);
 	if (encoding & LUMA_UNENCODED)
-		p_hdr->flags |= htonl(VICODEC_FL_LUMA_IS_UNCOMPRESSED);
+		flags |= VICODEC_FL_LUMA_IS_UNCOMPRESSED;
 	if (encoding & CB_UNENCODED)
-		p_hdr->flags |= htonl(VICODEC_FL_CB_IS_UNCOMPRESSED);
+		flags |= VICODEC_FL_CB_IS_UNCOMPRESSED;
 	if (encoding & CR_UNENCODED)
-		p_hdr->flags |= htonl(VICODEC_FL_CR_IS_UNCOMPRESSED);
+		flags |= VICODEC_FL_CR_IS_UNCOMPRESSED;
 	if (rf.height_div == 1)
-		p_hdr->flags |= htonl(VICODEC_FL_CHROMA_FULL_HEIGHT);
+		flags |= VICODEC_FL_CHROMA_FULL_HEIGHT;
 	if (rf.width_div == 1)
-		p_hdr->flags |= htonl(VICODEC_FL_CHROMA_FULL_WIDTH);
+		flags |= VICODEC_FL_CHROMA_FULL_WIDTH;
+	p_hdr->flags = htonl(flags);
 	p_hdr->colorspace = htonl(ctx->colorspace);
 	p_hdr->xfer_func = htonl(ctx->xfer_func);
 	p_hdr->ycbcr_enc = htonl(ctx->ycbcr_enc);
@@ -323,6 +322,7 @@ static int decode(struct vicodec_ctx *ctx,
 	unsigned int size = q_data->width * q_data->height;
 	unsigned int chroma_size = size;
 	unsigned int i;
+	u32 flags;
 	struct cframe_hdr *p_hdr;
 	struct cframe cf;
 	u8 *p;
@@ -330,7 +330,7 @@ static int decode(struct vicodec_ctx *ctx,
 	p_hdr = (struct cframe_hdr *)p_in;
 	cf.width = ntohl(p_hdr->width);
 	cf.height = ntohl(p_hdr->height);
-	q_data->flags = ntohl(p_hdr->flags);
+	flags = ntohl(p_hdr->flags);
 	ctx->colorspace = ntohl(p_hdr->colorspace);
 	ctx->xfer_func = ntohl(p_hdr->xfer_func);
 	ctx->ycbcr_enc = ntohl(p_hdr->ycbcr_enc);
@@ -351,12 +351,12 @@ static int decode(struct vicodec_ctx *ctx,
 	if (cf.width != q_data->width || cf.height != q_data->height)
 		return -EINVAL;
 
-	if (!(q_data->flags & VICODEC_FL_CHROMA_FULL_WIDTH))
+	if (!(flags & VICODEC_FL_CHROMA_FULL_WIDTH))
 		chroma_size /= 2;
-	if (!(q_data->flags & VICODEC_FL_CHROMA_FULL_HEIGHT))
+	if (!(flags & VICODEC_FL_CHROMA_FULL_HEIGHT))
 		chroma_size /= 2;
 
-	decode_frame(&cf, &ctx->ref_frame, q_data->flags);
+	decode_frame(&cf, &ctx->ref_frame, flags);
 
 	switch (q_data->info->id) {
 	case V4L2_PIX_FMT_YUV420:
@@ -489,7 +489,7 @@ static int device_process(struct vicodec_ctx *ctx,
 	if (ctx->is_enc) {
 		struct cframe_hdr *p_hdr = (struct cframe_hdr *)p_out;
 
-		encode(ctx, q_out, p_in, p_out);
+		encode(ctx, q_out, p_in, p_out, 0);
 		vb2_set_plane_payload(&out_vb->vb2_buf, 0,
 				      sizeof(*p_hdr) + ntohl(p_hdr->size));
 	} else {
-- 
2.18.0
