Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:39278 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752925AbdHKJ5Z (ORCPT
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
Subject: [PATCH 12/20] rcar-csi2: only allow formats on source pads
Date: Fri, 11 Aug 2017 11:56:55 +0200
Message-Id: <20170811095703.6170-13-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver is now pad and stream aware, only allow to get/set format on
source pads. Also record a different format for each source pad since
it's no longer true that they are all the same.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index b8ec03d595ba8ac4..034d37bc66e93ac7 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -289,7 +289,7 @@ struct rcar_csi2 {
 	struct v4l2_subdev subdev;
 	struct media_pad pads[NR_OF_RCAR_CSI2_PAD];
 
-	struct v4l2_mbus_framefmt mf;
+	struct v4l2_mbus_framefmt mf[4];
 
 	struct mutex lock;
 	int stream_count[4];
@@ -644,10 +644,14 @@ static int rcar_csi2_set_pad_format(struct v4l2_subdev *sd,
 	struct rcar_csi2 *priv = sd_to_csi2(sd);
 	struct v4l2_mbus_framefmt *framefmt;
 
+	if (format->pad < RCAR_CSI2_SOURCE_VC0 ||
+	    format->pad > RCAR_CSI2_SOURCE_VC3)
+		return -EINVAL;
+
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
-		priv->mf = format->format;
+		priv->mf[format->pad] = format->format;
 	} else {
-		framefmt = v4l2_subdev_get_try_format(sd, cfg, 0);
+		framefmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
 		*framefmt = format->format;
 	}
 
@@ -660,10 +664,15 @@ static int rcar_csi2_get_pad_format(struct v4l2_subdev *sd,
 {
 	struct rcar_csi2 *priv = sd_to_csi2(sd);
 
+	if (format->pad < RCAR_CSI2_SOURCE_VC0 ||
+	    format->pad > RCAR_CSI2_SOURCE_VC3)
+		return -EINVAL;
+
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
-		format->format = priv->mf;
+		format->format = priv->mf[format->pad];
 	else
-		format->format = *v4l2_subdev_get_try_format(sd, cfg, 0);
+		format->format = *v4l2_subdev_get_try_format(sd, cfg,
+							     format->pad);
 
 	return 0;
 }
-- 
2.13.3
