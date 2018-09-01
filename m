Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:42320 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726991AbeIAQuH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Sep 2018 12:50:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vicodec: fix wrong sizeimage
To: linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <c1d3156b-36db-556e-1979-0ade12a2acac@xs4all.nl>
Date: Sat, 1 Sep 2018 14:38:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The initial sizeimage for the compressed decoder output was wrong.
The size of the output was incorrectly used to calculate the image
size, that should have been the size of the capture.

Rework the code to fix this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index fdd77441a47b..47e9ad0941ab 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -1186,23 +1186,28 @@ static int vicodec_open(struct file *file)
 	ctx->q_data[V4L2_M2M_SRC].height = 720;
 	size = 1280 * 720 * ctx->q_data[V4L2_M2M_SRC].info->sizeimage_mult /
 		ctx->q_data[V4L2_M2M_SRC].info->sizeimage_div;
-	ctx->q_data[V4L2_M2M_SRC].sizeimage = size;
+	if (ctx->is_enc)
+		ctx->q_data[V4L2_M2M_SRC].sizeimage = size;
+	else
+		ctx->q_data[V4L2_M2M_SRC].sizeimage =
+			size + sizeof(struct fwht_cframe_hdr);
 	ctx->q_data[V4L2_M2M_DST] = ctx->q_data[V4L2_M2M_SRC];
 	ctx->q_data[V4L2_M2M_DST].info =
 		ctx->is_enc ? &pixfmt_fwht : v4l2_fwht_get_pixfmt(0);
 	size = 1280 * 720 * ctx->q_data[V4L2_M2M_DST].info->sizeimage_mult /
 		ctx->q_data[V4L2_M2M_DST].info->sizeimage_div;
-	ctx->q_data[V4L2_M2M_DST].sizeimage = size;
+	if (ctx->is_enc)
+		ctx->q_data[V4L2_M2M_DST].sizeimage =
+			size + sizeof(struct fwht_cframe_hdr);
+	else
+		ctx->q_data[V4L2_M2M_DST].sizeimage = size;
 	ctx->state.colorspace = V4L2_COLORSPACE_REC709;

-	size += sizeof(struct fwht_cframe_hdr);
 	if (ctx->is_enc) {
-		ctx->q_data[V4L2_M2M_DST].sizeimage = size;
 		ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->enc_dev, ctx,
 						    &queue_init);
 		ctx->lock = &dev->enc_lock;
 	} else {
-		ctx->q_data[V4L2_M2M_SRC].sizeimage = size;
 		ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->dec_dev, ctx,
 						    &queue_init);
 		ctx->lock = &dev->dec_lock;
