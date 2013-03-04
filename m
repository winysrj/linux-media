Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3574 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab3CDJFn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 04:05:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sekhar Nori <nsekhar@ti.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	linux@arm.linux.org.uk, Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 03/11] tvp7002: remove dv_preset support.
Date: Mon,  4 Mar 2013 10:04:57 +0100
Message-Id: <6d12aca80e48a751711d24d6a6bfbc52ccfcf67b.1362387265.git.hans.verkuil@cisco.com>
In-Reply-To: <1362387905-3666-1-git-send-email-hverkuil@xs4all.nl>
References: <1362387905-3666-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <b14bb5bd725678bc0fadfa241b462b5d6487f099.1362387265.git.hans.verkuil@cisco.com>
References: <b14bb5bd725678bc0fadfa241b462b5d6487f099.1362387265.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Finally remove the dv_preset support from this driver. Note that dv_preset
support was already removed from any bridge drivers that use this i2c
driver, so the dv_preset ops were no longer called and can be removed
safely.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/i2c/tvp7002.c |   70 -------------------------------------------
 1 file changed, 70 deletions(-)

diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index d7a08bc..7406de9 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -328,7 +328,6 @@ static const struct i2c_reg_value tvp7002_parms_720P50[] = {
 
 /* Timings definition for handling device operation */
 struct tvp7002_timings_definition {
-	u32 preset;
 	struct v4l2_dv_timings timings;
 	const struct i2c_reg_value *p_settings;
 	enum v4l2_colorspace color_space;
@@ -342,7 +341,6 @@ struct tvp7002_timings_definition {
 /* Struct list for digital video timings */
 static const struct tvp7002_timings_definition tvp7002_timings[] = {
 	{
-		V4L2_DV_720P60,
 		V4L2_DV_BT_CEA_1280X720P60,
 		tvp7002_parms_720P60,
 		V4L2_COLORSPACE_REC709,
@@ -353,7 +351,6 @@ static const struct tvp7002_timings_definition tvp7002_timings[] = {
 		153
 	},
 	{
-		V4L2_DV_1080I60,
 		V4L2_DV_BT_CEA_1920X1080I60,
 		tvp7002_parms_1080I60,
 		V4L2_COLORSPACE_REC709,
@@ -364,7 +361,6 @@ static const struct tvp7002_timings_definition tvp7002_timings[] = {
 		205
 	},
 	{
-		V4L2_DV_1080I50,
 		V4L2_DV_BT_CEA_1920X1080I50,
 		tvp7002_parms_1080I50,
 		V4L2_COLORSPACE_REC709,
@@ -375,7 +371,6 @@ static const struct tvp7002_timings_definition tvp7002_timings[] = {
 		245
 	},
 	{
-		V4L2_DV_720P50,
 		V4L2_DV_BT_CEA_1280X720P50,
 		tvp7002_parms_720P50,
 		V4L2_COLORSPACE_REC709,
@@ -386,7 +381,6 @@ static const struct tvp7002_timings_definition tvp7002_timings[] = {
 		183
 	},
 	{
-		V4L2_DV_1080P60,
 		V4L2_DV_BT_CEA_1920X1080P60,
 		tvp7002_parms_1080P60,
 		V4L2_COLORSPACE_REC709,
@@ -397,7 +391,6 @@ static const struct tvp7002_timings_definition tvp7002_timings[] = {
 		102
 	},
 	{
-		V4L2_DV_480P59_94,
 		V4L2_DV_BT_CEA_720X480P59_94,
 		tvp7002_parms_480P,
 		V4L2_COLORSPACE_SMPTE170M,
@@ -408,7 +401,6 @@ static const struct tvp7002_timings_definition tvp7002_timings[] = {
 		0xffff
 	},
 	{
-		V4L2_DV_576P50,
 		V4L2_DV_BT_CEA_720X576P50,
 		tvp7002_parms_576P,
 		V4L2_COLORSPACE_SMPTE170M,
@@ -588,32 +580,6 @@ static int tvp7002_write_inittab(struct v4l2_subdev *sd,
 	return error;
 }
 
-/*
- * tvp7002_s_dv_preset() - Set digital video preset
- * @sd: ptr to v4l2_subdev struct
- * @dv_preset: ptr to v4l2_dv_preset struct
- *
- * Set the digital video preset for a TVP7002 decoder device.
- * Returns zero when successful or -EINVAL if register access fails.
- */
-static int tvp7002_s_dv_preset(struct v4l2_subdev *sd,
-					struct v4l2_dv_preset *dv_preset)
-{
-	struct tvp7002 *device = to_tvp7002(sd);
-	u32 preset;
-	int i;
-
-	for (i = 0; i < NUM_TIMINGS; i++) {
-		preset = tvp7002_timings[i].preset;
-		if (preset == dv_preset->preset) {
-			device->current_timings = &tvp7002_timings[i];
-			return tvp7002_write_inittab(sd, tvp7002_timings[i].p_settings);
-		}
-	}
-
-	return -EINVAL;
-}
-
 static int tvp7002_s_dv_timings(struct v4l2_subdev *sd,
 					struct v4l2_dv_timings *dv_timings)
 {
@@ -752,22 +718,6 @@ static int tvp7002_query_dv(struct v4l2_subdev *sd, int *index)
 	return 0;
 }
 
-static int tvp7002_query_dv_preset(struct v4l2_subdev *sd,
-					struct v4l2_dv_preset *qpreset)
-{
-	int index;
-	int err = tvp7002_query_dv(sd, &index);
-
-	if (err || index == NUM_TIMINGS) {
-		qpreset->preset = V4L2_DV_INVALID;
-		if (err == -ENOLINK)
-			err = 0;
-		return err;
-	}
-	qpreset->preset = tvp7002_timings[index].preset;
-	return 0;
-}
-
 static int tvp7002_query_dv_timings(struct v4l2_subdev *sd,
 					struct v4l2_dv_timings *timings)
 {
@@ -915,23 +865,6 @@ static int tvp7002_log_status(struct v4l2_subdev *sd)
 	return 0;
 }
 
-/*
- * tvp7002_enum_dv_presets() - Enum supported digital video formats
- * @sd: pointer to standard V4L2 sub-device structure
- * @preset: pointer to format struct
- *
- * Enumerate supported digital video formats.
- */
-static int tvp7002_enum_dv_presets(struct v4l2_subdev *sd,
-		struct v4l2_dv_enum_preset *preset)
-{
-	/* Check requested format index is within range */
-	if (preset->index >= NUM_TIMINGS)
-		return -EINVAL;
-
-	return v4l_fill_dv_preset_info(tvp7002_timings[preset->index].preset, preset);
-}
-
 static int tvp7002_enum_dv_timings(struct v4l2_subdev *sd,
 		struct v4l2_enum_dv_timings *timings)
 {
@@ -966,9 +899,6 @@ static const struct v4l2_subdev_core_ops tvp7002_core_ops = {
 
 /* Specific video subsystem operation handlers */
 static const struct v4l2_subdev_video_ops tvp7002_video_ops = {
-	.enum_dv_presets = tvp7002_enum_dv_presets,
-	.s_dv_preset = tvp7002_s_dv_preset,
-	.query_dv_preset = tvp7002_query_dv_preset,
 	.g_dv_timings = tvp7002_g_dv_timings,
 	.s_dv_timings = tvp7002_s_dv_timings,
 	.enum_dv_timings = tvp7002_enum_dv_timings,
-- 
1.7.10.4

