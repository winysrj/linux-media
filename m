Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35988 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752090AbdFGSfq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 14:35:46 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v8 28/34] media: imx: csi: add frame skipping support
Date: Wed,  7 Jun 2017 11:34:07 -0700
Message-Id: <1496860453-6282-29-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1496860453-6282-1-git-send-email-steve_longerbeam@mentor.com>
References: <1496860453-6282-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

The CSI can skip any out of up to 6 input frames, allowing to reduce the
frame rate at the output pads by small fractions.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/staging/media/imx/imx-media-csi.c | 167 ++++++++++++++++++++++++++----
 1 file changed, 146 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index b9220cc..fb66695 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -2,6 +2,7 @@
  * V4L2 Capture CSI Subdev for Freescale i.MX5/6 SOC
  *
  * Copyright (c) 2014-2017 Mentor Graphics Inc.
+ * Copyright (C) 2017 Pengutronix, Philipp Zabel <kernel@pengutronix.de>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -9,6 +10,7 @@
  * (at your option) any later version.
  */
 #include <linux/delay.h>
+#include <linux/gcd.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -41,6 +43,18 @@
 #define H_ALIGN    1 /* multiple of 2 lines */
 #define S_ALIGN    1 /* multiple of 2 */
 
+/*
+ * struct csi_skip_desc - CSI frame skipping descriptor
+ * @keep - number of frames kept per max_ratio frames
+ * @max_ratio - width of skip_smfc, written to MAX_RATIO bitfield
+ * @skip_smfc - skip pattern written to the SKIP_SMFC bitfield
+ */
+struct csi_skip_desc {
+	u8 keep;
+	u8 max_ratio;
+	u8 skip_smfc;
+};
+
 struct csi_priv {
 	struct device *dev;
 	struct ipu_soc *ipu;
@@ -64,8 +78,9 @@ struct csi_priv {
 
 	struct v4l2_mbus_framefmt format_mbus[CSI_NUM_PADS];
 	const struct imx_media_pixfmt *cc[CSI_NUM_PADS];
-	struct v4l2_fract frame_interval;
+	struct v4l2_fract frame_interval[CSI_NUM_PADS];
 	struct v4l2_rect crop;
+	const struct csi_skip_desc *skip;
 
 	/* active vb2 buffers to send to video dev sink */
 	struct imx_media_buffer *active_vb2_buf[2];
@@ -580,6 +595,10 @@ static int csi_setup(struct csi_priv *priv)
 
 	ipu_csi_set_dest(priv->csi, priv->dest);
 
+	if (priv->dest == IPU_CSI_DEST_IDMAC)
+		ipu_csi_set_skip_smfc(priv->csi, priv->skip->skip_smfc,
+				      priv->skip->max_ratio - 1, 0);
+
 	ipu_csi_dump(priv->csi);
 
 	return 0;
@@ -587,6 +606,7 @@ static int csi_setup(struct csi_priv *priv)
 
 static int csi_start(struct csi_priv *priv)
 {
+	struct v4l2_fract *output_fi, *input_fi;
 	u32 bad_frames = 0;
 	int ret;
 
@@ -595,10 +615,12 @@ static int csi_start(struct csi_priv *priv)
 		return -EINVAL;
 	}
 
+	output_fi = &priv->frame_interval[priv->active_output_pad];
+	input_fi = &priv->frame_interval[CSI_SINK_PAD];
+
 	ret = v4l2_subdev_call(priv->sensor->sd, sensor,
 			       g_skip_frames, &bad_frames);
 	if (!ret && bad_frames) {
-		struct v4l2_fract *fi = &priv->frame_interval;
 		u32 delay_usec;
 
 		/*
@@ -609,8 +631,8 @@ static int csi_start(struct csi_priv *priv)
 		 * to lose vert/horiz sync.
 		 */
 		delay_usec = DIV_ROUND_UP_ULL(
-			(u64)USEC_PER_SEC * fi->numerator * bad_frames,
-			fi->denominator);
+			(u64)USEC_PER_SEC * input_fi->numerator * bad_frames,
+			input_fi->denominator);
 		usleep_range(delay_usec, delay_usec + 1000);
 	}
 
@@ -626,8 +648,7 @@ static int csi_start(struct csi_priv *priv)
 
 	/* start the frame interval monitor */
 	if (priv->fim && priv->dest == IPU_CSI_DEST_IDMAC) {
-		ret = imx_media_fim_set_stream(priv->fim, &priv->frame_interval,
-					       true);
+		ret = imx_media_fim_set_stream(priv->fim, output_fi, true);
 		if (ret)
 			goto idmac_stop;
 	}
@@ -642,8 +663,7 @@ static int csi_start(struct csi_priv *priv)
 
 fim_off:
 	if (priv->fim && priv->dest == IPU_CSI_DEST_IDMAC)
-		imx_media_fim_set_stream(priv->fim, &priv->frame_interval,
-					 false);
+		imx_media_fim_set_stream(priv->fim, NULL, false);
 idmac_stop:
 	if (priv->dest == IPU_CSI_DEST_IDMAC)
 		csi_idmac_stop(priv);
@@ -657,14 +677,85 @@ static void csi_stop(struct csi_priv *priv)
 
 		/* stop the frame interval monitor */
 		if (priv->fim)
-			imx_media_fim_set_stream(priv->fim,
-						 &priv->frame_interval,
-						 false);
+			imx_media_fim_set_stream(priv->fim, NULL, false);
 	}
 
 	ipu_csi_disable(priv->csi);
 }
 
