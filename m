Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35604 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754104AbdC1Amy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 20:42:54 -0400
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
Subject: [PATCH v6 29/39] media: imx: csi: add __csi_get_fmt
Date: Mon, 27 Mar 2017 17:40:46 -0700
Message-Id: <1490661656-10318-30-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add __csi_get_fmt() and use it to return the correct mbus format
(active or try) in get_fmt. Use it in other places as well.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Suggested-by: Russell King <linux@armlinux.org.uk>
---
 drivers/staging/media/imx/imx-media-csi.c | 61 ++++++++++++++++++++++++-------
 1 file changed, 47 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 730966b..f4c6a33 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -843,13 +843,26 @@ static int csi_eof_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 	return 0;
 }
 
-static int csi_try_crop(struct csi_priv *priv, struct v4l2_rect *crop,
+static struct v4l2_mbus_framefmt *
+__csi_get_fmt(struct csi_priv *priv, struct v4l2_subdev_pad_config *cfg,
+	      unsigned int pad, enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_format(&priv->sd, cfg, pad);
+	else
+		return &priv->format_mbus[pad];
+}
+
+static int csi_try_crop(struct csi_priv *priv,
+			struct v4l2_rect *crop,
+			struct v4l2_subdev_pad_config *cfg,
+			enum v4l2_subdev_format_whence which,
 			struct imx_media_subdev *sensor)
 {
 	struct v4l2_of_endpoint *sensor_ep;
 	struct v4l2_mbus_framefmt *infmt;
 
-	infmt = &priv->format_mbus[CSI_SINK_PAD];
+	infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD, which);
 	sensor_ep = &sensor->sensor_ep;
 
 	crop->width = min_t(__u32, infmt->width, crop->width);
@@ -899,17 +912,24 @@ static int csi_get_fmt(struct v4l2_subdev *sd,
 		       struct v4l2_subdev_format *sdformat)
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *fmt;
+	int ret = 0;
 
 	if (sdformat->pad >= CSI_NUM_PADS)
 		return -EINVAL;
 
 	mutex_lock(&priv->lock);
 
-	sdformat->format = priv->format_mbus[sdformat->pad];
+	fmt = __csi_get_fmt(priv, cfg, sdformat->pad, sdformat->which);
+	if (!fmt) {
+		ret = -EINVAL;
+		goto out;
+	}
 
+	sdformat->format = *fmt;
+out:
 	mutex_unlock(&priv->lock);
-
-	return 0;
+	return ret;
 }
 
 static int csi_set_fmt(struct v4l2_subdev *sd,
@@ -940,8 +960,6 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 		goto out;
 	}
 
-	infmt = &priv->format_mbus[CSI_SINK_PAD];
-
 	v4l_bound_align_image(&sdformat->format.width, MIN_W, MAX_W,
 			      W_ALIGN, &sdformat->format.height,
 			      MIN_H, MAX_H, H_ALIGN, S_ALIGN);
@@ -949,6 +967,8 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 	switch (sdformat->pad) {
 	case CSI_SRC_PAD_DIRECT:
 	case CSI_SRC_PAD_IDMAC:
+		infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD, sdformat->which);
+
 		if (sdformat->format.width < priv->crop.width * 3 / 4)
 			sdformat->format.width = priv->crop.width / 2;
 		else
@@ -1007,7 +1027,8 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 		crop.top = 0;
 		crop.width = sdformat->format.width;
 		crop.height = sdformat->format.height;
-		ret = csi_try_crop(priv, &crop, sensor);
+		ret = csi_try_crop(priv, &crop, cfg,
+				   sdformat->which, sensor);
 		if (ret)
 			goto out;
 
@@ -1052,7 +1073,11 @@ static int csi_get_selection(struct v4l2_subdev *sd,
 
 	mutex_lock(&priv->lock);
 
-	infmt = &priv->format_mbus[CSI_SINK_PAD];
+	infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD, sel->which);
+	if (!infmt) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP_BOUNDS:
@@ -1062,12 +1087,20 @@ static int csi_get_selection(struct v4l2_subdev *sd,
 		sel->r.height = infmt->height;
 		break;
 	case V4L2_SEL_TGT_CROP:
-		sel->r = priv->crop;
+		if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
+			struct v4l2_rect *try_crop =
+				v4l2_subdev_get_try_crop(&priv->sd,
+							 cfg, sel->pad);
+			sel->r = *try_crop;
+		} else {
+			sel->r = priv->crop;
+		}
 		break;
 	default:
 		ret = -EINVAL;
 	}
 
+out:
 	mutex_unlock(&priv->lock);
 	return ret;
 }
@@ -1077,7 +1110,6 @@ static int csi_set_selection(struct v4l2_subdev *sd,
 			     struct v4l2_subdev_selection *sel)
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
-	struct v4l2_mbus_framefmt *outfmt;
 	struct imx_media_subdev *sensor;
 	int ret = 0;
 
@@ -1111,15 +1143,16 @@ static int csi_set_selection(struct v4l2_subdev *sd,
 		goto out;
 	}
 
-	outfmt = &priv->format_mbus[sel->pad];
-
-	ret = csi_try_crop(priv, &sel->r, sensor);
+	ret = csi_try_crop(priv, &sel->r, cfg, sel->which, sensor);
 	if (ret)
 		goto out;
 
 	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
 		cfg->try_crop = sel->r;
 	} else {
+		struct v4l2_mbus_framefmt *outfmt =
+			&priv->format_mbus[sel->pad];
+
 		priv->crop = sel->r;
 		/* Update the source format */
 		outfmt->width = sel->r.width;
-- 
2.7.4
