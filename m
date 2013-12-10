Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3847 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab3LJPGG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 10:06:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 07/22] adv7842: Receive CEA formats as RGB on VGA (RGB) input
Date: Tue, 10 Dec 2013 16:03:53 +0100
Message-Id: <a8eb38781fe86e8a4fb78c163d522b8bf70b9420.1386687810.git.hans.verkuil@cisco.com>
In-Reply-To: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
References: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
References: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

If input is ADV7842_MODE_RGB and RGB quantization range is set to
V4L2_DV_RGB_RANGE_AUTO, then video with CEA timings will be received
as RGB. For ADV7842_MODE_COMP, automatic CSC mode will be selected.

See table 48 on page 281 in "ADV7842 Hardware Manual, Rev. 0, January 2011"
for details.

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Reviewed-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 52 +++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 18 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 828fd23..59e7ef5 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1034,25 +1034,41 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 {
 	struct adv7842_state *state = to_state(sd);
 
+	v4l2_dbg(2, debug, sd, "%s: rgb_quantization_range = %d\n",
+		       __func__, state->rgb_quantization_range);
+
 	switch (state->rgb_quantization_range) {
 	case V4L2_DV_RGB_RANGE_AUTO:
-		/* automatic */
-		if (is_digital_input(sd) && !(hdmi_read(sd, 0x05) & 0x80)) {
-			/* receiving DVI-D signal */
-
-			/* ADV7842 selects RGB limited range regardless of
-			   input format (CE/IT) in automatic mode */
-			if (state->timings.bt.standards & V4L2_DV_BT_STD_CEA861) {
-				/* RGB limited range (16-235) */
-				io_write_and_or(sd, 0x02, 0x0f, 0x00);
-
-			} else {
-				/* RGB full range (0-255) */
-				io_write_and_or(sd, 0x02, 0x0f, 0x10);
-			}
-		} else {
-			/* receiving HDMI or analog signal, set automode */
+		if (state->mode == ADV7842_MODE_RGB) {
+			/* Receiving analog RGB signal
+			 * Set RGB full range (0-255) */
+			io_write_and_or(sd, 0x02, 0x0f, 0x10);
+			break;
+		}
+
+		if (state->mode == ADV7842_MODE_COMP) {
+			/* Receiving analog YPbPr signal
+			 * Set automode */
 			io_write_and_or(sd, 0x02, 0x0f, 0xf0);
+			break;
+		}
+
+		if (hdmi_read(sd, 0x05) & 0x80) {
+			/* Receiving HDMI signal
+			 * Set automode */
+			io_write_and_or(sd, 0x02, 0x0f, 0xf0);
+			break;
+		}
+
+		/* Receiving DVI-D signal
+		 * ADV7842 selects RGB limited range regardless of
+		 * input format (CE/IT) in automatic mode */
+		if (state->timings.bt.standards & V4L2_DV_BT_STD_CEA861) {
+			/* RGB limited range (16-235) */
+			io_write_and_or(sd, 0x02, 0x0f, 0x00);
+		} else {
+			/* RGB full range (0-255) */
+			io_write_and_or(sd, 0x02, 0x0f, 0x10);
 		}
 		break;
 	case V4L2_DV_RGB_RANGE_LIMITED:
@@ -1309,7 +1325,7 @@ static int adv7842_dv_timings_cap(struct v4l2_subdev *sd,
 }
 
 /* Fill the optional fields .standards and .flags in struct v4l2_dv_timings
-   if the format is listed in adv7604_timings[] */
+   if the format is listed in adv7842_timings[] */
 static void adv7842_fill_optional_dv_timings_fields(struct v4l2_subdev *sd,
 		struct v4l2_dv_timings *timings)
 {
@@ -2129,7 +2145,7 @@ static int adv7842_cp_log_status(struct v4l2_subdev *sd)
 	static const char * const input_color_space_txt[16] = {
 		"RGB limited range (16-235)", "RGB full range (0-255)",
 		"YCbCr Bt.601 (16-235)", "YCbCr Bt.709 (16-235)",
-		"XvYCC Bt.601", "XvYCC Bt.709",
+		"xvYCC Bt.601", "xvYCC Bt.709",
 		"YCbCr Bt.601 (0-255)", "YCbCr Bt.709 (0-255)",
 		"invalid", "invalid", "invalid", "invalid", "invalid",
 		"invalid", "invalid", "automatic"
-- 
1.8.4.rc3

