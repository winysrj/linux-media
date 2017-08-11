Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:39242 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752942AbdHKJ5Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Aug 2017 05:57:25 -0400
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
Subject: [PATCH 09/20] rcar-csi2: figure out remote pad and stream which are starting
Date: Fri, 11 Aug 2017 11:56:52 +0200
Message-Id: <20170811095703.6170-10-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using the information in v4l2_mbus_frame_desc figure out which remote
pad and stream should be started or stopped.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 40 +++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index 46da45aea18fe3d3..8b4db70b0dd5d0fb 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -533,9 +533,14 @@ static void rcar_csi2_stop(struct rcar_csi2 *priv)
 	rcar_csi2_reset(priv);
 }
 
-static int rcar_csi2_sd_info(struct rcar_csi2 *priv, struct v4l2_subdev **sd)
+static int rcar_csi2_sd_info(struct rcar_csi2 *priv, unsigned int channel,
+			     struct v4l2_subdev **nextsd, unsigned int *nextpad,
+			     unsigned int *nextstream)
 {
+	struct v4l2_mbus_frame_desc_entry *entry;
+	struct v4l2_mbus_frame_desc fd;
 	struct media_pad *pad;
+	unsigned int i;
 
 	pad = media_entity_remote_pad(&priv->pads[RCAR_CSI2_SINK]);
 	if (!pad) {
@@ -543,31 +548,56 @@ static int rcar_csi2_sd_info(struct rcar_csi2 *priv, struct v4l2_subdev **sd)
 		return -ENODEV;
 	}
 
-	*sd = media_entity_to_v4l2_subdev(pad->entity);
-	if (!*sd) {
+	*nextsd = media_entity_to_v4l2_subdev(pad->entity);
+	if (!*nextsd) {
 		dev_err(priv->dev, "Could not find remote subdevice\n");
 		return -ENODEV;
 	}
 
-	return 0;
+	*nextpad = pad->index;
+
+	if (v4l2_subdev_call(*nextsd, pad, get_frame_desc, *nextpad, &fd)) {
+		dev_err(priv->dev, "Could not read frame desc\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < fd.num_entries; i++) {
+		entry = &fd.entry[i];
+
+		if ((entry->flags & V4L2_MBUS_FRAME_DESC_FL_CSI2) == 0)
+			return -EINVAL;
+
+		if (entry->csi2.channel == channel) {
+			*nextstream = i;
+			return 0;
+		}
+	}
+
+	dev_err(priv->dev, "Could not find stream for channel %u\n",
+		channel);
+	return -EINVAL;
 }
 
 static int rcar_csi2_s_stream(struct v4l2_subdev *sd, unsigned int pad,
 			      unsigned int stream, int enable)
 {
 	struct rcar_csi2 *priv = sd_to_csi2(sd);
+	unsigned int channel, nextpad, nextstream;
 	struct v4l2_subdev *nextsd;
 	int ret;
 
 	if (pad < RCAR_CSI2_SOURCE_VC0 || pad > RCAR_CSI2_SOURCE_VC3)
 		return -EINVAL;
 
+	/* Figure out CSI-2 channel from pad. First source is VC0, etc */
+	channel = pad - 1;
+
 	if (stream != 0)
 		return -EINVAL;
 
 	mutex_lock(&priv->lock);
 
-	ret = rcar_csi2_sd_info(priv, &nextsd);
+	ret = rcar_csi2_sd_info(priv, channel, &nextsd, &nextpad, &nextstream);
 	if (ret)
 		goto out;
 
-- 
2.13.3
