Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59873 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbcEXMJZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 08:09:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Jean-Michel Hautbois <jhautbois@gmail.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Subject: [PATCH] adv7604: Don't ignore pad number in subdev DV timings pad operations
Date: Tue, 24 May 2016 15:09:33 +0300
Message-Id: <1464091773-7231-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dv_timings_cap() and enum_dv_timings() pad operations take a pad
number as an input argument and return the DV timings capabilities and
list of supported DV timings for that pad.

Commit bd3e275f3ec0 ("[media] media: i2c: adv7604: Use v4l2-dv-timings
helpers") broke this as it started ignoring the pad number, always
returning the information associated with the currently selected input.
Fix it.

Fixes: bd3e275f3ec0 ("[media] media: i2c: adv7604: Use v4l2-dv-timings helpers")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/adv7604.c | 46 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index beb2841ceae5..3f1ab4986cfc 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -779,11 +779,31 @@ static const struct v4l2_dv_timings_cap adv76xx_timings_cap_digital = {
 			V4L2_DV_BT_CAP_CUSTOM)
 };
 
-static inline const struct v4l2_dv_timings_cap *
-adv76xx_get_dv_timings_cap(struct v4l2_subdev *sd)
+/*
+ * Return the DV timings capabilities for the requested sink pad. As a special
+ * case, pad value -1 returns the capabilities for the currently selected input.
+ */
+static const struct v4l2_dv_timings_cap *
+adv76xx_get_dv_timings_cap(struct v4l2_subdev *sd, int pad)
 {
-	return is_digital_input(sd) ? &adv76xx_timings_cap_digital :
-				      &adv7604_timings_cap_analog;
+	if (pad == -1) {
+		struct adv76xx_state *state = to_state(sd);
+
+		pad = state->selected_input;
+	}
+
+	switch (pad) {
+	case ADV76XX_PAD_HDMI_PORT_A:
+	case ADV7604_PAD_HDMI_PORT_B:
+	case ADV7604_PAD_HDMI_PORT_C:
+	case ADV7604_PAD_HDMI_PORT_D:
+		return &adv76xx_timings_cap_digital;
+
+	case ADV7604_PAD_VGA_RGB:
+	case ADV7604_PAD_VGA_COMP:
+	default:
+		return &adv7604_timings_cap_analog;
+	}
 }
 
 
@@ -1329,7 +1349,7 @@ static int stdi2dv_timings(struct v4l2_subdev *sd,
 		const struct v4l2_bt_timings *bt = &v4l2_dv_timings_presets[i].bt;
 
 		if (!v4l2_valid_dv_timings(&v4l2_dv_timings_presets[i],
-					   adv76xx_get_dv_timings_cap(sd),
+					   adv76xx_get_dv_timings_cap(sd, -1),
 					   adv76xx_check_dv_timings, NULL))
 			continue;
 		if (vtotal(bt) != stdi->lcf + 1)
@@ -1430,18 +1450,22 @@ static int adv76xx_enum_dv_timings(struct v4l2_subdev *sd,
 		return -EINVAL;
 
 	return v4l2_enum_dv_timings_cap(timings,
-		adv76xx_get_dv_timings_cap(sd), adv76xx_check_dv_timings, NULL);
+		adv76xx_get_dv_timings_cap(sd, timings->pad),
+		adv76xx_check_dv_timings, NULL);
 }
 
 static int adv76xx_dv_timings_cap(struct v4l2_subdev *sd,
 			struct v4l2_dv_timings_cap *cap)
 {
 	struct adv76xx_state *state = to_state(sd);
+	unsigned int pad = cap->pad;
 
 	if (cap->pad >= state->source_pad)
 		return -EINVAL;
 
-	*cap = *adv76xx_get_dv_timings_cap(sd);
+	*cap = *adv76xx_get_dv_timings_cap(sd, pad);
+	cap->pad = pad;
+
 	return 0;
 }
 
@@ -1450,9 +1474,9 @@ static int adv76xx_dv_timings_cap(struct v4l2_subdev *sd,
 static void adv76xx_fill_optional_dv_timings_fields(struct v4l2_subdev *sd,
 		struct v4l2_dv_timings *timings)
 {
-	v4l2_find_dv_timings_cap(timings, adv76xx_get_dv_timings_cap(sd),
-			is_digital_input(sd) ? 250000 : 1000000,
-			adv76xx_check_dv_timings, NULL);
+	v4l2_find_dv_timings_cap(timings, adv76xx_get_dv_timings_cap(sd, -1),
+				 is_digital_input(sd) ? 250000 : 1000000,
+				 adv76xx_check_dv_timings, NULL);
 }
 
 static unsigned int adv7604_read_hdmi_pixelclock(struct v4l2_subdev *sd)
@@ -1620,7 +1644,7 @@ static int adv76xx_s_dv_timings(struct v4l2_subdev *sd,
 
 	bt = &timings->bt;
 
-	if (!v4l2_valid_dv_timings(timings, adv76xx_get_dv_timings_cap(sd),
+	if (!v4l2_valid_dv_timings(timings, adv76xx_get_dv_timings_cap(sd, -1),
 				   adv76xx_check_dv_timings, NULL))
 		return -ERANGE;
 
-- 
Regards,

Laurent Pinchart

