Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33472 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753672AbdBPCVS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 21:21:18 -0500
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
Subject: [PATCH v4 28/36] media: imx: csi: fix crop rectangle changes in set_fmt
Date: Wed, 15 Feb 2017 18:19:30 -0800
Message-Id: <1487211578-11360-29-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

The cropping rectangle was being modified by the output pad's
set_fmt, which is the wrong pad to do this. The crop rectangle
should not be modified by the output pad set_fmt. It instead
should be reset to the full input frame when the input pad format
is set.

The output pad set_fmt should set width/height to the current
crop dimensions, or 1/2 the crop width/height to enable
downscaling.

So the other part of this patch is to enable downscaling if
the output pad dimension(s) are 1/2 the crop dimension(s) at
csi_setup() time.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-csi.c | 35 ++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index ae24b42..3cb97e2 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -531,6 +531,10 @@ static int csi_setup(struct csi_priv *priv)
 
 	ipu_csi_set_window(priv->csi, &priv->crop);
 
+	ipu_csi_set_downsize(priv->csi,
+			     priv->crop.width == 2 * outfmt->width,
+			     priv->crop.height == 2 * outfmt->height);
+
 	ipu_csi_init_interface(priv->csi, &sensor_mbus_cfg, &if_fmt);
 
 	ipu_csi_set_dest(priv->csi, priv->dest);
@@ -890,15 +894,15 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 	switch (sdformat->pad) {
 	case CSI_SRC_PAD_DIRECT:
 	case CSI_SRC_PAD_IDMAC:
-		crop.left = priv->crop.left;
-		crop.top = priv->crop.top;
-		crop.width = sdformat->format.width;
-		crop.height = sdformat->format.height;
-		ret = csi_try_crop(priv, &crop, sensor);
-		if (ret)
-			return ret;
-		sdformat->format.width = crop.width;
-		sdformat->format.height = crop.height;
+		if (sdformat->format.width < priv->crop.width * 3 / 4)
+			sdformat->format.width = priv->crop.width / 2;
+		else
+			sdformat->format.width = priv->crop.width;
+
+		if (sdformat->format.height < priv->crop.height * 3 / 4)
+			sdformat->format.height = priv->crop.height / 2;
+		else
+			sdformat->format.height = priv->crop.height;
 
 		if (sdformat->pad == CSI_SRC_PAD_IDMAC) {
 			cc = imx_media_find_format(0, sdformat->format.code,
@@ -948,6 +952,14 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 		}
 		break;
 	case CSI_SINK_PAD:
+		crop.left = 0;
+		crop.top = 0;
+		crop.width = sdformat->format.width;
+		crop.height = sdformat->format.height;
+		ret = csi_try_crop(priv, &crop, sensor);
+		if (ret)
+			return ret;
+
 		cc = imx_media_find_format(0, sdformat->format.code,
 					   true, false);
 		if (!cc) {
@@ -965,9 +977,8 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 	} else {
 		priv->format_mbus[sdformat->pad] = sdformat->format;
 		priv->cc[sdformat->pad] = cc;
-		/* Update the crop window if this is an output pad  */
-		if (sdformat->pad == CSI_SRC_PAD_DIRECT ||
-		    sdformat->pad == CSI_SRC_PAD_IDMAC)
+		/* Reset the crop window if this is the input pad */
+		if (sdformat->pad == CSI_SINK_PAD)
 			priv->crop = crop;
 	}
 
-- 
2.7.4
