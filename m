Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:43198 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751802AbdCSK76 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Mar 2017 06:59:58 -0400
In-Reply-To: <20170319103801.GQ21222@n2100.armlinux.org.uk>
References: <20170319103801.GQ21222@n2100.armlinux.org.uk>
From: Russell King <rmk+kernel@armlinux.org.uk>
To: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: sakari.ailus@linux.intel.com, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, kernel@pengutronix.de,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de
Subject: [PATCH 3/4] media: imx-csi: add frame size/interval enumeration
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1cpYOU-0006En-Vd@rmk-PC.armlinux.org.uk>
Date: Sun, 19 Mar 2017 10:49:02 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add frame size and frame interval enumeration to CSI.

CSI can scale the image independently horizontally and vertically by a
factor of two, which enumerates to four different frame sizes.

CSI can also drop frames, resulting in frame rate reduction, so
enumerate the resulting possible output frame rates.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/staging/media/imx/imx-media-csi.c | 51 +++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 65346e789dd6..d19659d7ddc2 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1073,6 +1073,55 @@ static int csi_enum_mbus_code(struct v4l2_subdev *sd,
 	return ret;
 }
 
+static int csi_enum_frame_size(struct v4l2_subdev *sd,
+			       struct v4l2_subdev_pad_config *cfg,
+			       struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *fmt;
+	int ret = 0;
+
+	if (fse->pad >= CSI_NUM_PADS ||
+	    fse->index > (fse->pad == CSI_SINK_PAD ? 0 : 3))
+		return -EINVAL;
+
+	mutex_lock(&priv->lock);
+	fmt = __csi_get_fmt(priv, cfg, fse->pad, fse->which);
+	fse->min_width = fse->max_width = fse->index & 1 ?
+					    fmt->width >> 1 : fmt->width;
+	fse->min_height = fse->max_height = fse->index & 2 ?
+					      fmt->height >> 1 : fmt->height;
+	mutex_unlock(&priv->lock);
+
+	return ret;
+}
+
+static int csi_enum_frame_interval(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_pad_config *cfg,
+				   struct v4l2_subdev_frame_interval_enum *fie)
+{
+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *fmt;
+	int ret = 0;
+
+	if (fie->pad >= CSI_NUM_PADS ||
+	    fie->index >= (fie->pad == CSI_SINK_PAD ? 1 : ARRAY_SIZE(csi_skip)))
+		return -EINVAL;
+
+	mutex_lock(&priv->lock);
+	fmt = __csi_get_fmt(priv, cfg, fie->pad, fie->which);
+	if ((fie->width == fmt->width || fie->width == fmt->width / 2) &&
+	    (fie->height == fmt->height || fie->height == fmt->height / 2)) {
+		fie->interval = priv->frame_interval;
+		csi_apply_skip_interval(&csi_skip[fie->index], &fie->interval);
+	} else {
+		ret = -EINVAL;
+	}
+	mutex_unlock(&priv->lock);
+
+	return ret;
+}
+
 static int csi_get_fmt(struct v4l2_subdev *sd,
 		       struct v4l2_subdev_pad_config *cfg,
 		       struct v4l2_subdev_format *sdformat)
@@ -1473,6 +1522,8 @@ static struct v4l2_subdev_video_ops csi_video_ops = {
 
 static struct v4l2_subdev_pad_ops csi_pad_ops = {
 	.enum_mbus_code = csi_enum_mbus_code,
+	.enum_frame_size = csi_enum_frame_size,
+	.enum_frame_interval = csi_enum_frame_interval,
 	.get_fmt = csi_get_fmt,
 	.set_fmt = csi_set_fmt,
 	.get_selection = csi_get_selection,
-- 
2.7.4
