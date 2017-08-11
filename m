Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:39328 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752931AbdHKJ52 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Aug 2017 05:57:28 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 13/20] rcar-csi2: implement get_frame_desc
Date: Fri, 11 Aug 2017 11:56:56 +0200
Message-Id: <20170811095703.6170-14-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The frame descriptor of the CSI-2 receiver mirrors that of the
transmitter in all aspects but the routing from the multiplexed sink pad
to the 'normal' source pads. Simply fetch the frame descriptor of the
transmitter and update the routing.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 56 +++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index 034d37bc66e93ac7..e01f334364d50754 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -677,6 +677,61 @@ static int rcar_csi2_get_pad_format(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int rcar_csi2_get_frame_desc(struct v4l2_subdev *sd, unsigned int pad,
+				    struct v4l2_mbus_frame_desc *fd)
+{
+	struct rcar_csi2 *priv = sd_to_csi2(sd);
+	struct v4l2_subdev *nextsd;
+	struct media_pad *nextpad;
+	unsigned int i;
+
+	/* Only valid for sink pad */
+	if (pad != RCAR_CSI2_SINK || fd == NULL)
+		return -EINVAL;
+
+	/* Figoure out remote subdev and pad */
+	nextpad = media_entity_remote_pad(&priv->pads[RCAR_CSI2_SINK]);
+	if (!nextpad) {
+		dev_err(priv->dev, "Could not find remote pad\n");
+		return -EPIPE;
+	}
+
+	nextsd = media_entity_to_v4l2_subdev(nextpad->entity);
+	if (!nextsd) {
+		dev_err(priv->dev, "Could not find remote subdevice\n");
+		return -ENODEV;
+	}
+
+	/*
+	 * Our frame descriptor will mirror that of the remote device
+	 * in all aspects but which of our source pads are routed to
+	 * which muxed channel. So start with a copy of the remote
+	 * description and then update the pads
+	 */
+
+	if (v4l2_subdev_call(nextsd, pad, get_frame_desc, nextpad->index, fd)) {
+		dev_err(priv->dev, "Could not read frame desc\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < fd->num_entries; i++) {
+		/* Make sure it's a muxed CSI2 bus */
+		if ((fd->entry[i].flags & V4L2_MBUS_FRAME_DESC_FL_CSI2) == 0)
+			return -EINVAL;
+
+		if (fd->entry[i].csi2.channel >= 4) {
+			dev_err(priv->dev, "CSI-2 channel value to large: %u\n",
+				fd->entry[i].csi2.channel);
+			return -EINVAL;
+		}
+
+		/* Figure out pad from CSI-2 channel. First source pad is 1 */
+		fd->entry[i].csi2.pad = fd->entry[i].csi2.channel + 1;
+	}
+
+	return 0;
+}
+
 static const struct v4l2_subdev_core_ops rcar_csi2_subdev_core_ops = {
 	.s_power = rcar_csi2_s_power,
 };
@@ -684,6 +739,7 @@ static const struct v4l2_subdev_core_ops rcar_csi2_subdev_core_ops = {
 static const struct v4l2_subdev_pad_ops rcar_csi2_pad_ops = {
 	.set_fmt = rcar_csi2_set_pad_format,
 	.get_fmt = rcar_csi2_get_pad_format,
+	.get_frame_desc = rcar_csi2_get_frame_desc,
 	.s_stream = rcar_csi2_s_stream,
 };
 
-- 
2.13.3
