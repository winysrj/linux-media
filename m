Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36689 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753706AbdC1AnV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 20:43:21 -0400
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
        devel@driverdev.osuosl.org
Subject: [PATCH v6 36/39] media: imx: csi: add sink selection rectangles
Date: Mon, 27 Mar 2017 17:40:53 -0700
Message-Id: <1490661656-10318-37-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

Move the crop rectangle to the sink pad and add a sink compose rectangle
to configure scaling. Also propagate rectangles from sink pad to crop
rectangle, to compose rectangle, and to the source pads both in ACTIVE
and TRY variants of set_fmt/selection, and initialize the default crop
and compose rectangles.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/media/imx/imx-media-csi.c | 153 +++++++++++++++++++++++-------
 1 file changed, 117 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 6b8f875..19609a7 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -80,6 +80,7 @@ struct csi_priv {
 	const struct imx_media_pixfmt *cc[CSI_NUM_PADS];
 	struct v4l2_fract frame_interval;
 	struct v4l2_rect crop;
+	struct v4l2_rect compose;
 	const struct csi_skip_desc *skip[CSI_NUM_PADS - 1];
 
 	/* active vb2 buffers to send to video dev sink */
@@ -575,8 +576,8 @@ static int csi_setup(struct csi_priv *priv)
 	ipu_csi_set_window(priv->csi, &priv->crop);
 
 	ipu_csi_set_downsize(priv->csi,
-			     priv->crop.width == 2 * outfmt->width,
-			     priv->crop.height == 2 * outfmt->height);
+			     priv->crop.width == 2 * priv->compose.width,
+			     priv->crop.height == 2 * priv->compose.height);
 
 	ipu_csi_init_interface(priv->csi, &sensor_mbus_cfg, &if_fmt);
 
@@ -1032,6 +1033,17 @@ __csi_get_crop(struct csi_priv *priv, struct v4l2_subdev_pad_config *cfg,
 		return &priv->crop;
 }
 
