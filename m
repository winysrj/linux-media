Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:33111 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367AbcHCSEF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2016 14:04:05 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: lars@metafoo.de
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v4 5/8] media: adv7180: implement g_parm
Date: Wed,  3 Aug 2016 11:03:47 -0700
Message-Id: <1470247430-11168-6-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1470247430-11168-1-git-send-email-steve_longerbeam@mentor.com>
References: <1470247430-11168-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement g_parm to return the current standard's frame period.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Tested-by: Tim Harvey <tharvey@gateworks.com>
Acked-by: Tim Harvey <tharvey@gateworks.com>

---
v4: no changes
v3: no changes
v2: no changes
---
 drivers/media/i2c/adv7180.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index b2df181..9705e24 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -764,6 +764,27 @@ static int adv7180_g_mbus_config(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int adv7180_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
+{
+	struct adv7180_state *state = to_state(sd);
+	struct v4l2_captureparm *cparm = &a->parm.capture;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	memset(a, 0, sizeof(*a));
+	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	if (state->curr_norm & V4L2_STD_525_60) {
+		cparm->timeperframe.numerator = 1001;
+		cparm->timeperframe.denominator = 30000;
+	} else {
+		cparm->timeperframe.numerator = 1;
+		cparm->timeperframe.denominator = 25;
+	}
+
+	return 0;
+}
+
 static int adv7180_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *cropcap)
 {
 	struct adv7180_state *state = to_state(sd);
@@ -822,6 +843,7 @@ static int adv7180_subscribe_event(struct v4l2_subdev *sd,
 static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 	.s_std = adv7180_s_std,
 	.g_std = adv7180_g_std,
+	.g_parm = adv7180_g_parm,
 	.querystd = adv7180_querystd,
 	.g_input_status = adv7180_g_input_status,
 	.s_routing = adv7180_s_routing,
-- 
1.9.1

