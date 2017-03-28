Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35801 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754136AbdC1AnG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 20:43:06 -0400
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
Subject: [PATCH v6 35/39] media: imx: propagate sink pad formats to source pads
Date: Mon, 27 Mar 2017 17:40:52 -0700
Message-Id: <1490661656-10318-36-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As part of this, separate format try code from *_set_fmt() into
*_try_fmt(), so that the latter function can be used to propagate
a legal format from sink to source. This also reduces subsequent
bloat in *_set_fmt().

imx-ic-prp never needed separate formats for sink and source pads,
so propagation in this case was easy, just have only a single
format shared by both pads.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-ic-prp.c        |  39 ++---
 drivers/staging/media/imx/imx-ic-prpencvf.c   |  95 +++++++----
 drivers/staging/media/imx/imx-media-capture.c |  13 ++
 drivers/staging/media/imx/imx-media-csi.c     | 224 +++++++++++++++-----------
 drivers/staging/media/imx/imx-media-vdic.c    |  82 ++++++----
 5 files changed, 279 insertions(+), 174 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-prp.c b/drivers/staging/media/imx/imx-ic-prp.c
index 505f456..b4d4e48 100644
--- a/drivers/staging/media/imx/imx-ic-prp.c
+++ b/drivers/staging/media/imx/imx-ic-prp.c
@@ -56,8 +56,7 @@ struct prp_priv {
 	/* the CSI id at link validate */
 	int csi_id;
 
-	struct v4l2_mbus_framefmt format_mbus[PRP_NUM_PADS];
-	const struct imx_media_pixfmt *cc[PRP_NUM_PADS];
+	struct v4l2_mbus_framefmt format_mbus;
 
 	bool stream_on; /* streaming is on */
 };
@@ -97,7 +96,7 @@ __prp_get_fmt(struct prp_priv *priv, struct v4l2_subdev_pad_config *cfg,
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
 		return v4l2_subdev_get_try_format(&ic_priv->sd, cfg, pad);
 	else
-		return &priv->format_mbus[pad];
+		return &priv->format_mbus;
 }
 
 /*
@@ -166,8 +165,8 @@ static int prp_set_fmt(struct v4l2_subdev *sd,
 		       struct v4l2_subdev_format *sdformat)
 {
 	struct prp_priv *priv = sd_to_priv(sd);
-	const struct imx_media_pixfmt *cc = NULL;
-	struct v4l2_mbus_framefmt *infmt;
+	const struct imx_media_pixfmt *cc;
+	struct v4l2_mbus_framefmt *fmt;
 	int ret = 0;
 	u32 code;
 
@@ -198,20 +197,13 @@ static int prp_set_fmt(struct v4l2_subdev *sd,
 	case PRP_SRC_PAD_PRPENC:
 	case PRP_SRC_PAD_PRPVF:
 		/* Output pads mirror input pad */
-		infmt = __prp_get_fmt(priv, cfg, PRP_SINK_PAD,
-				      sdformat->which);
-		cc = imx_media_find_ipu_format(infmt->code, CS_SEL_ANY);
-		sdformat->format = *infmt;
+		fmt = __prp_get_fmt(priv, cfg, PRP_SINK_PAD, sdformat->which);
+		sdformat->format = *fmt;
 		break;
 	}
 
-	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {
-		cfg->try_fmt = sdformat->format;
-	} else {
-		priv->format_mbus[sdformat->pad] = sdformat->format;
-		priv->cc[sdformat->pad] = cc;
-	}
-
+	fmt = __prp_get_fmt(priv, cfg, sdformat->pad, sdformat->which);
+	*fmt = sdformat->format;
 out:
 	mutex_unlock(&priv->lock);
 	return ret;
