Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35225 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164991AbdEYAbi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 May 2017 20:31:38 -0400
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
Subject: [PATCH v7 33/34] media: imx: set and propagate default field, colorimetry
Date: Wed, 24 May 2017 17:29:48 -0700
Message-Id: <1495672189-29164-34-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
References: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a call to imx_media_fill_default_mbus_fields() in the
*_try_fmt() functions at the sink pads, to set empty field order and
colorimetry parameters.

If the field order is set to ANY, choose the currently set field order
at the sink pad. If the colorspace is set to DEFAULT, choose the
current colorspace at the sink pad.  If any of xfer_func, ycbcr_enc
or quantization are set to DEFAULT, either choose the current sink pad
setting, or the default setting for the new colorspace, if non-DEFAULT
colorspace was given.

If a format is destined to be routed through the Image Converter,
fixed quantization and Y`CbCr encoding must be set.

Colorimetry is also propagated from sink to source pads anywhere
this has not already been done.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/media/imx/imx-ic-prp.c      | 10 +++--
 drivers/staging/media/imx/imx-ic-prpencvf.c | 17 ++++++--
 drivers/staging/media/imx/imx-media-csi.c   | 14 ++++++-
 drivers/staging/media/imx/imx-media-utils.c | 62 +++++++++++++++++++++++++++++
 drivers/staging/media/imx/imx-media-vdic.c  |  8 +++-
 drivers/staging/media/imx/imx-media.h       |  4 +-
 6 files changed, 103 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-prp.c b/drivers/staging/media/imx/imx-ic-prp.c
index 3fc2a4e..7bc293a 100644
--- a/drivers/staging/media/imx/imx-ic-prp.c
+++ b/drivers/staging/media/imx/imx-ic-prp.c
@@ -166,8 +166,8 @@ static int prp_set_fmt(struct v4l2_subdev *sd,
 		       struct v4l2_subdev_format *sdformat)
 {
 	struct prp_priv *priv = sd_to_priv(sd);
+	struct v4l2_mbus_framefmt *fmt, *infmt;
 	const struct imx_media_pixfmt *cc;
-	struct v4l2_mbus_framefmt *fmt;
 	int ret = 0;
 	u32 code;
 
@@ -181,6 +181,8 @@ static int prp_set_fmt(struct v4l2_subdev *sd,
 		goto out;
 	}
 
+	infmt = __prp_get_fmt(priv, cfg, PRP_SINK_PAD, sdformat->which);
+
 	switch (sdformat->pad) {
 	case PRP_SINK_PAD:
 		v4l_bound_align_image(&sdformat->format.width, MIN_W, MAX_W,
@@ -194,12 +196,14 @@ static int prp_set_fmt(struct v4l2_subdev *sd,
 			cc = imx_media_find_ipu_format(code, CS_SEL_ANY);
 			sdformat->format.code = cc->codes[0];
 		}
+
+		imx_media_fill_default_mbus_fields(&sdformat->format, infmt,
+						   true);
 		break;
 	case PRP_SRC_PAD_PRPENC:
 	case PRP_SRC_PAD_PRPVF:
 		/* Output pads mirror input pad */
-		fmt = __prp_get_fmt(priv, cfg, PRP_SINK_PAD, sdformat->which);
-		sdformat->format = *fmt;
+		sdformat->format = *infmt;
 		break;
 	}
 
diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index aef0387..5e9c817 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -805,6 +805,8 @@ static void prp_try_fmt(struct prp_priv *priv,
 			struct v4l2_subdev_format *sdformat,
 			const struct imx_media_pixfmt **cc)
 {
+	struct v4l2_mbus_framefmt *infmt;
+
 	*cc = imx_media_find_ipu_format(sdformat->format.code, CS_SEL_ANY);
 	if (!*cc) {
 		u32 code;
@@ -814,22 +816,29 @@ static void prp_try_fmt(struct prp_priv *priv,
 		sdformat->format.code = (*cc)->codes[0];
 	}
 
-	if (sdformat->pad == PRPENCVF_SRC_PAD) {
-		struct v4l2_mbus_framefmt *infmt =
-			__prp_get_fmt(priv, cfg, PRPENCVF_SINK_PAD,
-				      sdformat->which);
+	infmt = __prp_get_fmt(priv, cfg, PRPENCVF_SINK_PAD, sdformat->which);
 
+	if (sdformat->pad == PRPENCVF_SRC_PAD) {
 		if (sdformat->format.field != V4L2_FIELD_NONE)
 			sdformat->format.field = infmt->field;
 
 		prp_bound_align_output(&sdformat->format, infmt,
 				       priv->rot_mode);
+
+		/* propagate colorimetry from sink */
+		sdformat->format.colorspace = infmt->colorspace;
+		sdformat->format.xfer_func = infmt->xfer_func;
+		sdformat->format.quantization = infmt->quantization;
+		sdformat->format.ycbcr_enc = infmt->ycbcr_enc;
 	} else {
 		v4l_bound_align_image(&sdformat->format.width,
 				      MIN_W_SINK, MAX_W_SINK, W_ALIGN_SINK,
 				      &sdformat->format.height,
 				      MIN_H_SINK, MAX_H_SINK, H_ALIGN_SINK,
 				      S_ALIGN);
+
+		imx_media_fill_default_mbus_fields(&sdformat->format, infmt,
+						   true);
 	}
 }
 
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index b8b3630..4ab401d 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1268,11 +1268,11 @@ static void csi_try_fmt(struct csi_priv *priv,
 	struct v4l2_mbus_framefmt *infmt;
 	u32 code;
 
+	infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD, sdformat->which);
+
 	switch (sdformat->pad) {
 	case CSI_SRC_PAD_DIRECT:
 	case CSI_SRC_PAD_IDMAC:
-		infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD,
-				      sdformat->which);
 		incc = imx_media_find_mbus_format(infmt->code,
 						  CS_SEL_ANY, true);
 
@@ -1308,6 +1308,12 @@ static void csi_try_fmt(struct csi_priv *priv,
 			sdformat->format.field =  (infmt->height == 480) ?
 				V4L2_FIELD_SEQ_TB : V4L2_FIELD_SEQ_BT;
 		}
+
+		/* propagate colorimetry from sink */
+		sdformat->format.colorspace = infmt->colorspace;
+		sdformat->format.xfer_func = infmt->xfer_func;
+		sdformat->format.quantization = infmt->quantization;
+		sdformat->format.ycbcr_enc = infmt->ycbcr_enc;
 		break;
 	case CSI_SINK_PAD:
 		v4l_bound_align_image(&sdformat->format.width, MIN_W, MAX_W,
@@ -1334,6 +1340,10 @@ static void csi_try_fmt(struct csi_priv *priv,
 							CS_SEL_ANY, false);
 			sdformat->format.code = (*cc)->codes[0];
 		}
+
+		imx_media_fill_default_mbus_fields(
+			&sdformat->format, infmt,
+			priv->active_output_pad == CSI_SRC_PAD_DIRECT);
 		break;
 	}
 }
diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index f718422..5952387 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -464,6 +464,68 @@ int imx_media_init_mbus_fmt(struct v4l2_mbus_framefmt *mbus,
 }
 EXPORT_SYMBOL_GPL(imx_media_init_mbus_fmt);
 
+/*
+ * Check whether the field and colorimetry parameters in tryfmt are
+ * uninitialized, and if so fill them with the values from fmt,
+ * or if tryfmt->colorspace has been initialized, all the default
+ * colorimetry params can be derived from tryfmt->colorspace.
+ *
+ * tryfmt->code must be set on entry.
+ *
+ * If this format is destined to be routed through the Image Converter,
+ * quantization and Y`CbCr encoding must be fixed. The IC expects and
+ * produces fixed quantization and Y`CbCr encoding at its input and output
+ * (full range for RGB, limited range for YUV, and V4L2_YCBCR_ENC_601).
+ */
+void imx_media_fill_default_mbus_fields(struct v4l2_mbus_framefmt *tryfmt,
+					struct v4l2_mbus_framefmt *fmt,
+					bool ic_route)
+{
+	const struct imx_media_pixfmt *cc;
+	bool is_rgb = false;
+
+	cc = imx_media_find_mbus_format(tryfmt->code, CS_SEL_ANY, true);
+	if (!cc)
+		cc = imx_media_find_ipu_format(tryfmt->code, CS_SEL_ANY);
+	if (cc && cc->cs != IPUV3_COLORSPACE_YUV)
+		is_rgb = true;
+
+	/* fill field if necessary */
+	if (tryfmt->field == V4L2_FIELD_ANY)
+		tryfmt->field = fmt->field;
+
+	/* fill colorimetry if necessary */
+	if (tryfmt->colorspace == V4L2_COLORSPACE_DEFAULT) {
+		tryfmt->colorspace = fmt->colorspace;
+		tryfmt->xfer_func = fmt->xfer_func;
+		tryfmt->ycbcr_enc = fmt->ycbcr_enc;
+		tryfmt->quantization = fmt->quantization;
+	} else {
+		if (tryfmt->xfer_func == V4L2_XFER_FUNC_DEFAULT) {
+			tryfmt->xfer_func =
+				V4L2_MAP_XFER_FUNC_DEFAULT(tryfmt->colorspace);
+		}
+		if (tryfmt->ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT) {
+			tryfmt->ycbcr_enc =
+				V4L2_MAP_YCBCR_ENC_DEFAULT(tryfmt->colorspace);
+		}
+		if (tryfmt->quantization == V4L2_QUANTIZATION_DEFAULT) {
+			tryfmt->quantization =
+				V4L2_MAP_QUANTIZATION_DEFAULT(
+					is_rgb, tryfmt->colorspace,
+					tryfmt->ycbcr_enc);
+		}
+	}
+
+	if (ic_route) {
+		tryfmt->quantization = is_rgb ?
+			V4L2_QUANTIZATION_FULL_RANGE :
+			V4L2_QUANTIZATION_LIM_RANGE;
+		tryfmt->ycbcr_enc = V4L2_YCBCR_ENC_601;
+	}
+}
+EXPORT_SYMBOL_GPL(imx_media_fill_default_mbus_fields);
+
 int imx_media_mbus_fmt_to_pix_fmt(struct v4l2_pix_format *pix,
 				  struct v4l2_mbus_framefmt *mbus,
 				  const struct imx_media_pixfmt *cc)
diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
index 3dedc47..c0b6d7f 100644
--- a/drivers/staging/media/imx/imx-media-vdic.c
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -603,10 +603,11 @@ static void vdic_try_fmt(struct vdic_priv *priv,
 		sdformat->format.code = (*cc)->codes[0];
 	}
 
+	infmt = __vdic_get_fmt(priv, cfg, priv->active_input_pad,
+			       sdformat->which);
+
 	switch (sdformat->pad) {
 	case VDIC_SRC_PAD_DIRECT:
-		infmt = __vdic_get_fmt(priv, cfg, priv->active_input_pad,
-				       sdformat->which);
 		sdformat->format = *infmt;
 		/* output is always progressive! */
 		sdformat->format.field = V4L2_FIELD_NONE;
@@ -618,6 +619,9 @@ static void vdic_try_fmt(struct vdic_priv *priv,
 				      &sdformat->format.height,
 				      MIN_H, MAX_H_VDIC, H_ALIGN, S_ALIGN);
 
+		imx_media_fill_default_mbus_fields(&sdformat->format, infmt,
+						   true);
+
 		/* input must be interlaced! Choose SEQ_TB if not */
 		if (!V4L2_FIELD_HAS_BOTH(sdformat->format.field))
 			sdformat->format.field = V4L2_FIELD_SEQ_TB;
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index 6cebbd3..2cbf8e7 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -209,7 +209,9 @@ int imx_media_enum_ipu_format(u32 *code, u32 index, enum codespace_sel cs_sel);
 int imx_media_init_mbus_fmt(struct v4l2_mbus_framefmt *mbus,
 			    u32 width, u32 height, u32 code, u32 field,
 			    const struct imx_media_pixfmt **cc);
-
+void imx_media_fill_default_mbus_fields(struct v4l2_mbus_framefmt *tryfmt,
+					struct v4l2_mbus_framefmt *fmt,
+					bool ic_route);
 int imx_media_mbus_fmt_to_pix_fmt(struct v4l2_pix_format *pix,
 				  struct v4l2_mbus_framefmt *mbus,
 				  const struct imx_media_pixfmt *cc);
-- 
2.7.4
