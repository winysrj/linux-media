Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:44554 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727690AbeIMTwG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 15:52:06 -0400
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH RESEND v2] staging: cedrus: Fix checkpatch issues
Date: Thu, 13 Sep 2018 16:42:04 +0200
Message-Id: <20180913144204.6810-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Checkpatch, when used with --strict, reports a number of issues on the
cedrus driver.

Fix those warnings, except for a few, minor, lines too long warnings.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---

Resent since some changes were left uncommitted.

Changes from v1:
  - Removed the find_control wrapping
  - Added the bit length to the required variable
  - Added __ to the macro arguments

 drivers/staging/media/sunxi/cedrus/cedrus.c   | 10 +++++-----
 drivers/staging/media/sunxi/cedrus/cedrus.h   |  8 +++++---
 .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 19 ++++++++++++++-----
 .../staging/media/sunxi/cedrus/cedrus_regs.h  | 18 ++++++++++--------
 .../staging/media/sunxi/cedrus/cedrus_video.c |  6 ++----
 5 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
index 1f5f20a1f849..82558455384a 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -48,7 +48,7 @@ void *cedrus_find_control_data(struct cedrus_ctx *ctx, u32 id)
 {
 	unsigned int i;
 
-	for (i = 0; ctx->ctrls[i] != NULL; i++)
+	for (i = 0; ctx->ctrls[i]; i++)
 		if (ctx->ctrls[i]->id == id)
 			return ctx->ctrls[i]->p_cur.p;
 
@@ -147,10 +147,10 @@ static int cedrus_request_validate(struct media_request *req)
 			continue;
 
 		ctrl_test = v4l2_ctrl_request_hdl_ctrl_find(hdl,
-			cedrus_controls[i].id);
+							    cedrus_controls[i].id);
 		if (!ctrl_test) {
 			v4l2_info(&ctx->dev->v4l2_dev,
-				 "Missing required codec control\n");
+				  "Missing required codec control\n");
 			return -ENOENT;
 		}
 	}
@@ -310,8 +310,8 @@ static int cedrus_probe(struct platform_device *pdev)
 	dev->mdev.ops = &cedrus_m2m_media_ops;
 	dev->v4l2_dev.mdev = &dev->mdev;
 
-	ret = v4l2_m2m_register_media_controller(dev->m2m_dev,
-			vfd, MEDIA_ENT_F_PROC_VIDEO_DECODER);
+	ret = v4l2_m2m_register_media_controller(dev->m2m_dev, vfd,
+						 MEDIA_ENT_F_PROC_VIDEO_DECODER);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev,
 			 "Failed to initialize V4L2 M2M media controller\n");
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.h b/drivers/staging/media/sunxi/cedrus/cedrus.h
index 3262341e8c9a..3f61248c57ac 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.h
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.h
@@ -44,7 +44,7 @@ struct cedrus_control {
 	u32			id;
 	u32			elem_size;
 	enum cedrus_codec	codec;
-	bool			required;
+	unsigned char		required:1;
 };
 
 struct cedrus_mpeg2_run {
@@ -150,12 +150,14 @@ static inline dma_addr_t cedrus_dst_buf_addr(struct cedrus_ctx *ctx,
 	return buf ? cedrus_buf_addr(buf, &ctx->dst_fmt, plane) : 0;
 }
 
-static inline struct cedrus_buffer *vb2_v4l2_to_cedrus_buffer(const struct vb2_v4l2_buffer *p)
+static inline struct cedrus_buffer *
+vb2_v4l2_to_cedrus_buffer(const struct vb2_v4l2_buffer *p)
 {
 	return container_of(p, struct cedrus_buffer, m2m_buf.vb);
 }
 
-static inline struct cedrus_buffer *vb2_to_cedrus_buffer(const struct vb2_buffer *p)
+static inline struct cedrus_buffer *
+vb2_to_cedrus_buffer(const struct vb2_buffer *p)
 {
 	return vb2_v4l2_to_cedrus_buffer(to_vb2_v4l2_buffer(p));
 }
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
index 029eb1626bf4..9abd39cae38c 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
@@ -157,14 +157,22 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
 
 	/* Forward and backward prediction reference buffers. */
 
-	fwd_luma_addr = cedrus_dst_buf_addr(ctx, slice_params->forward_ref_index, 0);
-	fwd_chroma_addr = cedrus_dst_buf_addr(ctx, slice_params->forward_ref_index, 1);
+	fwd_luma_addr = cedrus_dst_buf_addr(ctx,
+					    slice_params->forward_ref_index,
+					    0);
+	fwd_chroma_addr = cedrus_dst_buf_addr(ctx,
+					      slice_params->forward_ref_index,
+					      1);
 
 	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_LUMA_ADDR, fwd_luma_addr);
 	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_CHROMA_ADDR, fwd_chroma_addr);
 
