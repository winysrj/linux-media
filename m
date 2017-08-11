Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:39198 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752965AbdHKJ52 (ORCPT
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
Subject: [PATCH 18/20] adv748x: switch to pad and stream aware s_stream
Date: Fri, 11 Aug 2017 11:57:01 +0200
Message-Id: <20170811095703.6170-19-niklas.soderlund+renesas@ragnatech.se>
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
 drivers/media/i2c/adv748x/adv748x-csi2.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index 58a9d9105148c15b..39d7877ff615fed1 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -128,22 +128,26 @@ static const struct v4l2_subdev_internal_ops adv748x_csi2_internal_ops = {
  * v4l2_subdev_video_ops
  */
 
-static int adv748x_csi2_s_stream(struct v4l2_subdev *sd, int enable)
+static int adv748x_csi2_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+				 unsigned int stream, int enable)
 {
 	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
+	struct adv748x_state *state = tx->state;
 	struct v4l2_subdev *src;
 
+	if (pad != ADV748X_CSI2_SOURCE || stream != 0)
+		return -EINVAL;
+
 	src = adv748x_get_remote_sd(&tx->pads[ADV748X_CSI2_SINK]);
 	if (!src)
 		return -EPIPE;
 
+	adv_dbg(state, "%s: pad: %u stream: %u enable: %d\n", sd->name,
+		pad, stream, enable);
+
 	return v4l2_subdev_call(src, video, s_stream, enable);
 }
 
-static const struct v4l2_subdev_video_ops adv748x_csi2_video_ops = {
-	.s_stream = adv748x_csi2_s_stream,
-};
-
 /* -----------------------------------------------------------------------------
  * v4l2_subdev_pad_ops
  *
@@ -257,6 +261,7 @@ static const struct v4l2_subdev_pad_ops adv748x_csi2_pad_ops = {
 	.get_fmt = adv748x_csi2_get_format,
 	.set_fmt = adv748x_csi2_set_format,
 	.get_frame_desc = adv748x_csi2_get_frame_desc,
+	.s_stream = adv748x_csi2_s_stream,
 };
 
 /* -----------------------------------------------------------------------------
@@ -264,7 +269,6 @@ static const struct v4l2_subdev_pad_ops adv748x_csi2_pad_ops = {
  */
 
 static const struct v4l2_subdev_ops adv748x_csi2_ops = {
-	.video = &adv748x_csi2_video_ops,
 	.pad = &adv748x_csi2_pad_ops,
 };
 
-- 
2.13.3