@@ -392,16 +384,15 @@ static int prp_registered(struct v4l2_subdev *sd)
 	for (i = 0; i < PRP_NUM_PADS; i++) {
 		priv->pad[i].flags = (i == PRP_SINK_PAD) ?
 			MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
-
-		/* set a default mbus format  */
-		imx_media_enum_ipu_format(&code, 0, CS_SEL_YUV);
-		ret = imx_media_init_mbus_fmt(&priv->format_mbus[i],
-					      640, 480, code, V4L2_FIELD_NONE,
-					      &priv->cc[i]);
-		if (ret)
-			return ret;
 	}
 
+	/* set a default mbus format  */
+	imx_media_enum_ipu_format(&code, 0, CS_SEL_YUV);
+	ret = imx_media_init_mbus_fmt(&priv->format_mbus, 640, 480, code,
+				      V4L2_FIELD_NONE, NULL);
+	if (ret)
+		return ret;
+
 	return media_entity_pads_init(&sd->entity, PRP_NUM_PADS, priv->pad);
 }
 
diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index 9babfa3..4123b03 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -767,35 +767,23 @@ static int prp_get_fmt(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static int prp_set_fmt(struct v4l2_subdev *sd,
-		       struct v4l2_subdev_pad_config *cfg,
-		       struct v4l2_subdev_format *sdformat)
+static void prp_try_fmt(struct prp_priv *priv,
+			struct v4l2_subdev_pad_config *cfg,
+			struct v4l2_subdev_format *sdformat,
+			const struct imx_media_pixfmt **cc)
 {
-	struct prp_priv *priv = sd_to_priv(sd);
-	const struct imx_media_pixfmt *cc;
-	struct v4l2_mbus_framefmt *infmt;
-	int ret = 0;
-	u32 code;
-
-	if (sdformat->pad >= PRPENCVF_NUM_PADS)
-		return -EINVAL;
-
-	mutex_lock(&priv->lock);
-
-	if (priv->stream_on) {
-		ret = -EBUSY;
-		goto out;
-	}
+	*cc = imx_media_find_ipu_format(sdformat->format.code, CS_SEL_ANY);
+	if (!*cc) {
+		u32 code;
 
-	cc = imx_media_find_ipu_format(sdformat->format.code, CS_SEL_ANY);
-	if (!cc) {
 		imx_media_enum_ipu_format(&code, 0, CS_SEL_ANY);
-		cc = imx_media_find_ipu_format(code, CS_SEL_ANY);
-		sdformat->format.code = cc->codes[0];
+		*cc = imx_media_find_ipu_format(code, CS_SEL_ANY);
+		sdformat->format.code = (*cc)->codes[0];
 	}
 
 	if (sdformat->pad == PRPENCVF_SRC_PAD) {
-		infmt = __prp_get_fmt(priv, cfg, PRPENCVF_SINK_PAD,
+		struct v4l2_mbus_framefmt *infmt =
+			__prp_get_fmt(priv, cfg, PRPENCVF_SINK_PAD,
 				      sdformat->which);
 
 		if (sdformat->format.field != V4L2_FIELD_NONE)
@@ -823,14 +811,65 @@ static int prp_set_fmt(struct v4l2_subdev *sd,
 				      MIN_H_SINK, MAX_H_SINK, H_ALIGN_SINK,
 				      S_ALIGN);
 	}
+}
 
-	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {
-		cfg->try_fmt = sdformat->format;
-	} else {
-		priv->format_mbus[sdformat->pad] = sdformat->format;
-		priv->cc[sdformat->pad] = cc;
+static int prp_set_fmt(struct v4l2_subdev *sd,
+		       struct v4l2_subdev_pad_config *cfg,
+		       struct v4l2_subdev_format *sdformat)
+{
+	struct prp_priv *priv = sd_to_priv(sd);
+	struct imx_media_video_dev *vdev = priv->vdev;
+	const struct imx_media_pixfmt *cc;
+	struct v4l2_pix_format vdev_fmt;
+	struct v4l2_mbus_framefmt *fmt;
+	int ret = 0;
+
+	if (sdformat->pad >= PRPENCVF_NUM_PADS)
+		return -EINVAL;
+
+	mutex_lock(&priv->lock);
+
+	if (priv->stream_on) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	prp_try_fmt(priv, cfg, sdformat, &cc);
+
+	fmt = __prp_get_fmt(priv, cfg, sdformat->pad, sdformat->which);
+	*fmt = sdformat->format;
+
+	/* propagate a default format to source pad */
+	if (sdformat->pad == PRPENCVF_SINK_PAD) {
+		const struct imx_media_pixfmt *outcc;
+		struct v4l2_mbus_framefmt *outfmt;
+		struct v4l2_subdev_format format;
+
+		format.pad = PRPENCVF_SRC_PAD;
+		format.which = sdformat->which;
+		format.format = sdformat->format;
+		prp_try_fmt(priv, cfg, &format, &outcc);
+
+		outfmt = __prp_get_fmt(priv, cfg, PRPENCVF_SRC_PAD,
+				       sdformat->which);
+		*outfmt = format.format;
+		if (sdformat->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+			priv->cc[PRPENCVF_SRC_PAD] = outcc;
 	}
 
+	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY)
+		goto out;
+
+	priv->cc[sdformat->pad] = cc;
+
+	/* propagate output pad format to capture device */
+	imx_media_mbus_fmt_to_pix_fmt(&vdev_fmt,
+				      &priv->format_mbus[PRPENCVF_SRC_PAD],
+				      priv->cc[PRPENCVF_SRC_PAD]);
+	mutex_unlock(&priv->lock);
+	imx_media_capture_device_set_format(vdev, &vdev_fmt);
+
+	return 0;
 out:
 	mutex_unlock(&priv->lock);
 	return ret;
diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index ff0a6ed..7521ca9 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -506,6 +506,19 @@ static struct video_device capture_videodev = {
 	.device_caps	= V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING,
 };
 
+void imx_media_capture_device_set_format(struct imx_media_video_dev *vdev,
+					 struct v4l2_pix_format *pix)
+{
+	struct capture_priv *priv = to_capture_priv(vdev);
+
+	mutex_lock(&priv->mutex);
+	priv->vdev.fmt.fmt.pix = *pix;
+	priv->vdev.cc = imx_media_find_format(pix->pixelformat, CS_SEL_ANY,
+					      false);
+	mutex_unlock(&priv->mutex);
+}
+EXPORT_SYMBOL_GPL(imx_media_capture_device_set_format);
+
 struct imx_media_buffer *
 imx_media_capture_device_next_buf(struct imx_media_video_dev *vdev)
 {
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index dee5733..6b8f875 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1022,11 +1022,21 @@ __csi_get_fmt(struct csi_priv *priv, struct v4l2_subdev_pad_config *cfg,
 		return &priv->format_mbus[pad];
 }
 
-static int csi_try_crop(struct csi_priv *priv,
-			struct v4l2_rect *crop,
-			struct v4l2_subdev_pad_config *cfg,
-			struct v4l2_mbus_framefmt *infmt,
-			struct imx_media_subdev *sensor)
+static struct v4l2_rect *
+__csi_get_crop(struct csi_priv *priv, struct v4l2_subdev_pad_config *cfg,
+	       enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_crop(&priv->sd, cfg, CSI_SINK_PAD);
+	else
+		return &priv->crop;
+}
+
+static void csi_try_crop(struct csi_priv *priv,
+			 struct v4l2_rect *crop,
+			 struct v4l2_subdev_pad_config *cfg,
+			 struct v4l2_mbus_framefmt *infmt,
+			 struct imx_media_subdev *sensor)
 {
 	struct v4l2_of_endpoint *sensor_ep;
 
@@ -1055,8 +1065,6 @@ static int csi_try_crop(struct csi_priv *priv,
 		if (crop->top + crop->height > infmt->height)
 			crop->top = infmt->height - crop->height;
 	}
-
-	return 0;
 }
 
 static int csi_enum_mbus_code(struct v4l2_subdev *sd,
@@ -1128,34 +1136,17 @@ static int csi_get_fmt(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static int csi_set_fmt(struct v4l2_subdev *sd,
-		       struct v4l2_subdev_pad_config *cfg,
-		       struct v4l2_subdev_format *sdformat)
+static void csi_try_fmt(struct csi_priv *priv,
+			struct imx_media_subdev *sensor,
+			struct v4l2_subdev_pad_config *cfg,
+			struct v4l2_subdev_format *sdformat,
+			struct v4l2_rect *crop,
+			const struct imx_media_pixfmt **cc)
 {
-	struct csi_priv *priv = v4l2_get_subdevdata(sd);
-	const struct imx_media_pixfmt *cc, *incc;
+	const struct imx_media_pixfmt *incc;
 	struct v4l2_mbus_framefmt *infmt;
-	struct imx_media_subdev *sensor;
-	struct v4l2_rect crop;
-	int ret = 0;
 	u32 code;
 
-	if (sdformat->pad >= CSI_NUM_PADS)
-		return -EINVAL;
-
-	sensor = imx_media_find_sensor(priv->md, &priv->sd.entity);
-	if (IS_ERR(sensor)) {
-		v4l2_err(&priv->sd, "no sensor attached\n");
-		return PTR_ERR(sensor);
-	}
-
-	mutex_lock(&priv->lock);
-
-	if (priv->stream_on) {
-		ret = -EBUSY;
-		goto out;
-	}
-
 	switch (sdformat->pad) {
 	case CSI_SRC_PAD_DIRECT:
 	case CSI_SRC_PAD_IDMAC:
@@ -1164,29 +1155,29 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 		incc = imx_media_find_mbus_format(infmt->code,
 						  CS_SEL_ANY, true);
 
-		if (sdformat->format.width < priv->crop.width * 3 / 4)
-			sdformat->format.width = priv->crop.width / 2;
+		if (sdformat->format.width < crop->width * 3 / 4)
+			sdformat->format.width = crop->width / 2;
 		else
-			sdformat->format.width = priv->crop.width;
+			sdformat->format.width = crop->width;
 
-		if (sdformat->format.height < priv->crop.height * 3 / 4)
-			sdformat->format.height = priv->crop.height / 2;
+		if (sdformat->format.height < crop->height * 3 / 4)
+			sdformat->format.height = crop->height / 2;
 		else
-			sdformat->format.height = priv->crop.height;
+			sdformat->format.height = crop->height;
 
 		if (incc->bayer) {
 			sdformat->format.code = infmt->code;
-			cc = incc;
+			*cc = incc;
 		} else {
 			u32 cs_sel = (incc->cs == IPUV3_COLORSPACE_YUV) ?
 				CS_SEL_YUV : CS_SEL_RGB;
 
-			cc = imx_media_find_ipu_format(sdformat->format.code,
-						       cs_sel);
-			if (!cc) {
+			*cc = imx_media_find_ipu_format(sdformat->format.code,
+							cs_sel);
+			if (!*cc) {
 				imx_media_enum_ipu_format(&code, 0, cs_sel);
-				cc = imx_media_find_ipu_format(code, cs_sel);
-				sdformat->format.code = cc->codes[0];
+				*cc = imx_media_find_ipu_format(code, cs_sel);
+				sdformat->format.code = (*cc)->codes[0];
 			}
 		}
 
@@ -1208,39 +1199,96 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 		v4l_bound_align_image(&sdformat->format.width, MIN_W, MAX_W,
 				      W_ALIGN, &sdformat->format.height,
 				      MIN_H, MAX_H, H_ALIGN, S_ALIGN);
-		crop.left = 0;
-		crop.top = 0;
-		crop.width = sdformat->format.width;
-		crop.height = sdformat->format.height;
-		ret = csi_try_crop(priv, &crop, cfg, &sdformat->format, sensor);
-		if (ret)
-			goto out;
+		crop->left = 0;
+		crop->top = 0;
+		crop->width = sdformat->format.width;
+		crop->height = sdformat->format.height;
+		csi_try_crop(priv, crop, cfg, &sdformat->format, sensor);
 
-		cc = imx_media_find_mbus_format(sdformat->format.code,
-						CS_SEL_ANY, true);
-		if (!cc) {
+		*cc = imx_media_find_mbus_format(sdformat->format.code,
+						 CS_SEL_ANY, true);
+		if (!*cc) {
 			imx_media_enum_mbus_format(&code, 0,
 						   CS_SEL_ANY, false);
-			cc = imx_media_find_mbus_format(code,
+			*cc = imx_media_find_mbus_format(code,
 							CS_SEL_ANY, false);
-			sdformat->format.code = cc->codes[0];
+			sdformat->format.code = (*cc)->codes[0];
 		}
 		break;
-	default:
-		ret = -EINVAL;
+	}
+}
+
+static int csi_set_fmt(struct v4l2_subdev *sd,
+		       struct v4l2_subdev_pad_config *cfg,
+		       struct v4l2_subdev_format *sdformat)
+{
+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	struct imx_media_video_dev *vdev = priv->vdev;
+	const struct imx_media_pixfmt *cc;
+	struct imx_media_subdev *sensor;
+	struct v4l2_pix_format vdev_fmt;
+	struct v4l2_mbus_framefmt *fmt;
+	struct v4l2_rect *crop;
+	int ret = 0;
+
+	if (sdformat->pad >= CSI_NUM_PADS)
+		return -EINVAL;
+
+	sensor = imx_media_find_sensor(priv->md, &priv->sd.entity);
+	if (IS_ERR(sensor)) {
+		v4l2_err(&priv->sd, "no sensor attached\n");
+		return PTR_ERR(sensor);
+	}
+
+	mutex_lock(&priv->lock);
+
+	if (priv->stream_on) {
+		ret = -EBUSY;
 		goto out;
 	}
 
-	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {
-		cfg->try_fmt = sdformat->format;
-	} else {
-		priv->format_mbus[sdformat->pad] = sdformat->format;
-		priv->cc[sdformat->pad] = cc;
-		/* Reset the crop window if this is the input pad */
-		if (sdformat->pad == CSI_SINK_PAD)
-			priv->crop = crop;
+	crop = __csi_get_crop(priv, cfg, sdformat->which);
+
+	csi_try_fmt(priv, sensor, cfg, sdformat, crop, &cc);
+
+	fmt = __csi_get_fmt(priv, cfg, sdformat->pad, sdformat->which);
+	*fmt = sdformat->format;
+
+	if (sdformat->pad == CSI_SINK_PAD) {
+		int pad;
+
+		/* propagate format to source pads */
+		for (pad = CSI_SINK_PAD + 1; pad < CSI_NUM_PADS; pad++) {
+			const struct imx_media_pixfmt *outcc;
+			struct v4l2_mbus_framefmt *outfmt;
+			struct v4l2_subdev_format format;
+
+			format.pad = pad;
+			format.which = sdformat->which;
+			format.format = sdformat->format;
+			csi_try_fmt(priv, sensor, cfg, &format, crop, &outcc);
+
+			outfmt = __csi_get_fmt(priv, cfg, pad, sdformat->which);
+			*outfmt = format.format;
+
+			if (sdformat->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+				priv->cc[pad] = outcc;
+		}
 	}
 
+	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY)
+		goto out;
+
+	priv->cc[sdformat->pad] = cc;
+
+	/* propagate IDMAC output pad format to capture device */
+	imx_media_mbus_fmt_to_pix_fmt(&vdev_fmt,
+				      &priv->format_mbus[CSI_SRC_PAD_IDMAC],
+				      priv->cc[CSI_SRC_PAD_IDMAC]);
+	mutex_unlock(&priv->lock);
+	imx_media_capture_device_set_format(vdev, &vdev_fmt);
+
+	return 0;
 out:
 	mutex_unlock(&priv->lock);
 	return ret;
@@ -1252,6 +1300,7 @@ static int csi_get_selection(struct v4l2_subdev *sd,
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *infmt;
+	struct v4l2_rect *crop;
 	int ret = 0;
 
 	if (sel->pad >= CSI_NUM_PADS || sel->pad == CSI_SINK_PAD)
@@ -1260,10 +1309,7 @@ static int csi_get_selection(struct v4l2_subdev *sd,
 	mutex_lock(&priv->lock);
 
 	infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD, sel->which);
-	if (!infmt) {
-		ret = -EINVAL;
-		goto out;
-	}
+	crop = __csi_get_crop(priv, cfg, sel->which);
 
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP_BOUNDS:
@@ -1273,20 +1319,12 @@ static int csi_get_selection(struct v4l2_subdev *sd,
 		sel->r.height = infmt->height;
 		break;
 	case V4L2_SEL_TGT_CROP:
-		if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
-			struct v4l2_rect *try_crop =
-				v4l2_subdev_get_try_crop(&priv->sd,
-							 cfg, sel->pad);
-			sel->r = *try_crop;
-		} else {
-			sel->r = priv->crop;
-		}
+		sel->r = *crop;
 		break;
 	default:
 		ret = -EINVAL;
 	}
 
-out:
 	mutex_unlock(&priv->lock);
 	return ret;
 }
@@ -1298,7 +1336,8 @@ static int csi_set_selection(struct v4l2_subdev *sd,
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *infmt;
 	struct imx_media_subdev *sensor;
-	int ret = 0;
+	struct v4l2_rect *crop;
+	int pad, ret = 0;
 
 	if (sel->pad >= CSI_NUM_PADS ||
 	    sel->pad == CSI_SINK_PAD ||
@@ -1318,6 +1357,9 @@ static int csi_set_selection(struct v4l2_subdev *sd,
 		goto out;
 	}
 
+	infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD, sel->which);
+	crop = __csi_get_crop(priv, cfg, sel->which);
+
 	/*
 	 * Modifying the crop rectangle always changes the format on the source
 	 * pad. If the KEEP_CONFIG flag is set, just return the current crop
@@ -1326,25 +1368,21 @@ static int csi_set_selection(struct v4l2_subdev *sd,
 	if (sel->flags & V4L2_SEL_FLAG_KEEP_CONFIG) {
 		sel->r = priv->crop;
 		if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
-			cfg->try_crop = sel->r;
+			*crop = sel->r;
 		goto out;
 	}
 
-	infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD, sel->which);
-	ret = csi_try_crop(priv, &sel->r, cfg, infmt, sensor);
-	if (ret)
-		goto out;
+	csi_try_crop(priv, &sel->r, cfg, infmt, sensor);
 
-	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
-		cfg->try_crop = sel->r;
-	} else {
-		struct v4l2_mbus_framefmt *outfmt =
-			&priv->format_mbus[sel->pad];
+	*crop = sel->r;
+
+	/* Update the source pad formats */
+	for (pad = CSI_SINK_PAD + 1; pad < CSI_NUM_PADS; pad++) {
+		struct v4l2_mbus_framefmt *outfmt;
 
-		priv->crop = sel->r;
-		/* Update the source format */
-		outfmt->width = sel->r.width;
-		outfmt->height = sel->r.height;
+		outfmt = __csi_get_fmt(priv, cfg, pad, sel->which);
+		outfmt->width = crop->width;
+		outfmt->height = crop->height;
 	}
 
 out:
diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
index cd28dd8..0da45cf 100644
--- a/drivers/staging/media/imx/imx-media-vdic.c
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -561,39 +561,27 @@ static int vdic_get_fmt(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static int vdic_set_fmt(struct v4l2_subdev *sd,
-			struct v4l2_subdev_pad_config *cfg,
-			struct v4l2_subdev_format *sdformat)
+static void vdic_try_fmt(struct vdic_priv *priv,
+			 struct v4l2_subdev_pad_config *cfg,
+			 struct v4l2_subdev_format *sdformat,
+			 const struct imx_media_pixfmt **cc)
 {
-	struct vdic_priv *priv = v4l2_get_subdevdata(sd);
-	const struct imx_media_pixfmt *cc;
 	struct v4l2_mbus_framefmt *infmt;
-	int ret = 0;
-	u32 code;
 
-	if (sdformat->pad >= VDIC_NUM_PADS)
-		return -EINVAL;
-
-	mutex_lock(&priv->lock);
+	*cc = imx_media_find_ipu_format(sdformat->format.code, CS_SEL_YUV);
+	if (!*cc) {
+		u32 code;
 
-	if (priv->stream_on) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	cc = imx_media_find_ipu_format(sdformat->format.code, CS_SEL_YUV);
-	if (!cc) {
 		imx_media_enum_ipu_format(&code, 0, CS_SEL_YUV);
-		cc = imx_media_find_ipu_format(code, CS_SEL_YUV);
-		sdformat->format.code = cc->codes[0];
+		*cc = imx_media_find_ipu_format(code, CS_SEL_YUV);
+		sdformat->format.code = (*cc)->codes[0];
 	}
 
 	switch (sdformat->pad) {
 	case VDIC_SRC_PAD_DIRECT:
 		infmt = __vdic_get_fmt(priv, cfg, priv->active_input_pad,
 				       sdformat->which);
-		sdformat->format.width = infmt->width;
-		sdformat->format.height = infmt->height;
+		sdformat->format = *infmt;
 		/* output is always progressive! */
 		sdformat->format.field = V4L2_FIELD_NONE;
 		break;
@@ -608,18 +596,54 @@ static int vdic_set_fmt(struct v4l2_subdev *sd,
 		if (!V4L2_FIELD_HAS_BOTH(sdformat->format.field))
 			sdformat->format.field = V4L2_FIELD_SEQ_TB;
 		break;
-	default:
-		ret = -EINVAL;
+	}
+}
+
+static int vdic_set_fmt(struct v4l2_subdev *sd,
+			struct v4l2_subdev_pad_config *cfg,
+			struct v4l2_subdev_format *sdformat)
+{
+	struct vdic_priv *priv = v4l2_get_subdevdata(sd);
+	const struct imx_media_pixfmt *cc;
+	struct v4l2_mbus_framefmt *fmt;
+	int ret = 0;
+
+	if (sdformat->pad >= VDIC_NUM_PADS)
+		return -EINVAL;
+
+	mutex_lock(&priv->lock);
+
+	if (priv->stream_on) {
+		ret = -EBUSY;
 		goto out;
 	}
 
-	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {
-		cfg->try_fmt = sdformat->format;
-	} else {
-		priv->format_mbus[sdformat->pad] = sdformat->format;
-		priv->cc[sdformat->pad] = cc;
+	vdic_try_fmt(priv, cfg, sdformat, &cc);
+
+	fmt = __vdic_get_fmt(priv, cfg, sdformat->pad, sdformat->which);
+	*fmt = sdformat->format;
+
+	/* propagate format to source pad */
+	if (sdformat->pad == VDIC_SINK_PAD_DIRECT ||
+	    sdformat->pad == VDIC_SINK_PAD_IDMAC) {
+		const struct imx_media_pixfmt *outcc;
+		struct v4l2_mbus_framefmt *outfmt;
+		struct v4l2_subdev_format format;
+
+		format.pad = VDIC_SRC_PAD_DIRECT;
+		format.which = sdformat->which;
+		format.format = sdformat->format;
+		vdic_try_fmt(priv, cfg, &format, &outcc);
+
+		outfmt = __vdic_get_fmt(priv, cfg, VDIC_SRC_PAD_DIRECT,
+					sdformat->which);
+		*outfmt = format.format;
+		if (sdformat->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+			priv->cc[VDIC_SRC_PAD_DIRECT] = outcc;
 	}
 
+	if (sdformat->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		priv->cc[sdformat->pad] = cc;
 out:
 	mutex_unlock(&priv->lock);
 	return ret;
-- 
2.7.4
