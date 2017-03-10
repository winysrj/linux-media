Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33244 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932705AbdCJEz0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Mar 2017 23:55:26 -0500
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
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v5 37/39] media: imx: csi: add frame skipping support
Date: Thu,  9 Mar 2017 20:53:17 -0800
Message-Id: <1489121599-23206-38-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

The CSI can skip any out of up to 6 input frames, allowing to reduce the
frame rate at the output pads by small fractions.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-csi.c | 125 ++++++++++++++++++++++++++++--
 1 file changed, 120 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index a726744..e5105ec 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1,13 +1,15 @@
 /*
  * V4L2 Capture CSI Subdev for Freescale i.MX5/6 SOC
  *
- * Copyright (c) 2014-2016 Mentor Graphics Inc.
+ * Copyright (c) 2014-2017 Mentor Graphics Inc.
+ * Copyright (C) 2017 Pengutronix, Philipp Zabel <kernel@pengutronix.de>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  */
+#include <linux/gcd.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -40,6 +42,18 @@
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
@@ -65,6 +79,7 @@ struct csi_priv {
 	const struct imx_media_pixfmt *cc[CSI_NUM_PADS];
 	struct v4l2_fract frame_interval;
 	struct v4l2_rect crop;
+	const struct csi_skip_desc *skip[CSI_NUM_PADS - 1];
 
 	/* active vb2 buffers to send to video dev sink */
 	struct imx_media_buffer *active_vb2_buf[2];
@@ -517,10 +532,12 @@ static int csi_setup(struct csi_priv *priv)
 	struct v4l2_mbus_config sensor_mbus_cfg;
 	struct v4l2_of_endpoint *sensor_ep;
 	struct v4l2_mbus_framefmt if_fmt;
+	const struct csi_skip_desc *skip;
 
 	infmt = &priv->format_mbus[CSI_SINK_PAD];
 	outfmt = &priv->format_mbus[priv->active_output_pad];
 	sensor_ep = &priv->sensor->sensor_ep;
+	skip = priv->skip[priv->active_output_pad - 1];
 
 	/* compose mbus_config from sensor endpoint */
 	sensor_mbus_cfg.type = sensor_ep->bus_type;
@@ -545,6 +562,9 @@ static int csi_setup(struct csi_priv *priv)
 
 	ipu_csi_set_dest(priv->csi, priv->dest);
 
+	ipu_csi_set_skip_smfc(priv->csi, skip->skip_smfc, skip->max_ratio - 1,
+			      0);
+
 	ipu_csi_dump(priv->csi);
 
 	return 0;
@@ -608,6 +628,77 @@ static void csi_stop(struct csi_priv *priv)
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
+	    in->numerator == 0 || in->denominator == 0)
+		return best_skip;
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
@@ -617,8 +708,16 @@ static int csi_g_frame_interval(struct v4l2_subdev *sd,
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
 
+	if (fi->pad >= CSI_NUM_PADS)
+		return -EINVAL;
+
 	mutex_lock(&priv->lock);
+
 	fi->interval = priv->frame_interval;
+
+	if (fi->pad != CSI_SINK_PAD)
+		csi_apply_skip_interval(priv->skip[fi->pad - 1], &fi->interval);
+
 	mutex_unlock(&priv->lock);
 
 	return 0;
@@ -629,14 +728,27 @@ static int csi_s_frame_interval(struct v4l2_subdev *sd,
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
 
+	if (fi->pad >= CSI_NUM_PADS)
+		return -EINVAL;
+
 	mutex_lock(&priv->lock);
 
-	/* Output pads mirror active input pad, no limits on input pads */
-	if (fi->pad == CSI_SRC_PAD_IDMAC || fi->pad == CSI_SRC_PAD_DIRECT)
-		fi->interval = priv->frame_interval;
+	/* No limits on input pad */
+	if (fi->pad == CSI_SINK_PAD) {
+		priv->frame_interval = fi->interval;
+
+		/* Reset frame skipping ratio to 1:1 */
+		priv->skip[0] = &csi_skip[0];
+		priv->skip[1] = &csi_skip[0];
 
-	priv->frame_interval = fi->interval;
+		goto out;
+	}
+
+	/* Output pads depend on input interval, modified by frame skipping */
+	priv->skip[fi->pad - 1] = csi_find_best_skip(&priv->frame_interval,
+						     &fi->interval);
 
+out:
 	mutex_unlock(&priv->lock);
 
 	return 0;
@@ -1256,6 +1368,9 @@ static int csi_registered(struct v4l2_subdev *sd)
 					      &priv->cc[i]);
 		if (ret)
 			goto put_csi;
+		/* disable frame skipping */
+		if (i != CSI_SINK_PAD)
+			priv->skip[i - 1] = &csi_skip[0];
 	}
 
 	/* init default frame interval */
-- 
2.7.4
