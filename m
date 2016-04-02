Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:45196 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbcDBRnA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Apr 2016 13:43:00 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-renesas-soc@vger.kernel.org, lars@metafoo.de,
	mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 2/3] [media] adv7180: Add cropcap operation
Date: Sat,  2 Apr 2016 19:42:19 +0200
Message-Id: <1459618940-8170-3-git-send-email-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <1459618940-8170-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
References: <1459618940-8170-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support to get the pixel aspect ratio depending on the current
standard (50 vs 60 Hz).

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/i2c/adv7180.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index d680d76..80ded70 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -726,6 +726,21 @@ static int adv7180_g_mbus_config(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int adv7180_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *cropcap)
+{
+	struct adv7180_state *state = to_state(sd);
+
+	if (state->curr_norm & V4L2_STD_525_60) {
+		cropcap->pixelaspect.numerator = 11;
+		cropcap->pixelaspect.denominator = 10;
+	} else {
+		cropcap->pixelaspect.numerator = 54;
+		cropcap->pixelaspect.denominator = 59;
+	}
+
+	return 0;
+}
+
 static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 	.s_std = adv7180_s_std,
 	.g_std = adv7180_g_std,
@@ -733,6 +748,7 @@ static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 	.g_input_status = adv7180_g_input_status,
 	.s_routing = adv7180_s_routing,
 	.g_mbus_config = adv7180_g_mbus_config,
+	.cropcap = adv7180_cropcap,
 };
 
 
-- 
2.7.4

