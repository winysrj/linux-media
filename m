Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:53318 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916AbbCTRFp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 13:05:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Martin Bugge <marbugge@cisco.com>,
	Mats Randgaard <mats.randgaard@cisco.com>
Subject: [PATCH 4/5] adv: use V4L2_DV_FL_IS_CE_VIDEO instead of V4L2_DV_BT_STD_CEA861.
Date: Fri, 20 Mar 2015 18:05:05 +0100
Message-Id: <1426871106-31914-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1426871106-31914-1-git-send-email-hverkuil@xs4all.nl>
References: <1426871106-31914-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Don't rely on V4L2_DV_BT_STD_CEA861 since that include the
640x480p format, which is an IT format, not CE.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Martin Bugge <marbugge@cisco.com>
Cc: Mats Randgaard <mats.randgaard@cisco.com>
---
 drivers/media/i2c/ad9389b.c | 10 +++++-----
 drivers/media/i2c/adv7511.c | 10 +++++-----
 drivers/media/i2c/adv7604.c |  5 +++--
 drivers/media/i2c/adv7842.c |  5 +++--
 4 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index fada175..69094ab 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -239,8 +239,8 @@ static void ad9389b_set_IT_content_AVI_InfoFrame(struct v4l2_subdev *sd)
 {
 	struct ad9389b_state *state = get_ad9389b_state(sd);
 
-	if (state->dv_timings.bt.standards & V4L2_DV_BT_STD_CEA861) {
-		/* CEA format, not IT  */
+	if (state->dv_timings.bt.flags & V4L2_DV_FL_IS_CE_VIDEO) {
+		/* CE format, not IT  */
 		ad9389b_wr_and_or(sd, 0xcd, 0xbf, 0x00);
 	} else {
 		/* IT format */
@@ -255,11 +255,11 @@ static int ad9389b_set_rgb_quantization_mode(struct v4l2_subdev *sd, struct v4l2
 	switch (ctrl->val) {
 	case V4L2_DV_RGB_RANGE_AUTO:
 		/* automatic */
-		if (state->dv_timings.bt.standards & V4L2_DV_BT_STD_CEA861) {
-			/* cea format, RGB limited range (16-235) */
+		if (state->dv_timings.bt.flags & V4L2_DV_FL_IS_CE_VIDEO) {
+			/* CE format, RGB limited range (16-235) */
 			ad9389b_csc_rgb_full2limit(sd, true);
 		} else {
-			/* not cea format, RGB full range (0-255) */
+			/* not CE format, RGB full range (0-255) */
 			ad9389b_csc_rgb_full2limit(sd, false);
 		}
 		break;
diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 81736aa..0ad0f6a 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -312,8 +312,8 @@ static void adv7511_csc_rgb_full2limit(struct v4l2_subdev *sd, bool enable)
 static void adv7511_set_IT_content_AVI_InfoFrame(struct v4l2_subdev *sd)
 {
 	struct adv7511_state *state = get_adv7511_state(sd);
-	if (state->dv_timings.bt.standards & V4L2_DV_BT_STD_CEA861) {
-		/* CEA format, not IT  */
+	if (state->dv_timings.bt.flags & V4L2_DV_FL_IS_CE_VIDEO) {
+		/* CE format, not IT  */
 		adv7511_wr_and_or(sd, 0x57, 0x7f, 0x00);
 	} else {
 		/* IT format */
@@ -331,11 +331,11 @@ static int adv7511_set_rgb_quantization_mode(struct v4l2_subdev *sd, struct v4l2
 		/* automatic */
 		struct adv7511_state *state = get_adv7511_state(sd);
 
-		if (state->dv_timings.bt.standards & V4L2_DV_BT_STD_CEA861) {
-			/* cea format, RGB limited range (16-235) */
+		if (state->dv_timings.bt.flags & V4L2_DV_FL_IS_CE_VIDEO) {
+			/* CE format, RGB limited range (16-235) */
 			adv7511_csc_rgb_full2limit(sd, true);
 		} else {
-			/* not cea format, RGB full range (0-255) */
+			/* not CE format, RGB full range (0-255) */
 			adv7511_csc_rgb_full2limit(sd, false);
 		}
 	}
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index aaab9c9..c3f4a58 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1075,7 +1075,7 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 		/* Receiving DVI-D signal
 		 * ADV7604 selects RGB limited range regardless of
 		 * input format (CE/IT) in automatic mode */
-		if (state->timings.bt.standards & V4L2_DV_BT_STD_CEA861) {
+		if (state->timings.bt.flags & V4L2_DV_FL_IS_CE_VIDEO) {
 			/* RGB limited range (16-235) */
 			io_write_clr_set(sd, 0x02, 0xf0, 0x00);
 		} else {
@@ -1755,8 +1755,9 @@ static void adv76xx_fill_format(struct adv76xx_state *state,
 	format->width = state->timings.bt.width;
 	format->height = state->timings.bt.height;
 	format->field = V4L2_FIELD_NONE;
+	format->colorspace = V4L2_COLORSPACE_SRGB;
 
-	if (state->timings.bt.standards & V4L2_DV_BT_STD_CEA861)
+	if (state->timings.bt.flags & V4L2_DV_FL_IS_CE_VIDEO)
 		format->colorspace = (state->timings.bt.height <= 576) ?
 			V4L2_COLORSPACE_SMPTE170M : V4L2_COLORSPACE_REC709;
 }
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 7c215ee..b5a37fe 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1119,7 +1119,7 @@ static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 		/* Receiving DVI-D signal
 		 * ADV7842 selects RGB limited range regardless of
 		 * input format (CE/IT) in automatic mode */
-		if (state->timings.bt.standards & V4L2_DV_BT_STD_CEA861) {
+		if (state->timings.bt.flags & V4L2_DV_FL_IS_CE_VIDEO) {
 			/* RGB limited range (16-235) */
 			io_write_and_or(sd, 0x02, 0x0f, 0x00);
 		} else {
@@ -1901,7 +1901,8 @@ static int adv7842_g_mbus_fmt(struct v4l2_subdev *sd,
 		return 0;
 	}
 
-	if (state->timings.bt.standards & V4L2_DV_BT_STD_CEA861) {
+	fmt->colorspace = V4L2_COLORSPACE_SRGB;
+	if (state->timings.bt.flags & V4L2_DV_FL_IS_CE_VIDEO) {
 		fmt->colorspace = (state->timings.bt.height <= 576) ?
 			V4L2_COLORSPACE_SMPTE170M : V4L2_COLORSPACE_REC709;
 	}
-- 
2.1.4

