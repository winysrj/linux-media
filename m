Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35227 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753607AbdBPCVV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 21:21:21 -0500
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
        Russell King <rmk+kernel@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v4 29/36] media: imx: mipi-csi2: enable setting and getting of frame rates
Date: Wed, 15 Feb 2017 18:19:31 -0800
Message-Id: <1487211578-11360-30-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Russell King <rmk+kernel@armlinux.org.uk>

Setting and getting frame rates is part of the negotiation mechanism
between subdevs.  The lack of support means that a frame rate at the
sensor can't be negotiated through the subdev path.

Add support at MIPI CSI2 level for handling this part of the
negotiation.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx6-mipi-csi2.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/staging/media/imx/imx6-mipi-csi2.c b/drivers/staging/media/imx/imx6-mipi-csi2.c
index 23dca80..c62f14e 100644
--- a/drivers/staging/media/imx/imx6-mipi-csi2.c
+++ b/drivers/staging/media/imx/imx6-mipi-csi2.c
@@ -34,6 +34,7 @@ struct csi2_dev {
 	struct v4l2_subdev      sd;
 	struct media_pad       pad[CSI2_NUM_PADS];
 	struct v4l2_mbus_framefmt format_mbus;
+	struct v4l2_fract      frame_interval;
 	struct clk             *dphy_clk;
 	struct clk             *cfg_clk;
 	struct clk             *pix_clk; /* what is this? */
@@ -397,6 +398,30 @@ static int csi2_set_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int csi2_g_frame_interval(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_frame_interval *fi)
+{
+	struct csi2_dev *csi2 = sd_to_dev(sd);
+
+	fi->interval = csi2->frame_interval;
+
+	return 0;
+}
+
+static int csi2_s_frame_interval(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_frame_interval *fi)
+{
+	struct csi2_dev *csi2 = sd_to_dev(sd);
+
+	/* Output pads mirror active input pad, no limits on input pads */
+	if (fi->pad != CSI2_SINK_PAD)
+		fi->interval = csi2->frame_interval;
+
+	csi2->frame_interval = fi->interval;
+
+	return 0;
+}
+
 /*
  * retrieve our pads parsed from the OF graph by the media device
  */
@@ -430,6 +455,8 @@ static struct v4l2_subdev_core_ops csi2_core_ops = {
 
 static struct v4l2_subdev_video_ops csi2_video_ops = {
 	.s_stream = csi2_s_stream,
+	.g_frame_interval = csi2_g_frame_interval,
+	.s_frame_interval = csi2_s_frame_interval,
 };
 
 static struct v4l2_subdev_pad_ops csi2_pad_ops = {
-- 
2.7.4
