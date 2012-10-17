Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1350 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441Ab2JQJSk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 05:18:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <mats.randgaard@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>
Subject: [RFC PATCH for v3.7 3/4] adv7604: use presets where possible.
Date: Wed, 17 Oct 2012 11:18:32 +0200
Message-Id: <13e374dd0af5d41485987379d1414e14919eeeed.1350465202.git.hans.verkuil@cisco.com>
In-Reply-To: <1350465513-7304-1-git-send-email-hverkuil@xs4all.nl>
References: <1350465513-7304-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c970cc0b7e589a05fbf258792412e5564f648f79.1350465202.git.hans.verkuil@cisco.com>
References: <c970cc0b7e589a05fbf258792412e5564f648f79.1350465202.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Use predefined video timings (prim_mode/vid_std) when available as recommended
by Analog Devices (http://ez.analog.com/message/48267#48267).

Also remove 720p30 support since the ADV7604 can't handle that.
(http://ez.analog.com/message/61488#61488)

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c |  275 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 219 insertions(+), 56 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 74a18c0..88b7984 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -105,7 +105,6 @@ static const struct v4l2_dv_timings adv7604_timings[] = {
 	V4L2_DV_BT_CEA_720X576P50,
 	V4L2_DV_BT_CEA_1280X720P24,
 	V4L2_DV_BT_CEA_1280X720P25,
-	V4L2_DV_BT_CEA_1280X720P30,
 	V4L2_DV_BT_CEA_1280X720P50,
 	V4L2_DV_BT_CEA_1280X720P60,
 	V4L2_DV_BT_CEA_1920X1080P24,
@@ -114,6 +113,7 @@ static const struct v4l2_dv_timings adv7604_timings[] = {
 	V4L2_DV_BT_CEA_1920X1080P50,
 	V4L2_DV_BT_CEA_1920X1080P60,
 
+	/* sorted by DMT ID */
 	V4L2_DV_BT_DMT_640X350P85,
 	V4L2_DV_BT_DMT_640X400P85,
 	V4L2_DV_BT_DMT_720X400P85,
@@ -163,6 +163,89 @@ static const struct v4l2_dv_timings adv7604_timings[] = {
 	{ },
 };
 
+struct adv7604_video_standards {
+	struct v4l2_dv_timings timings;
+	u8 vid_std;
+	u8 v_freq;
+};
+
+/* sorted by number of lines */
+static const struct adv7604_video_standards adv7604_prim_mode_comp[] = {
+	/* { V4L2_DV_BT_CEA_720X480P59_94, 0x0a, 0x00 }, TODO flickering */
+	{ V4L2_DV_BT_CEA_720X576P50, 0x0b, 0x00 },
+	{ V4L2_DV_BT_CEA_1280X720P50, 0x19, 0x01 },
+	{ V4L2_DV_BT_CEA_1280X720P60, 0x19, 0x00 },
+	{ V4L2_DV_BT_CEA_1920X1080P24, 0x1e, 0x04 },
+	{ V4L2_DV_BT_CEA_1920X1080P25, 0x1e, 0x03 },
+	{ V4L2_DV_BT_CEA_1920X1080P30, 0x1e, 0x02 },
+	{ V4L2_DV_BT_CEA_1920X1080P50, 0x1e, 0x01 },
+	{ V4L2_DV_BT_CEA_1920X1080P60, 0x1e, 0x00 },
+	/* TODO add 1920x1080P60_RB (CVT timing) */
+	{ },
+};
+
+/* sorted by number of lines */
+static const struct adv7604_video_standards adv7604_prim_mode_gr[] = {
+	{ V4L2_DV_BT_DMT_640X480P60, 0x08, 0x00 },
+	{ V4L2_DV_BT_DMT_640X480P72, 0x09, 0x00 },
+	{ V4L2_DV_BT_DMT_640X480P75, 0x0a, 0x00 },
+	{ V4L2_DV_BT_DMT_640X480P85, 0x0b, 0x00 },
+	{ V4L2_DV_BT_DMT_800X600P56, 0x00, 0x00 },
+	{ V4L2_DV_BT_DMT_800X600P60, 0x01, 0x00 },
+	{ V4L2_DV_BT_DMT_800X600P72, 0x02, 0x00 },
+	{ V4L2_DV_BT_DMT_800X600P75, 0x03, 0x00 },
+	{ V4L2_DV_BT_DMT_800X600P85, 0x04, 0x00 },
+	{ V4L2_DV_BT_DMT_1024X768P60, 0x0c, 0x00 },
+	{ V4L2_DV_BT_DMT_1024X768P70, 0x0d, 0x00 },
+	{ V4L2_DV_BT_DMT_1024X768P75, 0x0e, 0x00 },
+	{ V4L2_DV_BT_DMT_1024X768P85, 0x0f, 0x00 },
+	{ V4L2_DV_BT_DMT_1280X1024P60, 0x05, 0x00 },
+	{ V4L2_DV_BT_DMT_1280X1024P75, 0x06, 0x00 },
+	{ V4L2_DV_BT_DMT_1360X768P60, 0x12, 0x00 },
+	{ V4L2_DV_BT_DMT_1366X768P60, 0x13, 0x00 },
+	{ V4L2_DV_BT_DMT_1400X1050P60, 0x14, 0x00 },
+	{ V4L2_DV_BT_DMT_1400X1050P75, 0x15, 0x00 },
+	{ V4L2_DV_BT_DMT_1600X1200P60, 0x16, 0x00 }, /* TODO not tested */
+	/* TODO add 1600X1200P60_RB (not a DMT timing) */
+	{ V4L2_DV_BT_DMT_1680X1050P60, 0x18, 0x00 },
+	{ V4L2_DV_BT_DMT_1920X1200P60_RB, 0x19, 0x00 }, /* TODO not tested */
+	{ },
+};
+
+/* sorted by number of lines */
+static const struct adv7604_video_standards adv7604_prim_mode_hdmi_comp[] = {
+	{ V4L2_DV_BT_CEA_720X480P59_94, 0x0a, 0x00 },
+	{ V4L2_DV_BT_CEA_720X576P50, 0x0b, 0x00 },
+	{ V4L2_DV_BT_CEA_1280X720P50, 0x13, 0x01 },
+	{ V4L2_DV_BT_CEA_1280X720P60, 0x13, 0x00 },
+	{ V4L2_DV_BT_CEA_1920X1080P24, 0x1e, 0x04 },
+	{ V4L2_DV_BT_CEA_1920X1080P25, 0x1e, 0x03 },
+	{ V4L2_DV_BT_CEA_1920X1080P30, 0x1e, 0x02 },
+	{ V4L2_DV_BT_CEA_1920X1080P50, 0x1e, 0x01 },
+	{ V4L2_DV_BT_CEA_1920X1080P60, 0x1e, 0x00 },
+	{ },
+};
+
+/* sorted by number of lines */
+static const struct adv7604_video_standards adv7604_prim_mode_hdmi_gr[] = {
+	{ V4L2_DV_BT_DMT_640X480P60, 0x08, 0x00 },
+	{ V4L2_DV_BT_DMT_640X480P72, 0x09, 0x00 },
+	{ V4L2_DV_BT_DMT_640X480P75, 0x0a, 0x00 },
+	{ V4L2_DV_BT_DMT_640X480P85, 0x0b, 0x00 },
+	{ V4L2_DV_BT_DMT_800X600P56, 0x00, 0x00 },
+	{ V4L2_DV_BT_DMT_800X600P60, 0x01, 0x00 },
+	{ V4L2_DV_BT_DMT_800X600P72, 0x02, 0x00 },
+	{ V4L2_DV_BT_DMT_800X600P75, 0x03, 0x00 },
+	{ V4L2_DV_BT_DMT_800X600P85, 0x04, 0x00 },
+	{ V4L2_DV_BT_DMT_1024X768P60, 0x0c, 0x00 },
+	{ V4L2_DV_BT_DMT_1024X768P70, 0x0d, 0x00 },
+	{ V4L2_DV_BT_DMT_1024X768P75, 0x0e, 0x00 },
+	{ V4L2_DV_BT_DMT_1024X768P85, 0x0f, 0x00 },
+	{ V4L2_DV_BT_DMT_1280X1024P60, 0x05, 0x00 },
+	{ V4L2_DV_BT_DMT_1280X1024P75, 0x06, 0x00 },
+	{ },
+};
+
 /* ----------------------------------------------------------------------- */
 
 static inline struct adv7604_state *to_state(struct v4l2_subdev *sd)
@@ -671,64 +754,144 @@ static int adv7604_s_detect_tx_5v_ctrl(struct v4l2_subdev *sd)
 				((io_read(sd, 0x6f) & 0x10) >> 4));
 }
 
-static void configure_free_run(struct v4l2_subdev *sd, const struct v4l2_bt_timings *timings)
+static int find_and_set_predefined_video_timings(struct v4l2_subdev *sd,
+		u8 prim_mode,
+		const struct adv7604_video_standards *predef_vid_timings,
+		const struct v4l2_dv_timings *timings)
+{
+	struct adv7604_state *state = to_state(sd);
+	int i;
+
+	for (i = 0; predef_vid_timings[i].timings.bt.width; i++) {
+		if (!v4l_match_dv_timings(timings, &predef_vid_timings[i].timings,
+					DIGITAL_INPUT ? 250000 : 1000000))
+			continue;
+		io_write(sd, 0x00, predef_vid_timings[i].vid_std); /* video std */
+		io_write(sd, 0x01, (predef_vid_timings[i].v_freq << 4) +
+				prim_mode); /* v_freq and prim mode */
+		return 0;
+	}
+
+	return -1;
+}
+
+static int configure_predefined_video_timings(struct v4l2_subdev *sd,
+		struct v4l2_dv_timings *timings)
 {
+	struct adv7604_state *state = to_state(sd);
+	int err;
+
+	v4l2_dbg(1, debug, sd, "%s", __func__);
+
+	/* reset to default values */
+	io_write(sd, 0x16, 0x43);
+	io_write(sd, 0x17, 0x5a);
+	/* disable embedded syncs for auto graphics mode */
+	cp_write_and_or(sd, 0x81, 0xef, 0x00);
+	cp_write(sd, 0x8f, 0x00);
+	cp_write(sd, 0x90, 0x00);
+	cp_write(sd, 0xa2, 0x00);
+	cp_write(sd, 0xa3, 0x00);
+	cp_write(sd, 0xa4, 0x00);
+	cp_write(sd, 0xa5, 0x00);
+	cp_write(sd, 0xa6, 0x00);
+	cp_write(sd, 0xa7, 0x00);
+	cp_write(sd, 0xab, 0x00);
+	cp_write(sd, 0xac, 0x00);
+
+	switch (state->mode) {
+	case ADV7604_MODE_COMP:
+	case ADV7604_MODE_GR:
+		err = find_and_set_predefined_video_timings(sd,
+				0x01, adv7604_prim_mode_comp, timings);
+		if (err)
+			err = find_and_set_predefined_video_timings(sd,
+					0x02, adv7604_prim_mode_gr, timings);
+		break;
+	case ADV7604_MODE_HDMI:
+		err = find_and_set_predefined_video_timings(sd,
+				0x05, adv7604_prim_mode_hdmi_comp, timings);
+		if (err)
+			err = find_and_set_predefined_video_timings(sd,
+					0x06, adv7604_prim_mode_hdmi_gr, timings);
+		break;
+	default:
+		v4l2_dbg(2, debug, sd, "%s: Unknown mode %d\n",
+				__func__, state->mode);
+		err = -1;
+		break;
+	}
+
+
+	return err;
+}
+
+static void configure_custom_video_timings(struct v4l2_subdev *sd,
+		const struct v4l2_bt_timings *bt)
+{
+	struct adv7604_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	u32 width = htotal(timings);
-	u32 height = vtotal(timings);
-	u16 ch1_fr_ll = (((u32)timings->pixelclock / 100) > 0) ?
-		((width * (ADV7604_fsc / 100)) / ((u32)timings->pixelclock / 100)) : 0;
+	u32 width = htotal(bt);
+	u32 height = vtotal(bt);
+	u16 cp_start_sav = bt->hsync + bt->hbackporch - 4;
+	u16 cp_start_eav = width - bt->hfrontporch;
+	u16 cp_start_vbi = height - bt->vfrontporch;
+	u16 cp_end_vbi = bt->vsync + bt->vbackporch;
+	u16 ch1_fr_ll = (((u32)bt->pixelclock / 100) > 0) ?
+		((width * (ADV7604_fsc / 100)) / ((u32)bt->pixelclock / 100)) : 0;
+	const u8 pll[2] = {
+		0xc0 | ((width >> 8) & 0x1f),
+		width & 0xff
+	};
 
 	v4l2_dbg(2, debug, sd, "%s\n", __func__);
 
-	cp_write(sd, 0x8f, (ch1_fr_ll >> 8) & 0x7);	/* CH1_FR_LL */
-	cp_write(sd, 0x90, ch1_fr_ll & 0xff);		/* CH1_FR_LL */
-	cp_write(sd, 0xab, (height >> 4) & 0xff); /* CP_LCOUNT_MAX */
-	cp_write(sd, 0xac, (height & 0x0f) << 4); /* CP_LCOUNT_MAX */
-	/* TODO support interlaced */
-	cp_write(sd, 0x91, 0x10);	/* INTERLACED */
-
-	/* Should only be set in auto-graphics mode [REF_02 p. 91-92] */
-	if ((io_read(sd, 0x00) == 0x07) && (io_read(sd, 0x01) == 0x02)) {
-		u16 cp_start_sav, cp_start_eav, cp_start_vbi, cp_end_vbi;
-		const u8 pll[2] = {
-			(0xc0 | ((width >> 8) & 0x1f)),
-			(width & 0xff)
-		};
+	switch (state->mode) {
+	case ADV7604_MODE_COMP:
+	case ADV7604_MODE_GR:
+		/* auto graphics */
+		io_write(sd, 0x00, 0x07); /* video std */
+		io_write(sd, 0x01, 0x02); /* prim mode */
+		/* enable embedded syncs for auto graphics mode */
+		cp_write_and_or(sd, 0x81, 0xef, 0x10);
 
+		/* Should only be set in auto-graphics mode [REF_02, p. 91-92] */
 		/* setup PLL_DIV_MAN_EN and PLL_DIV_RATIO */
 		/* IO-map reg. 0x16 and 0x17 should be written in sequence */
 		if (adv_smbus_write_i2c_block_data(client, 0x16, 2, pll)) {
 			v4l2_err(sd, "writing to reg 0x16 and 0x17 failed\n");
-			return;
+			break;
 		}
 
 		/* active video - horizontal timing */
-		cp_start_sav = timings->hsync + timings->hbackporch - 4;
-		cp_start_eav = width - timings->hfrontporch;
 		cp_write(sd, 0xa2, (cp_start_sav >> 4) & 0xff);
-		cp_write(sd, 0xa3, ((cp_start_sav & 0x0f) << 4) | ((cp_start_eav >> 8) & 0x0f));
+		cp_write(sd, 0xa3, ((cp_start_sav & 0x0f) << 4) |
+					((cp_start_eav >> 8) & 0x0f));
 		cp_write(sd, 0xa4, cp_start_eav & 0xff);
 
 		/* active video - vertical timing */
-		cp_start_vbi = height - timings->vfrontporch;
-		cp_end_vbi = timings->vsync + timings->vbackporch;
 		cp_write(sd, 0xa5, (cp_start_vbi >> 4) & 0xff);
-		cp_write(sd, 0xa6, ((cp_start_vbi & 0xf) << 4) | ((cp_end_vbi >> 8) & 0xf));
+		cp_write(sd, 0xa6, ((cp_start_vbi & 0xf) << 4) |
+					((cp_end_vbi >> 8) & 0xf));
 		cp_write(sd, 0xa7, cp_end_vbi & 0xff);
-	} else {
-		/* reset to default values */
-		io_write(sd, 0x16, 0x43);
-		io_write(sd, 0x17, 0x5a);
-		cp_write(sd, 0xa2, 0x00);
-		cp_write(sd, 0xa3, 0x00);
-		cp_write(sd, 0xa4, 0x00);
-		cp_write(sd, 0xa5, 0x00);
-		cp_write(sd, 0xa6, 0x00);
-		cp_write(sd, 0xa7, 0x00);
+		break;
+	case ADV7604_MODE_HDMI:
+		/* set default prim_mode/vid_std for HDMI
+		   accoring to [REF_03, c. 4.2] */
+		io_write(sd, 0x00, 0x02); /* video std */
+		io_write(sd, 0x01, 0x06); /* prim mode */
+		break;
+	default:
+		v4l2_dbg(2, debug, sd, "%s: Unknown mode %d\n",
+				__func__, state->mode);
+		break;
 	}
-}
 
+	cp_write(sd, 0x8f, (ch1_fr_ll >> 8) & 0x7);
+	cp_write(sd, 0x90, ch1_fr_ll & 0xff);
+	cp_write(sd, 0xab, (height >> 4) & 0xff);
+	cp_write(sd, 0xac, (height & 0x0f) << 4);
+}
 
 static void set_rgb_quantization_range(struct v4l2_subdev *sd)
 {
@@ -964,8 +1127,10 @@ static int stdi2dv_timings(struct v4l2_subdev *sd,
 			state->aspect_ratio, timings))
 		return 0;
 
-	v4l2_dbg(2, debug, sd, "%s: No format candidate found for lcf=%d, bl = %d\n",
-			__func__, stdi->lcf, stdi->bl);
+	v4l2_dbg(2, debug, sd,
+		"%s: No format candidate found for lcvs = %d, lcf=%d, bl = %d, %chsync, %cvsync\n",
+		__func__, stdi->lcvs, stdi->lcf, stdi->bl,
+		stdi->hs_pol, stdi->vs_pol);
 	return -1;
 }
 
@@ -1163,6 +1328,7 @@ static int adv7604_s_dv_timings(struct v4l2_subdev *sd,
 {
 	struct adv7604_state *state = to_state(sd);
 	struct v4l2_bt_timings *bt;
+	int err;
 
 	if (!timings)
 		return -EINVAL;
@@ -1175,12 +1341,20 @@ static int adv7604_s_dv_timings(struct v4l2_subdev *sd,
 				__func__, (u32)bt->pixelclock);
 		return -ERANGE;
 	}
+
 	adv7604_fill_optional_dv_timings_fields(sd, timings);
 
 	state->timings = *timings;
 
-	/* freerun */
-	configure_free_run(sd, bt);
+	cp_write(sd, 0x91, bt->interlaced ? 0x50 : 0x10);
+
+	/* Use prim_mode and vid_std when available */
+	err = configure_predefined_video_timings(sd, timings);
+	if (err) {
+		/* custom settings when the video format
+		 does not have prim_mode/vid_std */
+		configure_custom_video_timings(sd, bt);
+	}
 
 	set_rgb_quantization_range(sd);
 
@@ -1238,12 +1412,6 @@ static void select_input(struct v4l2_subdev *sd)
 	switch (state->mode) {
 	case ADV7604_MODE_COMP:
 	case ADV7604_MODE_GR:
-		/* set mode and select free run resolution */
-		io_write(sd, 0x00, 0x07); /* video std */
-		io_write(sd, 0x01, 0x02); /* prim mode */
-		/* enable embedded syncs for auto graphics mode */
-		cp_write_and_or(sd, 0x81, 0xef, 0x10);
-
 		/* reset ADI recommended settings for HDMI: */
 		/* "ADV7604 Register Settings Recommendations (rev. 2.5, June 2010)" p. 4. */
 		hdmi_write(sd, 0x0d, 0x04); /* HDMI filter optimization */
@@ -1272,12 +1440,6 @@ static void select_input(struct v4l2_subdev *sd)
 		break;
 
 	case ADV7604_MODE_HDMI:
-		/* set mode and select free run resolution */
-		io_write(sd, 0x00, 0x02); /* video std */
-		io_write(sd, 0x01, 0x06); /* prim mode */
-		/* disable embedded syncs for auto graphics mode */
-		cp_write_and_or(sd, 0x81, 0xef, 0x00);
-
 		/* set ADI recommended settings for HDMI: */
 		/* "ADV7604 Register Settings Recommendations (rev. 2.5, June 2010)" p. 4. */
 		hdmi_write(sd, 0x0d, 0x84); /* HDMI filter optimization */
@@ -1534,8 +1696,9 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 	v4l2_info(sd, "CP locked: %s\n", no_lock_cp(sd) ? "false" : "true");
 	v4l2_info(sd, "CP free run: %s\n",
 			(!!(cp_read(sd, 0xff) & 0x10) ? "on" : "off"));
-	v4l2_info(sd, "Prim-mode = 0x%x, video std = 0x%x\n",
-			io_read(sd, 0x01) & 0x0f, io_read(sd, 0x00) & 0x3f);
+	v4l2_info(sd, "Prim-mode = 0x%x, video std = 0x%x, v_freq = 0x%x\n",
+			io_read(sd, 0x01) & 0x0f, io_read(sd, 0x00) & 0x3f,
+			(io_read(sd, 0x01) & 0x70) >> 4);
 
 	v4l2_info(sd, "-----Video Timings-----\n");
 	if (read_stdi(sd, &stdi))
-- 
1.7.10.4