+static const struct csi_skip_desc csi_skip[12] = {
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
+static void csi_apply_skip_interval(const struct csi_skip_desc *skip,
+				    struct v4l2_fract *interval)
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
+/*
+ * Find the skip pattern to produce the output frame interval closest to the
+ * requested one, for the given input frame interval. Updates the output frame
+ * interval to the exact value.
+ */
+static const struct csi_skip_desc *csi_find_best_skip(struct v4l2_fract *in,
+						      struct v4l2_fract *out)
+{
+	const struct csi_skip_desc *skip = &csi_skip[0], *best_skip = skip;
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
+	for (i = 0; i < ARRAY_SIZE(csi_skip); i++, skip++) {
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
+	csi_apply_skip_interval(best_skip, out);
+
+	return best_skip;
+}
+
 /*
  * V4L2 subdev operations.
  */
@@ -674,8 +765,13 @@ static int csi_g_frame_interval(struct v4l2_subdev *sd,
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
 
+	if (fi->pad >= CSI_NUM_PADS)
+		return -EINVAL;
+
 	mutex_lock(&priv->lock);
-	fi->interval = priv->frame_interval;
+
+	fi->interval = priv->frame_interval[fi->pad];
+
 	mutex_unlock(&priv->lock);
 
 	return 0;
@@ -685,18 +781,44 @@ static int csi_s_frame_interval(struct v4l2_subdev *sd,
 				struct v4l2_subdev_frame_interval *fi)
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	struct v4l2_fract *input_fi;
+	int ret = 0;
 
 	mutex_lock(&priv->lock);
 
-	/* Output pads mirror active input pad, no limits on input pads */
-	if (fi->pad == CSI_SRC_PAD_IDMAC || fi->pad == CSI_SRC_PAD_DIRECT)
-		fi->interval = priv->frame_interval;
+	input_fi = &priv->frame_interval[CSI_SINK_PAD];
 
-	priv->frame_interval = fi->interval;
+	switch (fi->pad) {
+	case CSI_SINK_PAD:
+		/* No limits on input frame interval */
+		/* Reset output intervals and frame skipping ratio to 1:1 */
+		priv->frame_interval[CSI_SRC_PAD_IDMAC] = fi->interval;
+		priv->frame_interval[CSI_SRC_PAD_DIRECT] = fi->interval;
+		priv->skip = &csi_skip[0];
+		break;
+	case CSI_SRC_PAD_IDMAC:
+		/*
+		 * frame interval at IDMAC output pad depends on input
+		 * interval, modified by frame skipping.
+		 */
+		priv->skip = csi_find_best_skip(input_fi, &fi->interval);
+		break;
+	case CSI_SRC_PAD_DIRECT:
+		/*
+		 * frame interval at DIRECT output pad is same as input
+		 * interval.
+		 */
+		fi->interval = *input_fi;
+		break;
+	default:
+		ret = -EINVAL;
+		goto out;
+	}
 
+	priv->frame_interval[fi->pad] = fi->interval;
+out:
 	mutex_unlock(&priv->lock);
-
-	return 0;
+	return ret;
 }
 
 static int csi_s_stream(struct v4l2_subdev *sd, int enable)
@@ -1333,11 +1455,14 @@ static int csi_registered(struct v4l2_subdev *sd)
 					      &priv->cc[i]);
 		if (ret)
 			goto put_csi;
+
+		/* init default frame interval */
+		priv->frame_interval[i].numerator = 1;
+		priv->frame_interval[i].denominator = 30;
 	}
 
-	/* init default frame interval */
-	priv->frame_interval.numerator = 1;
-	priv->frame_interval.denominator = 30;
+	/* disable frame skipping */
+	priv->skip = &csi_skip[0];
 
 	priv->fim = imx_media_fim_init(&priv->sd);
 	if (IS_ERR(priv->fim)) {
-- 
2.7.4
