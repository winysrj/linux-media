Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:39244 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752944AbdHKJ5Z (ORCPT
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
Subject: [PATCH 10/20] rcar-csi2: count usage for each source pad
Date: Fri, 11 Aug 2017 11:56:53 +0200
Message-Id: <20170811095703.6170-11-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The R-Car CSI-2 hardware can output the same virtual channel
simultaneously to more then one R-Car VIN. For this reason we need to
move the usage counting from the global device to each source pad.

If a source pads usage count go from 0 to 1 we need to signal that a new
stream should start, likewise if it go from 1 to 0 we need to stop a
stream. At the same time we don't want to start or stop the whole R-Car
CSI-2 device but at the first or last stream is started.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index 8b4db70b0dd5d0fb..12a8ea7a219ac7d3 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -294,7 +294,7 @@ struct rcar_csi2 {
 	struct v4l2_mbus_framefmt mf;
 
 	struct mutex lock;
-	int stream_count;
+	int stream_count[4];
 
 	struct {
 		struct v4l2_async_subdev asd;
@@ -582,7 +582,7 @@ static int rcar_csi2_s_stream(struct v4l2_subdev *sd, unsigned int pad,
 			      unsigned int stream, int enable)
 {
 	struct rcar_csi2 *priv = sd_to_csi2(sd);
-	unsigned int channel, nextpad, nextstream;
+	unsigned int i, channel, nextpad, nextstream, count = 0;
 	struct v4l2_subdev *nextsd;
 	int ret;
 
@@ -601,18 +601,25 @@ static int rcar_csi2_s_stream(struct v4l2_subdev *sd, unsigned int pad,
 	if (ret)
 		goto out;
 
-	priv->stream_count += enable ? 1 : -1;
+	priv->stream_count[channel] += enable ? 1 : -1;
 
-	if (enable && priv->stream_count == 1) {
+	for (i = 0; i < 4; i++)
+		count += priv->stream_count[i];
+
+	if (enable && count == 1) {
 		ret =  rcar_csi2_start(priv);
 		if (ret)
 			goto out;
-		ret = v4l2_subdev_call(nextsd, video, s_stream, 1);
-
-	} else if (!enable && !priv->stream_count) {
+	} else if (!enable && !count) {
 		rcar_csi2_stop(priv);
-		ret = v4l2_subdev_call(nextsd, video, s_stream, 0);
 	}
+
+	if (enable && priv->stream_count[channel] == 1)
+		ret = v4l2_subdev_call(nextsd, pad, s_stream, nextpad,
+				       nextstream, 1);
+	else if (!enable && !priv->stream_count[channel])
+		ret = v4l2_subdev_call(nextsd, pad, s_stream, nextpad,
+				       nextstream, 0);
 out:
 	mutex_unlock(&priv->lock);
 
@@ -912,7 +919,9 @@ static int rcar_csi2_probe(struct platform_device *pdev)
 	priv->dev = &pdev->dev;
 
 	mutex_init(&priv->lock);
-	priv->stream_count = 0;
+
+	for (i = 0; i < 4; i++)
+		priv->stream_count[i] = 0;
 
 	ret = rcar_csi2_parse_dt_settings(priv);
 	if (ret)
-- 
2.13.3
