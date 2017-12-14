Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:34172 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754300AbdLNTJT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 14:09:19 -0500
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
Subject: [PATCH/RFC v2 05/15] rcar-csi2: count usage for each source pad
Date: Thu, 14 Dec 2017 20:08:25 +0100
Message-Id: <20171214190835.7672-6-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
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
stream. At the same time we only want to start or stop the R-Car
CSI-2 device only on the first or last stream.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 38 +++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index 8ce0bfeef1113f9c..e0f56cc3d25179a9 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -328,6 +328,14 @@ enum rcar_csi2_pads {
 	NR_OF_RCAR_CSI2_PAD,
 };
 
+static int rcar_csi2_pad_to_vc(unsigned int pad)
+{
+	if (pad < RCAR_CSI2_SOURCE_VC0 || pad > RCAR_CSI2_SOURCE_VC3)
+		return -EINVAL;
+
+	return pad - RCAR_CSI2_SOURCE_VC0;
+}
+
 struct rcar_csi2_info {
 	const struct phypll_hsfreqrange *hsfreqrange;
 	const struct phtw_testdin_data *testdin_data;
@@ -350,7 +358,7 @@ struct rcar_csi2 {
 	struct v4l2_mbus_framefmt mf;
 
 	struct mutex lock;
-	int stream_count;
+	int stream_count[4];
 
 	unsigned short lanes;
 	unsigned char lane_swap[4];
@@ -630,7 +638,13 @@ static int rcar_csi2_s_stream(struct v4l2_subdev *sd, unsigned int pad,
 {
 	struct rcar_csi2 *priv = sd_to_csi2(sd);
 	struct v4l2_subdev *nextsd;
-	int ret;
+	unsigned int i, count = 0;
+	int ret, vc;
+
+	/* Only allow stream control on source pads and valid vc */
+	vc = rcar_csi2_pad_to_vc(pad);
+	if (vc < 0)
+		return vc;
 
 	/* Only one stream on each source pad */
 	if (stream != 0)
@@ -642,7 +656,10 @@ static int rcar_csi2_s_stream(struct v4l2_subdev *sd, unsigned int pad,
 	if (ret)
 		goto out;
 
-	if (enable && priv->stream_count == 0) {
+	for (i = 0; i < 4; i++)
+		count += priv->stream_count[i];
+
+	if (enable && count == 0) {
 		pm_runtime_get_sync(priv->dev);
 
 		ret = rcar_csi2_start(priv);
@@ -650,20 +667,23 @@ static int rcar_csi2_s_stream(struct v4l2_subdev *sd, unsigned int pad,
 			pm_runtime_put(priv->dev);
 			goto out;
 		}
+	} else if (!enable && count == 1) {
+		rcar_csi2_stop(priv);
+		pm_runtime_put(priv->dev);
+	}
 
+	if (enable && priv->stream_count[vc] == 0) {
 		ret = v4l2_subdev_call(nextsd, video, s_stream, 1);
 		if (ret) {
 			rcar_csi2_stop(priv);
 			pm_runtime_put(priv->dev);
 			goto out;
 		}
-	} else if (!enable && priv->stream_count == 1) {
-		rcar_csi2_stop(priv);
+	} else if (!enable && priv->stream_count[vc] == 1) {
 		ret = v4l2_subdev_call(nextsd, video, s_stream, 0);
-		pm_runtime_put(priv->dev);
 	}
 
-	priv->stream_count += enable ? 1 : -1;
+	priv->stream_count[vc] += enable ? 1 : -1;
 out:
 	mutex_unlock(&priv->lock);
 
@@ -919,7 +939,9 @@ static int rcar_csi2_probe(struct platform_device *pdev)
 	priv->dev = &pdev->dev;
 
 	mutex_init(&priv->lock);
-	priv->stream_count = 0;
+
+	for (i = 0; i < 4; i++)
+		priv->stream_count[i] = 0;
 
 	ret = rcar_csi2_probe_resources(priv, pdev);
 	if (ret) {
-- 
2.15.1
