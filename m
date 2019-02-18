Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 328CDC43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 15:13:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1BFB20838
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 15:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbfBRPN3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 10:13:29 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:40000 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfBRPN3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 10:13:29 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: gportay)
        with ESMTPSA id 93A10260485
From:   =?UTF-8?q?Ga=C3=ABl=20PORTAY?= <gael.portay@collabora.com>
To:     linux-media@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel@collabora.com,
        =?utf-8?q?Ga=C3=ABl=20PORTAY?= <gael.portay@collabora.com>
Subject: [PATCH] media: imx: vdic: add frame skipping support
Date:   Mon, 18 Feb 2019 10:13:04 -0500
Message-Id: <20190218151304.662-1-gael.portay@collabora.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The VDIC can skip frames, allowing to reduce the frame rate at its
output pad by small fractions.

With this commit, once can specify the frame interval with media-ctl.

media-ctl -V "'ipu1_vdic':2 [fmt: UYVY8_2X8/720x576@1/30 field:interlaced-tb]"

The commit is an adaptation for VDIC of the commit fb30ee795576 ([media]
media: imx: csi: add frame skipping support).

Signed-off-by: Gaël PORTAY <gael.portay@collabora.com>
---
 drivers/gpu/ipu-v3/ipu-common.c            |  28 +++++
 drivers/staging/media/imx/imx-media-vdic.c | 129 +++++++++++++++++++--
 include/video/imx-ipu-v3.h                 |   1 +
 3 files changed, 149 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 474b00e19697..19e1e50dc469 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -35,6 +35,12 @@
 #include <video/imx-ipu-v3.h>
 #include "ipu-prv.h"
 