-	bwd_luma_addr = cedrus_dst_buf_addr(ctx, slice_params->backward_ref_index, 0);
-	bwd_chroma_addr = cedrus_dst_buf_addr(ctx, slice_params->backward_ref_index, 1);
+	bwd_luma_addr = cedrus_dst_buf_addr(ctx,
+					    slice_params->backward_ref_index,
+					    0);
+	bwd_chroma_addr = cedrus_dst_buf_addr(ctx,
+					      slice_params->backward_ref_index,
+					      1);
 
 	cedrus_write(dev, VE_DEC_MPEG_BWD_REF_LUMA_ADDR, bwd_luma_addr);
 	cedrus_write(dev, VE_DEC_MPEG_BWD_REF_CHROMA_ADDR, bwd_chroma_addr);
@@ -179,7 +187,8 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
 
 	/* Source offset and length in bits. */
 
-	cedrus_write(dev, VE_DEC_MPEG_VLD_OFFSET, slice_params->data_bit_offset);
+	cedrus_write(dev, VE_DEC_MPEG_VLD_OFFSET,
+		     slice_params->data_bit_offset);
 
 	reg = slice_params->bit_size - slice_params->data_bit_offset;
 	cedrus_write(dev, VE_DEC_MPEG_VLD_LEN, reg);
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_regs.h b/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
index 9b14d1fb94a0..de2d6b6f64bf 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_regs.h
@@ -71,12 +71,9 @@
 
 #define VE_DEC_MPEG_MP12HDR_SLICE_TYPE(t)	(((t) << 28) & GENMASK(30, 28))
 #define VE_DEC_MPEG_MP12HDR_F_CODE_SHIFT(x, y)	(24 - 4 * (y) - 8 * (x))
-#define VE_DEC_MPEG_MP12HDR_F_CODE_MASK(x, y) \
-	GENMASK(VE_DEC_MPEG_MP12HDR_F_CODE_SHIFT(x, y) + 3, \
-		VE_DEC_MPEG_MP12HDR_F_CODE_SHIFT(x, y))
-#define VE_DEC_MPEG_MP12HDR_F_CODE(x, y, v) \
-	(((v) << VE_DEC_MPEG_MP12HDR_F_CODE_SHIFT(x, y)) & \
-	 VE_DEC_MPEG_MP12HDR_F_CODE_MASK(x, y))
+#define VE_DEC_MPEG_MP12HDR_F_CODE(__x, __y, __v) \
+	(((__v) & GENMASK(3, 0)) << VE_DEC_MPEG_MP12HDR_F_CODE_SHIFT(__x, __y))
+
 #define VE_DEC_MPEG_MP12HDR_INTRA_DC_PRECISION(p) \
 	(((p) << 10) & GENMASK(11, 10))
 #define VE_DEC_MPEG_MP12HDR_INTRA_PICTURE_STRUCTURE(s) \
@@ -204,8 +201,13 @@
 #define VE_DEC_MPEG_VLD_ADDR_FIRST_PIC_DATA	BIT(30)
 #define VE_DEC_MPEG_VLD_ADDR_LAST_PIC_DATA	BIT(29)
 #define VE_DEC_MPEG_VLD_ADDR_VALID_PIC_DATA	BIT(28)
-#define VE_DEC_MPEG_VLD_ADDR_BASE(a) \
-	(((a) & GENMASK(27, 4)) | (((a) >> 28) & GENMASK(3, 0)))
+#define VE_DEC_MPEG_VLD_ADDR_BASE(a)					\
+	({								\
+		u32 _tmp = (a);						\
+		u32 _lo = _tmp & GENMASK(27, 4);			\
+		u32 _hi = (_tmp >> 28) & GENMASK(3, 0);			\
+		(_lo | _hi);						\
+	})
 
 #define VE_DEC_MPEG_VLD_OFFSET			(VE_ENGINE_DEC_MPEG + 0x2c)
 #define VE_DEC_MPEG_VLD_LEN			(VE_ENGINE_DEC_MPEG + 0x30)
diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
index d3887f8dea6a..5c5fce678b93 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
@@ -82,10 +82,7 @@ static struct cedrus_format *cedrus_find_format(u32 pixelformat, u32 directions,
 static bool cedrus_check_format(u32 pixelformat, u32 directions,
 				unsigned int capabilities)
 {
-	struct cedrus_format *fmt = cedrus_find_format(pixelformat, directions,
-						       capabilities);
-
-	return fmt != NULL;
+	return cedrus_find_format(pixelformat, directions, capabilities);
 }
 
 static void cedrus_prepare_format(struct v4l2_pix_format *pix_fmt)
@@ -494,6 +491,7 @@ static void cedrus_buf_request_complete(struct vb2_buffer *vb)
 
 	v4l2_ctrl_request_complete(vb->req_obj.req, &ctx->hdl);
 }
+
 static struct vb2_ops cedrus_qops = {
 	.queue_setup		= cedrus_queue_setup,
 	.buf_prepare		= cedrus_buf_prepare,
-- 
2.17.1
