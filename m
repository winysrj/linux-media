Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33551 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222AbcFNWvc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2016 18:51:32 -0400
Received: by mail-pf0-f193.google.com with SMTP id c74so307139pfb.0
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2016 15:51:32 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 36/38] media: adv7180: implement g_parm
Date: Tue, 14 Jun 2016 15:49:32 -0700
Message-Id: <1465944574-15745-37-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement g_parm to return the current standard's frame period.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/i2c/adv7180.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index b3bb19f..9e40632 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -740,6 +740,27 @@ static int adv7180_g_mbus_config(struct v4l2_subdev *sd,
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
@@ -798,6 +819,7 @@ static int adv7180_subscribe_event(struct v4l2_subdev *sd,
 static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 	.s_std = adv7180_s_std,
 	.g_std = adv7180_g_std,
+	.g_parm = adv7180_g_parm,
 	.querystd = adv7180_querystd,
 	.g_input_status = adv7180_g_input_status,
 	.s_routing = adv7180_s_routing,
-- 
1.9.1

