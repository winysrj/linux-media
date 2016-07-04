Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:40715 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932386AbcGDNfE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 09:35:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/7] adv7511: fix quantization range handling
Date: Mon,  4 Jul 2016 15:34:47 +0200
Message-Id: <1467639292-1066-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467639292-1066-1-git-send-email-hverkuil@xs4all.nl>
References: <1467639292-1066-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Commit 1fb69bfd29e4b2e5e93922105326dd6cbd5ef6eb (adv7511: improve
colorspace handling) introduced a number of bugs, specifically with
regards to YCbCr output and quantization range handling:

- if the output is not RGB, then disable the full-to-limited range
  CSC matrix since that is meant for RGB formats. YCbCr formats are
  always limited range, so there is nothing to convert. (OK, full
  range YCbCr is possible, but we don't support that right now).

- the mediabus code that was passed to adv7511_set_fmt was always cleared
  by the memset in adv7511_fill_format. This made it effectively impossible
  to select YCbCr output.

- adv7511_set_fmt never updated the rgb quantization range.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7511.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 1695da0..161cbdb 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -343,16 +343,20 @@ static void adv7511_csc_rgb_full2limit(struct v4l2_subdev *sd, bool enable)
 	}
 }
 
-static int adv7511_set_rgb_quantization_mode(struct v4l2_subdev *sd, struct v4l2_ctrl *ctrl)
+static void adv7511_set_rgb_quantization_mode(struct v4l2_subdev *sd, struct v4l2_ctrl *ctrl)
 {
+	struct adv7511_state *state = get_adv7511_state(sd);
+
+	/* Only makes sense for RGB formats */
+	if (state->fmt_code != MEDIA_BUS_FMT_RGB888_1X24) {
+		/* so just keep quantization */
+		adv7511_csc_rgb_full2limit(sd, false);
+		return;
+	}
+
 	switch (ctrl->val) {
-	default:
-		return -EINVAL;
-		break;
-	case V4L2_DV_RGB_RANGE_AUTO: {
+	case V4L2_DV_RGB_RANGE_AUTO:
 		/* automatic */
-		struct adv7511_state *state = get_adv7511_state(sd);
-
 		if (state->dv_timings.bt.flags & V4L2_DV_FL_IS_CE_VIDEO) {
 			/* CE format, RGB limited range (16-235) */
 			adv7511_csc_rgb_full2limit(sd, true);
@@ -360,7 +364,6 @@ static int adv7511_set_rgb_quantization_mode(struct v4l2_subdev *sd, struct v4l2
 			/* not CE format, RGB full range (0-255) */
 			adv7511_csc_rgb_full2limit(sd, false);
 		}
-	}
 		break;
 	case V4L2_DV_RGB_RANGE_LIMITED:
 		/* RGB limited range (16-235) */
@@ -371,7 +374,6 @@ static int adv7511_set_rgb_quantization_mode(struct v4l2_subdev *sd, struct v4l2
 		adv7511_csc_rgb_full2limit(sd, false);
 		break;
 	}
-	return 0;
 }
 
 /* ------------------------------ CTRL OPS ------------------------------ */
@@ -388,8 +390,10 @@ static int adv7511_s_ctrl(struct v4l2_ctrl *ctrl)
 		adv7511_wr_and_or(sd, 0xaf, 0xfd, ctrl->val == V4L2_DV_TX_MODE_HDMI ? 0x02 : 0x00);
 		return 0;
 	}
-	if (state->rgb_quantization_range_ctrl == ctrl)
-		return adv7511_set_rgb_quantization_mode(sd, ctrl);
+	if (state->rgb_quantization_range_ctrl == ctrl) {
+		adv7511_set_rgb_quantization_mode(sd, ctrl);
+		return 0;
+	}
 	if (state->content_type_ctrl == ctrl) {
 		u8 itc, cn;
 
@@ -941,8 +945,6 @@ static int adv7511_enum_mbus_code(struct v4l2_subdev *sd,
 static void adv7511_fill_format(struct adv7511_state *state,
 				struct v4l2_mbus_framefmt *format)
 {
-	memset(format, 0, sizeof(*format));
-
 	format->width = state->dv_timings.bt.width;
 	format->height = state->dv_timings.bt.height;
 	format->field = V4L2_FIELD_NONE;
@@ -957,6 +959,7 @@ static int adv7511_get_fmt(struct v4l2_subdev *sd,
 	if (format->pad != 0)
 		return -EINVAL;
 
+	memset(&format->format, 0, sizeof(format->format));
 	adv7511_fill_format(state, &format->format);
 
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
@@ -1117,6 +1120,7 @@ static int adv7511_set_fmt(struct v4l2_subdev *sd,
 	adv7511_wr_and_or(sd, 0x57, 0x83, (ec << 4) | (q << 2) | (itc << 7));
 	adv7511_wr_and_or(sd, 0x59, 0x0f, (yq << 6) | (cn << 4));
 	adv7511_wr_and_or(sd, 0x4a, 0xff, 1);
+	adv7511_set_rgb_quantization_mode(sd, state->rgb_quantization_range_ctrl);
 
 	return 0;
 }
-- 
2.8.1

