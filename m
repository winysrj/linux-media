Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36023 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753807AbdBPCVd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 21:21:33 -0500
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
Subject: [PATCH v4 36/36] media: imx: propagate sink pad formats to source pads
Date: Wed, 15 Feb 2017 18:19:38 -0800
Message-Id: <1487211578-11360-37-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-ic-prp.c      | 11 ++++++++++-
 drivers/staging/media/imx/imx-ic-prpencvf.c | 22 ++++++++++++++--------
 drivers/staging/media/imx/imx-media-csi.c   | 26 +++++++++++++++++---------
 drivers/staging/media/imx/imx-media-vdic.c  | 15 ++++++++++++++-
 4 files changed, 55 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-prp.c b/drivers/staging/media/imx/imx-ic-prp.c
index b9ee8fb..5c57d2b 100644
--- a/drivers/staging/media/imx/imx-ic-prp.c
+++ b/drivers/staging/media/imx/imx-ic-prp.c
@@ -196,8 +196,17 @@ static int prp_set_fmt(struct v4l2_subdev *sd,
 	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {
 		cfg->try_fmt = sdformat->format;
 	} else {
-		priv->format_mbus[sdformat->pad] = sdformat->format;
+		struct v4l2_mbus_framefmt *f =
+			&priv->format_mbus[sdformat->pad];
+
+		*f = sdformat->format;
 		priv->cc[sdformat->pad] = cc;
+
+		/* propagate format to source pads */
+		if (sdformat->pad == PRP_SINK_PAD) {
+			priv->format_mbus[PRP_SRC_PAD_PRPENC] = *f;
+			priv->format_mbus[PRP_SRC_PAD_PRPVF] = *f;
+		}
 	}
 
 	return 0;
diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index dd9d499..c43f85f 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -806,16 +806,22 @@ static int prp_set_fmt(struct v4l2_subdev *sd,
 	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {
 		cfg->try_fmt = sdformat->format;
 	} else {
-		priv->format_mbus[sdformat->pad] = sdformat->format;
+		struct v4l2_mbus_framefmt *f =
+			&priv->format_mbus[sdformat->pad];
+		struct v4l2_mbus_framefmt *outf =
+			&priv->format_mbus[PRPENCVF_SRC_PAD];
+
+		*f = sdformat->format;
 		priv->cc[sdformat->pad] = cc;
-		if (sdformat->pad == PRPENCVF_SRC_PAD) {
-			/*
-			 * update the capture device format if this is
-			 * the IDMAC output pad
-			 */
-			imx_media_mbus_fmt_to_pix_fmt(&vdev->fmt.fmt.pix,
-						      &sdformat->format, cc);
+
+		/* propagate format to source pad */
+		if (sdformat->pad == PRPENCVF_SINK_PAD) {
+			outf->width = f->width;
+			outf->height = f->height;
 		}
+
+		/* update the capture device format from output pad */
+		imx_media_mbus_fmt_to_pix_fmt(&vdev->fmt.fmt.pix, outf, cc);
 	}
 
 	return 0;
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 3e6b607..9d9ec03 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1161,19 +1161,27 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {
 		cfg->try_fmt = sdformat->format;
 	} else {
+		struct v4l2_mbus_framefmt *f_direct, *f_idmac;
+
 		priv->format_mbus[sdformat->pad] = sdformat->format;
 		priv->cc[sdformat->pad] = cc;
-		/* Reset the crop window if this is the input pad */
-		if (sdformat->pad == CSI_SINK_PAD)
+
+		f_direct = &priv->format_mbus[CSI_SRC_PAD_DIRECT];
+		f_idmac = &priv->format_mbus[CSI_SRC_PAD_IDMAC];
+
+		if (sdformat->pad == CSI_SINK_PAD) {
+			/* reset the crop window */
 			priv->crop = crop;
-		else if (sdformat->pad == CSI_SRC_PAD_IDMAC) {
-			/*
-			 * update the capture device format if this is
-			 * the IDMAC output pad
-			 */
-			imx_media_mbus_fmt_to_pix_fmt(&vdev->fmt.fmt.pix,
-						      &sdformat->format, cc);
+
+			/* propagate format to source pads */
+			f_direct->width = crop.width;
+			f_direct->height = crop.height;
+			f_idmac->width = crop.width;
+			f_idmac->height = crop.height;
 		}
+
+		/* update the capture device format from IDMAC output pad */
+		imx_media_mbus_fmt_to_pix_fmt(&vdev->fmt.fmt.pix, f_idmac, cc);
 	}
 
 	return 0;
diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
index 61e6017..55fb522 100644
--- a/drivers/staging/media/imx/imx-media-vdic.c
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -649,8 +649,21 @@ static int vdic_set_fmt(struct v4l2_subdev *sd,
 	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {
 		cfg->try_fmt = sdformat->format;
 	} else {
-		priv->format_mbus[sdformat->pad] = sdformat->format;
+		struct v4l2_mbus_framefmt *f =
+			&priv->format_mbus[sdformat->pad];
+		struct v4l2_mbus_framefmt *outf =
+			&priv->format_mbus[VDIC_SRC_PAD_DIRECT];
+
+		*f = sdformat->format;
 		priv->cc[sdformat->pad] = cc;
+
+		/* propagate format to source pad */
+		if (sdformat->pad == VDIC_SINK_PAD_DIRECT ||
+		    sdformat->pad == VDIC_SINK_PAD_IDMAC) {
+			outf->width = f->width;
+			outf->height = f->height;
+			outf->field = V4L2_FIELD_NONE;
+		}
 	}
 
 	return 0;
-- 
2.7.4
