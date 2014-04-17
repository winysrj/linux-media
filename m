Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38906 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbaDQONk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 10:13:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v4 37/49] adv7604: Remove deprecated video-level DV timings operations
Date: Thu, 17 Apr 2014 16:13:08 +0200
Message-Id: <1397744000-23967-38-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video enum_dv_timings and dv_timings_cap operations are deprecated
and unused. Remove them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 35 +++++++++--------------------------
 1 file changed, 9 insertions(+), 26 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 684b912..29bdb9e 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1527,16 +1527,20 @@ static int adv7604_enum_dv_timings(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int __adv7604_dv_timings_cap(struct v4l2_subdev *sd,
-			struct v4l2_dv_timings_cap *cap,
-			unsigned int pad)
+static int adv7604_dv_timings_cap(struct v4l2_subdev *sd,
+			struct v4l2_dv_timings_cap *cap)
 {
+	struct adv7604_state *state = to_state(sd);
+
+	if (cap->pad >= state->source_pad)
+		return -EINVAL;
+
 	cap->type = V4L2_DV_BT_656_1120;
 	cap->bt.max_width = 1920;
 	cap->bt.max_height = 1200;
 	cap->bt.min_pixelclock = 25000000;
 
-	switch (pad) {
+	switch (cap->pad) {
 	case ADV7604_PAD_HDMI_PORT_A:
 	case ADV7604_PAD_HDMI_PORT_B:
 	case ADV7604_PAD_HDMI_PORT_C:
@@ -1557,25 +1561,6 @@ static int __adv7604_dv_timings_cap(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int adv7604_dv_timings_cap(struct v4l2_subdev *sd,
-			struct v4l2_dv_timings_cap *cap)
-{
-	struct adv7604_state *state = to_state(sd);
-
-	return __adv7604_dv_timings_cap(sd, cap, state->selected_input);
-}
-
-static int adv7604_pad_dv_timings_cap(struct v4l2_subdev *sd,
-			struct v4l2_dv_timings_cap *cap)
-{
-	struct adv7604_state *state = to_state(sd);
-
-	if (cap->pad >= state->source_pad)
-		return -EINVAL;
-
-	return __adv7604_dv_timings_cap(sd, cap, cap->pad);
-}
-
 /* Fill the optional fields .standards and .flags in struct v4l2_dv_timings
    if the format is listed in adv7604_timings[] */
 static void adv7604_fill_optional_dv_timings_fields(struct v4l2_subdev *sd,
@@ -2453,8 +2438,6 @@ static const struct v4l2_subdev_video_ops adv7604_video_ops = {
 	.s_dv_timings = adv7604_s_dv_timings,
 	.g_dv_timings = adv7604_g_dv_timings,
 	.query_dv_timings = adv7604_query_dv_timings,
-	.enum_dv_timings = adv7604_enum_dv_timings,
-	.dv_timings_cap = adv7604_dv_timings_cap,
 };
 
 static const struct v4l2_subdev_pad_ops adv7604_pad_ops = {
@@ -2463,7 +2446,7 @@ static const struct v4l2_subdev_pad_ops adv7604_pad_ops = {
 	.set_fmt = adv7604_set_format,
 	.get_edid = adv7604_get_edid,
 	.set_edid = adv7604_set_edid,
-	.dv_timings_cap = adv7604_pad_dv_timings_cap,
+	.dv_timings_cap = adv7604_dv_timings_cap,
 	.enum_dv_timings = adv7604_enum_dv_timings,
 };
 
-- 
1.8.3.2

