Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33256 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753748AbdBPCV0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 21:21:26 -0500
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
Subject: [PATCH v4 33/36] media: imx: redo pixel format enumeration and negotiation
Date: Wed, 15 Feb 2017 18:19:35 -0800
Message-Id: <1487211578-11360-34-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The previous API and negotiation of mbus codes and pixel formats
was broken, and has been completely redone.

The negotiation of media bus codes should be as follows:

CSI:

sink pad     direct src pad      IDMAC src pad
--------     ----------------    -------------
RGB (any)        IPU RGB           RGB (any)
YUV (any)        IPU YUV           YUV (any)
Bayer              N/A             must be same bayer code as sink

VDIC:

direct sink pad    IDMAC sink pad    direct src pad
---------------    --------------    --------------
IPU YUV only       YUV (any)         IPU YUV only

PRP:

direct sink pad    direct src pads
---------------    ---------------
IPU (any)          same as sink code

PRP ENC/VF:

direct sink pad    IDMAC src pads
---------------    --------------
IPU (any)          any RGB or YUV

Given the above, a new internal API is created:

enum codespace_sel {
       CS_SEL_YUV = 0, /* find or enumerate only YUV codes */
       CS_SEL_RGB,     /* find or enumerate only RGB codes */
       CS_SEL_ANY,     /* find or enumerate both YUV and RGB codes */
};

/* Find and enumerate fourcc pixel formats */
const struct imx_media_pixfmt *
imx_media_find_format(u32 fourcc, enum codespace_sel cs_sel);
int imx_media_enum_format(u32 *fourcc, u32 index, enum codespace_sel cs_sel);

/* Find and enumerate media bus codes */
const struct imx_media_pixfmt *
imx_media_find_mbus_format(u32 code, enum codespace_sel cs_sel,
                          bool allow_bayer);
int imx_media_enum_mbus_format(u32 *code, u32 index, enum codespace_sel cs_sel,
                              bool allow_bayer);

/* Find and enumerate IPU internal media bus codes */
const struct imx_media_pixfmt *
imx_media_find_ipu_format(u32 code, enum codespace_sel cs_sel);
int imx_media_enum_ipu_format(u32 *code, u32 index, enum codespace_sel cs_sel);

The tables have been split into separate tables for YUV and RGB formats
to support the implementation of the above.

The subdev's .enum_mbus_code() and .set_fmt() operations have
been rewritten using the above APIs.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-ic-prp.c        |  72 ++++--
 drivers/staging/media/imx/imx-ic-prpencvf.c   |  53 ++--
 drivers/staging/media/imx/imx-media-capture.c |  77 +++---
 drivers/staging/media/imx/imx-media-csi.c     | 107 +++++---
 drivers/staging/media/imx/imx-media-utils.c   | 357 +++++++++++++++++++-------
 drivers/staging/media/imx/imx-media-vdic.c    | 100 +++++---
 drivers/staging/media/imx/imx-media.h         |  27 +-
 7 files changed, 528 insertions(+), 265 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-prp.c b/drivers/staging/media/imx/imx-ic-prp.c
index 3683f7c..b9ee8fb 100644
--- a/drivers/staging/media/imx/imx-ic-prp.c
+++ b/drivers/staging/media/imx/imx-ic-prp.c
@@ -96,16 +96,6 @@ static void prp_stop(struct prp_priv *priv)
 {
 }
 
-static int prp_enum_mbus_code(struct v4l2_subdev *sd,
-			      struct v4l2_subdev_pad_config *cfg,
-			      struct v4l2_subdev_mbus_code_enum *code)
-{
-	if (code->pad >= PRP_NUM_PADS)
-		return -EINVAL;
-
-	return imx_media_enum_ipu_format(NULL, &code->code, code->index, true);
-}
-
 static struct v4l2_mbus_framefmt *
 __prp_get_fmt(struct prp_priv *priv, struct v4l2_subdev_pad_config *cfg,
 	      unsigned int pad, enum v4l2_subdev_format_whence which)
@@ -118,6 +108,33 @@ __prp_get_fmt(struct prp_priv *priv, struct v4l2_subdev_pad_config *cfg,
 		return &priv->format_mbus[pad];
 }
 
