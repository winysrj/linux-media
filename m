Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:34210 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754305AbdLNTJU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 14:09:20 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH/RFC v2 06/15] rcar-csi2: use frame description information when propagating .s_stream()
Date: Thu, 14 Dec 2017 20:08:26 +0100
Message-Id: <20171214190835.7672-7-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the frame description from the remote subdevice of the rcar-csi2's
sink pad to get the remote pad and stream pad needed to propagate the
.s_stream() operation.

The CSI-2 virtual channel which should be acted upon can be determined
by looking at which of the rcar-csi2 source pad the .s_stream() was
called on. This is because the rcar-csi2 acts as a demultiplexer for the
CSI-2 link on the one sink pad and outputs each virtual channel on a
distinct and known source pad.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 58 ++++++++++++++++++++---------
 1 file changed, 41 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index e0f56cc3d25179a9..6b607b2e31e26063 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -614,20 +614,31 @@ static void rcar_csi2_stop(struct rcar_csi2 *priv)
 	rcar_csi2_reset(priv);
 }
 
-static int rcar_csi2_sd_info(struct rcar_csi2 *priv, struct v4l2_subdev **sd)
+static int rcar_csi2_get_source_info(struct rcar_csi2 *priv,
+				     struct v4l2_subdev **subdev,
+				     unsigned int *pad,
+				     struct v4l2_mbus_frame_desc *fd)
 {
-	struct media_pad *pad;
+	struct media_pad *remote_pad;
 
-	pad = media_entity_remote_pad(&priv->pads[RCAR_CSI2_SINK]);
-	if (!pad) {
-		dev_err(priv->dev, "Could not find remote pad\n");
+	/* Get source subdevice and pad */
+	remote_pad = media_entity_remote_pad(&priv->pads[RCAR_CSI2_SINK]);
+	if (!remote_pad) {
+		dev_err(priv->dev, "Could not find remote source pad\n");
 		return -ENODEV;
 	}
+	*subdev = media_entity_to_v4l2_subdev(remote_pad->entity);
+	*pad = remote_pad->index;
 
-	*sd = media_entity_to_v4l2_subdev(pad->entity);
-	if (!*sd) {
-		dev_err(priv->dev, "Could not find remote subdevice\n");
-		return -ENODEV;
+	/* Get frame descriptor */
+	if (v4l2_subdev_call(*subdev, pad, get_frame_desc, *pad, fd)) {
+		dev_err(priv->dev, "Could not read frame desc\n");
+		return -EINVAL;
+	}
+
+	if (fd->type != V4L2_MBUS_FRAME_DESC_TYPE_CSI2) {
+		dev_err(priv->dev, "Frame desc do not describe CSI-2 link");
+		return -EINVAL;
 	}
 
 	return 0;
@@ -637,9 +648,10 @@ static int rcar_csi2_s_stream(struct v4l2_subdev *sd, unsigned int pad,
 			      unsigned int stream, int enable)
 {
 	struct rcar_csi2 *priv = sd_to_csi2(sd);
+	struct v4l2_mbus_frame_desc fd;
 	struct v4l2_subdev *nextsd;
-	unsigned int i, count = 0;
-	int ret, vc;
+	unsigned int i, rpad, count = 0;
+	int ret, vc, rstream = -1;
 
 	/* Only allow stream control on source pads and valid vc */
 	vc = rcar_csi2_pad_to_vc(pad);
@@ -650,11 +662,23 @@ static int rcar_csi2_s_stream(struct v4l2_subdev *sd, unsigned int pad,
 	if (stream != 0)
 		return -EINVAL;
 
-	mutex_lock(&priv->lock);
-
-	ret = rcar_csi2_sd_info(priv, &nextsd);
+	/* Get information about multiplexed link */
+	ret = rcar_csi2_get_source_info(priv, &nextsd, &rpad, &fd);
 	if (ret)
-		goto out;
+		return ret;
+
+	/* Get stream on multiplexed link */
+	for (i = 0; i < fd.num_entries; i++)
+		if (fd.entry[i].bus.csi2.channel == vc)
+			rstream = fd.entry[i].stream;
+
+	if (rstream < 0) {
+		dev_err(priv->dev, "Could not find stream for vc %u\n", vc);
+		return -EINVAL;
+	}
+
+	/* Start or stop the requested stream */
+	mutex_lock(&priv->lock);
 
 	for (i = 0; i < 4; i++)
 		count += priv->stream_count[i];
@@ -673,14 +697,14 @@ static int rcar_csi2_s_stream(struct v4l2_subdev *sd, unsigned int pad,
 	}
 
 	if (enable && priv->stream_count[vc] == 0) {
-		ret = v4l2_subdev_call(nextsd, video, s_stream, 1);
+		ret = v4l2_subdev_call(nextsd, pad, s_stream, rpad, rstream, 1);
 		if (ret) {
 			rcar_csi2_stop(priv);
 			pm_runtime_put(priv->dev);
 			goto out;
 		}
 	} else if (!enable && priv->stream_count[vc] == 1) {
-		ret = v4l2_subdev_call(nextsd, video, s_stream, 0);
+		ret = v4l2_subdev_call(nextsd, pad, s_stream, rpad, rstream, 0);
 	}
 
 	priv->stream_count[vc] += enable ? 1 : -1;
-- 
2.15.1
