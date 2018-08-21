Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:49602 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726739AbeHUKuZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 06:50:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/6] vicodec: add QP controls
Date: Tue, 21 Aug 2018 09:31:14 +0200
Message-Id: <20180821073119.3662-2-hverkuil@xs4all.nl>
In-Reply-To: <20180821073119.3662-1-hverkuil@xs4all.nl>
References: <20180821073119.3662-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Instead of hardcoding the quantization parameter (or 'DEADZONE_WIDTH'
as it was called in the codec) make this configurable through two
controls: one for I frames, one for P frames.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../media/platform/vicodec/vicodec-codec.c    | 17 ++++-----
 .../media/platform/vicodec/vicodec-codec.h    |  2 +
 drivers/media/platform/vicodec/vicodec-core.c | 38 +++++++++++++++++++
 3 files changed, 48 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-codec.c b/drivers/media/platform/vicodec/vicodec-codec.c
index 2d047646f614..7163f11b7ee8 100644
--- a/drivers/media/platform/vicodec/vicodec-codec.c
+++ b/drivers/media/platform/vicodec/vicodec-codec.c
@@ -13,7 +13,6 @@
 #include "vicodec-codec.h"
 
 #define ALL_ZEROS 15
-#define DEADZONE_WIDTH 20
 
 static const uint8_t zigzag[64] = {
 	0,
@@ -164,7 +163,7 @@ static const int quant_table_p[] = {
 	3, 3, 3, 6, 6, 9,  9,  10,
 };
 
-static void quantize_intra(s16 *coeff, s16 *de_coeff)
+static void quantize_intra(s16 *coeff, s16 *de_coeff, u16 qp)
 {
 	const int *quant = quant_table;
 	int i, j;
@@ -172,8 +171,7 @@ static void quantize_intra(s16 *coeff, s16 *de_coeff)
 	for (j = 0; j < 8; j++) {
 		for (i = 0; i < 8; i++, quant++, coeff++, de_coeff++) {
 			*coeff >>= *quant;
-			if (*coeff >= -DEADZONE_WIDTH &&
-			    *coeff <= DEADZONE_WIDTH)
+			if (*coeff >= -qp && *coeff <= qp)
 				*coeff = *de_coeff = 0;
 			else
 				*de_coeff = *coeff << *quant;
@@ -191,7 +189,7 @@ static void dequantize_intra(s16 *coeff)
 			*coeff <<= *quant;
 }
 
-static void quantize_inter(s16 *coeff, s16 *de_coeff)
+static void quantize_inter(s16 *coeff, s16 *de_coeff, u16 qp)
 {
 	const int *quant = quant_table_p;
 	int i, j;
@@ -199,8 +197,7 @@ static void quantize_inter(s16 *coeff, s16 *de_coeff)
 	for (j = 0; j < 8; j++) {
 		for (i = 0; i < 8; i++, quant++, coeff++, de_coeff++) {
 			*coeff >>= *quant;
-			if (*coeff >= -DEADZONE_WIDTH &&
-			    *coeff <= DEADZONE_WIDTH)
+			if (*coeff >= -qp && *coeff <= qp)
 				*coeff = *de_coeff = 0;
 			else
 				*de_coeff = *coeff << *quant;
@@ -639,13 +636,15 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
 					deltablock, width, input_step);
 			if (is_intra || blocktype == IBLOCK) {
 				fwht(input, cf->coeffs, width, input_step, 1);
-				quantize_intra(cf->coeffs, cf->de_coeffs);
+				quantize_intra(cf->coeffs, cf->de_coeffs,
+					       cf->i_frame_qp);
 				blocktype = IBLOCK;
 			} else {
 				/* inter code */
 				encoding |= FRAME_PCODED;
 				fwht16(deltablock, cf->coeffs, 8, 0);
-				quantize_inter(cf->coeffs, cf->de_coeffs);
+				quantize_inter(cf->coeffs, cf->de_coeffs,
+					       cf->p_frame_qp);
 			}
 			if (!next_is_intra) {
 				ifwht(cf->de_coeffs, cf->de_fwht, blocktype);
diff --git a/drivers/media/platform/vicodec/vicodec-codec.h b/drivers/media/platform/vicodec/vicodec-codec.h
index cdfad1332a3e..cabe7b98623b 100644
--- a/drivers/media/platform/vicodec/vicodec-codec.h
+++ b/drivers/media/platform/vicodec/vicodec-codec.h
@@ -103,6 +103,8 @@ struct cframe_hdr {
 
 struct cframe {
 	unsigned int width, height;
+	u16 i_frame_qp;
+	u16 p_frame_qp;
 	__be16 *rlc_data;
 	s16 coeffs[8 * 8];
 	s16 de_coeffs[8 * 8];
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 408cd55d3580..702fc6546d7a 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -97,8 +97,12 @@ struct vicodec_ctx {
 
 	struct v4l2_ctrl_handler hdl;
 	struct v4l2_ctrl	*ctrl_gop_size;
+	struct v4l2_ctrl	*ctrl_i_frame_qp;
+	struct v4l2_ctrl	*ctrl_p_frame_qp;
 	unsigned int		gop_size;
 	unsigned int		gop_cnt;
+	u16			i_frame_qp;
+	u16			p_frame_qp;
 
 	/* Abort requested by m2m */
 	int			aborting;
@@ -191,6 +195,8 @@ static void encode(struct vicodec_ctx *ctx,
 
 	cf.width = q_data->width;
 	cf.height = q_data->height;
+	cf.i_frame_qp = ctx->i_frame_qp;
+	cf.p_frame_qp = ctx->p_frame_qp;
 	cf.rlc_data = (__be16 *)(p_out + sizeof(*p_hdr));
 
 	encoding = encode_frame(&rf, &ctx->ref_frame, &cf, !ctx->gop_cnt,
@@ -1141,7 +1147,11 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	ctx->last_src_buf = NULL;
 	ctx->last_dst_buf = NULL;
 	v4l2_ctrl_grab(ctx->ctrl_gop_size, true);
+	v4l2_ctrl_grab(ctx->ctrl_i_frame_qp, true);
+	v4l2_ctrl_grab(ctx->ctrl_p_frame_qp, true);
 	ctx->gop_size = v4l2_ctrl_g_ctrl(ctx->ctrl_gop_size);
+	ctx->i_frame_qp = v4l2_ctrl_g_ctrl(ctx->ctrl_i_frame_qp);
+	ctx->p_frame_qp = v4l2_ctrl_g_ctrl(ctx->ctrl_p_frame_qp);
 	ctx->gop_cnt = 0;
 	ctx->cur_buf_offset = 0;
 	ctx->comp_size = 0;
@@ -1211,6 +1221,30 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	return vb2_queue_init(dst_vq);
 }
 
+#define VICODEC_CID_CUSTOM_BASE		(V4L2_CID_MPEG_BASE | 0xf000)
+#define VICODEC_CID_I_FRAME_QP		(VICODEC_CID_CUSTOM_BASE + 0)
+#define VICODEC_CID_P_FRAME_QP		(VICODEC_CID_CUSTOM_BASE + 1)
+
+static const struct v4l2_ctrl_config vicodec_ctrl_i_frame = {
+	.id = VICODEC_CID_I_FRAME_QP,
+	.name = "FWHT I-Frame QP Value",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 1,
+	.max = 31,
+	.def = 20,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config vicodec_ctrl_p_frame = {
+	.id = VICODEC_CID_P_FRAME_QP,
+	.name = "FWHT P-Frame QP Value",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 1,
+	.max = 31,
+	.def = 20,
+	.step = 1,
+};
+
 /*
  * File operations
  */
@@ -1242,6 +1276,10 @@ static int vicodec_open(struct file *file)
 	ctx->ctrl_gop_size = v4l2_ctrl_new_std(hdl, NULL,
 					       V4L2_CID_MPEG_VIDEO_GOP_SIZE,
 					       1, 16, 1, 10);
+	ctx->ctrl_i_frame_qp = v4l2_ctrl_new_custom(hdl, &vicodec_ctrl_i_frame,
+						    NULL);
+	ctx->ctrl_p_frame_qp = v4l2_ctrl_new_custom(hdl, &vicodec_ctrl_p_frame,
+						    NULL);
 	if (hdl->error) {
 		rc = hdl->error;
 		v4l2_ctrl_handler_free(hdl);
-- 
2.18.0
