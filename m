Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:53533 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755173AbdBGQTM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Feb 2017 11:19:12 -0500
Message-ID: <1486484319.2277.78.camel@pengutronix.de>
Subject: [PATCH] media: imx: csi: fix crop rectangle reset in sink set_fmt
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Tue, 07 Feb 2017 17:18:39 +0100
In-Reply-To: <1483755102-24785-18-git-send-email-steve_longerbeam@mentor.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
         <1483755102-24785-18-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The csi_try_crop call in set_fmt should compare the cropping rectangle
to the currently set input format, not to the previous input format.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
This is a patch against the current imx-media-staging-md-wip branch.
S_FMT wouldn't update the cropping rectangle during the first time it is
called, since the csi_try_crop call would compare to the input frame
format returned by __csi_get_fmt, which still contains the old value.
---
 drivers/staging/media/imx/imx-media-csi.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c
b/drivers/staging/media/imx/imx-media-csi.c
index 637d0f137938a..7c590bf94fad5 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -820,15 +820,13 @@ __csi_get_fmt(struct csi_priv *priv, struct
v4l2_subdev_pad_config *cfg,
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
@@ -1023,8 +1021,7 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
 		crop.top = 0;
 		crop.width = sdformat->format.width;
 		crop.height = sdformat->format.height;
-		ret = csi_try_crop(priv, &crop, cfg,
-				   sdformat->which, sensor);
+		ret = csi_try_crop(priv, &crop, cfg, &sdformat->format, sensor);
 		if (ret)
 			return ret;
 
@@ -1104,6 +1101,7 @@ static int csi_set_selection(struct v4l2_subdev
*sd,
 			     struct v4l2_subdev_selection *sel)
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *infmt;
 	struct imx_media_subdev *sensor;
 	int ret;
 
@@ -1133,7 +1131,8 @@ static int csi_set_selection(struct v4l2_subdev
*sd,
 		return 0;
 	}
 
-	ret = csi_try_crop(priv, &sel->r, cfg, sel->which, sensor);
+	infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD, sel->which);
+	ret = csi_try_crop(priv, &sel->r, cfg, infmt, sensor);
 	if (ret)
 		return ret;
 
-- 
2.11.0