+/* IPU Register Fields */
+#define VDI_MAX_RATIO_SKIP_MASK			0x000f0000
+#define VDI_MAX_RATIO_SKIP_SHIFT		16
+#define VDI_SKIP_MASK_MASK			0xfff00000
+#define VDI_SKIP_SHIFT_SHIFT			20
+
 static inline u32 ipu_cm_read(struct ipu_soc *ipu, unsigned offset)
 {
 	return readl(ipu->cm_reg + offset);
@@ -267,6 +273,28 @@ int ipu_rot_mode_to_degrees(int *degrees, enum ipu_rotate_mode mode,
 }
 EXPORT_SYMBOL_GPL(ipu_rot_mode_to_degrees);
 
+int ipu_set_skip_vdi(struct ipu_soc *ipu, u32 skip, u32 max_ratio)
+{
+	unsigned long flags;
+	u32 temp;
+
+	if (max_ratio > 15)
+		return -EINVAL;
+
+	spin_lock_irqsave(&ipu->lock, flags);
+
+	temp = ipu_cm_read(ipu, IPU_SKIP);
+	temp &= ~(VDI_MAX_RATIO_SKIP_MASK | VDI_SKIP_MASK_MASK);
+	temp |= (max_ratio << VDI_MAX_RATIO_SKIP_SHIFT) |
+		(skip << VDI_SKIP_SHIFT_SHIFT);
+	ipu_cm_write(ipu, temp, IPU_SKIP);
+
+	spin_unlock_irqrestore(&ipu->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_set_skip_vdi);
+
 struct ipuv3_channel *ipu_idmac_get(struct ipu_soc *ipu, unsigned num)
 {
 	struct ipuv3_channel *channel;
diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
index 2808662e2597..a12ac4dd5afd 100644
--- a/drivers/staging/media/imx/imx-media-vdic.c
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -9,6 +9,7 @@
  * (at your option) any later version.
  */
 #include <linux/delay.h>
+#include <linux/gcd.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -68,6 +69,18 @@ struct vdic_pipeline_ops {
 #define H_ALIGN    1 /* multiple of 2 lines */
 #define S_ALIGN    1 /* multiple of 2 */
 
+/*
+ * struct vdic_skip_desc - VDIC frame skipping descriptor
+ * @keep - number of frames kept per max_ratio frames
+ * @max_ratio - width of skip, written to MAX_RATIO bitfield
+ * @skip - skip pattern written to the SKIP bitfield
+ */
+struct vdic_skip_desc {
+	u8 keep;
+	u8 max_ratio;
+	u8 skip;
+};
+
 struct vdic_priv {
 	struct device        *dev;
 	struct ipu_soc       *ipu;
@@ -111,6 +124,7 @@ struct vdic_priv {
 	struct v4l2_mbus_framefmt format_mbus[VDIC_NUM_PADS];
 	const struct imx_media_pixfmt *cc[VDIC_NUM_PADS];
 	struct v4l2_fract frame_interval[VDIC_NUM_PADS];
+	const struct vdic_skip_desc *skip;
 
 	/* the video device at IDMAC input pad */
 	struct imx_media_video_dev *vdev;
@@ -388,6 +402,7 @@ static int vdic_start(struct vdic_priv *priv)
 		      infmt->width, infmt->height);
 	ipu_vdi_set_field_order(priv->vdi, V4L2_STD_UNKNOWN, infmt->field);
 	ipu_vdi_set_motion(priv->vdi, priv->motion);
+	ipu_set_skip_vdi(priv->ipu, priv->skip->skip, priv->skip->max_ratio - 1);
 
 	ret = priv->ops->setup(priv);
 	if (ret)
@@ -558,6 +573,63 @@ static int vdic_enum_mbus_code(struct v4l2_subdev *sd,
 	return imx_media_enum_ipu_format(&code->code, code->index, CS_SEL_YUV);
 }
 
+static const struct vdic_skip_desc vdic_skip[12] = {
+	{ 1, 1, 0x00 }, /* Keep all frames */
+	{ 5, 6, 0x10 }, /* Skip every sixth frame */
+	{ 4, 5, 0x08 }, /* Skip every fifth frame */
+	{ 3, 4, 0x04 }, /* Skip every fourth frame */
+	{ 2, 3, 0x02 }, /* Skip every third frame */
+	{ 3, 5, 0x0a }, /* Skip frames 1 and 3 of every 5 */
+	{ 1, 2, 0x01 }, /* Skip every second frame */
+	{ 2, 5, 0x0b }, /* Keep frames 1 and 4 of every 5 */
+	{ 1, 3, 0x03 }, /* Keep one in three frames */
+	{ 1, 4, 0x07 }, /* Keep one in four frames */
+	{ 1, 5, 0x0f }, /* Keep one in five frames */
+	{ 1, 6, 0x1f }, /* Keep one in six frames */
+};
+
+static void vdic_apply_skip_interval(const struct vdic_skip_desc *skip,
+				     struct v4l2_fract *interval)
+{
+	unsigned int div;
+
+	interval->numerator *= skip->max_ratio;
+	interval->denominator *= skip->keep;
+
+	/* Reduce fraction to lowest terms */
+	div = gcd(interval->numerator, interval->denominator);
+	if (div > 1) {
+		interval->numerator /= div;
+		interval->denominator /= div;
+	}
+}
+
+static int vdic_enum_frame_interval(struct v4l2_subdev *sd,
+				    struct v4l2_subdev_pad_config *cfg,
+				    struct v4l2_subdev_frame_interval_enum *fie)
+{
+	struct vdic_priv *priv = v4l2_get_subdevdata(sd);
+	struct v4l2_fract *input_fi;
+	int ret = 0;
+
+	if (fie->pad >= VDIC_NUM_PADS ||
+	    fie->index >= (fie->pad != VDIC_SRC_PAD_DIRECT ?
+			   1 : ARRAY_SIZE(vdic_skip)))
+		return -EINVAL;
+
+	mutex_lock(&priv->lock);
+
+	input_fi = &priv->frame_interval[CSI_SINK_PAD];
+	fie->interval = *input_fi;
+
+	if (fie->pad == VDIC_SRC_PAD_DIRECT)
+		vdic_apply_skip_interval(&vdic_skip[fie->index],
+					 &fie->interval);
+
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
 static int vdic_get_fmt(struct v4l2_subdev *sd,
 			struct v4l2_subdev_pad_config *cfg,
 			struct v4l2_subdev_format *sdformat)
@@ -786,6 +858,48 @@ static int vdic_link_validate(struct v4l2_subdev *sd,
 	return ret;
 }
 
+/*
+ * Find the skip pattern to produce the output frame interval closest to the
+ * requested one, for the given input frame interval. Updates the output frame
+ * interval to the exact value.
+ */
+static const struct vdic_skip_desc *vdic_find_best_skip(struct v4l2_fract *in,
+							struct v4l2_fract *out)
+{
+	const struct vdic_skip_desc *skip = &vdic_skip[0], *best_skip = skip;
+	u32 min_err = UINT_MAX;
+	u64 want_us;
+	int i;
+
+	/* Default to 1:1 ratio */
+	if (out->numerator == 0 || out->denominator == 0 ||
+	    in->numerator == 0 || in->denominator == 0) {
+		*out = *in;
+		return best_skip;
+	}
+
+	want_us = div_u64((u64)USEC_PER_SEC * out->numerator, out->denominator);
+
+	/* Find the reduction closest to the requested time per frame */
+	for (i = 0; i < ARRAY_SIZE(vdic_skip); i++, skip++) {
+		u64 tmp, err;
+
+		tmp = div_u64((u64)USEC_PER_SEC * in->numerator *
+			      skip->max_ratio, in->denominator * skip->keep);
+
+		err = abs((s64)tmp - want_us);
+		if (err < min_err) {
+			min_err = err;
+			best_skip = skip;
+		}
+	}
+
+	*out = *in;
+	vdic_apply_skip_interval(best_skip, out);
+
+	return best_skip;
+}
+
 static int vdic_g_frame_interval(struct v4l2_subdev *sd,
 				struct v4l2_subdev_frame_interval *fi)
 {
@@ -826,17 +940,10 @@ static int vdic_s_frame_interval(struct v4l2_subdev *sd,
 		*output_fi = fi->interval;
 		if (priv->csi_direct)
 			output_fi->denominator *= 2;
+		priv->skip = &vdic_skip[0];
 		break;
 	case VDIC_SRC_PAD_DIRECT:
-		/*
-		 * frame rate at output pad is double input
-		 * rate when using direct CSI->VDIC pipeline.
-		 *
-		 * TODO: implement VDIC frame skipping
-		 */
-		fi->interval = *input_fi;
-		if (priv->csi_direct)
-			fi->interval.denominator *= 2;
+		priv->skip = vdic_find_best_skip(output_fi, &fi->interval);
 		break;
 	default:
 		ret = -EINVAL;
@@ -883,6 +990,9 @@ static int vdic_registered(struct v4l2_subdev *sd)
 			priv->frame_interval[i].denominator *= 2;
 	}
 
+	/* disable frame skipping */
+	priv->skip = &vdic_skip[0];
+
 	priv->active_input_pad = VDIC_SINK_PAD_DIRECT;
 
 	ret = vdic_init_controls(priv);
@@ -906,6 +1016,7 @@ static void vdic_unregistered(struct v4l2_subdev *sd)
 static const struct v4l2_subdev_pad_ops vdic_pad_ops = {
 	.init_cfg = imx_media_init_cfg,
 	.enum_mbus_code = vdic_enum_mbus_code,
+	.enum_frame_interval = vdic_enum_frame_interval,
 	.get_fmt = vdic_get_fmt,
 	.set_fmt = vdic_set_fmt,
 	.link_validate = vdic_link_validate,
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index c887f4bee5f8..026c4340a8da 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -203,6 +203,7 @@ int ipu_idmac_channel_irq(struct ipu_soc *ipu, struct ipuv3_channel *channel,
  * IPU Common functions
  */
 int ipu_get_num(struct ipu_soc *ipu);
+int ipu_set_skip_vdi(struct ipu_soc *csi, u32 skip, u32 max_ratio);
 void ipu_set_csi_src_mux(struct ipu_soc *ipu, int csi_id, bool mipi_csi2);
 void ipu_set_ic_src_mux(struct ipu_soc *ipu, int csi_id, bool vdi);
 void ipu_dump(struct ipu_soc *ipu);
-- 
2.20.1

