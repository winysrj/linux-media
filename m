Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4429 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3HSOor (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 10:44:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, matrandg@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 12/20] v4l2-dv-timings: rename v4l_match_dv_timings to v4l2_match_dv_timings
Date: Mon, 19 Aug 2013 16:44:21 +0200
Message-Id: <1376923469-30694-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
References: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

It's the only function in v4l2-dv-timings.c with the v4l prefix instead
of v4l2. Make it consistent with the other functions.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c               |  4 ++--
 drivers/media/platform/s5p-tv/hdmi_drv.c  |  2 +-
 drivers/media/usb/hdpvr/hdpvr-video.c     |  2 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c | 12 ++++++------
 include/media/v4l2-dv-timings.h           |  8 ++++----
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index ba8602c..a1a9d1e 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -763,7 +763,7 @@ static int find_and_set_predefined_video_timings(struct v4l2_subdev *sd,
 	int i;
 
 	for (i = 0; predef_vid_timings[i].timings.bt.width; i++) {
-		if (!v4l_match_dv_timings(timings, &predef_vid_timings[i].timings,
+		if (!v4l2_match_dv_timings(timings, &predef_vid_timings[i].timings,
 					DIGITAL_INPUT ? 250000 : 1000000))
 			continue;
 		io_write(sd, 0x00, predef_vid_timings[i].vid_std); /* video std */
@@ -1183,7 +1183,7 @@ static void adv7604_fill_optional_dv_timings_fields(struct v4l2_subdev *sd,
 	int i;
 
 	for (i = 0; adv7604_timings[i].bt.width; i++) {
-		if (v4l_match_dv_timings(timings, &adv7604_timings[i],
+		if (v4l2_match_dv_timings(timings, &adv7604_timings[i],
 					DIGITAL_INPUT ? 250000 : 1000000)) {
 			*timings = adv7604_timings[i];
 			break;
diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 1b34c36..4ad9374 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -625,7 +625,7 @@ static int hdmi_s_dv_timings(struct v4l2_subdev *sd,
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(hdmi_timings); i++)
-		if (v4l_match_dv_timings(&hdmi_timings[i].dv_timings,
+		if (v4l2_match_dv_timings(&hdmi_timings[i].dv_timings,
 					timings, 0))
 			break;
 	if (i == ARRAY_SIZE(hdmi_timings)) {
diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index e68245a..0500c417 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -642,7 +642,7 @@ static int vidioc_s_dv_timings(struct file *file, void *_fh,
 	if (dev->status != STATUS_IDLE)
 		return -EBUSY;
 	for (i = 0; i < ARRAY_SIZE(hdpvr_dv_timings); i++)
-		if (v4l_match_dv_timings(timings, hdpvr_dv_timings + i, 0))
+		if (v4l2_match_dv_timings(timings, hdpvr_dv_timings + i, 0))
 			break;
 	if (i == ARRAY_SIZE(hdpvr_dv_timings))
 		return -EINVAL;
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 917e58c..1a9d393 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -181,7 +181,7 @@ bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
 
 	for (i = 0; i < ARRAY_SIZE(timings); i++) {
 		if (v4l2_dv_valid_timings(timings + i, cap) &&
-		    v4l_match_dv_timings(t, timings + i, pclock_delta)) {
+		    v4l2_match_dv_timings(t, timings + i, pclock_delta)) {
 			*t = timings[i];
 			return true;
 		}
@@ -191,16 +191,16 @@ bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
 EXPORT_SYMBOL_GPL(v4l2_find_dv_timings_cap);
 
 /**
- * v4l_match_dv_timings - check if two timings match
+ * v4l2_match_dv_timings - check if two timings match
  * @t1 - compare this v4l2_dv_timings struct...
  * @t2 - with this struct.
  * @pclock_delta - the allowed pixelclock deviation.
  *
  * Compare t1 with t2 with a given margin of error for the pixelclock.
  */
-bool v4l_match_dv_timings(const struct v4l2_dv_timings *t1,
-			  const struct v4l2_dv_timings *t2,
-			  unsigned pclock_delta)
+bool v4l2_match_dv_timings(const struct v4l2_dv_timings *t1,
+			   const struct v4l2_dv_timings *t2,
+			   unsigned pclock_delta)
 {
 	if (t1->type != t2->type || t1->type != V4L2_DV_BT_656_1120)
 		return false;
@@ -221,7 +221,7 @@ bool v4l_match_dv_timings(const struct v4l2_dv_timings *t1,
 		return true;
 	return false;
 }
-EXPORT_SYMBOL_GPL(v4l_match_dv_timings);
+EXPORT_SYMBOL_GPL(v4l2_match_dv_timings);
 
 void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
 			   const struct v4l2_dv_timings *t, bool detailed)
diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index 696e5c2..43f6b67 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -64,7 +64,7 @@ bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
 			      const struct v4l2_dv_timings_cap *cap,
 			      unsigned pclock_delta);
 
-/** v4l_match_dv_timings() - do two timings match?
+/** v4l2_match_dv_timings() - do two timings match?
   * @measured:	  the measured timings data.
   * @standard:	  the timings according to the standard.
   * @pclock_delta: maximum delta in Hz between standard->pixelclock and
@@ -72,9 +72,9 @@ bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
   *
   * Returns true if the two timings match, returns false otherwise.
   */
-bool v4l_match_dv_timings(const struct v4l2_dv_timings *measured,
-			  const struct v4l2_dv_timings *standard,
-			  unsigned pclock_delta);
+bool v4l2_match_dv_timings(const struct v4l2_dv_timings *measured,
+			   const struct v4l2_dv_timings *standard,
+			   unsigned pclock_delta);
 
 /** v4l2_print_dv_timings() - log the contents of a dv_timings struct
   * @dev_prefix:device prefix for each log line.
-- 
1.8.3.2

