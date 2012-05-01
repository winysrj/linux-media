Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2102 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab2EAJGB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2012 05:06:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/7] tvp7002: add support for the new dv timings API.
Date: Tue,  1 May 2012 11:05:50 +0200
Message-Id: <b419fb4621a18067eb435771451646e6182c6d6b.1335862609.git.hans.verkuil@cisco.com>
In-Reply-To: <1335863152-15791-1-git-send-email-hverkuil@xs4all.nl>
References: <1335863152-15791-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <de77f3452a3710c48282ebe24937731b252a1ef7.1335862609.git.hans.verkuil@cisco.com>
References: <de77f3452a3710c48282ebe24937731b252a1ef7.1335862609.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/tvp7002.c |  102 +++++++++++++++++++++++++++++++++++------
 1 file changed, 89 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/tvp7002.c b/drivers/media/video/tvp7002.c
index d7676d8..607fd05 100644
--- a/drivers/media/video/tvp7002.c
+++ b/drivers/media/video/tvp7002.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/module.h>
+#include <linux/v4l2-dv-timings.h>
 #include <media/tvp7002.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
@@ -328,6 +329,7 @@ static const struct i2c_reg_value tvp7002_parms_720P50[] = {
 /* Preset definition for handling device operation */
 struct tvp7002_preset_definition {
 	u32 preset;
+	struct v4l2_dv_timings timings;
 	const struct i2c_reg_value *p_settings;
 	enum v4l2_colorspace color_space;
 	enum v4l2_field scanmode;
@@ -341,6 +343,7 @@ struct tvp7002_preset_definition {
 static const struct tvp7002_preset_definition tvp7002_presets[] = {
 	{
 		V4L2_DV_720P60,
+		V4L2_DV_BT_CEA_1280X720P60,
 		tvp7002_parms_720P60,
 		V4L2_COLORSPACE_REC709,
 		V4L2_FIELD_NONE,
@@ -351,6 +354,7 @@ static const struct tvp7002_preset_definition tvp7002_presets[] = {
 	},
 	{
 		V4L2_DV_1080I60,
+		V4L2_DV_BT_CEA_1920X1080I60,
 		tvp7002_parms_1080I60,
 		V4L2_COLORSPACE_REC709,
 		V4L2_FIELD_INTERLACED,
@@ -361,6 +365,7 @@ static const struct tvp7002_preset_definition tvp7002_presets[] = {
 	},
 	{
 		V4L2_DV_1080I50,
+		V4L2_DV_BT_CEA_1920X1080I50,
 		tvp7002_parms_1080I50,
 		V4L2_COLORSPACE_REC709,
 		V4L2_FIELD_INTERLACED,
@@ -371,6 +376,7 @@ static const struct tvp7002_preset_definition tvp7002_presets[] = {
 	},
 	{
 		V4L2_DV_720P50,
+		V4L2_DV_BT_CEA_1280X720P50,
 		tvp7002_parms_720P50,
 		V4L2_COLORSPACE_REC709,
 		V4L2_FIELD_NONE,
@@ -381,6 +387,7 @@ static const struct tvp7002_preset_definition tvp7002_presets[] = {
 	},
 	{
 		V4L2_DV_1080P60,
+		V4L2_DV_BT_CEA_1920X1080P60,
 		tvp7002_parms_1080P60,
 		V4L2_COLORSPACE_REC709,
 		V4L2_FIELD_NONE,
@@ -391,6 +398,7 @@ static const struct tvp7002_preset_definition tvp7002_presets[] = {
 	},
 	{
 		V4L2_DV_480P59_94,
+		V4L2_DV_BT_CEA_720X480P59_94,
 		tvp7002_parms_480P,
 		V4L2_COLORSPACE_SMPTE170M,
 		V4L2_FIELD_NONE,
@@ -401,6 +409,7 @@ static const struct tvp7002_preset_definition tvp7002_presets[] = {
 	},
 	{
 		V4L2_DV_576P50,
+		V4L2_DV_BT_CEA_720X576P50,
 		tvp7002_parms_576P,
 		V4L2_COLORSPACE_SMPTE170M,
 		V4L2_FIELD_NONE,
@@ -605,6 +614,35 @@ static int tvp7002_s_dv_preset(struct v4l2_subdev *sd,
 	return -EINVAL;
 }
 
+static int tvp7002_s_dv_timings(struct v4l2_subdev *sd,
+					struct v4l2_dv_timings *dv_timings)
+{
+	struct tvp7002 *device = to_tvp7002(sd);
+	const struct v4l2_bt_timings *bt = &dv_timings->bt;
+	int i;
+
+	if (dv_timings->type != V4L2_DV_BT_656_1120)
+		return -EINVAL;
+	for (i = 0; i < NUM_PRESETS; i++) {
+		const struct v4l2_bt_timings *t = &tvp7002_presets[i].timings.bt;
+
+		if (!memcmp(bt, t, &bt->standards - &bt->width)) {
+			device->current_preset = &tvp7002_presets[i];
+			return tvp7002_write_inittab(sd, tvp7002_presets[i].p_settings);
+		}
+	}
+	return -EINVAL;
+}
+
+static int tvp7002_g_dv_timings(struct v4l2_subdev *sd,
+					struct v4l2_dv_timings *dv_timings)
+{
+	struct tvp7002 *device = to_tvp7002(sd);
+
+	*dv_timings = device->current_preset->timings;
+	return 0;
+}
+
 /*
  * tvp7002_s_ctrl() - Set a control
  * @ctrl: ptr to v4l2_ctrl struct
@@ -666,8 +704,7 @@ static int tvp7002_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *f
  * Returns the current DV preset by TVP7002. If no active input is
  * detected, returns -EINVAL
  */
-static int tvp7002_query_dv_preset(struct v4l2_subdev *sd,
-						struct v4l2_dv_preset *qpreset)
+static int tvp7002_query_dv(struct v4l2_subdev *sd, int *index)
 {
 	const struct tvp7002_preset_definition *presets = tvp7002_presets;
 	struct tvp7002 *device;
@@ -679,10 +716,9 @@ static int tvp7002_query_dv_preset(struct v4l2_subdev *sd,
 	u8 lpf_msb;
 	u8 cpl_lsb;
 	u8 cpl_msb;
-	int index;
 
-	/* Return invalid preset if no active input is detected */
-	qpreset->preset = V4L2_DV_INVALID;
+	/* Return invalid index if no active input is detected */
+	*index = NUM_PRESETS;
 
 	device = to_tvp7002(sd);
 
@@ -705,8 +741,8 @@ static int tvp7002_query_dv_preset(struct v4l2_subdev *sd,
 	progressive = (lpf_msb & TVP7002_INPR_MASK) >> TVP7002_IP_SHIFT;
 
 	/* Do checking of video modes */
-	for (index = 0; index < NUM_PRESETS; index++, presets++)
-		if (lpfr  == presets->lines_per_frame &&
+	for (*index = 0; *index < NUM_PRESETS; (*index)++, presets++)
+		if (lpfr == presets->lines_per_frame &&
 			progressive == presets->progressive) {
 			if (presets->cpl_min == 0xffff)
 				break;
@@ -714,17 +750,42 @@ static int tvp7002_query_dv_preset(struct v4l2_subdev *sd,
 				break;
 		}
 
-	if (index == NUM_PRESETS) {
+	if (*index == NUM_PRESETS) {
 		v4l2_dbg(1, debug, sd, "detection failed: lpf = %x, cpl = %x\n",
 								lpfr, cpln);
-		return 0;
+		return -ENOLINK;
 	}
 
-	/* Set values in found preset */
-	qpreset->preset = presets->preset;
-
 	/* Update lines per frame and clocks per line info */
-	v4l2_dbg(1, debug, sd, "detected preset: %d\n", presets->preset);
+	v4l2_dbg(1, debug, sd, "detected preset: %d\n", *index);
+	return 0;
+}
+
+static int tvp7002_query_dv_preset(struct v4l2_subdev *sd,
+					struct v4l2_dv_preset *qpreset)
+{
+	int index;
+	int err = tvp7002_query_dv(sd, &index);
+
+	if (err || index == NUM_PRESETS) {
+		qpreset->preset = V4L2_DV_INVALID;
+		if (err == -ENOLINK)
+			err = 0;
+		return err;
+	}
+	qpreset->preset = tvp7002_presets[index].preset;
+	return 0;
+}
+
+static int tvp7002_query_dv_timings(struct v4l2_subdev *sd,
+					struct v4l2_dv_timings *timings)
+{
+	int index;
+	int err = tvp7002_query_dv(sd, &index);
+
+	if (err)
+		return err;
+	*timings = tvp7002_presets[index].timings;
 	return 0;
 }
 
@@ -894,6 +955,17 @@ static int tvp7002_enum_dv_presets(struct v4l2_subdev *sd,
 	return v4l_fill_dv_preset_info(tvp7002_presets[preset->index].preset, preset);
 }
 
+static int tvp7002_enum_dv_timings(struct v4l2_subdev *sd,
+		struct v4l2_enum_dv_timings *timings)
+{
+	/* Check requested format index is within range */
+	if (timings->index >= NUM_PRESETS)
+		return -EINVAL;
+
+	timings->timings = tvp7002_presets[timings->index].timings;
+	return 0;
+}
+
 static const struct v4l2_ctrl_ops tvp7002_ctrl_ops = {
 	.s_ctrl = tvp7002_s_ctrl,
 };
@@ -920,6 +992,10 @@ static const struct v4l2_subdev_video_ops tvp7002_video_ops = {
 	.enum_dv_presets = tvp7002_enum_dv_presets,
 	.s_dv_preset = tvp7002_s_dv_preset,
 	.query_dv_preset = tvp7002_query_dv_preset,
+	.g_dv_timings = tvp7002_g_dv_timings,
+	.s_dv_timings = tvp7002_s_dv_timings,
+	.enum_dv_timings = tvp7002_enum_dv_timings,
+	.query_dv_timings = tvp7002_query_dv_timings,
 	.s_stream = tvp7002_s_stream,
 	.g_mbus_fmt = tvp7002_mbus_fmt,
 	.try_mbus_fmt = tvp7002_mbus_fmt,
-- 
1.7.10

