Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36827 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753739AbdBPCV2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 21:21:28 -0500
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
Subject: [PATCH v4 34/36] media: imx: csi: add frame skipping support
Date: Wed, 15 Feb 2017 18:19:36 -0800
Message-Id: <1487211578-11360-35-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

The CSI can skip any out of up to 6 input frames, allowing to reduce the
frame rate at the output pads by small fractions.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-csi.c | 119 +++++++++++++++++++++++++++++-
 1 file changed, 115 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 1d4e746..6284f99 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -9,6 +9,7 @@
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  */
+#include <linux/gcd.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -40,6 +41,18 @@
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
@@ -58,6 +71,7 @@ struct csi_priv {
 	const struct imx_media_pixfmt *cc[CSI_NUM_PADS];
 	struct v4l2_fract frame_interval;
 	struct v4l2_rect crop;
+	const struct csi_skip_desc *skip[CSI_NUM_PADS - 1];
 
 	/* the video device at IDMAC output pad */
 	struct imx_media_video_dev *vdev;
@@ -512,10 +526,12 @@ static int csi_setup(struct csi_priv *priv)
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
@@ -540,6 +556,9 @@ static int csi_setup(struct csi_priv *priv)
 
 	ipu_csi_set_dest(priv->csi, priv->dest);
 
+	ipu_csi_set_skip_smfc(priv->csi, skip->skip_smfc, skip->max_ratio - 1,
+			      0);
+
 	ipu_csi_dump(priv->csi);
 
 	return 0;
@@ -603,26 +622,115 @@ static void csi_stop(struct csi_priv *priv)
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
 static int csi_g_frame_interval(struct v4l2_subdev *sd,
 				struct v4l2_subdev_frame_interval *fi)
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
 
+	if (fi->pad >= CSI_NUM_PADS)
+		return -EINVAL;
+
 	fi->interval = priv->frame_interval;
 
+	if (fi->pad != CSI_SINK_PAD)
+		csi_apply_skip_interval(priv->skip[fi->pad - 1], &fi->interval);
+
 	return 0;
 }
 
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
 static int csi_s_frame_interval(struct v4l2_subdev *sd,
 				struct v4l2_subdev_frame_interval *fi)
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
 
-	/* Output pads mirror active input pad, no limits on input pads */
-	if (fi->pad == CSI_SRC_PAD_IDMAC || fi->pad == CSI_SRC_PAD_DIRECT)
-		fi->interval = priv->frame_interval;
+	if (fi->pad >= CSI_NUM_PADS)
+		return -EINVAL;
+
+	/* No limits on input pad */
+	if (fi->pad == CSI_SINK_PAD) {
+		priv->frame_interval = fi->interval;
+
+		/* Reset frame skipping ratio to 1:1 */
+		priv->skip[0] = &csi_skip[0];
+		priv->skip[1] = &csi_skip[0];
+
+		return 0;
+	}
 
-	priv->frame_interval = fi->interval;
+	/* Output pads depend on input interval, modified by frame skipping */
+	priv->skip[fi->pad - 1] = csi_find_best_skip(&priv->frame_interval,
+						     &fi->interval);
 
 	return 0;
 }
@@ -1198,6 +1306,9 @@ static int csi_registered(struct v4l2_subdev *sd)
 					      &priv->cc[i]);
 		if (ret)
 			goto put_csi;
+		/* disable frame skipping */
+		if (i != CSI_SINK_PAD)
+			priv->skip[i - 1] = &csi_skip[0];
 	}
 
 	priv->fim = imx_media_fim_init(&priv->sd);
-- 
2.7.4
