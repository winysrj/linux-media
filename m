Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:37481 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727335AbeGSL1p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 07:27:45 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de
Subject: [PATCH v2] media: coda: add SPS fixup code for frame sizes that are not multiples of 16
Date: Thu, 19 Jul 2018 12:45:10 +0200
Message-Id: <20180719104510.6903-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CODA7541 firmware does not set the SPS frame cropping fields to
properly describe coded h.264 streams with frame sizes that are not a
multiple of the macroblock size.
This adds RBSP parsing code and a SPS fixup routine to manually replace
the cropping information in the headers produced by the firmware with
the correct values.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1 [1]:
 - renamed coda_sps_fixup to coda_h264_sps_fixup
 - added comments
 - only call coda_h264_sps_fixup on CODA7541 and older

[1] https://patchwork.linuxtv.org/patch/50650/
---
 drivers/media/platform/coda/coda-bit.c  |  20 ++
 drivers/media/platform/coda/coda-h264.c | 316 ++++++++++++++++++++++++
 drivers/media/platform/coda/coda.h      |   2 +
 3 files changed, 338 insertions(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index c255c8e9db52..15ceaed03872 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1215,6 +1215,26 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 		if (ret < 0)
 			goto out;
 
+		/*
+		 * If visible width or height are not aligned to macroblock
+		 * size, the crop_right and crop_bottom SPS fields must be set
+		 * to the difference between visible and coded size.  This is
+		 * only supported by CODA960 firmware. All others do not allow
+		 * writing frame cropping parameters, so we have to manually
+		 * fix up the SPS RBSP ourselves.
+		 */
+		if (ctx->dev->devtype->product != CODA_960 &&
+		    ((q_data_src->rect.width % 16) ||
+		     (q_data_src->rect.height % 16))) {
+			ret = coda_h264_sps_fixup(ctx, q_data_src->rect.width,
+						  q_data_src->rect.height,
+						  &ctx->vpu_header[0][0],
+						  &ctx->vpu_header_size[0],
+						  sizeof(ctx->vpu_header[0]));
+			if (ret < 0)
+				goto out;
+		}
+
 		/*
 		 * Get PPS in the first frame and copy it to an
 		 * intermediate buffer.
diff --git a/drivers/media/platform/coda/coda-h264.c b/drivers/media/platform/coda/coda-h264.c
index 07b4c706504f..635356a839cf 100644
--- a/drivers/media/platform/coda/coda-h264.c
+++ b/drivers/media/platform/coda/coda-h264.c
@@ -114,3 +114,319 @@ int coda_h264_level(int level_idc)
 	default: return -EINVAL;
 	}
 }
+
+struct rbsp {
+	char *buf;
+	int size;
+	int pos;
+};
+
+static inline int rbsp_read_bit(struct rbsp *rbsp)
+{
+	int shift = 7 - (rbsp->pos % 8);
+	int ofs = rbsp->pos++ / 8;
+
+	if (ofs >= rbsp->size)
+		return -EINVAL;
+
+	return (rbsp->buf[ofs] >> shift) & 1;
+}
+
+static inline int rbsp_write_bit(struct rbsp *rbsp, int bit)
+{
+	int shift = 7 - (rbsp->pos % 8);
+	int ofs = rbsp->pos++ / 8;
+
+	if (ofs >= rbsp->size)
+		return -EINVAL;
+
+	rbsp->buf[ofs] &= ~(1 << shift);
+	rbsp->buf[ofs] |= bit << shift;
+
+	return 0;
+}
+
+static inline int rbsp_read_bits(struct rbsp *rbsp, int num, int *val)
+{
+	int i, ret;
+	int tmp = 0;
+
+	if (num > 32)
+		return -EINVAL;
+
+	for (i = 0; i < num; i++) {
+		ret = rbsp_read_bit(rbsp);
+		if (ret < 0)
+			return ret;
+		tmp |= ret << (num - i - 1);
+	}
+
+	if (val)
+		*val = tmp;
+
+	return 0;
+}
+
+static int rbsp_write_bits(struct rbsp *rbsp, int num, int value)
+{
+	int ret;
+
+	while (num--) {
+		ret = rbsp_write_bit(rbsp, (value >> num) & 1);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int rbsp_read_uev(struct rbsp *rbsp, unsigned int *val)
+{
+	int leading_zero_bits = 0;
+	unsigned int tmp = 0;
+	int ret;
+
+	while ((ret = rbsp_read_bit(rbsp)) == 0)
+		leading_zero_bits++;
+	if (ret < 0)
+		return ret;
+
+	if (leading_zero_bits > 0) {
+		ret = rbsp_read_bits(rbsp, leading_zero_bits, &tmp);
+		if (ret)
+			return ret;
+	}
+
+	if (val)
+		*val = (1 << leading_zero_bits) - 1 + tmp;
+
+	return 0;
+}
+
+static int rbsp_write_uev(struct rbsp *rbsp, unsigned int value)
+{
+	int i;
+	int ret;
+	int tmp = value + 1;
+	int leading_zero_bits = fls(tmp) - 1;
+
+	for (i = 0; i < leading_zero_bits; i++) {
+		ret = rbsp_write_bit(rbsp, 0);
+		if (ret)
+			return ret;
+	}
+
+	return rbsp_write_bits(rbsp, leading_zero_bits + 1, tmp);
+}
+
+static int rbsp_read_sev(struct rbsp *rbsp, int *val)
+{
+	unsigned int tmp;
+	int ret;
+
+	ret = rbsp_read_uev(rbsp, &tmp);
+	if (ret)
+		return ret;
+
+	if (val) {
+		if (tmp & 1)
+			*val = (tmp + 1) / 2;
+		else
+			*val = -(tmp / 2);
+	}
+
+	return 0;
+}
+
+/**
+ * coda_h264_sps_fixup - fixes frame cropping values in h.264 SPS
+ * @ctx: encoder context
+ * @width: visible width
+ * @height: visible height
+ * @buf: buffer containing h.264 SPS RBSP, starting with NAL header
+ * @size: modified RBSP size return value
+ * @max_size: available size in buf
+ *
+ * Rewrites the frame cropping values in an h.264 SPS RBSP correctly for the
+ * given visible width and height.
+ */
+int coda_h264_sps_fixup(struct coda_ctx *ctx, int width, int height, char *buf,
+			int *size, int max_size)
+{
+	int profile_idc;
+	unsigned int pic_order_cnt_type;
+	int pic_width_in_mbs_minus1, pic_height_in_map_units_minus1;
+	int frame_mbs_only_flag, frame_cropping_flag;
+	int vui_parameters_present_flag;
+	unsigned int crop_right, crop_bottom;
+	struct rbsp sps;
+	int pos;
+	int ret;
+
+	if (*size < 8 || *size >= max_size)
+		return -EINVAL;
+
+	sps.buf = buf + 5; /* Skip NAL header */
+	sps.size = *size - 5;
+
+	profile_idc = sps.buf[0];
+	/* Skip constraint_set[0-5]_flag, reserved_zero_2bits */
+	/* Skip level_idc */
+	sps.pos = 24;
+
+	/* seq_parameter_set_id */
+	ret = rbsp_read_uev(&sps, NULL);
+	if (ret)
+		return ret;
+
+	if (profile_idc == 100 || profile_idc == 110 || profile_idc == 122 ||
+	    profile_idc == 244 || profile_idc == 44 || profile_idc == 83 ||
+	    profile_idc == 86 || profile_idc == 118 || profile_idc == 128 ||
+	    profile_idc == 138 || profile_idc == 139 || profile_idc == 134 ||
+	    profile_idc == 135) {
+		dev_err(ctx->fh.vdev->dev_parent,
+			"%s: Handling profile_idc %d not implemented\n",
+			__func__, profile_idc);
+		return -EINVAL;
+	}
+
+	/* log2_max_frame_num_minus4 */
+	ret = rbsp_read_uev(&sps, NULL);
+	if (ret)
+		return ret;
+
+	ret = rbsp_read_uev(&sps, &pic_order_cnt_type);
+	if (ret)
+		return ret;
+
+	if (pic_order_cnt_type == 0) {
+		/* log2_max_pic_order_cnt_lsb_minus4 */
+		ret = rbsp_read_uev(&sps, NULL);
+		if (ret)
+			return ret;
+	} else if (pic_order_cnt_type == 1) {
+		unsigned int i, num_ref_frames_in_pic_order_cnt_cycle;
+
+		/* delta_pic_order_always_zero_flag */
+		ret = rbsp_read_bit(&sps);
+		if (ret < 0)
+			return ret;
+		/* offset_for_non_ref_pic */
+		ret = rbsp_read_sev(&sps, NULL);
+		if (ret)
+			return ret;
+		/* offset_for_top_to_bottom_field */
+		ret = rbsp_read_sev(&sps, NULL);
+		if (ret)
+			return ret;
+
+		ret = rbsp_read_uev(&sps,
+				    &num_ref_frames_in_pic_order_cnt_cycle);
+		if (ret)
+			return ret;
+		for (i = 0; i < num_ref_frames_in_pic_order_cnt_cycle; i++) {
+			/* offset_for_ref_frame */
+			ret = rbsp_read_sev(&sps, NULL);
+			if (ret)
+				return ret;
+		}
+	}
+
+	/* max_num_ref_frames */
+	ret = rbsp_read_uev(&sps, NULL);
+	if (ret)
+		return ret;
+
+	/* gaps_in_frame_num_value_allowed_flag */
+	ret = rbsp_read_bit(&sps);
+	if (ret < 0)
+		return ret;
+	ret = rbsp_read_uev(&sps, &pic_width_in_mbs_minus1);
+	if (ret)
+		return ret;
+	ret = rbsp_read_uev(&sps, &pic_height_in_map_units_minus1);
+	if (ret)
+		return ret;
+	frame_mbs_only_flag = ret = rbsp_read_bit(&sps);
+	if (ret < 0)
+		return ret;
+	if (!frame_mbs_only_flag) {
+		/* mb_adaptive_frame_field_flag */
+		ret = rbsp_read_bit(&sps);
+		if (ret < 0)
+			return ret;
+	}
+	/* direct_8x8_inference_flag */
+	ret = rbsp_read_bit(&sps);
+	if (ret < 0)
+		return ret;
+
+	/* Mark position of the frame cropping flag */
+	pos = sps.pos;
+	frame_cropping_flag = ret = rbsp_read_bit(&sps);
+	if (ret < 0)
+		return ret;
+	if (frame_cropping_flag) {
+		unsigned int crop_left, crop_top;
+
+		ret = rbsp_read_uev(&sps, &crop_left);
+		if (ret)
+			return ret;
+		ret = rbsp_read_uev(&sps, &crop_right);
+		if (ret)
+			return ret;
+		ret = rbsp_read_uev(&sps, &crop_top);
+		if (ret)
+			return ret;
+		ret = rbsp_read_uev(&sps, &crop_bottom);
+		if (ret)
+			return ret;
+	}
+	vui_parameters_present_flag = ret = rbsp_read_bit(&sps);
+	if (ret < 0)
+		return ret;
+	if (vui_parameters_present_flag) {
+		dev_err(ctx->fh.vdev->dev_parent,
+			"%s: Handling vui_parameters not implemented\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	crop_right = round_up(width, 16) - width;
+	crop_bottom = round_up(height, 16) - height;
+	crop_right /= 2;
+	if (frame_mbs_only_flag)
+		crop_bottom /= 2;
+	else
+		crop_bottom /= 4;
+
+
+	sps.size = max_size - 5;
+	sps.pos = pos;
+	frame_cropping_flag = 1;
+	ret = rbsp_write_bit(&sps, frame_cropping_flag);
+	if (ret)
+		return ret;
+	ret = rbsp_write_uev(&sps, 0); /* crop_left */
+	if (ret)
+		return ret;
+	ret = rbsp_write_uev(&sps, crop_right);
+	if (ret)
+		return ret;
+	ret = rbsp_write_uev(&sps, 0); /* crop_top */
+	if (ret)
+		return ret;
+	ret = rbsp_write_uev(&sps, crop_bottom);
+	if (ret)
+		return ret;
+	ret = rbsp_write_bit(&sps, 0); /* vui_parameters_present_flag */
+	if (ret)
+		return ret;
+	ret = rbsp_write_bit(&sps, 1);
+	if (ret)
+		return ret;
+
+	*size = 5 + DIV_ROUND_UP(sps.pos, 8);
+
+	return 0;
+}
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 9f57f73161d6..19ac0b9dc6eb 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -305,6 +305,8 @@ int coda_h264_padding(int size, char *p);
 int coda_h264_profile(int profile_idc);
 int coda_h264_level(int level_idc);
 int coda_sps_parse_profile(struct coda_ctx *ctx, struct vb2_buffer *vb);
+int coda_h264_sps_fixup(struct coda_ctx *ctx, int width, int height, char *buf,
+			int *size, int max_size);
 
 bool coda_jpeg_check_buffer(struct coda_ctx *ctx, struct vb2_buffer *vb);
 int coda_jpeg_write_tables(struct coda_ctx *ctx);
-- 
2.18.0
