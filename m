Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:34130 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754277AbdLNTJS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 14:09:18 -0500
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
Subject: [PATCH/RFC v2 04/15] rcar-csi2: switch to pad and stream aware s_stream
Date: Thu, 14 Dec 2017 20:08:24 +0100
Message-Id: <20171214190835.7672-5-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch the driver to implement the pad and stream aware s_stream
operation. This is needed to enable to support to start and stop
individual streams on a multiplexed pad.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index d8751add48fc1322..8ce0bfeef1113f9c 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -625,12 +625,17 @@ static int rcar_csi2_sd_info(struct rcar_csi2 *priv, struct v4l2_subdev **sd)
 	return 0;
 }
 
-static int rcar_csi2_s_stream(struct v4l2_subdev *sd, int enable)
+static int rcar_csi2_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			      unsigned int stream, int enable)
 {
 	struct rcar_csi2 *priv = sd_to_csi2(sd);
 	struct v4l2_subdev *nextsd;
 	int ret;
 
+	/* Only one stream on each source pad */
+	if (stream != 0)
+		return -EINVAL;
+
 	mutex_lock(&priv->lock);
 
 	ret = rcar_csi2_sd_info(priv, &nextsd);
@@ -699,17 +704,13 @@ static int rcar_csi2_get_pad_format(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static const struct v4l2_subdev_video_ops rcar_csi2_video_ops = {
-	.s_stream = rcar_csi2_s_stream,
-};
-
 static const struct v4l2_subdev_pad_ops rcar_csi2_pad_ops = {
 	.set_fmt = rcar_csi2_set_pad_format,
 	.get_fmt = rcar_csi2_get_pad_format,
+	.s_stream = rcar_csi2_s_stream,
 };
 
 static const struct v4l2_subdev_ops rcar_csi2_subdev_ops = {
-	.video	= &rcar_csi2_video_ops,
 	.pad	= &rcar_csi2_pad_ops,
 };
 
-- 
2.15.1
