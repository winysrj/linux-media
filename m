Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:36299 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932553AbbKMLqe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2015 06:46:34 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: "Prashant Laddha (prladdha)" <prladdha@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-dv-timings: add new arg to v4l2_match_dv_timings
Message-ID: <5645CD92.5080508@xs4all.nl>
Date: Fri, 13 Nov 2015 12:46:26 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the new match_reduced_fps argument to v4l2_match_dv_timings().
Depending on the situation you may or may not desire to match the
reduced_fps flag. Typically only HDMI transmitters will need to
check for this flag.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---

Needed to make Prashant's "[RFC v2 0/4] vivid: reduced fps support"
patch series work for HDMI output.

https://www.mail-archive.com/linux-media@vger.kernel.org/msg92552.html

 drivers/media/i2c/adv7604.c                  | 6 +++---
 drivers/media/i2c/adv7842.c                  | 6 +++---
 drivers/media/i2c/tc358743.c                 | 4 ++--
 drivers/media/pci/cobalt/cobalt-v4l2.c       | 2 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c     | 2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c | 2 +-
 drivers/media/platform/vivid/vivid-vid-out.c | 2 +-
 drivers/media/usb/hdpvr/hdpvr-video.c        | 2 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c    | 9 +++++++--
 include/media/v4l2-dv-timings.h              | 4 +++-
 10 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 5631ec0..d642303 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -905,7 +905,7 @@ static int find_and_set_predefined_video_timings(struct v4l2_subdev *sd,
 
 	for (i = 0; predef_vid_timings[i].timings.bt.width; i++) {
 		if (!v4l2_match_dv_timings(timings, &predef_vid_timings[i].timings,
-					is_digital_input(sd) ? 250000 : 1000000))
+				is_digital_input(sd) ? 250000 : 1000000, false))
 			continue;
 		io_write(sd, 0x00, predef_vid_timings[i].vid_std); /* video std */
 		io_write(sd, 0x01, (predef_vid_timings[i].v_freq << 4) +
@@ -1479,7 +1479,7 @@ static void adv76xx_fill_optional_dv_timings_fields(struct v4l2_subdev *sd,
 
 	for (i = 0; adv76xx_timings[i].bt.width; i++) {
 		if (v4l2_match_dv_timings(timings, &adv76xx_timings[i],
-					is_digital_input(sd) ? 250000 : 1000000)) {
+				is_digital_input(sd) ? 250000 : 1000000, false)) {
 			*timings = adv76xx_timings[i];
 			break;
 		}
@@ -1644,7 +1644,7 @@ static int adv76xx_s_dv_timings(struct v4l2_subdev *sd,
 	if (!timings)
 		return -EINVAL;
 
-	if (v4l2_match_dv_timings(&state->timings, timings, 0)) {
+	if (v4l2_match_dv_timings(&state->timings, timings, 0, false)) {
 		v4l2_dbg(1, debug, sd, "%s: no change\n", __func__);
 		return 0;
 	}
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index b7269b8..56726dc 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -155,7 +155,7 @@ static bool adv7842_check_dv_timings(const struct v4l2_dv_timings *t, void *hdl)
 	int i;
 
 	for (i = 0; adv7842_timings_exceptions[i].bt.width; i++)
-		if (v4l2_match_dv_timings(t, adv7842_timings_exceptions + i, 0))
+		if (v4l2_match_dv_timings(t, adv7842_timings_exceptions + i, 0, false))
 			return false;
 	return true;
 }
@@ -1008,7 +1008,7 @@ static int find_and_set_predefined_video_timings(struct v4l2_subdev *sd,
 
 	for (i = 0; predef_vid_timings[i].timings.bt.width; i++) {
 		if (!v4l2_match_dv_timings(timings, &predef_vid_timings[i].timings,
-					  is_digital_input(sd) ? 250000 : 1000000))
+				  is_digital_input(sd) ? 250000 : 1000000, false))
 			continue;
 		/* video std */
 		io_write(sd, 0x00, predef_vid_timings[i].vid_std);
@@ -1659,7 +1659,7 @@ static int adv7842_s_dv_timings(struct v4l2_subdev *sd,
 	if (state->mode == ADV7842_MODE_SDP)
 		return -ENODATA;
 
-	if (v4l2_match_dv_timings(&state->timings, timings, 0)) {
+	if (v4l2_match_dv_timings(&state->timings, timings, 0, false)) {
 		v4l2_dbg(1, debug, sd, "%s: no change\n", __func__);
 		return 0;
 	}
diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 9ef5baa..fdf1333 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -862,7 +862,7 @@ static void tc358743_format_change(struct v4l2_subdev *sd)
 		v4l2_dbg(1, debug, sd, "%s: Format changed. No signal\n",
 				__func__);
 	} else {
-		if (!v4l2_match_dv_timings(&state->timings, &timings, 0))
+		if (!v4l2_match_dv_timings(&state->timings, &timings, 0, false))
 			enable_stream(sd, false);
 
 		v4l2_print_dv_timings(sd->name,
@@ -1366,7 +1366,7 @@ static int tc358743_s_dv_timings(struct v4l2_subdev *sd,
 		v4l2_print_dv_timings(sd->name, "tc358743_s_dv_timings: ",
 				timings, false);
 
-	if (v4l2_match_dv_timings(&state->timings, timings, 0)) {
+	if (v4l2_match_dv_timings(&state->timings, timings, 0, false)) {
 		v4l2_dbg(1, debug, sd, "%s: no change\n", __func__);
 		return 0;
 	}
diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index ff46e42..6018a0b 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -649,7 +649,7 @@ static int cobalt_s_dv_timings(struct file *file, void *priv_fh,
 		return 0;
 	}
 
-	if (v4l2_match_dv_timings(timings, &s->timings, 0))
+	if (v4l2_match_dv_timings(timings, &s->timings, 0, false))
 		return 0;
 
 	if (vb2_is_busy(&s->q))
diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 7994075..3547d33 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -627,7 +627,7 @@ static int hdmi_s_dv_timings(struct v4l2_subdev *sd,
 
 	for (i = 0; i < ARRAY_SIZE(hdmi_timings); i++)
 		if (v4l2_match_dv_timings(&hdmi_timings[i].dv_timings,
-					timings, 0))
+					timings, 0, false))
 			break;
 	if (i == ARRAY_SIZE(hdmi_timings)) {
 		dev_err(dev, "timings not supported\n");
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 45a2ed8..9cc07c6 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -1670,7 +1670,7 @@ int vivid_vid_cap_s_dv_timings(struct file *file, void *_fh,
 	    !valid_cvt_gtf_timings(timings))
 		return -EINVAL;
 
-	if (v4l2_match_dv_timings(timings, &dev->dv_timings_cap, 0))
+	if (v4l2_match_dv_timings(timings, &dev->dv_timings_cap, 0, false))
 		return 0;
 	if (vb2_is_busy(&dev->vb_vid_cap_q))
 		return -EBUSY;
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index db645ab..1f3b081 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -1156,7 +1156,7 @@ int vivid_vid_out_s_dv_timings(struct file *file, void *_fh,
 				0, NULL, NULL) &&
 	    !valid_cvt_gtf_timings(timings))
 		return -EINVAL;
-	if (v4l2_match_dv_timings(timings, &dev->dv_timings_out, 0))
+	if (v4l2_match_dv_timings(timings, &dev->dv_timings_out, 0, true))
 		return 0;
 	if (vb2_is_busy(&dev->vb_vid_out_q))
 		return -EBUSY;
diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index d8d8c0f..7dee22d 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -642,7 +642,7 @@ static int vidioc_s_dv_timings(struct file *file, void *_fh,
 	if (dev->status != STATUS_IDLE)
 		return -EBUSY;
 	for (i = 0; i < ARRAY_SIZE(hdpvr_dv_timings); i++)
-		if (v4l2_match_dv_timings(timings, hdpvr_dv_timings + i, 0))
+		if (v4l2_match_dv_timings(timings, hdpvr_dv_timings + i, 0, false))
 			break;
 	if (i == ARRAY_SIZE(hdpvr_dv_timings))
 		return -EINVAL;
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index d8e62f6..c157f99 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -209,7 +209,7 @@ bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
 		if (v4l2_valid_dv_timings(v4l2_dv_timings_presets + i, cap,
 					  fnc, fnc_handle) &&
 		    v4l2_match_dv_timings(t, v4l2_dv_timings_presets + i,
-					  pclock_delta)) {
+					  pclock_delta, false)) {
 			u32 flags = t->bt.flags & V4L2_DV_FL_REDUCED_FPS;
 
 			*t = v4l2_dv_timings_presets[i];
@@ -228,12 +228,14 @@ EXPORT_SYMBOL_GPL(v4l2_find_dv_timings_cap);
  * @t1 - compare this v4l2_dv_timings struct...
  * @t2 - with this struct.
  * @pclock_delta - the allowed pixelclock deviation.
+ * @match_reduced_fps - if true, then fail if V4L2_DV_FL_REDUCED_FPS does not
+ * match.
  *
  * Compare t1 with t2 with a given margin of error for the pixelclock.
  */
 bool v4l2_match_dv_timings(const struct v4l2_dv_timings *t1,
 			   const struct v4l2_dv_timings *t2,
-			   unsigned pclock_delta)
+			   unsigned pclock_delta, bool match_reduced_fps)
 {
 	if (t1->type != t2->type || t1->type != V4L2_DV_BT_656_1120)
 		return false;
@@ -247,6 +249,9 @@ bool v4l2_match_dv_timings(const struct v4l2_dv_timings *t1,
 	    t1->bt.vfrontporch == t2->bt.vfrontporch &&
 	    t1->bt.vsync == t2->bt.vsync &&
 	    t1->bt.vbackporch == t2->bt.vbackporch &&
+	    (!match_reduced_fps ||
+	     (t1->bt.flags & V4L2_DV_FL_REDUCED_FPS) ==
+		(t2->bt.flags & V4L2_DV_FL_REDUCED_FPS)) &&
 	    (!t1->bt.interlaced ||
 		(t1->bt.il_vfrontporch == t2->bt.il_vfrontporch &&
 		 t1->bt.il_vsync == t2->bt.il_vsync &&
diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index 69829a5..4392040 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -107,12 +107,14 @@ bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
  * @standard:	  the timings according to the standard.
  * @pclock_delta: maximum delta in Hz between standard->pixelclock and
  * 		the measured timings.
+ * @match_reduced_fps - if true, then fail if V4L2_DV_FL_REDUCED_FPS does not
+ * match.
  *
  * Returns true if the two timings match, returns false otherwise.
  */
 bool v4l2_match_dv_timings(const struct v4l2_dv_timings *measured,
 			   const struct v4l2_dv_timings *standard,
-			   unsigned pclock_delta);
+			   unsigned pclock_delta, bool match_reduced_fps);
 
 /**
  * v4l2_print_dv_timings() - log the contents of a dv_timings struct
-- 
2.6.2

