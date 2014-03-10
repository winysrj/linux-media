Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48727 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbaCJXOw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 19:14:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 37/48] adv7604: Add pad-level DV timings support
Date: Tue, 11 Mar 2014 00:15:48 +0100
Message-Id: <1394493359-14115-38-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/adv7604.c | 47 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 43 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 66b3481..a96c339 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1514,24 +1514,42 @@ static int read_stdi(struct v4l2_subdev *sd, struct stdi_readback *stdi)
 static int adv7604_enum_dv_timings(struct v4l2_subdev *sd,
 			struct v4l2_enum_dv_timings *timings)
 {
+	struct adv7604_state *state = to_state(sd);
+
 	if (timings->index >= ARRAY_SIZE(adv7604_timings) - 1)
 		return -EINVAL;
+
+	if (timings->pad >= state->source_pad)
+		return -EINVAL;
+
 	memset(timings->reserved, 0, sizeof(timings->reserved));
 	timings->timings = adv7604_timings[timings->index];
 	return 0;
 }
 
-static int adv7604_dv_timings_cap(struct v4l2_subdev *sd,
-			struct v4l2_dv_timings_cap *cap)
+static int __adv7604_dv_timings_cap(struct v4l2_subdev *sd,
+			struct v4l2_dv_timings_cap *cap,
+			unsigned int pad)
 {
 	cap->type = V4L2_DV_BT_656_1120;
 	cap->bt.max_width = 1920;
 	cap->bt.max_height = 1200;
 	cap->bt.min_pixelclock = 25000000;
-	if (is_digital_input(sd))
+
+	switch (pad) {
+	case ADV7604_PAD_HDMI_PORT_A:
+	case ADV7604_PAD_HDMI_PORT_B:
+	case ADV7604_PAD_HDMI_PORT_C:
+	case ADV7604_PAD_HDMI_PORT_D:
 		cap->bt.max_pixelclock = 225000000;
-	else
+		break;
+	case ADV7604_PAD_VGA_RGB:
+	case ADV7604_PAD_VGA_COMP:
+	default:
 		cap->bt.max_pixelclock = 170000000;
+		break;
+	}
+
 	cap->bt.standards = V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
 			 V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT;
 	cap->bt.capabilities = V4L2_DV_BT_CAP_PROGRESSIVE |
@@ -1539,6 +1557,25 @@ static int adv7604_dv_timings_cap(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int adv7604_dv_timings_cap(struct v4l2_subdev *sd,
+			struct v4l2_dv_timings_cap *cap)
+{
+	struct adv7604_state *state = to_state(sd);
+
+	return __adv7604_dv_timings_cap(sd, cap, state->selected_input);
+}
+
+static int adv7604_pad_dv_timings_cap(struct v4l2_subdev *sd,
+			struct v4l2_dv_timings_cap *cap)
+{
+	struct adv7604_state *state = to_state(sd);
+
+	if (cap->pad >= state->source_pad)
+		return -EINVAL;
+
+	return __adv7604_dv_timings_cap(sd, cap, cap->pad);
+}
+
 /* Fill the optional fields .standards and .flags in struct v4l2_dv_timings
    if the format is listed in adv7604_timings[] */
 static void adv7604_fill_optional_dv_timings_fields(struct v4l2_subdev *sd,
@@ -2389,6 +2426,8 @@ static const struct v4l2_subdev_pad_ops adv7604_pad_ops = {
 	.set_fmt = adv7604_set_format,
 	.get_edid = adv7604_get_edid,
 	.set_edid = adv7604_set_edid,
+	.dv_timings_cap = adv7604_pad_dv_timings_cap,
+	.enum_dv_timings = adv7604_enum_dv_timings,
 };
 
 static const struct v4l2_subdev_ops adv7604_ops = {
-- 
1.8.3.2

