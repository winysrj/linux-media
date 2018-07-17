Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:62807 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731256AbeGQNKQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 09:10:16 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Lars-Peter Clausen <lars@metafoo.de>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 2/2] adv7180: add g_frame_interval support
Date: Tue, 17 Jul 2018 14:30:41 +0200
Message-Id: <20180717123041.2862-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180717123041.2862-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180717123041.2862-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement g_frame_interval to return the current standard's frame
interval.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/i2c/adv7180.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index c2e24132e8c21d38..f72312efc471acd9 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -461,6 +461,22 @@ static int adv7180_g_std(struct v4l2_subdev *sd, v4l2_std_id *norm)
 	return 0;
 }
 
+static int adv7180_g_frame_interval(struct v4l2_subdev *sd,
+				    struct v4l2_subdev_frame_interval *fi)
+{
+	struct adv7180_state *state = to_state(sd);
+
+	if (state->curr_norm & V4L2_STD_525_60) {
+		fi->interval.numerator = 1001;
+		fi->interval.denominator = 30000;
+	} else {
+		fi->interval.numerator = 1;
+		fi->interval.denominator = 25;
+	}
+
+	return 0;
+}
+
 static void adv7180_set_power_pin(struct adv7180_state *state, bool on)
 {
 	if (!state->pwdn_gpio)
@@ -820,6 +836,7 @@ static int adv7180_subscribe_event(struct v4l2_subdev *sd,
 static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 	.s_std = adv7180_s_std,
 	.g_std = adv7180_g_std,
+	.g_frame_interval = adv7180_g_frame_interval,
 	.querystd = adv7180_querystd,
 	.g_input_status = adv7180_g_input_status,
 	.s_routing = adv7180_s_routing,
-- 
2.18.0