+static int prp_enum_mbus_code(struct v4l2_subdev *sd,
+			      struct v4l2_subdev_pad_config *cfg,
+			      struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct prp_priv *priv = sd_to_priv(sd);
+	struct v4l2_mbus_framefmt *infmt;
+	int ret = 0;
+
+	switch (code->pad) {
+	case PRP_SINK_PAD:
+		ret = imx_media_enum_ipu_format(&code->code, code->index,
+						CS_SEL_ANY);
+		break;
+	case PRP_SRC_PAD_PRPENC:
+	case PRP_SRC_PAD_PRPVF:
+		if (code->index != 0)
+			return -EINVAL;
+		infmt = __prp_get_fmt(priv, cfg, PRP_SINK_PAD, code->which);
+		code->code = infmt->code;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return ret;
+}
+
 static int prp_get_fmt(struct v4l2_subdev *sd,
 		       struct v4l2_subdev_pad_config *cfg,
 		       struct v4l2_subdev_format *sdformat)
@@ -152,23 +169,28 @@ static int prp_set_fmt(struct v4l2_subdev *sd,
 	if (priv->stream_on)
 		return -EBUSY;
 
-	cc = imx_media_find_ipu_format(0, sdformat->format.code, true);
-	if (!cc) {
-		imx_media_enum_ipu_format(NULL, &code, 0, true);
-		cc = imx_media_find_ipu_format(0, code, true);
-		sdformat->format.code = cc->codes[0];
-	}
-
-	v4l_bound_align_image(&sdformat->format.width, MIN_W, MAX_W,
-			      W_ALIGN, &sdformat->format.height,
-			      MIN_H, MAX_H, H_ALIGN, S_ALIGN);
-
-	/* Output pads mirror input pad */
-	if (sdformat->pad == PRP_SRC_PAD_PRPENC ||
-	    sdformat->pad == PRP_SRC_PAD_PRPVF) {
+	switch (sdformat->pad) {
+	case PRP_SINK_PAD:
+		v4l_bound_align_image(&sdformat->format.width, MIN_W, MAX_W,
+				      W_ALIGN, &sdformat->format.height,
+				      MIN_H, MAX_H, H_ALIGN, S_ALIGN);
+
+		cc = imx_media_find_ipu_format(sdformat->format.code,
+					       CS_SEL_ANY);
+		if (!cc) {
+			imx_media_enum_ipu_format(&code, 0, CS_SEL_ANY);
+			cc = imx_media_find_ipu_format(code, CS_SEL_ANY);
+			sdformat->format.code = cc->codes[0];
+		}
+		break;
+	case PRP_SRC_PAD_PRPENC:
+	case PRP_SRC_PAD_PRPVF:
+		/* Output pads mirror input pad */
 		infmt = __prp_get_fmt(priv, cfg, PRP_SINK_PAD,
 				      sdformat->which);
+		cc = imx_media_find_ipu_format(infmt->code, CS_SEL_ANY);
 		sdformat->format = *infmt;
+		break;
 	}
 
 	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {
@@ -364,7 +386,7 @@ static int prp_registered(struct v4l2_subdev *sd)
 			MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
 
 		/* set a default mbus format  */
-		imx_media_enum_ipu_format(NULL, &code, 0, true);
+		imx_media_enum_ipu_format(&code, 0, CS_SEL_YUV);
 		ret = imx_media_init_mbus_fmt(&priv->format_mbus[i],
 					      640, 480, code, V4L2_FIELD_NONE,
 					      &priv->cc[i]);
diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index 6e45975..dd9d499 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -689,20 +689,6 @@ static void prp_stop(struct prp_priv *priv)
 	prp_put_ipu_resources(priv);
 }
 
-static int prp_enum_mbus_code(struct v4l2_subdev *sd,
-			      struct v4l2_subdev_pad_config *cfg,
-			      struct v4l2_subdev_mbus_code_enum *code)
-{
-	if (code->pad >= PRPENCVF_NUM_PADS)
-		return -EINVAL;
-
-	if (code->pad == PRPENCVF_SRC_PAD)
-		return imx_media_enum_format(NULL, &code->code, code->index,
-					     true, false);
-
-	return imx_media_enum_ipu_format(NULL, &code->code, code->index, true);
-}
-
 static struct v4l2_mbus_framefmt *
 __prp_get_fmt(struct prp_priv *priv, struct v4l2_subdev_pad_config *cfg,
 	      unsigned int pad, enum v4l2_subdev_format_whence which)
@@ -715,6 +701,25 @@ __prp_get_fmt(struct prp_priv *priv, struct v4l2_subdev_pad_config *cfg,
 		return &priv->format_mbus[pad];
 }
 
+static int prp_enum_mbus_code(struct v4l2_subdev *sd,
+			      struct v4l2_subdev_pad_config *cfg,
+			      struct v4l2_subdev_mbus_code_enum *code)
+{
+	int ret;
+
+	if (code->pad >= PRPENCVF_NUM_PADS)
+		return -EINVAL;
+
+	if (code->pad == PRPENCVF_SINK_PAD)
+		ret = imx_media_enum_ipu_format(&code->code, code->index,
+						CS_SEL_ANY);
+	else
+		ret = imx_media_enum_mbus_format(&code->code, code->index,
+						 CS_SEL_ANY, false);
+
+	return ret;
+}
+
 static int prp_get_fmt(struct v4l2_subdev *sd,
 		       struct v4l2_subdev_pad_config *cfg,
 		       struct v4l2_subdev_format *sdformat)
@@ -754,11 +759,13 @@ static int prp_set_fmt(struct v4l2_subdev *sd,
 		infmt = __prp_get_fmt(priv, cfg, PRPENCVF_SINK_PAD,
 				      sdformat->which);
 
-		cc = imx_media_find_format(0, sdformat->format.code,
-					   true, false);
+		cc = imx_media_find_mbus_format(sdformat->format.code,
+						CS_SEL_ANY, false);
 		if (!cc) {
-			imx_media_enum_format(NULL, &code, 0, true, false);
-			cc = imx_media_find_format(0, code, true, false);
+			imx_media_enum_mbus_format(&code, 0,
+						   CS_SEL_ANY, false);
+			cc = imx_media_find_mbus_format(code,
+							CS_SEL_ANY, false);
 			sdformat->format.code = cc->codes[0];
 		}
 
@@ -781,11 +788,11 @@ static int prp_set_fmt(struct v4l2_subdev *sd,
 					      infmt->height / 4, MAX_H_SRC,
 					      H_ALIGN_SRC, S_ALIGN);
 	} else {
-		cc = imx_media_find_ipu_format(0, sdformat->format.code,
-					       true);
+		cc = imx_media_find_ipu_format(sdformat->format.code,
+					       CS_SEL_ANY);
 		if (!cc) {
-			imx_media_enum_ipu_format(NULL, &code, 0, true);
-			cc = imx_media_find_ipu_format(0, code, true);
+			imx_media_enum_ipu_format(&code, 0, CS_SEL_ANY);
+			cc = imx_media_find_ipu_format(code, CS_SEL_ANY);
 			sdformat->format.code = cc->codes[0];
 		}
 
@@ -1021,7 +1028,7 @@ static int prp_registered(struct v4l2_subdev *sd)
 	for (i = 0; i < PRPENCVF_NUM_PADS; i++) {
 		if (i == PRPENCVF_SINK_PAD) {
 			priv->pad[i].flags = MEDIA_PAD_FL_SINK;
-			imx_media_enum_ipu_format(NULL, &code, 0, true);
+			imx_media_enum_ipu_format(&code, 0, CS_SEL_YUV);
 		} else {
 			priv->pad[i].flags = MEDIA_PAD_FL_SOURCE;
 			code = 0;
diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index fbf6067..9ef1cc2 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -85,12 +85,33 @@ static int vidioc_querycap(struct file *file, void *fh,
 static int capture_enum_fmt_vid_cap(struct file *file, void *fh,
 				    struct v4l2_fmtdesc *f)
 {
-	u32 fourcc;
+	struct capture_priv *priv = video_drvdata(file);
+	const struct imx_media_pixfmt *cc_src;
+	struct v4l2_subdev_format fmt_src;
+	u32 fourcc, cs_sel;
 	int ret;
 
-	ret = imx_media_enum_format(&fourcc, NULL, f->index, true, true);
-	if (ret)
+	fmt_src.pad = priv->src_sd_pad;
+	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	ret = v4l2_subdev_call(priv->src_sd, pad, get_fmt, NULL, &fmt_src);
+	if (ret) {
+		v4l2_err(priv->src_sd, "failed to get src_sd format\n");
 		return ret;
+	}
+	cc_src = imx_media_find_mbus_format(fmt_src.format.code,
+					    CS_SEL_ANY, true);
+	if (cc_src->bayer) {
+		if (f->index != 0)
+			return -EINVAL;
+		fourcc = cc_src->fourcc;
+	} else {
+		cs_sel = (cc_src->cs == IPUV3_COLORSPACE_YUV) ?
+			CS_SEL_YUV : CS_SEL_RGB;
+
+		ret = imx_media_enum_format(&fourcc, f->index, cs_sel);
+		if (ret)
+			return ret;
+	}
 
 	f->pixelformat = fourcc;
 
@@ -112,40 +133,36 @@ static int capture_try_fmt_vid_cap(struct file *file, void *fh,
 {
 	struct capture_priv *priv = video_drvdata(file);
 	struct v4l2_subdev_format fmt_src;
-	const struct imx_media_pixfmt *cc, *src_cc;
-	u32 fourcc;
+	const struct imx_media_pixfmt *cc, *cc_src;
 	int ret;
 
-	fourcc = f->fmt.pix.pixelformat;
-	cc = imx_media_find_format(fourcc, 0, true, true);
-	if (!cc) {
-		imx_media_enum_format(&fourcc, NULL, 0, true, true);
-		cc = imx_media_find_format(fourcc, 0, true, true);
-	}
-
-	/*
-	 * user frame dimensions are the same as src_sd's pad.
-	 */
 	fmt_src.pad = priv->src_sd_pad;
 	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 	ret = v4l2_subdev_call(priv->src_sd, pad, get_fmt, NULL, &fmt_src);
 	if (ret)
 		return ret;
 
-	/*
-	 * but we can allow planar pixel formats if the src_sd's
-	 * pad configured a YUV format
-	 */
-	src_cc = imx_media_find_format(0, fmt_src.format.code, true, false);
-	if (src_cc->cs == IPUV3_COLORSPACE_YUV &&
-	    cc->cs == IPUV3_COLORSPACE_YUV) {
-		imx_media_mbus_fmt_to_pix_fmt(&f->fmt.pix,
-					      &fmt_src.format, cc);
+	cc_src = imx_media_find_mbus_format(fmt_src.format.code,
+					    CS_SEL_ANY, true);
+
+	if (cc_src->bayer) {
+		cc = cc_src;
 	} else {
-		imx_media_mbus_fmt_to_pix_fmt(&f->fmt.pix,
-					      &fmt_src.format, src_cc);
+		u32 fourcc, cs_sel;
+
+		cs_sel = (cc_src->cs == IPUV3_COLORSPACE_YUV) ?
+			CS_SEL_YUV : CS_SEL_RGB;
+		fourcc = f->fmt.pix.pixelformat;
+
+		cc = imx_media_find_format(fourcc, cs_sel);
+		if (!cc) {
+			imx_media_enum_format(&fourcc, 0, cs_sel);
+			cc = imx_media_find_format(fourcc, cs_sel);
+		}
 	}
 
+	imx_media_mbus_fmt_to_pix_fmt(&f->fmt.pix, &fmt_src.format, cc);
+
 	return 0;
 }
 
@@ -165,8 +182,8 @@ static int capture_s_fmt_vid_cap(struct file *file, void *fh,
 		return ret;
 
 	priv->vdev.fmt.fmt.pix = f->fmt.pix;
-	priv->vdev.cc = imx_media_find_format(f->fmt.pix.pixelformat, 0,
-					      true, true);
+	priv->vdev.cc = imx_media_find_format(f->fmt.pix.pixelformat,
+					      CS_SEL_ANY);
 
 	return 0;
 }
@@ -573,8 +590,8 @@ int imx_media_capture_device_register(struct imx_media_video_dev *vdev)
 	vdev->fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	imx_media_mbus_fmt_to_pix_fmt(&vdev->fmt.fmt.pix,
 				      &fmt_src.format, NULL);
-	vdev->cc = imx_media_find_format(0, fmt_src.format.code,
-					 true, false);
+	vdev->cc = imx_media_find_format(vdev->fmt.fmt.pix.pixelformat,
+					 CS_SEL_ANY);
 
 	v4l2_info(sd, "Registered %s as /dev/%s\n", vfd->name,
 		  video_device_node_name(vfd));
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 040cca6..1d4e746 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -877,15 +877,44 @@ static int csi_enum_mbus_code(struct v4l2_subdev *sd,
 			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_mbus_code_enum *code)
 {
-	if (code->pad >= CSI_NUM_PADS)
-		return -EINVAL;
+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	const struct imx_media_pixfmt *incc;
+	struct v4l2_mbus_framefmt *infmt;
+	int ret = 0;
+	u32 cs_sel;
 
-	if (code->pad == CSI_SRC_PAD_DIRECT)
-		return imx_media_enum_ipu_format(NULL, &code->code,
-						 code->index, true);
+	infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD, code->which);
+	incc = imx_media_find_mbus_format(infmt->code, CS_SEL_ANY, true);
 
-	return imx_media_enum_format(NULL, &code->code, code->index,
-				     true, false);
+	switch (code->pad) {
+	case CSI_SINK_PAD:
+		ret = imx_media_enum_mbus_format(&code->code, code->index,
+						 CS_SEL_ANY, true);
+		break;
+	case CSI_SRC_PAD_DIRECT:
+		cs_sel = (incc->cs == IPUV3_COLORSPACE_YUV) ?
+			CS_SEL_YUV : CS_SEL_RGB;
+		ret = imx_media_enum_ipu_format(&code->code, code->index,
+						cs_sel);
+		break;
+	case CSI_SRC_PAD_IDMAC:
+		if (incc->bayer) {
+			if (code->index != 0)
+				return -EINVAL;
+			code->code = infmt->code;
+		} else {
+			cs_sel = (incc->cs == IPUV3_COLORSPACE_YUV) ?
+				CS_SEL_YUV : CS_SEL_RGB;
+			ret = imx_media_enum_mbus_format(&code->code,
+							 code->index,
+							 cs_sel, false);
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return ret;
 }
 
 static int csi_get_fmt(struct v4l2_subdev *sd,
@@ -917,7 +946,7 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 	struct v4l2_mbus_framefmt *infmt;
 	struct imx_media_subdev *sensor;
 	struct v4l2_rect crop;
-	u32 code;
+	u32 code, cs_sel;
 	int ret;
 
 	if (sdformat->pad >= CSI_NUM_PADS)
@@ -932,14 +961,16 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 		return PTR_ERR(sensor);
 	}
 
-	v4l_bound_align_image(&sdformat->format.width, MIN_W, MAX_W,
-			      W_ALIGN, &sdformat->format.height,
-			      MIN_H, MAX_H, H_ALIGN, S_ALIGN);
-
 	switch (sdformat->pad) {
 	case CSI_SRC_PAD_DIRECT:
 	case CSI_SRC_PAD_IDMAC:
-		infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD, sdformat->which);
+		infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD,
+				      sdformat->which);
+		incc = imx_media_find_mbus_format(infmt->code,
+						  CS_SEL_ANY, true);
+
+		cs_sel = (incc->cs == IPUV3_COLORSPACE_YUV) ?
+			CS_SEL_YUV : CS_SEL_RGB;
 
 		if (sdformat->format.width < priv->crop.width * 3 / 4)
 			sdformat->format.width = priv->crop.width / 2;
@@ -952,32 +983,29 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 			sdformat->format.height = priv->crop.height;
 
 		if (sdformat->pad == CSI_SRC_PAD_IDMAC) {
-			cc = imx_media_find_format(0, sdformat->format.code,
-						   true, false);
-			if (!cc) {
-				imx_media_enum_format(NULL, &code, 0,
-						      true, false);
-				cc = imx_media_find_format(0, code,
-							   true, false);
-				sdformat->format.code = cc->codes[0];
-			}
-
-			incc = priv->cc[CSI_SINK_PAD];
-			if (cc->cs != incc->cs) {
+			if (incc->bayer) {
 				sdformat->format.code = infmt->code;
-				cc = imx_media_find_format(
-					0, sdformat->format.code,
-					true, false);
+				cc = incc;
+			} else {
+				cc = imx_media_find_mbus_format(
+					sdformat->format.code, cs_sel, false);
+				if (!cc) {
+					imx_media_enum_mbus_format(
+						&code, 0, cs_sel, false);
+					cc = imx_media_find_mbus_format(
+						code, cs_sel, false);
+					sdformat->format.code = cc->codes[0];
+				}
 			}
 
 			if (sdformat->format.field != V4L2_FIELD_NONE)
 				sdformat->format.field = infmt->field;
 		} else {
-			cc = imx_media_find_ipu_format(0, sdformat->format.code,
-						       true);
+			cc = imx_media_find_ipu_format(sdformat->format.code,
+						       cs_sel);
 			if (!cc) {
-				imx_media_enum_ipu_format(NULL, &code, 0, true);
-				cc = imx_media_find_ipu_format(0, code, true);
+				imx_media_enum_ipu_format(&code, 0, cs_sel);
+				cc = imx_media_find_ipu_format(code, cs_sel);
 				sdformat->format.code = cc->codes[0];
 			}
 
@@ -999,6 +1027,9 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 		}
 		break;
 	case CSI_SINK_PAD:
+		v4l_bound_align_image(&sdformat->format.width, MIN_W, MAX_W,
+				      W_ALIGN, &sdformat->format.height,
+				      MIN_H, MAX_H, H_ALIGN, S_ALIGN);
 		crop.left = 0;
 		crop.top = 0;
 		crop.width = sdformat->format.width;
@@ -1008,11 +1039,13 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 		if (ret)
 			return ret;
 
-		cc = imx_media_find_format(0, sdformat->format.code,
-					   true, false);
+		cc = imx_media_find_mbus_format(sdformat->format.code,
+						CS_SEL_ANY, true);
 		if (!cc) {
-			imx_media_enum_format(NULL, &code, 0, true, false);
-			cc = imx_media_find_format(0, code, true, false);
+			imx_media_enum_mbus_format(&code, 0,
+						   CS_SEL_ANY, false);
+			cc = imx_media_find_mbus_format(code,
+							CS_SEL_ANY, false);
 			sdformat->format.code = cc->codes[0];
 		}
 		break;
@@ -1157,7 +1190,7 @@ static int csi_registered(struct v4l2_subdev *sd)
 
 		code = 0;
 		if (i == CSI_SRC_PAD_DIRECT)
-			imx_media_enum_ipu_format(NULL, &code, 0, true);
+			imx_media_enum_ipu_format(&code, 0, CS_SEL_YUV);
 
 		/* set a default mbus format  */
 		ret = imx_media_init_mbus_fmt(&priv->format_mbus[i],
diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index 6855560..a7fa84a 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -12,14 +12,13 @@
 #include "imx-media.h"
 
 /*
- * List of pixel formats for the subdevs. This must be a super-set of
- * the formats supported by the ipu image converter.
+ * List of supported pixel formats for the subdevs.
  *
- * The non-mbus formats (planar and BGR) must all fall at the end of
- * this table, otherwise enum_fmt() at media pads will stop before
- * seeing all the supported mbus formats.
+ * In all of these tables, the non-mbus formats (with no
+ * mbus codes) must all fall at the end of the table.
  */
-static const struct imx_media_pixfmt imx_media_formats[] = {
+
+static const struct imx_media_pixfmt yuv_formats[] = {
 	{
 		.fourcc	= V4L2_PIX_FMT_UYVY,
 		.codes  = {
@@ -36,13 +35,45 @@ static const struct imx_media_pixfmt imx_media_formats[] = {
 		},
 		.cs     = IPUV3_COLORSPACE_YUV,
 		.bpp    = 16,
+	},
+	/***
+	 * non-mbus YUV formats start here. NOTE! when adding non-mbus
+	 * formats, NUM_NON_MBUS_YUV_FORMATS must be updated below.
+	 ***/
+	{
+		.fourcc	= V4L2_PIX_FMT_YUV420,
+		.cs     = IPUV3_COLORSPACE_YUV,
+		.bpp    = 12,
+		.planar = true,
 	}, {
-		.fourcc = V4L2_PIX_FMT_YUV32,
-		.codes  = {MEDIA_BUS_FMT_AYUV8_1X32},
+		.fourcc = V4L2_PIX_FMT_YVU420,
 		.cs     = IPUV3_COLORSPACE_YUV,
-		.bpp    = 32,
-		.ipufmt = true,
+		.bpp    = 12,
+		.planar = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_YUV422P,
+		.cs     = IPUV3_COLORSPACE_YUV,
+		.bpp    = 16,
+		.planar = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_NV12,
+		.cs     = IPUV3_COLORSPACE_YUV,
+		.bpp    = 12,
+		.planar = true,
 	}, {
+		.fourcc = V4L2_PIX_FMT_NV16,
+		.cs     = IPUV3_COLORSPACE_YUV,
+		.bpp    = 16,
+		.planar = true,
+	},
+};
+
+#define NUM_NON_MBUS_YUV_FORMATS 5
+#define NUM_YUV_FORMATS ARRAY_SIZE(yuv_formats)
+#define NUM_MBUS_YUV_FORMATS (NUM_YUV_FORMATS - NUM_NON_MBUS_YUV_FORMATS)
+
+static const struct imx_media_pixfmt rgb_formats[] = {
+	{
 		.fourcc	= V4L2_PIX_FMT_RGB565,
 		.codes  = {MEDIA_BUS_FMT_RGB565_2X8_LE},
 		.cs     = IPUV3_COLORSPACE_RGB,
@@ -61,7 +92,9 @@ static const struct imx_media_pixfmt imx_media_formats[] = {
 		.cs     = IPUV3_COLORSPACE_RGB,
 		.bpp    = 32,
 		.ipufmt = true,
-	}, {
+	},
+	/*** raw bayer formats start here ***/
+	{
 		.fourcc = V4L2_PIX_FMT_SBGGR8,
 		.codes  = {MEDIA_BUS_FMT_SBGGR8_1X8},
 		.cs     = IPUV3_COLORSPACE_RGB,
@@ -130,7 +163,10 @@ static const struct imx_media_pixfmt imx_media_formats[] = {
 		.bpp    = 16,
 		.bayer  = true,
 	},
-	/*** non-mbus formats start here ***/
+	/***
+	 * non-mbus RGB formats start here. NOTE! when adding non-mbus
+	 * formats, NUM_NON_MBUS_RGB_FORMATS must be updated below.
+	 ***/
 	{
 		.fourcc	= V4L2_PIX_FMT_BGR24,
 		.cs     = IPUV3_COLORSPACE_RGB,
@@ -139,135 +175,256 @@ static const struct imx_media_pixfmt imx_media_formats[] = {
 		.fourcc	= V4L2_PIX_FMT_BGR32,
 		.cs     = IPUV3_COLORSPACE_RGB,
 		.bpp    = 32,
-	}, {
-		.fourcc	= V4L2_PIX_FMT_YUV420,
-		.cs     = IPUV3_COLORSPACE_YUV,
-		.bpp    = 12,
-		.planar = true,
-	}, {
-		.fourcc = V4L2_PIX_FMT_YVU420,
-		.cs     = IPUV3_COLORSPACE_YUV,
-		.bpp    = 12,
-		.planar = true,
-	}, {
-		.fourcc = V4L2_PIX_FMT_YUV422P,
-		.cs     = IPUV3_COLORSPACE_YUV,
-		.bpp    = 16,
-		.planar = true,
-	}, {
-		.fourcc = V4L2_PIX_FMT_NV12,
-		.cs     = IPUV3_COLORSPACE_YUV,
-		.bpp    = 12,
-		.planar = true,
-	}, {
-		.fourcc = V4L2_PIX_FMT_NV16,
+	},
+};
+
+#define NUM_NON_MBUS_RGB_FORMATS 2
+#define NUM_RGB_FORMATS ARRAY_SIZE(rgb_formats)
+#define NUM_MBUS_RGB_FORMATS (NUM_RGB_FORMATS - NUM_NON_MBUS_RGB_FORMATS)
+
+static const struct imx_media_pixfmt ipu_yuv_formats[] = {
+	{
+		.fourcc = V4L2_PIX_FMT_YUV32,
+		.codes  = {MEDIA_BUS_FMT_AYUV8_1X32},
 		.cs     = IPUV3_COLORSPACE_YUV,
-		.bpp    = 16,
-		.planar = true,
+		.bpp    = 32,
+		.ipufmt = true,
 	},
 };
 
-static const u32 imx_media_ipu_internal_codes[] = {
-	MEDIA_BUS_FMT_AYUV8_1X32, MEDIA_BUS_FMT_ARGB8888_1X32,
+#define NUM_IPU_YUV_FORMATS ARRAY_SIZE(ipu_yuv_formats)
+
+static const struct imx_media_pixfmt ipu_rgb_formats[] = {
+	{
+		.fourcc	= V4L2_PIX_FMT_RGB32,
+		.codes  = {MEDIA_BUS_FMT_ARGB8888_1X32},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 32,
+		.ipufmt = true,
+	},
 };
 
+#define NUM_IPU_RGB_FORMATS ARRAY_SIZE(ipu_rgb_formats)
+
 static inline u32 pixfmt_to_colorspace(const struct imx_media_pixfmt *fmt)
 {
 	return (fmt->cs == IPUV3_COLORSPACE_RGB) ?
 		V4L2_COLORSPACE_SRGB : V4L2_COLORSPACE_SMPTE170M;
 }
 
-static const struct imx_media_pixfmt *find_format(u32 fourcc, u32 code,
-						  bool allow_rgb,
-						  bool allow_planar,
-						  bool ipu_fmt_only)
+static const struct imx_media_pixfmt *find_format(u32 fourcc,
+						  u32 code,
+						  enum codespace_sel cs_sel,
+						  bool allow_non_mbus,
+						  bool allow_bayer)
 {
-	const struct imx_media_pixfmt *fmt, *ret = NULL;
+	const struct imx_media_pixfmt *array, *fmt, *ret = NULL;
+	u32 array_size;
 	int i, j;
 
-	for (i = 0; i < ARRAY_SIZE(imx_media_formats); i++) {
-		fmt = &imx_media_formats[i];
+	switch (cs_sel) {
+	case CS_SEL_YUV:
+		array_size = NUM_YUV_FORMATS;
+		array = yuv_formats;
+		break;
+	case CS_SEL_RGB:
+		array_size = NUM_RGB_FORMATS;
+		array = rgb_formats;
+		break;
+	case CS_SEL_ANY:
+		array_size = NUM_YUV_FORMATS + NUM_RGB_FORMATS;
+		array = yuv_formats;
+		break;
+	default:
+		return NULL;
+	}
+
+	for (i = 0; i < array_size; i++) {
+		if (cs_sel == CS_SEL_ANY && i >= NUM_YUV_FORMATS)
+			fmt = &rgb_formats[i - NUM_YUV_FORMATS];
+		else
+			fmt = &array[i];
 
-		if (ipu_fmt_only && !fmt->ipufmt)
+		if ((!allow_non_mbus && fmt->codes[0] == 0) ||
+		    (!allow_bayer && fmt->bayer))
 			continue;
 
-		if (fourcc && fmt->fourcc == fourcc &&
-		    (fmt->cs != IPUV3_COLORSPACE_RGB || allow_rgb) &&
-		    (!fmt->planar || allow_planar)) {
+		if (fourcc && fmt->fourcc == fourcc) {
 			ret = fmt;
 			goto out;
 		}
 
 		for (j = 0; code && fmt->codes[j]; j++) {
-			if (fmt->codes[j] == code && !fmt->planar &&
-			    (fmt->cs != IPUV3_COLORSPACE_RGB || allow_rgb)) {
+			if (code == fmt->codes[j]) {
 				ret = fmt;
 				goto out;
 			}
 		}
 	}
+
 out:
 	return ret;
 }
 
-const struct imx_media_pixfmt *imx_media_find_format(u32 fourcc, u32 code,
-						     bool allow_rgb,
-						     bool allow_planar)
+static int enum_format(u32 *fourcc, u32 *code, u32 index,
+		       enum codespace_sel cs_sel,
+		       bool allow_non_mbus,
+		       bool allow_bayer)
 {
-	return find_format(fourcc, code, allow_rgb, allow_planar, false);
+	const struct imx_media_pixfmt *fmt;
+	u32 mbus_yuv_sz = NUM_MBUS_YUV_FORMATS;
+	u32 mbus_rgb_sz = NUM_MBUS_RGB_FORMATS;
+	u32 yuv_sz = NUM_YUV_FORMATS;
+	u32 rgb_sz = NUM_RGB_FORMATS;
+
+	switch (cs_sel) {
+	case CS_SEL_YUV:
+		if (index >= yuv_sz ||
+		    (!allow_non_mbus && index >= mbus_yuv_sz))
+			return -EINVAL;
+		fmt = &yuv_formats[index];
+		break;
+	case CS_SEL_RGB:
+		if (index >= rgb_sz ||
+		    (!allow_non_mbus && index >= mbus_rgb_sz))
+			return -EINVAL;
+		fmt = &rgb_formats[index];
+		if (!allow_bayer && fmt->bayer)
+			return -EINVAL;
+		break;
+	case CS_SEL_ANY:
+		if (!allow_non_mbus) {
+			if (index >= mbus_yuv_sz) {
+				index -= mbus_yuv_sz;
+				if (index >= mbus_rgb_sz)
+					return -EINVAL;
+				fmt = &rgb_formats[index];
+				if (!allow_bayer && fmt->bayer)
+					return -EINVAL;
+			} else {
+				fmt = &yuv_formats[index];
+			}
+		} else {
+			if (index >= yuv_sz + rgb_sz)
+				return -EINVAL;
+			if (index >= yuv_sz) {
+				fmt = &rgb_formats[index - yuv_sz];
+				if (!allow_bayer && fmt->bayer)
+					return -EINVAL;
+			} else {
+				fmt = &yuv_formats[index];
+			}
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (fourcc)
+		*fourcc = fmt->fourcc;
+	if (code)
+		*code = fmt->codes[0];
+
+	return 0;
+}
+
+const struct imx_media_pixfmt *
+imx_media_find_format(u32 fourcc, enum codespace_sel cs_sel)
+{
+	return find_format(fourcc, 0, cs_sel, true, false);
 }
 EXPORT_SYMBOL_GPL(imx_media_find_format);
 
-const struct imx_media_pixfmt *imx_media_find_ipu_format(u32 fourcc,
-							 u32 code,
-							 bool allow_rgb)
+int imx_media_enum_format(u32 *fourcc, u32 index, enum codespace_sel cs_sel)
 {
-	return find_format(fourcc, code, allow_rgb, false, true);
+	return enum_format(fourcc, NULL, index, cs_sel, true, false);
 }
-EXPORT_SYMBOL_GPL(imx_media_find_ipu_format);
+EXPORT_SYMBOL_GPL(imx_media_enum_format);
 
-int imx_media_enum_format(u32 *fourcc, u32 *code, u32 index,
-			  bool allow_rgb, bool allow_planar)
+const struct imx_media_pixfmt *
+imx_media_find_mbus_format(u32 code, enum codespace_sel cs_sel,
+			   bool allow_bayer)
 {
-	const struct imx_media_pixfmt *fmt;
+	return find_format(0, code, cs_sel, false, allow_bayer);
+}
+EXPORT_SYMBOL_GPL(imx_media_find_mbus_format);
 
-	if (index >= ARRAY_SIZE(imx_media_formats))
-		return -EINVAL;
+int imx_media_enum_mbus_format(u32 *code, u32 index, enum codespace_sel cs_sel,
+			       bool allow_bayer)
+{
+	return enum_format(NULL, code, index, cs_sel, false, allow_bayer);
+}
+EXPORT_SYMBOL_GPL(imx_media_enum_mbus_format);
 
-	fmt = &imx_media_formats[index];
+const struct imx_media_pixfmt *
+imx_media_find_ipu_format(u32 code, enum codespace_sel cs_sel)
+{
+	const struct imx_media_pixfmt *array, *fmt, *ret = NULL;
+	u32 array_size;
+	int i, j;
 
-	if ((fmt->cs == IPUV3_COLORSPACE_RGB && !allow_rgb) ||
-	    (fmt->planar && !allow_planar))
-		return -EINVAL;
+	switch (cs_sel) {
+	case CS_SEL_YUV:
+		array_size = NUM_IPU_YUV_FORMATS;
+		array = ipu_yuv_formats;
+		break;
+	case CS_SEL_RGB:
+		array_size = NUM_IPU_RGB_FORMATS;
+		array = ipu_rgb_formats;
+		break;
+	case CS_SEL_ANY:
+		array_size = NUM_IPU_YUV_FORMATS + NUM_IPU_RGB_FORMATS;
+		array = ipu_yuv_formats;
+		break;
+	default:
+		return NULL;
+	}
 
-	if (code)
-		*code = fmt->codes[0];
-	if (fourcc)
-		*fourcc = fmt->fourcc;
+	for (i = 0; i < array_size; i++) {
+		if (cs_sel == CS_SEL_ANY && i >= NUM_IPU_YUV_FORMATS)
+			fmt = &ipu_rgb_formats[i - NUM_IPU_YUV_FORMATS];
+		else
+			fmt = &array[i];
 
-	return 0;
+		for (j = 0; code && fmt->codes[j]; j++) {
+			if (code == fmt->codes[j]) {
+				ret = fmt;
+				goto out;
+			}
+		}
+	}
+
+out:
+	return ret;
 }
-EXPORT_SYMBOL_GPL(imx_media_enum_format);
+EXPORT_SYMBOL_GPL(imx_media_find_ipu_format);
 
-int imx_media_enum_ipu_format(u32 *fourcc, u32 *code, u32 index,
-			      bool allow_rgb)
+int imx_media_enum_ipu_format(u32 *code, u32 index, enum codespace_sel cs_sel)
 {
-	const struct imx_media_pixfmt *fmt;
-	u32 lcode;
-
-	if (index >= ARRAY_SIZE(imx_media_ipu_internal_codes))
-		return -EINVAL;
-
-	lcode = imx_media_ipu_internal_codes[index];
-
-	fmt = find_format(0, lcode, allow_rgb, false, true);
-	if (!fmt)
+	switch (cs_sel) {
+	case CS_SEL_YUV:
+		if (index >= NUM_IPU_YUV_FORMATS)
+			return -EINVAL;
+		*code = ipu_yuv_formats[index].codes[0];
+		break;
+	case CS_SEL_RGB:
+		if (index >= NUM_IPU_RGB_FORMATS)
+			return -EINVAL;
+		*code = ipu_rgb_formats[index].codes[0];
+		break;
+	case CS_SEL_ANY:
+		if (index >= NUM_IPU_YUV_FORMATS + NUM_IPU_RGB_FORMATS)
+			return -EINVAL;
+		if (index >= NUM_IPU_YUV_FORMATS) {
+			index -= NUM_IPU_YUV_FORMATS;
+			*code = ipu_rgb_formats[index].codes[0];
+		} else {
+			*code = ipu_yuv_formats[index].codes[0];
+		}
+		break;
+	default:
 		return -EINVAL;
-
-	if (code)
-		*code = fmt->codes[0];
-	if (fourcc)
-		*fourcc = fmt->fourcc;
+	}
 
 	return 0;
 }
@@ -283,10 +440,14 @@ int imx_media_init_mbus_fmt(struct v4l2_mbus_framefmt *mbus,
 	mbus->height = height;
 	mbus->field = field;
 	if (code == 0)
-		imx_media_enum_format(NULL, &code, 0, true, false);
-	lcc = imx_media_find_format(0, code, true, false);
-	if (!lcc)
-		return -EINVAL;
+		imx_media_enum_mbus_format(&code, 0, CS_SEL_YUV, false);
+	lcc = imx_media_find_mbus_format(code, CS_SEL_ANY, false);
+	if (!lcc) {
+		lcc = imx_media_find_ipu_format(code, CS_SEL_ANY);
+		if (!lcc)
+			return -EINVAL;
+	}
+
 	mbus->code = code;
 	mbus->colorspace = pixfmt_to_colorspace(lcc);
 
@@ -304,7 +465,7 @@ int imx_media_mbus_fmt_to_pix_fmt(struct v4l2_pix_format *pix,
 	u32 stride;
 
 	if (!cc) {
-		cc = imx_media_find_format(0, mbus->code, true, false);
+		cc = imx_media_find_mbus_format(mbus->code, CS_SEL_ANY, true);
 		if (!cc)
 			return -EINVAL;
 	}
@@ -346,7 +507,7 @@ int imx_media_ipu_image_to_mbus_fmt(struct v4l2_mbus_framefmt *mbus,
 {
 	const struct imx_media_pixfmt *fmt;
 
-	fmt = imx_media_find_format(image->pix.pixelformat, 0, true, false);
+	fmt = imx_media_find_format(image->pix.pixelformat, CS_SEL_ANY);
 	if (!fmt)
 		return -EINVAL;
 
diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
index 5bb21e9..61e6017 100644
--- a/drivers/staging/media/imx/imx-media-vdic.c
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -520,20 +520,6 @@ static int vdic_s_stream(struct v4l2_subdev *sd, int enable)
 	return ret;
 }
 
-static int vdic_enum_mbus_code(struct v4l2_subdev *sd,
-			       struct v4l2_subdev_pad_config *cfg,
-			       struct v4l2_subdev_mbus_code_enum *code)
-{
-	if (code->pad >= VDIC_NUM_PADS)
-		return -EINVAL;
-
-	if (code->pad == VDIC_SINK_PAD_IDMAC)
-		return imx_media_enum_format(NULL, &code->code, code->index,
-					     false, false);
-
-	return imx_media_enum_ipu_format(NULL, &code->code, code->index, false);
-}
-
 static struct v4l2_mbus_framefmt *
 __vdic_get_fmt(struct vdic_priv *priv, struct v4l2_subdev_pad_config *cfg,
 	       unsigned int pad, enum v4l2_subdev_format_whence which)
@@ -544,6 +530,32 @@ __vdic_get_fmt(struct vdic_priv *priv, struct v4l2_subdev_pad_config *cfg,
 		return &priv->format_mbus[pad];
 }
 
+static int vdic_enum_mbus_code(struct v4l2_subdev *sd,
+			       struct v4l2_subdev_pad_config *cfg,
+			       struct v4l2_subdev_mbus_code_enum *code)
+{
+	int ret;
+
+	switch (code->pad) {
+	case VDIC_SINK_PAD_IDMAC:
+		ret = imx_media_enum_mbus_format(&code->code, code->index,
+						 CS_SEL_YUV, false);
+		break;
+	case VDIC_SINK_PAD_DIRECT:
+		ret = imx_media_enum_ipu_format(&code->code, code->index,
+						CS_SEL_YUV);
+		break;
+	case VDIC_SRC_PAD_DIRECT:
+		ret = imx_media_enum_ipu_format(&code->code, code->index,
+						CS_SEL_YUV);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return ret;
+}
+
 static int vdic_get_fmt(struct v4l2_subdev *sd,
 			struct v4l2_subdev_pad_config *cfg,
 			struct v4l2_subdev_format *sdformat)
@@ -578,19 +590,16 @@ static int vdic_set_fmt(struct v4l2_subdev *sd,
 	if (priv->stream_on)
 		return -EBUSY;
 
-	v4l_bound_align_image(&sdformat->format.width, MIN_W, MAX_W_VDIC,
-			      W_ALIGN, &sdformat->format.height,
-			      MIN_H, MAX_H_VDIC, H_ALIGN, S_ALIGN);
-
 	switch (sdformat->pad) {
 	case VDIC_SRC_PAD_DIRECT:
 		infmt = __vdic_get_fmt(priv, cfg, priv->active_input_pad,
 				       sdformat->which);
 
-		cc = imx_media_find_ipu_format(0, sdformat->format.code, false);
+		cc = imx_media_find_ipu_format(sdformat->format.code,
+					       CS_SEL_YUV);
 		if (!cc) {
-			imx_media_enum_ipu_format(NULL, &code, 0, false);
-			cc = imx_media_find_ipu_format(0, code, false);
+			imx_media_enum_ipu_format(&code, 0, CS_SEL_YUV);
+			cc = imx_media_find_ipu_format(code, CS_SEL_YUV);
 			sdformat->format.code = cc->codes[0];
 		}
 
@@ -599,29 +608,36 @@ static int vdic_set_fmt(struct v4l2_subdev *sd,
 		/* output is always progressive! */
 		sdformat->format.field = V4L2_FIELD_NONE;
 		break;
-	case VDIC_SINK_PAD_IDMAC:
 	case VDIC_SINK_PAD_DIRECT:
-		if (sdformat->pad == VDIC_SINK_PAD_DIRECT) {
-			cc = imx_media_find_ipu_format(0, sdformat->format.code,
-						       false);
-			if (!cc) {
-				imx_media_enum_ipu_format(NULL, &code, 0,
-							  false);
-				cc = imx_media_find_ipu_format(0, code, false);
-				sdformat->format.code = cc->codes[0];
-			}
-		} else {
-			cc = imx_media_find_format(0, sdformat->format.code,
-						   false, false);
-			if (!cc) {
-				imx_media_enum_format(NULL, &code, 0,
-						      false, false);
-				cc = imx_media_find_format(0, code,
-							   false, false);
-				sdformat->format.code = cc->codes[0];
-			}
+		v4l_bound_align_image(&sdformat->format.width,
+				      MIN_W, MAX_W_VDIC, W_ALIGN,
+				      &sdformat->format.height,
+				      MIN_H, MAX_H_VDIC, H_ALIGN, S_ALIGN);
+
+		cc = imx_media_find_ipu_format(sdformat->format.code,
+					       CS_SEL_YUV);
+		if (!cc) {
+			imx_media_enum_ipu_format(&code, 0, CS_SEL_YUV);
+			cc = imx_media_find_ipu_format(code, CS_SEL_YUV);
+			sdformat->format.code = cc->codes[0];
 		}
+		/* input must be interlaced! Choose SEQ_TB if not */
+		if (!V4L2_FIELD_HAS_BOTH(sdformat->format.field))
+			sdformat->format.field = V4L2_FIELD_SEQ_TB;
+		break;
+	case VDIC_SINK_PAD_IDMAC:
+		v4l_bound_align_image(&sdformat->format.width,
+				      MIN_W, MAX_W_VDIC, W_ALIGN,
+				      &sdformat->format.height,
+				      MIN_H, MAX_H_VDIC, H_ALIGN, S_ALIGN);
 
+		cc = imx_media_find_mbus_format(sdformat->format.code,
+						CS_SEL_YUV, false);
+		if (!cc) {
+			imx_media_enum_mbus_format(&code, 0, CS_SEL_YUV, false);
+			cc = imx_media_find_mbus_format(code, CS_SEL_YUV, false);
+			sdformat->format.code = cc->codes[0];
+		}
 		/* input must be interlaced! Choose SEQ_TB if not */
 		if (!V4L2_FIELD_HAS_BOTH(sdformat->format.field))
 			sdformat->format.field = V4L2_FIELD_SEQ_TB;
@@ -766,7 +782,7 @@ static int vdic_registered(struct v4l2_subdev *sd)
 
 		code = 0;
 		if (i != VDIC_SINK_PAD_IDMAC)
-			imx_media_enum_ipu_format(NULL, &code, 0, true);
+			imx_media_enum_ipu_format(&code, 0, CS_SEL_YUV);
 
 		/* set a default mbus format  */
 		ret = imx_media_init_mbus_fmt(&priv->format_mbus[i],
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index 7f19739..4ac2bb6 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -171,16 +171,23 @@ struct imx_media_dev {
 	struct v4l2_async_notifier subdev_notifier;
 };
 
-const struct imx_media_pixfmt *imx_media_find_format(u32 fourcc, u32 code,
-						     bool allow_rgb,
-						     bool allow_planar);
-const struct imx_media_pixfmt *imx_media_find_ipu_format(u32 fourcc, u32 code,
-							 bool allow_rgb);
-
-int imx_media_enum_format(u32 *fourcc, u32 *code, u32 index,
-			  bool allow_rgb, bool allow_planar);
-int imx_media_enum_ipu_format(u32 *fourcc, u32 *code, u32 index,
-			      bool allow_rgb);
+enum codespace_sel {
+	CS_SEL_YUV = 0,
+	CS_SEL_RGB,
+	CS_SEL_ANY,
+};
+
+const struct imx_media_pixfmt *
+imx_media_find_format(u32 fourcc, enum codespace_sel cs_sel);
+int imx_media_enum_format(u32 *fourcc, u32 index, enum codespace_sel cs_sel);
+const struct imx_media_pixfmt *
+imx_media_find_mbus_format(u32 code, enum codespace_sel cs_sel,
+			   bool allow_bayer);
+int imx_media_enum_mbus_format(u32 *code, u32 index, enum codespace_sel cs_sel,
+			       bool allow_bayer);
+const struct imx_media_pixfmt *
+imx_media_find_ipu_format(u32 code, enum codespace_sel cs_sel);
+int imx_media_enum_ipu_format(u32 *code, u32 index, enum codespace_sel cs_sel);
 
 int imx_media_init_mbus_fmt(struct v4l2_mbus_framefmt *mbus,
 			    u32 width, u32 height, u32 code, u32 field,
-- 
2.7.4
