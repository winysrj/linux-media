Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:54318 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753019AbeEKOEy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 10:04:54 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2] media: i2c: adv748x: Fix pixel rate values
Date: Fri, 11 May 2018 16:04:34 +0200
Message-Id: <20180511140434.19274-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The pixel rate, as reported by the V4L2_CID_PIXEL_RATE control, must
include both horizontal and vertical blanking. Both the AFE and HDMI
receiver program it incorrectly:

- The HDMI receiver goes to the trouble of removing blanking to compute
the rate of active pixels. This is easy to fix by removing the
computation and returning the incoming pixel clock rate directly.

- The AFE performs similar calculation, while it should simply return
the fixed pixel rate for analog sources, mandated by the ADV748x to be
14.3180180 MHz.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
[Niklas: Update AFE fixed pixel rate]
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

---

* Changes since v1
- Update AFE fixed pixel rate.
---
 drivers/media/i2c/adv748x/adv748x-afe.c  | 12 ++++++------
 drivers/media/i2c/adv748x/adv748x-hdmi.c |  8 +-------
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c b/drivers/media/i2c/adv748x/adv748x-afe.c
index 61514bae7e5ceb42..edd25e895e5dec3c 100644
--- a/drivers/media/i2c/adv748x/adv748x-afe.c
+++ b/drivers/media/i2c/adv748x/adv748x-afe.c
@@ -321,17 +321,17 @@ static const struct v4l2_subdev_video_ops adv748x_afe_video_ops = {
 static int adv748x_afe_propagate_pixelrate(struct adv748x_afe *afe)
 {
 	struct v4l2_subdev *tx;
-	unsigned int width, height, fps;
 
 	tx = adv748x_get_remote_sd(&afe->pads[ADV748X_AFE_SOURCE]);
 	if (!tx)
 		return -ENOLINK;
 
-	width = 720;
-	height = afe->curr_norm & V4L2_STD_525_60 ? 480 : 576;
-	fps = afe->curr_norm & V4L2_STD_525_60 ? 30 : 25;
-
-	return adv748x_csi2_set_pixelrate(tx, width * height * fps);
+	/*
+	 * The ADV748x ADC sampling frequency is twice the externally supplied
+	 * clock whose frequency is required to be 28.63636 MHz. It oversamples
+	 * with a factor of 4 resulting in a pixel rate of 14.3180180 MHz.
+	 */
+	return adv748x_csi2_set_pixelrate(tx, 14318180);
 }
 
 static int adv748x_afe_enum_mbus_code(struct v4l2_subdev *sd,
diff --git a/drivers/media/i2c/adv748x/adv748x-hdmi.c b/drivers/media/i2c/adv748x/adv748x-hdmi.c
index 10d229a4f08868f7..aecc2a84dfecbec8 100644
--- a/drivers/media/i2c/adv748x/adv748x-hdmi.c
+++ b/drivers/media/i2c/adv748x/adv748x-hdmi.c
@@ -402,8 +402,6 @@ static int adv748x_hdmi_propagate_pixelrate(struct adv748x_hdmi *hdmi)
 {
 	struct v4l2_subdev *tx;
 	struct v4l2_dv_timings timings;
-	struct v4l2_bt_timings *bt = &timings.bt;
-	unsigned int fps;
 
 	tx = adv748x_get_remote_sd(&hdmi->pads[ADV748X_HDMI_SOURCE]);
 	if (!tx)
@@ -411,11 +409,7 @@ static int adv748x_hdmi_propagate_pixelrate(struct adv748x_hdmi *hdmi)
 
 	adv748x_hdmi_query_dv_timings(&hdmi->sd, &timings);
 
-	fps = DIV_ROUND_CLOSEST_ULL(bt->pixelclock,
-				    V4L2_DV_BT_FRAME_WIDTH(bt) *
-				    V4L2_DV_BT_FRAME_HEIGHT(bt));
-
-	return adv748x_csi2_set_pixelrate(tx, bt->width * bt->height * fps);
+	return adv748x_csi2_set_pixelrate(tx, timings.bt.pixelclock);
 }
 
 static int adv748x_hdmi_enum_mbus_code(struct v4l2_subdev *sd,
-- 
2.17.0
