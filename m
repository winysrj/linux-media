Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:33702 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275AbbLKQFB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 11:05:01 -0500
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Cc: magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, ian.molton@codethink.co.uk,
	lars@metafoo.de, william.towle@codethink.co.uk,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH 2/3] media: adv7604: implement cropcap
Date: Fri, 11 Dec 2015 17:04:52 +0100
Message-Id: <1449849893-14865-3-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1449849893-14865-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1449849893-14865-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Used by the rcar_vin driver.

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 drivers/media/i2c/adv7604.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index d30e7cc..1bfa9f3 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1896,6 +1896,22 @@ static int adv76xx_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	return 0;
 }
 
+static int adv76xx_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
+{
+	struct adv76xx_state *state = to_state(sd);
+
+	a->bounds.left	 = 0;
+	a->bounds.top	 = 0;
+	a->bounds.width	 = state->timings.bt.width;
+	a->bounds.height = state->timings.bt.height;
+	a->defrect	 = a->bounds;
+	a->type		 = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	a->pixelaspect.numerator   = 1;
+	a->pixelaspect.denominator = 1;
+
+	return 0;
+}
+
 static int adv76xx_set_format(struct v4l2_subdev *sd,
 			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_format *format)
@@ -2419,6 +2435,7 @@ static const struct v4l2_subdev_core_ops adv76xx_core_ops = {
 static const struct v4l2_subdev_video_ops adv76xx_video_ops = {
 	.s_routing = adv76xx_s_routing,
 	.g_crop = adv76xx_g_crop,
+	.cropcap = adv76xx_cropcap,
 	.g_input_status = adv76xx_g_input_status,
 	.s_dv_timings = adv76xx_s_dv_timings,
 	.g_dv_timings = adv76xx_g_dv_timings,
-- 
2.6.3

