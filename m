Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33995 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbcA0LEx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 06:04:53 -0500
Received: by mail-wm0-f67.google.com with SMTP id p63so2638657wmp.1
        for <linux-media@vger.kernel.org>; Wed, 27 Jan 2016 03:04:53 -0800 (PST)
From: Jean-Michel Hautbois <jhautbois@gmail.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, mchehab@osg.samsung.com, lars@metafoo.de,
	Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Subject: [PATCH v3] media: i2c: adv7604: Use v4l2-dv-timings helpers
Date: Wed, 27 Jan 2016 12:04:50 +0100
Message-Id: <1453892690-18042-1-git-send-email-jean-michel.hautbois@veo-labs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the helper to enumerate and set DV timings instead of a custom code.
This will ease debugging too, as it is consistent with other drivers.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
---
 drivers/media/i2c/adv7604.c | 178 ++++++++++++++++----------------------------
 1 file changed, 65 insertions(+), 113 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index f8dd750..5a33a50 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -207,71 +207,22 @@ static bool adv76xx_has_afe(struct adv76xx_state *state)
 	return state->info->has_afe;
 }
 
-/* Supported CEA and DMT timings */
-static const struct v4l2_dv_timings adv76xx_timings[] = {
-	V4L2_DV_BT_CEA_720X480P59_94,
-	V4L2_DV_BT_CEA_720X576P50,
-	V4L2_DV_BT_CEA_1280X720P24,
-	V4L2_DV_BT_CEA_1280X720P25,
-	V4L2_DV_BT_CEA_1280X720P50,
-	V4L2_DV_BT_CEA_1280X720P60,
-	V4L2_DV_BT_CEA_1920X1080P24,
-	V4L2_DV_BT_CEA_1920X1080P25,
-	V4L2_DV_BT_CEA_1920X1080P30,
-	V4L2_DV_BT_CEA_1920X1080P50,
-	V4L2_DV_BT_CEA_1920X1080P60,
-
-	/* sorted by DMT ID */
-	V4L2_DV_BT_DMT_640X350P85,
-	V4L2_DV_BT_DMT_640X400P85,
-	V4L2_DV_BT_DMT_720X400P85,
-	V4L2_DV_BT_DMT_640X480P60,
-	V4L2_DV_BT_DMT_640X480P72,
-	V4L2_DV_BT_DMT_640X480P75,
-	V4L2_DV_BT_DMT_640X480P85,
-	V4L2_DV_BT_DMT_800X600P56,
-	V4L2_DV_BT_DMT_800X600P60,
-	V4L2_DV_BT_DMT_800X600P72,
-	V4L2_DV_BT_DMT_800X600P75,
-	V4L2_DV_BT_DMT_800X600P85,
-	V4L2_DV_BT_DMT_848X480P60,
-	V4L2_DV_BT_DMT_1024X768P60,
-	V4L2_DV_BT_DMT_1024X768P70,
-	V4L2_DV_BT_DMT_1024X768P75,
-	V4L2_DV_BT_DMT_1024X768P85,
-	V4L2_DV_BT_DMT_1152X864P75,
-	V4L2_DV_BT_DMT_1280X768P60_RB,
-	V4L2_DV_BT_DMT_1280X768P60,
-	V4L2_DV_BT_DMT_1280X768P75,
-	V4L2_DV_BT_DMT_1280X768P85,
-	V4L2_DV_BT_DMT_1280X800P60_RB,
-	V4L2_DV_BT_DMT_1280X800P60,
-	V4L2_DV_BT_DMT_1280X800P75,
-	V4L2_DV_BT_DMT_1280X800P85,
-	V4L2_DV_BT_DMT_1280X960P60,
-	V4L2_DV_BT_DMT_1280X960P85,
-	V4L2_DV_BT_DMT_1280X1024P60,
-	V4L2_DV_BT_DMT_1280X1024P75,
-	V4L2_DV_BT_DMT_1280X1024P85,
-	V4L2_DV_BT_DMT_1360X768P60,
-	V4L2_DV_BT_DMT_1400X1050P60_RB,
-	V4L2_DV_BT_DMT_1400X1050P60,
-	V4L2_DV_BT_DMT_1400X1050P75,
-	V4L2_DV_BT_DMT_1400X1050P85,
-	V4L2_DV_BT_DMT_1440X900P60_RB,
-	V4L2_DV_BT_DMT_1440X900P60,
-	V4L2_DV_BT_DMT_1600X1200P60,
-	V4L2_DV_BT_DMT_1680X1050P60_RB,
-	V4L2_DV_BT_DMT_1680X1050P60,
-	V4L2_DV_BT_DMT_1792X1344P60,
-	V4L2_DV_BT_DMT_1856X1392P60,
-	V4L2_DV_BT_DMT_1920X1200P60_RB,
-	V4L2_DV_BT_DMT_1366X768P60_RB,
-	V4L2_DV_BT_DMT_1366X768P60,
-	V4L2_DV_BT_DMT_1920X1080P60,
-	{ },
+/* Unsupported timings. This device cannot support 720p30. */
+static const struct v4l2_dv_timings adv76xx_timings_exceptions[] = {
+	V4L2_DV_BT_CEA_1280X720P30,
+	{ }
 };
 
+static bool adv76xx_check_dv_timings(const struct v4l2_dv_timings *t, void *hdl)
+{
+	int i;
+
+	for (i = 0; adv76xx_timings_exceptions[i].bt.width; i++)
+		if (v4l2_match_dv_timings(t, adv76xx_timings_exceptions + i, 0, false))
+			return false;
+	return true;
+}
+
 struct adv76xx_video_standards {
 	struct v4l2_dv_timings timings;
 	u8 vid_std;
@@ -806,6 +757,36 @@ static inline bool is_digital_input(struct v4l2_subdev *sd)
 	       state->selected_input == ADV7604_PAD_HDMI_PORT_D;
 }
 
+static const struct v4l2_dv_timings_cap adv7604_timings_cap_analog = {
+	.type = V4L2_DV_BT_656_1120,
+	/* keep this initialization for compatibility with GCC < 4.4.6 */
+	.reserved = { 0 },
+	V4L2_INIT_BT_TIMINGS(0, 1920, 0, 1200, 25000000, 170000000,
+		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
+			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
+		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_REDUCED_BLANKING |
+			V4L2_DV_BT_CAP_CUSTOM)
+};
+
+static const struct v4l2_dv_timings_cap adv76xx_timings_cap_digital = {
+	.type = V4L2_DV_BT_656_1120,
+	/* keep this initialization for compatibility with GCC < 4.4.6 */
+	.reserved = { 0 },
+	V4L2_INIT_BT_TIMINGS(0, 1920, 0, 1200, 25000000, 225000000,
+		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
+			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
+		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_REDUCED_BLANKING |
+			V4L2_DV_BT_CAP_CUSTOM)
+};
+
+static inline const struct v4l2_dv_timings_cap *
+adv76xx_get_dv_timings_cap(struct v4l2_subdev *sd)
+{
+	return is_digital_input(sd) ? &adv76xx_timings_cap_digital :
+				      &adv7604_timings_cap_analog;
+}
+
+
 /* ----------------------------------------------------------------------- */
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -1330,17 +1311,23 @@ static int stdi2dv_timings(struct v4l2_subdev *sd,
 	u32 pix_clk;
 	int i;
 
-	for (i = 0; adv76xx_timings[i].bt.height; i++) {
-		if (vtotal(&adv76xx_timings[i].bt) != stdi->lcf + 1)
+	for (i = 0; v4l2_dv_timings_presets[i].bt.width; i++) {
+		const struct v4l2_bt_timings *bt = &v4l2_dv_timings_presets[i].bt;
+
+		if (!v4l2_valid_dv_timings(&v4l2_dv_timings_presets[i],
+					   adv76xx_get_dv_timings_cap(sd),
+					   adv76xx_check_dv_timings, NULL))
+			continue;
+		if (vtotal(bt) != stdi->lcf + 1)
 			continue;
-		if (adv76xx_timings[i].bt.vsync != stdi->lcvs)
+		if (bt->vsync != stdi->lcvs)
 			continue;
 
-		pix_clk = hfreq * htotal(&adv76xx_timings[i].bt);
+		pix_clk = hfreq * htotal(bt);
 
-		if ((pix_clk < adv76xx_timings[i].bt.pixelclock + 1000000) &&
-		    (pix_clk > adv76xx_timings[i].bt.pixelclock - 1000000)) {
-			*timings = adv76xx_timings[i];
+		if ((pix_clk < bt->pixelclock + 1000000) &&
+		    (pix_clk > bt->pixelclock - 1000000)) {
+			*timings = v4l2_dv_timings_presets[i];
 			return 0;
 		}
 	}
@@ -1425,15 +1412,11 @@ static int adv76xx_enum_dv_timings(struct v4l2_subdev *sd,
 {
 	struct adv76xx_state *state = to_state(sd);
 
-	if (timings->index >= ARRAY_SIZE(adv76xx_timings) - 1)
-		return -EINVAL;
-
 	if (timings->pad >= state->source_pad)
 		return -EINVAL;
 
-	memset(timings->reserved, 0, sizeof(timings->reserved));
-	timings->timings = adv76xx_timings[timings->index];
-	return 0;
+	return v4l2_enum_dv_timings_cap(timings,
+		adv76xx_get_dv_timings_cap(sd), adv76xx_check_dv_timings, NULL);
 }
 
 static int adv76xx_dv_timings_cap(struct v4l2_subdev *sd,
@@ -1444,29 +1427,7 @@ static int adv76xx_dv_timings_cap(struct v4l2_subdev *sd,
 	if (cap->pad >= state->source_pad)
 		return -EINVAL;
 
-	cap->type = V4L2_DV_BT_656_1120;
-	cap->bt.max_width = 1920;
-	cap->bt.max_height = 1200;
-	cap->bt.min_pixelclock = 25000000;
-
-	switch (cap->pad) {
-	case ADV76XX_PAD_HDMI_PORT_A:
-	case ADV7604_PAD_HDMI_PORT_B:
-	case ADV7604_PAD_HDMI_PORT_C:
-	case ADV7604_PAD_HDMI_PORT_D:
-		cap->bt.max_pixelclock = 225000000;
-		break;
-	case ADV7604_PAD_VGA_RGB:
-	case ADV7604_PAD_VGA_COMP:
-	default:
-		cap->bt.max_pixelclock = 170000000;
-		break;
-	}
-
-	cap->bt.standards = V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
-			 V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT;
-	cap->bt.capabilities = V4L2_DV_BT_CAP_PROGRESSIVE |
-		V4L2_DV_BT_CAP_REDUCED_BLANKING | V4L2_DV_BT_CAP_CUSTOM;
+	*cap = *adv76xx_get_dv_timings_cap(sd);
 	return 0;
 }
 
@@ -1475,15 +1436,9 @@ static int adv76xx_dv_timings_cap(struct v4l2_subdev *sd,
 static void adv76xx_fill_optional_dv_timings_fields(struct v4l2_subdev *sd,
 		struct v4l2_dv_timings *timings)
 {
-	int i;
-
-	for (i = 0; adv76xx_timings[i].bt.width; i++) {
-		if (v4l2_match_dv_timings(timings, &adv76xx_timings[i],
-				is_digital_input(sd) ? 250000 : 1000000, false)) {
-			*timings = adv76xx_timings[i];
-			break;
-		}
-	}
+	v4l2_find_dv_timings_cap(timings, adv76xx_get_dv_timings_cap(sd),
+			is_digital_input(sd) ? 250000 : 1000000,
+			adv76xx_check_dv_timings, NULL);
 }
 
 static unsigned int adv7604_read_hdmi_pixelclock(struct v4l2_subdev *sd)
@@ -1651,12 +1606,9 @@ static int adv76xx_s_dv_timings(struct v4l2_subdev *sd,
 
 	bt = &timings->bt;
 
-	if ((is_analog_input(sd) && bt->pixelclock > 170000000) ||
-			(is_digital_input(sd) && bt->pixelclock > 225000000)) {
-		v4l2_dbg(1, debug, sd, "%s: pixelclock out of range %d\n",
-				__func__, (u32)bt->pixelclock);
+	if (!v4l2_valid_dv_timings(timings, adv76xx_get_dv_timings_cap(sd),
+				   adv76xx_check_dv_timings, NULL))
 		return -ERANGE;
-	}
 
 	adv76xx_fill_optional_dv_timings_fields(sd, timings);
 
-- 
2.7.0

