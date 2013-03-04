Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2819 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab3CDJFh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 04:05:37 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sekhar Nori <nsekhar@ti.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	linux@arm.linux.org.uk, Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 01/11] tvp7002: replace 'preset' by 'timings' in various structs/variables.
Date: Mon,  4 Mar 2013 10:04:55 +0100
Message-Id: <b14bb5bd725678bc0fadfa241b462b5d6487f099.1362387265.git.hans.verkuil@cisco.com>
In-Reply-To: <1362387905-3666-1-git-send-email-hverkuil@xs4all.nl>
References: <1362387905-3666-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is the first step towards removing the deprecated preset support of this
driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/i2c/tvp7002.c |   90 +++++++++++++++++++++----------------------
 1 file changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index 537f6b4..7995eeb 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -326,8 +326,8 @@ static const struct i2c_reg_value tvp7002_parms_720P50[] = {
 	{ TVP7002_EOR, 0xff, TVP7002_RESERVED }
 };
 
-/* Preset definition for handling device operation */
-struct tvp7002_preset_definition {
+/* Timings definition for handling device operation */
+struct tvp7002_timings_definition {
 	u32 preset;
 	struct v4l2_dv_timings timings;
 	const struct i2c_reg_value *p_settings;
@@ -339,8 +339,8 @@ struct tvp7002_preset_definition {
 	u16 cpl_max;
 };
 
-/* Struct list for digital video presets */
-static const struct tvp7002_preset_definition tvp7002_presets[] = {
+/* Struct list for digital video timings */
+static const struct tvp7002_timings_definition tvp7002_timings[] = {
 	{
 		V4L2_DV_720P60,
 		V4L2_DV_BT_CEA_1280X720P60,
@@ -420,7 +420,7 @@ static const struct tvp7002_preset_definition tvp7002_presets[] = {
 	}
 };
 
-#define NUM_PRESETS	ARRAY_SIZE(tvp7002_presets)
+#define NUM_TIMINGS ARRAY_SIZE(tvp7002_timings)
 
 /* Device definition */
 struct tvp7002 {
@@ -431,7 +431,7 @@ struct tvp7002 {
 	int ver;
 	int streaming;
 
-	const struct tvp7002_preset_definition *current_preset;
+	const struct tvp7002_timings_definition *current_timings;
 };
 
 /*
@@ -603,11 +603,11 @@ static int tvp7002_s_dv_preset(struct v4l2_subdev *sd,
 	u32 preset;
 	int i;
 
-	for (i = 0; i < NUM_PRESETS; i++) {
-		preset = tvp7002_presets[i].preset;
+	for (i = 0; i < NUM_TIMINGS; i++) {
+		preset = tvp7002_timings[i].preset;
 		if (preset == dv_preset->preset) {
-			device->current_preset = &tvp7002_presets[i];
-			return tvp7002_write_inittab(sd, tvp7002_presets[i].p_settings);
+			device->current_timings = &tvp7002_timings[i];
+			return tvp7002_write_inittab(sd, tvp7002_timings[i].p_settings);
 		}
 	}
 
@@ -623,12 +623,12 @@ static int tvp7002_s_dv_timings(struct v4l2_subdev *sd,
 
 	if (dv_timings->type != V4L2_DV_BT_656_1120)
 		return -EINVAL;
-	for (i = 0; i < NUM_PRESETS; i++) {
-		const struct v4l2_bt_timings *t = &tvp7002_presets[i].timings.bt;
+	for (i = 0; i < NUM_TIMINGS; i++) {
+		const struct v4l2_bt_timings *t = &tvp7002_timings[i].timings.bt;
 
 		if (!memcmp(bt, t, &bt->standards - &bt->width)) {
-			device->current_preset = &tvp7002_presets[i];
-			return tvp7002_write_inittab(sd, tvp7002_presets[i].p_settings);
+			device->current_timings = &tvp7002_timings[i];
+			return tvp7002_write_inittab(sd, tvp7002_timings[i].p_settings);
 		}
 	}
 	return -EINVAL;
@@ -639,7 +639,7 @@ static int tvp7002_g_dv_timings(struct v4l2_subdev *sd,
 {
 	struct tvp7002 *device = to_tvp7002(sd);
 
-	*dv_timings = device->current_preset->timings;
+	*dv_timings = device->current_timings->timings;
 	return 0;
 }
 
@@ -681,15 +681,15 @@ static int tvp7002_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *f
 	int error;
 
 	/* Calculate height and width based on current standard */
-	error = v4l_fill_dv_preset_info(device->current_preset->preset, &e_preset);
+	error = v4l_fill_dv_preset_info(device->current_timings->preset, &e_preset);
 	if (error)
 		return error;
 
 	f->width = e_preset.width;
 	f->height = e_preset.height;
 	f->code = V4L2_MBUS_FMT_YUYV10_1X20;
-	f->field = device->current_preset->scanmode;
-	f->colorspace = device->current_preset->color_space;
+	f->field = device->current_timings->scanmode;
+	f->colorspace = device->current_timings->color_space;
 
 	v4l2_dbg(1, debug, sd, "MBUS_FMT: Width - %d, Height - %d",
 			f->width, f->height);
@@ -697,16 +697,16 @@ static int tvp7002_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *f
 }
 
 /*
- * tvp7002_query_dv_preset() - query DV preset
+ * tvp7002_query_dv() - query DV timings
  * @sd: pointer to standard V4L2 sub-device structure
- * @qpreset: standard V4L2 v4l2_dv_preset structure
+ * @index: index into the tvp7002_timings array
  *
- * Returns the current DV preset by TVP7002. If no active input is
+ * Returns the current DV timings detected by TVP7002. If no active input is
  * detected, returns -EINVAL
  */
 static int tvp7002_query_dv(struct v4l2_subdev *sd, int *index)
 {
-	const struct tvp7002_preset_definition *presets = tvp7002_presets;
+	const struct tvp7002_timings_definition *timings = tvp7002_timings;
 	u8 progressive;
 	u32 lpfr;
 	u32 cpln;
@@ -717,7 +717,7 @@ static int tvp7002_query_dv(struct v4l2_subdev *sd, int *index)
 	u8 cpl_msb;
 
 	/* Return invalid index if no active input is detected */
-	*index = NUM_PRESETS;
+	*index = NUM_TIMINGS;
 
 	/* Read standards from device registers */
 	tvp7002_read_err(sd, TVP7002_L_FRAME_STAT_LSBS, &lpf_lsb, &error);
@@ -738,23 +738,23 @@ static int tvp7002_query_dv(struct v4l2_subdev *sd, int *index)
 	progressive = (lpf_msb & TVP7002_INPR_MASK) >> TVP7002_IP_SHIFT;
 
 	/* Do checking of video modes */
-	for (*index = 0; *index < NUM_PRESETS; (*index)++, presets++)
-		if (lpfr == presets->lines_per_frame &&
-			progressive == presets->progressive) {
-			if (presets->cpl_min == 0xffff)
+	for (*index = 0; *index < NUM_TIMINGS; (*index)++, timings++)
+		if (lpfr == timings->lines_per_frame &&
+			progressive == timings->progressive) {
+			if (timings->cpl_min == 0xffff)
 				break;
-			if (cpln >= presets->cpl_min && cpln <= presets->cpl_max)
+			if (cpln >= timings->cpl_min && cpln <= timings->cpl_max)
 				break;
 		}
 
-	if (*index == NUM_PRESETS) {
+	if (*index == NUM_TIMINGS) {
 		v4l2_dbg(1, debug, sd, "detection failed: lpf = %x, cpl = %x\n",
 								lpfr, cpln);
 		return -ENOLINK;
 	}
 
 	/* Update lines per frame and clocks per line info */
-	v4l2_dbg(1, debug, sd, "detected preset: %d\n", *index);
+	v4l2_dbg(1, debug, sd, "detected timings: %d\n", *index);
 	return 0;
 }
 
@@ -764,13 +764,13 @@ static int tvp7002_query_dv_preset(struct v4l2_subdev *sd,
 	int index;
 	int err = tvp7002_query_dv(sd, &index);
 
-	if (err || index == NUM_PRESETS) {
+	if (err || index == NUM_TIMINGS) {
 		qpreset->preset = V4L2_DV_INVALID;
 		if (err == -ENOLINK)
 			err = 0;
 		return err;
 	}
-	qpreset->preset = tvp7002_presets[index].preset;
+	qpreset->preset = tvp7002_timings[index].preset;
 	return 0;
 }
 
@@ -782,7 +782,7 @@ static int tvp7002_query_dv_timings(struct v4l2_subdev *sd,
 
 	if (err)
 		return err;
-	*timings = tvp7002_presets[index].timings;
+	*timings = tvp7002_timings[index].timings;
 	return 0;
 }
 
@@ -896,7 +896,7 @@ static int tvp7002_s_stream(struct v4l2_subdev *sd, int enable)
  */
 static int tvp7002_log_status(struct v4l2_subdev *sd)
 {
-	const struct tvp7002_preset_definition *presets = tvp7002_presets;
+	const struct tvp7002_timings_definition *timings = tvp7002_timings;
 	struct tvp7002 *device = to_tvp7002(sd);
 	struct v4l2_dv_enum_preset e_preset;
 	struct v4l2_dv_preset detected;
@@ -907,20 +907,20 @@ static int tvp7002_log_status(struct v4l2_subdev *sd)
 	tvp7002_query_dv_preset(sd, &detected);
 
 	/* Print standard related code values */
-	for (i = 0; i < NUM_PRESETS; i++, presets++)
-		if (presets->preset == detected.preset)
+	for (i = 0; i < NUM_TIMINGS; i++, timings++)
+		if (timings->preset == detected.preset)
 			break;
 
-	if (v4l_fill_dv_preset_info(device->current_preset->preset, &e_preset))
+	if (v4l_fill_dv_preset_info(device->current_timings->preset, &e_preset))
 		return -EINVAL;
 
 	v4l2_info(sd, "Selected DV Preset: %s\n", e_preset.name);
 	v4l2_info(sd, "   Pixels per line: %u\n", e_preset.width);
 	v4l2_info(sd, "   Lines per frame: %u\n\n", e_preset.height);
-	if (i == NUM_PRESETS) {
+	if (i == NUM_TIMINGS) {
 		v4l2_info(sd, "Detected DV Preset: None\n");
 	} else {
-		if (v4l_fill_dv_preset_info(presets->preset, &e_preset))
+		if (v4l_fill_dv_preset_info(timings->preset, &e_preset))
 			return -EINVAL;
 		v4l2_info(sd, "Detected DV Preset: %s\n", e_preset.name);
 		v4l2_info(sd, "  Pixels per line: %u\n", e_preset.width);
@@ -946,20 +946,20 @@ static int tvp7002_enum_dv_presets(struct v4l2_subdev *sd,
 		struct v4l2_dv_enum_preset *preset)
 {
 	/* Check requested format index is within range */
-	if (preset->index >= NUM_PRESETS)
+	if (preset->index >= NUM_TIMINGS)
 		return -EINVAL;
 
-	return v4l_fill_dv_preset_info(tvp7002_presets[preset->index].preset, preset);
+	return v4l_fill_dv_preset_info(tvp7002_timings[preset->index].preset, preset);
 }
 
 static int tvp7002_enum_dv_timings(struct v4l2_subdev *sd,
 		struct v4l2_enum_dv_timings *timings)
 {
 	/* Check requested format index is within range */
-	if (timings->index >= NUM_PRESETS)
+	if (timings->index >= NUM_TIMINGS)
 		return -EINVAL;
 
-	timings->timings = tvp7002_presets[timings->index].timings;
+	timings->timings = tvp7002_timings[timings->index].timings;
 	return 0;
 }
 
@@ -1043,7 +1043,7 @@ static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id *id)
 
 	sd = &device->sd;
 	device->pdata = c->dev.platform_data;
-	device->current_preset = tvp7002_presets;
+	device->current_timings = tvp7002_timings;
 
 	/* Tell v4l2 the device is ready */
 	v4l2_i2c_subdev_init(sd, c, &tvp7002_ops);
@@ -1080,7 +1080,7 @@ static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id *id)
 		return error;
 
 	/* Set registers according to default video mode */
-	preset.preset = device->current_preset->preset;
+	preset.preset = device->current_timings->preset;
 	error = tvp7002_s_dv_preset(sd, &preset);
 
 	v4l2_ctrl_handler_init(&device->hdl, 1);
-- 
1.7.10.4

