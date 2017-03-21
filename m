Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36471 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757076AbdCUXqG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Mar 2017 19:46:06 -0400
Subject: Re: [PATCH 3/4] media: imx-csi: add frame size/interval enumeration
To: Russell King <rmk+kernel@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <20170319103801.GQ21222@n2100.armlinux.org.uk>
 <E1cpYOU-0006En-Vd@rmk-PC.armlinux.org.uk>
Cc: sakari.ailus@linux.intel.com, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, kernel@pengutronix.de,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <c797369f-f4b9-e216-f594-d142d1786549@gmail.com>
Date: Tue, 21 Mar 2017 16:46:02 -0700
MIME-Version: 1.0
In-Reply-To: <E1cpYOU-0006En-Vd@rmk-PC.armlinux.org.uk>
Content-Type: multipart/mixed;
 boundary="------------E3B670C67C429BDFA28F45A9"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------E3B670C67C429BDFA28F45A9
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Russell,

On 03/19/2017 03:49 AM, Russell King wrote:
> Add frame size and frame interval enumeration to CSI.
>
> CSI can scale the image independently horizontally and vertically by a
> factor of two, which enumerates to four different frame sizes.
>
> CSI can also drop frames, resulting in frame rate reduction, so
> enumerate the resulting possible output frame rates.
>

I applied this patch, modified to return a frame size range on the
sink pad. Also, I believe both frame size and frame interval
enumeration should base their decision making on the crop rectangle
at the sink pad, not on the format at the source pads, due to the
crop/compose re-org patch from Philipp.

The updated patch is attached.

Steve


--------------E3B670C67C429BDFA28F45A9
Content-Type: text/x-patch;
 name="0036-media-imx-csi-add-frame-size-interval-enumeration.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0036-media-imx-csi-add-frame-size-interval-enumeration.patch"

>From ce1772dfe9e0381b2749102e760ed7c49fda5ae2 Mon Sep 17 00:00:00 2001
From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Sun, 19 Mar 2017 10:49:02 +0000
Subject: [PATCH 36/38] media: imx-csi: add frame size/interval enumeration

Add frame size and frame interval enumeration to CSI.

CSI can downscale the image independently horizontally and vertically by a
factor of two, which enumerates to four different frame sizes at the
output pads. The input pad supports a range of frame sizes.

CSI can also drop frames, resulting in frame rate reduction, so
enumerate the resulting possible output frame rates.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-csi.c | 62 +++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 5f9fa83..55265c1 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1098,6 +1098,66 @@ static int csi_enum_mbus_code(struct v4l2_subdev *sd,
 	return ret;
 }
 
+static int csi_enum_frame_size(struct v4l2_subdev *sd,
+			       struct v4l2_subdev_pad_config *cfg,
+			       struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	struct v4l2_rect *crop;
+	int ret = 0;
+
+	if (fse->pad >= CSI_NUM_PADS ||
+	    fse->index > (fse->pad == CSI_SINK_PAD ? 0 : 3))
+		return -EINVAL;
+
+	mutex_lock(&priv->lock);
+
+	if (fse->pad == CSI_SINK_PAD) {
+		fse->min_width = MIN_W;
+		fse->max_width = MAX_W;
+		fse->min_height = MIN_H;
+		fse->max_height = MAX_H;
+	} else {
+		crop = __csi_get_crop(priv, cfg, fse->which);
+
+		fse->min_width = fse->max_width = fse->index & 1 ?
+			crop->width / 2 : crop->width;
+		fse->min_height = fse->max_height = fse->index & 2 ?
+			crop->height / 2 : crop->height;
+	}
+
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
+static int csi_enum_frame_interval(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_pad_config *cfg,
+				   struct v4l2_subdev_frame_interval_enum *fie)
+{
+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	struct v4l2_rect *crop;
+	int ret = 0;
+
+	if (fie->pad >= CSI_NUM_PADS ||
+	    fie->index >= (fie->pad == CSI_SINK_PAD ? 1 : ARRAY_SIZE(csi_skip)))
+		return -EINVAL;
+
+	mutex_lock(&priv->lock);
+
+	crop = __csi_get_crop(priv, cfg, fie->which);
+
+	if ((fie->width == crop->width || fie->width == crop->width / 2) &&
+	    (fie->height == crop->height || fie->height == crop->height / 2)) {
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
@@ -1562,6 +1622,8 @@ static struct v4l2_subdev_video_ops csi_video_ops = {
 
 static struct v4l2_subdev_pad_ops csi_pad_ops = {
 	.enum_mbus_code = csi_enum_mbus_code,
+	.enum_frame_size = csi_enum_frame_size,
+	.enum_frame_interval = csi_enum_frame_interval,
 	.get_fmt = csi_get_fmt,
 	.set_fmt = csi_set_fmt,
 	.get_selection = csi_get_selection,
-- 
2.7.4


--------------E3B670C67C429BDFA28F45A9--