+static struct v4l2_rect *
+__csi_get_compose(struct csi_priv *priv, struct v4l2_subdev_pad_config *cfg,
+		  enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_compose(&priv->sd, cfg,
+						   CSI_SINK_PAD);
+	else
+		return &priv->compose;
+}
+
 static void csi_try_crop(struct csi_priv *priv,
 			 struct v4l2_rect *crop,
 			 struct v4l2_subdev_pad_config *cfg,
@@ -1141,6 +1153,7 @@ static void csi_try_fmt(struct csi_priv *priv,
 			struct v4l2_subdev_pad_config *cfg,
 			struct v4l2_subdev_format *sdformat,
 			struct v4l2_rect *crop,
+			struct v4l2_rect *compose,
 			const struct imx_media_pixfmt **cc)
 {
 	const struct imx_media_pixfmt *incc;
@@ -1155,15 +1168,8 @@ static void csi_try_fmt(struct csi_priv *priv,
 		incc = imx_media_find_mbus_format(infmt->code,
 						  CS_SEL_ANY, true);
 
-		if (sdformat->format.width < crop->width * 3 / 4)
-			sdformat->format.width = crop->width / 2;
-		else
-			sdformat->format.width = crop->width;
-
-		if (sdformat->format.height < crop->height * 3 / 4)
-			sdformat->format.height = crop->height / 2;
-		else
-			sdformat->format.height = crop->height;
+		sdformat->format.width = compose->width;
+		sdformat->format.height = compose->height;
 
 		if (incc->bayer) {
 			sdformat->format.code = infmt->code;
@@ -1199,11 +1205,17 @@ static void csi_try_fmt(struct csi_priv *priv,
 		v4l_bound_align_image(&sdformat->format.width, MIN_W, MAX_W,
 				      W_ALIGN, &sdformat->format.height,
 				      MIN_H, MAX_H, H_ALIGN, S_ALIGN);
+
+		/* Reset crop and compose rectangles */
 		crop->left = 0;
 		crop->top = 0;
 		crop->width = sdformat->format.width;
 		crop->height = sdformat->format.height;
 		csi_try_crop(priv, crop, cfg, &sdformat->format, sensor);
+		compose->left = 0;
+		compose->top = 0;
+		compose->width = crop->width;
+		compose->height = crop->height;
 
 		*cc = imx_media_find_mbus_format(sdformat->format.code,
 						 CS_SEL_ANY, true);
@@ -1228,7 +1240,7 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 	struct imx_media_subdev *sensor;
 	struct v4l2_pix_format vdev_fmt;
 	struct v4l2_mbus_framefmt *fmt;
-	struct v4l2_rect *crop;
+	struct v4l2_rect *crop, *compose;
 	int ret = 0;
 
 	if (sdformat->pad >= CSI_NUM_PADS)
@@ -1248,8 +1260,9 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 	}
 
 	crop = __csi_get_crop(priv, cfg, sdformat->which);
+	compose = __csi_get_compose(priv, cfg, sdformat->which);
 
-	csi_try_fmt(priv, sensor, cfg, sdformat, crop, &cc);
+	csi_try_fmt(priv, sensor, cfg, sdformat, crop, compose, &cc);
 
 	fmt = __csi_get_fmt(priv, cfg, sdformat->pad, sdformat->which);
 	*fmt = sdformat->format;
@@ -1266,7 +1279,8 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 			format.pad = pad;
 			format.which = sdformat->which;
 			format.format = sdformat->format;
-			csi_try_fmt(priv, sensor, cfg, &format, crop, &outcc);
+			csi_try_fmt(priv, sensor, cfg, &format, NULL, compose,
+				    &outcc);
 
 			outfmt = __csi_get_fmt(priv, cfg, pad, sdformat->which);
 			*outfmt = format.format;
@@ -1300,16 +1314,17 @@ static int csi_get_selection(struct v4l2_subdev *sd,
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *infmt;
-	struct v4l2_rect *crop;
+	struct v4l2_rect *crop, *compose;
 	int ret = 0;
 
-	if (sel->pad >= CSI_NUM_PADS || sel->pad == CSI_SINK_PAD)
+	if (sel->pad != CSI_SINK_PAD)
 		return -EINVAL;
 
 	mutex_lock(&priv->lock);
 
 	infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD, sel->which);
 	crop = __csi_get_crop(priv, cfg, sel->which);
+	compose = __csi_get_compose(priv, cfg, sel->which);
 
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP_BOUNDS:
@@ -1321,6 +1336,15 @@ static int csi_get_selection(struct v4l2_subdev *sd,
 	case V4L2_SEL_TGT_CROP:
 		sel->r = *crop;
 		break;
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = crop->width;
+		sel->r.height = crop->height;
+		break;
+	case V4L2_SEL_TGT_COMPOSE:
+		sel->r = *compose;
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -1329,19 +1353,34 @@ static int csi_get_selection(struct v4l2_subdev *sd,
 	return ret;
 }
 
+static int csi_set_scale(u32 *compose, u32 crop, u32 flags)
+{
+	if ((flags & (V4L2_SEL_FLAG_LE | V4L2_SEL_FLAG_GE)) ==
+		     (V4L2_SEL_FLAG_LE | V4L2_SEL_FLAG_GE) &&
+	    *compose != crop && *compose != crop / 2)
+		return -ERANGE;
+
+	if (*compose <= crop / 2 ||
+	    (*compose < crop * 3 / 4 && !(flags & V4L2_SEL_FLAG_GE)) ||
+	    (*compose < crop && (flags & V4L2_SEL_FLAG_LE)))
+		*compose = crop / 2;
+	else
+		*compose = crop;
+
+	return 0;
+}
+
 static int csi_set_selection(struct v4l2_subdev *sd,
 			     struct v4l2_subdev_pad_config *cfg,
 			     struct v4l2_subdev_selection *sel)
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *infmt;
+	struct v4l2_rect *crop, *compose;
 	struct imx_media_subdev *sensor;
-	struct v4l2_rect *crop;
 	int pad, ret = 0;
 
-	if (sel->pad >= CSI_NUM_PADS ||
-	    sel->pad == CSI_SINK_PAD ||
-	    sel->target != V4L2_SEL_TGT_CROP)
+	if (sel->pad != CSI_SINK_PAD)
 		return -EINVAL;
 
 	sensor = imx_media_find_sensor(priv->md, &priv->sd.entity);
@@ -1359,30 +1398,66 @@ static int csi_set_selection(struct v4l2_subdev *sd,
 
 	infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD, sel->which);
 	crop = __csi_get_crop(priv, cfg, sel->which);
+	compose = __csi_get_compose(priv, cfg, sel->which);
 
-	/*
-	 * Modifying the crop rectangle always changes the format on the source
-	 * pad. If the KEEP_CONFIG flag is set, just return the current crop
-	 * rectangle.
-	 */
-	if (sel->flags & V4L2_SEL_FLAG_KEEP_CONFIG) {
-		sel->r = priv->crop;
-		if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
-			*crop = sel->r;
-		goto out;
-	}
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP:
+		/*
+		 * Modifying the crop rectangle always changes the format on
+		 * the source pads. If the KEEP_CONFIG flag is set, just return
+		 * the current crop rectangle.
+		 */
+		if (sel->flags & V4L2_SEL_FLAG_KEEP_CONFIG) {
+			sel->r = priv->crop;
+			if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
+				*crop = sel->r;
+			goto out;
+		}
+
+		csi_try_crop(priv, &sel->r, cfg, infmt, sensor);
+
+		*crop = sel->r;
+
+		/* Reset scaling to 1:1 */
+		compose->width = crop->width;
+		compose->height = crop->height;
+		break;
+	case V4L2_SEL_TGT_COMPOSE:
+		/*
+		 * Modifying the compose rectangle always changes the format on
+		 * the source pads. If the KEEP_CONFIG flag is set, just return
+		 * the current compose rectangle.
+		 */
+		if (sel->flags & V4L2_SEL_FLAG_KEEP_CONFIG) {
+			sel->r = priv->compose;
+			if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
+				*compose = sel->r;
+			goto out;
+		}
 
-	csi_try_crop(priv, &sel->r, cfg, infmt, sensor);
+		sel->r.left = 0;
+		sel->r.top = 0;
+		ret = csi_set_scale(&sel->r.width, crop->width, sel->flags);
+		if (ret)
+			goto out;
+		ret = csi_set_scale(&sel->r.height, crop->height, sel->flags);
+		if (ret)
+			goto out;
 
-	*crop = sel->r;
+		*compose = sel->r;
+		break;
+	default:
+		ret = -EINVAL;
+		goto out;
+	}
 
-	/* Update the source pad formats */
+	/* Reset source pads to sink compose rectangle */
 	for (pad = CSI_SINK_PAD + 1; pad < CSI_NUM_PADS; pad++) {
 		struct v4l2_mbus_framefmt *outfmt;
 
 		outfmt = __csi_get_fmt(priv, cfg, pad, sel->which);
-		outfmt->width = crop->width;
-		outfmt->height = crop->height;
+		outfmt->width = compose->width;
+		outfmt->height = compose->height;
 	}
 
 out:
@@ -1445,6 +1520,12 @@ static int csi_registered(struct v4l2_subdev *sd)
 			priv->skip[i - 1] = &csi_skip[0];
 	}
 
+	/* init default crop and compose rectangle sizes */
+	priv->crop.width = 640;
+	priv->crop.height = 480;
+	priv->compose.width = 640;
+	priv->compose.height = 480;
+
 	/* init default frame interval */
 	priv->frame_interval.numerator = 1;
 	priv->frame_interval.denominator = 30;
-- 
2.7.4
