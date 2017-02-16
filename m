Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33557 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753747AbdBPCVb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 21:21:31 -0500
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
Subject: [PATCH v4 35/36] media: imx: csi: fix crop rectangle reset in sink set_fmt
Date: Wed, 15 Feb 2017 18:19:37 -0800
Message-Id: <1487211578-11360-36-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

The csi_try_crop call in set_fmt should compare the cropping rectangle
to the currently set input format, not to the previous input format.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-csi.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 6284f99..3e6b607 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -937,15 +937,13 @@ __csi_get_fmt(struct csi_priv *priv, struct v4l2_subdev_pad_config *cfg,
 static int csi_try_crop(struct csi_priv *priv,
 			struct v4l2_rect *crop,
 			struct v4l2_subdev_pad_config *cfg,
-			enum v4l2_subdev_format_whence which,
+			struct v4l2_mbus_framefmt *infmt,
 			struct imx_media_subdev *sensor)
 {
 	struct v4l2_of_endpoint *sensor_ep;
-	struct v4l2_mbus_framefmt *infmt;
 	v4l2_std_id std;
 	int ret;
 
-	infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD, which);
 	sensor_ep = &sensor->sensor_ep;
 
 	crop->width = min_t(__u32, infmt->width, crop->width);
@@ -1142,8 +1140,7 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 		crop.top = 0;
 		crop.width = sdformat->format.width;
 		crop.height = sdformat->format.height;
-		ret = csi_try_crop(priv, &crop, cfg,
-				   sdformat->which, sensor);
+		ret = csi_try_crop(priv, &crop, cfg, &sdformat->format, sensor);
 		if (ret)
 			return ret;
 
@@ -1225,6 +1222,7 @@ static int csi_set_selection(struct v4l2_subdev *sd,
 			     struct v4l2_subdev_selection *sel)
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *infmt;
 	struct imx_media_subdev *sensor;
 	int ret;
 
@@ -1254,7 +1252,8 @@ static int csi_set_selection(struct v4l2_subdev *sd,
 		return 0;
 	}
 
-	ret = csi_try_crop(priv, &sel->r, cfg, sel->which, sensor);
+	infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD, sel->which);
+	ret = csi_try_crop(priv, &sel->r, cfg, infmt, sensor);
 	if (ret)
 		return ret;
 
-- 
2.7.4
