Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34003 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753725AbdCJEzF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Mar 2017 23:55:05 -0500
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
Subject: [PATCH v5 33/39] media: imx: mipi-csi2: enable setting and getting of frame rates
Date: Thu,  9 Mar 2017 20:53:13 -0800
Message-Id: <1489121599-23206-34-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
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
 drivers/staging/media/imx/imx6-mipi-csi2.c | 36 ++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/staging/media/imx/imx6-mipi-csi2.c b/drivers/staging/media/imx/imx6-mipi-csi2.c
index 1a71b40..d8f931e 100644
--- a/drivers/staging/media/imx/imx6-mipi-csi2.c
+++ b/drivers/staging/media/imx/imx6-mipi-csi2.c
@@ -49,6 +49,7 @@ struct csi2_dev {
 	struct mutex lock;
 
 	struct v4l2_mbus_framefmt format_mbus;
+	struct v4l2_fract frame_interval;
 
 	int                     power_count;
 	bool                    stream_on;
@@ -487,6 +488,35 @@ static int csi2_set_fmt(struct v4l2_subdev *sd,
 	return ret;
 }
 
+static int csi2_g_frame_interval(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_frame_interval *fi)
+{
+	struct csi2_dev *csi2 = sd_to_dev(sd);
+
+	mutex_lock(&csi2->lock);
+	fi->interval = csi2->frame_interval;
+	mutex_unlock(&csi2->lock);
+
+	return 0;
+}
+
+static int csi2_s_frame_interval(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_frame_interval *fi)
+{
+	struct csi2_dev *csi2 = sd_to_dev(sd);
+
+	mutex_lock(&csi2->lock);
+
+	/* Output pads mirror active input pad, no limits on input pads */
+	if (fi->pad != CSI2_SINK_PAD)
+		fi->interval = csi2->frame_interval;
+
+	csi2->frame_interval = fi->interval;
+
+	mutex_unlock(&csi2->lock);
+	return 0;
+}
+
 static int csi2_link_validate(struct v4l2_subdev *sd,
 			      struct media_link *link,
 			      struct v4l2_subdev_format *source_fmt,
@@ -535,6 +565,8 @@ static struct v4l2_subdev_core_ops csi2_core_ops = {
 
 static struct v4l2_subdev_video_ops csi2_video_ops = {
 	.s_stream = csi2_s_stream,
+	.g_frame_interval = csi2_g_frame_interval,
+	.s_frame_interval = csi2_s_frame_interval,
 };
 
 static struct v4l2_subdev_pad_ops csi2_pad_ops = {
@@ -603,6 +635,10 @@ static int csi2_probe(struct platform_device *pdev)
 	csi2->sd.entity.function = MEDIA_ENT_F_VID_IF_BRIDGE;
 	csi2->sd.grp_id = IMX_MEDIA_GRP_ID_CSI2;
 
+	/* init default frame interval */
+	csi2->frame_interval.numerator = 1;
+	csi2->frame_interval.denominator = 30;
+
 	ret = csi2_parse_endpoints(csi2);
 	if (ret)
 		return ret;
-- 
2.7.4
