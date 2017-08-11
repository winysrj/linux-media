Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:39204 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752938AbdHKJ5Z (ORCPT
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
Subject: [PATCH 08/20] rcar-csi2: switch to pad and stream aware s_stream
Date: Fri, 11 Aug 2017 11:56:51 +0200
Message-Id: <20170811095703.6170-9-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
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
 drivers/media/platform/rcar-vin/rcar-csi2.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index 58c8e9ec8ab756fc..46da45aea18fe3d3 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -552,12 +552,19 @@ static int rcar_csi2_sd_info(struct rcar_csi2 *priv, struct v4l2_subdev **sd)
 	return 0;
 }
 
-static int rcar_csi2_s_stream(struct v4l2_subdev *sd, int enable)
+static int rcar_csi2_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			      unsigned int stream, int enable)
 {
 	struct rcar_csi2 *priv = sd_to_csi2(sd);
 	struct v4l2_subdev *nextsd;
 	int ret;
 
+	if (pad < RCAR_CSI2_SOURCE_VC0 || pad > RCAR_CSI2_SOURCE_VC3)
+		return -EINVAL;
+
+	if (stream != 0)
+		return -EINVAL;
+
 	mutex_lock(&priv->lock);
 
 	ret = rcar_csi2_sd_info(priv, &nextsd);
@@ -625,10 +632,6 @@ static int rcar_csi2_get_pad_format(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static const struct v4l2_subdev_video_ops rcar_csi2_video_ops = {
-	.s_stream = rcar_csi2_s_stream,
-};
-
 static const struct v4l2_subdev_core_ops rcar_csi2_subdev_core_ops = {
 	.s_power = rcar_csi2_s_power,
 };
@@ -636,10 +639,10 @@ static const struct v4l2_subdev_core_ops rcar_csi2_subdev_core_ops = {
 static const struct v4l2_subdev_pad_ops rcar_csi2_pad_ops = {
 	.set_fmt = rcar_csi2_set_pad_format,
 	.get_fmt = rcar_csi2_get_pad_format,
+	.s_stream = rcar_csi2_s_stream,
 };
 
 static const struct v4l2_subdev_ops rcar_csi2_subdev_ops = {
-	.video	= &rcar_csi2_video_ops,
 	.core	= &rcar_csi2_subdev_core_ops,
 	.pad	= &rcar_csi2_pad_ops,
 };
-- 
2.13.3
